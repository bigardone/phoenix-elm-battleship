import Elm from './main';

const playerId = window.playerId;
const elmDiv = document.querySelector('#main_container');

if (elmDiv) {
  Elm.Main.embed(elmDiv, { playerId: playerId });
}
