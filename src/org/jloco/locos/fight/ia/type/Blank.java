package org.jloco.locos.fight.ia.type;

import org.jloco.locos.fight.Fight;
import org.jloco.locos.fight.Fighter;
import org.jloco.locos.fight.ia.AbstractIA;

/**
 * Created by Locos on 18/09/2015.
 */
public class Blank extends AbstractIA {

    public Blank(Fight fight, Fighter fighter) {
        super(fight, fighter, (byte) 1);
    }

    @Override
    public void apply() {
        this.stop = true;
        this.endTurn();
    }
}
