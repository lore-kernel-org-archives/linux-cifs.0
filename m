From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Sat, 11 Sep 2010 11:08:15 +0400
Message-ID: <AANLkTik_=xi5Engkm4Xcrk_WUaXSsSAsWUhh=M8VYWer@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910185002.73e61b8b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/9/11 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> So what? Why should the writer know anything about whether it succeed=
s
> before a flush or close occurs? POSIX does not mandate that. If you a=
re
> able to report an error at write time, then that's fine. It's not
> required however.

We can write a data in write_end call all the time when we don't have
an oplock for writing. If we get an error we simply returned it in
from write_end and an application gets it.

> That's not how I read this:
>
> 57: server downgrades oplock on 0x0001 to level 2
> 60: client drops oplock altogether for 0x0001 (note that it replies
> =A0 =A0with oplock level 0)
> 65: server revokes oplock on 0x0002 altogether
> 66: client "acks" the oplock break
>
> At that point there are no more oplocks held. Why would the server ne=
ed
> to send another oplock break?

It (60) is the Oplock Break acknowledge request that's sent by the
client on the server's Oplock Break Notification (57). According to
the spec (page 214, section 2.2.4.32.1 of [MS-CIFS].pdf)
NewOpLockLevel field is used by the server to indicate new oplock
level for the FID. There no words that says that this field is used by
the client in acknowledge. An acknowledge is only used to indicate
that all the dirty data and byte-range locks are flushed to the server
and doesn't bring any other information. It's my understanding of the
spec.

Even more, CIFS client does it according to the spec (file.c, line 2341=
):

        if (!cfile->closePend && !cfile->oplock_break_cancelled) {
                rc =3D CIFSSMBLock(0, cifs_sb->tcon, cfile->netfid, 0, =
0, 0, 0,

LOCKING_ANDX_OPLOCK_RELEASE, false);
                cFYI(1, "Oplock release rc =3D %d", rc);
        }

and there is no mention of OplockLevel in CIFSSMBLock call.

So, as you can see above: there is no value that is set to OplockLevel
field of SMB_COM_LOCKING_ANDX command.

That's why I said that client1 continues keeping the level II oplock.

--=20
Best regards,
Pavel Shilovsky.
