Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D6351477A;
	Wed, 30 Sep 2026 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786421; cv=none; b=JgOUHcU6E8BiWQM3QnhLTkq5KEpUacblc1EG+ydZ05F4gCKebPDdq0MZiT5xLZkEbv3aqOiV4d7HbGMFYIvWgGrXrNH8NV25jE3/WMhbJC0qmZV2cxJwjfKVE1gSfqt2aUTjJmpB6oNHykBkMG7YiONhyXS9x143cHsxg+L+Tq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786421; c=relaxed/simple;
	bh=N8GYaWTC0rUcAxPnIEiYJSiaJA+klV7VmQhi4X66//Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Shi+shXQYgF+zJRLLGs7bnWmk6LE7+hBNS+dXflarqIJxZQm+sCtmtow4ViqRoMXP5d4E0jd0dUTd5mZA6B0C841FeG8TUCqI9CbQObNo89RFrEMf8bX6yXNgHoiLjTrIQ8P2UexRtGBFZQYR312VKYcvpVs6uHkriZLCN9wyxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHALs2h3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHALs2h3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8261F0089A;
	Wed, 30 Sep 2026 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790786419;
	bh=iPUuZLmAEeFRLgcWPsoOfbwxyIyXceeZl5aZ/gyXQ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHALs2h3RGR2UbhOhinhhr5VxRbpfCau4S7hEWLaQQ48ltJweoktvuG+2BrwXcRgX
	 WpD9OR1LMiS4aHy4kyOdf+A4va6ixENLgPy9FT3qnw9dZoOjr6ePoSXwm7gM8UBHZX
	 qWO46+qyY0nETAeC++5uSQhXOznrGtOp8P56rgNErbDQUD+RU1zp0qf0ikAwdHpUFS
	 s+1269+gq9yYFu5NedmJyevRJ4dS6WQXPR3MrqZ/wElQBZY1ZIlh6PC16qZ+rp+KWi
	 Uje/UeLgNB2fUBDOb1Ylw0QzF8MfOKyrmrutyr13FFpeq7GePrfbbSpkHx1pe4Y4e4
	 B3JkJHWo27ofg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Tom Talpey <tom@talpey.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18.y 1/2] cifs: Remove the RFC1002 header from smb_hdr
Date: Wed, 30 Sep 2026 12:40:16 -0400
Message-ID: <20260930164017.3227931-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026092947-pull-universe-5b22@gregkh>
References: <2026092947-pull-universe-5b22@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 83bfbd0bb9025f98fa62b44f93bd67466773d1db ]

Remove the RFC1002 header from struct smb_hdr as used for SMB-1.0.  This
simplifies the SMB-1.0 code by simplifying a lot of places that have to add
or subtract 4 to work around the fact that the RFC1002 header isn't really
part of the message and the base for various offsets within the message is
from the base of the smb_hdr, not the RFC1002 header.

Further, clean up a bunch of places that require an extra kvec struct
specifically pointing to the RFC1002 header, such that kvec[0].iov_base
must be exactly 4 bytes before kvec[1].iov_base.

This allows the header preamble size stuff to be removed too.

The size of the request and response message are then handed around either
directly or by summing the size of all the iov_len members in the kvec
array for which we have a count.

Also, this simplifies and cleans up the common transmission and receive
paths for SMB1 and SMB2/3 as there no longer needs to be special handling
casing for SMB1 messages as the RFC1002 header is now generated on the fly
for SMB1 as it is for SMB2/3.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

Stable dependency adaptation for 6c5c547f037bc18f0b8d0b5db5a648f8f630ce85:

Retain only the midQ-to-mid rename in compound_send_recv(). Prepare its
response-copy block using the corresponding layout from 62432a3f51450:
check the received response first, then copy it and transfer ownership
inside the resp_iov guard. This provides the context needed for the target
to defer response-buffer transfers until compound synchronization finishes.

Omit the SMB1 RFC1002 conversion and all other unrelated hunks. This stable
tree still defines smb_hdr in client/cifspdu.h, uses the older negotiate
and filesystem-info type names, and has moved CIFSTCon and transaction2
helpers out of the upstream locations. Restoring those functions or
importing the intervening SMB1 reorganization is unnecessary for the target.
Keep HEADER_PREAMBLE_SIZE(server) in the response length because SMB1 still
reaches this shared path through SendReceive2(). No functions are added.

The target applies cleanly with a three-way application on this adaptation.

cc: Shyam Prasad N <sprasad@microsoft.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org

[ sashal: Reduced backport -- upstream 83bfbd0bb9025 touches 19 file(s), this
  backport carries 1. Not backported here:
  fs/smb/client/cifs_debug.c
  fs/smb/client/cifs_debug.h
  fs/smb/client/cifsencrypt.c
  fs/smb/client/cifsglob.h
  fs/smb/client/cifspdu.h
  fs/smb/client/cifsproto.h
  fs/smb/client/cifssmb.c
  fs/smb/client/cifstransport.c
  ... and 10 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 6c5c547f037b ("smb: client: close completed creates on compound wait errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/transport.c | 73 ++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 4da3d62b6481e..53db53a78d6c5 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -864,7 +864,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   int *resp_buf_type, struct kvec *resp_iov)
 {
 	int i, j, optype, rc = 0;
-	struct mid_q_entry *midQ[MAX_COMPOUND];
+	struct mid_q_entry *mid[MAX_COMPOUND];
 	bool cancelled_mid[MAX_COMPOUND] = {false};
 	struct cifs_credits credits[MAX_COMPOUND] = {
 		{ .value = 0, .instance = 0 }
@@ -930,35 +930,35 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	for (i = 0; i < num_rqst; i++) {
-		midQ[i] = server->ops->setup_request(ses, server, &rqst[i]);
-		if (IS_ERR(midQ[i])) {
+		mid[i] = server->ops->setup_request(ses, server, &rqst[i]);
+		if (IS_ERR(mid[i])) {
 			revert_current_mid(server, i);
 			for (j = 0; j < i; j++)
-				delete_mid(midQ[j]);
+				delete_mid(mid[j]);
 			cifs_server_unlock(server);
 
 			/* Update # of requests on wire to server */
 			for (j = 0; j < num_rqst; j++)
 				add_credits(server, &credits[j], optype);
-			return PTR_ERR(midQ[i]);
+			return PTR_ERR(mid[i]);
 		}
 
-		midQ[i]->mid_state = MID_REQUEST_SUBMITTED;
-		midQ[i]->optype = optype;
+		mid[i]->mid_state = MID_REQUEST_SUBMITTED;
+		mid[i]->optype = optype;
 		/*
 		 * Invoke callback for every part of the compound chain
 		 * to calculate credits properly. Wake up this thread only when
 		 * the last element is received.
 		 */
 		if (i < num_rqst - 1)
-			midQ[i]->callback = cifs_compound_callback;
+			mid[i]->callback = cifs_compound_callback;
 		else
-			midQ[i]->callback = cifs_compound_last_callback;
+			mid[i]->callback = cifs_compound_last_callback;
 	}
 	rc = smb_send_rqst(server, num_rqst, rqst, flags);
 
 	for (i = 0; i < num_rqst; i++)
-		cifs_save_when_sent(midQ[i]);
+		cifs_save_when_sent(mid[i]);
 
 	if (rc < 0) {
 		revert_current_mid(server, num_rqst);
@@ -1001,23 +1001,23 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	spin_unlock(&ses->ses_lock);
 
 	for (i = 0; i < num_rqst; i++) {
-		rc = wait_for_response(server, midQ[i]);
+		rc = wait_for_response(server, mid[i]);
 		if (rc != 0)
 			break;
 	}
 	if (rc != 0) {
 		for (; i < num_rqst; i++) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
-				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
-			send_cancel(server, &rqst[i], midQ[i]);
-			spin_lock(&midQ[i]->mid_lock);
-			midQ[i]->wait_cancelled = true;
-			if (midQ[i]->callback) {
-				midQ[i]->callback = cifs_cancelled_callback;
+				 mid[i]->mid, le16_to_cpu(mid[i]->command));
+			send_cancel(server, &rqst[i], mid[i]);
+			spin_lock(&mid[i]->mid_lock);
+			mid[i]->wait_cancelled = true;
+			if (mid[i]->callback) {
+				mid[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;
 			}
-			spin_unlock(&midQ[i]->mid_lock);
+			spin_unlock(&mid[i]->mid_lock);
 		}
 	}
 
@@ -1025,37 +1025,38 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		if (rc < 0)
 			goto out;
 
-		rc = cifs_sync_mid_result(midQ[i], server);
+		rc = cifs_sync_mid_result(mid[i], server);
 		if (rc != 0) {
 			/* mark this mid as cancelled to not free it below */
 			cancelled_mid[i] = true;
 			goto out;
 		}
 
-		if (!midQ[i]->resp_buf ||
-		    midQ[i]->mid_state != MID_RESPONSE_READY) {
+		if (!mid[i]->resp_buf ||
+		    mid[i]->mid_state != MID_RESPONSE_READY) {
 			rc = -EIO;
 			cifs_dbg(FYI, "Bad MID state?\n");
 			goto out;
 		}
 
-		buf = (char *)midQ[i]->resp_buf;
-		resp_iov[i].iov_base = buf;
-		resp_iov[i].iov_len = midQ[i]->resp_buf_size +
-			HEADER_PREAMBLE_SIZE(server);
+		rc = server->ops->check_receive(mid[i], server,
+						flags & CIFS_LOG_ERROR);
 
-		if (midQ[i]->large_buf)
-			resp_buf_type[i] = CIFS_LARGE_BUFFER;
-		else
-			resp_buf_type[i] = CIFS_SMALL_BUFFER;
-
-		rc = server->ops->check_receive(midQ[i], server,
-						     flags & CIFS_LOG_ERROR);
+		if (resp_iov) {
+			buf = (char *)mid[i]->resp_buf;
+			resp_iov[i].iov_base = buf;
+			resp_iov[i].iov_len = mid[i]->resp_buf_size +
+				HEADER_PREAMBLE_SIZE(server);
 
-		/* mark it so buf will not be freed by delete_mid */
-		if ((flags & CIFS_NO_RSP_BUF) == 0)
-			midQ[i]->resp_buf = NULL;
+			if (mid[i]->large_buf)
+				resp_buf_type[i] = CIFS_LARGE_BUFFER;
+			else
+				resp_buf_type[i] = CIFS_SMALL_BUFFER;
 
+			/* mark it so buf will not be freed by delete_mid */
+			if ((flags & CIFS_NO_RSP_BUF) == 0)
+				mid[i]->resp_buf = NULL;
+		}
 	}
 
 	/*
@@ -1084,7 +1085,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 */
 	for (i = 0; i < num_rqst; i++) {
 		if (!cancelled_mid[i])
-			delete_mid(midQ[i]);
+			delete_mid(mid[i]);
 	}
 
 	return rc;
-- 
2.53.0

