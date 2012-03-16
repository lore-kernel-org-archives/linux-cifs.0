From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 10/11] CIFS: Expand CurrentMid field
Date: Fri, 16 Mar 2012 18:09:33 +0300
Message-ID: <1331910574-998-11-git-send-email-piastry@etersoft.ru>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331910574-998-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

While in CIFS/SMB we have 16 bit mid, in SMB2 it is 64 bit.
Convert the existing field to 64 bit and mask off higher bits
for CIFS/SMB.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    2 +-
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/misc.c      |   84 ++++++++++++++++++++++++++++-----------------------
 3 files changed, 48 insertions(+), 40 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a403398..b213458 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -282,7 +282,7 @@ struct TCP_Server_Info {
 				   vcnumbers */
 	int capabilities; /* allow selective disabling of caps by smb sess */
 	int timeAdj;  /* Adjust for difference in server time zone in sec */
-	__u16 CurrentMid;         /* multiplex id - rotating counter */
+	__u64 CurrentMid;         /* multiplex id - rotating counter */
 	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index db38a40..8958721 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -115,7 +115,7 @@ extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
 				void **request_buf);
 extern int CIFS_SessSetup(unsigned int xid, struct cifs_ses *ses,
 			     const struct nls_table *nls_cp);
-extern __u16 GetNextMid(struct TCP_Server_Info *server);
+extern __u64 GetNextMid(struct TCP_Server_Info *server);
 extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
 extern u64 cifs_UnixTimeToNT(struct timespec);
 extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 88459d0..0b743b7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -213,54 +213,61 @@ cifs_small_buf_release(void *buf_to_free)
 }
 
 /*
-	Find a free multiplex id (SMB mid). Otherwise there could be
-	mid collisions which might cause problems, demultiplexing the
-	wrong response to this request. Multiplex ids could collide if
-	one of a series requests takes much longer than the others, or
-	if a very large number of long lived requests (byte range
-	locks or FindNotify requests) are pending.  No more than
-	64K-1 requests can be outstanding at one time.  If no
-	mids are available, return zero.  A future optimization
-	could make the combination of mids and uid the key we use
-	to demultiplex on (rather than mid alone).
-	In addition to the above check, the cifs demultiplex
-	code already used the command code as a secondary
-	check of the frame and if signing is negotiated the
-	response would be discarded if the mid were the same
-	but the signature was wrong.  Since the mid is not put in the
-	pending queue until later (when it is about to be dispatched)
-	we do have to limit the number of outstanding requests
-	to somewhat less than 64K-1 although it is hard to imagine
-	so many threads being in the vfs at one time.
-*/
-__u16 GetNextMid(struct TCP_Server_Info *server)
+ * Find a free multiplex id (SMB mid). Otherwise there could be
+ * mid collisions which might cause problems, demultiplexing the
+ * wrong response to this request. Multiplex ids could collide if
+ * one of a series requests takes much longer than the others, or
+ * if a very large number of long lived requests (byte range
+ * locks or FindNotify requests) are pending. No more than
+ * 64K-1 requests can be outstanding at one time. If no
+ * mids are available, return zero. A future optimization
+ * could make the combination of mids and uid the key we use
+ * to demultiplex on (rather than mid alone).
+ * In addition to the above check, the cifs demultiplex
+ * code already used the command code as a secondary
+ * check of the frame and if signing is negotiated the
+ * response would be discarded if the mid were the same
+ * but the signature was wrong. Since the mid is not put in the
+ * pending queue until later (when it is about to be dispatched)
+ * we do have to limit the number of outstanding requests
+ * to somewhat less than 64K-1 although it is hard to imagine
+ * so many threads being in the vfs at one time.
+ */
+__u64 GetNextMid(struct TCP_Server_Info *server)
 {
-	__u16 mid = 0;
-	__u16 last_mid;
+	__u64 mid = 0;
+	__u16 last_mid, cur_mid;
 	bool collision;
 
 	spin_lock(&GlobalMid_Lock);
-	last_mid = server->CurrentMid; /* we do not want to loop forever */
-	server->CurrentMid++;
-	/* This nested loop looks more expensive than it is.
-	In practice the list of pending requests is short,
-	fewer than 50, and the mids are likely to be unique
-	on the first pass through the loop unless some request
-	takes longer than the 64 thousand requests before it
-	(and it would also have to have been a request that
-	 did not time out) */
-	while (server->CurrentMid != last_mid) {
+
+	/* mid is 16 bit only for CIFS/SMB */
+	cur_mid = (__u16)((server->CurrentMid) & 0xffff);
+	/* we do not want to loop forever */
+	last_mid = cur_mid;
+	cur_mid++;
+
+	/*
+	 * This nested loop looks more expensive than it is.
+	 * In practice the list of pending requests is short,
+	 * fewer than 50, and the mids are likely to be unique
+	 * on the first pass through the loop unless some request
+	 * takes longer than the 64 thousand requests before it
+	 * (and it would also have to have been a request that
+	 * did not time out).
+	 */
+	while (cur_mid != last_mid) {
 		struct mid_q_entry *mid_entry;
 		unsigned int num_mids;
 
 		collision = false;
-		if (server->CurrentMid == 0)
-			server->CurrentMid++;
+		if (cur_mid == 0)
+			cur_mid++;
 
 		num_mids = 0;
 		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 			++num_mids;
-			if (mid_entry->mid == server->CurrentMid &&
+			if (mid_entry->mid == cur_mid &&
 			    mid_entry->midState == MID_REQUEST_SUBMITTED) {
 				/* This mid is in use, try a different one */
 				collision = true;
@@ -282,10 +289,11 @@ __u16 GetNextMid(struct TCP_Server_Info *server)
 			server->tcpStatus = CifsNeedReconnect;
 
 		if (!collision) {
-			mid = server->CurrentMid;
+			mid = (__u64)cur_mid;
+			server->CurrentMid = mid;
 			break;
 		}
-		server->CurrentMid++;
+		cur_mid++;
 	}
 	spin_unlock(&GlobalMid_Lock);
 	return mid;
-- 
1.7.1
