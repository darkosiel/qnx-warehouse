let arr = [];
let warehouseArr = [];

$(() => {
  window.addEventListener('message', (event) => {
    let data = event.data;
    if (data.action === 'open' && data.state) {
      $('.buymenu').fadeIn();
      $('.buypage').fadeIn();
      $('.lager1').hide();
      $('.lager2').hide();
      $('.lager3').hide();
      $('.success').hide();
      $('.verwaltenpage').hide();
      $('.betretenpage').hide();
      $('.loginpage').hide();

      esc();

      //   locale setup
      $('#smalllagername').text(data.Config.small.label);
      $('#middlelagername').text(data.Config.medium.label);
      $('#biglagername').text(data.Config.big.label);

      // price setup
      $('#smalllagerprice').text(
        data.Config.small.price.toLocaleString('de-DE', {}) + '$'
      );
      $('#middlelagerprice').text(
        data.Config.medium.price.toLocaleString('de-DE', {}) + '$'
      );
      $('#biglagerprice').text(
        data.Config.big.price.toLocaleString('de-DE', {}) + '$'
      );
    } else if (data.action === 'showWarehouse') {
      $('.boxconte').empty();
      data.warehouse.forEach((element) => {
        $('.boxconte').append(`
        <div class="boxx">
            <img src="images/lager1.png" alt=""> 
                <div class="boxbox">
                    <span class="lagertxt">Name</span>
                    <span class="boxtxt" id="aktuelllagername">${
                      element.label
                    }</span>
                </div>
                <div class="boxbox">
                    <span class="lagertxt">Preis</span>
                    <span class="boxtxt" id="aktuelllagerprice" >${element.price.toLocaleString(
                      'de-DE',
                      {}
                    )}$</span> 
                </div>   
            <div class="buttonbox">
                <button onclick="showVerwalten('${element.label}', '${
          element.price
        }', ${element.sellPrice})">Verwalten</button>
                <button onclick="showBetreten()">Betreten</button>
           </div> 
        </div>      
        `);
      });
    } else if (data.action === 'inventory') {
      $('.inventory').fadeIn();
      $('#yallah').empty();
      data.item.forEach((element) => {
        $('#yallah').append(`
          <div class="box" onclick="putItem('${element.name}', '${element.label}')">
            <span id="itemcount">${element.count}</span> 
            <div class="flex">
                <img  class="itemimg" src="images/${element.name}.png">
                <span id="itemname">${element.label}</span>
            </div>
          </div>
        `);
      });
    } else if (data.action === 'lagerItems') {
      $('#invappend').empty();
      data.items.forEach((element) => {
        $('#info').text(element.myWeight + '/' + element.maxWeight);
        $('#invappend').append(`
          <div class="box" onclick="takeItem('${element.name}', '${element.label}')">
            <span id="itemcount">${element.count}</span>
            <div class="flex">
              <img   
                class="itemimg"
                src="images/${element.name}.png" 
              />
              <span id="itemname">${element.label}</span> 
            </div>
          </div> 
      `);
      });
    }
  });
});

const esc = () => {
  document.onkeyup = (data) => {
    if (data.which === 27) return close();
  };
};

function buySmall() {
  let pin = $('#smallPin').val();

  if (!pin) return;

  // passed checks
  $('.lager1').hide();
  $('.lager2').hide();
  $('.lager3').hide();
  $('.loader').fadeIn();
  setTimeout(() => {
    $.post(
      'https://qnx-lager/buy',
      JSON.stringify({
        type: 'small',
        pin: pin,
      })
    );
    $('.loader').fadeOut();
    $('.success').fadeIn();
  }, 1500);
}

function buyMedium() {
  let pin = $('#mediumPin').val();

  if (!pin) return;

  // passed checks
  $('.lager1').hide();
  $('.lager2').hide();
  $('.lager3').hide();
  $('.loader').fadeIn();
  setTimeout(() => {
    $.post(
      'https://qnx-lager/buy',
      JSON.stringify({
        type: 'medium',
        pin: pin,
      })
    );
    $('.loader').fadeOut();
    $('.success').fadeIn();
  }, 1500);
}

function buyBig() {
  let pin = $('#bigPin').val();

  if (!pin) return;

  // passed checks
  $('.lager1').hide();
  $('.lager2').hide();
  $('.lager3').hide();
  $('.loader').fadeIn();
  setTimeout(() => {
    $.post(
      'https://qnx-lager/buy',
      JSON.stringify({
        type: 'big',
        pin: pin,
      })
    );
    $('.loader').fadeOut();
    $('.success').fadeIn();
  }, 1500);
}

//
function showVerwalten(label, price, sellPrice) {
  $('.loginpage').hide();
  $('.verwaltenpage').fadeIn();
  $('#aaaaaaaaaaaaaaaaa').text(label);
  $('#bbbbbbbbbbbbb').text(price.toLocaleString('de-DE', {}));
  document.querySelector(
    '.monkeySeller'
  ).placeholder = `Verkaufspreis: ${sellPrice.toLocaleString('de-DE', {})}$`;
}
//

//
function changePin() {
  let pin = $('#changepin').val();
  let bPin = $('.secPin').val();

  if (!pin && !bPin) return;

  if (pin !== bPin) {
    $.post(
      'https://qnx-lager/notify',
      JSON.stringify({
        type: 'ungleich',
      })
    );
  }

  $('.verwaltenpage').hide();
  $('.loader').fadeIn();
  setTimeout(() => {
    $.post(
      'https://qnx-lager/changePin',
      JSON.stringify({
        newPin: pin,
      })
    );

    $('.loader').fadeOut();
    $('.loginpage').fadeIn();
  }, 1500);
}
//

//
function sellWarehouse() {
  let pin = $('.pinsav').val();

  if (!pin) return;

  $('.verwaltenpage').hide();
  $('.loader').fadeIn();
  setTimeout(() => {
    $.post(
      'https://qnx-lager/sellWarehouse',
      JSON.stringify({
        pin: pin,
      })
    );

    $('.loader').fadeOut();
    $('.loginpage').fadeIn();
  }, 1500);
}
//

//
function enterWarehouse() {
  let pin = $('.babyJoiner').val();

  if (!pin) return;

  $.post(
    'https://qnx-lager/enterWarehouse',
    JSON.stringify({
      pin: pin,
    })
  );
  $('.betretenpage').hide();
  $('.loginpage').fadeIn();
}
//

//
function putItem(name, label) {
  $('.boxsetting').fadeIn();

  arr = [];
  arr.push({ name: name, label: label });
}
//

function transfer() {
  let amount = $('#lalibala').val();

  if (!amount) return;

  $.post(
    'https://qnx-lager/putItem',
    JSON.stringify({
      name: arr[0].name,
      label: arr[0].label,
      count: amount,
    })
  );
  $('.boxsetting').hide();
  arr = [];
}

//
function takeItem(name, label) {
  $('#yau').fadeIn();

  warehouseArr = [];
  warehouseArr.push({ name: name, label: label });
}
//

function transfer_out() {
  let amount = $('#lalibala2').val();

  if (!amount) return;

  $.post(
    'https://qnx-lager/takeItem',
    JSON.stringify({
      name: warehouseArr[0].name,
      labe: warehouseArr[0].label,
      count: amount,
    })
  );
  $('#yau').hide();
  warehouseArr = [];
}

function showLogin() {
  $('.buypage').fadeOut();
  $('.lager1').hide();
  $('.lager2').hide();
  $('.lager3').hide();
  $('.success').hide();
  $('.verwaltenpage').hide();
  $('.betretenpage').hide();
  $('.loginpage').fadeIn();
}

function showBuy() {
  $('.loginpage').fadeOut();
  $('.lager1').hide();
  $('.lager2').hide();
  $('.lager3').hide();
  $('.success').hide();
  $('.verwaltenpage').hide();
  $('.betretenpage').hide();
  $('.buypage').fadeIn();
}

function showLager1() {
  $('.buypage').fadeOut();
  $('.loader').fadeIn();
  setTimeout(() => {
    $('.loader').fadeOut();
    $('.lager1').fadeIn();
  }, 1500);
}

function showLager2() {
  $('.buypage').fadeOut();
  $('.loader').fadeIn();
  setTimeout(() => {
    $('.loader').fadeOut();
    $('.lager2').fadeIn();
  }, 1500);
}

function showLager3() {
  $('.buypage').fadeOut();
  $('.loader').fadeIn();
  setTimeout(() => {
    $('.loader').fadeOut();
    $('.lager3').fadeIn();
  }, 1500);
}

function showSuccess() {
  $('.lager1').hide();
  $('.lager2').hide();
  $('.lager3').hide();
  $('.loader').fadeIn();
  setTimeout(() => {
    $('.loader').fadeOut();
    $('.success').fadeIn();
  }, 1500);
}

function showBetreten() {
  $('.loginpage').hide();
  $('.betretenpage').fadeIn();
}

function closeSetting() {
  $('.boxsetting').fadeOut();
}

function close() {
  $.post('https://qnx-lager/close');
  $('.buymenu').fadeOut();
  $('.inventory').fadeOut();
  $('.boxconte').empty();
  $('#yallah').empty();
  $('#invappend').empty();
}
