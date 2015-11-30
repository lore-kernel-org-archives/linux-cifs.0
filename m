From: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org (J. Bruce Fields)
Subject: Re: vfs: move btrfs clone ioctls to common code
Date: Mon, 30 Nov 2015 17:56:29 -0500
Message-ID: <20151130225629.GC31564@fieldses.org>
References: <1448563859-21922-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org,
	jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448563859-21922-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Nov 26, 2015 at 07:50:54PM +0100, Christoph Hellwig wrote:
> This patch set moves the existing btrfs clone ioctls that other file
> system have started to implement to common code, and allows the NFS
> server to export this functionality to remote systems.
> 
> This work is based originally on my NFS CLONE prototype, which reused
> code from Anna Schumaker's NFS COPY prototype, as well as various
> updates from Peng Tao to this code.

Looks good to me.  (In particular: ACK to the locks.c and nfsd patches.
But, disclaimer, I haven't tried to test clone.)

--b.

> 
> The patches are also available as a git branch and on gitweb:
> 
> 	git://git.infradead.org/users/hch/pnfs.git clone-for-viro
> 	http://git.infradead.org/users/hch/pnfs.git/shortlog/refs/heads/clone-for-viro
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
