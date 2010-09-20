import grailsyuiexample.ContactType
import grailsyuiexample.Customer
import grailsyuiexample.Product

class BootStrap {

    def init = { servletContext ->

     new ContactType(name:"Email").save()
     new ContactType(name:"Phone").save()
     new ContactType(name:"Postal Mail").save()
     new ContactType(name:"In Person Mtg.").save()

     new Customer(firstName:"John", lastName:"Smith",
                  streetAddressOne:"123 Anywhere St.",
                  city:"Anytown", state:"WA", zipCode:"98765",
                  areaCode:"123", phonePrefix:"456", phoneSuffix:"7890",
                  email:"john.smith@fakemail.com").save()

     new Customer(firstName:"Jane", lastName:"Doe",
                  streetAddressOne:"123 Anyplace Ave.",
                  city:"Anyville", state:"AL", zipCode:"12345",
                  areaCode:"098", phonePrefix:"765", phoneSuffix:"4321",
                  email:"jane.dpe@fakemail.com").save()

     new Product(name:"Wonder Widget").save()
     new Product(name:"Wacky Widget").save()
     new Product(name:"Wiggle Widget").save()

    }
    def destroy = {
    }
}
