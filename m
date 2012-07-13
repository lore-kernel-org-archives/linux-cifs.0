From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 27/32] CIFS: Setup async request in ops struct
Date: Fri, 13 Jul 2012 11:53:40 +0400
Message-ID: <1342166025-29377-28-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +++
 fs/cifs/cifsproto.h |    2 ++
 fs/cifs/smb1ops.c   |    1 +
 fs/cifs/transport.c |    4 ++--
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 340dce0..5e4d1c5 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -173,6 +173,9 @@ struct smb_version_operations {
 	/* setup request: allocate mid, sign message */
 	int (*setup_request)(struct cifs_ses *, struct kvec *, unsigned int,
 			     struct mid_q_entry **);
+	/* setup async request: allocate mid, sign message */
+	int (*setup_async_request)(struct TCP_Server_Info *, struct kvec *,
+				   unsigned int, struct mid_q_entry **);
 	/* check response: verify signature, map error */
 	int (*check_receive)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     bool);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 8836c7b..5aadeec 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -78,6 +78,8 @@ extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 			    char *in_buf, int flags);
 extern int cifs_setup_request(struct cifs_ses *, struct kvec *, unsigned int,
 			      struct mid_q_entry **);
+extern int cifs_setup_async_request(struct TCP_Server_Info *, struct kvec *,
+				    unsigned int, struct mid_q_entry **);
 extern int cifs_check_receive(struct mid_q_entry *mid,
 			struct TCP_Server_Info *server, bool log_error);
 extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 7195fad..7bd4973 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -524,6 +524,7 @@ struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
 	.setup_request = cifs_setup_request,
+	.setup_async_request = cifs_setup_async_request,
 	.check_receive = cifs_check_receive,
 	.add_credits = cifs_add_credits,
 	.set_credits = cifs_set_credits,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 8844328..4d37902 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -349,7 +349,7 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 	return 0;
 }
 
-static int
+int
 cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
 			 unsigned int nvec, struct mid_q_entry **ret_mid)
 {
@@ -395,7 +395,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 		return rc;
 
 	mutex_lock(&server->srv_mutex);
-	rc = cifs_setup_async_request(server, iov, nvec, &mid);
+	rc = server->ops->setup_async_request(server, iov, nvec, &mid);
 	if (rc) {
 		mutex_unlock(&server->srv_mutex);
 		add_credits(server, 1, optype);
-- 
1.7.1
