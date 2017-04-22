// this is the same as rooms.coffee in site point tut
jQuery(document).on('turbolinks:load', function() {
  var messages, messages_to_bottom;
  messages = $('#messages');
  if ($('#messages').length > 0) {
    messages_to_bottom = function() {
      return messages.scrollTop(messages.prop("scrollHeight"));
    };
    messages_to_bottom(); //sitepoint

    App.messages = App.cable.subscriptions.create('MessagesChannel', {
      received: function(data) {
        // apparently I don't need the #messages below, it was working with something else
        $("#messages").removeClass('hidden')
        messages.append(this.renderMessage(data));
        return messages_to_bottom(); //sitepoint
      },

      renderMessage: function(data) {

        // discuss = changeTextColour(data);

        return "<p> <b>" + data.user + "</b>" + "(" + data.connect + ")" + ": " + data.message + "</p>";
      }
    });
  } //sitepoint
});
  // function changeTextColour (data) {
  //
  //   if (data.connect = "Agree") {
  //     return data.connect.fontcolor("green");
  //   } else if (data.connect = "Disagree") {
  //     return data.connect.fontcolor("red");
  //   }
  // }

// discuss = data.connect
// if (discuss = "Agree") {
//   discuss = discuss.fontcolor("green");
// } else {
//   discuss = discuss.fontcolor("red");
// }
// jQuery(document).on('turbolinks:load', function() {
//   var messages, messages_to_bottom;
//   messages = $('#messages');
//   if ($('#messages').length > 0) {
//     messages_to_bottom = function() {
//       return messages.scrollTop(messages.prop("scrollHeight"));
//     };
//     messages_to_bottom();
//     App.global_chat = App.cable.subscriptions.create({
//       channel: "ChatRoomsChannel",
//       chat_room_id: messages.data('chat-room-id')
//     }, {
//       received: function(data) {
//         messages.append(data['message']);
//         return messages_to_bottom();
//       },
//
//       send_message: function(message, chat_room_id) {
//         return this.perform('send_message', {
//           message: message,
//           chat_room_id: chat_room_id
//         });
//       }
//     });
//     return $('#new_message').submit(function(e) {
//       var $this, textarea;
//       $this = $(this);
//       textarea = $this.find('#message_body');
//       if ($.trim(textarea.val()).length > 1) {
//         App.global_chat.send_message(textarea.val(), messages.data('chat-room-id'));
//         textarea.val('');
//       }
//       e.preventDefault();
//       return false;
//     });
//   }
// });
