if (Set) {
    if (Set.prototype) {
        if (!Set.prototype.map) {
            Set.prototype.map = function () {
                return [...this].map(...arguments);
            }
        }
    }
}

if (CSV) {
    if (CSV.prototype) {
        if (!CSV.prototype.map) {
            CSV.prototype.map = function (callback, thisArg = undefined) {
                if (!callback) return false;
                result = [];
                this.forEach(e => result[result.length] = callback.call(thisArg, e, result.length, this));
                return result;
            };
        }
    }
}

if (Promise) {
    if (!Promise.Running) {
        Promise.Running = function (promise) {
            return new Promise((resolve, reject) => promise.then(resolve, reject));
        };
    }

    if (Promise.prototype) {
        if (!Promise.prototype.wait) {
            Promise.prototype.wait = function (promise) {
                return this.then(
                    value => new Promise((resolve, reject) => promise.then(
                        () => resolve(value),
                        reject
                    ))
                );
            };
        }
    }

    if (!Promise.Deferred) {
        Promise.Deferred = function (executor = (() => {}), autoResolve = true, defer = true) {
            if (defer === true) {
                this.defer = new Promise((resolve, reject) => {
                    this.resolve = resolve;
                    this.reject = reject;
                });
            } else if (defer === false) {
                this.defer = new Promise((resolve, reject) => {
                    this.resolve = resolve;
                    this.reject = reject;
                    resolve();
                })
            } else if (('defer' in defer) && ('resolve' in defer) && ('reject' in defer)) {
                this.defer = defer.defer;
                this.resolve = defer.resolve;
                this.reject = defer.reject;
            } else {
                throw Error("defer is invalid (got: "+defer+", expected: Boolean or Promise.Deferred-like)");
            }

            if (autoResolve===true && executor.length>1) {
                console.warn(new Error("autoResolve left true, but executor expects resolve"));
            }

            if ('then' in executor) {
                this.promise = executor;
                // autoResolve makes no sense here
            } else {
                this.promise = new Promise((resolve, reject) => {
                    this.start = this.defer.then(value => executor(value, resolve, reject));
                    if (autoResolve) this.start.then(resolve, reject);
                });
            }

            this.run = (value) => {
                this.resolve(value);
                return this.promise;
            };
            this.runAfter = (promise) => {
                return promise.then(this.accept, this.reject);
            };
        };
        Promise.Deferred.prototype = async (value) => { // Okay, it's cheat a little
            this.resolve(value);
            return await this.promise;
        };
        Object.entries(Object.getOwnPropertyDescriptors(Promise.prototype)).forEach(([name, descriptor]) => {
                Object.defineProperty(Promise.Deferred.prototype, name, (() => {
                    switch (name) {
                        // These are returning a new Promise
                        case "then":
                        case "catch":
                        case "finally":
                        case "wait":
                            return {
                                configurable: descriptor.configurable,
                                enumerable: descriptor.enumerable,
                                writable: false,
                                value: function () {
                                    let result = new Promise.Deferred(this.run, true, this);
                                    result.promise = this.promise[name].apply(this.promise, arguments);
                                    return result;
                                }
                            }

                        default:
                            switch (typeof descriptor.value) {
                                case "function":
                                    return {
                                        configurable: descriptor.configurable,
                                        enumerable: descriptor.enumerable,
                                        writable: false,
                                        value: function () {
                                            return this.promise[name].apply(this.promise, arguments);
                                        }
                                    };

                                default:
                                    return {
                                        configurable: descriptor.configurable,
                                        enumerable: descriptor.enumerable,
                                        get: function () {
                                            return this.promise[name];
                                        },
                                        set: function (value) {
                                            return this.promise[name] = value;
                                        }
                                    }
                            }
                    }
                })());
            }
        );
    }

    if (!Promise.defer) {
        Promise.defer = function () {
            return Reflect.construct(Promise.Deferred, arguments);
        };
    }
}

if (document) {
    if (!document.ready) {
        document.ready = new Promise.Deferred;
        document.addEventListener('ready', document.ready.resolve);
    }
}

if (window) {
    if (!window.webComponentsReady) {
        window.webComponentsReady = new Promise.Deferred;
        window.addEventListener('WebComponentsReady', window.webComponentsReady.resolve);
    }

    if (!window.Observable) {
        window.Observable = function (target = {}) {
            if ('_observers' in target) throw Error("_observers should not be defined in target");
            else target._observers = {};

            return new Proxy(target, {
                get: (target, p) => {
                    if (p === 'listen' || p === 'observe') {
                        return function (property, callback) {
                            if (!(property in target._observers)) {
                                target._observers[property] = [];
                            }
                            return target._observers[property].push(callback);
                        }
                    }
                    {
                        let match = /(?:listen(?:For)?|observe)([A-Z].*)/.exec(p);
                        if (match) {
                            let property = match[1].charAt(0).toLowerCase()+match[1].slice(1);
                            if (true || property in target) {
                                return function (callback) {
                                    if (!(property in target._observers)) {
                                        target._observers[property] = [];
                                    }
                                    return target._observers[property].push(callback);
                                }
                            } else {
                                throw Error("No property named "+property);
                            }
                        }
                    }
                    return target[p];
                },
                set: (target, p, value) => {
                    if (p in target._observers) {
                        target._observers[p].forEach(observer => {
                            observer.call(target, value, p);
                        });
                    }
                    return target[p] = value;
                }
            });
        }
    }
}

function tcl(promise) {
    return promise.then(value => console.log(promise, value));
}
