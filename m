From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: During negprot request, shouldn't cifs _always_ set the
 "extended security negotiation" bit in flags2 ?
Date: Sat, 24 Mar 2012 07:41:18 -0400
Message-ID: <20120324074118.63862cc6@tlielax.poochiereds.net>
References: <201203240531.10450.linux@kukkukk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?R8O8bnRlcg==?= Kukkukk <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201203240531.10450.linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 24 Mar 2012 05:31:09 +0100
G=C3=BCnter Kukkukk <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org> wrote:

> some background:
>=20
> cifs tried to connect to a XP box, which was joined to a domain.
> smbclient (and Mac) were working - cifs not.
>=20
> On that XP box GPOs (or others) were set in that way, that _only_
> NTLMSSP connections were allowed at all.
>=20
> During the "negotiate protocol" request, cifs does _not_ set the
> "extended security negotiation" bit in flags2.
>     in cifs terms: #define SMBFLG2_EXT_SEC cpu_to_le16(0x800)
> Cifs supports that - but does not offer that capability to the server=
=2E
>=20
> So the XP server did response to _not_ support extended security in
> the capabilities field...
> Cifs tried default ntlm - and failed to connect.
> Any mount options regarding "sec=3D....." don't help here!
>=20
> So shouldn't cifs _always_ set the "extended security negotiation" bi=
t in flags2
> during negprot (to get proper server caps)?
>=20
> Atm one can workaround with:
>=20
> echo 0x80080 > /proc/fs/cifs/SecurityFlags   or
> echo 0x80    > /proc/fs/cifs/SecurityFlags
>=20
> to force NTLMSSP.
>=20
> Cheers, G=C3=BCnter

=46WIW, specifying sec=3Dntlmssp should also work w/o mucking with the
entirely unintuitive SecurityFlags interface.

Now, *should* it set extsec bit unconditionally? Yes.

*Does* it? No.

The reasons for this are more or less an implementation detail in
cifs.ko. The problem is that cifs makes the decision about what
security mode to use far too early and doesn't have a mechanism to fall
back to select one properly based on what the server supports.

I proposed a set of patches to fix this a couple of years ago, but only
some were merged:

    [PATCH 00/11] cifs: overhaul of auth selection code

At the time, Steve insisted that the patchset allow users to specify
multiple sec=3D options at mount time and somehow respect them. I didn'=
t
see a way to do this cleanly and gave up in frustration.

The discussion surrounding that is here:

    http://lists.samba.org/archive/linux-cifs-client/2010-May/005972.ht=
ml


A new effort to clean up this mess would certainly be welcome from me,
but I found Steve's idea of how this should work to be unnecessarily
complicated. If someone does want to do this then I suggest the
scheme be fully written out beforehand so we can understand what the
expected behavior should be.

Personally, I think being able to specify multiple sec=3D options is no=
t
worth the trouble. At mount time, users can try a different one if the
specified one fails.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
