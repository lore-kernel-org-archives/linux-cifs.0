Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F916214204
	for <linux-cifs@vger.kernel.org>; Mon,  3 Nov 2025 22:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762210677; cv=none; b=gu1AHrpO9AVeYrLP/MnwxiuiGAjiA6yr3JRsFzOCff6oVvMuWT4yzuTREmwT6I5+OQzVrkRC+/TW4TVtl4zWiKrFuC6IeELAVTabaUan0JdY5oO3BVmdqwA4TI9pBQbLsvfq5ad2GksTst+5+MHXDbgafpDWEzaHojsxzukdVFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762210677; c=relaxed/simple;
	bh=aXKHUZg6WiIxqWjF49OQA+hCEb5+P+5lJuhNpJEt9/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nxb67yqWcqgToaBEHl3dH6N1ScTrxXtWwUWSCeOwSIFHXaQrSQuoZNmlsV7y861VUY9utuQRdSUzul1lo3zrqY39+9K5Nl32jPvak3cKypg7WXY7WW15rHHlLCscx1GR1D2M8fCjP5gOJM/d38ib5fe/4SW5+ITIkUXZvkxEnlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BXG30uZT; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BXG30uZT"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3ee64bc6b90so3873170f8f.0
        for <linux-cifs@vger.kernel.org>; Mon, 03 Nov 2025 14:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762210674; x=1762815474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=woaq09gBMKAgzKkT28bSEWfquvq2rcTRJnnMzH9zQEM=;
        b=BXG30uZTfjA6FIEijtAs7S8y6K94Gm36zjsl/sX3hcf1u7oKHh/Hi33D6BFUegLNSz
         7UYMRP5Y6/rEKjRkm9WHmx4gGp9RyDSaqeojPdCpsNDdS0uawfwohJp1ZkvfPFYq2wcw
         goDn9QeWz6Fp98F8CD0TV8SA5c++1Ir3EBeybOoOc+Q534xcsdoP9Tas6CnT/4w+Cv3I
         RTcRYf21Zl4KhnKA7sxV2wywFOFhaYWRJhbkuHmxQMDuGG7M8ZuMwSh8shHZ3fesoVKB
         5swbhBtTX0c1UNn4ZPksi/E+mj04Pi5F+vlzn0yY62IFRm4NUrp8qkFCYQ2VhMCkVhyS
         v8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762210674; x=1762815474;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=woaq09gBMKAgzKkT28bSEWfquvq2rcTRJnnMzH9zQEM=;
        b=EiOzwZoAs27Gzc+A0HECgikvXQmcaP3EKdtMWYnkPo75ZgWJb0ROrVqBbe+jCI0EV3
         LY82hC8T5N52C2L200VU0M/In6yjfERYSKHQk5Lgo38mYQNd3ros4bIorWRGXJNT1Tfv
         ySvjarOVID8nnNguPV0v4u2rAnEx7MFaPz5MfhAcWSs1IEUINUyt9/VadeIvLehumgE5
         vJUqqOKUeJAyiISvJc/dO/RzZZsMFR5/7gLSqa2CSi0m7wjfYAvJvHMTo/UvHKw3Sk1u
         M82yZT+OGFxhdmJOIjWAch0Gn8oFjDXHs9IAF59WBiD89Bm/duBfxQrI4pPZcW1uqOvF
         3Raw==
X-Forwarded-Encrypted: i=1; AJvYcCXRKPNygC2azSAhu5oN+uDvYwdsj4XqCLEY48vsxtR/PsGDLjqqxQEJweZVTDKURAsp40sVRw/7NxaA@vger.kernel.org
X-Gm-Message-State: AOJu0YwG5g51jUcPEH+O8SgoxHZk+BwT8Gz5RUB7EDcKp5CACZ8RFASO
	GGrQ0LptjKrOBnaMrz0ioH852eHWvHMONvTiYUvhoopk69AU7sFqt9wVoUZIQq55Ds4=
X-Gm-Gg: ASbGncvUhCkEQ79Q/xEscP3OQcvACScsuW7aMmE47Xtj19jpiMmQvPC6tUOncvM8PTF
	OQJ2uGdJEgNGats5j/vZ8DLL0ts9b8UNzEeeUJOAjaJqsGO9Z7NXxQ2eXe2RGMvtvN0yyxhjNHx
	crwrFHtxh6DC329fFM/ACD5FnpEbXgpSUNXEcmRwW1tITzt4LbAxug6U4JJFt9rBv7xTjYU+mDK
	IUaZqiV+00EaYLetFclBK8vOD4RqrEgULJ/8rwIbiIZWsrifqzcE8LBeUg1XLbcXyUJ+MPMAd5L
	ceiVYJtcsIbYSWWEaCK+SLo1+8ptVMShsg4z/GWvp62jb5Huu56x+6GeWwEj9+GOktTAttxBeO7
	mqlE4qMekHyDhEFFaLELrEqL4O4VCbStfpR9fJU7pGUsRPpguE+NtU5BWid1HN7edBu3vGzHY+B
	afGjXS
X-Google-Smtp-Source: AGHT+IFwFhVXiPd4hy146h4DqON39yrCDlSswV40KFoenniqHV80RvlLPb5vJhYG91hmgzHv7UecmQ==
X-Received: by 2002:a05:6000:4b14:b0:429:c4bb:fbd1 with SMTP id ffacd0b85a97d-429c4bbfe42mr9301290f8f.18.1762210673595;
        Mon, 03 Nov 2025 14:57:53 -0800 (PST)
Received: from precision ([152.234.106.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba1f1831141sm251142a12.4.2025.11.03.14.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 14:57:53 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	jaeshin@redhat.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v4] smb: client: fix potential UAF in smb2_close_cached_fid()
Date: Mon,  3 Nov 2025 19:52:55 -0300
Message-ID: <20251103225255.908859-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

find_or_create_cached_dir() could grab a new reference after kref_put()
had seen the refcount drop to zero but before cfid_list_lock is acquired
in smb2_close_cached_fid(), leading to use-after-free.

Switch to kref_put_lock() so cfid_release() is called with
cfid_list_lock held, closing that gap.

Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
Cc: stable@vger.kernel.org
Reported-by: Jay Shin <jaeshin@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V3 -> V4: rebase, added Reviewed-by and Reported-by, add
lockdep_assert_held in smb2_close_cached_fid, change commit subject (was
"smb: client: fix race in smb2_close_cached_fid()") to clearly state the
bug class (UAF)
V2 -> V3: rebase, remove unneeded comments, modify commit subject
V1 -> V2: kept the original function names and added __releases annotation
to silence sparse warning
---
 fs/smb/client/cached_dir.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index b8ac7b7faf61..018055fd2cdb 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -388,11 +388,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			 * lease. Release one here, and the second below.
 			 */
 			cfid->has_lease = false;
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			close_cached_dir(cfid);
 		}
 		spin_unlock(&cfids->cfid_list_lock);
 
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	} else {
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
@@ -438,12 +438,14 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 
 static void
 smb2_close_cached_fid(struct kref *ref)
+__releases(&cfid->cfids->cfid_list_lock)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
 	int rc;
 
-	spin_lock(&cfid->cfids->cfid_list_lock);
+	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
+
 	if (cfid->on_list) {
 		list_del(&cfid->entry);
 		cfid->on_list = false;
@@ -478,7 +480,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 	close_cached_dir(cfid);
@@ -487,7 +489,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 
 void close_cached_dir(struct cached_fid *cfid)
 {
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfids->cfid_list_lock);
 }
 
 /*
@@ -596,7 +598,7 @@ cached_dir_offload_close(struct work_struct *work)
 
 	WARN_ON(cfid->on_list);
 
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	close_cached_dir(cfid);
 	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
 }
 
@@ -762,7 +764,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 			 * Drop the ref-count from above, either the lease-ref (if there
 			 * was one) or the extra one acquired.
 			 */
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			close_cached_dir(cfid);
 	}
 	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
 			   dir_cache_timeout * HZ);
-- 
2.50.1

