From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Sun, 12 Sep 2010 09:16:59 -0400
Message-ID: <20100912091659.73ef9cdb@tlielax.poochiereds.net>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
	<AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK@mail.gmail.com>
	<20100908063224.240b0419@corrin.poochiereds.net>
	<AANLkTinYFe6O-4ANt1VYcvEMukiis-11cDuMP2GSKZ7j@mail.gmail.com>
	<AANLkTin+qiQsF_hOCvdBKtCh0n0bcd82RDOUz=h3K6gu@mail.gmail.com>
	<AANLkTikOR_HU934L6FKq8q2ZwcaTTOTPfaSofimK6OFH@mail.gmail.com>
	<AANLkTi=zc7G847VHqVjO7LRfLkzzSGsJURvJmH1C8gOQ@mail.gmail.com>
	<AANLkTikXWGNtuOjPbG0wAdHLuVQOVuouaUaBi4HRwSR-@mail.gmail.com>
	<20100910081549.41de32d1@corrin.poochiereds.net>
	<AANLkTi=5YgKzG=rXJ5MuV+R_MGkEd+2ERouUiEc8K5B8@mail.gmail.com>
	<20100910185002.73e61b8b@tlielax.poochiereds.net>
	<AANLkTik_=xi5Engkm4Xcrk_WUaXSsSAsWUhh=M8VYWer@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik_=xi5Engkm4Xcrk_WUaXSsSAsWUhh=M8VYWer-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 11 Sep 2010 11:08:15 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/9/11 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > So what? Why should the writer know anything about whether it succe=
eds
> > before a flush or close occurs? POSIX does not mandate that. If you=
 are
> > able to report an error at write time, then that's fine. It's not
> > required however.
>=20
> We can write a data in write_end call all the time when we don't have
> an oplock for writing. If we get an error we simply returned it in
> from write_end and an application gets it.
>=20

I don't understand the above statement. Can you clarify it?

> > That's not how I read this:
> >
> > 57: server downgrades oplock on 0x0001 to level 2
> > 60: client drops oplock altogether for 0x0001 (note that it replies
> > =A0 =A0with oplock level 0)
> > 65: server revokes oplock on 0x0002 altogether
> > 66: client "acks" the oplock break
> >
> > At that point there are no more oplocks held. Why would the server =
need
> > to send another oplock break?
>=20
> It (60) is the Oplock Break acknowledge request that's sent by the
> client on the server's Oplock Break Notification (57). According to
> the spec (page 214, section 2.2.4.32.1 of [MS-CIFS].pdf)
> NewOpLockLevel field is used by the server to indicate new oplock
> level for the FID. There no words that says that this field is used b=
y
> the client in acknowledge. An acknowledge is only used to indicate
> that all the dirty data and byte-range locks are flushed to the serve=
r
> and doesn't bring any other information. It's my understanding of the
> spec.
>=20
> Even more, CIFS client does it according to the spec (file.c, line 23=
41):
>=20
>         if (!cfile->closePend && !cfile->oplock_break_cancelled) {
>                 rc =3D CIFSSMBLock(0, cifs_sb->tcon, cfile->netfid, 0=
, 0, 0, 0,
>=20
> LOCKING_ANDX_OPLOCK_RELEASE, false);
>                 cFYI(1, "Oplock release rc =3D %d", rc);
>         }
>=20
> and there is no mention of OplockLevel in CIFSSMBLock call.
>=20
> So, as you can see above: there is no value that is set to OplockLeve=
l
> field of SMB_COM_LOCKING_ANDX command.
>=20
> That's why I said that client1 continues keeping the level II oplock.
>=20

That's just because our client is primitive in this regard. When an
oplock break comes in, it always drops the entire oplock rather than
trying to downgrade it.

Notice that when the client sends the "reply" that it's actually a
request. The client never sends an actual "response" to an oplock
break. What it does is send a new LOCKING_ANDX request to the server
with a Lock Type of oplock break (0x02) and an oplock level of 0.

My interpretation has always been that this "response" from the client
tells the server what new oplock level the client has elected to take.
In this case, it elected to drop the lock altogether so the server has
no need to send a new oplock break.

I'll concede though that the spec is nebulous here. It might be
worthwhile to make a dochelp request to MS on this point.=20

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
