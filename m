From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: smb2 work status
Date: Sat, 16 Jul 2011 15:28:11 -0400
Message-ID: <20110716192811.GE26925@infradead.org>
References: <CAKywueQqyi6ynwoAv6Q3GzbxYJSOv7k229N3NA_y05kguqA+DQ@mail.gmail.com>
 <CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Jul 16, 2011 at 01:29:22PM +0400, Pavel Shilovsky wrote:
> Jeff, Christoph, can you comment on this, please?

I really don't like all that ifdef mess.  I'm not quite sure how to
fix in in general, though.  For the inode operations it's fairly simple:
just have a different set for smb2, the only shared code is just the
path_from_dentry call, so there's not much duplication.  But for the
rest I'm not too sure.  Stubbing things out smarter would help, as
would creating more helpers but I'm not sure that's going to help
with everything.  Also some of the big bulk commits earlier in the
series add code that's pretty far from the normal Linux style, e.g.
smb2pdu.c, it would be nice to at least make the new code in cifs
look normal.
