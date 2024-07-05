/* regras auxiliares para agentes */

i_am_winning(Art)   //verifica se eu coloquei o melhor lance atual no artefato Art do leilão
   :- currentWinner(W)[artifact_id(Art)] &
      .my_name(Me) & .term2string(Me,MeS) & W == MeS.

/* planos auxiliares para Cartago */

// tenta encontrar um artefato específico e então focar nele
+!discover_art(ToolName)
   <- lookupArtifact(ToolName,ToolId);
      focus(ToolId).
// continue tentando até que o artefato seja encontrado
-!discover_art(ToolName)
   <- .wait(100);
      !discover_art(ToolName).
