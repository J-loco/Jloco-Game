package org.jloco.locos.exchange;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import org.apache.mina.core.future.ConnectFuture;
import org.apache.mina.core.service.IoConnector;
import org.apache.mina.core.session.IoSession;
import org.apache.mina.filter.codec.ProtocolCodecFilter;
import org.apache.mina.filter.codec.textline.LineDelimiter;
import org.apache.mina.filter.codec.textline.TextLineCodecFactory;
import org.apache.mina.transport.socket.nio.NioSocketConnector;
import org.slf4j.LoggerFactory;
import org.jloco.locos.kernel.Config;

import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;

/**
 * Connection to the login server's exchange port. Protocol v2 (see JLoco-Login ExchangeProtocol): UTF-8
 * lines terminated by "\n", and a challenge-response handshake so the server key never travels.
 */
public class ExchangeClient {

    /** Exchange protocol spoken by this game server; the login server announces its own in "SK?". */
    public static final int PROTOCOL_VERSION = 2;
    private static final int MAX_LINE_BYTES = 16 * 1024;

    public static Logger logger = (Logger) LoggerFactory.getLogger(ExchangeClient.class);

    private IoSession ioSession;
    private ConnectFuture connectFuture;
    private IoConnector ioConnector = new NioSocketConnector();

    public ExchangeClient() {
        configure(this.ioConnector);
        Config.exchangeClient = this;
        ExchangeClient.logger.setLevel(Level.INFO);
    }

    public void setIoSession(IoSession ioSession) {
        this.ioSession = ioSession;
    }

    public IoSession getIoSession() {
        return ioSession;
    }

    public ConnectFuture getConnectFuture() {
        return connectFuture;
    }

    public void initialize() {
        try {
            this.connectFuture = this.ioConnector.connect(new InetSocketAddress(Config.exchangeIp, Config.exchangePort));
        } catch (Exception e) {
            ExchangeClient.logger.error("The game server don't found the login server. Exception : " + e.getMessage());
            try { Thread.sleep(2000); } catch(Exception ignored) {}
            return;
        }

        try { Thread.sleep(3000); } catch(Exception ignored) {}

        if (!ioConnector.isActive()) {
            if (!Config.isRunning) return;

            ExchangeClient.logger.error("Try to connect to the login server..");
            restart();
            return;
        }
        ExchangeClient.logger.info("The exchange client was connected on address : " + Config.exchangeIp + ":" + Config.exchangePort);
    }

    public void restart() {
        if (!Config.isRunning) return;

        ExchangeClient.logger.error("The login server was not found..");

        this.stop();
        this.connectFuture = null;
        this.ioConnector = new NioSocketConnector();
        configure(this.ioConnector);
        this.initialize();
    }

    public void stop() {
        if(this.ioSession != null)
            this.ioSession.close(true);
        if (this.connectFuture != null)
            this.connectFuture.cancel();

        this.connectFuture = null;
        this.ioConnector.dispose();
        ExchangeClient.logger.info("The exchange client was stopped.");
    }

    private static void configure(IoConnector connector) {
        TextLineCodecFactory lines = new TextLineCodecFactory(StandardCharsets.UTF_8, LineDelimiter.UNIX, LineDelimiter.UNIX);
        lines.setDecoderMaxLineLength(MAX_LINE_BYTES);
        lines.setEncoderMaxLineLength(MAX_LINE_BYTES);
        connector.getFilterChain().addLast("lines", new ProtocolCodecFilter(lines));
        connector.setHandler(new ExchangeHandler());
    }

    /** Sends one message; line breaks inside it would split it, so they are removed. */
    public void send(String packet) {
        if(this.ioSession != null && !this.ioSession.isClosing() && this.ioSession.isConnected())
            this.getIoSession().write(packet.replace("\n", "").replace("\r", ""));
    }
}
