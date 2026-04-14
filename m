Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262511DFFD
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 16:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776183493; cv=none; b=B18dRKQ3k2saxKH89DmOTfCbjxf1ytlCl3675Z6c7ny5eU4xx833U4zRykVg4eduyfzpRqnHJ+82UO0XG+6t1cXypauHJOsuwmKRFQpGOA/6LIQ+Fr40JB76fiRdW2ebCqhN5U5RGxjUfOo9QDwljaB/D3ytfeO2B5cnAOt0qmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776183493; c=relaxed/simple;
	bh=nVJ+EzzCzMonFjaNwYvhzGXta/u8E0ZomWSlFMYf7zI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Pa4bW0uP2R6fu2SVLpwLUqE2vGi6hgjMzwI/CNrvn2FQ9e74I+6mRGYpZMpzdft4fBOUFauyp5G1kAahpi3oe0stjBUaWAVDInBM3rIGB7rgqNxPCTFm1TzLbKK6fjws8Koqb8XdERjZhTj0Zv4d6cGay5bXZ3r2cN8Nr+kGbr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A4bTi5Yy; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A4bTi5Yy"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82f37c09352so1712539b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 09:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776183491; x=1776788291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=TUnElORk1CylRbeSfxzFXUT14s2LHPojbvEYU1HbPrQ=;
        b=A4bTi5YyxKWtlxNzuN8D1lInbZBPl5+akwGQ8dvQqx8jbpBLcqQnYOq3i0iV4/I+1v
         NjJx4ymmt5ZhXBR9FfXejVR3Fs6u/Q1QU8ErcIKur3SYjLGz+HreCVVAOoIZl0As4cGG
         nGg9KBayp7yYAL5dwiXKIjNnyL7cRy/IftjcE65mro88dUjuSU3kmORMwZ7MMdq/6uVZ
         0Xge33UYV0ptF62KLm28A5bxNJioWXS24Y2ILI1IrpWd3scE646yx/w51WuZ8ToQ7Me7
         qJU3ARIHB7CnJjpJjmhwtl6yl/snZLbVGvQ16RBgo6xeKQcKChTFB1eyBI+ZnVlRhh+i
         Kdrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776183491; x=1776788291;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TUnElORk1CylRbeSfxzFXUT14s2LHPojbvEYU1HbPrQ=;
        b=VXBIwOLh3mh0ojVbH1ndx7b9E34MW47f3tZi4SGils636g/mMtcPLjJm0aLBEOBSMX
         07TnXedJuMWa2Buo1JDpDnWxE02uULITurCJ9IJ8HW2Zmwo/9SF7DIZ0pZ6cDU3zZShr
         zLa5ntT+ZYg84+3j4UiNCg0yUkB+3bl7gP/hR0sGmhIHW/Xi2rOExyT42Yz67ljJK01d
         QxPWkIuYj4aZxf2FOGnENwqZ7PKJBa1c4qP9mSTlacSDQ/GFMEbRbI1AnrW7cmLWpGpJ
         hLgEvqQyNsf++UXHiAiKrLgMZZLTMnEqUQ+0XILpEw6NvswnjwC/soBeUaGlyqRsardo
         QIZA==
X-Gm-Message-State: AOJu0YysiG2MdOUTy2dItPZ8cg3AvRig+jneUZq8Idmmuan8AtQbCB8d
	Kf5f+0FG/1syQ/wbJHFXz7plZfFjS64SWE+iOQbAqUeQQXGGDtRPWJuPqHjtrygC
X-Gm-Gg: AeBDievJScx6K56UNOGyOlmbJYDaWHGYL1FEi3yDxEgbA6Gq8kiW/EZfkWk91nWm1Z+
	CHc1vBZ6/vsE6tkX13CfcJ3DmDwGS3+adJTiUOdt0Ydxr1aTs5TNcj8pTcOwo4V8+I4JOpNWuQp
	f+ySEXkfLdBnwjQ5Y6uP7lIdbRYuE+acS+r2JUnRK4epXqRiQOohofatkdG/FOdcX+04KWTUQnI
	01nE5vC4/CLhyR7/RboXOCVVntkaUtCSsSlahhfhOVEUgaduFguCtHoV2bjm4kzW5HIhImBpqtD
	+VJZgvFSVr3hK1koCDyJhZk3QIcRcj6bU9/dB2bfQVNvZB675+EXRyBaJCUByNv+5vMCbQ1H1dV
	gicDlAUB7XQ8iwV0NByFGMAPCAEjh8stG0Bk1+d4O78NB17xIGWmGVuL8pdStxa7aHROJpk3zCh
	a8eA8KypRLFibjfxVPfaoY6ErV4bDRWDKwsAVXnQeNQHG6VqEXxf/UXXtObjwC7g==
X-Received: by 2002:a05:6a00:1250:b0:82f:3017:6157 with SMTP id d2e1a72fcca58-82f3017684fmr8797709b3a.7.1776183490923;
        Tue, 14 Apr 2026 09:18:10 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([167.220.110.101])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-82f0c30ee59sm15298585b3a.1.2026.04.14.09.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 09:18:10 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	pc@manguebit.com,
	ematsumiya@suse.de,
	henrique.carvalho@suse.com,
	bharathsm@microsoft.com
Subject: [PATCH 1/4] smb: client: add tracepoints for lock operations
Date: Tue, 14 Apr 2026 21:48:02 +0530
Message-ID: <20260414161805.233686-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tracepoints when lock operations are sent to the
server with details including lock offset, length, and flags.

smb3_lock_enter: before sending lock request
smb3_lock_done: lock acquired successfully
smb3_lock_err: lock request failed
smb3_lock_cached: lock granted from local cache (no server roundtrip)

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/file.c    | 10 +++++--
 fs/smb/client/smb2pdu.c | 15 ++++++++++-
 fs/smb/client/trace.h   | 58 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 5d5b49468aff..66a678a0e89f 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1712,7 +1712,7 @@ cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
  */
 static int
 cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
-		 bool wait)
+		 bool wait, unsigned int xid)
 {
 	struct cifsLockInfo *conf_lock;
 	struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
@@ -1727,7 +1727,13 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
 					lock->type, lock->flags, &conf_lock,
 					CIFS_LOCK_OP);
 	if (!exist && cinode->can_cache_brlcks) {
+		struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+
 		list_add_tail(&lock->llist, &cfile->llist->locks);
+		trace_smb3_lock_cached(xid, cfile->fid.persistent_fid,
+				       tcon->tid, tcon->ses->Suid,
+				       lock->offset, lock->length,
+				       lock->type, 1, 0);
 		up_write(&cinode->lock_sem);
 		return rc;
 	}
@@ -2342,7 +2348,7 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 		if (!lock)
 			return -ENOMEM;
 
-		rc = cifs_lock_add_if(cfile, lock, wait_flag);
+		rc = cifs_lock_add_if(cfile, lock, wait_flag, xid);
 		if (rc < 0) {
 			kfree(lock);
 			return rc;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5188218c25be..61bae531959a 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -6277,6 +6277,11 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 		smb2_set_replay(server, &rqst);
 	}
 
+	trace_smb3_lock_enter(xid, persist_fid, tcon->tid, tcon->ses->Suid,
+			      le64_to_cpu(buf[0].Offset),
+			      le64_to_cpu(buf[0].Length),
+			      le32_to_cpu(buf[0].Flags), num_lock, 0);
+
 	rc = cifs_send_recv(xid, tcon->ses, server,
 			    &rqst, &resp_buf_type, flags,
 			    &rsp_iov);
@@ -6285,7 +6290,15 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "Send error in smb2_lockv = %d\n", rc);
 		cifs_stats_fail_inc(tcon, SMB2_LOCK_HE);
 		trace_smb3_lock_err(xid, persist_fid, tcon->tid,
-				    tcon->ses->Suid, rc);
+				    tcon->ses->Suid,
+				    le64_to_cpu(buf[0].Offset),
+				    le64_to_cpu(buf[0].Length),
+				    le32_to_cpu(buf[0].Flags), num_lock, rc);
+	} else {
+		trace_smb3_lock_done(xid, persist_fid, tcon->tid, tcon->ses->Suid,
+				     le64_to_cpu(buf[0].Offset),
+				     le64_to_cpu(buf[0].Length),
+				     le32_to_cpu(buf[0].Flags), num_lock, 0);
 	}
 
 	if (is_replayable_error(rc) &&
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index acfbb63086ea..242c9da0283e 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -670,9 +670,65 @@ DEFINE_EVENT(smb3_fd_err_class, smb3_##name,    \
 	TP_ARGS(xid, fid, tid, sesid, rc))
 
 DEFINE_SMB3_FD_ERR_EVENT(flush_err);
-DEFINE_SMB3_FD_ERR_EVENT(lock_err);
 DEFINE_SMB3_FD_ERR_EVENT(close_err);
 
+DECLARE_EVENT_CLASS(smb3_lock_class,
+	TP_PROTO(unsigned int xid,
+		__u64	fid,
+		__u32	tid,
+		__u64	sesid,
+		__u64	offset,
+		__u64	len,
+		__u32	flags,
+		__u32	num_lock,
+		int	rc),
+	TP_ARGS(xid, fid, tid, sesid, offset, len, flags, num_lock, rc),
+	TP_STRUCT__entry(
+		__field(unsigned int, xid)
+		__field(__u64, fid)
+		__field(__u32, tid)
+		__field(__u64, sesid)
+		__field(__u64, offset)
+		__field(__u64, len)
+		__field(__u32, flags)
+		__field(__u32, num_lock)
+		__field(int, rc)
+	),
+	TP_fast_assign(
+		__entry->xid = xid;
+		__entry->fid = fid;
+		__entry->tid = tid;
+		__entry->sesid = sesid;
+		__entry->offset = offset;
+		__entry->len = len;
+		__entry->flags = flags;
+		__entry->num_lock = num_lock;
+		__entry->rc = rc;
+	),
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx offset=0x%llx len=0x%llx flags=0x%x num_lock=%u rc=%d",
+		__entry->xid, __entry->sesid, __entry->tid, __entry->fid,
+		__entry->offset, __entry->len, __entry->flags, __entry->num_lock,
+		__entry->rc)
+)
+
+#define DEFINE_SMB3_LOCK_EVENT(name)          \
+DEFINE_EVENT(smb3_lock_class, smb3_##name,    \
+	TP_PROTO(unsigned int xid,		\
+		__u64	fid,			\
+		__u32	tid,			\
+		__u64	sesid,			\
+		__u64	offset,			\
+		__u64	len,			\
+		__u32	flags,			\
+		__u32	num_lock,		\
+		int	rc),			\
+	TP_ARGS(xid, fid, tid, sesid, offset, len, flags, num_lock, rc))
+
+DEFINE_SMB3_LOCK_EVENT(lock_enter);
+DEFINE_SMB3_LOCK_EVENT(lock_done);
+DEFINE_SMB3_LOCK_EVENT(lock_err);
+DEFINE_SMB3_LOCK_EVENT(lock_cached);
+
 /*
  * For handle based query/set info calls
  */
-- 
2.48.1

