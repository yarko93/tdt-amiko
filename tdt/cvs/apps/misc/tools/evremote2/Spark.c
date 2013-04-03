/*
 * Spark.c
 *
 * (c) 2010 duckbox project
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 */

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>

#include <termios.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <signal.h>
#include <time.h>

#include "global.h"
#include "map.h"
#include "remotes.h"
#include "Spark.h"

static tLongKeyPressSupport cLongKeyPressSupport = {
  10, 120,
};

static tButton cButtonsEdisionSpark[] = {};

/* fixme: move this to a structure and
 * use the private structure of RemoteControl_t
 */
static struct sockaddr_un  vAddr;

struct keyMap {
	char *KeyName;
	int KeyCode;
};

/* All possible keys on all remotes
 * add if you have more
 * Only these keys should be used in lircd.conf
 */

struct keyMap linuxKeys[] = {
	{ "KEY_POWER", KEY_POWER },
	{ "KEY_MUTE", KEY_MUTE },
	{ "KEY_V", KEY_V },
	{ "KEY_AUX", KEY_AUX },
	{ "KEY_0", KEY_0 },
	{ "KEY_1", KEY_1 },
	{ "KEY_2", KEY_2 },
	{ "KEY_3", KEY_3 },
	{ "KEY_4", KEY_4 },
	{ "KEY_5", KEY_5 },
	{ "KEY_6", KEY_6 },
	{ "KEY_7", KEY_7 },
	{ "KEY_8", KEY_8 },
	{ "KEY_9", KEY_9 },
	{ "KEY_BACK", KEY_BACK },
	{ "KEY_INFO", KEY_INFO },
	{ "KEY_AUDIO", KEY_AUDIO },
	{ "KEY_DOWN", KEY_DOWN },
	{ "KEY_UP", KEY_UP },
	{ "KEY_RIGHT", KEY_RIGHT },
	{ "KEY_LEFT", KEY_LEFT },
	{ "KEY_VOLUMEUP", KEY_VOLUMEUP },
	{ "KEY_VOLUMEDOWN", KEY_VOLUMEDOWN },
	{ "KEY_PAGEUP", KEY_PAGEUP },
	{ "KEY_PAGEDOWN", KEY_PAGEDOWN },
	{ "KEY_OK", KEY_OK },
	{ "KEY_MENU", KEY_MENU },
	{ "KEY_EPG", KEY_EPG },
	{ "KEY_HOME", KEY_HOME },
	{ "KEY_FAVORITES", KEY_FAVORITES },
	{ "KEY_RED", KEY_RED },
	{ "KEY_GREEN", KEY_GREEN },
	{ "KEY_YELLOW", KEY_YELLOW },
	{ "KEY_BLUE", KEY_BLUE },
	{ "KEY_REWIND", KEY_REWIND },
	{ "KEY_PAUSE", KEY_PAUSE },
	{ "KEY_PLAY", KEY_PLAY },
	{ "KEY_FASTFORWARD", KEY_FASTFORWARD },
	{ "KEY_RECORD", KEY_RECORD },
	{ "KEY_STOP", KEY_STOP },
	{ "KEY_SLOW", KEY_SLOW },
	{ "KEY_ARCHIVE", KEY_ARCHIVE },
	{ "KEY_SAT", KEY_SAT },
	{ "KEY_PREVIOUS", KEY_PREVIOUS },
	{ "KEY_NEXT", KEY_NEXT },
	{ "KEY_TV2", KEY_TV2 },
	{ "KEY_CLOSE", KEY_CLOSE },
	{ "KEY_TIME", KEY_TIME },
	{ "KEY_NULL", KEY_NULL },
	{ "KEY_F1", KEY_F1 },
	{ "KEY_FIND", KEY_FIND },
	{ "KEY_CHANNELDOWN", KEY_CHANNELDOWN },
	{ "KEY_CHANNELUP", KEY_CHANNELUP },
	{ "KEY_T", KEY_T },
	{ "KEY_F", KEY_F },
	{ "KEY_P", KEY_P },
	{ "KEY_W", KEY_W },
	{ "KEY_TITLE", KEY_TITLE },
	{ "KEY_SUBTITLE", KEY_SUBTITLE },
	{ "KEY_VIDEO", KEY_VIDEO },
	{ "KEY_S", KEY_S },
	{ "KEY_HELP", KEY_HELP },
	{ "KEY_F2", KEY_F2 },
	{ "KEY_F3", KEY_F3 },
	{ "KEY_U", KEY_U },
	{NULL, -1}
};

static int lookupKey(char *keyname){
	struct keyMap *l = linuxKeys;
	while (l->KeyName && strcmp(l->KeyName, keyname))
		l++;
	return l->KeyCode;
}


static int pInit(Context_t* context, int argc, char* argv[]) {

    int vHandle;

    vAddr.sun_family = AF_UNIX;
    strcpy(vAddr.sun_path, "/var/run/lirc/lircd");

    vHandle = socket(AF_UNIX,SOCK_STREAM, 0);

    if(vHandle == -1)  {
        perror("socket");
        return -1;
    }

    if(connect(vHandle,(struct sockaddr *)&vAddr,sizeof(vAddr)) == -1)
    {
        perror("connect");
        return -1;
    }

    return vHandle;
}

static int pShutdown(Context_t* context ) {

    close(context->fd);

    return 0;
}

static int pRead(Context_t* context ) {
	const int           cSize = 128;
	char                vBuffer[cSize];
	char                keyname[cSize];
	int                 updown;
	int                 vCurrentCode  = -1;
	int                 rc;

	memset(vBuffer, 0, 128);
    //wait for new command
    rc = read (context->fd, vBuffer, cSize);
	if(rc <= 0)return -1;

	printf("[RCU] key: %s\n", &vBuffer[0]);

	if (2 == sscanf(vBuffer, "%*x %x %s %*s", &updown, keyname)) {
		vCurrentCode = lookupKey(keyname);
		if (vCurrentCode == -1) {
			printf("[RCU] unknown key %s\n", keyname);
			return -1;
		}
		static int nextflag = 0;
		if (updown == 0)
			nextflag++;
		vCurrentCode += (nextflag << 16);
	}

    return vCurrentCode;
}

static int pNotification(Context_t* context, const int cOn) {

    struct aotom_ioctl_data vfd_data;
    int ioctl_fd = -1;

    if(cOn)
    {
       ioctl_fd = open("/dev/vfd", O_RDONLY);
       vfd_data.u.icon.icon_nr = 35;
       vfd_data.u.icon.on = 1;
       ioctl(ioctl_fd, VFDICONDISPLAYONOFF, &vfd_data);
       close(ioctl_fd);
    }
    else
    {
       usleep(100000);
       ioctl_fd = open("/dev/vfd", O_RDONLY);
       vfd_data.u.icon.icon_nr = 35;
       vfd_data.u.icon.on = 0;
       ioctl(ioctl_fd, VFDICONDISPLAYONOFF, &vfd_data);
       close(ioctl_fd);
    }

    return 0;
}

RemoteControl_t Spark_RC = {
	"Spark RemoteControl",
	Spark,
	&pInit,
	&pShutdown,
	&pRead,
	&pNotification,
	cButtonsEdisionSpark,
	NULL,
	NULL,
  	1,
  	&cLongKeyPressSupport,
};

