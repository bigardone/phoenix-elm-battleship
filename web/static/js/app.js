import Elm from './main';

const playerId = window.playerId;
const elmDiv = document.querySelector('#main_container');

if (elmDiv) {
  const app = Elm.Main.embed(elmDiv, { playerId: playerId, baseUrl: document.origin });

  app.ports.setDocumentTitle.subscribe((title) => {
    document.title = `${title} · Phoenix Battleship`;
  });
}
