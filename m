From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: TCP_Server_Info diet
Date: Thu, 30 Dec 2010 09:39:50 -0500
Message-ID: <1293719990-24871-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Remove fields that are completely unused, and rearrange struct
according to recommendations by "pahole".

Before:

	/* size: 1112, cachelines: 18, members: 49 */
	/* sum members: 1086, holes: 8, sum holes: 26 */
	/* bit holes: 1, sum bit holes: 7 bits */
	/* last cacheline: 24 bytes */

After:

	/* size: 1072, cachelines: 17, members: 42 */
	/* sum members: 1065, holes: 3, sum holes: 7 */
	/* last cacheline: 48 bytes */

...savings of 40 bytes per struct on x86_64. 21 bytes by field removal,
and 19 by reorganizing to eliminate holes.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |   26 +++++++++-----------------
 fs/cifs/cifssmb.c  |    2 --
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 871efa3..d6433a4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -161,6 +161,7 @@ struct TCP_Server_Info {
 	int srv_count; /* reference counter */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
 	char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
+	enum statusEnum tcpStatus; /* what we think the status is */
 	char *hostname; /* hostname portion of UNC string */
 	struct socket *ssocket;
 	struct sockaddr_storage dstaddr;
@@ -168,25 +169,16 @@ struct TCP_Server_Info {
 	wait_queue_head_t response_q;
 	wait_queue_head_t request_q; /* if more than maxmpx to srvr must block*/
 	struct list_head pending_mid_q;
-	void *Server_NlsInfo;	/* BB - placeholder for future NLS info  */
-	unsigned short server_codepage;	/* codepage for the server    */
-	enum protocolEnum protocolType;
-	char versionMajor;
-	char versionMinor;
-	bool svlocal:1;			/* local server or remote */
 	bool noblocksnd;		/* use blocking sendmsg */
 	bool noautotune;		/* do not autotune send buf sizes */
 	bool tcp_nodelay;
 	atomic_t inFlight;  /* number of requests on the wire to server */
-#ifdef CONFIG_CIFS_STATS2
-	atomic_t inSend; /* requests trying to send */
-	atomic_t num_waiters;   /* blocked waiting to get in sendrecv */
-#endif
-	enum statusEnum tcpStatus; /* what we think the status is */
 	struct mutex srv_mutex;
 	struct task_struct *tsk;
 	char server_GUID[16];
 	char secMode;
+	bool session_estab; /* mark when very first sess is established */
+	u16 dialect; /* dialect index that server chose */
 	enum securityEnum secType;
 	unsigned int maxReq;	/* Clients should submit no more */
 	/* than maxReq distinct unanswered SMBs to the server when using  */
@@ -199,8 +191,6 @@ struct TCP_Server_Info {
 	unsigned int max_vcs;	/* maximum number of smb sessions, at least
 				   those that can be specified uniquely with
 				   vcnumbers */
-	char sessid[4];		/* unique token id for this session */
-	/* (returned on Negotiate */
 	int capabilities; /* allow selective disabling of caps by smb sess */
 	int timeAdj;  /* Adjust for difference in server time zone in sec */
 	__u16 CurrentMid;         /* multiplex id - rotating counter */
@@ -210,18 +200,20 @@ struct TCP_Server_Info {
 	__u32 sequence_number; /* for signing, protected by srv_mutex */
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
-	u16 dialect; /* dialect index that server chose */
 	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
 	/* extended security flavors that server supports */
+	bool	sec_ntlmssp;		/* supports NTLMSSP */
+	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
-	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
-	bool	sec_ntlmssp;		/* supports NTLMSSP */
-	bool session_estab; /* mark when very first sess is established */
 	struct delayed_work	echo; /* echo ping workqueue job */
 #ifdef CONFIG_CIFS_FSCACHE
 	struct fscache_cookie   *fscache; /* client index cache cookie */
 #endif
+#ifdef CONFIG_CIFS_STATS2
+	atomic_t inSend; /* requests trying to send */
+	atomic_t num_waiters;   /* blocked waiting to get in sendrecv */
+#endif
 };
 
 /*
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 606deba..c5b2014 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -452,7 +452,6 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 		server->maxBuf = min((__u32)le16_to_cpu(rsp->MaxBufSize),
 				(__u32)CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
 		server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
-		GETU32(server->sessid) = le32_to_cpu(rsp->SessionKey);
 		/* even though we do not use raw we might as well set this
 		accurately, in case we ever find a need for it */
 		if ((le16_to_cpu(rsp->RawMode) & RAW_ENABLE) == RAW_ENABLE) {
@@ -566,7 +565,6 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 			(__u32) CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
 	cFYI(DBG2, "Max buf = %d", ses->server->maxBuf);
-	GETU32(ses->server->sessid) = le32_to_cpu(pSMBr->SessionKey);
 	server->capabilities = le32_to_cpu(pSMBr->Capabilities);
 	server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
 	server->timeAdj *= 60;
-- 
1.7.3.4
