Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3DF1C862F
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 16:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782490814; cv=none; b=h7JW9ucGSPim8pqZAWpaVJx/gFCrg9g96XEL+gSYO+E0s0dACKe3EHwsmLUHoBaD2r7gCgf1qCJVUZ3m9NveJrpvigfGDQ6JKVEkrngTZYD9kvYnWqlhL5erdD02Im/tdVk7v4tWK49s7M3xDWnZjOmrciSzmYXEr4Sw0GGTS4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782490814; c=relaxed/simple;
	bh=HklE+RsUbWK8P2Wp31J1Pnnr8iwmzRLgE9tjkCQrSbs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CoH2beG7CurmwyoIeAAmh2T4/SjeqxzLQ+GX610zG90iCF/nVAFQ1x4HbOnJ+z4v2l/yYRXYU+JZr0XtIvJ/jc1gbDwCrpx89zjMA8EeDf0flS/i9l75IA9FOUeZOJIhEIGnT/J6V+/zdwytANNs52QnDpC/7A+TdsQPq/50wBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HDTsWF9w; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HDTsWF9w"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4924593f45dso15432585e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 09:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782490811; x=1783095611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qasV0QqyQvON9Pvf2sVK/cL/T84+x5XBleMWHVYC/rI=;
        b=HDTsWF9wnLMrI2HCu+u1OdLB2XQot6+BlTrCn74ndhd9SVcpk8Ws4VfhM0EnX7VRck
         tOFz5Q+NNiMHFKtkgnDvQeTnUrhB2Z/PdOzjmTt0jv2jDis6hR+pJO6KiansLC1l0Tpu
         twkyXoHY/lQ6KjivmKKwfyJSOzAEnNEsh0Qx56vvb8p0a/h/iVfi8McwqVXtmVPfhTIa
         hwYR7nUbEHuat/+JEA/nc4tvuIdCYv4q2o+7/rfq2vfmDDmxnml1BQPO9HkKSyWVfCDp
         MuxU3TLGt7PG23PwU346wZtSZX9K+L2qnCvRxdhaT6iE0Io7YIbiPOj5FA+Y9iGcyA9N
         ALKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782490811; x=1783095611;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qasV0QqyQvON9Pvf2sVK/cL/T84+x5XBleMWHVYC/rI=;
        b=TsCAqbek74Z69vy2Mwmt2y8OyhyM1OxWHyh3aSv8pwtsGSOULvfq7+HylmIDZkRddv
         1eQQ5F4TNUrBahNi3CLKx5H47MqOnzRNG5UMXMxzobFg1ugmTKCuE2sTHCsSnInU2qLo
         9R6MGXnljjk4kdSSDluXmXzg9Lkb/D0pAJovLsHV3LScf2XrztL3Yo8UWCS6hef6eRXN
         yw0klYejM/W8NNCT6KpNsJ1K3o+AOmBYtsh+iRd7Hzk4oEG0gvDHczvi0788TMEgje3i
         Fqilqx19YQ8CHVfEfGAg6jsWNgsAQ4J/RCHP68FlpdrILD++xCkxkl2e3Yty4lzYbUSJ
         wqpQ==
X-Forwarded-Encrypted: i=1; AFNElJ+tA0KzQrEWhLUeU6JDQSmRdp9IFOHVV9b1+YbvUMjD6CGS0yBDmgRg9OZIwdCXfiEBoRiw+SxsVp4o@vger.kernel.org
X-Gm-Message-State: AOJu0YzmP5GG6HRmwVit2I2Fr4qZuYi3WJiTChtRFR5N9q64FJn0MB11
	NSCUO74+IW4cY9LCNO24L7kwQc+LpyalajGv4x7kL//h2OiwXgA/Sbm+hRhUaJFuBmI=
X-Gm-Gg: AfdE7cmK4BoEDNjIzjkNjhSpo9xcT27Pl9G2sjJE+NbsN5Vlnkgjnncqe7orvmmOIVC
	Czk0F1w6uBR0WMjHxp4zmAVJcY1F4+V3oOKxmGk/cdRh9b/nXDwCeaDx5HscPL2Hx/45Q16iv5u
	xtKHAmIK9MsJnH861HcxNTcveKtUjk4lnvOV7HQBKqV66vA7qta7ZYWZSZNHy+8najqOW0qNoH4
	Dz5Ji0J35Om7+SHOg4NCgoFuNdU0d1s4768XQA8wpYWs6v/J2mSUkuG/vyWqw79xOeHPeDZ9n2s
	BjMqldO4Chmu84VmFY372yzZLKbAC+YxfOyMjmvRPqOrmcvwFrehb/G0Bs7UDiMhvUvGyhiTCae
	w77DRVaVzsdO4AAjYZNv+83nCLhA+G0f/IVqK02DwAYDwq69qCZBNdTZroUvMUb2CMd98fk/336
	Hm3gR0Mgo/eOTblEyCPwMaVRZZJik2Qw==
X-Received: by 2002:a05:600c:8b18:b0:492:37b7:6090 with SMTP id 5b1f17b1804b1-4926683b257mr103268205e9.5.1782490811161;
        Fri, 26 Jun 2026 09:20:11 -0700 (PDT)
Received: from precision ([2804:7f0:6402:38cd:c905:3f5:b088:d65d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c8afc91sm19940107eec.14.2026.06.26.09.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 09:20:10 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org
Subject: [RFC PATCH for-next] smb: client: parallelize multichannel write issue
Date: Fri, 26 Jun 2026 13:19:53 -0300
Message-ID: <20260626161953.593789-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I'm sending this as an RFC PATCH first so the approach and results can
be sanity checked more broadly.

The netfs writeback path issues write subrequests through the filesystem
issue_write() callback. For multichannel, those subrequests may target
different channels, but the issue callback is still entered serially by
the netfs issuing context.

As a result, while one channel is running the write issue path, write
subrequests for other channels may be left waiting to be issued. This
can limit multichannel writeback throughput because the channels are not
kept busy independently.

For multichannel sessions, queue the existing write issue path to a
workqueue. This lets the netfs issuing context return quickly and
continue issuing subsequent write subrequests for other channels.
Single-channel sessions keep the existing synchronous issue path.

Preliminary fio testing showed improvments in throughput by up to 2.5x
in 4MiB writes with larger dirty limits (1g/256m), 1.4x improvement for
1GiB writes with larger dirty limits, and is neutral when dirty limits
keep the pipeline shallow (4m/1m).

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cifsfs.c    | 14 +++++++++-
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/cifsproto.h |  1 +
 fs/smb/client/file.c      | 57 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index ce23924f01b3..2ade5b47ef12 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -163,6 +163,7 @@ struct workqueue_struct	*cifsoplockd_wq;
 struct workqueue_struct	*deferredclose_wq;
 struct workqueue_struct	*serverclose_wq;
 struct workqueue_struct	*cfid_put_wq;
+struct workqueue_struct	*cifs_write_issue_wq;
 __u32 cifs_lock_secret;
 
 /*
@@ -2009,9 +2010,17 @@ init_cifs(void)
 		goto out_destroy_serverclose_wq;
 	}
 
+	cifs_write_issue_wq = alloc_workqueue("cifs_write_issue",
+					      WQ_UNBOUND | WQ_MEM_RECLAIM,
+					      0);
+	if (!cifs_write_issue_wq) {
+		rc = -ENOMEM;
+		goto out_destroy_cfid_put_wq;
+	}
+
 	rc = cifs_init_inodecache();
 	if (rc)
-		goto out_destroy_cfid_put_wq;
+		goto out_destroy_write_issue_wq;
 
 	rc = cifs_init_netfs();
 	if (rc)
@@ -2079,6 +2088,8 @@ init_cifs(void)
 	cifs_destroy_netfs();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_write_issue_wq:
+	destroy_workqueue(cifs_write_issue_wq);
 out_destroy_cfid_put_wq:
 	destroy_workqueue(cfid_put_wq);
 out_destroy_serverclose_wq:
@@ -2119,6 +2130,7 @@ exit_cifs(void)
 	destroy_mids();
 	cifs_destroy_netfs();
 	cifs_destroy_inodecache();
+	destroy_workqueue(cifs_write_issue_wq);
 	destroy_workqueue(deferredclose_wq);
 	destroy_workqueue(cifsoplockd_wq);
 	destroy_workqueue(decrypt_wq);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 82e0adc1dabd..591353f261a8 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2137,6 +2137,7 @@ extern struct workqueue_struct *cifsoplockd_wq;
 extern struct workqueue_struct *deferredclose_wq;
 extern struct workqueue_struct *serverclose_wq;
 extern struct workqueue_struct *cfid_put_wq;
+extern struct workqueue_struct *cifs_write_issue_wq;
 extern __u32 cifs_lock_secret;
 
 extern mempool_t *cifs_sm_req_poolp;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 79d891f7df1a..113ffeec0e2f 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -59,6 +59,7 @@ int init_cifs_idmap(void);
 void exit_cifs_idmap(void);
 int init_cifs_spnego(void);
 void exit_cifs_spnego(void);
+int cifs_init_write_issue_wq(void);
 const char *build_path_from_dentry(struct dentry *direntry, void *page);
 char *__build_path_from_dentry_optional_prefix(struct dentry *direntry,
 					       void *page, const char *tree,
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b60344125f27..3a070962a1f5 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -38,6 +38,46 @@
 #include <trace/events/netfs.h>
 
 static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush);
+static void __cifs_issue_write(struct netfs_io_subrequest *subreq);
+
+struct cifs_issue_write_work {
+	struct work_struct work;
+	struct netfs_io_subrequest *subreq;
+};
+
+static bool cifs_write_is_mchan(struct cifs_ses *ses)
+{
+	bool is_mchan;
+
+	spin_lock(&ses->chan_lock);
+	is_mchan = ses->chan_count > 1;
+	spin_unlock(&ses->chan_lock);
+
+	return is_mchan;
+}
+
+static void cifs_issue_write_work_fn(struct work_struct *work)
+{
+	struct cifs_issue_write_work *w = container_of(work, struct cifs_issue_write_work, work);
+
+	__cifs_issue_write(w->subreq);
+	kfree(w);
+}
+
+static int cifs_issue_parallel_write(struct cifs_ses *ses,
+				      struct netfs_io_subrequest *subreq)
+{
+	struct cifs_issue_write_work *w = kmalloc_obj(*w, GFP_NOFS);
+
+	if (!w)
+		return -ENOMEM;
+
+	w->subreq = subreq;
+	INIT_WORK(&w->work, cifs_issue_write_work_fn);
+	queue_work(cifs_write_issue_wq, &w->work);
+
+	return 0;
+}
 
 /*
  * Prepare a subrequest to upload to the server.  We need to allocate credits
@@ -108,7 +148,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 /*
  * Issue a subrequest to upload to the server.
  */
-static void cifs_issue_write(struct netfs_io_subrequest *subreq)
+static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 {
 	struct cifs_io_subrequest *wdata =
 		container_of(subreq, struct cifs_io_subrequest, subreq);
@@ -142,6 +182,21 @@ static void cifs_issue_write(struct netfs_io_subrequest *subreq)
 	goto out;
 }
 
+static void cifs_issue_write(struct netfs_io_subrequest *subreq)
+{
+	struct cifs_io_subrequest *wdata = container_of(subreq, struct cifs_io_subrequest, subreq);
+	struct cifs_ses *ses = tlink_tcon(wdata->req->cfile->tlink)->ses;
+
+	if (cifs_write_is_mchan(ses)) {
+		int err = cifs_issue_parallel_write(ses, subreq);
+
+		if (!err)
+			return;
+	}
+
+	__cifs_issue_write(subreq);
+}
+
 static void cifs_netfs_invalidate_cache(struct netfs_io_request *wreq)
 {
 	cifs_invalidate_cache(wreq->inode, 0);
-- 
2.54.0

