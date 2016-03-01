From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Fix duplicate line introduced by
	clone_file_range patch
Date: Tue, 1 Mar 2016 07:50:50 +0100
Message-ID: <20160301065050.GD31969@lst.de>
References: <smfrench@gmail.com> <1456791058-92940-1-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456791058-92940-1-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 29, 2016 at 06:10:58PM -0600, Steve French wrote:
> Commit 04b38d601239b4 ("vfs: pull btrfs clone API to vfs layer")
> added a duplicated line (in cifsfs.c) which causes a sparse compile
> warning.
> 
> Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> CC: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Oops.  The fix looks fine to me:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
