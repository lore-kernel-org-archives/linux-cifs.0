From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 04/10] locks: clean up vfs_setlease kerneldoc comments
Date: Mon, 25 Aug 2014 16:11:46 -0400
Message-ID: <20140825201146.GC21957@fieldses.org>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
 <1408804878-1331-5-git-send-email-jlayton@primarydata.com>
 <20140824155117.GC15908@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140824155117.GC15908-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Sun, Aug 24, 2014 at 08:51:17AM -0700, Christoph Hellwig wrote:
> On Sat, Aug 23, 2014 at 10:41:12AM -0400, Jeff Layton wrote:
> > Some of the latter paragraphs seem ambiguous and just plain wrong.
> > In particular the break_lease comment makes no sense. We call
> > break_lease (and break_deleg) from all sorts of vfs-layer functions,
> > so there is clearly such a method.

Right, but there's no f_op->break_lease.  Anyway:

> > Also, we are close to being able to allow for "real" filesystem
> > setlease methods so remove the final comment about it not being a
> > full implementation yet.
> 
> I'd remove even more:
> 
> > + *
> > + * This will call the filesystem's setlease file method, if defined. Note that
> > + * there is no getlease method; instead, the filesystem setlease method should
> > + * call back to generic_setlease() to add a lease to the inode's lease list,
> > + * where fcntl_getlease() can find it.  Since fcntl_getlease() only reports
> > + * whether the current task holds a lease, a cluster filesystem need only do
> > + * this for leases held by processes on this node.
> >   */
> 
> If we'd ever want a full implementation I think we'd absolutely need
> the getlease method.  But instead of hypothetizing about future
> implementation I'd rather leave it to those actually implementing such
> support, if that ever happens.

I agree, that makes sense.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
