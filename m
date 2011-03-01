From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Tue, 1 Mar 2011 14:38:27 -0600
Message-ID: <AANLkTikaGd6EzNBWkYrJM3upP4fnBUx4p7c_29cLReLX@mail.gmail.com>
References: <20110228234225.GC14237@fieldses.org>
	<AANLkTikeSEYOs_nzno40eM0ZSrStMqcziPzWGRViT5M-@mail.gmail.com>
	<20110228235910.GD14237@fieldses.org>
	<AANLkTinFwcBMmPpn0_30Bjaa+0ipoJ6qrM=u1TGQ+Q8g@mail.gmail.com>
	<20110301032808.GA17725@fieldses.org>
	<20110301180700.GC20599@fieldses.org>
	<AANLkTikNH0ujA-qram1=1JEqJ7DH6dLRR723YZgJde1+@mail.gmail.com>
	<20110301192102.GD20599@fieldses.org>
	<20110301150949.6ca5b880@tlielax.poochiereds.net>
	<AANLkTikc2GAe1+jRyuJGEJ8i5EBtoO-dayocL2yATMWQ@mail.gmail.com>
	<20110301203445.GE20599@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110301203445.GE20599-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 1, 2011 at 2:34 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> =
wrote:
> On Tue, Mar 01, 2011 at 02:11:32PM -0600, Steve French wrote:
>> I vaguely remember that the same problem can occur with nfsd on a
>> local file system
>
> Not true; as I've said, exportable local filesystems know how to look=
 up
> a file on disk by filehandle.
>
>> and that nfs clients have to be able to recover from
>> ESTALE (e.g. lookup/delete/create/lookup would fail with ESTALE
>> otherwise).
>
> It is true, however, that there are some *other* cases when a server =
can
> return ESTALE. =A0In those cases (such as the one Peter Staubach disc=
usses
> in more detail at http://lwn.net/Articles/272684/) there may be some
> recovery that a client might reasonably attempt.
>
> Alas, no client can be expected to recover from ESTALE errors on an
> opened file--those will just be passed on to the application.

If this is v4 (only) wouldn't we always have an open->dentry in cache?



--=20
Thanks,

Steve
