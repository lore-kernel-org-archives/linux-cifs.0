From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount
 calls
Date: Fri, 24 Jun 2011 06:48:10 -0400
Message-ID: <20110624064810.495dec99@corrin.poochiereds.net>
References: <20110609124043.GA9621@infradead.org>
	<BANLkTikmfKtDxG_6qg+6JiCT2FzF1FFfQg@mail.gmail.com>
	<20110611094314.GA6217@infradead.org>
	<20110611111253.GD11521@ZenIV.linux.org.uk>
	<BANLkTim==J7=-bEz1pahhKuxFdMFe2BnWg@mail.gmail.com>
	<20110617035421.GO11521@ZenIV.linux.org.uk>
	<20110617140833.GA9563@ZenIV.linux.org.uk>
	<BANLkTi=mH-9F9N4Gz8JJqL==Hm5p8Y1_tQ@mail.gmail.com>
	<20110620085943.6371af1b@corrin.poochiereds.net>
	<BANLkTinfETnDdcBFkQNq8pLZPQOGsVRuGA@mail.gmail.com>
	<20110620161516.GU11521@ZenIV.linux.org.uk>
	<BANLkTi=nYfiy0qnHPXs2fckCPNJXwbpi7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=nYfiy0qnHPXs2fckCPNJXwbpi7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 24 Jun 2011 12:47:42 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/6/20 Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>:
> > On Mon, Jun 20, 2011 at 11:13:22AM -0500, Steve French wrote:
> >> Would the plan be for Al to merge these out of his tree?
> >
> > Can do, if cifs folks are OK with it... =C2=A0Note that it's a regr=
ession since
> > the last merge window, so it probably ought to go to Linus before 3=
=2E0-final.
> >
>=20
> Al, what is the status of your patchset? Note, that you can add my
> "Acked-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>" tag as well if you
> need it.
>=20

Yes, I've looked over the set and it looks good to me. Nice cleanup,
Al. You can add my:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
