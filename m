From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/4] fs: fix data invalidation in the cleancache during
 direct IO
Date: Thu, 20 Apr 2017 16:44:31 +0200
Message-ID: <20170420144431.GA14620@quack2.suse.cz>
References: <20170414140753.16108-1-aryabinin@virtuozzo.com>
 <20170414140753.16108-2-aryabinin@virtuozzo.com>
 <20170418193808.GA16667@linux.intel.com>
 <ac3b6a27-4345-53cf-04b5-c1f74e680695@virtuozzo.com>
 <20170419192836.GA6364@linux.intel.com>
 <20170420143510.GF22135@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
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
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170420143510.GF22135-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 20-04-17 16:35:10, Jan Kara wrote:
> On Wed 19-04-17 13:28:36, Ross Zwisler wrote:
> > On Wed, Apr 19, 2017 at 06:11:31PM +0300, Andrey Ryabinin wrote:
> > > On 04/18/2017 10:38 PM, Ross Zwisler wrote:
> > > > On Fri, Apr 14, 2017 at 05:07:50PM +0300, Andrey Ryabinin wrote:
> > > >> Some direct write fs hooks call invalidate_inode_pages2[_range]()
> > > >> conditionally iff mapping->nrpages is not zero. If page cache is empty,
> > > >> buffered read following after direct IO write would get stale data from
> > > >> the cleancache.
> > > >>
> > > >> Also it doesn't feel right to check only for ->nrpages because
> > > >> invalidate_inode_pages2[_range] invalidates exceptional entries as well.
> > > >>
> > > >> Fix this by calling invalidate_inode_pages2[_range]() regardless of nrpages
> > > >> state.
> > > >>
> > > >> Fixes: c515e1fd361c ("mm/fs: add hooks to support cleancache")
> > > >> Signed-off-by: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> > > >> ---
> > > > <>
> > > >> diff --git a/fs/dax.c b/fs/dax.c
> > > >> index 2e382fe..1e8cca0 100644
> > > >> --- a/fs/dax.c
> > > >> +++ b/fs/dax.c
> > > >> @@ -1047,7 +1047,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> > > >>  	 * into page tables. We have to tear down these mappings so that data
> > > >>  	 * written by write(2) is visible in mmap.
> > > >>  	 */
> > > >> -	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {
> > > >> +	if ((iomap->flags & IOMAP_F_NEW)) {
> > > >>  		invalidate_inode_pages2_range(inode->i_mapping,
> > > >>  					      pos >> PAGE_SHIFT,
> > > >>  					      (end - 1) >> PAGE_SHIFT);
> > > > 
> > > > tl;dr: I think the old code is correct, and that you don't need this change.
> > > > 
> > > > This should be harmless, but could slow us down a little if we keep
> > > > calling invalidate_inode_pages2_range() without really needing to.  Really for
> > > > DAX I think we need to call invalidate_inode_page2_range() only if we have
> > > > zero pages mapped over the place where we are doing I/O, which is why we check
> > > > nrpages.
> > > > 
> > > 
> > > Check for ->nrpages only looks strange, because invalidate_inode_pages2_range() also
> > > invalidates exceptional radix tree entries. Is that correct that we invalidate
> > > exceptional entries only if ->nrpages > 0 and skip invalidation otherwise?
> > 
> > For DAX we only invalidate clean DAX exceptional entries so that we can keep
> > dirty entries around for writeback, but yes you're correct that we only do the
> > invalidation if nrpages > 0.  And yes, it does seem a bit weird. :)
> 
> Actually in this place the nrpages check is deliberate since there should
> only be hole pages or nothing in the invalidated range - see the comment
> before the if. But thinking more about it this assumption actually is not
> right in presence of zero PMD entries in the radix tree. So this change
> actually also fixes a possible bug for DAX but we should do it as a
> separate patch with a proper changelog.

Something like the attached patch. Ross?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR

--tKW2IUtsqtDRztdT
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-Fix-inconsistency-between-mmap-and-write-2.patch"

>From da79b4b72a6fe5fcf1a554ca1ce77cb462e8a306 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Date: Thu, 20 Apr 2017 16:38:20 +0200
Subject: [PATCH] dax: Fix inconsistency between mmap and write(2)

When a process has a PMD-sized hole mapped via mmap and later allocates
part of the file underlying this area using write(2), memory mappings
need not be appropriately invalidated if the file has no hole pages
allocated and thus view via mmap will not show the data written by
write(2). Fix the problem by always invalidating memory mappings
covering part of the file for which blocks got allocated.

Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 85abd741253d..da7bc44e5725 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1028,11 +1028,11 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		return -EIO;
 
 	/*
-	 * Write can allocate block for an area which has a hole page mapped
-	 * into page tables. We have to tear down these mappings so that data
-	 * written by write(2) is visible in mmap.
+	 * Write can allocate block for an area which has a hole page or zero
+	 * PMD entry in the radix tree.  We have to tear down these mappings so
+	 * that data written by write(2) is visible in mmap.
 	 */
-	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {
+	if (iomap->flags & IOMAP_F_NEW) {
 		invalidate_inode_pages2_range(inode->i_mapping,
 					      pos >> PAGE_SHIFT,
 					      (end - 1) >> PAGE_SHIFT);
-- 
2.12.0


--tKW2IUtsqtDRztdT--
