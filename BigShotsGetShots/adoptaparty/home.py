import cgi
import webapp2
import logging

class Home(webapp2.RequestHandler):
    def get(self):
        self.response.out.write("")

app = webapp2.WSGIApplication([('/', Home)], debug=True)

def main():
    app.run()

if __name__ == "__main__":
    main()
