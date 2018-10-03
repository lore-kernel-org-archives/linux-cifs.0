From: Garry McNulty <garrmcnu@gmail.com>
Subject: [PATCH] fs/cifs: fix uninitialised variable warnings
Date: Wed,  3 Oct 2018 20:51:21 +0100
Message-ID: <20181003195121.6059-1-garrmcnu@gmail.com>
Cc: sfrench@samba.org, lsahlber@redhat.com,
        linux-kernel@vger.kernel.org, Garry McNulty <garrmcnu@gmail.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

In some error conditions, resp_buftype can be passed uninitialised to
free_rsp_buf(), potentially resulting in a spurious debug message.
If resp_buftype randomly had the value 1 (CIFS_SMALL_BUFFER) then this
would log a debug message.
The rsp pointer is initialised to NULL so there is no other side-effect.

Detected by CoverityScan, CID 1438585 ("Uninitialized scalar variable")
Detected by CoverityScan, CID 1438667 ("Uninitialized scalar variable")
Detected by CoverityScan, CID 1438764 ("Uninitialized scalar variable")

Signed-off-by: Garry McNulty <garrmcnu@gmail.com>
---
 fs/cifs/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f54d07bda067..65a864b8d09e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2261,7 +2261,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[SMB2_CREATE_IOV_SIZE];
 	struct kvec rsp_iov = {NULL, 0};
-	int resp_buftype;
+	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
 
@@ -2547,7 +2547,7 @@ SMB2_close_flags(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
-	int resp_buftype;
+	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 
 	cifs_dbg(FYI, "Close\n");
@@ -2699,7 +2699,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	int rc = 0;
-	int resp_buftype;
+	int resp_buftype = CIFS_NO_BUFFER;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
 
-- 
2.14.4
