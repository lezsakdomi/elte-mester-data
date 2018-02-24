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
        Promise.Deferred = function (executor = (() => {
        })) {
            this.defer = new Promise((resolve, reject) => {
                this.resolve = resolve;
                this.reject = reject;
            });
            if (executor.accept) {
                if (!executor.reject) {
                    this.promise = this.defer.then(executor.accept);
                } else { // executor.reject
                    this.promise = this.defer.then(executor.accept, executor.reject);
                }
            } else {
                this.promise = this.defer.then(executor);
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
                                    let result = new Promise.Deferred(this.run);
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
}

function tcl(promise) {
    return promise.then(value => console.log(promise, value));
}