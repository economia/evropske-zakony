# vytahne dvojice obdobi-cislo vsech schvalenych zakonu
require! {
    fs
    async
}

obdobi = [1 to 6]
results = {}
regexString = '<TR class="approved" valign="top">    <TD align=right nowrap>&nbsp;<A HREF=historie.sqw.o=([0-9]+)&T=([0-9]+) title="Historie projednávání tisku">'
regex_g = new RegExp regexString, \g
regex = new RegExp regexString
<~ async.each obdobi, (obdobi, cb) ->
    (err, data) <~ fs.readFile "../data/psp_zakony/#obdobi.html"
    data .= toString!
    matches = data.match regex_g
    matches.forEach (str) ->
        [all, obdobi, cislo] = str.match regex
        results["#obdobi-#cislo"] = yes
    cb!
<~ fs.writeFile "../data/zakony_passed.json" JSON.stringify results
console.log 'done'
