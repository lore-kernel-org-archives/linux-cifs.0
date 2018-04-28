From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: copy_file_range and user space tools to do copy fastest
Date: Fri, 27 Apr 2018 23:18:41 -0600
Message-ID: <736468DE-36BE-471B-B5F2-DB3D0B3E892B@dilger.ca>
References: <CAH2r5mtRF-yS6stThuVzem+WFmxDqpGLwFvUPviYcmh9dXXwkA@mail.gmail.com>
 <EFCB08E9-C9B9-41AC-A398-4D552FC8EFC9@dilger.ca>
 <20180427234126.GA213261@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_F36350DE-BF6B-428E-B6C6-1E7E894AAAFE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Steve French <smfrench@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180427234126.GA213261@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--Apple-Mail=_F36350DE-BF6B-428E-B6C6-1E7E894AAAFE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 27, 2018, at 5:41 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
>=20
> On Fri, Apr 27, 2018 at 01:45:40PM -0600, Andreas Dilger wrote:
>> On Apr 27, 2018, at 12:25 PM, Steve French <smfrench@gmail.com> =
wrote:
>>>=20
>>> Are there any user space tools (other than our test tools and xfs_io
>>> etc.) that support copy_file_range?  Looks like at least cp and =
rsync
>>> and dd don't.  That syscall which now has been around a couple =
years,
>>> and was reminded about at the LSF/MM summit a few days ago, =
presumably
>>> is the 'best' way to copy a file fast since it tries all the
>>> mechanisms (reflink etc.) in order.
>>>=20
>>> Since copy_file_range syscall can be 100x or more faster for network
>>> file systems than the alternative, was surprised when I noticed that
>>> cp and rsync didn't support it.  It doesn't look like rsync even
>>> supports reflink either(although presumably if you call
>>> copy_file_range you don't have to worry about that), and =
reads/writes
>>> are 8K. See copy_file() in rsync/util.c
>>>=20
>>> In the cp command it looks like it can call the FICLONE IOCTL (see
>>> clone_file() in coreutils/src/copy.c) but doesn't call the expected
>>> "copy_file_range" syscall.
>>>=20
>>> In the dd command it doesn't call either - see dd_copy in =
corutils/src/dd.c
>>>=20
>>> Since it can be 100x or more faster in some cases to call
>>> copy_file_range than do reads/writes back and forth to do a copy
>>> (especially if network or clustered backend or cloud), what tools =
are
>>> the best to recommend?
>>>=20
>>> Would rsync or cp be likely to take patches to call the standard
>>> "copy_file_range" syscall
>>> (http://man7.org/linux/man-pages/man2/copy_file_range.2.html)?
>>> Presumably not if it has been two+ years ... but would be interested
>>> what copy tools to recommend to use instead.
>>=20
>> I would start with submitting a patch to coreutils, if you can figure
>> out that code enough to do so (I find it quite opaque).  Since it has
>> been in the kernel for a while already, it should be acceptable to =
the
>> upstream coreutils maintainers to use this interface.  Doubly so if =
you
>> include some benchmarks with CIFS/NFS clients avoiding network =
overhead
>> during the copy.
>>=20
>=20
> For cp (coreutils), apparently there was a concern that =
copy_file_range()
> expands holes; see the thread at
> =
https://lists.gnu.org/archive/html/bug-coreutils/2016-09/msg00020.html.
> Though, I'd think it could just be used on non-holes only.  And I =
don't think
> the size_t type of 'len' is a problem either, since it's the copy =
length, not
> the file size.  You just call it multiple times if the file is larger.

I think cp is already using SEEK_HOLE/SEEK_DATA and/or FIEMAP to =
determine
the mapped and sparse segments of the file, so it should be practical to
use copy_file_range() in conjunction with these to copy only the =
allocated
parts of the file.

Cheers, Andreas






--Apple-Mail=_F36350DE-BF6B-428E-B6C6-1E7E894AAAFE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlrkBDMACgkQcqXauRfM
H+Bpzw//QuS1htKV7SYg1PBkFULb2sEgI83jPjnPIebBIbPrkTBl+uMh79R1rm+P
sy5cQJZLdHTpV70IVyYE0KPiuCUx6PtCv21jT+MyTnqoRyaI8TV8v4yNURxgdKGn
V/nn0MHI7YsWAownf6jvE+2DN7brc9W1BEH8xJKai/nB2NHELKt+SVKaCzM9P6Uj
1bff71w66NhwF0FtulSZ01HmiFIsCufbZO8KyQ0ccNzX0eKNfkmnsFlY6KgnhZo5
6HD/rfx/TQAJ46Wanst8SC75twVyJeBMfXg1/uXYVWeut8BiCbJmccWVOxRs2NUF
wQsWOTzOvQkiEVji32i/HZR3p1OM1miXV3T3Cf5swnOezqVVBUfQXFDY1dgg0dKw
cfveJQVxuClh+x6+BMsYG/2vH03CNl3iz3AHMFyaq4qQOdvYzGoUc8b4x7GTcXk5
mXIRy3QU+H/crv21LspQRujJ4GefkU+HQpUv8bc3dVnJhw0a8/oP7xs0b3DYpcts
D55cNAePpT0A/IFTPw61xEwJg5EXpMO3bEHF8mtQrSJYm/1mBEiEQPiD9IiNkcbF
GjJeYTsj5G4x4F7BTnkBceVAmC2kDbhdix6DpIv8Y7dXYKssMGM/ui2sefSvrlXt
q4KCY9bhLKzOFmcv1QqrKoviedj24oHL7NpQzXThct8KfwHOza0=
=7zBj
-----END PGP SIGNATURE-----

--Apple-Mail=_F36350DE-BF6B-428E-B6C6-1E7E894AAAFE--
