From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/4] fs: fix data invalidation in the cleancache during
 direct IO
Date: Tue, 18 Apr 2017 15:46:47 -0700
Message-ID: <20170418154647.9583bfa06705c614a2640a15@linux-foundation.org>
References: <20170414140753.16108-1-aryabinin@virtuozzo.com>
        <20170414140753.16108-2-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
        <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>,
        Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
        Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
        Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
        Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>,
        Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>,
        Alexey Kuznetsov <kuznet-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>,
        Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
        <v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, <linux-
To: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170414140753.16108-2-aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 14 Apr 2017 17:07:50 +0300 Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:

> Some direct write fs hooks call invalidate_inode_pages2[_range]()
> conditionally iff mapping->nrpages is not zero. If page cache is empty,
> buffered read following after direct IO write would get stale data from
> the cleancache.
> 
> Also it doesn't feel right to check only for ->nrpages because
> invalidate_inode_pages2[_range] invalidates exceptional entries as well.
> 
> Fix this by calling invalidate_inode_pages2[_range]() regardless of nrpages
> state.

I'm not understanding this.  I can buy the argument about
nrexceptional, but why does cleancache require the
invalidate_inode_pages2_range) call even when ->nrpages is zero?

I *assume* it's because invalidate_inode_pages2_range() calls
cleancache_invalidate_inode(), yes?  If so, can we please add this to
the changelog?  If not then please explain further.
