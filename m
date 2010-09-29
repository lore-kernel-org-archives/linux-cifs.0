From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] cifs: set backing_dev_info on new S_ISREG inodes
Date: Wed, 29 Sep 2010 19:17:30 -0400
Message-ID: <20100929231730.GA6921@infradead.org>
References: <1285768194-29595-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1285768194-29595-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 29, 2010 at 09:49:54AM -0400, Jeff Layton wrote:
> Testing on very recent kernel (2.6.36-rc6) made this warning pop:
> 
>     WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x65/0x70()
>     Hardware name:
>     Dirtiable inode bdi default != sb bdi cifs
> 
> ...the following patch fixes it and seems to be the obviously correct
> thing to do for cifs.

See my patch in the btrfs/default_backing_dev_info thread for the real
fix for the underlying issue.  But your patch won't harm either way.
