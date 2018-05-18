From: Long Li <longli@linuxonhyperv.com>
Subject: [RFC PATCH 04/09] Change function to support offset when reading pages
Date: Thu, 17 May 2018 17:22:09 -0700
Message-ID: <20180518002214.5657-5-longli@linuxonhyperv.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518002214.5657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

It's possible that we may want to read data into an offset to the 1st page, change
the functions to pass the offset to transport.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsproto.h | 2 +-
 fs/cifs/connect.c   | 4 ++--
 fs/cifs/file.c      | 4 ++--
 fs/cifs/smb2ops.c   | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 94106b9..cc034e2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -197,7 +197,7 @@ extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
 extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 			         unsigned int to_read);
 extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
-				      struct page *page, unsigned int to_read);
+				      struct page *page, unsigned int page_offset, unsigned int to_read);
 extern int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			       struct cifs_sb_info *cifs_sb);
 extern int cifs_match_super(struct super_block *, void *);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 58c2083..46d0cf4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -591,11 +591,11 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 }
 
 int
-cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
+cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page, unsigned int page_offset,
 		      unsigned int to_read)
 {
 	struct msghdr smb_msg;
-	struct bio_vec bv = {.bv_page = page, .bv_len = to_read};
+	struct bio_vec bv = {.bv_page = page, .bv_len = to_read, .bv_offset = page_offset};
 	iov_iter_bvec(&smb_msg.msg_iter, READ | ITER_BVEC, &bv, 1, to_read);
 	return cifs_readv_from_socket(server, &smb_msg);
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ed25e04..e240c7c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3044,7 +3044,7 @@ uncached_fill_pages(struct TCP_Server_Info *server,
 			result = n;
 #endif
 		else
-			result = cifs_read_page_from_socket(server, page, n);
+			result = cifs_read_page_from_socket(server, page, page_offset, n);
 		if (result < 0)
 			break;
 
@@ -3614,7 +3614,7 @@ readpages_fill_pages(struct TCP_Server_Info *server,
 			result = n;
 #endif
 		else
-			result = cifs_read_page_from_socket(server, page, n);
+			result = cifs_read_page_from_socket(server, page, 0, n);
 		if (result < 0)
 			break;
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b76b858..f890dd7 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2387,7 +2387,7 @@ read_data_into_pages(struct TCP_Server_Info *server, struct page **pages,
 			zero_user(page, len, PAGE_SIZE - len);
 			len = 0;
 		}
-		length = cifs_read_page_from_socket(server, page, n);
+		length = cifs_read_page_from_socket(server, page, 0, n);
 		if (length < 0)
 			return length;
 		server->total_read += length;
-- 
2.7.4
