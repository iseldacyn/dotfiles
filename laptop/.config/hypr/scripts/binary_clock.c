/* inspired by https://gist.github.com/fjueic/1ba317bcd9884bdb2f0ddab996206630 */
#include <time.h>
#include <wchar.h>
#include <stdio.h>
#include <stdlib.h>
#include <locale.h>

char *get_hours_binary( int );
char *get_minutes_binary( int );
char *get_seconds_binary( int );
int power( int, int );

int main( int argc, char **argv ) {
    setlocale( LC_CTYPE, "" );

    time_t time_raw = time(NULL);
    struct tm *time_curr = localtime( &time_raw );
    int time_unit = argv[1][0] - '0';

    char *time_in_binary = NULL;
    wint_t *binary_time = NULL;
    switch(time_unit) {
        case 0:
            time_in_binary = get_hours_binary( time_curr->tm_hour );
            binary_time = malloc( sizeof(wint_t) * 4 );
            break;
        case 1:
            time_in_binary = get_minutes_binary( time_curr->tm_min );
            binary_time = malloc( sizeof(wint_t) * 6 );
            break; case 2:
            time_in_binary = get_seconds_binary( time_curr->tm_sec );
            binary_time = malloc( sizeof(wint_t) * 6 );
            break;
        default:
            time_in_binary = "err";
            binary_time = malloc( sizeof(wint_t) * 3 );
    }

    int i = 0;
    while( time_in_binary[i] != '\0' ) {
        if( time_in_binary[i] == '0' )
            binary_time[i] = L'○';
        else if( time_in_binary[i] == '1' )
            binary_time[i] = L'⬤';
        else {
            binary_time[i] = btowc(time_in_binary[i]);
        }
        i++;
    }
    wprintf( L"%ls\n", binary_time );

    free(time_in_binary);
    free(binary_time);
}

char *get_hours_binary( int h ) {
    char *hours = malloc(4);
    if( !hours ) exit(1);
    if( h > 12 ) h-=12;
    for( int i = 0; i < 4; i++ ) {
        int curr_bit = power(2,3-i);
        if( h >= curr_bit ) {
            hours[i] = '1';
            h -= curr_bit;
        }
        else
            hours[i] = '0';
    }
    return hours;
}

char *get_minutes_binary( int m ) {
    char *minutes = malloc(6);
    if( !minutes ) exit(1);
    for( int i = 0; i < 6; i++ ) {
        int curr_bit = power(2,5-i);
        if( m >= curr_bit ) {
            minutes[i] = '1';
            m -= curr_bit;
        }
        else
            minutes[i] = '0';
    }
    return minutes;
}

char *get_seconds_binary( int s ) {
    return get_minutes_binary( s );
}

int power( int a, int b ) {
    int v = 1;
    while( b != 0 ) {
        if( (b+1)%2 ) {
            a *= a;
            b /= 2;
        }
        else {
            b -= 1;
            v *= a;
        }
    }
    return v;
}
