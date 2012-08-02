From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Howto mount cifs from c?
Date: Thu, 2 Aug 2012 23:27:14 +0200
Message-ID: <CANXojcwS9qap3b4Hvef_5S31eby7PX-_4jYd6LemtMHO6rp7TA@mail.gmail.com>
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
	<CANXojcz5SKpFUpt9h2e60pGZh60ngjiSzxdNLGBp+DfQUJej+Q@mail.gmail.com>
	<CAH2r5mvS2OHBpu8q60WuXK3L7ys2mx_PRtRa=OEK51FZKdtxQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvS2OHBpu8q60WuXK3L7ys2mx_PRtRa=OEK51FZKdtxQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Oh I'm sorry. The code I gave did add // and /, which was not ok again.

I will try something like:

memcpy(vfsdata+len0, "\\\\", 2)
len0+=2;

memcpy(vfsdata+len0, smb_server->name, strlen(smb_server->name));
len0+=strlen(smb_server->name);

memcpy(vfsdata+len0, "\\", 1)
len0+=1;

memcpy(vfsdata+len0, smb_share->name, strlen(smb_share->name));
len0+=strlen(smb_share->name);

and optional a terminator:

*(vfsdata+len0)='\0';

I will test this, and report back.

Stef
