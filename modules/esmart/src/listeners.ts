export type Destructor = () => void;

export type Listener<T extends any[]> = (...args: T) => void;

/**
 * Creates function for singleton callbacks (should register only once)
 *
 * @param registerListener - Singleton listener (registers only once in time of first usage)
 *
 * @example
 *
 * const addListener = createGlobalListener((globalListener) => document.addEventListener('keypress', globalListener))
 *
 * // register new listener
 * const removeListener = addListener((event) => console.log(event))
 *
 * // remove listener
 * removeListener()
 */
export function createGlobalListener<T extends any[]>(
  registerListener: (globalListener: Listener<T>) => (listener: Listener<T>) => Destructor,
) {
  let listeners: Listener<T>[] | undefined;

  const globalListener = (...args: T) => {
    if (listeners) {
      listeners.forEach((listener) => listener(...args));
    }
  };

  return (listener: Listener<T>): Destructor => {
    if (!listeners) {
      listeners = [listener];
      registerListener(globalListener);
    } else {
      listeners.push(listener);
    }
    return () => {
      if (listeners) {
        listeners = listeners.filter((_listener) => _listener !== listener);
      }
    };
  };
}
