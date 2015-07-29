From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [regression 4.2-rc3] loop: xfstests xfs/073 deadlocked in low
 memory conditions
Date: Thu, 30 Jul 2015 08:13:56 +1000
Message-ID: <20150729221356.GC16638@dastard>
References: <20150721015934.GY7943@dastard>
 <20150721085859.GG11967@dhcp22.suse.cz>
 <20150729115411.GF15801@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150729115411.GF15801-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 29, 2015 at 01:54:12PM +0200, Michal Hocko wrote:
> On Tue 21-07-15 10:58:59, Michal Hocko wrote:
> > [CCing more people from a potentially affected fs - the reference to the 
> >  email thread is: http://marc.info/?l=linux-mm&m=143744398020147&w=2]
...
> > > The didn't used to happen, because the loop device used to issue
> > > reads through the splice path and that does:
> > > 
> > > 	error = add_to_page_cache_lru(page, mapping, index,
> > > 			GFP_KERNEL & mapping_gfp_mask(mapping));
> > > 
> > > i.e. it pays attention to the allocation context placed on the
> > > inode and so is doing GFP_NOFS allocations here and avoiding the
> > > recursion problem.
> > > 
> > > [ CC'd Michal Hocko and the mm list because it's a clear exaple of
> > > why ignoring the mapping gfp mask on any page cache allocation is
> > > a landmine waiting to be tripped over. ]
> > 
> > Thank you for CCing me. I haven't noticed this one when checking for
> > other similar hardcoded GFP_KERNEL users (6afdb859b710 ("mm: do not
> > ignore mapping_gfp_mask in page cache allocation paths")). And there
> > seem to be more of them now that I am looking closer.
> > 
> > I am not sure what to do about fs/nfs/dir.c:nfs_symlink which doesn't
> > require GFP_NOFS or mapping gfp mask for other allocations in the same
> > context.
> > 
> > What do you think about this preliminary (and untested) patch?
> 
> Dave, did you have chance to test the patch in your environment? Is the
> patch good to go or we want a larger refactoring?

No, I haven't had a chance to test it yet. I'll try to get somethign
done by the end of the week, but I'm not able to reliably
reproduce the hang I saw (i.e. the analysis I did was from the first
deadlock and I've only seen it once since) so testing is likely to
be inconclusive, anyway....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
