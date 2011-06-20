From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount
 calls
Date: Mon, 20 Jun 2011 08:59:43 -0400
Message-ID: <20110620085943.6371af1b@corrin.poochiereds.net>
References: <1307622570-7141-1-git-send-email-piastryyy@gmail.com>
	<20110609124043.GA9621@infradead.org>
	<BANLkTikmfKtDxG_6qg+6JiCT2FzF1FFfQg@mail.gmail.com>
	<20110611094314.GA6217@infradead.org>
	<20110611111253.GD11521@ZenIV.linux.org.uk>
	<BANLkTim==J7=-bEz1pahhKuxFdMFe2BnWg@mail.gmail.com>
	<20110617035421.GO11521@ZenIV.linux.org.uk>
	<20110617140833.GA9563@ZenIV.linux.org.uk>
	<BANLkTi=mH-9F9N4Gz8JJqL==Hm5p8Y1_tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=mH-9F9N4Gz8JJqL==Hm5p8Y1_tQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 20 Jun 2011 16:54:48 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/6/17 Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>:
> > On Fri, Jun 17, 2011 at 04:54:21AM +0100, Al Viro wrote:
> >
> >> See #untested in vfs-2.6.git; I *hope* I've got all the leaks in c=
urrent
> >> mainline plugged and all sget() races ought to be taken care of. =C2=
=A0And
> >> yes, the branch name matches the reality - this sucker is complete=
ly
> >> untested. =C2=A0Have fun... =C2=A0Commit message is atrocious, of =
course - I'm too
> >> tired to even try writing a coherent patch description at the mome=
nt and
> >> I'll probably need to split it into several patches anyway. =C2=A0=
Tomorrow...
> >
> > Updated, split up, pushed into #untested. =C2=A0Enjoy...
> >
>=20
> Today I tried this branch and it was ok.
>=20
> Steve, Jeff, what do you think?
>=20

I did some light testing on it over the weekend and it looks good to me
as well. Nice cleanup, Al.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
