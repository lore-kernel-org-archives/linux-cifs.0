From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Tue, 1 Mar 2011 15:31:11 -0500
Message-ID: <20110301153111.6673e191@tlielax.poochiereds.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikc2GAe1+jRyuJGEJ8i5EBtoO-dayocL2yATMWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 1 Mar 2011 14:11:32 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I vaguely remember that the same problem can occur with nfsd on a
> local file system and that nfs clients have to be able to recover from
> ESTALE (e.g. lookup/delete/create/lookup would fail with ESTALE
> otherwise).   Don't clients handle ESTALE by relooking up the file ala
> 
> http://lwn.net/Articles/272684/
> 

In the case of writeback, what pathname will you use? The client just
has an inode and that inode has a filehandle. The path hasn't been
dealt with since the open().

Even if it did want to retry a lookup, it's certainly possible that the
file has been renamed on the server or by another client. If that's the
case, the NFS client will have no valid path that it can reuse anyway.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
