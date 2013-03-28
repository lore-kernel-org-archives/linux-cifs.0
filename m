From: Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Packet signing and sequence numbers
Date: Wed, 27 Mar 2013 22:51:13 -0400
Message-ID: <5153B021.1010400@gmail.com>
References: <51536712.9060504@gmail.com> <20130327211115.1a09db9a@corrin.poochiereds.net> <CAH2r5mvz=U615HC_dNBsnRc8JYdJ7gEAQxQWa5JMS339z8x7MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2LSAAOORMMTHLNHANSEKD"
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvz=U615HC_dNBsnRc8JYdJ7gEAQxQWa5JMS339z8x7MQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2LSAAOORMMTHLNHANSEKD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/27/2013 10:15 PM, Steve French wrote:
> On Wed, Mar 27, 2013 at 8:11 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
>>
>> On Wed, 27 Mar 2013 17:39:30 -0400
>> Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> I notice the patch in this message
>>>
>>> http://thread.gmane.org/gmane.linux.kernel.cifs/7655/focus=3D7671
>>>
>>> Never made it into Linus's tree. It's also not in Debian or RedHat's
>>> kernels. I'm running into this on CentOS.
>>>
>>> Has there been any activity on this issue since December?
>>>
>>> Incidentally, I filed a bug report on bugs.redhat.com relating to wha=
t
>>> I'm hitting:
>>>
>>> https://bugzilla.redhat.com/show_bug.cgi?id=3D928516
>>>
>>
>> If you have a support contract with Red Hat, then it would be best to
>> open a support case, which will help make the case for its inclusion
>> into the RHEL kernel.
>>
>>> I'm looking for a good reason to (or to not) apply the patches to the=

>>> current RH kernel on my systems; I rather need it for my current proj=
ect.
>>>
>>> (I'd respond via the linux-cifs list, but Thunderbird is being a PITA=

>>> and preventing me from subscribing to it via gmane's NNTP, through wh=
ich
>>> I'd be able to reply to the thread directly...)
>>>
>>
>> You're correct that it never made it in. I think the patch makes
>> sense...Steve, was there some reason you didn't merge it?
>>
>> In the meantime, if you're able to test the patch and reply on-list
>> with the results then that would be helpful.
>>
>> Thanks,
>> --
>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
>=20
>=20
> I don't remember getting any other test feedback on it - do we have
> some additional tested-by to add (or anyone else review it).  I didn't
> personally try it (I was traveling during the holiday break when it
> was discussed) and I didn't see it in Jeff's tree so I assumed that he
> found a problem with it.
>=20
> Does it fix your situation?

I haven't tried it, but:

1) When I hit my problem symptoms, I hypothesized a probable cause.
(desync of crypto state between client and server)
2) The patch addresses the same class of bug.

Based on my understanding of the components involved, I think it highly
likely the patch will fix it. I do have a server I can test it on, so
I'll give it a try.

While I'm here, I'll raise one other thing...the code increments the
sequence number twice when preparing a send, once for the send, and once
for response. My gut tells me that it would be less sloppy to instead
increment once for send, and once at the time of receipt...but updating
the sequence number at that time might carry an unnecessary performance
penalty, and so perhaps that's a valid use of the server's receive
window. (I haven't studied the protocol in depth, though, so I might be
way off.)



------enig2LSAAOORMMTHLNHANSEKD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRU7AlAAoJED5TcEBdxYwQODIH/jJ06ks5hjPtZzjwYtuEMRcn
bLSvlKpKZvXIfPyWndOhcoYrjF4t3pOm9F8hwELj50agTiNOz11UaFxHiV+UPp0x
nRh3EzBi1urijxzLBl++e38z9mOW5wz7vh7I2GnIfS91IMAEDy2JBZ4RjYxdApHl
UCnwFExpVV8B9Fka7nMazeOz3JPKl10d/ZcHXOr1lCWda1ir7IvLUbwnK7IWyQ2k
SVv6bL2thOIer7Hzle41C3u4tBzqdsfaDMPgPyoHoMN4O4osju+MkehonZ2Y18lj
yWX+oK/6zpUsQU0vXuQIwGHrYfNqvCTnLMNcyHK0G+QBzrhUw738tl6JEb+XlOQ=
=XJX6
-----END PGP SIGNATURE-----

------enig2LSAAOORMMTHLNHANSEKD--
