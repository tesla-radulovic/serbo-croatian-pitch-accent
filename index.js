const puppeteer = require( 'puppeteer' );

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

    const resp = await page.goto('https://rjecnik.hr/?letter='+process.argv[2]+'&page='+process.argv[3],{
	waitUntil:["networkidle0"]
    });

  const text = await resp.text();
    
  console.log(text);
    
  await browser.close();
})();
