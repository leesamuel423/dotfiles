// Script to run in console for linkedin endorsements

window.scrollTo({
  left: 0,
  top: document.body.scrollHeight,
  behavior: 'smooth', // smooth scrolling triggers DOM renders
})

setTimeout(() => {
  const htmlCollections = document.getElementsByClassName('artdeco-button__text')
  for (i = 0; i < htmlCollections.length; i++) {
    if (htmlCollections[i].parentElement.innerText == ("Endorse")) {
      htmlCollections[i].click()
    }
  }
}, 2000);
