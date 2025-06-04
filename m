Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C69212F94
	for <linux-cifs@vger.kernel.org>; Wed,  4 Jun 2025 10:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032328; cv=none; b=hFgGIyJkkByZ2kfzMUZZ3V0tWG8bjIGyvOhBSAKJdZNEf2qAXRae9Bs/OvQ0ZDoNzrocetOyWVex04aDgvNf2yPXr3Ge24/tXKCB5+DuULYoHr7ZACs4MM/fZVl6gGYElStoksoNaHpSyBnaIjSPNIbRjaTmBaJeY4k1LBrKxGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032328; c=relaxed/simple;
	bh=jUSXwZ2JU5BfvyGxISsNxAJNOcBzyuz6dvu40OfpaqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qv4cziV5Fr4YaTVhKphmuB9izeR4WFDqmI160QQ4xQtiVmH+Tx2VTq8SnujZNBiT4wnny/lP75VVyDGCrlPtYuSfQLe6GrTR0JuTqtZyK1AUdUZuP/qfJjbt2o4PQoxN5dKDFAVmAN4Ei9sofjx1e7oYZHXE4ElIniqZgMqMvNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l7fYV6lw; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l7fYV6lw"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-742c3d06de3so7153333b3a.0
        for <linux-cifs@vger.kernel.org>; Wed, 04 Jun 2025 03:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749032326; x=1749637126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qw3PtZiVdnv/vW6tX1csKF7nxGGb2pEKG6KpB6qgCZ0=;
        b=l7fYV6lwzWvLxpN6P/MSIJjIY2O2iHAF8207WkwOU63qzN+Zh56JgndQrSRbMRxrOH
         mp0intzYZXZE3Ay310Ql9Dx3rt7S7OuRZXoDahubzBpmdDUvX9Gk9ovajVwNvx3Ig9Ge
         oJazccW471Tjoyy5fmF7RmAVUY5bT1CYnOA4Sje6EbA1naTb5nfJvQix3Qam3U3csJZE
         RLJz3MdPoXDZJ3eqVfNJdZRuboCNPC7mPfBkVGn2IKslInidVL3z5hx9sQbs+MWqM+BI
         eK1FW6zTwzDRz8XrFUeGBrh6YuonfuvatYyOOvFJJzMzo/FqeAbVvp+LfDc5M3cVerJM
         nJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749032326; x=1749637126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qw3PtZiVdnv/vW6tX1csKF7nxGGb2pEKG6KpB6qgCZ0=;
        b=asm8NUipFN5f6zn4ZTfyYeAslrgfb8lYTjJ5PH1hW5KOQIHMZDb0DiqJs8dtUXpTLQ
         +H139bKLLkAvvVdKlxCnkbLhA1mBpqgPT1WGdwRC2LfuyiIDn9yBsoQuNCTBgWnv6W0R
         zQt+2caAuC8aPO+tmO/aU4mRAbtm6Qn50ljtrcIg8zYFGI0uV29XVzSbrsenmRABKHzp
         KnsFjjCU1NrwsoEkPs6hKPvmZkFIN5aFx6Qny1hNot1fPlu9n4wqwOfj89GrncLPX9i9
         nxSj4og2k3XpzkTdZVbRQOGjAmD05K6m0t+CXx6Bu9VFuAzEQzfFT6AH+RrFO3jpErQS
         45JQ==
X-Gm-Message-State: AOJu0YzTp3zyRb6jhnMYAyvUBgtobtQ975hiuKZ6apuTNVgvbPV26H1/
	RDv7KfZv67O+lpYyWE1pjY+6PZg64amEKoAaAVUdTTYM5ONgnRvAoRxFmR241ArztBk=
X-Gm-Gg: ASbGnctXXgmYBe+6YpIZ34fowGhzzhDhC4cpA+3l26BcBmiljC4l/d2aHDEGMwGTRIY
	qkCnteC7+JEiucmCdg49gs4wIZvtQGjFMFWZmelBvPNZRWWfaDhjs4aXOJd2vd/Q3hyBDKuVveE
	amkYKW1ihN0PLx3MzEmSNdIMLes7th1QbScldcDhMZJEnT/szFALJZoxCK2bGS93IhOL9cZdbAo
	HBUvOgjscpBdqDCQ+ih0D1453HaL0d2cZEC/r8RnSm4qe4vFHh3Opf11ueghqjmTa1MTU/RSIDX
	7EcDcI8B32jYtq83PP+yIJQrVfPQNgp/VqiC1A/aTCNS2sJQTGgtDKA48Pl9i8qzOuxSXktEWAk
	kdfQ=
X-Google-Smtp-Source: AGHT+IGeKFOnEHPTHRUko+guia9EmB94vKNL8bHm+swr3hnPxvulr6l7xYFjtVnfUozX5GiopJZH9w==
X-Received: by 2002:a17:902:f64d:b0:234:d292:be95 with SMTP id d9443c01a7336-235e1201291mr31773275ad.42.1749032314906;
        Wed, 04 Jun 2025 03:18:34 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bf8132sm100563625ad.106.2025.06.04.03.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 03:18:34 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com,
	paul@darkrain42.org,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 4/7] cifs: serialize initialization and cleanup of cfid
Date: Wed,  4 Jun 2025 15:48:13 +0530
Message-ID: <20250604101829.832577-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250604101829.832577-1-sprasad@microsoft.com>
References: <20250604101829.832577-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today we can have multiple processes calling open_cached_dir
and other workers freeing the cached dir all in parallel.
Although small sections of this code is locked to protect
individual fields, there can be races between these threads
which can be hard to debug.

This patch serializes all initialization and cleanup of
the cfid struct and the associated resources: dentry and
the server handle.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 16 ++++++++++++++++
 fs/smb/client/cached_dir.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 94538f52dfc8..2746d693d80a 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -198,6 +198,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOENT;
 	}
 
+	/*
+	 * the following is a critical section. We need to make sure that the
+	 * callers are serialized per-cfid
+	 */
+	mutex_lock(&cfid->cfid_mutex);
+
 	/*
 	 * check again that the cfid is valid (with mutex held this time).
 	 * Return cached fid if it is valid (has a lease and has a time).
@@ -208,11 +214,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	spin_lock(&cfid->fid_lock);
 	if (cfid->has_lease && cfid->time) {
 		spin_unlock(&cfid->fid_lock);
+		mutex_unlock(&cfid->cfid_mutex);
 		*ret_cfid = cfid;
 		kfree(utf16_path);
 		return 0;
 	} else if (!cfid->has_lease) {
 		spin_unlock(&cfid->fid_lock);
+		mutex_unlock(&cfid->cfid_mutex);
 		/* drop the ref that we have */
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
 		kfree(utf16_path);
@@ -229,6 +237,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	 */
 	npath = path_no_prefix(cifs_sb, path);
 	if (IS_ERR(npath)) {
+		mutex_unlock(&cfid->cfid_mutex);
 		rc = PTR_ERR(npath);
 		goto out;
 	}
@@ -389,6 +398,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
 	}
+	mutex_unlock(&cfid->cfid_mutex);
+
 	kfree(utf16_path);
 
 	if (is_replayable_error(rc) &&
@@ -432,6 +443,9 @@ smb2_close_cached_fid(struct kref *ref)
 					       refcount);
 	int rc;
 
+	/* make sure not to race with server open */
+	mutex_lock(&cfid->cfid_mutex);
+
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->on_list) {
 		list_del(&cfid->entry);
@@ -452,6 +466,7 @@ smb2_close_cached_fid(struct kref *ref)
 		if (rc) /* should we retry on -EBUSY or -EAGAIN? */
 			cifs_dbg(VFS, "close cached dir rc %d\n", rc);
 	}
+	mutex_unlock(&cfid->cfid_mutex);
 
 	free_cached_dir(cfid);
 }
@@ -666,6 +681,7 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
+	mutex_init(&cfid->cfid_mutex);
 	spin_lock_init(&cfid->fid_lock);
 	kref_init(&cfid->refcount);
 	return cfid;
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 1dfe79d947a6..93c936af2253 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -42,6 +42,7 @@ struct cached_fid {
 	struct kref refcount;
 	struct cifs_fid fid;
 	spinlock_t fid_lock;
+	struct mutex cfid_mutex;
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
 	struct work_struct put_work;
-- 
2.43.0

