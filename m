From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/2] dax: prevent invalidation of mapped DAX entries
Date: Mon, 1 May 2017 10:54:51 -0600
Message-ID: <20170501165451.GB14837@linux.intel.com>
References: <20170420191446.GA21694@linux.intel.com>
 <20170421034437.4359-1-ross.zwisler@linux.intel.com>
 <20170425101041.GG2793@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>,
 Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,
 Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
 Alexey Kuznetsov <kuznet-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170425101041.GG2793-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-cifs.vger.kernel.org

On Tue, Apr 25, 2017 at 12:10:41PM +0200, Jan Kara wrote:
> On Thu 20-04-17 21:44:36, Ross Zwisler wrote:
> > dax_invalidate_mapping_entry() currently removes DAX exceptional entries
> > only if they are clean and unlocked.  This is done via:
> > 
> > invalidate_mapping_pages()
> >   invalidate_exceptional_entry()
> >     dax_invalidate_mapping_entry()
> > 
> > However, for page cache pages removed in invalidate_mapping_pages() there
> > is an additional criteria which is that the page must not be mapped.  This
> > is noted in the comments above invalidate_mapping_pages() and is checked in
> > invalidate_inode_page().
> > 
> > For DAX entries this means that we can can end up in a situation where a
> > DAX exceptional entry, either a huge zero page or a regular DAX entry,
> > could end up mapped but without an associated radix tree entry. This is
> > inconsistent with the rest of the DAX code and with what happens in the
> > page cache case.
> > 
> > We aren't able to unmap the DAX exceptional entry because according to its
> > comments invalidate_mapping_pages() isn't allowed to block, and
> > unmap_mapping_range() takes a write lock on the mapping->i_mmap_rwsem.
> > 
> > Since we essentially never have unmapped DAX entries to evict from the
> > radix tree, just remove dax_invalidate_mapping_entry().
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Fixes: c6dcf52c23d2 ("mm: Invalidate DAX radix tree entries only if appropriate")
> > Reported-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>    [4.10+]
> 
> Just as a side note - we wouldn't really have to unmap the mapping range
> covered by the DAX exceptional entry. It would be enough to find out
> whether such range is mapped and bail out in that case. But that would
> still be pretty expensive for DAX - we'd have to do rmap walk similar as in
> dax_mapping_entry_mkclean() and IMHO it is not worth it. So I agree with
> what you did. You can add:
> 
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Yep, that makes sense.  Thanks for the review.
