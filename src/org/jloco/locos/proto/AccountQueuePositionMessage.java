package org.jloco.locos.proto;

import org.jloco.locos.annotation.DofusMessage;
import org.jloco.locos.api.AbstractDofusMessage;
import org.jloco.locos.kernel.Config;

@DofusMessage(header = "Af")
public class AccountQueuePositionMessage extends AbstractDofusMessage {
    
    private int position;
    private int totalAbo;
    private int totalNonAbo;
    private int button;
    
    public AccountQueuePositionMessage(int position, int totalAbo, int totalNonAbo, int button) {
        this.position = position;
        this.totalAbo = totalAbo;
        this.totalNonAbo = totalNonAbo;
        this.button = button;
    }
    
    public AccountQueuePositionMessage() {}
    
    @Override
    public void serialize() {
        getOutput().append("Af").append(position).append("|").append(totalAbo).append("|").append(totalNonAbo).append("|").append(button).append(Config.gameServerId);
    }
    
    @Override
    public void deserialize() {
    
    }
    
    @Override
    public String toString() {
        return "AccountQueuePositionMessage{" +
                "position=" + position +
                ", totalAbo=" + totalAbo +
                ", totalNonAbo=" + totalNonAbo +
                ", button=" + button +
                '}';
    }
}
