import './ticket.dart';

class TicketList {
  List<Ticket> tickets;

  TicketList({
    required this.tickets,
  });

  factory TicketList.fromJson(List<dynamic> json) {
    List<Ticket> ticketsList = <Ticket>[];
    ticketsList = json.map((e) => Ticket.fromJson(e)).toList();
    return new TicketList(
      tickets: ticketsList,
    );
  }
}
