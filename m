From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH] cifs: remove unnecessary locking around sequence_number
Date: Mon, 22 Nov 2010 15:31:01 -0500
Message-ID: <1290457863-10804-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The server->sequence_number is already protected by the srv_mutex. The
GlobalMid_lock is unneeded here.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |    6 ++----
 fs/cifs/cifsglob.h    |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index f856732..66f3d50 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -72,6 +72,7 @@ static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
 	return 0;
 }
 
+/* must be called with server->srv_mutex held */
 int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 		  __u32 *pexpected_response_sequence_number)
 {
@@ -84,14 +85,12 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 	if ((cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) == 0)
 		return rc;
 
-	spin_lock(&GlobalMid_Lock);
 	cifs_pdu->Signature.Sequence.SequenceNumber =
 			cpu_to_le32(server->sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
 	*pexpected_response_sequence_number = server->sequence_number++;
 	server->sequence_number++;
-	spin_unlock(&GlobalMid_Lock);
 
 	rc = cifs_calculate_signature(cifs_pdu, server, smb_signature);
 	if (rc)
@@ -149,6 +148,7 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 	return rc;
 }
 
+/* must be called with server->srv_mutex held */
 int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 		   __u32 *pexpected_response_sequence_number)
 {
@@ -162,14 +162,12 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 	if ((cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) == 0)
 		return rc;
 
-	spin_lock(&GlobalMid_Lock);
 	cifs_pdu->Signature.Sequence.SequenceNumber =
 				cpu_to_le32(server->sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
 	*pexpected_response_sequence_number = server->sequence_number++;
 	server->sequence_number++;
-	spin_unlock(&GlobalMid_Lock);
 
 	rc = cifs_calc_signature2(iov, n_vec, server, smb_signature);
 	if (rc)
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a8d9f32..bba731c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -200,7 +200,7 @@ struct TCP_Server_Info {
 	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
-	__u32 sequence_number; /* needed for CIFS PDU signature */
+	__u32 sequence_number; /* for signing, protected by srv_mutex */
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
 	u16 dialect; /* dialect index that server chose */
-- 
1.7.3.2
