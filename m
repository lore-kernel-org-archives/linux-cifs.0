From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: wrap received signature check in srv_mutex
Date: Sat,  2 Apr 2011 07:34:30 -0400
Message-ID: <1301744070-30667-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

While testing my patchset to fix asynchronous writes, I hit a bunch
of signature problems when testing with signing on. The problem seems
to be that signature checks on receive can be running at the same
time as a process that is sending, or even that multiple receives can
be checking signatures at the same time, clobbering the same data
structures.

While we're at it, clean up the comments over cifs_calculate_signature
and add a note that the srv_mutex should be held when calling this
function.

This patch seems to fix the problems for me, but I'm not clear on
whether it's the best approach. If it is, then this should probably
go to stable too.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5bb4b09..dfbd9f1 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -30,12 +30,13 @@
 #include <linux/ctype.h>
 #include <linux/random.h>
 
-/* Calculate and return the CIFS signature based on the mac key and SMB PDU */
-/* the 16 byte signature must be allocated by the caller  */
-/* Note we only use the 1st eight bytes */
-/* Note that the smb header signature field on input contains the
-	sequence number before this function is called */
-
+/*
+ * Calculate and return the CIFS signature based on the mac key and SMB PDU.
+ * The 16 byte signature must be allocated by the caller. Note we only use the
+ * 1st eight bytes and that the smb header signature field on input contains
+ * the sequence number before this function is called. Also, this function
+ * should be called with the server->srv_mutex held.
+ */
 static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
 				struct TCP_Server_Info *server, char *signature)
 {
@@ -209,8 +210,10 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 					cpu_to_le32(expected_sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
+	mutex_lock(&server->srv_mutex);
 	rc = cifs_calculate_signature(cifs_pdu, server,
 		what_we_think_sig_should_be);
+	mutex_unlock(&server->srv_mutex);
 
 	if (rc)
 		return rc;
-- 
1.7.4
