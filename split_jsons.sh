#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────────
# 1) Ensure 'jq' is installed:
if ! command -v jq &>/dev/null; then
  echo "❌ jq not found. Install it with: sudo apt-get update && sudo apt-get install -y jq" >&2
  exit 1
fi

# 2) Embed your JSON array here (paste exactly, no comments, no trailing commas):
JSON_ENTRIES=$(cat <<'EOF'
[
  {
    "image_id": "10.jpg",
    "text": "{\"name\":\"Garima Aggarwal\",\"date\":\"June 11, 2020\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "9.jpg",
    "text": "{\"name\":\"Garima Aggarwal\",\"date\":\"June 11, 2020\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "8.jpg",
    "text": "{\"name\":\"Diza Cremonita\",\"date\":\"December 15, 2020\",\"issuer\":\"MIT Bootcamps & Harvard Medical School Center for Primary Care\"}"
  },
  {
    "image_id": "7.jpg",
    "text": "{\"name\":\"Diza Cremonita\",\"date\":\"December 15, 2020\",\"issuer\":\"MIT Bootcamps & Harvard Medical School Center for Primary Care\"}"
  },
  {
    "image_id": "6.jpg",
    "text": "{\"name\":\"Diza Cremonita\",\"date\":\"December 15, 2020\",\"issuer\":\"Massachusetts Institute of Technology\"}"
  },
  {
    "image_id": "5.jpg",
    "text": "{\"name\":\"Diza Cremonita\",\"date\":\"December 15, 2020\",\"issuer\":\"Massachusetts Institute of Technology\"}"
  },
  {
    "image_id": "4.jpg",
    "text": "{\"name\":\"Leonardo Munhoz Schuler\",\"date\":\"2020\",\"issuer\":\"Harvard University\"}"
  },
  {
    "image_id": "3.jpg",
    "text": "{\"name\":\"Leonardo Munhoz Schuler\",\"date\":\"2020\",\"issuer\":\"Harvard University\"}"
  },
  {
    "image_id": "2.jpg",
    "text": "{\"name\":\"Jeffrey Mishlove\",\"date\":\"June 14, 1980\",\"issuer\":\"University of California\"}"
  },
  {
    "image_id": "1.jpg",
    "text": "{\"name\":\"Jeffrey Mishlove\",\"date\":\"June 14, 1980\",\"issuer\":\"University of California\"}"
  },
  {
    "image_id": "20.jpg",
    "text": "{\"name\":\"Krithika Ramadoss\",\"date\":\"January 13 - March 20, 2020\",\"issuer\":\"Harvard Division of Continuing Education\"}"
  },
  {
    "image_id": "19.jpg",
    "text": "{\"name\":\"Nurudeen Adeyinka Salau\",\"date\":\"September 30 - November 18, 2019\",\"issuer\":\"Massachusetts Institute of Technology\"}"
  },
  {
    "image_id": "18.jpg",
    "text": "{\"name\":\"Jennifer Stroud\",\"date\":\"March 20 - March 21, 2019\",\"issuer\":\"Harvard University Extension School\"}"
  },
  {
    "image_id": "17.jpg",
    "text": "{\"name\":\"Jennifer Stroud\",\"date\":\"March 20 - March 21, 2019\",\"issuer\":\"Harvard University Extension School\"}"
  },
  {
    "image_id": "16.jpg",
    "text": "{\"name\":\"Essam Abdulaziz Al-Sharafi\",\"date\":\"July 2018\",\"issuer\":\"Massachusetts Institute of Technology\"}"
  },
  {
    "image_id": "15.jpg",
    "text": "{\"name\":\"Essam Abdulaziz Al-Sharafi\",\"date\":\"July 2018\",\"issuer\":\"Massachusetts Institute of Technology\"}"
  },
  {
    "image_id": "14.jpg",
    "text": "{\"name\":\"Marco Spoel\",\"date\":\"May 7 - June 25, 2018\",\"issuer\":\"Massachusetts Institute of Technology\"}"
  },
  {
    "image_id": "13.jpg",
    "text": "{\"name\":\"Stevan Urošević\",\"date\":\"February 18, 2015\",\"issuer\":\"Massachusetts Institute of Technology\"}"
  },
  {
    "image_id": "12.jpg",
    "text": "{\"name\":\"Stevan Urošević\",\"date\":\"February 18, 2015\",\"issuer\":\"Massachusetts Institute of Technology\"}"
  },
  {
    "image_id": "11.jpg",
    "text": "{\"name\":\"Kamal Koushik Duppalapudi\",\"date\":\"2020\",\"issuer\":\"Harvard University\"}"
  },
  {
    "image_id": "30.jpg",
    "text": "{\"name\":\"Erick Michael Sánchez Guillén\",\"date\":\"July 4, 2020\",\"issuer\":\"Harvard University (HarvardX)\"}"
  },
  {
    "image_id": "29.jpg",
    "text": "{\"name\":\"Erick Michael Sánchez Guillén\",\"date\":\"July 4, 2020\",\"issuer\":\"Harvard University (HarvardX)\"}"
  },
  {
    "image_id": "28.jpg",
    "text": "{\"name\":\"Doina Popa\",\"date\":\"May 2020\",\"issuer\":\"Massachusetts Institute of Technology\"}"
  },
  {
    "image_id": "27.jpg",
    "text": "{\"name\":\"Doina Popa\",\"date\":\"May 2020\",\"issuer\":\"Massachusetts Institute of Technology\"}"
  },
  {
    "image_id": "26.jpg",
    "text": "{\"name\":\"Yuan Fu\",\"date\":\"March 20, 2020\",\"issuer\":\"University of California, Irvine\"}"
  },
  {
    "image_id": "25.jpg",
    "text": "{\"name\":\"Yuan Fu\",\"date\":\"March 20, 2020\",\"issuer\":\"University of California, Irvine\"}"
  },
  {
    "image_id": "24.jpg",
    "text": "{\"name\":\"Yuan Fu\",\"date\":\"March 20, 2020\",\"issuer\":\"University of California, Irvine\"}"
  },
  {
    "image_id": "23.jpg",
    "text": "{\"name\":\"Yuan Fu\",\"date\":\"March 20, 2020\",\"issuer\":\"University of California, Irvine\"}"
  },
  {
    "image_id": "22.jpg",
    "text": "{\"name\":\"Muhammad Saeed Ahmad\",\"date\":\"June 12, 2020\",\"issuer\":\"University of California, Los Angeles\"}"
  },
  {
    "image_id": "21.jpg",
    "text": "{\"name\":\"Rodrigo de Oliveira Morelli\",\"date\":\"May 15, 2020\",\"issuer\":\"University of California, Berkeley\"}"
  },
  {
    "image_id": "31.jpg",
    "text": "{\"name\":\"David Ascencios Rondón\",\"date\":\"December 2020\",\"issuer\":\"MITx\"}"
  },
  {
    "image_id": "32.jpg",
    "text": "{\"name\":\"David Ascencios Rondón\",\"date\":\"December 2020\",\"issuer\":\"MITx\"}"
  },
  {
    "image_id": "33.jpg",
    "text": "{\"name\":\"Vincent Lemus\",\"date\":\"June 27, 2020\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "34.jpg",
    "text": "{\"name\":\"Madison Maren Kausen\",\"date\":\"May 16, 2014\",\"issuer\":\"University of California\"}"
  },
  {
    "image_id": "35.jpg",
    "text": "{\"name\":\"Madison Maren Kausen\",\"date\":\"May 16, 2014\",\"issuer\":\"University of California\"}"
  },
  {
    "image_id": "36.jpg",
    "text": "{\"name\":\"Erick Michael Sánchez Guillén\",\"date\":\"July 4, 2020\",\"issuer\":\"Harvard University (HarvardX)\"}"
  },
  {
    "image_id": "37.jpg",
    "text": "{\"name\":\"Tica Lin\",\"date\":\"Fall 2020\",\"issuer\":\"Harvard University\"}"
  },
  {
    "image_id": "38.jpg",
    "text": "{\"name\":\"Tica Lin\",\"date\":\"Fall 2020\",\"issuer\":\"Harvard University\"}"
  },
  {
    "image_id": "39.jpg",
    "text": "{\"name\":\"Tica Lin\",\"date\":\"Fall 2020\",\"issuer\":\"Harvard University\"}"
  },
  {
    "image_id": "40.jpg",
    "text": "{\"name\":\"Rishi Sanjay Shah\",\"date\":\"December 18, 2020\",\"issuer\":\"University of California, Irvine\"}"
  },
  {
    "image_id": "41.jpg",
    "text": "{\"name\":\"Carlos Robles\",\"date\":\"May 27, 2021\",\"issuer\":\"Harvard University\"}"
  },
  {
    "image_id": "42.jpg",
    "text": "{\"name\":\"Jayakrishnan Balachandran\",\"date\":\"June 20, 2021\",\"issuer\":\"MITx\"}"
  },
  {
    "image_id": "43.jpg",
    "text": "{\"name\":\"Erik P. Kraft\",\"date\":\"May 26, 2021\",\"issuer\":\"Harvard University Extension School\"}"
  },
  {
    "image_id": "44.jpg",
    "text": "{\"name\":\"Erik P. Kraft\",\"date\":\"May 26, 2021\",\"issuer\":\"Harvard University Extension School\"}"
  },
  {
    "image_id": "45.jpg",
    "text": "{\"name\":\"Erik P. Kraft\",\"date\":\"May 26, 2021\",\"issuer\":\"Harvard University Extension School\"}"
  },
  {
    "image_id": "46.jpg",
    "text": "{\"name\":\"Erik P. Kraft\",\"date\":\"May 26, 2021\",\"issuer\":\"Harvard University Extension School\"}"
  },
  {
    "image_id": "47.jpg",
    "text": "{\"name\":\"Ravit Dotan\",\"date\":\"May 14, 2021\",\"issuer\":\"University of California\"}"
  },
  {
    "image_id": "48.jpg",
    "text": "{\"name\":\"Dr Christian Von Holst\",\"date\":\"October 21, 2021\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "49.jpg",
    "text": "{\"name\":\"Dr Christian Von Holst\",\"date\":\"October 21, 2021\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "50.jpg",
    "text": "{\"name\":\"David K. Quach\",\"date\":\"November 13, 2021\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "51.jpg",
    "text": "{\"name\":\"Antonio Aurelio de Paiva Fagundes Jr., MD, PhD\",\"date\":\"September 30, 2021\",\"issuer\":\"Harvard Medical School Brigham and Women's Hospital\"}"
  },
  {
    "image_id": "52.jpg",
    "text": "{\"name\":\"Antonio Aurelio de Paiva Fagundes Jr., MD, PhD\",\"date\":\"September 30, 2021\",\"issuer\":\"Harvard Medical School Brigham and Women's Hospital\"}"
  },
  {
    "image_id": "53.jpg",
    "text": "{\"name\":\"Nikhil Kumar\",\"date\":\"December 2, 2021\",\"issuer\":\"Harvard University (HarvardX)\"}"
  },
  {
    "image_id": "54.jpg",
    "text": "{\"name\":\"Nikhil Kumar\",\"date\":\"December 2, 2021\",\"issuer\":\"Harvard University (HarvardX)\"}"
  },
  {
    "image_id": "55.jpg",
    "text": "{\"name\":\"Amal Asokan Swayamprabha Mandiram\",\"date\":\"November 16, 2021\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "56.jpg",
    "text": "{\"name\":\"Amal Asokan Swayamprabha Mandiram\",\"date\":\"November 16, 2021\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "57.jpg",
    "text": "{\"name\":\"Choi Tae Yang\",\"date\":\"December 15, 2021\",\"issuer\":\"MITx\"}"
  },
  {
    "image_id": "58.jpg",
    "text": "{\"name\":\"Choi Tae Yang\",\"date\":\"December 15, 2021\",\"issuer\":\"MITx\"}"
  },
  {
    "image_id": "59.jpg",
    "text": "{\"name\":\"Harpita Pandian\",\"date\":\"2022\",\"issuer\":\"Harvard University\"}"
  },
  {
    "image_id": "60.jpg",
    "text": "{\"name\":\"Harpita Pandian\",\"date\":\"2022\",\"issuer\":\"Harvard University\"}"
  },
  {
    "image_id": "61.jpg",
    "text": "{\"name\":\"Vamsi Krishna K P\",\"date\":\"April 1, 2022\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "62.jpg",
    "text": "{\"name\":\"Karunarathnalage Lilan Udayanga Dayananda\",\"date\":\"April 11, 2022\",\"issuer\":\"University of Pennsylvania\"}"
  },
  {
    "image_id": "63.jpg",
    "text": "{\"name\":\"Kana Udomon\",\"date\":\"March 4, 2022\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "64.jpg",
    "text": "{\"name\":\"Kana Udomon\",\"date\":\"March 4, 2022\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "65.jpg",
    "text": "{\"name\":\"Natan-Haim Kalson\",\"date\":\"June 6, 2022\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "66.jpg",
    "text": "{\"name\":\"Natan-Haim Kalson\",\"date\":\"June 6, 2022\",\"issuer\":\"California Institute of Technology\"}"
  },
  {
    "image_id": "67.jpg",
    "text": "{\"name\":\"Shashank Tomar\",\"date\":\"June 9, 2022\",\"issuer\":\"California Institute of Technology\"}"
