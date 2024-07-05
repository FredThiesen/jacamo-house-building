// Esta empresa pode concorrer a todos os tipos de tarefas,
// mas pode comprometer-se com no máximo 2 deles
// Estratégia: preço fixo

{ include("common.asl") }

// uma regra para ajudar o agente a inferir se ele pode se comprometer com outra tarefa
can_commit :-
   .my_name(Me) & .term2string(Me,MeS) &
   .findall( ArtId, currentWinner(MeS)[artifact_id(ArtId)], L) &
   .length(L,S) & S < 2.

// crenças iniciais sobre avaliações para o leilão
my_price("SitePreparation", 1900).
my_price("Floors",           900).
my_price("Walls",            900).
my_price("Roof",            1100).
my_price("WindowsDoors",    2000).
my_price("Plumbing",         600).
my_price("ElectricalSystem", 300).
my_price("Painting",        1100).

!discover_art("auction_for_SitePreparation").
!discover_art("auction_for_Floors").
!discover_art("auction_for_Walls").
!discover_art("auction_for_Roof").
!discover_art("auction_for_WindowsDoors").
!discover_art("auction_for_Plumbing").
!discover_art("auction_for_ElectricalSystem").
!discover_art("auction_for_Painting").

@[atomic] // atômico para garantir que ainda ganhe menos de dois quando o lance for feito
+currentBid(V)[artifact_id(Art)]        // há um novo valor para o lance atual
    : task(S)[artifact_id(Art)] &
      my_price(S,P) &                   // obter minha avaliação para este serviço
      not i_am_winning(Art) &           // Eu não sou o vencedor
      P < V &                           // Posso oferecer um lance melhor
      can_commit                        // Ainda posso me comprometer com outra tarefa
   <- .print("Meu lance no artefato ", Art, ", Task ", S, ", é ", P);
      bid( P )[ artifact_id(Art) ].     // faço meu lance oferecendo um serviço mais barato
      
/* planos para fase de execução */

{ include("org_code.asl") }
{ include("org_goals.asl") }
