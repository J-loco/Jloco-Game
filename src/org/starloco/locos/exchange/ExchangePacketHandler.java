package org.starloco.locos.exchange;

import org.starloco.locos.client.Account;
import org.starloco.locos.command.CommandPlayer;
import org.starloco.locos.database.DatabaseManager;
import org.starloco.locos.database.data.login.AccountData;
import org.starloco.locos.database.data.login.PlayerData;
import org.starloco.locos.game.GameClient;
import org.starloco.locos.game.GameServer;
import org.starloco.locos.game.world.World;
import org.starloco.locos.kernel.Config;
import org.starloco.locos.kernel.Main;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HexFormat;

class ExchangePacketHandler {

    static void parser(String packet) {
            if(packet.isEmpty()) return;
            try {
                switch (packet.charAt(0)) {
                    case 'F': //Free places
                        if (packet.charAt(1) == '?') { //Required
                            int i = GameServer.MAX_PLAYERS - World.world.getOnlinePlayers().size();
                            Config.exchangeClient.send("F" + i);
                        }
                        break;

                    case 'S': //Server
                        switch (packet.charAt(1)) {
                            case 'H': //Host
                                if (packet.charAt(2) == 'K') { //Ok
                                    ExchangeClient.logger.info("The login server has validated the connection.");
                                    GameServer.setState(1);
                                }
                                break;

                            case 'K': //Key
                                switch (packet.charAt(2)) {
                                    case '?': //Required: "SK?<protocol version>;<nonce>"
                                        String[] challenge = packet.substring(3).split(";", 2);
                                        if (challenge.length != 2 || !String.valueOf(ExchangeClient.PROTOCOL_VERSION).equals(challenge[0])) {
                                            ExchangeClient.logger.error("The login server speaks exchange protocol " + (challenge[0].isEmpty() ? "1" : challenge[0])
                                                    + ", expected " + ExchangeClient.PROTOCOL_VERSION + ": update the login server and the game server together.");
                                            Main.stop("Exchange protocol mismatch with the login server");
                                            break;
                                        }
                                        int i = 50000 - Config.gameServer.getClients().size();
                                        // The key never travels: prove we know it by signing the login server's nonce.
                                        Config.exchangeClient.send("SK" + Config.gameServerId + ";" + sign(Config.gameServerKey, challenge[1]) + ";" + i);
                                        break;

                                    case 'K': //Ok
                                        ExchangeClient.logger.info("The login server has accepted the connection.");
                                        Config.exchangeClient.send("SH" + Config.gameIp + ";" + Config.gamePort);
                                        break;

                                    case 'R': //Refused
                                        ExchangeClient.logger.info("The login server has refused the connection.");
                                        Main.stop("Connection refused by the login");
                                        break;
                                }
                                break;
                        }
                        break;

                    case 'W': //Waiting
                        switch (packet.charAt(1)) {
                            case 'A': //Add
                                int id = Integer.parseInt(packet.substring(2));
                                Account account = World.world.ensureAccountLoaded(id);

                                if (account == null) {
                                    // Account doesn't exist, TODO: Send error
                                     break;
                                }

                                if (account.getCurrentPlayer() != null)
                                    account.getGameClient().kick();
                                account.setSubscribe();
                                Config.gameServer.addWaitingAccount(account);
                                break;
                            case 'K': //Kick
                                id = Integer.parseInt(packet.substring(2));
                                DatabaseManager.get(PlayerData.class).updateLogged(id, 0);
                                DatabaseManager.get(AccountData.class).setLogged(id, 0);
                                account = World.world.ensureAccountLoaded(id);

                                if (account != null) {
                                    GameClient client;
                                    if ((client = account.getGameClient()) != null) {
                                        client.disconnect();
                                        client.kick();
                                    }
                                }
                                break;
                        }
                        break;

                    case 'D': // Data
                        if (packet.charAt(1) == 'M') { // Message
                            String[] split = packet.substring(2).split(";");
                            if (split.length > 1) {
                                String prefix = "<font color='#C35617'>[" + (new SimpleDateFormat("HH:mm").format(new Date(System.currentTimeMillis()))) + "] (" + CommandPlayer.canal + ") (" + split[1] + ") <b>" + split[0] + "</b>";
                                final String message = "Im116;" + prefix + "~" + split[2] + "</font>";

                                World.world.getOnlinePlayers().stream().filter(p -> p != null && !p.noall).forEach(p -> p.send(message.replace("%20", " ")));
                            }
                        }
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
    }

    /** hex HMAC-SHA256(key, nonce): the exchange handshake answer (StarLoco-Login ExchangeProtocol.sign). */
    static String sign(String key, String nonce) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
            return HexFormat.of().formatHex(mac.doFinal(nonce.getBytes(StandardCharsets.UTF_8)));
        } catch (GeneralSecurityException | IllegalArgumentException e) {
            throw new IllegalStateException("Cannot sign the exchange challenge (is system.server.game.key set?)", e);
        }
    }
}
