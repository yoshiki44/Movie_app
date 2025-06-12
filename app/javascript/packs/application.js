// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "@rails/actioncable"
import '../src/dropdown'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "bootstrap"

function setupHamburgerMenu() {
  const hamburger = document.getElementById('customHamburger');
  const navMenu = document.getElementById('navbarSupportedContent');
  const closeBtn = document.getElementById('closeHamburger');

  if (hamburger && navMenu) {
    // すでにイベント登録している場合の重複防止
    hamburger.onclick = function() {
      navMenu.classList.toggle('show');
    };
    if (closeBtn) {
      closeBtn.onclick = function() {
        navMenu.classList.remove('show');
      };
    }

    // メニューリンク押したら自動で閉じる
    navMenu.querySelectorAll('a').forEach(link => {
      link.onclick = () => {
        navMenu.classList.remove('show');
      };
    });
  }
}

// Turbolinks or Turbo or 初回ロード
document.addEventListener('turbolinks:load', setupHamburgerMenu);
document.addEventListener('DOMContentLoaded', setupHamburgerMenu);
// Turbo Streamsなら
document.addEventListener('turbo:load', setupHamburgerMenu);
