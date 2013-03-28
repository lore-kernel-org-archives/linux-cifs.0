From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Packet signing and sequence numbers
Date: Thu, 28 Mar 2013 06:52:34 -0400
Message-ID: <20130328065234.60801d2f@corrin.poochiereds.net>
References: <51536712.9060504@gmail.com>
 <20130327211115.1a09db9a@corrin.poochiereds.net>
 <CAH2r5mvz=U615HC_dNBsnRc8JYdJ7gEAQxQWa5JMS339z8x7MQ@mail.gmail.com>
 <5153B021.1010400@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L65ftAdB5Ci9AL3ROPkW2if"; protocol="application/pgp-signature"
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5153B021.1010400-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/L65ftAdB5Ci9AL3ROPkW2if
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Mar 2013 22:51:13 -0400
Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On 03/27/2013 10:15 PM, Steve French wrote:
> > On Wed, Mar 27, 2013 at 8:11 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >> On Wed, 27 Mar 2013 17:39:30 -0400
> >> Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> I notice the patch in this message
> >>>
> >>> http://thread.gmane.org/gmane.linux.kernel.cifs/7655/focus=3D7671
> >>>
> >>> Never made it into Linus's tree. It's also not in Debian or RedHat's
> >>> kernels. I'm running into this on CentOS.
> >>>
> >>> Has there been any activity on this issue since December?
> >>>
> >>> Incidentally, I filed a bug report on bugs.redhat.com relating to what
> >>> I'm hitting:
> >>>
> >>> https://bugzilla.redhat.com/show_bug.cgi?id=3D928516
> >>>
> >>
> >> If you have a support contract with Red Hat, then it would be best to
> >> open a support case, which will help make the case for its inclusion
> >> into the RHEL kernel.
> >>
> >>> I'm looking for a good reason to (or to not) apply the patches to the
> >>> current RH kernel on my systems; I rather need it for my current proj=
ect.
> >>>
> >>> (I'd respond via the linux-cifs list, but Thunderbird is being a PITA
> >>> and preventing me from subscribing to it via gmane's NNTP, through wh=
ich
> >>> I'd be able to reply to the thread directly...)
> >>>
> >>
> >> You're correct that it never made it in. I think the patch makes
> >> sense...Steve, was there some reason you didn't merge it?
> >>
> >> In the meantime, if you're able to test the patch and reply on-list
> >> with the results then that would be helpful.
> >>
> >> Thanks,
> >> --
> >> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >=20
> >=20
> >=20
> > I don't remember getting any other test feedback on it - do we have
> > some additional tested-by to add (or anyone else review it).  I didn't
> > personally try it (I was traveling during the holiday break when it
> > was discussed) and I didn't see it in Jeff's tree so I assumed that he
> > found a problem with it.
> >=20

I think I thought you had merged it for 3.8 and dropped it. I never saw
any problems with it. Let's get it in for 3.9.

> > Does it fix your situation?
>=20
> I haven't tried it, but:
>=20
> 1) When I hit my problem symptoms, I hypothesized a probable cause.
> (desync of crypto state between client and server)
> 2) The patch addresses the same class of bug.
>=20
> Based on my understanding of the components involved, I think it highly
> likely the patch will fix it. I do have a server I can test it on, so
> I'll give it a try.
>=20
> While I'm here, I'll raise one other thing...the code increments the
> sequence number twice when preparing a send, once for the send, and once
> for response. My gut tells me that it would be less sloppy to instead
> increment once for send, and once at the time of receipt...but updating
> the sequence number at that time might carry an unnecessary performance
> penalty, and so perhaps that's a valid use of the server's receive
> window. (I haven't studied the protocol in depth, though, so I might be
> way off.)
>=20
>=20

No, I think you're quite right. It would be much cleaner to do it that
way. That's a bit more of an overhaul though, and I think the patch is
appropriate as-is for now.

Cheers,
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--Sig_/L65ftAdB5Ci9AL3ROPkW2if
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRVCDyAAoJEAAOaEEZVoIVMA4QAJ2HZwALivzkvwcfh1qEr3Fw
vbmS7xeb4CAOWJ4b4wNrQ7bbsE/6toTfaQ3SowFmTNbeo4yOoVH7uRYYwkZyPIC5
3togwxcfzrp6kYdJvz1gLPjbsZBz1ktpUh/bwcsk1X6xIkLlCRbvTkuNwJjXLWz7
Jyv1UOdKUQRnYqjOCDF8y11XMZPmbb5wOUoD4dy6zVexLbexoldfJRvbc1sjsNZ3
IeH+KirrCRKh9N3/aaaKPTU6kZD3C5uU/hjqjFJs4A/nMp98YvOOBYFC9uUk5NV6
FQtHCovJ8wBPC13EoYGnSuMfdkpoHIV4xCdeXeCiQPPSMW5EuKZojH8bkURMaHny
W7R7Mi0GZb87ivHkVZfAyTV1ymL5rXRBCqYbCEPHBmiZwpSQQteiMQjyXFijLiEt
g5uJpa9gJc0ELtfogXheMuN0w2V+PeUsLahLtBTueJ0lkZIdmWUHuPkck8j4HoM/
jzICkayabbyysW2lc5l7EcszrvAmTg9wSWG+W9jHih0n5mSs8BzNOJp4AE/QO1NI
dpKI5P+gFHzNgpVSFAv6woKa+d+HmVqyXl4UdO2cGXBITTTuWOBzvdg6mh89gES5
tGWByxB76kHy8ZKaqHI56RTsnEVQwCuKLXrGl0OGM6dXN4eDlx0juIU3D0Kq0pOl
JtrELb3MT6eBj6XwxXLH
=LXeb
-----END PGP SIGNATURE-----

--Sig_/L65ftAdB5Ci9AL3ROPkW2if--
