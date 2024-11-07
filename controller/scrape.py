from flask_restful import Resource, request
from service.scrape import ScrapeService
from base.response_code import ResponseCode
import traceback

class ScrapeController(Resource):
    def __init__(self):
        self.scrape_service = ScrapeService()
    
    def post(self):
        payload = request.get_json()
        results = []

        # try:
        to_scrape_urls = payload['to_scrape_urls']
        results = self.scrape_service.scrape(to_scrape_urls)
        response = {
            'message': 'success',
            'data': results,
        }
        response_code = ResponseCode.SUCCESS
        # except:
        #     err = traceback.format_exc()
        #     response = {
        #         'message': f'Error: {err}',
        #         'data': results,
        #     }
        #     response_code = ResponseCode.BAD_REQUEST
        return response
