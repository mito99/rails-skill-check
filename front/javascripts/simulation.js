import '../stylesheets/simulation.scss';
import $ from 'jquery';

$(function(){
  $(".sim-action_input input[type=text]").on("change", function(){
    // 前ゼロ、カンマなど廃し、数値を整形
    const num = $(this).val().replace(/,/g,'');
    if(num.match(/^[0-9]+$/)){
      $(this).val(Number(num));
    }
  });
});

$(function(){
  $("#calc-button").on("click", function(){
    clear_plans_message();
    clear_action_message();

    const users = $("#input-user").val();
    const boxes = $("#input-box").val();
    const msg = validation(users, boxes);
    if(msg) return action_message(msg);

    // サーバ負荷軽減のため、連続送信を１秒間隔に制限
    operation_block();
    const url = "./api/v1/payments/plans";
    $.get(url,{users, boxes}).
      then(success_plans_getapi(users, boxes)). 
      catch(fail_plans_getapi).
      then(clear_operation_block(1000));
  });

  function validation(user, box){
    const un_num = [user, box].some(p=>!p.match(/^[0-9]+$/));
    if(un_num || user <= 0 || box <= 0){
      return "ユーザ数、受信箱数には１以上の数値を入力してください。";
    }

    const user_max_num = $(".sim-plan-cards").data("user-max");
    if(user_max_num && user > Number(user_max_num)){
      return "ユーザ数には、" + user_max_num + "以下の数値を入力してください。";
    }

    const box_max_num = $(".sim-plan-cards").data("box-max");
    if(box_max_num && box > Number(box_max_num)){
      return "受信箱数には、" + box_max_num + "以下の数値を入力してください。";
    }
  }

  function action_message(msg){
    $(".sim-action_message").text(msg);
  }

  function clear_action_message(){
    action_message("");
  }

  function plans_message(user, box){
    const msg = "ユーザ数" + user + "人、受信箱数" + box + "個の" +
      "料金を表示しています。";
    $(".sim-plans_message").text(msg);
  }

  function clear_plans_message(){
    $(".sim-plans_message").text("");
  }

  function success_plans_getapi(users, boxes){
    return function(response){
      plans_message(users, boxes);
      $("[data-plan-id]").each((idx,card)=>{
        const plan_id = $(card).data("plan-id");
        const plan_data = response[plan_id];

        const $price = $(card).
          find(".sim-plan-card_body_price_value>span:first");
        if(plan_data){
          const lowprice_rank = plan_data.rank;
          const card_status = lowprice_rank === 1 ? "lowprice" : "";
          $(card).attr("data-card-status", card_status);
          $price.text(plan_data.fee.toLocaleString());
          return;
        }

        $(card).attr("data-card-status", "disabled");
        $price.text("-");
      });
    }
  }

  function fail_plans_getapi(xhr, status, error){
    action_message("料金計算に失敗しました。");
  }

  function operation_block(){
    $("body").addClass("__block");
  }

  function clear_operation_block(msec){
    return function(){
      setTimeout(function(){
        $("body").removeClass("__block");
      }, msec);
    }
  }
});
