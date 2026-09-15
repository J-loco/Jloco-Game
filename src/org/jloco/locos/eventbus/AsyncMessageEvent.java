package org.jloco.locos.eventbus;

import org.jloco.locos.api.AbstractDofusMessage;
import org.jloco.locos.api.AbstractEventMessageDispatcher;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class AsyncMessageEvent<T> extends AbstractEventMessageDispatcher<T> {
    
    private final Executor executor;
    
    public AsyncMessageEvent(Executor executor) {
        this.executor = executor;
    }
    
    public AsyncMessageEvent() {
        this(Executors.newCachedThreadPool());
    }
    
    @Override
    public void publish(T message) {
        executor.execute(() -> doPublish(message));
    }
}
