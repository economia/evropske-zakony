require! {
    fs
    moment
    '../data/zakony_passed.json'
}
(err, data) <~ fs.readFile "../data/tisky.unl"
id_to_obdobi = # from poslanci:organy
    165: 1
    166: 2
    167: 3
    168: 4
    169: 5
    170: 6
lines = data.toString!.split "\n"
#lines.length = 50
months_assoc = {}
lines.forEach (line) ->
    [id_tisk, id_druh, id_stav, ct, cislo_za, id_navrh, id_org, id_org_obd, id_osoba, navrhovatel, nazev_tisku, predlozeno, rozeslano, dal, tech_nos_dat, uplny_nazev_tisku, zm_lhuty, lhuta, rj, t_url, is_eu, roz, is_sdv, status] = line.split "|"
    return unless id_tisk.length
    predlozenoDate = moment predlozeno, "DD.MM.YYYY"
    return unless predlozenoDate
    id_druh = parseInt id_druh, 10
    return unless id_druh in [1 2 3 4 12 20 27]
    obdobi = id_to_obdobi[id_org_obd]
    return unless obdobi
    is_eu = parseInt is_eu, 10
    # if not predlozenoDate
    #     console.log 'foo'
    #     console.log "#{id_tisk.length}: #id_tisk"
    #     console.log predlozeno
    monthId = predlozenoDate.format "YYYY-MM"
    months_assoc[monthId] ?=
        date: predlozenoDate.format "M. YYYY"
        total: 0
        eu: 0
        ok_total: 0
        ok_eu: 0
    months_assoc[monthId].total++
    if is_eu
        months_assoc[monthId].eu++
    if zakony_passed["#obdobi-#ct"]
        months_assoc[monthId].ok_total++
        if is_eu
            months_assoc[monthId].ok_eu++
for id, {date, total, eu, ok_total, ok_eu} of months_assoc
    console.log "#date\t#total\t#eu\t#ok_total\t#ok_eu"
