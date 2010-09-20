package grailsyuiexample

import grails.converters.JSON

class ProductController {

  def scaffold = Product

  def choices = {
    def choiceList = Product.list()
    def processedList = []

    choiceList.each() {
      processedList << it.name
    }

    render processedList as JSON
  }
}
