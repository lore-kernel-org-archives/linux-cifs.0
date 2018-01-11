From: Daniel N Pettersson <daniel.n.pettersson-VrBV9hrLPhE@public.gmane.org>
Subject: [PATCH] cifs: Fix autonegotiate security settings mismatch
Date: Thu, 11 Jan 2018 16:00:12 +0100
Message-ID: <1515682812-21567-1-git-send-email-Daniel.N.Pettersson@axis.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel N Pettersson <danielnp-VrBV9hrLPhE@public.gmane.org>
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Daniel N Pettersson <danielnp-VrBV9hrLPhE@public.gmane.org>

Autonegotiation gives a security settings mismatch error if the SMB
server selects an SMBv3 dialect that isn't SMB3.02. The exact error is
"protocol revalidation - security settings mismatch".
This can be tested using Samba v4.2 or by setting the global Samba
setting max protocol = SMB3_00.

The check that fails in smb3_validate_negotiate is the dialect
verification of the negotiate info response. This is because it tries
to verify against the protocol_id in the global smbdefault_values. The
protocol_id in smbdefault_values is SMB3.02.
In SMB2_negotiate the protocol_id in smbdefault_values isn't updated,
it is global so it probably shouldn't be, but server->dialect is.

This patch changes the check in smb3_validate_negotiate to use
server->dialect instead of server->vals->protocol_id. The patch works
with autonegotiate and when using a specific version in the vers mount
option.

Signed-off-by: Daniel N Pettersson <danielnp-VrBV9hrLPhE@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 01346b8..66af1f8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -733,8 +733,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 	}
 
 	/* check validate negotiate info response matches what we got earlier */
-	if (pneg_rsp->Dialect !=
-			cpu_to_le16(tcon->ses->server->vals->protocol_id))
+	if (pneg_rsp->Dialect != cpu_to_le16(tcon->ses->server->dialect))
 		goto vneg_out;
 
 	if (pneg_rsp->SecurityMode != cpu_to_le16(tcon->ses->server->sec_mode))
-- 
2.1.4
