From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 1/8] cifs: add pid field to cifs_writedata
Date: Fri,  3 Feb 2012 09:32:54 -0500
Message-ID: <1328279581-21889-2-git-send-email-jlayton@redhat.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We'll need this to handle rwpidforward option correctly when we use
async writes in the aio_write op.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/cifssmb.c   |    4 ++--
 fs/cifs/file.c      |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index a81549d..2778605 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -477,6 +477,7 @@ struct cifs_writedata {
 	struct work_struct		work;
 	struct cifsFileInfo		*cfile;
 	__u64				offset;
+	pid_t				pid;
 	unsigned int			bytes;
 	int				result;
 	unsigned int			nr_pages;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index cf12c0c..9525ae3 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2122,8 +2122,8 @@ cifs_async_writev(struct cifs_writedata *wdata)
 		goto async_writev_out;
 	}
 
-	smb->hdr.Pid = cpu_to_le16((__u16)wdata->cfile->pid);
-	smb->hdr.PidHigh = cpu_to_le16((__u16)(wdata->cfile->pid >> 16));
+	smb->hdr.Pid = cpu_to_le16((__u16)wdata->pid);
+	smb->hdr.PidHigh = cpu_to_le16((__u16)(wdata->pid >> 16));
 
 	smb->AndXCommand = 0xFF;	/* none */
 	smb->Fid = wdata->cfile->netfid;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4dd9283..ffbb2b4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1758,6 +1758,7 @@ retry:
 				rc = -EBADF;
 				break;
 			}
+			wdata->pid = wdata->cfile->pid;
 			rc = cifs_async_writev(wdata);
 		} while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
 
-- 
1.7.7.6
