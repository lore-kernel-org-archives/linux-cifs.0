From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use sensible file nlink values if unprovided
Date: Sat, 06 Jul 2013 06:52:16 -0400
Message-ID: <1373107936.2360.10.camel@tlielax.poochiereds.net>
References: <1372961186-19213-1-git-send-email-ddiss@suse.de>
	 <CAH2r5mtyaufgrOssd872OZzq32TQ8fyprE82aK8FV7MbxceU7g@mail.gmail.com>
	 <20130705184031.67afd669@f163.suse.de>
	 <1373061027.2261.14.camel@tlielax.poochiereds.net>
	 <CAH2r5msgztCnAZyvgmU3Y5Yupv-S=m1FXVzfN-RBQJbp0dRcyw@mail.gmail.com>
	 <1373063192.2261.21.camel@tlielax.poochiereds.net>
	 <614F550557B82C44AC27C492ADA391AA11ECE73C@TK5EX14MBXC284.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <614F550557B82C44AC27C492ADA391AA11ECE73C-Jfd81uAzPQtJjAzVvmUwVFir+X/St4rqwBk/1ggFUS45P9zcU8sUGwC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2013-07-06 at 00:13 +0000, Tom Talpey wrote:
> > I dunno...maybe it's time to ask dochelp for clarification on what =
sort of
> > semantics we should be expecting from this field?
>=20
> It'll all be in MS-FSA, which is pretty simple:
>=20
> 2.1.5.11.27   FileStandardInformation
> OutputBuffer is of type FILE_STANDARD_INFORMATION, as described in [M=
S-FSCC] section 2.4.38.
> Pseudocode for the operation is as follows:
> ...
> =EF=82=A7	OutputBuffer.NumberOfLinks set to the number of Link elemen=
ts in Open.File.LinkList, except if Link.IsDeleted field is TRUE (that =
is, the number of not-deleted links to the file).<116>
> =EF=82=A7	If OutputBuffer.NumberOfLinks is 0, set OutputBuffer.Delete=
Pending to 1.
>=20
> WBN 116 has an important statement however:
>=20
> <116> Section 2.1.5.11.27: This algorithm is only implemented by NTFS=
 and ReFS. The FAT, EXFAT, CDFS, and UDFS file systems always return 1.
>=20
>=20

Thanks! I probably should have read the spec before crying to dochelp ;=
)

I think that makes sense. So what we probably want to do is something
like (pseudocode):

if (nlink =3D=3D 0) {
	if (directory)
		nlink =3D 2;
	else if (regular file && !delete pending)
		nlink =3D 1;
}

=2E..IOW, leave it at 0 if delete pending is set. It would be preferabl=
e
to encapsulate this logic in a function too and call it from all of the
places where we want to fake up this value.

readdir is tricky since none of the non-POSIX infolevels seem to return
a NumberOfLinks value or a DeletePending flag. Probably best to just
fake them up as best we can and hope that a later getattr fetches the
correct value. If the dirent didn't have a link count of at least 1,
then it presumably wouldn't be visible to a FIND_* call.

Note too that this does mean that the server that David is trying to
work around is arguably broken. It's probably reasonable to go ahead an=
d
work around it since we need to do something similar for the readdir
case anyway, but it would be best to have them fix their server as well=
=2E

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
