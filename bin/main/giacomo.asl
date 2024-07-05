// Agente Giacomo, que quer construir uma casa

{ include("common.asl") }

/* Crenças e regras iniciais */

// conta o número de tarefas com base nas propriedades observáveis ​​dos artefatos do leilão
number_of_tasks(NS) :- .findall( S, task(S), L) & .length(L,NS).


/* Initial goals */

!have_a_house.


/* Planos */

+!have_a_house
   <- !contract; // contrata as empresas que vão construir a casa
      !execute;  // (simula) a execução da construção
   .
-!have_a_house[error(E),error_msg(Msg),code(Cmd),code_src(Src),code_line(Line)]
   <- .print("Falha ao construir uma casa devido a: ",Msg," (",E,"). Commando: ",Cmd, " no ",Src,":", Line).


/* Planos de Contratação */

+!contract
   <- !create_auction_artifacts;
      !wait_for_bids;
      !dispose_auction_artifacts.

+!create_auction_artifacts
   <-  !create_auction_artifact("SitePreparation", 2000); // 2000 é o valor máximo que posso pagar pela tarefa
       !create_auction_artifact("Floors",          1000);
       !create_auction_artifact("Walls",           1000);
       !create_auction_artifact("Roof",            2000);
       !create_auction_artifact("WindowsDoors",    2500);
       !create_auction_artifact("Plumbing",         500);
       !create_auction_artifact("ElectricalSystem", 500);
       !create_auction_artifact("Painting",        1200).

+!create_auction_artifact(Task,MaxPrice)
   <- .concat("auction_for_",Task,ArtName);
      makeArtifact(ArtName, "tools.LeilaoDeTresLances", [Task, MaxPrice], ArtId);
      focus(ArtId).
      
-!create_auction_artifact(Task,MaxPrice)[error_code(Code)]
   <- .print("Error creating artifact ", Code).

+!wait_for_bids
   <- println("Waiting bids for 5 seconds...");
      .wait(5000); // utiliza um prazo interno de 5 segundos para fechar os leilões
      !show_winners.

+!show_winners
   <- for ( currentWinner(Ag)[artifact_id(ArtId)] ) {
         ?currentBid(Price)[artifact_id(ArtId)]; // verifica o lance atual
         ?task(Task)[artifact_id(ArtId)];          // e a tarefa a que se destina
         println("Winner of task ", Task," is ", Ag, " for ", Price);
      }.

+!dispose_auction_artifacts
   <- for ( task(_)[artifact_id(ArtId)] ) {
         // println("Fechando o leilão ", ArtId,"...");
         // clearAuction[artifact_id(ArtId)];
         // ?status(Status)[artifact_id(ArtId)]; // verifica o status do artefato
         // println("Status of task ", Task, " is ", Status);
         stopFocus(ArtId);
      }.

/* Planos de gestão da execução da construção da casa */

+!execute
      <- println("*** Execution Phase (não implementado. Comentado para agilizar a parte de leilão ***");
      .
   //    <- println;
   //       println;

   //       // Criação do grupo
   //       .my_name(Me);
   //       createWorkspace("ora4mas");
   //       joinWorkspace("ora4mas",WOrg);

   //       // Obs.: nós (temos que) usar o mesmo id para OrgBoard e Workspace (ora4mas neste exemplo)
   //       makeArtifact(ora4mas, "ora4mas.nopl.OrgBoard", ["src/org/house-os.xml"], OrgArtId)[wid(WOrg)];
   //       focus(OrgArtId);
   //       createGroup(hsh_group, house_group, GrArtId);
   //       debug(inspector_gui(on))[artifact_id(GrArtId)];
   //       adoptRole(house_owner)[artifact_id(GrArtId)];
   //       focus(GrArtId);

   //       !contract_winners("hsh_group"); // eles entrarão no grupo

   //       // cria o artefato GUI
   //       makeArtifact("housegui", "simulator.House");

   //       // cria o scheme
   //       createScheme(bhsch, build_house_sch, SchArtId);
   //       debug(inspector_gui(on))[artifact_id(SchArtId)];
   //       focus(SchArtId);

   //       ?formationStatus(ok)[artifact_id(GrArtId)]; // veja o plano abaixo para garantir que esperaremos até que esteja bem formado
   //       addScheme("bhsch")[artifact_id(GrArtId)];
   //       commitMission("management_of_house_building")[artifact_id(SchArtId)].

   // +!contract_winners(GroupName)
   //     : number_of_tasks(NS) &
   //       .findall( ArtId, currentWinner(A)[artifact_id(ArtId)] & A \== "no_winner", L) &
   //       .length(L, NS)
   //    <- for ( currentWinner(Ag)[artifact_id(ArtId)] ) {
   //             ?task(Task)[artifact_id(ArtId)];
   //             println("Contracting ",Ag," for ", Task);
   //             .send(Ag, achieve, contract(Task,GroupName)) //envia a mensagem ao agente avisando sobre o resultado
   //       }.
   // +!contract_winners(_)
   //    <- println("** I didn't find enough builders!");
   //       .fail.

   // // planeja esperar até que o grupo esteja bem formado
   // // suspende esta intenção até que se acredite que o grupo esteja bem formado
   // +?formationStatus(ok)[artifact_id(G)]
   //    <- .wait({+formationStatus(ok)[artifact_id(G)]}).

   // +!house_built // Tenho uma obrigação em relação ao objetivo de nível superior do esquema: terminar!
   // <- println("*** Finalizado ***").
