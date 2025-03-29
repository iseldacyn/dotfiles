#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>

#define PATH_TO_CHARGE_FULL "/sys/class/power_supply/BATT/charge_full"
#define PATH_TO_CHARGE_NOW "/sys/class/power_supply/BATT/charge_now"
#define PATH_TO_BATTERY_STATUS "/sys/class/power_supply/BATT/status"

typedef enum
{
	CHARGING,
	DISCHARGING,
	FULL
}status_t;

void make_daemon();
int get_battery_level();
status_t get_battery_status();
void send_message();

int main()
{
	
	make_daemon();

	int sent = 0;

	while( 1 )
	{
		int percentage = get_battery_level();

		// only send message once, when battery <= 20%
		if ( percentage <= 20 )
		{
			status_t status = get_battery_status();
			if ( status == CHARGING )
			{
				// send message again if taken off charger
				sent = 0;
				goto out_of_if;
			}
			else if ( !sent )
			{
				send_message();
				sent = 1;
			}
				
		}
		else
			sent = 0;

	out_of_if:

		fprintf( stderr, "percentage: %d\n", percentage );

		sleep(1);
	}

	return 0;
}

// turns program into a daemon
void make_daemon()
{
	// fork from parent & terminate if successful
	__pid_t pid = fork();
	if( pid < 0 )
	{
		perror( "Error when calling fork()\n" );
		exit(1);
	}
	else if( pid > 0 )
		exit(0);

	// allow file editing
	umask(0);

	// create a new session
	if( setsid() < 0 )
	{
		perror( "Error when calling setsid()\n" );
		exit(1);
	}

	// fork off again to remove session leader
	pid = fork();
	if( pid < 0 )
	{
		perror( "Error when calling fork()\n" );
		exit(1);
	}
	else if( pid > 0 )
		exit(0);
}

int get_battery_level()
{
	long unsigned int batt_full, batt_now;

	FILE *charge_full = fopen( PATH_TO_CHARGE_FULL, "r" );
	FILE *charge_now = fopen( PATH_TO_CHARGE_NOW, "r" );

	fscanf( charge_full, "%lu", &batt_full );
	fscanf( charge_now, "%lu", &batt_now );

	fclose( charge_full );
	fclose( charge_now );

	return (int)(100 * batt_now / batt_full);
}

status_t get_battery_status()
{
	char status[15];
	
	FILE *batt_status = fopen( PATH_TO_BATTERY_STATUS, "r" );
	fscanf( batt_status, "%s", &status );
	fclose( batt_status );

	status_t curr_status;

	if( status[0] == 'D' )
		curr_status = DISCHARGING;
	else if( status[0] == 'C' )
		curr_status = CHARGING;
	else
		curr_status = FULL;

	fprintf( stderr, "status: %s\n", status );

	return curr_status;
}

void send_message()
{
	system( "dunstify -i /home/iselda/Pictures/volume/low-battery.png -r 2595 -u critical 'LOW BATTERY: Please plug in charger!'" );
	return;
}
