// A empresa empreiteira Thiesen licita apenas para o serviço de encanamento
// Estratégia: diminuir seu preço em 150 até seu valor mínimo

{ include("common.asl") }

my_price(100). // crença inicial

!discover_art("auction_for_Plumbing").

+currentBid(V)[artifact_id(Art)]        // há um novo valor para o lance atual
    : not i_am_winning(Art) &           // Eu não sou o vencedor
      my_price(P) & P < V               // Posso oferecer um lance melhor
   <- ?task(Task)[artifact_id(ArtId)];
      .print("Meu lance para a tarefa ",Task, " é ",math.max(V-10,P));
      bid( math.max(V-10,P) ).         // faço meu lance oferecendo um serviço mais barato

/* planos para fase de execução */

{ include("org_code.asl") }

+!plumbing_installed   // Objetivo da organização (criado a partir de uma obrigação)
   <- installPlumbing. // simula a ação (no GUI artifact)

