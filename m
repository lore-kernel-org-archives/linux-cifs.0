From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't start signing too early
Date: Mon, 11 Jul 2011 10:16:53 -0400
Message-ID: <1310393813-12443-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sniffing traffic on the wire shows that windows clients send a zeroed
out signature field in a NEGOTIATE request, and send "BSRSPYL" in the
signature field during SESSION_SETUP. Make the cifs client behave the
same way.

It doesn't seem to make much difference in any server that I've tested
against, but it's probably best to follow windows behavior as closely as
possible here.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5a0ee7f..45ae18e 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -77,9 +77,15 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 	if ((cifs_pdu == NULL) || (server == NULL))
 		return -EINVAL;
 
-	if ((cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) == 0)
+	if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) ||
+	    server->tcpStatus == CifsNeedNegotiate)
 		return rc;
 
+	if (!server->session_estab) {
+		strncpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
+		return rc;
+	}
+
 	cifs_pdu->Signature.Sequence.SequenceNumber =
 			cpu_to_le32(server->sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
@@ -154,9 +160,15 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 	if ((cifs_pdu == NULL) || (server == NULL))
 		return -EINVAL;
 
-	if ((cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) == 0)
+	if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) ||
+	    server->tcpStatus == CifsNeedNegotiate)
 		return rc;
 
+	if (!server->session_estab) {
+		strncpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
+		return rc;
+	}
+
 	cifs_pdu->Signature.Sequence.SequenceNumber =
 				cpu_to_le32(server->sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
-- 
1.7.6
