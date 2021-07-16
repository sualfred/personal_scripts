#!/bin/bash

#################################
#            Config             #
#################################

#Search this paths
PATHS=( "/symlinks/share/share/filme" "/symlinks/share/share/HDR/filme" )

#Your TheMovieDB API
API=867ff90cfaeef855e39cf1fb3f56edf4

#Language Code
LANGUAGE=de

#Force redownload
OVERWRITE=false

#Custom path to store the log files. Uncomment this line and change the path. By default the working directory is going to be used.
LOGPATH="/symlinks/share/share/scripts"

#################################

#Functions
downloadTrailer(){
        DL=$(youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"  "https://www.youtube.com/watch?v=$ID" -o "$DIR/$FILENAME-trailer.%(ext)s" --restrict-filenames --no-continue)
        log "$DL"

        if [ -z "$(echo "$DL" | grep "100.0%")" ]; then
                missing ""
                missing "Error: Downloading failed - $FILENAME - $DIR - TheMovideDB: https://www.themoviedb.org/movie/$TMDBID - YouTube: https://www.youtube.com/watch?v=$ID"
                missing "------------------"
                missing "$DL"
                missing "------------------"
                missing ""
        else
                #Update file modification date
                touch "$DIR/$FILENAME-trailer.mp4"
        fi
}

log(){
        echo "$1" |& tee -a "$LOGPATH/trailerdl.log"
}

missing(){
        echo "$1" |& tee -a "$LOGPATH/trailerdl-error.log" &>/dev/null
}

#################################

#Delete old logs
rm "$LOGPATH/trailerdl.log" &>/dev/null
rm "$LOGPATH/trailerdl-error.log" &>/dev/null

#Use manually provided language code (optional)
if [ "$1" = "force" ]; then
        OVERWRITE=true
elif ! [ -z "$1" ]; then
        LANGUAGE="$1"
fi

if [ "$2" = "force" ]; then
        OVERWRITE=true
fi

if [ -z "$LOGPATH" ]; then
        LOGPATH=$(pwd)
fi


#Walk defined paths and search for movies without existing local trailer
for i in "${PATHS[@]}"
do
        find "$i" -mindepth 1 -maxdepth 2 -name '*.nfo*' -printf "%h\n" | sort -u | while read DIR
        do
                FILENAME=$(ls "$DIR" | egrep '\.nfo$' | sed s/".nfo"//g | sed "\/-trailer$/d")

                if ! [ -f "$DIR/$FILENAME-trailer.mp4" ] || [ $OVERWRITE = "true" ]; then

                        #Get TheMovieDB ID from NFO
			TMDBID=$(xmlstarlet sel -t -v "movie/tmdbid" "$DIR/$FILENAME.nfo")

                        log ""
                        log "Movie Path: $DIR"
                        log "Processing file: $FILENAME.nfo"

                        if ! [ -z "$TMDBID" ]; then

                                log "TheMovieDB: https://www.themoviedb.org/movie/$TMDBID"

                                #Get trailer YouTube ID from themoviedb.org
                                JSON=($(curl "http://api.themoviedb.org/3/movie/$TMDBID/videos?api_key=$API&language=$LANGUAGE" | jq '.results | sort_by(-.size)' | jq -r '.[] | select(.type=="Trailer") | .key'))
                                #JSON=($(curl "http://api.themoviedb.org/3/movie/$TMDBID/videos?api_key=$API&language=$LANGUAGE" | jq '.results | sort_by(-.size)' | jq -r '.[] | select(.type=="Trailer")'))
				ID="${JSON[0]}"

                                if ! [ -z "$ID" ]; then
                                                #Start download
                                        log "YouTube: https://www.youtube.com/watch?v=$ID"
                                        downloadTrailer

                                else
                                        log "YouTube: n/a"
                                        missing "Error: Missing YouTube ID - $FILENAME - $DIR - TheMovideDB: https://www.themoviedb.org/movie/$TMDBID"

                                fi

                        else
                                        log "TheMovieDB: n/a"
                                missing "Error: Missing TheMovieDB ID - $FILENAME - $DIR"
                        fi

                fi
        done
done
