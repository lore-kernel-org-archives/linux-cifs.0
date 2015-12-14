From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 5/4] vfs: return EINVAL for unsupported file types in clone
Date: Mon, 14 Dec 2015 17:34:58 +0100
Message-ID: <20151214163458.GB12687@lst.de>
References: <1449143992-7415-1-git-send-email-hch@lst.de> <1449143992-7415-3-git-send-email-hch@lst.de> <20151207005331.GA10582@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	tao.peng-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org,
	bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151207005331.GA10582-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

diff --git a/fs/read_write.c b/fs/read_write.c
index 1f0d3f1..6268ebc 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1528,7 +1528,7 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
-		return -EOPNOTSUPP;
+		return -EINVAL;
 
 	if (!(file_in->f_mode & FMODE_READ) ||
 	    !(file_out->f_mode & FMODE_WRITE) ||
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
