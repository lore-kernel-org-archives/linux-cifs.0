Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEB63CEB9E;
	Wed, 30 Sep 2026 19:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794883; cv=none; b=M9+7kgU1ghngaXL+AX14vF6nWvoYRqHvXnzQ01H/Nckb4yeg6xfbUiDE/QHw7fmjB2szqod/5fm/oCm98LdVv9Ff0sYmKaK6qzTSVrXMnD9S0csiHC0Vxg8p2tCRX+ka0i2Mht8WFi7PGEGhHUX1UttOtvRySP2XWwJjL4+LimA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794883; c=relaxed/simple;
	bh=8+bOG8AwHnovSh6kljaTv3iKMr944K6DweMcKmEGVIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnQA9v9Boq3kmO20MQE4bz0XVVir2kDZez8XdGx3WG0FAmElHbvaFPnGDY6BGI48jQhoBk1bHwN3wQ2nFRRkmLf0ngPScyWcN3Fui5t9HhLXfKmTrWw06scps0HYm7YrmvLA6i1i7a7sGKAnV+wERjvENDELJRHKWglE9zDmLp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d0VtJ7DQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0VtJ7DQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207BF1F0089C;
	Wed, 30 Sep 2026 19:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790794863;
	bh=Y3ISftF454uS262SdhXAcFS69weDyK5XjBsfznxdvKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0VtJ7DQZUrbjcpEQ6xS4dpFBkzys95VLLZjonOrsdiTFK96EM3x3l3QSWHEdIx3x
	 kvye7IvCr72AOgy4Jr8xTKdPVRUDXr4LvcEnb5ATm5Nxdpk8UxMUpY/HKvHbZVTG01
	 mnCGui5ckTem8MJrJnq1pVTzP9JUatg84SDkLv9gO7UFMIBzPUj2UMsmn0JocYalGA
	 kWOqG5ztrHA3QCLWZxZ2e5fjgU4GxWMMt65F9173bkfJ72C5w84jfhsjeUmch0P+PY
	 TSyLFl92gxH5P5zAJ0PAyzFiZgnTTlJTnensNcVS/AAEl+KUgkKShMb6Isbo/QX22J
	 W1lcD6al1UGXw==
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
Subject: [PATCH 6.6.y 1/3] cifs: Remove the RFC1002 header from smb_hdr
Date: Wed, 30 Sep 2026 15:00:58 -0400
Message-ID: <20260930190100.383713-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026092927-uproar-implement-c4b4@gregkh>
References: <2026092927-uproar-implement-c4b4@gregkh>
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

Dependency backport for Linux 6.12:

Retain only the compound_send_recv() local MID array rename from midQ to
mid. Drop the RFC1002/SMB1 refactor: this stable tree still keeps the SMB1
transport code in transport.c and struct smb_hdr in cifspdu.h, and the
target fix does not require any changes to framing or message lengths.

To allow 8f6f8a48399f82f4a83f7b9f25b9707e0062a4f9 ("smb: client: delete
compound mids on send failure before unlock") to apply and compile
unchanged, also give the existing delete_mid() its explicit server
argument and update all callers. Use ses->server in cifs_setup_request(),
matching the server used by allocate_mid(). Retain the stable mid_lock,
MID_DELETED flag, server pointer, and kref release implementation.

No functions are added, and the target's send-failure fix remains a
separate patch. The upstream subject and author are preserved.

Upstream description follows:

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

cc: Shyam Prasad N <sprasad@microsoft.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org

[ sashal: Reduced backport -- upstream 83bfbd0bb9025 touches 19 file(s), this
  backport carries 3. Not backported here:
  fs/smb/client/cifs_debug.c
  fs/smb/client/cifs_debug.h
  fs/smb/client/cifsencrypt.c
  fs/smb/client/cifsglob.h
  fs/smb/client/cifspdu.h
  fs/smb/client/cifssmb.c
  fs/smb/client/cifstransport.c
  fs/smb/client/connect.c
  ... and 9 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 8f6f8a48399f ("smb: client: delete compound mids on send failure before unlock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h     |  2 +-
 fs/smb/client/smb2transport.c |  2 +-
 fs/smb/client/transport.c     | 74 +++++++++++++++++------------------
 3 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1f37bc2923fb8..93cdb298d6327 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -83,7 +83,7 @@ extern char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 				     int add_treename);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 char *cifs_build_devname(char *nodename, const char *prepath);
-extern void delete_mid(struct mid_q_entry *mid);
+extern void delete_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid);
 void __release_mid(struct kref *refcount);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index e4adfb6325dd1..a00eaac20c6b9 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -915,7 +915,7 @@ smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
-		delete_mid(mid);
+		delete_mid(server, mid);
 		return ERR_PTR(rc);
 	}
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index a47242a0f5c6d..58c773e9760d4 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -158,14 +158,14 @@ void __release_mid(struct kref *refcount)
 }
 
 void
-delete_mid(struct mid_q_entry *mid)
+delete_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	spin_lock(&mid->server->mid_lock);
+	spin_lock(&server->mid_lock);
 	if (!(mid->mid_flags & MID_DELETED)) {
 		list_del_init(&mid->qhead);
 		mid->mid_flags |= MID_DELETED;
 	}
-	spin_unlock(&mid->server->mid_lock);
+	spin_unlock(&server->mid_lock);
 
 	release_mid(mid);
 }
@@ -851,7 +851,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	if (rc < 0) {
 		revert_current_mid(server, mid->credits);
 		server->sequence_number -= 2;
-		delete_mid(mid);
+		delete_mid(server, mid);
 	}
 
 	cifs_server_unlock(server);
@@ -986,7 +986,7 @@ cifs_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *ignored,
 		return ERR_PTR(rc);
 	rc = cifs_sign_rqst(rqst, ses->server, &mid->sequence_number);
 	if (rc) {
-		delete_mid(mid);
+		delete_mid(ses->server, mid);
 		return ERR_PTR(rc);
 	}
 	return mid;
@@ -1081,7 +1081,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   int *resp_buf_type, struct kvec *resp_iov)
 {
 	int i, j, optype, rc = 0;
-	struct mid_q_entry *midQ[MAX_COMPOUND];
+	struct mid_q_entry *mid[MAX_COMPOUND];
 	bool cancelled_mid[MAX_COMPOUND] = {false};
 	struct cifs_credits credits[MAX_COMPOUND] = {
 		{ .value = 0, .instance = 0 }
@@ -1147,35 +1147,35 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	for (i = 0; i < num_rqst; i++) {
-		midQ[i] = server->ops->setup_request(ses, server, &rqst[i]);
-		if (IS_ERR(midQ[i])) {
+		mid[i] = server->ops->setup_request(ses, server, &rqst[i]);
+		if (IS_ERR(mid[i])) {
 			revert_current_mid(server, i);
 			for (j = 0; j < i; j++)
-				delete_mid(midQ[j]);
+				delete_mid(server, mid[j]);
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
@@ -1218,20 +1218,20 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
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
+				 mid[i]->mid, le16_to_cpu(mid[i]->command));
+			send_cancel(server, &rqst[i], mid[i]);
 			spin_lock(&server->mid_lock);
-			midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
-			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED ||
-			    midQ[i]->mid_state == MID_RESPONSE_RECEIVED) {
-				midQ[i]->callback = cifs_cancelled_callback;
+			mid[i]->mid_flags |= MID_WAIT_CANCELLED;
+			if (mid[i]->mid_state == MID_REQUEST_SUBMITTED ||
+			    mid[i]->mid_state == MID_RESPONSE_RECEIVED) {
+				mid[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;
 			}
@@ -1243,36 +1243,36 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
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
+		buf = (char *)mid[i]->resp_buf;
 		resp_iov[i].iov_base = buf;
-		resp_iov[i].iov_len = midQ[i]->resp_buf_size +
+		resp_iov[i].iov_len = mid[i]->resp_buf_size +
 			HEADER_PREAMBLE_SIZE(server);
 
-		if (midQ[i]->large_buf)
+		if (mid[i]->large_buf)
 			resp_buf_type[i] = CIFS_LARGE_BUFFER;
 		else
 			resp_buf_type[i] = CIFS_SMALL_BUFFER;
 
-		rc = server->ops->check_receive(midQ[i], server,
+		rc = server->ops->check_receive(mid[i], server,
 						     flags & CIFS_LOG_ERROR);
 
 		/* mark it so buf will not be freed by delete_mid */
 		if ((flags & CIFS_NO_RSP_BUF) == 0)
-			midQ[i]->resp_buf = NULL;
+			mid[i]->resp_buf = NULL;
 
 	}
 
@@ -1302,7 +1302,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 */
 	for (i = 0; i < num_rqst; i++) {
 		if (!cancelled_mid[i])
-			delete_mid(midQ[i]);
+			delete_mid(server, mid[i]);
 	}
 
 	return rc;
@@ -1466,7 +1466,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
-	delete_mid(midQ);
+	delete_mid(server, midQ);
 	add_credits(server, &credits, 0);
 
 	return rc;
@@ -1559,7 +1559,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = cifs_sign_smb(in_buf, server, &midQ->sequence_number);
 	if (rc) {
-		delete_mid(midQ);
+		delete_mid(server, midQ);
 		cifs_server_unlock(server);
 		return rc;
 	}
@@ -1574,7 +1574,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	cifs_server_unlock(server);
 
 	if (rc < 0) {
-		delete_mid(midQ);
+		delete_mid(server, midQ);
 		return rc;
 	}
 
@@ -1599,7 +1599,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			   blocking lock to return. */
 			rc = send_cancel(server, &rqst, midQ);
 			if (rc) {
-				delete_mid(midQ);
+				delete_mid(server, midQ);
 				return rc;
 			}
 		} else {
@@ -1611,7 +1611,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			/* If we get -ENOLCK back the lock may have
 			   already been removed. Don't exit in this case. */
 			if (rc && rc != -ENOLCK) {
-				delete_mid(midQ);
+				delete_mid(server, midQ);
 				return rc;
 			}
 		}
@@ -1651,7 +1651,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
-	delete_mid(midQ);
+	delete_mid(server, midQ);
 	if (rstart && rc == -EACCES)
 		return -ERESTARTSYS;
 	return rc;
-- 
2.53.0

