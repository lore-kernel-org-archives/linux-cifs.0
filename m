From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] cifs: don't perform SMB echoes on un-negotiated
 socket
Date: Mon, 7 Feb 2011 16:57:26 -0500
Message-ID: <20110207165726.7141bb4b@tlielax.poochiereds.net>
References: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
	<AANLkTi=zs7KZjTnysqxpnGam+2Mv3FRTCKZcY8fB0uFU@mail.gmail.com>
	<20110207132036.7af97f8f@tlielax.poochiereds.net>
	<AANLkTikD-Q9A5VxfkbkL-Yg9CjwCTNSoyA9W2biHCOA2@mail.gmail.com>
	<20110207161414.1694cad0@tlielax.poochiereds.net>
	<AANLkTiktLMYNi=crSh+NaE2=6qfWgw=ohLjKhp77sJt+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTiktLMYNi=crSh+NaE2=6qfWgw=ohLjKhp77sJt+-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 7 Feb 2011 15:29:05 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Feb 7, 2011 at 3:14 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Mon, 7 Feb 2011 12:36:22 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Mon, Feb 7, 2011 at 12:20 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> >> > On Mon, 7 Feb 2011 11:42:05 -0600
> >> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> On Mon, Feb 7, 2011 at 7:54 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org=
> wrote:
> >> >> > Commit 247ec9b4 makes the SMB echo workqueue job skip doing e=
choes
> >> >> > unless the tcpStatus =3D=3D CifsGood. Problem: tcpStatus =3D=3D=
 CifsGood is not
> >> >> > a reliable indicator of whether the socket has had a NEGOTIAT=
E done on
> >> >> > it. This fixes that by adding a new tcpStatus of CifsNeedNego=
tiate that
> >> >> > indicates this. It also cleans up cifs_reconnect_tcon a bit.
> >> >> >
> >> >> > This is not the only way to fix this issue. As Steve pointed =
out to me,
> >> >> > we could also check to see whether there's a valid SMB sessio=
n on the
> >> >> > list as an indicator of whether a NEGOTIATE has been done. I =
think the
> >> >> > approach I'm proposing clarifies the code better, but I'm wil=
ling to go
> >> >> > with his approach if that's the general concensus.
> >> >>
> >> >> Jeff may be right that the code is clearer with this approach (=
I may try
> >> >> to code the alternative to check) but ... we really shouldn't b=
e sending
> >> >> an SMBecho between negprot and sessionsetup anyway (so checking=
 for
> >> >> sessionsetup may make sense).
> >> >> =A0If a negprot times out or
> >> >> sessionsetup times out we don't need to be sending SMBecho
> >> >> (on the other hand perhaps a really slow krb5 sessionsetup?)
> >> >> Once a sessionsetup is sent, SMBechos make more sense.
> >> >>
> >> >
> >> > Why shouldn't we send one between the negotiate and session setu=
p? The
> >> > MS-CIFS spec makes no mention that a session setup is required p=
rior to
> >> > doing an echo. You may be correct, but that's not really what th=
e spec
> >> > says.
> >>
> >> I don't remember ever having seen one between negprot and sessions=
etup
> >> from other clients - but the broader point is that an SMBecho does=
n't
> >> serve any purpose in between negprot/sessionsetup (once at least o=
ne
> >> session is setup, checking if the server stays up is more interest=
ing)
> >>
> >
> > I'm not sure I agree there. There's nothing that says that the
> > NEGOTIATE and SESSION_SETUP have to be done within a certain amount=
 of
> > time of each other. Checking the validity of the connection there s=
eems
> > reasonable.
> >
> > ...but at this point, if you think checking for a valid session is =
the
> > best approach then so be it.
>=20
> I am not convinced which way is best and it likely doesn't matter.
>=20
> > Practically, how do you suggest that we check for a valid SMB sessi=
on?
> > I assume the code will need to walk the smb_ses_list. The ses->stat=
us
> > doesn't appear to actually change on reconnect however. It only set=
s
> > the "need_reconnect" boolean.
> >
> > It appears that the ses->status is set to CifsGood and never change=
s
> > after the initial session setup. Perhaps that field should be remov=
ed?
>=20
> aah - that makes it tougher to check.  If we don't mark ses->Status =3D=
=3D
> NEED_RECONNECT
> or something other than CifsGood then your approach is easier.
>=20

Well, we do mark a need_reconnect boolean which we could check, but
what about sessions that are just being established for the first time?
They typically don't go on the list until they are established, but I
don't really want to depend on that since that's really an
implementation detail.

The ad hoc nature of a lot of this code makes me worry that future
changes to it could break things. The fields that are intended to track
state are not clearly defined, so it's hard to depend on any of this
without clearly defining what the states actually represent. The
locking around the state variables doesn't follow any clear rules
either.

This code is probably ripe for cleanup, but I'm not going to embark on
that for 2.6.38. Would it be reasonable to take the patches I've
already proposed and we can discuss approaches to clean this code up
when we're at Connectathon in a few weeks?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
