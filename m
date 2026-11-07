Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024587;
	b=YgogJ4PSCNiYPBL2TamdgGgKgkCfAThl0aomtID4rsBb1vyiIVaYwDTydXs0UMZPE+D0
	 DeRY/beDqv33tqtwoP/zCunN1nGi1xTAtWfpEAI4M+z3SOxpNbQ9CMMf1wJ23j/BlVC11
	 n3ouk6Ev7GvUvRfVzTo2fPoxw7jHhDXiic1T/OwagNLIL5myVH9Vlj4EcJ7RVU2jmfcfp
	 y9pGCXKX3A+xS9L9LtlaWStK9i0U4J2eArV2YK6fLhI8It4d/EmRRokH8InGiQ5mu/NQf
	 MtEiHIjzwufzUKLG6eXf8NGDzckwmbmoWkf0/m/WJHuHfLfByIWBxOciYRRFspwDhYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024587;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cCBhluogALMB9ict55RUcD1t3S2bLQ055nWP0iu3cWw=;
	b=cr9fgRbe4/owSF7GfkyCAP3qSVuugO/1XHVhoIlpWgcV5X0c1PMMxb+ZYvq2aT9XuWNv
	 8R2Idlrn+T7RaiRHNF7KmBN6Gqhfvp/ZMWBRmvnIpuhrBp4PbuU8jiPHeELlFdFXcdWhD
	 Ly0Xqs92WVjJAeYYaZZQ52sGz62aQqqqXOCtB0m1SvJeOE+2g1PWc88ONcSGesCIcxFH8
	 69t66mlImNHcr6pah8JzoBRZfsBN4Y0ciXJQi06Iu5hEB5DAGce6z/QPZTimS5cYzaF20
	 MCjysXXuFWJyL7eqe+DkVWzBHrl09W0R59ZJD4Ob6Erk7Xx+MJGC06S5V7EU5nkYdaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=RHo65pc9;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5C1606A335;
	Sat,  7 Nov 2026 04:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E5C1606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=RHo65pc9
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=cCBhluogALMB9ict55RUcD1t3S2bLQ055nWP0iu3cWw=; b=RHo65pc9gC9EYROKho94XMlwH0
	i4Dy5YQo+AgPTkpigOqctbEePXTMnfrJmBeyKr2LRkmyKAJ/xPX1EfaV/vFeXIL/t2JLlTcBa0wob
	SyIiQ94k4syGHMibbLCiUNqcW5LrdgqIsjpGAISyF+mTD8CEec86licahOkRmCYAIDuaynCDV54RQ
	wMVA0DCeOJdtYPRiWUkYB0Q5kxs1palFrv8EMuB3B8curSvLm7s7hrZVOSSKqhVA/44owEQBTW7Zj
	OqZLXLaCvJrVtHNjkPcvOLFckUFXGMyLCKp8DaaSh2t6E1JwQKXoHYSZCCaqW2eeye5ijokCWJx1X
	lH4ijkNA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkN-000000015N4-25sb;
	Sat, 07 Nov 2026 01:09:44 -0300
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
Subject: [PATCH v8 10/19] smb: client: issue writes from a worker if the task is dying
Date: Sat,  7 Nov 2026 01:09:31 -0300
Message-ID: <20261107040940.2692656-11-pc@manguebit.org>
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
index 0d2db0dd43f2..1bd8edbc8d7b 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -94,6 +94,12 @@ static bool cifs_io_aborted(struct cifs_io_subrequest *subreq)
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
@@ -170,7 +176,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 /*
  * Issue a subrequest to upload to the server.
  */
-static void cifs_issue_write(struct netfs_io_subrequest *subreq)
+static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 {
 	struct cifs_io_subrequest *wdata =
 		container_of(subreq, struct cifs_io_subrequest, subreq);
@@ -208,6 +214,24 @@ static void cifs_issue_write(struct netfs_io_subrequest *subreq)
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

