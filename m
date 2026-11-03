Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746825;
	b=EtXkC/e65OkqjAAkA6sUv6adFHLmZ+D2PdUa7TF/r+Ek1cTm/dMx0Q7ybYnkq+pLJZhK
	 zfExHL0Y9BVSE7LKyNBtlD5HL+6rPAE8LOrefctN5eeeohnl/31Ref5wiP90Gh1/ndOak
	 cmvlh8DwyuzrnHL9k4uPv1Joc6llRdFTwyuvkq9NKLipR+KdpuMs9NfFHwbbovu9cE3Sb
	 8BisHmSiPIfYFotVrPZl/thylCMaMcx00199dJ9Ba7QJUZYunXW0OCJQlqHkGigglpN46
	 kk4iIrX5MPbC8aO2ac+W3sIJGDRMjFvmKqNKMtDKSeaxVBreJ/ol1yoHxUR3SAIaIwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746825;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rxu3usRU6V45z79IJjKUZpBQggZAWEDLODVZowP/c/Q=;
	b=SNtIkzEUlDBy9iqTiOl/VoNWfdm9A1pHvk4yHKFEmGi9mywpweaaGzohWADWs4x9hRrQ
	 9E3BcV+poa2prZ4/LtVpgbEc8bjSU+hL1gR9AVzGtCVJA+ubd9vOt8KFtkCDcM+BImDNj
	 mWzJWRXabb9BRIpLZa2VKtTTzfWJxjoDikr6CReFYYUJWQCAjYU7wpVjGNowqo58ub2xT
	 QD3GdTB674g3xDKF3fGhPLBPZgbKa/VdF9zgODOlsGlC5qCDuhOaxEll4mKLy7QrtHv4+
	 WqtORnyjkLJHaWPis+Rya3WCLI6Yi/oH75RVfonEt9fxPDW4xLnb+DbFI8pEongX+SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=1HJxYVdX;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A1D606A334;
	Tue,  3 Nov 2026 23:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4A1D606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=1HJxYVdX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=rxu3usRU6V45z79IJjKUZpBQggZAWEDLODVZowP/c/Q=; b=1HJxYVdXX7OjwBGLdVtuEOVk4o
	OZJKfl9bwn3ABjq6V6oyyDLzZ+Xbn9Qhc3mE3GPCp02GQV9xUVQKkfweTeMchJ2pvqYwBmlqw8RM+
	D+rPHxDlCaosmcohP7KxN4F+1HsP3nl2z0koXqptGqO5mCplQNIMgta6vGU9yesIL+TKiKhRzVl/x
	h/utP006ybrs/5rvxl7QolmcSpZctxxpr86I3rCOq0970Tg//Ff6nI2FubBQmeYHdtdAr6pVrP1VB
	n2fv+HfOKpVw9P2dms7TmLk1gPWKfmMsa5g68DpwZvEjBHL6nDV+N0tYZLfVWu8Xqwe/7Xva8oxCU
	xTUP9iEA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xONUM-00000000kNY-0eM9;
	Tue, 03 Nov 2026 20:00:23 -0300
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
Subject: [PATCH v3 08/16] smb: client: issue writes from a worker if the task is dying
Date: Tue,  3 Nov 2026 20:00:12 -0300
Message-ID: <20261103230020.1617748-9-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103230020.1617748-1-pc@manguebit.org>
References: <20261103230020.1617748-1-pc@manguebit.org>
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

A task with a fatal signal pending can't send on the socket:
__smb_send_rqst() refuses it upfront with -ERESTARTSYS, as SIGKILL can't
be blocked and a send interrupted halfway forces a reconnect.  Writeback,
however, runs in the context of whoever starts it, so when a dying task
flushes dirty pages - close() racing with SIGKILL, or fd teardown during
exit_group() - every write subrequest gets refused:

  smb3_write_err: ... offset=0x1400000 len=0x400000 rc=-512
  cifs_flush_err: ino=... rc=-512

Since the switch to netfslib, a failed upload ends writeback with the
folios clean, so the data is silently lost: the server ends up with
20MiB of a 64MiB file while stat(2) reports the full size.

Issue writeback subrequests of dying tasks from a new cifswritebackd
workqueue instead, like afs does for all of its writes, so they get sent
from a context with no signals.  Leave direct and unbuffered writes
alone, as their callers get the error.  Use a dedicated WQ_UNBOUND
workqueue as the writes may block for long on credits, sends or reopens,
e.g. on hard mounts with an unresponsive server, and must not hold up
other cifs work such as reconnects, nor starve the WQ_MEM_RECLAIM
rescuer of cifsiod_wq.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsfs.c   | 15 +++++++++++++--
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 26 +++++++++++++++++++++++++-
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index b3735c98bfc3..7146bb22a69e 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -164,6 +164,7 @@ struct workqueue_struct	*cifsoplockd_wq;
 struct workqueue_struct	*deferredclose_wq;
 struct workqueue_struct	*serverclose_wq;
 struct workqueue_struct	*cfid_put_wq;
+struct workqueue_struct	*cifs_writeback_wq;
 __u32 cifs_lock_secret;
 
 /*
@@ -2133,9 +2134,16 @@ init_cifs(void)
 		goto out_destroy_serverclose_wq;
 	}
 
-	rc = cifs_init_inodecache();
-	if (rc)
+	cifs_writeback_wq = alloc_workqueue("cifswritebackd",
+					    WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	if (!cifs_writeback_wq) {
+		rc = -ENOMEM;
 		goto out_destroy_cfid_put_wq;
+	}
+
+	rc = cifs_init_inodecache();
+	if (rc)
+		goto out_destroy_writeback_wq;
 
 	rc = cifs_init_netfs();
 	if (rc)
@@ -2206,6 +2214,8 @@ init_cifs(void)
 	cifs_destroy_netfs();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_writeback_wq:
+	destroy_workqueue(cifs_writeback_wq);
 out_destroy_cfid_put_wq:
 	destroy_workqueue(cfid_put_wq);
 out_destroy_serverclose_wq:
@@ -2251,6 +2261,7 @@ exit_cifs(void)
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(serverclose_wq);
 	destroy_workqueue(cfid_put_wq);
+	destroy_workqueue(cifs_writeback_wq);
 	destroy_workqueue(cifsiod_wq);
 }
 
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index b6a993cc0245..e211dea91e6e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2144,6 +2144,7 @@ extern struct workqueue_struct *cifsoplockd_wq;
 extern struct workqueue_struct *deferredclose_wq;
 extern struct workqueue_struct *serverclose_wq;
 extern struct workqueue_struct *cfid_put_wq;
+extern struct workqueue_struct *cifs_writeback_wq;
 extern __u32 cifs_lock_secret;
 
 extern mempool_t *cifs_sm_req_poolp;
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 9bdcacbee8a8..e124042cabf5 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -90,6 +90,12 @@ static bool cifs_io_aborted(struct cifs_io_subrequest *subreq)
 	       tcon->need_reconnect;
 }
 
+static bool cifs_writeback_dying(struct netfs_io_subrequest *subreq)
+{
+	return subreq->rreq->origin == NETFS_WRITEBACK &&
+		fatal_signal_pending(current);
+}
+
 /*
  * Prepare a subrequest to upload to the server.  We need to allocate credits
  * so that we know the maximum amount of data that we can include in it.
@@ -166,7 +172,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 /*
  * Issue a subrequest to upload to the server.
  */
-static void cifs_issue_write(struct netfs_io_subrequest *subreq)
+static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 {
 	struct cifs_io_subrequest *wdata =
 		container_of(subreq, struct cifs_io_subrequest, subreq);
@@ -204,6 +210,24 @@ static void cifs_issue_write(struct netfs_io_subrequest *subreq)
 	goto out;
 }
 
+static void cifs_issue_write_worker(struct work_struct *work)
+{
+	struct netfs_io_subrequest *subreq;
+
+	subreq = container_of(work, struct netfs_io_subrequest, work);
+	__cifs_issue_write(subreq);
+}
+
+static void cifs_issue_write(struct netfs_io_subrequest *subreq)
+{
+	if (unlikely(cifs_writeback_dying(subreq))) {
+		subreq->work.func = cifs_issue_write_worker;
+		WARN_ON_ONCE(!queue_work(cifs_writeback_wq, &subreq->work));
+		return;
+	}
+	__cifs_issue_write(subreq);
+}
+
 static void cifs_netfs_invalidate_cache(struct netfs_io_request *wreq)
 {
 	cifs_invalidate_cache(wreq->inode, 0);
-- 
2.56.0

