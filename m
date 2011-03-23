From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Wed, 23 Mar 2011 12:57:56 -0500
Message-ID: <AANLkTim0EDSppQ8_ngLZg2XqZi=vUrEL+SsMNcr8FR3F@mail.gmail.com>
References: <20110228235910.GD14237@fieldses.org>
	<AANLkTinFwcBMmPpn0_30Bjaa+0ipoJ6qrM=u1TGQ+Q8g@mail.gmail.com>
	<20110301032808.GA17725@fieldses.org>
	<20110301180700.GC20599@fieldses.org>
	<AANLkTikNH0ujA-qram1=1JEqJ7DH6dLRR723YZgJde1+@mail.gmail.com>
	<20110301192102.GD20599@fieldses.org>
	<20110301150949.6ca5b880@tlielax.poochiereds.net>
	<AANLkTikc2GAe1+jRyuJGEJ8i5EBtoO-dayocL2yATMWQ@mail.gmail.com>
	<20110301203445.GE20599@fieldses.org>
	<AANLkTikaGd6EzNBWkYrJM3upP4fnBUx4p7c_29cLReLX@mail.gmail.com>
	<20110301204807.GF20599@fieldses.org>
	<20110316113014.74766db6@tlielax.poochiereds.net>
	<4D80DAA5.6030106@likewise.com>
	<AANLkTik9hN2jVW6+=LnwY1xaCLqGBW6-BeG-=dmZgCnr@mail.gmail.com>
	<AANLkTikA6akj7GDM_H7ndbMvPc6rnRtZ_i_zEHMrG31H@mail.gmail.com>
	<AANLkTinbOJRmrudrCyQ9zHTSUr69RV-1NTyoc1NOFAjz@mail.gmail.com>
	<AANLkTincOKZ5YjN9cKYaTByu7DST7bzQvO5XESsStTDh@mail.gmail.com>
	<AANLkTi=2EpL2F=+t0eDuGv_OrkxtgNxxu02_iv+ashbU@mail.gmail.com>
	<AANLkTimLAg74dVMZqOrZ60CYe_94Q1ihwWGq7DaDTVyG@mail.gmail.com>
	<AANLkTin+NAGqF5EJjVJZ1tW62tQcjmJLP8njfGLqsFZQ@mail.gmail.com>
	<AANLkTinUiU47-621kVwignvL0Dud1nTYc1RhnHMKQQz2@mail.gmail.com>
	<AANLkTi=St7RiwyEy0Fq-P16cfSTEvN0-BEgWC4NOsujx@mail.gmail.com>
	<AANLkTik5HcN=Lz70fGD1wN6GkZkQy4BWa7Ovz4RNghA0@mail.gmail.com>
	<AANLkTimYByiDRRjwrcNM+HKK6t_hgoS_oWn3hXVbzkF+@mail.gmail.com>
	<AANLkTi=0aG4iOtJPxe2zZnx9hW2DUGGArnR6s_jioZ=E@mail.gmail.com>
	<AANLkTimsD73JRzhFTycYKZBcgL9q3VjA1Dpj8judwWFE@mail.gmail.com>
	<AANLkTikcSyXoqbBKG+0iyX1zN=TfYQ5dTH9BTSoLg-42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikcSyXoqbBKG+0iyX1zN=TfYQ5dTH9BTSoLg-42-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is useful list.  I will look through your questions, and
reposting comments to linux-cifs.

On Wed, Mar 23, 2011 at 10:58 AM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Steve,
>
> Some review comments (on smb2misc.c, will review the rest).
>
>
> smb2misc.c
>
> 1. =A0I think we should change check_smb2_hdr to look like check_smb_=
hdr.
> =A0 =A0ProtocolId and MessageId are compared twice.
yes. agreed.
> 2. =A0The mid is declared as __u16 in function check_smb2_hdr but in
> =A0 =A0function checkSMB2, it is declared as __u64.
Good catch.

> 3. =A0In function checkSMB2, we probably do not need the first else.
> 4. =A0In function checkSMB2, perhaps we should use CIFS_MAX_MSGSIZE i=
nstead
> =A0 =A0of variable CIFSMaxBufSize.
This is the similar to cifs (eventually we can change the pool size
and design for
SMB2, since optimal (and maximum possible) sizes for SMB2 requests are
far larger
than for cifs but this is reasonable for initial default for large buff=
ers
(affects readdir responses mainly, since Jeremy had done a readpages th=
at uses
an array of pages rather than large buffers for SMB2, since it is impra=
ctical
or impossible to allocate slab buffers large enough to hold smb2's larg=
e read
responses).   The comparison is:
                   len < (CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4)
simply because that is the size of the objects in the pool.


> 4. =A0Do we need to apply le64_to_cpu to smb->MessageId while compari=
ng
> =A0 =A0to mid?
No.   The MessageId is opaque (same as in cifs for the Mid, albeit for =
SMB2
much larger and doesn't wrap).



--=20
Thanks,

Steve
