From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 1/4] locks: new locks_mandatory_area calling convention
Date: Tue, 8 Dec 2015 15:54:53 +0100
Message-ID: <20151208145453.GA3621@lst.de>
References: <1449143992-7415-1-git-send-email-hch@lst.de> <1449143992-7415-2-git-send-email-hch@lst.de> <20151208040504.GA2791@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org,
	jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208040504.GA2791-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Dec 08, 2015 at 04:05:04AM +0000, Al Viro wrote:
> Where the hell would truncate(2) get struct file, anyway?  IOW, the inode
> argument is _not_ pointless; re-added.

Oh, right.  Interestingly is seems like xfstests has no coverage of this
code path at all.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
