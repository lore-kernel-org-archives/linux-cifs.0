From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: mark CONFIG_CIFS_NFSD_EXPORT as BROKEN
Date: Mon, 23 May 2011 14:07:22 -0400
Message-ID: <20110523140722.45c4ffc6@tlielax.poochiereds.net>
References: <1306065324-24604-1-git-send-email-jlayton@redhat.com>
	<20110522115938.GA27941@infradead.org>
	<20110522081707.72cce108@corrin.poochiereds.net>
	<BANLkTim_K__5bqJG5snk+Bb+CW5dB70aQA@mail.gmail.com>
	<20110523071208.5dc935f8@corrin.poochiereds.net>
	<BANLkTikRqxGo3mm7h3w3-JL+Si6ZJYGPZQ@mail.gmail.com>
	<4DDA8BE6.8000001@plainjoe.org>
	<BANLkTikpWQaYRbaTGs5WtZ8zWrL8jeeQZQ@mail.gmail.com>
	<20110523134542.7d16be6d@tlielax.poochiereds.net>
	<BANLkTinX=CA_zeqNPhZpZD9JY3BNk08K_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Gerald Carter <jerry-I3iY/6WR96Zg9hUCZPvPmw@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinX=CA_zeqNPhZpZD9JY3BNk08K_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 23 May 2011 12:52:36 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, May 23, 2011 at 12:45 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Mon, 23 May 2011 11:58:50 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Mon, May 23, 2011 at 11:31 AM, Gerald Carter <jerry-I3iY/6WR96Ypug/h7KTFAQ@public.gmane.org=
g> wrote:
> >> > On 05/23/2011 08:42 AM, Steve French wrote:
> >> >
> >> >> Shirish had done some experiments (and AFAIK has a small patch
> >> >> that fixed NFS export over CIFS which works, with the usual res=
trictions
> >> >> about having to return ESTALE if the NFS client tries to access
> >> >> an inode which has been flushed from the cache on the server si=
de).
> >> >>
> >> >>>> For nfs v3 clients that can't handle ESTALE, we are probably
> >> >>>> stuck with having to wait for Samba to implement the flag
> >> >>> Flag?
> >> >>
> >> >> NTCreateX: =C2=A0FILE_OPEN_BY_FILE_ID
> >> >>
> >> >> IIRC Shirish verified that the Windows client will emit this fl=
ag, but their
> >> >> server had not gotten around to implementing it (although Samba=
 could
> >> >> implement it now that their is an open-by-handle syscall).
> >> >
> >> > Hey Jeff/Steve,
> >> >
> >> > I found in [MS-CIFS] that says a server MUST return STATUS_NOT_S=
UPPORTED
> >> > for this option.
> >> Yes - Microsoft has said that their servers do return
> >> STATUS_NOT_SUPPORTED but this is not "MUST" in exactly the same se=
nse
> >> as in an IETF RFC, and the discussion I had with JRA was about ser=
vers
> >> which support the Unix/POSIX extensions allowing this.
> >>
> >
> > Reality check -- this is only going to be useful iff:
> >
> > 1) such a thing were to materialize on the server side (and that wi=
ll
> > probably be in samba only)
> >
> > ...and...
> >
> > 2) someone writes the code to take advantage of it
> >
> > ...and that still won't fix the aforementioned problem with
> > directories.
>=20
> Hang on - it is useful already.   With Shirish's patch he was able to
> back up a Windows or Samba server via NFS.    For running more
> complicated applications for long periods of time - it depends on the
> NFS client whether ESTALE is handled or not - but at least ESTALE is =
a
> documented return code and that the Linux NFS implementation did not
> yet merge Peter Staubach's fix for ESTALE is a bug in Linux NFS (some
> OS do handle ESTALE properly).
>=20

Again, this is not reliable. Your backup in this case might work if
you're lucky, or it might not if the server happens to crash and reboot
or an inode gets pushed out of the cache. A NFS server that doesn't
work after a reboot is worse than useless -- it's risky.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
