Feature: crawler downloads first page

	As a user
	I want to download the initial page
	So I can crawl the web
	
	Scenario: begin crawl
		Given the crawl has not begun
		When I start a crawl with the URI "http://example.com/"
		Then the page should be downloaded