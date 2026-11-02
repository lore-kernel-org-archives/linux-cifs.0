Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632536;
	b=IJ5qVnLJgYUWLhXd6ZTpgKN+YgRRCmlqQrVBgqIBQfVwBKZZ66hsVkw31djCDjrlX9Kh
	 XxAyoJepRpVbToXxgckOwqaXMwwsJ0uH1L5/mj8uChmHB7fQLgMHjz2g+76tdwGfoaaEb
	 20WoDxi5PVujznZjj2HEYYd+8nPOI2MIo5TFuLxDHeygS02ff+rwJ0iioeph8hnZLCiZ4
	 idrP0OFbspmltL6EPm59ysWb9J+ktDONqcKXV6QzVdnRHs6m9kVS8ONgs88oGPUME7qx0
	 Kxa18nsaICG6d76LUDNzA/Y6NU4dekY/iSyiOBxQN2cg3BOg1/me5R8qtccSb1atHHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632536;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0BEMFmOH5KacIdrfQvN/6kDbKvhLOg4ogPk81fGsgK8=;
	b=VXqxtsvJvyNHKDtTMn24oqiejwlbgpZn6aVar7vnCXDpE4tFHTgPVBpqTF2Dccpqsvzg
	 2NxYTLdiW8ronJCkoCFE7leAfc2QD5iaMvX82U1kWz5MezxsX4C4dXjTBpTfhxd41Egk7
	 1Cn2HNYpDAamNDIbiV5MiWqShlRCTDboBmqklMTd449wXxxdPCXUY768gM0FAGY+Gkfj1
	 Z6/driHgbh1kAO6b0BPjhpcQ/MFxrEDa+h9It6e32xycWEmHuQQsWJKzJuya/cNRs07kk
	 9z+xa7JiRUWI6jbBxLGBm0wOmVWTNlGKoG3RChKdxGfar6IhT89Hvi6aVAUUEkpltrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=bL73dCaC;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B8560B57E1;
	Mon,  2 Nov 2026 15:15:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29B8560B57E1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=bL73dCaC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=0BEMFmOH5KacIdrfQvN/6kDbKvhLOg4ogPk81fGsgK8=; b=bL73dCaCAn4zn0/vMXLYuzRyx7
	aQO6YvL4DjuTqFsAQ4KHEnzYY/ilyD9hhYwpODzbv03MSySAqgAzXoDvaM0ycY9OQosPqrpNBFNUB
	oa7nUCjLfuchwHuisX02lCyA0umA9CT7xGzO/IB27rPJI3t7JYXzVMlcUUFLczy387CCwjZXhK6qU
	9PCPvJ6CMZZXi3f57IB6XARq0jEG4F1q9DPenp5zpAn7QbttX9GlIjHVT9Rq7x+3xFgBmwFNnwymu
	LjLC3+OLLTlXIiOyjehfmLClN3fwQKj3hHMcpNqdifCNJhB5u/sogGfo9D8WITRZyczbeP6KCQI/d
	HWGy1GIQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtku-00000000aSK-0nhf;
	Mon, 02 Nov 2026 12:15:29 -0300
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
Subject: [PATCH 10/15] smb: client: don't fail writeback preparation if the task is dying
Date: Mon,  2 Nov 2026 12:15:20 -0300
Message-ID: <20261102151525.925058-11-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102151525.925058-1-pc@manguebit.org>
References: <20261102151525.925058-1-pc@manguebit.org>
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
index 2a1d26deefad..8d7d308a785d 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -127,12 +127,17 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
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
@@ -141,10 +146,17 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
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
@@ -208,10 +220,15 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 
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
@@ -341,15 +358,17 @@ static void cifs_begin_writeback(struct netfs_io_request *wreq)
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
 
@@ -2815,7 +2834,7 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
 	}
 
 	if (test_bit(CIFS_INO_TMPFILE, &cifs_inode->flags))
-		find_flags &= FIND_NO_DIRECT;
+		find_flags &= FIND_NO_REOPEN | FIND_NO_DIRECT;
 
 	cifs_sb = CIFS_SB(cifs_inode);
 
@@ -2875,6 +2894,10 @@ int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
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

