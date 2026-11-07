Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024587;
	b=FWLfwRsPFgw/U1XBmceRoY1QxPjHOSHJU0FTQm1YSrWKwBvkfHaSQ+ElV7bBc059fYzQ
	 RMF2Mwdjy0RwE8l0ipEXT6RA1F5eFj4nREEMAQw/4nxX2gPnBQz3B10GNYIw+LfzakLcD
	 BugWrQanv0n1kF2t5NDyaLJndNQH+IZgBoI5Yq2SNwTuhTwS2tpmHNNas+1Z1UwsB8Ymj
	 2OzxMSbiUpFxqdvYHnIiwsQ76Qg6boOMiUxbfHbbn9faXRZIal/d/FIJIP2UrtTpcDv8a
	 yhH4lpAl3afdwzWxjZ6EilXjETUz5UCH/tPTcKwBARu5noj0qTfKF8p0V985G270Ghw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024587;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zbKLAnuBZe+4yKtzTOQDfDyNndD4zkvcGnWOdV0jqwo=;
	b=RbL2M7FRqbG6aZLHjV3Nb06n5Rn+LzCBrEM9x0k/6xERE5CwI4MgftXMXQUL8F8ANBI9
	 OOych8kcXZ9NenAOMyPIYJkUxf0pwJqnWpHQnwJedyvIgYep3ZaePiDkOttfMQX05D1/A
	 bcOM6fimUlTe5rKJSrjtDEYFPjJ4525gMQ//cffowj3Wf4AKfxIvibzv66vDoRTKbjcZb
	 9tV217K3YbD5sa4keaAKpk1bf97WWFAMrwLrk4Zl+xHvJOnVYL4FDgGlOFTqZFHpachUm
	 5QZd20YLRgWRLl8cple/R1FqslXa1uLRkXkvODftlY8lMxL0WtRcmCxkDupQKcg7pnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=k6KnVMHE;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67766606A336;
	Sat,  7 Nov 2026 04:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67766606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=k6KnVMHE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=zbKLAnuBZe+4yKtzTOQDfDyNndD4zkvcGnWOdV0jqwo=; b=k6KnVMHEuTvHJBB7gOSngWxjBC
	w1JgaMdsssIZVHpmHK3SaKYZY6WGC8FqQ6Etogq1OnDl4XQCscnx9zXppJzxFoJx1Kx4rcznzkFrR
	3gdTnkVY+NkRSEDU4DcSpaka4ij4CdsCS6R7VJpj4CfSJ9Yp1RniDyYw9TH5/AEq+qV72dglVgQIj
	iMUAGS7Uxhg4gLax8ShUZGAWrWXIqSHofgJrG5+TvByMh2us1Z9j07ikBqeG4uwBIHAOMg4J01jBE
	3It1uScMTgr9G+prmdxK7CFpuBvKnnGdYDd7qrTuolL//jUzIP0TCxtx6D8kJM9l/LQjAcliAs0vM
	2dOfWorA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkN-000000015NF-3VR4;
	Sat, 07 Nov 2026 01:09:45 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v8 11/19] smb: client: don't fail writeback preparation if the task is dying
Date: Sat,  7 Nov 2026 01:09:32 -0300
Message-ID: <20261107040940.2692656-12-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107040940.2692656-1-pc@manguebit.org>
References: <20261107040940.2692656-1-pc@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_prepare_write() may need to reopen an invalidated handle and to wait
for credits, both from the context of the task doing writeback.  A dying
task gets the reopen refused at send time and the killable credit wait
interrupted, so the subrequest is failed and, as with refused sends, its
folios end writeback clean and the data is lost.

For writeback in a dying task, skip both and prepare a credit-less
subrequest capped at SMB2_MAX_BUFFER_SIZE, as already done when the
server is low on credits.  It gets issued from cifswritebackd, which
reopens the handle if needed and takes a single credit when sending,
neither of which can be interrupted there.  Do the same when the reopen
or credit wait fails because a fatal signal arrived meanwhile.

cifs_begin_writeback() reopens the handle too when all the writable ones
got invalidated, e.g. by a reconnect.  If that fails, there is no
upload stream, so netfs ends writeback of every folio clean with no
error recorded.  Take an invalidated handle as is there and leave
reopening it to cifs_prepare_write().  If there is no writable handle at
all, record -EIO for the mapping, so that the loss gets reported.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 37 ++++++++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index e211dea91e6e..064a2cdab4d9 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1894,6 +1894,7 @@ enum cifs_find_flags {
 	FIND_NO_PENDING_DELETE	= (1U << 2),
 	FIND_OPEN_FLAGS		= (1U << 3),
 	FIND_NO_DIRECT		= (1U << 4),
+	FIND_NO_REOPEN		= (1U << 5),
 };
 
 #define   MID_FREE 0
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1bd8edbc8d7b..396524c3f2b6 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -135,12 +135,17 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 		cifs_negotiate_wsize(server, cifs_sb->ctx,
 				     tlink_tcon(req->cfile->tlink));
 
+	if (cifs_writeback_dying(subreq))
+		goto defer;
+
 retry:
 	if (open_file->invalidHandle) {
 		rc = cifs_reopen_file(open_file, false);
 		if (rc < 0) {
 			if (rc == -EAGAIN)
 				goto retry;
+			if (cifs_writeback_dying(subreq))
+				goto defer;
 			subreq->error = rc;
 			return netfs_prepare_write_failed(subreq);
 		}
@@ -149,10 +154,17 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	rc = server->ops->wait_mtu_credits(server, wsize, &stream->sreq_max_len,
 					   &wdata->credits);
 	if (rc < 0) {
+		if (cifs_writeback_dying(subreq))
+			goto defer;
 		subreq->error = rc;
 		return netfs_prepare_write_failed(subreq);
 	}
+	goto out;
 
+defer:
+	wdata->credits = (struct cifs_credits){};
+	stream->sreq_max_len = min_t(size_t, wsize, SMB2_MAX_BUFFER_SIZE);
+out:
 	wdata->credits.rreq_debug_id = subreq->rreq->debug_id;
 	wdata->credits.rreq_debug_index = subreq->debug_index;
 	wdata->credits.in_flight_check = 1;
@@ -216,10 +228,15 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 
 static void cifs_issue_write_worker(struct work_struct *work)
 {
-	struct netfs_io_subrequest *subreq;
+	struct cifs_io_subrequest *wdata;
+	struct cifsFileInfo *cfile;
 
-	subreq = container_of(work, struct netfs_io_subrequest, work);
-	__cifs_issue_write(subreq);
+	wdata = container_of(work, struct cifs_io_subrequest, subreq.work);
+	cfile = wdata->req->cfile;
+	while (cfile->invalidHandle &&
+	       cifs_reopen_file(cfile, false) == -EAGAIN)
+		;
+	__cifs_issue_write(&wdata->subreq);
 }
 
 static void cifs_issue_write(struct netfs_io_subrequest *subreq)
@@ -354,15 +371,17 @@ static void cifs_begin_writeback(struct netfs_io_request *wreq)
 	struct cifs_io_request *req = container_of(wreq, struct cifs_io_request, rreq);
 	int ret;
 
-	ret = cifs_get_writable_file(CIFS_I(wreq->inode), FIND_NO_DIRECT,
+	ret = cifs_get_writable_file(CIFS_I(wreq->inode),
+				     FIND_NO_REOPEN | FIND_NO_DIRECT,
 				     &req->cfile);
 	if (ret) {
-		ret = cifs_get_writable_file(CIFS_I(wreq->inode), FIND_ANY,
-					     &req->cfile);
+		ret = cifs_get_writable_file(CIFS_I(wreq->inode),
+					     FIND_NO_REOPEN, &req->cfile);
 	}
 	if (ret) {
 		cifs_dbg(VFS, "%s: couldn't find writable handle: %d\n",
 			 __func__, ret);
+		mapping_set_error(wreq->mapping, -EIO);
 		return;
 	}
 
@@ -2828,7 +2847,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 	}
 
 	if (test_bit(CIFS_INO_TMPFILE, &cifs_inode->flags))
-		find_flags &= FIND_NO_DIRECT;
+		find_flags &= FIND_NO_REOPEN | FIND_NO_DIRECT;
 
 	cifs_sb = CIFS_SB(cifs_inode);
 
@@ -2888,6 +2907,10 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 	spin_unlock(&cifs_inode->open_file_lock);
 
 	if (inv_file) {
+		if (find_flags & FIND_NO_REOPEN) {
+			*ret_file = inv_file;
+			return 0;
+		}
 		rc = cifs_reopen_file(inv_file, false);
 		if (!rc) {
 			*ret_file = inv_file;
-- 
2.56.0

