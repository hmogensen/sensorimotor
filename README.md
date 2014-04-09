matlab-analysis
===============

1. Mappar i projektet:
-------------

* ```layout```	generiska funktioner som kan vara intressanta för att skapa GUI:n i Matlab
* ```third-party```	open source från Matlab Central
* ```sensorimotor/```
 * ```classes```		datastrukturer som sparas på disk, dvs de behöver vara bakåt/framåtkompatibla
 * ```gui```		varje gång man startar programmet så skapar ett objekt av klassen ScGuiManager. Övriga filer i denna mapp är funktioner eller datastrukturer för ScGuiManager. Sparas ej på disk
* ```functions```	funktioner som ej är användbara för någon annan än oss

2. Lägga till en grafisk komponent:
-------------

I vänsterraden finns det 4-5 paneler. Varje panel har en ```ScLayoutManager``` som placerar ut knappar o dyl i rader. (funktionen ```ScLayoutManager->add``` )
Antag att man vill ändra property ```x``` i ScGuiManager-objektet. Då låter man ScLayoutManager lägga till en grafisk komponent (ex ```uicontrol```) till rätt panel. Den grafiska komponenten har en callback-funktion som ändrar ```x``` i ScGuiManager. Övriga uicontrol-objekt som påverkas av ```x``` har listeners som talar om för dem att x har ändrats. Listeners läggs tex till med funktionen sc_addlistener. 

Det finns en hierarkisk ordning på panelerna, uppifrån och ned. Grafiska objekt på trigger-panelen kan tex inte påverka file-panelen, men de kan påverka plot-panelen (som befinner sig under). Om man har gjort ett omöjligt val i triggerpanelen som inte går att plotta så kan man göra alla paneler under trigger-panelen osynliga för att hindra klåfingriga användare från att skapa en krasch genom att försöka plotta ändå.

3. Övrigt
-------------
Om man ändrar property state i ScGuiManager (görs i file panel, andra uppifrån) så måste samtliga paneler under tas bort och skapas på nytt, eftersom de kommer se olika ut. state kan antingen vara att hitta vågformer (tidigare användningsområdet för programmet) eller amplitudanalysen
