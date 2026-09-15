package org.jloco.locos.game.action.type;

import org.jloco.locos.client.Player;
import org.jloco.locos.game.action.ExchangeAction;

import java.util.function.BiConsumer;

public class ScenarioActionData implements ActionDataInterface {
    private final ExchangeAction<?> source;
    private final BiConsumer<Player,Integer> onCompleted;

    public ScenarioActionData(ExchangeAction<?> source, BiConsumer<Player,Integer> onCompleted) {
        this.source = source;
        this.onCompleted = onCompleted;
    }

    /** @param result value of the scenario's END action, -1 if the client sent none */
    public void onCompletion(Player player, int result) {
        player.setExchangeAction(source);
        onCompleted.accept(player, result);
    }
}
