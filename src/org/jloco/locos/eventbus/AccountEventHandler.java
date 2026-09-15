package org.jloco.locos.eventbus;

import org.jloco.locos.annotation.Handler;
import org.jloco.locos.proto.AccountQueuePositionMessage;

public class AccountEventHandler {
    
    @Handler
    public void onQueue(AccountQueuePositionMessage message) {
        message.getClient().send(new AccountQueuePositionMessage(1, 1, 1, 1));
    }
}
