From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Sat, 3 Mar 2012 07:09:21 -0500
Message-ID: <20120303070921.5ce2bb10@tlielax.poochiereds.net>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 3 Mar 2012 12:35:50 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2012/2/28 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > This is going to be more complicated than it seems.
> >
> > Apparently (according to Chris), Windows will often allow mapmpx si=
multaneous
> > requests per process for various handle based requests. =C2=A0 In a=
ddition according
> > to JRA, Samba server does not care if you go beyond maxmpx (and the=
re is
> > a big performance advantage of that). =C2=A0 On the other hand - if=
 the server
> > sets maxmpx to less than 10, these kind of changes probably make se=
nse
> > (those servers are probably broken otherwise), but for normal serve=
rs
> > this will end up restricting more than windows (for more than than =
the
> > maxmpx per pid). =C2=A0 Generally, for servers like Samba that supp=
ort
> > simultaneous requests reasonably we have to be careful about killin=
g
> > performance especially now that with Jeff's async reads and writes
> > we will frequently get up to 50 (and should probably make it easier
> > to have more than 50 to servers like Samba).
> >
> > Quoting JRA and Volker - "You should be able to queue
> > thousands of simultaneous requests from one client to Samba"
> > (as long as the client doesn't time out. =C2=A0The server keeps
> > responding to the earlier requests, so with our client timeout
> > code weshould be fine).
> >
>=20
> If Samba supports more than 50 requests on fly why it doens't set
> MaxMpx count value appropriately (higher that 50). If some servers
> respect this value, some - not, why this value needs anyway? I really
> think that if it exists in the spec we must follow it's logic -
> support all servers that follow the CIFS/SMB spec.
>=20

Yeah, that seems crazy to me too. Why not simply have samba advertise a
more realistic value of MaxMpx if it's able to support one?

> From another hand, we won't kill the nowdays performance if we
> substract only 1 slot for echos and 1 slot for oplocks from maxmpx
> value (we have 48 for Samba anyway). But it helps us to make the code
> more common and easily shareble between existing cifs code and new
> smb2 one (for smb2 we should reserve these 2 slots too).
>=20
> I really think we shouldn't fix all the problems with one patch. This
> patch doesn't make things worse but better: it solves the problem wit=
h
> 3rd party servers and doesn't make the performance worse (there is no
> much difference between 48 and 50 simultaneous requests for io
> operations).
>=20
> While we can change the behavior for some special cases (Samba,
> Windows) later to make them faster, etc, I think we shouldn't stop on
> the current patch - it fixes the existing bug and it is the essential
> step we should do before SMB2 comes to the tree.
>=20

I agree wholeheartedly. Let's code to the spec we have first and only
afterward worry about adding hacks for servers that deviate from it.

=46WIW, I feel that it is absolutely essential that we clean this code =
up
and get it right before we can merge any further SMB2 code as it's
fundamental.

Now that said, I think Steve's objection is more related to blocking
locks than oplock breaks or echoes. The existing code does this in
wait_for_free_request:

	/* update # of requests on the wire to server */
	if (long_op !=3D CIFS_BLOCKING_OP)
		atomic_inc(&server->inFlight);

=2E..so blocking locks are not currently counted against "inFlight". Th=
e
big question is whether windows clients do something similar here.

If they do then we can probably reasonably assume that most servers
are designed to deal with that fact. If not, then we'll need to come up
with some way to deal with pessimal cases like this:

Suppose I have a MaxMpx of 50, and a task on the client locks a file.
Then, 50 more threads go to lock the same file with blocking lock
calls. At that point all of the slots are presumably consumed. How do
we ensure that the thread holding the lock can issue an unlock call so
we can make progress?

Also, suppose we have maxmpx =3D=3D 1. Can we even do blocking locks at
all? A single blocking lock will consume our only slot...

One thing we could consider is to stop using blocking locks at all. Or,
use the Timeout field with a reasonable value of a few seconds and just
loop to emulate blocking. It would suck for lock "fairness", but we
could be reasonably sure that we won't end up sucking up the entire
maxmpx for long periods of time that way.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
