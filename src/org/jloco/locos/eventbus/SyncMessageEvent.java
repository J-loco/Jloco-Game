package org.jloco.locos.eventbus;

import org.jloco.locos.api.AbstractDofusMessage;
import org.jloco.locos.api.AbstractEventMessageDispatcher;

public class SyncMessageEvent<T> extends AbstractEventMessageDispatcher<T> {
    
    @Override
    public void publish(T message) {
        doPublish(message);
    }
}
