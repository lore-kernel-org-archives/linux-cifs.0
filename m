From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 05/10] nfsd: don't keep a pointer to the lease in
 nfs4_file
Date: Sun, 24 Aug 2014 08:51:32 -0700
Message-ID: <20140824155132.GD15908@infradead.org>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
 <1408804878-1331-6-git-send-email-jlayton@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1408804878-1331-6-git-send-email-jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Aug 23, 2014 at 10:41:13AM -0400, Jeff Layton wrote:
> Now that we don't need to pass in an actual lease pointer to
> vfs_setlease on unlock, we can stop tracking a pointer to the lease in
> the nfs4_file.
> 
> Switch all of the places that check the fi_lease to check fi_deleg_file
> instead. We always set that at the same time so it will have the same
> semantics.
> 
> Signed-off-by: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
