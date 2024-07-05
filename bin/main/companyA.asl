// Esta empresa licita apenas para encanamento
// Estratégia: preço fixo

{ include("common.asl") }

my_price(300). // crença inicial

!discover_art("auction_for_Plumbing").

+currentBid(V)[artifact_id(Art)]         // Tem um valor novo para o lance atual
    : not i_am_winning(Art)  &           // Não sou o vencedor atual
      my_price(P) & P < V                // Eu posso oferecer um lance melhor
   <- .print("Meu lance no artefato ", Art, " é ",P);
      bid( P ).                          // fazer meu lance oferecendo um serviço mais barato

/* planos para fase de execução */

{ include("org_code.asl") }

// plano para executar metas organizacionais (não implementado)

+!plumbing_installed   // Objetivo da organização (criado a partir de uma obrigação)
   <- installPlumbing. // simula a ação (no GUI artifact)

