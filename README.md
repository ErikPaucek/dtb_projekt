# Téma projektu
Táto téma sa zaoberá analýzou filmových hodnotení a odporúčaní na základe dát z MovieLens datasetu. MovieLens poskytuje informácie o filmoch, ich žánroch a hodnoteniach od používateľov, čo umožňuje skúmať vzťahy medzi preferenciami divákov a vlastnosťami filmov. 
___
## 1. Úvod a popis zdrojových dát


Cieľom semestrálneho projektu je identifikácia najviac hodnotených a najlepšie hodnotených filmov, analýza preferencií užívateľov na základe ich demografie a vytvorenie modelu odporúčania filmov.
___

### Popis tabuliek

`movies` obsahuje zoznam filmov, pričom každý film má unikátny identifikátor, ktorý sa nazýva "id" a slúži na jednoznačnú identifikáciu filmu. Názov filmu je uložený v stĺpci "title" a rok vydania filmu je zaznamenaný v stĺpci "release_year".

`genres` uchováva zoznam žánrov filmov. Každý žáner má unikátny identifikátor "id", ktorý slúži na jeho identifikáciu, a názov žánru je uložený v stĺpci "name".

`genres_movies` prepája filmy a ich žánre, čím vytvára many-to-many vzťah. Každý záznam má unikátny identifikátor "id". Stĺpec "movie_id" odkazuje na identifikátor filmu v tabuľke Movies, zatiaľ čo stĺpec "genre_id" odkazuje na identifikátor žánru v tabuľke Genres.

`ratings` obsahuje informácie o hodnoteniach filmov od užívateľov. Každé hodnotenie má unikátny identifikátor "id". Stĺpec "user_id" odkazuje na identifikátor užívateľa v tabuľke Users a "movie_id" odkazuje na identifikátor hodnoteného filmu v tabuľke Movies. Hodnota hodnotenia je zaznamenaná v stĺpci "rating" a čas, kedy bolo hodnotenie priradené, je uložený v stĺpci "rated_at".

`tags` uchováva užívateľské štítky (tagy) priradené k filmom. Každý štítok má unikátny identifikátor "id". Stĺpec "user_id" odkazuje na identifikátor užívateľa v tabuľke Users a "movie_id" na identifikátor filmu v tabuľke Movies. Text štítku je uložený v stĺpci "tags" a čas priradenia štítku v stĺpci "created_at".

`users` obsahuje informácie o užívateľoch. Každý užívateľ má identifikátor "id", ktorý ho jednoznačne identifikuje. Vek užívateľa je zaznamenaný v stĺpci "age", pohlavie v stĺpci "gender" a PSČ v stĺpci "zip_code". Stĺpec "occupation_id" odkazuje na identifikátor zamestnania v tabuľke Occupations.

`occupations` obsahuje zoznam zamestnaní. Každé zamestnanie má unikátny identifikátor "id" a jeho názov je zaznamenaný v stĺpci "name".

`age_group` slúži na kategorizáciu vekových skupín. Každá veková skupina má unikátny identifikátor "id" a jej názov je uvedený v stĺpci "name".
___

### ERD diagram
![Entitno-relačná schéma MovieLens](erd_schema.png)

<p align="center"><i>Obrázok 1 Entitno-relačná schéma MovieLens</i></p>

___

## 2. Dimenzionálny model
### Faktorová tabuľka: `fact_ratings`
### Hlavné metriky:
- rating
### Klúče v tabuľke `fact_ratings`:
- **fact_rating_id** - Primárny klúč tabuľky.
- **user_id** - Cudzí klúč, ktorý odkazuje na tabuľku `dim_users`.
- **date_id** - Cudzí klúč, ktorý odkazuje na tabuľku `dim_date`.
- **tags_id** - Cudzí klúč, ktorý odkazuje na tabuľku `dim_tags`.
- **time_id** - Cudzí klúč, ktorý odkazuje na tabuľku `dim_time`.
- **movie_id** - Cudzí klúč, ktorý odkazuje na tabuľku `dim_movies`.

___

### Dimenzionálne tabuľky:

#### `dim_users` 
- Obsahuje údaje o používateľoch (vek, veková skupina, pohlavie, poštové identifikačné číslo, pohlavie).
- #### Typ dimenzie: SCD 2, pretože sa údaje môžu meniť.
<br>

#### `dim_date`
- Obsahuje údaje o dátume (deň - int, deň - string, mesiac - int, mesiac - string, rok, štvrťrok).
- #### Typ dimenzie: SCD 1, pretože sú údaje nemenné.
<br>

#### `dim_tags`
- Obsahuje údaje o popise filmu (popis, dátum vytvorenia).
- #### Typ dimenzie: SCD 1, pretože sú údaje nemenné.
<br>

#### `dim_time`
- Obsahuje údaje o čase v daný deň (sekunda, minúta, hodina, ráno/poobede).
- #### Typ dimenzie: SCD 1, pretože sú údaje nemenné.
<br>

#### `dim_movies`
- Obsahuje údaje o filme (názov, rok vydania, žáner).
- #### Typ dimenzie: SCD 1, pretože sú údaje nemenné.
___

![Schéma hviezdy pre MovieLens](star_schema.png)
<p align="center"><i>Obrázok 2 Schéma hviezdy pre MovieLens</i></p>

