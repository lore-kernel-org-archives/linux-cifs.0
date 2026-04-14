Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C56B3E6396
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 16:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776183513; cv=none; b=e7aCdmc7HWK8HwC8TmKnpK/LvIAmTBm44Wuyss7TO9UFUIuFhL9waWKpEu52/9dtl6yOnN0sUAuLduYmDAcnjWCmHr323K0N0O1hiPO4e+KgAwVwJ8Zy0G7kO2tqLSDHe4MJheht4NSRRrk+fCAvP1pRFhY7UtWhT9Wpya/vf8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776183513; c=relaxed/simple;
	bh=bcs5Bdjk/1br+qhEaLKA5J3IsoAvhukhYIjFlzbnEUI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBKLf8wrNWGeZgdyVgfhYBNxqr+nG55n1fmMjANm5NEF7PWOwB9CtcWWErEif4PfW9eyONUHyQef190g98M6vzdeWVbD2Vj8Hkv4glDQFmrNV3RLU4fUyD1Cn+0+jenWUm8Bq+PpGcqPqSrO+S2xGUf0nB2GtW0zy7D7Wg3pc1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gi/1H5Uf; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gi/1H5Uf"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82a7ebc729dso2616980b3a.3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 09:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776183511; x=1776788311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LfIZ0nR9y0zFrB/7i4IOTVQkXd+7h9FHuUzcwphCbDw=;
        b=gi/1H5UfZ5AnxzFqextHbfQj6xbF+hArOIED775G+uOcVdA4zd0vec+s1RexRueI6+
         xc3sOk5ANn2PboMuTbKlyDcwkOi1HQ3NmSw39sANQHKNdfe8qvJ9iluLNx5SN/yGPKPq
         900K7HtOZ6n3liqjM+fVBZElaZMylbpGrlmeKeIFtr81JwUcFWZf1lEbV/k54KQcrHt6
         gM2b73zFxeJ7VC3T/6Oev1Bv7b1s3bvlYxNvdJ3XLGpzOfqbE3o2NSDrsVnLA/u39sEJ
         6EqKH81xW82mRLUTewS2auRsui49TOvIcCipY007BCLvAvBvCg6S0cAl+JpGt6HO5sXg
         7m9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776183511; x=1776788311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LfIZ0nR9y0zFrB/7i4IOTVQkXd+7h9FHuUzcwphCbDw=;
        b=DsTecY/oiaqqu33cnK7AtBtTGtUGqUaFut1Xn/dZM4L0YLx5Hw3AzI8XNxVmq/aIfT
         qpjmEWuNCAUjJ8HCiJtr+rXKAy5fRI7sTEWk8ChVzCLV/gxSfO2o2mXH8KIGGW1VvTU8
         vxlAD6r7RX8UVbA9xI4vM8nl1hTylb/GoibFUhb95zg2KBgSIPPoHcdh6gr9UFcm+4Ff
         DA3Viphc/hh4zmuJRVYFltD7cNFkLlbNsz0QwmIek5aBdCr0BT/gRAbYX8vKYs36h82v
         k8fVnzTLBHjxHn7vZ+JLY8NqbBhLUHbQ4MS5mY685YwT8LxdYnRR3vFpszuYUXE4IeGt
         0rXA==
X-Gm-Message-State: AOJu0YzGxLsMDUEd2A5ezYKl4F9gDquhowMahWwoCGifTSEgDw5Tj/gP
	iMmWwA5/TQoW1GJARbqpdNa4nra7oi1hhjK2myUYcH88G6Z+z0fmfUyLeGNKXdNO
X-Gm-Gg: AeBDievn6aSgszqRSOQCfNIasDv4LJzNtyw5m8eFSM4C4+eXEmy2xvY8x1JVJ+VksjH
	02bZ6bPG07v0s+kabsHYCfywOFhZ6aHLEQZ10L3WWNds+b5mLT1UrCwcqO9v37C7tyyosHhh606
	2c7Go9la7uDauK59crWZay4aaF/s6c7bZ55X/FokpzHRojjtkIW8vSeeM3OnQ+5sQQ/RvByvN9S
	l/MT4EzmWhM7GJXXNS422bKbflVww0tZv/2HtulGj6CAL1KxgbLswwNyyglPG/sn/ALf51TF30p
	9LAPznQ/R7EbxX11qRoZ3UkmJIUUJk9jGOSogQsFGLbGSUHEsFEA90P/7plvFtNVk+0WFxUBP7h
	5SaEERIz3RMDeNglPv3oHvOrpbXioSsDQUbys0mx4wEWDvhmLUgEIs2jVgOUDOhkK4MeeFsWK15
	LL3lW3UY8DPfwft4j8vun/Vv+FgirtkYHjaqxjFAxkM6MmObZ/gTn2Ut8i6XiWPg==
X-Received: by 2002:a05:6a00:2918:b0:82a:6461:6d1e with SMTP id d2e1a72fcca58-82f0c26bb4emr20063608b3a.46.1776183511249;
        Tue, 14 Apr 2026 09:18:31 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([167.220.110.101])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-82f0c30ee59sm15298585b3a.1.2026.04.14.09.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 09:18:30 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	pc@manguebit.com,
	ematsumiya@suse.de,
	henrique.carvalho@suse.com,
	bharathsm@microsoft.com
Subject: [PATCH 4/4] smb: client: add tracepoints for deferred handle caching
Date: Tue, 14 Apr 2026 21:48:05 +0530
Message-ID: <20260414161805.233686-4-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260414161805.233686-1-bharathsm@microsoft.com>
References: <20260414161805.233686-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tracepoints to observe handle caching behavior.

smb3_open_cached: emitted when an open reuses a cached handle from
a previous deferred close, avoiding a network round-trip

smb3_close_cached: emitted when a close is deferred (handle cached
for potential reuse by subsequent opens)

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/file.c  |  8 +++++++
 fs/smb/client/trace.h | 51 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 4662592801b0..79819241ebfd 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1083,6 +1083,9 @@ int cifs_open(struct inode *inode, struct file *file)
 		rc = cfile ? 0 : -ENOENT;
 	}
 	if (rc == 0) {
+		trace_smb3_open_cached(xid, tcon->tid, tcon->ses->Suid,
+				       cfile->fid.persistent_fid,
+				       file->f_flags, cfile->f_flags);
 		file->private_data = cfile;
 		spin_lock(&CIFS_I(inode)->deferred_lock);
 		cifs_del_deferred_close(cfile);
@@ -1442,6 +1445,7 @@ int cifs_close(struct inode *inode, struct file *file)
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_deferred_close *dclose;
+	struct cifs_tcon *tcon;
 
 	cifs_fscache_unuse_inode_cookie(inode, file->f_mode & FMODE_WRITE);
 
@@ -1468,6 +1472,10 @@ int cifs_close(struct inode *inode, struct file *file)
 					cifsFileInfo_get(cfile);
 			} else {
 				/* Deferred close for files */
+				tcon = tlink_tcon(cfile->tlink);
+				trace_smb3_close_cached(tcon->tid, tcon->ses->Suid,
+						cfile->fid.persistent_fid,
+						cifs_sb->ctx->closetimeo);
 				queue_delayed_work(deferredclose_wq,
 						&cfile->deferred, cifs_sb->ctx->closetimeo);
 				cfile->deferred_close_scheduled = true;
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 57abf5fca26c..b99ec5a417fa 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -1361,6 +1361,57 @@ DEFINE_EVENT(smb3_open_done_class, smb3_##name,  \
 DEFINE_SMB3_OPEN_DONE_EVENT(open_done);
 DEFINE_SMB3_OPEN_DONE_EVENT(posix_mkdir_done);
 
+TRACE_EVENT(smb3_open_cached,
+	TP_PROTO(unsigned int xid,
+		__u32 tid,
+		__u64 sesid,
+		__u64 fid,
+		unsigned int oflags,
+		unsigned int cflags),
+	TP_ARGS(xid, tid, sesid, fid, oflags, cflags),
+	TP_STRUCT__entry(
+		__field(unsigned int, xid)
+		__field(__u32, tid)
+		__field(__u64, sesid)
+		__field(__u64, fid)
+		__field(unsigned int, oflags)
+		__field(unsigned int, cflags)
+	),
+	TP_fast_assign(
+		__entry->xid = xid;
+		__entry->tid = tid;
+		__entry->sesid = sesid;
+		__entry->fid = fid;
+		__entry->oflags = oflags;
+		__entry->cflags = cflags;
+	),
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx oflags=0x%x cflags=0x%x",
+		__entry->xid, __entry->sesid, __entry->tid, __entry->fid,
+		__entry->oflags, __entry->cflags)
+);
+
+TRACE_EVENT(smb3_close_cached,
+	TP_PROTO(__u32 tid,
+		__u64 sesid,
+		__u64 fid,
+		unsigned long delay_jiffies),
+	TP_ARGS(tid, sesid, fid, delay_jiffies),
+	TP_STRUCT__entry(
+		__field(__u32, tid)
+		__field(__u64, sesid)
+		__field(__u64, fid)
+		__field(unsigned long, delay_jiffies)
+	),
+	TP_fast_assign(
+		__entry->tid = tid;
+		__entry->sesid = sesid;
+		__entry->fid = fid;
+		__entry->delay_jiffies = delay_jiffies;
+	),
+	TP_printk("sid=0x%llx tid=0x%x fid=0x%llx delay_jiffies=%lu",
+		__entry->sesid, __entry->tid, __entry->fid, __entry->delay_jiffies)
+);
+
 
 DECLARE_EVENT_CLASS(smb3_lease_done_class,
 	TP_PROTO(__u32	lease_state,
-- 
2.48.1

