From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 1/1] CIFS: add CONFIG_CIFS_DEBUG_KEYS to dump encryption keys
Date: Wed, 24 May 2017 16:13:25 +0200
Message-ID: <20170524141325.18545-1-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add new config option that dumps AES keys to the console when they are
generated. This is obviously for debugging purposes only, and should not
be enabled otherwise.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/Kconfig         |  9 +++++++++
 fs/cifs/smb2transport.c | 28 +++++++++++++++++++++++++---
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 034f00f21390..afeefe79c25e 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -146,6 +146,15 @@ config CIFS_DEBUG2
 	   option can be turned off unless you are debugging
 	   cifs problems.  If unsure, say N.
 
+config CIFS_DEBUG_DUMP_KEYS
+	bool "Dump encryption keys for offline decryption (Unsafe)"
+	depends on CIFS_DEBUG && CIFS_SMB2
+	help
+	   Enabling this will dump the encryption and decryption keys
+	   used to communicate on an encrypted share connection on the
+	   console. This allows Wireshark to decrypt and dissect
+	   encrypted network captures. Enable this carefully.
+
 config CIFS_DFS_UPCALL
 	  bool "DFS feature support"
 	  depends on CIFS && KEYS
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index c69ec96e92ac..be45e7b5f666 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -335,9 +335,31 @@ generate_smb3signingkey(struct cifs_ses *ses,
 	if (rc)
 		return rc;
 
-	return generate_key(ses, ptriplet->decryption.label,
-			    ptriplet->decryption.context,
-			    ses->smb3decryptionkey, SMB3_SIGN_KEY_SIZE);
+	rc = generate_key(ses, ptriplet->decryption.label,
+			  ptriplet->decryption.context,
+			  ses->smb3decryptionkey, SMB3_SIGN_KEY_SIZE);
+
+	if (rc)
+		return rc;
+
+#ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
+	cifs_dbg(VFS, "%s: dumping generated AES session keys\n", __func__);
+	/*
+	 * The session id is opaque in terms of endianness, so we can't
+	 * print it as a long long. we dump it as we got it on the
+	 * wire.
+	 */
+	cifs_dbg(VFS, "Session Id    %*ph\n", sizeof(ses->Suid), &ses->Suid);
+	cifs_dbg(VFS, "Session Key   %*ph\n",
+		 SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
+	cifs_dbg(VFS, "Signing Key   %*ph\n",
+		 SMB3_SIGN_KEY_SIZE, ses->smb3signingkey);
+	cifs_dbg(VFS, "ServerIn Key  %*ph\n",
+		 SMB3_SIGN_KEY_SIZE, ses->smb3encryptionkey);
+	cifs_dbg(VFS, "ServerOut Key %*ph\n",
+		 SMB3_SIGN_KEY_SIZE, ses->smb3decryptionkey);
+#endif
+	return rc;
 }
 
 int
-- 
2.12.0
