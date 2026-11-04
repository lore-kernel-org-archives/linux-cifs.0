Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827701;
	b=Ut0xFZZs8mgunEb/iEdp2chguUPGNfmxDRa6/UBslT5T5k1bqwNhsdoKeehDte7jDZiz
	 YTnn39sB+ZwPMH12s1yh/6p2soEnMkB7pcgWWLzbMVeqORjS/juVdYW3gaXfFljhcDR1a
	 TycmhYwxwai5yNYmy7/bYGXTZbweTeRuUmhhpNEhjtDbaa9xnrOHntmuMytG7QC5no9De
	 SkbzZBnh/eTFoGnDFrykx6FEJ4CFPjfxuIqnhtqhy9/Hqf5AfnJ9IIrSRdNJtxWGGH7h5
	 LL5Cq3eGh58o0t9HLWq66AGYXiCw/7EW9t3eRuJl5t8qN8moWD/wLfgsG4wdEXc+WOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827701;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ovcMl0JyCowxsb8XmZjuNm/BUQ/IC3Cx//FZVb9v0Fg=;
	b=kSuW806ftYWmqvKxr+SbiiHc9VQncisiXjhu6yT1kyLM+5fjTDgA2rBbmS2A+C0CrH95
	 EiSgZK9tJDtusdbv86qb1pm8HWO6ZtEY8rE5X7w+S5T2B8onVt4cj9b9XviaUHRVGePYr
	 JVDjlWDMQ8moBI/Chnf4IgJHmMTCPnx0U03rZQHRXmFB+j1GRoOUG19VXq/hvlFD9d+hh
	 U3OmHYNU0zCwdQ9xYNa1Puepx1Y2ZifejT+Q/AcO7kj1t0+ZA2w6zKh8S9uIya/qWpoQi
	 H8ahO0XRpgJpZGDzNnfsZftae2Oc1DNwZvppq5oczEfsVfKOG2oOyRVfAIiwpJqt2yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=YZNQIJN2;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF94606C5AD;
	Wed,  4 Nov 2026 21:28:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EF94606C5AD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=YZNQIJN2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=ovcMl0JyCowxsb8XmZjuNm/BUQ/IC3Cx//FZVb9v0Fg=; b=YZNQIJN2lT+5puUtMnRWdo5Wfd
	iRh2mzvxtO1tCOQCp2Ce3jPpwXFD7dC4TLv0R7sHnGpbAgypyHJXWGkvl4aGKdRfoksthdjT1xr8r
	K8VcDPMZDKhSHhVXxyJWvSPuUmDRwY+ZeZn4KfUNa5Mpcz7f8yT6HW5tS5tKpLcNF1s+7Q4En1Vta
	eXQXlPkXB7q/YmmYmBM27S3zCALnzNymyPirgnjevLVkAv6elRqz0HjQmT5G/4qM0vuBdLqzEanpA
	Xcd73VKlqhIUGps/vVnVbYdeQdjiQLjVuFn+YGLcGZxWLRz1y1040g/9DdemzKBg+j+cF2TL+cAcf
	GH51yPlQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOiWi-00000000rHR-3eOS;
	Wed, 04 Nov 2026 18:28:14 -0300
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
Subject: [PATCH v4 09/17] smb: client: don't fail writeback preparation if the task is dying
Date: Wed,  4 Nov 2026 18:28:02 -0300
Message-ID: <20261104212810.1935575-10-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104212810.1935575-1-pc@manguebit.org>
References: <20261104212810.1935575-1-pc@manguebit.org>
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
index e124042cabf5..60c4a3103dbb 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -131,12 +131,17 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
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
@@ -145,10 +150,17 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
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
@@ -212,10 +224,15 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 
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
@@ -350,15 +367,17 @@ static void cifs_begin_writeback(struct netfs_io_request *wreq)
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
 
@@ -2824,7 +2843,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 	}
 
 	if (test_bit(CIFS_INO_TMPFILE, &cifs_inode->flags))
-		find_flags &= FIND_NO_DIRECT;
+		find_flags &= FIND_NO_REOPEN | FIND_NO_DIRECT;
 
 	cifs_sb = CIFS_SB(cifs_inode);
 
@@ -2884,6 +2903,10 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
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

