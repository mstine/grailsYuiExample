package grailsyuiexample

import grails.converters.JSON

class ContactController {

  def scaffold = Contact

  def _list1 = { }
  def _list2 = { }
  def _list3 = { }


  def dataTable = {
    def contacts = Contact.list()

    def jsonResults = []

    contacts.each() {
      def row = [:]
      jsonResults << row

      row.id = it.id
      row.customer = it.customer.toString()
      row.product = it.product.name
      row.date = it.date
      row.type = it.type.name
      row.notes = it.notes
      row.delete = "Delete"
    }

    def jsonMap = [contacts: jsonResults]

    render jsonMap as JSON
  }



  def updateCustomer = {
    def contactId = params.id
    def customerChoice = params.choice

    def contact = Contact.get(Long.valueOf(contactId))

    def lastName = customerChoice.substring(0, customerChoice.indexOf(","))
    def firstName = customerChoice.substring(customerChoice.indexOf(",") + 2)

    def customer = Customer.findByFirstNameAndLastName(firstName, lastName)

    contact.customer = customer
    saveAndRenderJSONResponse(contact)
  }

  def updateProduct = {
    def contactId = params.id
    def productChoice = params.choice

    def contact = Contact.get(Long.valueOf(contactId))
    def product = Product.findByName(productChoice)

    contact.product = product
    saveAndRenderJSONResponse(contact)
  }

  def updateType = {
    def contactId = params.id
    def typeChoice = params.choice

    def contact = Contact.get(Long.valueOf(contactId))
    def contactType = ContactType.findByName(typeChoice)

    contact.type = contactType
    saveAndRenderJSONResponse(contact)
  }

  def updateNotes = {
    def contactId = params.id
    def notesValue = params.choice

    def contact = Contact.get(Long.valueOf(contactId))
    contact.notes = notesValue

    saveAndRenderJSONResponse(contact)
  }


  def updateDate = {
    def contactId = params.id
    def contactDateValue = params.choice

    def contact = Contact.get(Long.valueOf(contactId))
    def newDate = Date.parse("M/d/yyyy", contactDateValue)

    contact.date = newDate
    saveAndRenderJSONResponse(contact, newDate.format("MM/dd/yyyy"))
  }
  
  def remove = {
    def contact = Contact.get(params.id)
    contact.delete()
    render(contentType:"text/json") {
      replyCode = "201"
    }
  }

  def add = {
    def contact = new Contact(customer:Customer.get(1), product:Product.get(1), type:ContactType.get(1), date:new Date())
    if (contact.save()) {
      render(contentType: "text/json") {
        replyCode = "201"
        data = {
          id = contact.id
          product = contact.product.name
          customer = contact.customer.toString()
          type = contact.type.name
          date = contact.date
        }
      }
    } else {
      render(contentType: "text/json") {
        replyCode = "500"
        replyText = "Error creating new contact!"
      }
    }
  }

  private def saveAndRenderJSONResponse(Contact contact, String response) {
    if (contact.save()) {
      render(contentType: "text/json") {
        replyCode = "201"
        data = response
      }
    } else {
      render(contentType: "text/json") {
        replyCode = "500"
        replyText = "Error saving field!"
      }
    }
  }

  private def saveAndRenderJSONResponse(Contact contact) {
    if (contact.save()) {
      render(contentType: "text/json") {
        replyCode = "201"
        data = params.choice
      }
    } else {
      render(contentType: "text/json") {
        replyCode = "500"
        replyText = "Error saving field!"
      }
    }
  }
}
