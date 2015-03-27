From: Steve French <smfrench@gmail.com>
Subject: [PATCH 2/4] [CIFS] Don't ignore errors on encrypting password in SMBTcon
Date: Fri, 27 Mar 2015 00:28:00 -0500
Message-ID: <1427434082-4299-3-git-send-email-smfrench@gmail.com>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
Cc: smfrench@gmail.com
To: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Although unlikely to fail (and tree connect does not commonly send
a password since SECMODE_USER is the default for most servers)
do not ignore errors on SMBNTEncrypt in SMB Tree Connect.

Reported by Coverity (CID 1226853)

Signed-off-by: Steve French <smfrench@gmail.com>
---
 fs/cifs/connect.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4cb8450..cdb1aaf 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3696,6 +3696,12 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 #endif /* CIFS_WEAK_PW_HASH */
 		rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
 					bcc_ptr, nls_codepage);
+		if (rc) {
+			cifs_dbg(FYI, "%s Can't generate NTLM rsp. Error: %d\n",
+				 __func__, rc);
+			cifs_buf_release(smb_buffer);
+			return rc;
+		}
 
 		bcc_ptr += CIFS_AUTH_RESP_SIZE;
 		if (ses->capabilities & CAP_UNICODE) {
-- 
1.9.1
