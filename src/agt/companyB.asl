// Esta empresa licita para preparação do local
// Estratégia: diminuir seu preço em 150 até seu valor mínimo

{ include("common.asl") }

my_price(1500). // crença inicial

!discover_art("auction_for_SitePreparation").

+currentBid(V)[artifact_id(Art)]        // há um novo valor para o lance atual
    : not i_am_winning(Art) &           // Eu não sou o vencedor
      my_price(P) & P < V               // Posso oferecer um lance melhor
   <- .print("Meu lance no artefato ", Art, " é ",math.max(V-150,P));
      bid( math.max(V-150,P) ).         // faço meu lance oferecendo um serviço mais barato
      
/* planos para fase de execução */

{ include("org_code.asl") }

+!site_prepared
   <- prepareSite. // simula a ação (no artefato GUI)

