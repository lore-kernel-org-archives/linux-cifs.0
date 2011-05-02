From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 8/8] cifs: use the server's MaxMpxCount to determine max requests in flight
Date: Mon,  2 May 2011 10:04:29 -0400
Message-ID: <1304345069-2441-9-git-send-email-jlayton@redhat.com>
References: <1304345069-2441-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304345069-2441-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we have a default cap of 50 outstanding requests and a hard
cap of 256. However, the server sends us how many requests it can handle
simultaneously via the MaxMapCount value in the NegProt request. Use
that value instead and eliminate the cifs_max_pending module parm.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c    |   12 ------------
 fs/cifs/cifsglob.h  |   14 +-------------
 fs/cifs/connect.c   |    5 +++--
 fs/cifs/transport.c |    6 +++---
 4 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fb6a2ad..22f0b1a 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -72,10 +72,6 @@ unsigned int cifs_min_small = 30;
 module_param(cifs_min_small, int, 0);
 MODULE_PARM_DESC(cifs_min_small, "Small network buffers in pool. Default: 30 "
 				 "Range: 2 to 256");
-unsigned int cifs_max_pending = CIFS_MAX_REQ;
-module_param(cifs_max_pending, int, 0);
-MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
-				   "Default: 50 Range: 2 to 256");
 unsigned short echo_retries = 5;
 module_param(echo_retries, ushort, 0644);
 MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giving up and "
@@ -1035,14 +1031,6 @@ init_cifs(void)
 	spin_lock_init(&cifs_file_list_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
-	if (cifs_max_pending < 2) {
-		cifs_max_pending = 2;
-		cFYI(1, "cifs_max_pending set to min of 2");
-	} else if (cifs_max_pending > 256) {
-		cifs_max_pending = 256;
-		cFYI(1, "cifs_max_pending set to max of 256");
-	}
-
 	rc = cifs_fscache_register();
 	if (rc)
 		goto out_clean_proc;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index b3a6404..5f7c52a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -56,17 +56,6 @@
  */
 #define CIFS_MAX_ACTIMEO (1 << 30)
 
-/*
- * MAX_REQ is the maximum number of requests that WE will send
- * on one socket concurrently. It also matches the most common
- * value of max multiplex returned by servers.  We may
- * eventually want to use the negotiated value (in case
- * future servers can handle more) when we are more confident that
- * we will not have problems oveloading the socket with pending
- * write data.
- */
-#define CIFS_MAX_REQ 50
-
 #define RFC1001_NAME_LEN 15
 #define RFC1001_NAME_LEN_WITH_NULL (RFC1001_NAME_LEN + 1)
 
@@ -185,8 +174,8 @@ struct TCP_Server_Info {
 	__u16 sec_mode;
 	bool session_estab; /* mark when very first sess is established */
 	u16 dialect; /* dialect index that server chose */
+	u16 maxReq;  /* Clients should submit no more */
 	enum securityEnum secType;
-	unsigned int maxReq;	/* Clients should submit no more */
 	/* than maxReq distinct unanswered SMBs to the server when using  */
 	/* multiplexed reads or writes */
 	unsigned int maxBuf;	/* maxBuf specifies the maximum */
@@ -905,7 +894,6 @@ GLOBAL_EXTERN unsigned int linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
 GLOBAL_EXTERN unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
 GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
-GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
 
 /* reconnect after this many failed echo attempts */
 GLOBAL_EXTERN unsigned short echo_retries;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b5e4b75..5a636ab 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -728,8 +728,8 @@ multi_t2_fnd:
 	/* Note that cifs_max_pending is normally 50, but
 	can be set at module install time to as little as two */
 	spin_lock(&GlobalMid_Lock);
-	if (atomic_read(&server->inFlight) >= cifs_max_pending)
-		atomic_set(&server->inFlight, cifs_max_pending - 1);
+	if (atomic_read(&server->inFlight) >= server->maxReq)
+		atomic_set(&server->inFlight, server->maxReq - 1);
 	/* We do not want to set the max_pending too low or we
 	could end up with the counter going negative */
 	spin_unlock(&GlobalMid_Lock);
@@ -1770,6 +1770,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->noautotune = volume_info->noautotune;
 	/* BB should we set this unconditionally now, especially for SMB2 */
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
+	tcp_ses->maxReq = 1; /* reset after NEGOTIATE */
 	atomic_set(&tcp_ses->inFlight, 0);
 	init_waitqueue_head(&tcp_ses->response_q);
 	init_waitqueue_head(&tcp_ses->request_q);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index ad32b70..89a9892 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -265,12 +265,12 @@ int wait_for_free_request(struct TCP_Server_Info *server,
 	spin_lock(&GlobalMid_Lock);
 	while (1) {
 		if ((server->is_smb2 == false) && 
-		    atomic_read(&server->inFlight) >= cifs_max_pending) {
+		    atomic_read(&server->inFlight) >= server->maxReq) {
 			spin_unlock(&GlobalMid_Lock);
 			cifs_num_waiters_inc(server);
 			wait_event(server->request_q,
-				   atomic_read(&server->inFlight)
-				     < cifs_max_pending);
+				atomic_read(&server->inFlight) <
+						server->maxReq);
 			cifs_num_waiters_dec(server);
 			spin_lock(&GlobalMid_Lock);
 #ifdef CONFIG_CIFS_SMB2
-- 
1.7.4.4
