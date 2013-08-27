require! {
    async
    request
    iconv.Iconv
    fs
}
obdobi = [1 to 6]
iconv = new Iconv \CP1250 \utf-8
<~ async.eachSeries obdobi, (obdobi, cb) ->
    address = "http://www.psp.cz/sqw/tisky.sqw?str=1&O=#{obdobi}&PT=K&N=1&F=N&D=1,2,16&RA=2000"
    console.log "Loading #address"
    (err, response, body) <~ request.get address, encoding:null
    console.log "loaded"
    body = iconv.convert body
    <~ fs.writeFile "../data/psp_zakony/#{obdobi}.html" body
    console.log "saved"
    cb!
console.log "Done!"
