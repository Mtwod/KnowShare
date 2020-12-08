function createMessageChannel() {
  App.messages = App.cable.subscriptions.create({
    channel: 'MessagesChannel', chatroom_id: parseInt($("#message_chatroom_id").val())
    },
    {
    
    received: function(data) {
      $("#messages").removeClass('hidden')
      return $('#messages').append(this.renderMessage(data));
    },
    renderMessage: function(data) {
      if(data.user.id == data.booking.id){
        return "<div class='row'><p class='bg-secondary message ml-auto mr-3 p-2 text-right'> <b>" + data.username + "</b><br>" + data.message + "</p></div>";
      } else {
        return "<div class='row'><p class='bg-info message ml-3 p-2'> <b>" + data.username + "</b><br>" + data.message + "</p></div>";
      }
    },
  });
return App.messages;
}