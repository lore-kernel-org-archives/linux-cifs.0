From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH 1/1] CIFS: add int cast to silence warning
Date: Mon, 26 Jun 2017 14:49:11 +0200
Message-ID: <20170626124911.28449-1-aaptel@suse.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The '*' field specifier expects an int and sizeof returns an unsigned
long int but its always going to be a small positive value so casting is
safe.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/smb2transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 437d11711b3e..ad0492c682e7 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -349,7 +349,8 @@ generate_smb3signingkey(struct cifs_ses *ses,
 	 * print it as a long long. we dump it as we got it on the
 	 * wire.
 	 */
-	cifs_dbg(VFS, "Session Id    %*ph\n", sizeof(ses->Suid), &ses->Suid);
+	cifs_dbg(VFS, "Session Id    %*ph\n", (int)sizeof(ses->Suid),
+		 &ses->Suid);
 	cifs_dbg(VFS, "Session Key   %*ph\n",
 		 SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
 	cifs_dbg(VFS, "Signing Key   %*ph\n",
-- 
2.12.3
