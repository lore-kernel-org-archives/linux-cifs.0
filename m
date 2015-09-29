From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm, fs: Obey gfp_mapping for add_to_page_cache
Date: Tue, 29 Sep 2015 15:02:46 -0700
Message-ID: <20150929150246.286cc6013bce3eec170376aa@linux-foundation.org>
References: <1443193461-31402-1-git-send-email-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	"Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>,
	Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
To: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443193461-31402-1-git-send-email-mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 25 Sep 2015 17:04:21 +0200 mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> 6afdb859b710 ("mm: do not ignore mapping_gfp_mask in page cache
> allocation paths) has caught some users of hardcoded GFP_KERNEL
> used in the page cache allocation paths. This, however, wasn't complete
> and there were others which went unnoticed.
> 
> Dave Chinner has reported the following deadlock for xfs on loop device:
> : With the recent merge of the loop device changes, I'm now seeing
> : XFS deadlock on my single CPU, 1GB RAM VM running xfs/073.
> :
> : The deadlocked is as follows:
> :
> : kloopd1: loop_queue_read_work
> :       xfs_file_iter_read
> :       lock XFS inode XFS_IOLOCK_SHARED (on image file)
> :       page cache read (GFP_KERNEL)
> :       radix tree alloc
> :       memory reclaim
> :       reclaim XFS inodes
> :       log force to unpin inodes
> :       <wait for log IO completion>
> :
> : xfs-cil/loop1: <does log force IO work>
> :       xlog_cil_push
> :       xlog_write
> :       <loop issuing log writes>
> :               xlog_state_get_iclog_space()
> :               <blocks due to all log buffers under write io>
> :               <waits for IO completion>
> :
> : kloopd1: loop_queue_write_work
> :       xfs_file_write_iter
> :       lock XFS inode XFS_IOLOCK_EXCL (on image file)
> :       <wait for inode to be unlocked>
> :
> : i.e. the kloopd, with it's split read and write work queues, has
> : introduced a dependency through memory reclaim. i.e. that writes
> : need to be able to progress for reads make progress.
> :
> : The problem, fundamentally, is that mpage_readpages() does a
> : GFP_KERNEL allocation, rather than paying attention to the inode's
> : mapping gfp mask, which is set to GFP_NOFS.
> :
> : The didn't used to happen, because the loop device used to issue
> : reads through the splice path and that does:
> :
> :       error = add_to_page_cache_lru(page, mapping, index,
> :                       GFP_KERNEL & mapping_gfp_mask(mapping));
> 
> This has changed by aa4d86163e4 (block: loop: switch to VFS ITER_BVEC).

xfs-on-loop deadlocks since April would appear to warrant a -stable
backport, yes?

> this is a rebase on top of the current mmotm
> (2015-09-22-15-28)

So I've redone the patch against current mainline.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
