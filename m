From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v3] smb2: fix uninitialized variable bug in
 smb2_ioctl_query_info
Date: Wed, 10 Oct 2018 00:02:20 +0200
Message-ID: <20181009220220.GA24569@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

There is a potential execution path in which variable *resp_buftype*
is passed as an argument to function free_rsp_buf(), in which it is
used in a comparison without being properly initialized previously.

Fix this by initializing variable *resp_buftype* to CIFS_NO_BUFFER
in order to avoid unpredictable or unintended results.

Addresses-Coverity-ID: 1473971 ("Uninitialized scalar variable")
Fixes: c5d25bdb2967 ("cifs: add IOCTL for QUERY_INFO passthrough to userspace")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v3:
 - Initialize resp_buftype to CIFS_NO_BUFFER instead of to -1.
   Thanks to Ronnie Sahlberg for pointing this out.

Changes in v2:
 - Fix Coverity and Fixes tag.
 - Update commit log.

 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c6c6450d..8472cb0 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1133,7 +1133,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	struct smb_rqst rqst;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
-	int resp_buftype;
+	int resp_buftype = CIFS_NO_BUFFER;
 	struct smb2_query_info_rsp *rsp = NULL;
 	void *buffer;
 
-- 
2.7.4
