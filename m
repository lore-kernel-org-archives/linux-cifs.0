From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Howto mount cifs from c?
Date: Thu, 2 Aug 2012 22:37:20 +0200
Message-ID: <CANXojcz5SKpFUpt9h2e60pGZh60ngjiSzxdNLGBp+DfQUJej+Q@mail.gmail.com>
References: <CANXojcz_p23rcNo3gPiAjJ95M0ry+p5Q_5hyYO0TF==0VpKBqg@mail.gmail.com>
	<CANXojczSt+3pyiEH_RoQa4TjA+7H1pmNJrpbJsX3iQA1Vr1O_A@mail.gmail.com>
	<CADT32eJcEm=UnXaCfAva1aXWptxBGEmBAYgeJnqU7nVtC7T4nA@mail.gmail.com>
	<CANXojcwnCQQOEBk3=sM_61Uq7BunLyUvx67WzNGxbRszcgp-fA@mail.gmail.com>
	<CADT32e+Rx3L12ciJXL3VsKnOpsAFiedZXAU78-jZromi7dioNw@mail.gmail.com>
	<CANXojczjroEONLHbmauimAh_M-4ZuHMJ=3LTnHAXMSahc9WMRA@mail.gmail.com>
	<CANXojcy+RapoY9dHXgkaCMr3D7c01bBhiJcxyU2698QwNzY_aA@mail.gmail.com>
	<CADT32eK7WuEASsQ3pUWr9Qj74wRyaGwnEZ10XeQBF-r6d9WHUg@mail.gmail.com>
	<CANXojcyKPGYMv_6iequis+v2d67ozTk7Lw9D0=MY7WWymT=1Nw@mail.gmail.com>
	<20120802161435.7d1564ce@tlielax.poochiereds.net>
	<CANXojczHxNVG5LNb+DR=w92sG5Fto8Vc7O5x9qP8NA-t+xFA1A@mail.gmail.com>
	<20120802162637.2d4fefb5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120802162637.2d4fefb5-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I use:

/* add rw etc*/

len1=sprintf(vfsdata+len0, ",rw,nodfs,unc=");
len0+=len1;
/* add the unc */

*(vfsdata+len0)='\\';
len0++;
*(vfsdata+len0)='\\';
len0++;

memcpy(vfsdata+len0, smb_server->name, strlen(smb_server->name));
len0+=strlen(smb_server->name);

*(vfsdata+len0)='\\';
len0++;

memcpy(vfsdata+len0, smb_share->name, strlen(smb_share->name));
len0+=strlen(smb_share->name);

if (strlen(smb_server->ipv4address)>0) {

         /* add ip */

         len1=sprintf(vfsdata+len0, ",ip=%s", smb_server->ipv4address);
         len0+=len1;

}
Here I got logmessages:

kernel: fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 118 with uid: 0
kernel: fs/cifs/connect.c: UNC:
\\SCLFS20091030\p//SCLFS20091030/public ip:
SCLFS20091030\p//SCLFS20091030/public

which is also bogus.

I think I'm not the person to remove the unc from the kernel with a
patch...but I think it's not required anymore, it adds nothing.
Right now it's required by the cifs module still as I checked.

I think there is something wrong with parsing the backslashes. They
should be forbidden. Some hint?

Stef
