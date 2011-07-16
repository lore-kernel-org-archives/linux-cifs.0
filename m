From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2 work status
Date: Sat, 16 Jul 2011 13:29:22 +0400
Message-ID: <CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ@mail.gmail.com>
References: <CAKywueQqyi6ynwoAv6Q3GzbxYJSOv7k229N3NA_y05kguqA+DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQqyi6ynwoAv6Q3GzbxYJSOv7k229N3NA_y05kguqA+DQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/7/12 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Hi all!
>
> Here is my last update of SMB2 code development. What now works:
> 1) mount/umount.
> 2) stat, mkdir, rmdir, rm.
> 3) open/reopen/close, direct read/write.
>
> The work branch is
> http://git.etersoft.ru/people/piastry/packages/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev
> (rebased to current master).
>
> Your comments are appreciated!
>
> --
> Best regards,
> Pavel Shilovsky.
>

Jeff, Christoph, can you comment on this, please?

-- 
Best regards,
Pavel Shilovsky.
