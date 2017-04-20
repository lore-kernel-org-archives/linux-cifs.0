From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/4] fs: fix data invalidation in the cleancache during
 direct IO
Date: Thu, 20 Apr 2017 16:35:10 +0200
Message-ID: <20170420143510.GF22135@quack2.suse.cz>
References: <20170414140753.16108-1-aryabinin@virtuozzo.com>
 <20170414140753.16108-2-aryabinin@virtuozzo.com>
 <20170418193808.GA16667@linux.intel.com>
 <ac3b6a27-4345-53cf-04b5-c1f74e680695@virtuozzo.com>
 <20170419192836.GA6364@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,
        Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
        linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>,
        Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
        Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
        Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>,
        Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>,
        Alexey Kuznetsov <kuznet-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,
        Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
        v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-tec
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170419192836.GA6364-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Wed 19-04-17 13:28:36, Ross Zwisler wrote:
> On Wed, Apr 19, 2017 at 06:11:31PM +0300, Andrey Ryabinin wrote:
> > On 04/18/2017 10:38 PM, Ross Zwisler wrote:
> > > On Fri, Apr 14, 2017 at 05:07:50PM +0300, Andrey Ryabinin wrote:
> > >> Some direct write fs hooks call invalidate_inode_pages2[_range]()
> > >> conditionally iff mapping->nrpages is not zero. If page cache is empty,
> > >> buffered read following after direct IO write would get stale data from
> > >> the cleancache.
> > >>
> > >> Also it doesn't feel right to check only for ->nrpages because
> > >> invalidate_inode_pages2[_range] invalidates exceptional entries as well.
> > >>
> > >> Fix this by calling invalidate_inode_pages2[_range]() regardless of nrpages
> > >> state.
> > >>
> > >> Fixes: c515e1fd361c ("mm/fs: add hooks to support cleancache")
> > >> Signed-off-by: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> > >> ---
> > > <>
> > >> diff --git a/fs/dax.c b/fs/dax.c
> > >> index 2e382fe..1e8cca0 100644
> > >> --- a/fs/dax.c
> > >> +++ b/fs/dax.c
> > >> @@ -1047,7 +1047,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> > >>  	 * into page tables. We have to tear down these mappings so that data
> > >>  	 * written by write(2) is visible in mmap.
> > >>  	 */
> > >> -	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {
> > >> +	if ((iomap->flags & IOMAP_F_NEW)) {
> > >>  		invalidate_inode_pages2_range(inode->i_mapping,
> > >>  					      pos >> PAGE_SHIFT,
> > >>  					      (end - 1) >> PAGE_SHIFT);
> > > 
> > > tl;dr: I think the old code is correct, and that you don't need this change.
> > > 
> > > This should be harmless, but could slow us down a little if we keep
> > > calling invalidate_inode_pages2_range() without really needing to.  Really for
> > > DAX I think we need to call invalidate_inode_page2_range() only if we have
> > > zero pages mapped over the place where we are doing I/O, which is why we check
> > > nrpages.
> > > 
> > 
> > Check for ->nrpages only looks strange, because invalidate_inode_pages2_range() also
> > invalidates exceptional radix tree entries. Is that correct that we invalidate
> > exceptional entries only if ->nrpages > 0 and skip invalidation otherwise?
> 
> For DAX we only invalidate clean DAX exceptional entries so that we can keep
> dirty entries around for writeback, but yes you're correct that we only do the
> invalidation if nrpages > 0.  And yes, it does seem a bit weird. :)

Actually in this place the nrpages check is deliberate since there should
only be hole pages or nothing in the invalidated range - see the comment
before the if. But thinking more about it this assumption actually is not
right in presence of zero PMD entries in the radix tree. So this change
actually also fixes a possible bug for DAX but we should do it as a
separate patch with a proper changelog.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
