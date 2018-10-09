From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] smb2: fix uninitialized variable bug in smb2_ioctl_query_info
Date: Tue, 9 Oct 2018 22:07:19 +0200
Message-ID: <20181009200719.GA19561@embeddedor.com>
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
is passed as an argument to function free_rsp_buf(), in which is used
without being properly initialized previously.

Fix this by initializing variable *resp_buftype* to -1 in order to
avoid unpredictable or unintended results.

Addresses-Coverity-ID: 1472116 ("Uninitialized scalar variable")
Fixes: 1473971 ("Uninitialized scalar variable")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c6c6450d..927aadd 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1133,7 +1133,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	struct smb_rqst rqst;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
-	int resp_buftype;
+	int resp_buftype = -1;
 	struct smb2_query_info_rsp *rsp = NULL;
 	void *buffer;
 
-- 
2.7.4
