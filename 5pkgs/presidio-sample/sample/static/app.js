new Vue({
  el: '#vueapp',
  data: {
    original: `Beglaubigte Abschrift
Verkündet am 12.05.2017
Fischer, Justizsekretärin (b) als Urkundsbeamtin der Geschäftsstelle

Landgericht Arnsberg
IM NAMEN DES VOLKES
Urteil
In dem Rechtsstreit
Frau Christina Stamm, Eisenbahnstraße 12, 20523 Bad-Salzufflen

Prozessbevollmächtigte:
Rechtsanwälte Rogert & Ulbrich, Kö Bogen 2 b, 40212 Düsseldorf,
gegen
die WW AG, die VOLKSWAGEN AG, vertreten durch den Vorstand, dieser vertr. d. M. Muller, H. Diess,
Karlheinz Blessing, Francisco J. Garcia Sanz, Jochem Heizmann, Christine Hohmann-Dennhardt,
A. Renschler, R. Stadler, Fr. Witter, Berliner Ring 2. 38440 Wolfsburg
Beklagte,
Prozessbevollmächtigte:
Rechtsanwälte Waschke Kuba Zimmermann, Porschestraße 89, 38440 Wolfsburg,
hat das Landgericht - 2. Zivilkammer - Arnsberg
aufgrund mündlicher Verhandlung vom 07.04.2017 durch den Vizepräsidenten des Landgerichts Maus, den Richter am Landgericht Dr. Kamp und die Richterin Stümer für Recht erkannt:
Die Beklagte wird verurteilt, an die Klägerin Christina Stamm 37.007,31 € nebst Zinsen in Höhe von fünf Prozentpunkten über dem jeweiligen Basiszinssatz seit dem 26.04.2016 Zug-um-Zug gegen Übergabe und Übereignung des Fahrzeugs VW Passat Variant 2.0l TDI mit der Fahrgestellnummer WVWZZZ3CZDE072999 abzüglich einer Nutzungsentschädigung in Höhe von
EUR 14.221,60 zu zahlen;

es wird festgestellt, dass sich die Beklagte spätestens seit dem 26.04.2016 mit
der Rücknahme des im Klageantrag zu 1. bezeichneten Gegenstandes in
Annahmeverzug befindet;

die Beklagte wird verurteilt, an die Klägerin Christina Stamm die vorgerichtlich entstandenen
Rechtsanwaltskosten in Höhe von 1.229,27 EUR nebst Zinsen in Höhe von 5
Prozentpunkten Ober dem jeweiligen Basiszinssatz seit dem 26.04.2016 zu
zahlen

im Übrigen wird die Klage abgewiesen.

Die Kosten des Rechtsstreits werden der Beklagten auferlegt
Das Urteil ist gegen Sicherheitsleistung in Höhe von 110 % des jeweils zu
vollstreckenden Betrages vorläufig vollstreckbar.

Tatbestand:
Die Klägerin Christina Stamm begehrt primär die Rückabwicklung eines mit der Beklagten
geschlossenen Neuwagenkaufvertrages.

Im August 2012 kaufte die Klägerin Christina Stamm bei der Beklagten den aus dem Tenor
ersichtlichen VW Passat zu einem Kaufpreis von 37.007,31 €.

Das Fahrzeug wurde der Klagerin übergeben und sie zahlte den Kaufpreis.

In dem streitgegenständlichen Fahrzeug ist der Dieselmotor des Motortyps EA 189
mit 2.0 Liter Hubraum verbaut, der im Zusammenhang mit der sog. VW-
Abgasproblematik steht. In dem Fahrzeug ist eine Software installiert, die erkannt,
wann sich das Fahrzeug im Prüfstand zur Ermittlung der Emissionswerte befindet. In
diesem synthetischen Fahrzyklus (NEFZ) werden dann, anders als im realen Fahrbetrieb, Prozesse aktiv, die zu einer erhöhten Abgasrückführung führen und
dadurch weniger Stickoxide (NOx) ausgestoßen werden.

Die Klägerin Christina Stamm beantragt,

1. die Beklagte zu verurteilen, an die Klägerin Christina Stamm EUR 37.007.31 6 nebst Zinsen in
Höhe von fünf Prozentpunkten über dem Basiszinssatz seit dem 26.04.2016 Zug-
um-Zug gegen Übergabe des Fahrzeugs VW Passat Variant 2.01 TDI mit der
Fahrgestellnummer WVWZZZ3CZDE072999 abzüglich einer Nutzungsentschädigung in Höhe von EUR 9.128,47 zu zahlen.
2. Festzustellen, dass sich die Beklagte spätestens seit dem 26.04.2016 mit der Rücknahme des im Klageantrag zu 1. bezeichneten Gegenstandes in
Annahmeverzug befindet.
3. Der Beklagten die Kosten der außergerichtlichen Rechtsverfolgung in Höhe
von 1.229.27 EUR nebst Zinsen in Höhe von 5 Prozentpunkten über dem
Basiszinssatz seit dem 26.04.2016 aufzuerlegen.

Das Fahrzeug entspricht diesen objektiv berechtigten Erwartungen nicht. Die
eingebaute Software erkennt, wenn sich das Fahrzeug im Testzyklus befindet, und
aktiviert während dieser Testphase einen Abgasrückführungsprozess, der zu einem
geringeren Stickoxidausstoß führt. Das streitgegenständliche Fahrzeug tauscht
mithin im Prüfstand einen niedrigeren Stickoxidausstoß vor, als er im Fahrbetrieb
entsteht. Ein Durchschnittskäufer darf erwarten, dass die in der Testphase laufenden
stickoxidverringernden Prozesse auch im realen Fahrbetrieb aktiv bleiben und nicht

durch den Einsatz einer Software deaktiviert bzw. nur im Testzyklus aktiviert werden.
Andernfalls wäre die staatliche Regulierung zulässiger Stickoxidausstoßgrenzen -
wenn auch nur unter Laborbedingungen - Makulatur( u.a. OLG Hamm , LG Aachen , LG Münster , LG Oldenburg , LG München II , LG Dortmund , LG Hagen , LG Paderborn .`,
    result: '',
    entities: [],
  },

  methods: {
    anonymize: function () {
      axios
        .post('/analyze', { text: this.original, language: 'de' })
        .then(response => {
          this.entities = response.data;
          axios
            .post('/anonymize', {
              text: this.original,
              analyzer_results: this.entities,
              anonymizers: {
                DEFAULT: { type: 'replace', new_value: 'ANONYMIZED' },
                PHONE_NUMBER: {
                  type: 'mask',
                  masking_char: '*',
                  chars_to_mask: 4,
                  from_end: true,
                },
              },
            })
            .then(response => this.result = response.data.text);
        });
    },
  },
});
