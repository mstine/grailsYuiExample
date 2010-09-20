package grailsyuiexample

class Customer {

    String firstName
    String lastName
    String streetAddressOne
    String streetAddressTwo
    String city
    String state
    String zipCode
    String areaCode
    String phonePrefix
    String phoneSuffix
    String email


    static constraints = {
      firstName(blank:false)
      lastName(blank:false)
      streetAddressOne(blank:false)
      streetAddressTwo(nullable:true)
      city(blank:false)
      state(blank:false)
      zipCode(blank:false)
      areaCode(blank:false)
      phonePrefix(blank:false)
      phoneSuffix(blank:false)
      email(email:true)
    }

  def String toString() {
    "${lastName}, ${firstName}"
  }
}
