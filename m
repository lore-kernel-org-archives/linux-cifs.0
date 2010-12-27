From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/18] cifs: set up recurring workqueue job to do SMB echo requests
Date: Sun, 26 Dec 2010 21:30:02 -0500
Message-ID: <1293417006-6417-15-git-send-email-jlayton@redhat.com>
References: <1293417006-6417-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293417006-6417-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/connect.c  |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index db90fe0..64d69f9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -218,6 +218,7 @@ struct TCP_Server_Info {
 	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
 	bool	sec_ntlmssp;		/* supports NTLMSSP */
 	bool session_estab; /* mark when very first sess is established */
+	struct delayed_work	echo; /* echo ping workqueue job */
 #ifdef CONFIG_CIFS_FSCACHE
 	struct fscache_cookie   *fscache; /* client index cache cookie */
 #endif
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7890bc1..57187c6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -52,6 +52,9 @@
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
 
+/* SMB echo "timeout" -- FIXME: tunable? */
+#define SMB_ECHO_INTERVAL (60 * HZ)
+
 extern void SMBNTencrypt(unsigned char *passwd, unsigned char *c8,
 			 unsigned char *p24);
 
@@ -333,6 +336,26 @@ static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTargetSMB)
 
 }
 
+static void
+cifs_echo_request(struct work_struct *work)
+{
+	int rc;
+	struct TCP_Server_Info *server = container_of(work,
+					struct TCP_Server_Info, echo.work);
+
+	/* no need to ping if we got a response recently */
+	if (time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
+		goto requeue_echo;
+
+	rc = CIFSSMBEcho(server);
+	if (rc)
+		cFYI(1, "Unable to send echo request to server: %s",
+			server->hostname);
+
+requeue_echo:
+	queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECHO_INTERVAL);
+}
+
 static int
 cifs_demultiplex_thread(struct TCP_Server_Info *server)
 {
@@ -1569,6 +1592,8 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
 	list_del_init(&server->tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
+	cancel_delayed_work_sync(&server->echo);
+
 	spin_lock(&GlobalMid_Lock);
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);
@@ -1660,6 +1685,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->sequence_number = 0;
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
+	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
 
 	/*
 	 * at this point we are the only ones with the pointer
@@ -1708,6 +1734,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	cifs_fscache_get_client_cookie(tcp_ses);
 
+	/* queue echo request delayed work */
+	queue_delayed_work(system_nrt_wq, &tcp_ses->echo, SMB_ECHO_INTERVAL);
+
 	return tcp_ses;
 
 out_err_crypto_release:
-- 
1.7.3.4
