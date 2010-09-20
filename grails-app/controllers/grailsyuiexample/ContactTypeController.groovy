package grailsyuiexample

import grails.converters.JSON

class ContactTypeController {

  def scaffold = ContactType

  def choices = {
    def choiceList = ContactType.list()
    def processedList = []

    choiceList.each() {
      processedList << it.name
    }

    render processedList as JSON
  }
}
