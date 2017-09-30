From: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Subject: [PATCH] SMB3: Fix resource leak if an unexpected dialect is returned
Date: Sat, 30 Sep 2017 08:05:29 +0200
Message-ID: <20170930060529.8445-1-christophe.jaillet@wanadoo.fr>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we receive an unexpected dialect, we must free some resources before
returning.

Branch to the existing error hangling path to fix it.

Fixes: 9764c02fcbad ("SMB3: Add support for multidialect negotiate (SMB2.1 and later)")
Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6f0e6343c15e..29025398d7d2 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -554,18 +554,21 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			rc = -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			cifs_dbg(VFS,
 				"SMB2.1 dialect returned but not requested\n");
-			return -EIO;
+			rc = -EIO;
+			goto neg_exit;
 		}
 	} else if (strcmp(ses->server->vals->version_string,
 		   SMBDEFAULT_VERSION_STRING) == 0) {
 		if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID)) {
 			cifs_dbg(VFS,
 				"SMB2 dialect returned but not requested\n");
-			return -EIO;
+			rc = -EIO;
+			goto neg_exit;
 		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
 			/* ops set to 3.0 by default for default so update */
 			ses->server->ops = &smb21_operations;
@@ -575,7 +578,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		/* if requested single dialect ensure returned dialect matched */
 		cifs_dbg(VFS, "Illegal 0x%x dialect returned: not requested\n",
 			le16_to_cpu(rsp->DialectRevision));
-		return -EIO;
+		rc = -EIO;
+		goto neg_exit;
 	}
 
 	cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
-- 
2.11.0
