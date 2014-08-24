From: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH 03/10] locks: generic_delete_lease doesn't need a
 file_lock at all
Date: Sun, 24 Aug 2014 06:09:31 -0400
Message-ID: <20140824060931.30501a5b@synchrony.poochiereds.net>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
	<1408804878-1331-4-git-send-email-jlayton@primarydata.com>
	<20140824012757.GA21609@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140824012757.GA21609-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Sat, 23 Aug 2014 18:27:57 -0700
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Sat, Aug 23, 2014 at 10:41:11AM -0400, Jeff Layton wrote:
> > +static int generic_delete_lease(struct file *filp)
> >  {
> >  	struct file_lock *fl, **before;
> >  	struct dentry *dentry = filp->f_path.dentry;
> >  	struct inode *inode = dentry->d_inode;
> >  
> > -	trace_generic_delete_lease(inode, *flp);
> > -
> 
> Can you keep the tracepoint and modify it to not need the file_lock
> pointer?  It really helped me with some debugging lately.
> 
> Otherwise looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Doh! Yes, I meant to put that back. Will do on the next respin.

Thanks,
-- 
Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
