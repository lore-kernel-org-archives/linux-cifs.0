From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Tue, 1 Mar 2011 14:37:39 -0600
Message-ID: <AANLkTimQZg_QDRUU7KroPT4oPsUqjpVeQxdnvT3XyCv7@mail.gmail.com>
References: <1298929961-5541-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110228224957.GB14237@fieldses.org>
	<AANLkTimDd-m388VJTC1zJtf3Q7LkFcsvNuwcY6vRwt7K@mail.gmail.com>
	<20110228234225.GC14237@fieldses.org>
	<AANLkTikeSEYOs_nzno40eM0ZSrStMqcziPzWGRViT5M-@mail.gmail.com>
	<20110228235910.GD14237@fieldses.org>
	<AANLkTinFwcBMmPpn0_30Bjaa+0ipoJ6qrM=u1TGQ+Q8g@mail.gmail.com>
	<20110301032808.GA17725@fieldses.org>
	<20110301180700.GC20599@fieldses.org>
	<AANLkTikNH0ujA-qram1=1JEqJ7DH6dLRR723YZgJde1+@mail.gmail.com>
	<20110301192102.GD20599@fieldses.org>
	<20110301150949.6ca5b880@tlielax.poochiereds.net>
	<AANLkTikc2GAe1+jRyuJGEJ8i5EBtoO-dayocL2yATMWQ@mail.gmail.com>
	<20110301153111.6673e191@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110301153111.6673e191-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If it is a write (at least nfsv4) we don't have this issue right?  We
will have an open, the open will have a dentry in cache so we will
have an inode num cached.

On Tue, Mar 1, 2011 at 2:31 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 1 Mar 2011 14:11:32 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> I vaguely remember that the same problem can occur with nfsd on a
>> local file system and that nfs clients have to be able to recover fr=
om
>> ESTALE (e.g. lookup/delete/create/lookup would fail with ESTALE
>> otherwise). =A0 Don't clients handle ESTALE by relooking up the file=
 ala
>>
>> http://lwn.net/Articles/272684/
>>
>
> In the case of writeback, what pathname will you use? The client just
> has an inode and that inode has a filehandle. The path hasn't been
> dealt with since the open().
>
> Even if it did want to retry a lookup, it's certainly possible that t=
he
> file has been renamed on the server or by another client. If that's t=
he
> case, the NFS client will have no valid path that it can reuse anyway=
=2E
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
