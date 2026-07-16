Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD4031716D
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 09:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195836; cv=none; b=tBPWP0XvDzeTRpNFUaL5i9ZECnuEG4xSH1HLeqZAQNrb1vvL819mgtEKU0dF1lWqb7+kV3UfdBCRy4nAikiBhIefADd65erDBoYp6sfhKEIXYsgN1DHRNnv4XMhwHrQruGIobC45Bgb8MKafLMir/IyCbL8flY4H2TWNb2gA+oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195836; c=relaxed/simple;
	bh=OkFgctVZzvqWht8sV3MIXh1UDVnq6j6iWGEBIaF+4tk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QW5h0h2XUJcwgXMq1ewdZb75dhKA1pqTQdZxSbZTZjtAYu97p7MyDmD9NSgU2TpLi+QwO4XRZoVR+bs32bspWgtwk5YTh4ifk5QBbuuMxuDNa7yCrpFta493rNm44AGUIq7SYWZET/kNousBPmnPlNreCzaqZGgVIje/gL/F7Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YT5Wr49V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YT5Wr49V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82AC1F000E9;
	Thu, 16 Jul 2026 09:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784195834;
	bh=dQocDXTCjNTfhaeq2pjocP0fO+h/73SjoxKcf6mModA=;
	h=From:To:Cc:Subject:Date;
	b=YT5Wr49V45NN+CtZRumPjn19zDP5/EUbKU3YjQjzxxv7ByZupoDIjsoDHqNSjAQCL
	 AOfUeugscJlEeeeYjVHmnwsdfaUpRW4Wn+fKh3Esz4NSJ3hGeFuAKJ/Sbyb3r7hvDV
	 e813j0rJK+LzgqDTm9vWXFa6jaawVcKpLHGHQQLY54HdpVB/vPgjzAFA+qTM0tzhie
	 C5wEU1eGdQbGsftVpiCLvb5hTg4CgJGc2k4XskuXJS0Om4FJTFH2kYDb8shp71iNYu
	 GRmDN6aTrbbp9uqbCoyYLxyQ4i3AWsGDfTb1SiNZ8t1L2ue5hCBfwb2ZlPb9a34PKx
	 Cnf04BYO+OIeg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/7] ksmbd: implement the command sequence window
Date: Thu, 16 Jul 2026 18:57:04 +0900
Message-Id: <20260716095711.6228-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd tracked only credit counts (total_credits/outstanding_credits) and
never validated the MessageId of an incoming request. As a result a
request carrying a MessageId outside the granted range was accepted, a
MessageId could be replayed, and a 64-bit sequence wrap was not detected.

Maintain a command sequence window per connection:

  - [seq_low, seq_high) is the range of granted sequence numbers and
    seq_bitmap records which of them have been granted but not yet
    consumed. The window starts as { 0 } at connection setup.
  - smb2_set_rsp_credits() extends seq_high by the number of credits it
    grants (setting the corresponding bits), capped so the window never
    spans more than KSMBD_CMD_SEQ_WINDOW (== SMB2_MAX_CREDITS) sequence
    numbers. This implements the "limit the range of acceptable
    sequence numbers" allowance and keeps seq_bitmap usable as a ring.
  - smb2_check_sequence_number(), run for every SMB2 request from
    ksmbd_smb2_check_message(), verifies that the CreditCharge
    consecutive sequence numbers starting at MessageId lie within the
    window and have not already been consumed, then removes them and
    slides seq_low forward. CANCEL consumes nothing. A violation
    (out of window, replay, or wrap) tears the connection down.

The legacy SMB1 multi-protocol negotiate occupies sequence number 0 but
does not pass through ksmbd_smb2_check_message(), so it consumes that
sequence number explicitly; otherwise seq_low would stay pinned at 0
after the upgrade to SMB2 and eventually stall credit grants.

For an in-order client seq_high - seq_low equals total_credits, so the
window-room cap never reduces the number of credits granted. it only
engages for a client that withholds low sequence numbers.
init_smb2_max_credits() now clamps the configured maximum to
SMB2_MAX_CREDITS so the window (and its bitmap) can always represent
every outstanding sequence number.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c |  8 ++++
 fs/smb/server/connection.h | 20 ++++++++++
 fs/smb/server/smb2misc.c   | 79 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2ops.c    |  7 ++++
 fs/smb/server/smb2pdu.c    | 16 ++++++++
 fs/smb/server/smb_common.c | 17 +++++++-
 6 files changed, 146 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 2de1413ba64e..3d2b8f243a22 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -219,6 +219,14 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	conn->total_credits = 1;
 	conn->outstanding_credits = 0;
 
+	/*
+	 * The command sequence window starts as the set { 0 } when the
+	 * connection is established.
+	 */
+	conn->seq_low = 0;
+	conn->seq_high = 1;
+	__set_bit(0, conn->seq_bitmap);
+
 	init_waitqueue_head(&conn->req_running_q);
 	init_waitqueue_head(&conn->r_count_q);
 	INIT_LIST_HEAD(&conn->requests);
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 3ecfe4a7e045..8af6e19cc775 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -17,6 +17,7 @@
 #include <linux/nls.h>
 #include <linux/unicode.h>
 #include <linux/workqueue.h>
+#include <linux/bitmap.h>
 
 #include "smb_common.h"
 #include "ksmbd_work.h"
@@ -25,6 +26,15 @@ struct smbdirect_buffer_descriptor_v1;
 
 #define KSMBD_SOCKET_BACKLOG		16
 
+/*
+ * Size of the per-connection SMB2 command sequence window. This mirrors
+ * SMB2_MAX_CREDITS, the maximum number of credits (and therefore the
+ * maximum number of outstanding sequence numbers) that can be granted on
+ * a connection. It must be a power of two so the window can be indexed as
+ * a ring.
+ */
+#define KSMBD_CMD_SEQ_WINDOW		8192
+
 enum {
 	KSMBD_SESS_NEW = 0,
 	KSMBD_SESS_GOOD,
@@ -74,6 +84,16 @@ struct ksmbd_conn {
 	unsigned int			total_credits;
 	unsigned int			outstanding_credits;
 	spinlock_t			credits_lock;
+	/*
+	 * Connection command sequence window. [seq_low, seq_high) is the
+	 * range of granted sequence numbers (message IDs). seq_bitmap marks
+	 * the ones in that range that have been granted but
+	 * not yet consumed by a received request.  All three are protected by
+	 * credits_lock.
+	 */
+	u64				seq_low;
+	u64				seq_high;
+	DECLARE_BITMAP(seq_bitmap, KSMBD_CMD_SEQ_WINDOW);
 	wait_queue_head_t		req_running_q;
 	wait_queue_head_t		r_count_q;
 	/* Lock to protect requests list*/
diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index 9f3629c86291..532dea7be0b3 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -372,6 +372,75 @@ static int smb2_validate_credit_charge(struct ksmbd_work *work,
 	return ret;
 }
 
+/*
+ * Verify that the sequence number(s) consumed by an incoming request fall
+ * within the connection's command sequence window and are not a replay, then
+ * remove them from the window. Returns 0 if the request
+ * may proceed, or 1 if it is invalid and the connection must be torn down.
+ */
+static int smb2_check_sequence_number(struct ksmbd_work *work,
+				      struct smb2_hdr *hdr)
+{
+	struct ksmbd_conn *conn = work->conn;
+	u64 mid = le64_to_cpu(hdr->MessageId);
+	unsigned short charge;
+	u64 i;
+	int ret = 0;
+
+	/* An SMB2 CANCEL consumes no sequence number. */
+	if (hdr->Command == SMB2_CANCEL)
+		return 0;
+
+	/*
+	 * A multi-credit request consumes CreditCharge consecutive sequence
+	 * numbers; every other request consumes exactly one.
+	 */
+	charge = le16_to_cpu(hdr->CreditCharge);
+	if (!(conn->vals->req_capabilities & SMB2_GLOBAL_CAP_LARGE_MTU) ||
+	    charge == 0)
+		charge = 1;
+
+	/* The 64-bit sequence number space must not wrap. */
+	if (mid + charge < mid) {
+		pr_err("SMB2 sequence number wrapped (mid %llu charge %u)\n",
+		       mid, charge);
+		return 1;
+	}
+
+	spin_lock(&conn->credits_lock);
+
+	/* The whole range must lie within the granted window... */
+	if (mid < conn->seq_low || mid + charge > conn->seq_high) {
+		ksmbd_debug(SMB,
+			    "MessageId %llu (charge %u) outside command window [%llu, %llu)\n",
+			    mid, charge, conn->seq_low, conn->seq_high);
+		ret = 1;
+		goto out;
+	}
+
+	/* ...and none of it may have been consumed already (replay). */
+	for (i = mid; i < mid + charge; i++) {
+		if (!test_bit(i & (KSMBD_CMD_SEQ_WINDOW - 1), conn->seq_bitmap)) {
+			ksmbd_debug(SMB,
+				    "replayed sequence number %llu (mid %llu charge %u)\n",
+				    i, mid, charge);
+			ret = 1;
+			goto out;
+		}
+	}
+
+	/* Consume the sequence numbers and slide the low edge forward. */
+	for (i = mid; i < mid + charge; i++)
+		__clear_bit(i & (KSMBD_CMD_SEQ_WINDOW - 1), conn->seq_bitmap);
+	while (conn->seq_low < conn->seq_high &&
+	       !test_bit(conn->seq_low & (KSMBD_CMD_SEQ_WINDOW - 1),
+			 conn->seq_bitmap))
+		conn->seq_low++;
+out:
+	spin_unlock(&conn->credits_lock);
+	return ret;
+}
+
 int ksmbd_smb2_check_message(struct ksmbd_work *work)
 {
 	struct smb2_pdu *pdu = ksmbd_req_buf_next(work);
@@ -476,6 +545,16 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 	    smb2_validate_credit_charge(work, hdr))
 		return 1;
 
+	/*
+	 * A sequence number violation (out of window or a replay) is a
+	 * protocol error. tear the connection down rather than
+	 * keep accepting requests on it.
+	 */
+	if (smb2_check_sequence_number(work, hdr)) {
+		ksmbd_conn_set_exiting(work->conn);
+		return 1;
+	}
+
 	return 0;
 }
 
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index 97938150d2d9..761db8d59448 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -330,6 +330,13 @@ void init_smb2_max_trans_size(unsigned int sz)
 
 void init_smb2_max_credits(unsigned int sz)
 {
+	/*
+	 * The command sequence window (and its backing bitmap) can track at
+	 * most SMB2_MAX_CREDITS outstanding sequence numbers, so the number of
+	 * credits granted on a connection must not exceed that.
+	 */
+	if (sz > SMB2_MAX_CREDITS)
+		sz = SMB2_MAX_CREDITS;
 	smb21_server_values.max_credits = sz;
 	smb30_server_values.max_credits = sz;
 	smb302_server_values.max_credits = sz;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 295cca6cf3ae..e09c60191dc2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -388,6 +388,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	unsigned short credits_requested, aux_max;
 	unsigned short credit_charge, credits_granted = 0;
+	u64 window_room, i;
 
 	if (work->send_no_response)
 		return 0;
@@ -424,11 +425,26 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 		aux_max = 1;
 	else
 		aux_max = conn->vals->max_credits - conn->total_credits;
+
+	/*
+	 * The command sequence window must not grow beyond
+	 * KSMBD_CMD_SEQ_WINDOW sequence numbers ahead of the oldest one still
+	 * outstanding. Cap the grant by the room left in the window so that
+	 * credits are withheld until the client consumes the low end (and so
+	 * that seq_bitmap stays usable as a ring).
+	 */
+	window_room = conn->seq_low + KSMBD_CMD_SEQ_WINDOW - conn->seq_high;
+	aux_max = min_t(unsigned short, aux_max, window_room);
 	credits_granted = min_t(unsigned short, credits_requested, aux_max);
 
 	conn->total_credits += credits_granted;
 	work->credits_granted += credits_granted;
 
+	/* Extend the sequence window to cover the newly granted credits. */
+	for (i = conn->seq_high; i < conn->seq_high + credits_granted; i++)
+		__set_bit(i & (KSMBD_CMD_SEQ_WINDOW - 1), conn->seq_bitmap);
+	conn->seq_high += credits_granted;
+
 	if (!req_hdr->NextCommand) {
 		/* Update CreditRequest in last request */
 		hdr->CreditRequest = cpu_to_le16(work->credits_granted);
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 7de73223189a..e41bdd1bbffa 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -164,7 +164,22 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
 	hdr = smb_get_msg(work->request_buf);
 	if (*(__le32 *)hdr->Protocol == SMB1_PROTO_NUMBER &&
 	    hdr->Command == SMB_COM_NEGOTIATE) {
-		work->conn->outstanding_credits++;
+		struct ksmbd_conn *conn = work->conn;
+
+		conn->outstanding_credits++;
+		/*
+		 * A legacy SMB1 multi-protocol negotiate occupies sequence
+		 * number 0 but does not pass through
+		 * ksmbd_smb2_check_message(). Consume it here so that, after
+		 * the connection is upgraded to SMB2, the command sequence
+		 * window can advance instead of staying pinned at 0.
+		 */
+		spin_lock(&conn->credits_lock);
+		if (conn->seq_low == 0) {
+			__clear_bit(0, conn->seq_bitmap);
+			conn->seq_low = 1;
+		}
+		spin_unlock(&conn->credits_lock);
 		return 0;
 	}
 
-- 
2.25.1

