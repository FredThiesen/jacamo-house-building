package tools;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.ObsProperty;

/**
 * Artefato que implementa o leilão.
 */
public class LeilaoDeTresLances extends Artifact {

    private long biddingDeadline;
    private long biddingDuration = 3000; // 3 segundos por padrão
    private int bidCount = 0;
    private final int maxBids = 3;

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
        defineObsProperty("currentBid", maxValue);
        defineObsProperty("currentWinner", "no_winner");
        defineObsProperty("status", "open");
        defineObsProperty("timeLeft", biddingDuration);

        biddingDeadline = System.currentTimeMillis() + biddingDuration;
        updateRemainingTime(System.currentTimeMillis());
        bidCount = 0; // Reset bid count
    }

    // Operação para fazer um lance
    @OPERATION
    public void bid(double bidValue) {
        long currentTime = System.currentTimeMillis();
        updateRemainingTime(currentTime);

        if (currentTime > biddingDeadline) {
            failed("Acabou o tempo do leilão.");
            return;
        }

        if (bidCount >= maxBids) {
            failed("Número máximo de lances atingido.");
            return;
        }

        ObsProperty opCurrentValue = getObsProperty("currentBid");
        ObsProperty opCurrentWinner = getObsProperty("currentWinner");
        ObsProperty opStatus = getObsProperty("status");

        if (!opStatus.getValue().equals("open")) {
            failed("Leilão está fechado.");
            return;
        }

        if (bidValue < 0) {
            failed("Valor negativo.");
            return;
        }

        if (bidValue < opCurrentValue.doubleValue()) {  // O lance é melhor que o anterior
            opCurrentValue.updateValue(bidValue);
            opCurrentWinner.updateValue(getCurrentOpAgentId().getAgentName());
            bidCount++; // Increment bid count
        }
    }

    // Atualiza o tempo restante para o leilão
    private void updateRemainingTime(long currentTime) {
        ObsProperty opTimeLeft = getObsProperty("timeLeft");
        long timeLeft = biddingDeadline - currentTime;
        if (timeLeft < 0) {
            timeLeft = 0;
        }
        opTimeLeft.updateValue(timeLeft);
    }
}
