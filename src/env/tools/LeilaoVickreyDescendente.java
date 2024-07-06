package tools;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.ObsProperty;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Artefato que implementa um Leilão de Segundo Preço Selado (Vickrey) descendente.
 */
public class LeilaoVickreyDescendente extends Artifact {

    private List<Bid> bids = new ArrayList<>();

    private class Bid {
        String agentName;
        double value;

        Bid(String agentName, double value) {
            this.agentName = agentName;
            this.value = value;
        }
    }

    @OPERATION
    public void init(String taskDs, int maxValue) {
        startAuction(taskDs, maxValue);
    }

    // Operação para iniciar um novo leilão
    @OPERATION
    public void startAuction(String taskDs, int maxValue) {
        // Define ou atualiza as propriedades observáveis
        defineObsProperty("task", taskDs);
        defineObsProperty("maxValue", maxValue);
        defineObsProperty("currentWinner", "no_winner");

        bids.clear();
    }

    // Operação para fazer um lance
    @OPERATION
    public void bid(double bidValue) {
        if (!getObsProperty("status").getValue().equals("open")) {
            failed("Leilão está fechado.");
            return;
        }

        if (bidValue < 0) {
            failed("Valor negativo.");
            return;
        }

        bids.add(new Bid(getCurrentOpAgentId().getAgentName(), bidValue));
    }

    // Operação para finalizar o leilão e determinar o vencedor e o preço a pagar
    @OPERATION
    public void closeAuction() {
        if (!getObsProperty("status").getValue().equals("open")) {
            failed("Leilão já está fechado.");
            return;
        }

        if (bids.isEmpty()) {
            failed("Nenhum lance foi registrado.");
            return;
        }

        // Ordena os lances pelo valor (do menor para o maior)
        Collections.sort(bids, (b1, b2) -> Double.compare(b1.value, b2.value));

        Bid lowestBid = bids.get(0);
        Bid secondLowestBid = bids.size() > 1 ? bids.get(1) : null;

        ObsProperty opCurrentWinner = getObsProperty("currentWinner");
        opCurrentWinner.updateValue(lowestBid.agentName);

        if (secondLowestBid != null) {
            defineObsProperty("winningBidValue", secondLowestBid.value);
        } else {
            defineObsProperty("winningBidValue", lowestBid.value);
        }
    }
}
