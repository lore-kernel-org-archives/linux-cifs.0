From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Howto mount cifs from c?
Date: Thu, 2 Aug 2012 16:26:37 -0400
Message-ID: <20120802162637.2d4fefb5@tlielax.poochiereds.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANXojczHxNVG5LNb+DR=w92sG5Fto8Vc7O5x9qP8NA-t+xFA1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2 Aug 2012 22:20:26 +0200
Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> uid: 0
> >> >> kernel: fs/cifs/connect.c: UNC: \\SCLFS20091030/public ip: 192.168.0.2
> >                                         ^^^^^^^^
> > Your unc= parm is bogus, it requires backslashes as delimiters.
> >
> > Is there some reason you're not using mount.cifs?
> >
> 
> I'm mounting from my own c program, and would like to use the general
> mount command from c.
> 
> Look at some messages back, I've tried backslashes there, and the code
> that does that is there. There I also got errors,, so the construction
> to create/add the unc to the options is probably wrong.
> 


I'm not sure about your earlier messages, but the UNC in the example
above is clearly bogus. It should be something like:

    \\SCLFS20091030\public

Replicating all of the logic in mount.cifs sounds fragile. I'd urge you
not to do that. If you do insist on doing that, then a kernel patchset
that eliminates the need for the silly unc= parameter in the first
place would be a good way to help ensure that that doesn't break in the
future.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
