package grailsyuiexample

import grails.converters.JSON

class CustomerController {

  def scaffold = Customer

  def choices = {
    def choiceList = Customer.list()
    def processedList = []

    choiceList.each() {
      processedList << it.toString()
    }

    render processedList as JSON
  }
}
