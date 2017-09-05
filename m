From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] cifs: hide unused functions
Date: Tue,  5 Sep 2017 11:24:15 +0200
Message-ID: <20170905092440.2172429-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sachin Prabhu <sprabhu@redhat.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The newly added SMB2+ attribute support causes unused function
warnings when CONFIG_CIFS_XATTR is disabled:

fs/cifs/smb2ops.c:563:1: error: 'smb2_set_ea' defined but not used [-Werror=unused-function]
 smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
fs/cifs/smb2ops.c:513:1: error: 'smb2_query_eas' defined but not used [-Werror=unused-function]
 smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,

This adds another #ifdef around the affected functions.

Fixes: 5517554e4313 ("cifs: Add support for writing attributes on SMB2+")
Fixes: 95907fea4fd8 ("cifs: Add support for reading attributes on SMB2+")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cifs/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index fb2934b9b97c..6cd91670ba2d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -426,6 +426,7 @@ smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+#ifdef CONFIG_CIFS_XATTR
 static ssize_t
 move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 		     struct smb2_file_full_ea_info *src, size_t src_size,
@@ -613,6 +614,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 	return rc;
 }
+#endif
 
 static bool
 smb2_can_echo(struct TCP_Server_Info *server)
-- 
2.9.0
