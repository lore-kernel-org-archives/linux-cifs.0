From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2 work status
Date: Mon, 18 Jul 2011 19:45:01 +0400
Message-ID: <CAKywueSP7p3pja6FociCPXDtcSuChDdHw1JqCwxyhnqMuP5ahg@mail.gmail.com>
References: <CAKywueQqyi6ynwoAv6Q3GzbxYJSOv7k229N3NA_y05kguqA+DQ@mail.gmail.com>
	<CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ@mail.gmail.com>
	<20110716192811.GE26925@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110716192811.GE26925-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/7/16 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>:
> On Sat, Jul 16, 2011 at 01:29:22PM +0400, Pavel Shilovsky wrote:
>> Jeff, Christoph, can you comment on this, please?
>
> I really don't like all that ifdef mess. =A0I'm not quite sure how to
> fix in in general, though. =A0For the inode operations it's fairly si=
mple:
> just have a different set for smb2, the only shared code is just the
> path_from_dentry call, so there's not much duplication. =A0But for th=
e
> rest I'm not too sure. =A0Stubbing things out smarter would help, as
> would creating more helpers but I'm not sure that's going to help
> with everything. =A0Also some of the big bulk commits earlier in the
> series add code that's pretty far from the normal Linux style, e.g.
> smb2pdu.c, it would be nice to at least make the new code in cifs
> look normal.

Thanks for your comments!

If I understand you right, you mean to separate inode and file
operations for smb2 into a different structures, set them once with
ifdefs in cifs_set_ops() and keep them in smb2inode.c and smb2file.c
files.

As for the code style of new files - I am going to fix it soon.

--=20
Best regards,
Pavel Shilovsky.
