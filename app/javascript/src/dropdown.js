import { Dropdown } from 'bootstrap'

document.addEventListener('turbolinks:load', () => {
  const dropdownElements = document.querySelectorAll('[data-bs-toggle="dropdown"]')
  dropdownElements.forEach((el) => new Dropdown(el))
})
