Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961535;
	b=1lfCmyprvY6HMXPUix4uAnTsulasClu1khB+KfNlQTKvrAxQP5GCO7ZxEfUgUxUQ5aAO
	 sSdOlqSJPqXaHWRsE12Z5AWmwzK+KasbB8zScnnPSoH5T5Kvr7+/U2Nf3IqocNfpOv4Mj
	 bUMYh9ztFZhqgdUY7HaLJlgFsFYR9xcn3eQtreQFHcTw8IIvPwPPRxdarbR5OhqJt2ucv
	 AhqXQ2GrgBg9HEjUg5FDQadWleEavlhe1OCSTlmTTYSg2+HC+7Tq922vq3PPhK32mRu6c
	 Qb1KrpOc9kc/kzCTsz0y4C7T2JgEKcj27MIxr6ZpgaOBmDdHotOPD/PAy7PtU7tGOXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961535;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B58E4pSFjKm7IGrehgXSmXdGo6N43CbyBCh2MCpRtOs=;
	b=KATCf5mFlf6LnMNRYOXiU3v82c7/m9tgM+n9tZlsSD2vunRZTNb0M8M8ww7jwvOoM1jM
	 sUbMD3yGq2s5EWksPaiYS+xgBbh+SxXEEeGsDEflxzgRQj9iAW994gI85hQymwEFAAAZa
	 0rI084n7GW4sNFAIfWHQzUfd7N32asff1I2SlAWDPIbW6NRKGV0yk0ms9VY6D0HsTRKft
	 ibfg5wiZ5BttZ4WShjTLZotSx7MiSsLPFGLFABJncajTWf4zobHW7D4XrQggAnZqC1+dc
	 tRlFHkAdKkohP/e8Ko6PrXwJ94eCayqheqSMdRnYeuS8j0GCf3v0Ln0sK23a5xEUpfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hXAZEX1l;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF198606A330
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 00:25:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF198606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hXAZEX1l
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cdb2893531bso329126a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 16:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794961534; x=1795566334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B58E4pSFjKm7IGrehgXSmXdGo6N43CbyBCh2MCpRtOs=;
        b=hXAZEX1lqtJXHIuAZhdFXkin5h5+Sw7FQSqcvxwn9+jnxeRHLTJAKd6A5NcCvRZYts
         Co4NdG+FFxfpC+RN9fQ/1R3Txrr18pXmUEL64YHSA1iMM3eHo5xE+8kmIYBK39GJy0JX
         L32QqnPQtNZgP6Lf2sz+aaMUBajeB2U514Cgnka4WU2FajW7hO6INFsK44sxMgvjFWKh
         I8tVCfa4rj8cLvZN8gdylEsyGL75LFl6229UQMk738495jg5gRNf0KncDE+j0/A/xCWQ
         DaP7fFlzl1sC4N39vOVG4MIacfCMxNVVLfVJG4Xjk6dvBxnZGgucL+jEg2tk+6JBQj2k
         sdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794961534; x=1795566334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=B58E4pSFjKm7IGrehgXSmXdGo6N43CbyBCh2MCpRtOs=;
        b=bOCJKZDOJaQcsP5XJyJsSkvcNVBFcQ+sZlNygAqKmDzLVY3qOP1kASGApWFTx8d9XZ
         tUB6p/uwA6syaJEuLHE01h1NdmmjA+DPJF7/ehZB/yyyJcXqR9WCy9GDhO9Bsg02BglZ
         xUFoSGNh0kUPRlaqOM7v7vmJMaaFMYxcKCao20e5Zz9K/p8yiF6xxn7O5j5MBp8iTsR6
         pBf78H2JC3MuQRXo5Bt0qhllj+670Ker3+EDcxiM6qtmf6twUYTI5auyNt1FAxPsPaFV
         AvkrAHEnUn0hBfrCSVnQiqKfXh6vAUbyNRR+qGNcaW6xViEstSdanOCqbKwy9i8aBtE5
         Irpg==
X-Forwarded-Encrypted: i=1; AL+hErESwnZkWAr1tGmEzNuChldsWcFIITDvbgRiIcn6TWsF4DzCbnoAv8K473qZye1NNCXxv2lLc8I/4T86@vger.kernel.org
X-Gm-Message-State: APuU4Z9A5INs7Jk/X2rvf+bOXUX71nit4ocbso3PaifbCRAbS3W+K9YM
	2opsA0iBEkXZsoJxe6E9qfnoxoOIL5frlv6j3Qh6yeBCeFyCwt3a/LNM
X-Gm-Gg: AZFdTZdyP2MQWzZjxsE0jZNV2ixT3wPuShUOZqwCm47ljv+szfs0mG/HdEYpVScXHwv
	zAVXAZ28o0wIMueLZW9OFpXyJA54MVHGyTH2/K00hLQaAvxqLbhp45FGZVveKb26lTF1Il/w0h6
	CxVsjMr+mCFjYIN54namZ+NKok/QI2n9covy1NV5mBozSpbyCrlmDU0A+ftaCLmUNJISEiwIzxS
	Fb9HTgO9NvxXsulA27B41oYtvu/QMCNLnvzE5tba6JJff8f6Nyqm5IrgdoEo9t0XMS1q2ZfJ2hS
	nIjXMnlZHtNZ7g3vfbxbbDrORG9Tv5DvSShz5KK/UesUddn0JtVbnh/hT0gzIKg+QOOkvjepHqN
	e4hTFgnRDAiAkHXNyiB1JTrdPpCCzigyHzz/HjoI7B6GXR3x3X7eI5EZR8hjeT3A6Xi+MEMVzOg
	xBPxxiC+vNM5Cr/M+QMZSbcbwYP5iiDGwY87D/k/8S1cfizW1rqphhwMMKYSH+1jyGzG0qRPsJD
	Kis95ZpSPrPzAnit0LLhp5kEfXWkxtY9FrOoLlVrvN7ptR6ayc4MBxQYZRxqO7Y+c7QgaI6LP9O
	BQvdUxYqa1fHI/FMHRU7iBh9w4/Xcxa+OCzq8+d5d52MLRaCQMKzHCHjoNeyBaiQGCCg/LKJS7K
	zYYBWArnLTJ6gY8w6kUnPBpuuuJK0TJ+w4udaMWmNFMFqkAoFrD7uZ0Aj7k+uIyLqEg6prJBrMV
	csqSUf7VYrsxm8Acp4yPGFcwEEI9T7yUPUQa18fG8H62pZLm9XTAf7fEVuvita1Q==
X-Received: by 2002:a17:90a:d44b:b0:3b0:d808:a991 with SMTP id 98e67ed59e1d1-3b3d07c3e85mr1057779a91.55.1794961533975;
        Tue, 17 Nov 2026 16:25:33 -0800 (PST)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d1c04020sm1212211a91.17.2026.11.17.16.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:25:33 -0800 (PST)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Allen Pais <apais@microsoft.com>,
	Rachel Menge <rachelmenge@linux.microsoft.com>,
	Hardik Garg <hargar@linux.microsoft.com>,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Gillian Laming <glaming@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] smb: client: drop dentries for dying cached dirs during unmount
Date: Wed, 18 Nov 2026 00:25:28 +0000
Message-ID: <20261118002529.250616-2-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118002529.250616-1-sidchintamaneni@gmail.com>
References: <20261118002529.250616-1-sidchintamaneni@gmail.com>
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

During unmount, cifs_kill_sb() calls close_all_cached_dirs() to release
all cached directory dentries and flush cfid_put_wq before calling
kill_anon_super(). Two races allow a cached_fid's dentry reference to
outlive close_all_cached_dirs() and trigger a busy-dentry panic in
generic_shutdown_super():

1. When invalidate_all_cached_dirs() or
   cifs_mark_open_handles_for_deleted_file() runs concurrently, it moves
   cached_fid entries from cfids->entries onto cfids->dying under
   cfids->cfid_list_lock, then drops cfid_list_lock before laundromat_work
   runs on cfid_put_wq. If close_all_cached_dirs() runs in that window, it
   only walks cfids->entries (missing cfids->dying) and flushes cfid_put_wq
   before laundromat_work is queued, leaving cfid->dentry held:

  Thread 1 (umount)               Thread 2 (reconnect / open_dirs)
  -----------------               --------------------------------
                                  invalidate_all_cached_dirs()
                                    spin_lock(&cfid_list_lock)
                                    list_move(&cfid->entry, &cfids->dying)
                                    spin_unlock(&cfid_list_lock)
  cifs_kill_sb()
    close_all_cached_dirs()
      spin_lock(&cfid_list_lock)
      walks cfids->entries (empty)
      spin_unlock(&cfid_list_lock)
      flush_workqueue(cfid_put_wq)
    kill_anon_super(sb)
      -> generic_shutdown_super()
         BUG: Dentry still in use (1)
         VFS: Busy inodes after unmount!
                                    mod_delayed_work(cfid_put_wq,
                                                     &cfids->laundromat_work, 0)
                                    dput(cfid->dentry) [too late]

2. When two mounts share a cifs_tcon and drop_cached_dir_by_name() (for
   example via rmdir on the sibling mount) drops the final reference in
   close_cached_dir() -> smb2_close_cached_fid(), it deletes cfid from
   cfids->entries under cfids->cfid_list_lock, unlocks cfid_list_lock, and
   calls dput(cfid->dentry) synchronously outside cfid_put_wq. A
   concurrent unmount of the superblock owning cfid->dentry can finish
   close_all_cached_dirs() and reach kill_anon_super() before that dput()
   completes.

Fix the first race by also walking cfids->dying under
cfids->cfid_list_lock in close_all_cached_dirs() and clearing cfid->dentry
under the lock. Fix the second race by detaching cfid->dentry under
cfids->cfid_list_lock in smb2_close_cached_fid() and holding
cifs_sb->outstanding_rreq across dput(dentry) so cifs_kill_sb() waits for
the in-flight dput() before calling kill_anon_super().

Fixes: 3fa640d035e5 ("smb: During unmount, ensure all cached dir instances drop their dentry")
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
---
 fs/smb/client/cached_dir.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 50217f47a0ed1..e5c924409078c 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -467,6 +467,8 @@ __releases(&cfid->cfids->cfid_list_lock)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
+	struct cifs_sb_info *cifs_sb = NULL;
+	struct dentry *dentry;
 	int rc;
 
 	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
@@ -476,10 +478,19 @@ __releases(&cfid->cfids->cfid_list_lock)
 		cfid->on_list = false;
 		cfid->cfids->num_entries--;
 	}
+	dentry = cfid->dentry;
+	cfid->dentry = NULL;
+	if (dentry) {
+		cifs_sb = CIFS_SB(dentry->d_sb);
+		atomic_inc(&cifs_sb->outstanding_rreq);
+	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 
-	dput(cfid->dentry);
-	cfid->dentry = NULL;
+	if (dentry) {
+		dput(dentry);
+		if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+			wake_up_var(&cifs_sb->outstanding_rreq);
+	}
 
 	if (cfid->is_open) {
 		rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
@@ -594,6 +605,22 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 
 			list_add_tail(&tmp_list->entry, &entry);
 		}
+		list_for_each_entry(cfid, &cfids->dying, entry) {
+			if (!cfid->dentry)
+				continue;
+			tmp_list = kmalloc_obj(*tmp_list, GFP_ATOMIC);
+			if (!tmp_list) {
+				cifs_tcon_dbg(VFS, "Out of memory while dropping dentries\n");
+				spin_unlock(&cfids->cfid_list_lock);
+				spin_unlock(&cifs_sb->tlink_tree_lock);
+				goto done;
+			}
+
+			tmp_list->dentry = cfid->dentry;
+			cfid->dentry = NULL;
+
+			list_add_tail(&tmp_list->entry, &entry);
+		}
 		spin_unlock(&cfids->cfid_list_lock);
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
-- 
2.43.0

