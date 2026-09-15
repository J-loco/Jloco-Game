package org.jloco.locos.exchange;

import org.apache.mina.core.service.IoHandlerAdapter;
import org.apache.mina.core.session.IoSession;
import org.jloco.locos.kernel.Config;

public class ExchangeHandler extends IoHandlerAdapter {

    @Override
    public void sessionCreated(IoSession arg0) {
        Config.exchangeClient.setIoSession(arg0);
    }

    @Override
    public void messageReceived(IoSession arg0, Object arg1) {
        String packet = (String) arg1;
        ExchangeClient.logger.debug(packet);
        ExchangePacketHandler.parser(packet);
    }

    @Override
    public void messageSent(IoSession arg0, Object arg1) {
        ExchangeClient.logger.debug(String.valueOf(arg1));
    }

    @Override
    public void sessionClosed(IoSession arg0) {
        Config.exchangeClient.restart();
    }

    @Override
    public void exceptionCaught(IoSession arg0, Throwable arg1) {
        arg1.printStackTrace();
    }
}
