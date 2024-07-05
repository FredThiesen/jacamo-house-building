// Esta empresa licita pisos, paredes e telhados
// Estratégia: um preço fixo mais baixo para realizar todas as 3 tarefas,
// diminui o lance atual em um valor fixo

{ include("common.asl") }

my_price(800). // preço mínimo para as 3 tarefas

// uma regra para calcular a soma dos lances atuais feitos por este agente
sum_of_my_offers(S) :-
   .my_name(Me) & .term2string(Me,MeS) &
   .findall( V,      // artifacts/auctions I am currently winning
             currentWinner(MeS)[artifact_id(ArtId)] &
             currentBid(V)[artifact_id(ArtId)],
             L) &
   S = math.sum(L).

/* Planos para fase de leilão */

!discover_art("auction_for_Floors").
!discover_art("auction_for_Walls").
!discover_art("auction_for_Roof").


+currentBid(V)[artifact_id(Art)]      // há um novo valor para o lance atual
    : not i_am_winning(Art) &         // Eu não sou o vencedor
      my_price(P) &
      sum_of_my_offers(Sum) &
      task(S)[artifact_id(Art)] &
      P < Sum + V                     // Ainda posso oferecer um lance melhor
   <- .print("Meu lance no artefato ", Art, ", Task ", S,", é ",math.max(V-10,P));
      bid( math.max(V-10,P) )[ artifact_id(Art) ].  // faço meu lance oferecendo um serviço mais barato
      
/* planos para fase de execução */

{ include("org_code.asl") }
{ include("org_goals.asl") }
