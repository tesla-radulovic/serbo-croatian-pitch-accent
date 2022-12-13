const puppeteer = require( 'puppeteer' );

const isempty = /<tbody>\s*<\/tbody>/;

const letters = ["A","B"];/*"C","Č","Ć","D","Dž","Đ","E","F","G","H","I","J","K","L","Lj","M","N","Nj","O","P","R","S","Š","T","U","V","Z","Ž"];*/

(async () => {
    const browser = await puppeteer.launch();
  
    const page = await browser.newPage();

    let cont = true;
    let i = 1;
    while(cont || i > 100){
	const resp = await page.goto('https://rjecnik.hr/?letter='+process.argv[2]+'&page='+i,{
	    waitUntil:["networkidle0"]
	});
	const text = await resp.text();
    
	if( isempty.test(text) ){
	    cont = false
	}else {
	    console.log(text);
	}
	i = i + 1;
    }
    console.log(i);
    
    await browser.close();
})();
