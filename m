From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 5/8] cifs: make cifsFileInfo_get return the cifsFileInfo pointer
Date: Fri,  3 Feb 2012 09:32:58 -0500
Message-ID: <1328279581-21889-6-git-send-email-jlayton@redhat.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0e56b1e..4adad0a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -555,9 +555,11 @@ struct cifs_io_parms {
  * Take a reference on the file private data. Must be called with
  * cifs_file_list_lock held.
  */
-static inline void cifsFileInfo_get(struct cifsFileInfo *cifs_file)
+static inline
+struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file)
 {
 	++cifs_file->count;
+	return cifs_file;
 }
 
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
-- 
1.7.7.6
