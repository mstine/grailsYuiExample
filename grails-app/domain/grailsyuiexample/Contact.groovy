package grailsyuiexample

class Contact {

    Customer customer
    Product product
    Date date
    ContactType type
    String notes

    static constraints = {
      customer(nullable:true)
      product(nullable:true)
      date(blank:false)
      type(nullable:true)
      notes(nullable:true)
    }

  
}
