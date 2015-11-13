From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/9] vfs: add COPY_FILE_CLONE_ONLY flag
Date: Fri, 13 Nov 2015 00:58:22 -0800
Message-ID: <20151113085822.GA2272@infradead.org>
References: <1445728636-10109-1-git-send-email-tao.peng@primarydata.com>
 <1445728636-10109-2-git-send-email-tao.peng@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>,
	Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
	Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: Peng Tao <tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445728636-10109-2-git-send-email-tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Oct 25, 2015 at 07:17:08AM +0800, Peng Tao wrote:
> To tell file system not to return partial success in the
> .copy_file_range method. This is useful to implement the
> clone (or reflink) functionality.

The return value is only part of it, the other part is to
make it atomic.  Thus I don't think overloading copy_file_range
is a good idea - we should have a seaprate .clone_file_range that
is called by the btrfs ioctls moved to the core, and have
vfs_copy_file_range use .clone_file_range if that exists, and
if none of the potentially conflicting future flags like
COPY_FALLOC are present.
