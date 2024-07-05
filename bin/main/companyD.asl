// Esta empresa oferece propostas para todas as tarefas
// Estratégia: oferece um valor aleatório

{ include("common.asl") }

!discover_art("auction_for_SitePreparation").
!discover_art("auction_for_Floors").
!discover_art("auction_for_Walls").
!discover_art("auction_for_Roof").
!discover_art("auction_for_WindowsDoors").
!discover_art("auction_for_Plumbing").
!discover_art("auction_for_ElectricalSystem").
!discover_art("auction_for_Painting").

+task(S)[artifact_id(Art)]
   <- .wait(math.random(500)+50);
      Bid = math.floor(math.random(10000))+800;
      .print("Meu lance no artefato ", Art, " é ",Bid);
      bid( Bid )[artifact_id(Art)]. // lembra que o artefato ignora se este 
                                          // agente fizer um lance maior que o lance atual

/* planos para fase de execução */

{ include("org_code.asl") }
{ include("org_goals.asl") }
