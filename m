Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB25522F01
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555565; cv=none; b=Sj0zfeWtfzddYgdWia7j73/gT2C18qgx9xKPo4DAK9M9hiBFzt1c1/FGnRDzbMBmO04B4BlA2MSXIHhxzmRixhXnwyEuVZ3uBxGEVbSRrJHL7jLmqTq//q+qVnl/O2+7dWLtDqEF8yve69lnj3iaZOIY0NnleUcYSvF+rCkkhj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555565; c=relaxed/simple;
	bh=nfjvo32tj6EtskpnROVEtkgFFHHcvBQmcVjjP365Tys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bX7H7HzoLEaGCCcv5LbCTg82bRDPi8vJM7B7PG8N6LnV1YWv2HFOSph430z24zSlKoM2/a1iktWqO1C1wf7CKM9p8CU4rGO8UseDZ5+VG5lm15BfGqwVBYwRw8p03tTB2knXQEO9X9PHwGewcvcXxCGTCnT/z7AHlDJCV/Be+IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bmu2GvSn; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bmu2GvSn"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493c2b3dc8bso2238345e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555562; x=1784160362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5qDQAggnv1hDj3qbTaknK6MranCuFoO21LeaDnRSUUo=;
        b=bmu2GvSnfTE6OGf+IuFFTY0xpWHkQ6ggHH4L2hbRo9KE5XOe+wrXInSGdfmt/cpwLg
         CIA8OV1fnuMahWLkcauyz4HtIorJZ1tmWOzFetpv3PKxydQQ8HjRrZVeMElc1xcvsxOt
         cKwQgn3NcZzY8NJ23fqGYOhZT/A7oWQ3cIK8cGw3+E0tmHKqCfDGBEjGV34JjRGEMumi
         l5Y0uuCem1/McH6t/zBNR+YD02vVBUtokSE5YiJoefWIc9Sbs/jlsGdjjduDuoV5O2FX
         AsTEV8qg94isFFcs5PwTH+940MxD/iTPUbP2RYijJIzo9wGoncQVH7r8G5qrbxVFGg3p
         TmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555562; x=1784160362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5qDQAggnv1hDj3qbTaknK6MranCuFoO21LeaDnRSUUo=;
        b=R8qPWrvPwJEP//b/DTrN+fe8aV3NUUrD54aSv4aKx4Alk0HVM+D4sTFIMQce5t3MZ6
         TpHqB4vB38M5MJXEenftcDXig47Fz+PwKwftRBaKCvLr07xIbdzDlR8OtT/fhM8uy9dh
         Md9HLZ5ZzDZG4oGUFz/BIVAgo/JeVy1YGbU08o5uVb3N8Mpt7wVtvKJh/LNx0dgVGvcG
         heUeHr8DxeZ81Nypi8yAI/y95Hr7FM9QuRjc+U94CAodj2KkcwQzqS2mR+lkqVZaSa07
         qrRDt0gaMTUrT6JJLe6SirHBuEaZfKBGESrwAPGyjEB/ujhH/va9u1WrgfRcUxKEFqow
         RsBA==
X-Forwarded-Encrypted: i=1; AHgh+RrUT/3WEeO99ZVvYV5/seYsaGYCbKZuYoOHqAYm6xTz6TTSAJM93fyX6QpY1+nr+3FHRYnuLneJoOPh@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6+oxp8mmpk6HclgU+a9YY6U8iv8EgIZa1mHuHE3qBajTG8ZgP
	JRSekTGiK8hhd68CmTaeXhwPFRtiObq1EYmNYeGTIzOGO1EECmjI4lio
X-Gm-Gg: AfdE7cnnofbC9ytziEfZjrlFEWPtfm7QDUDENsBbgA7X53L3PUA29JRO2OnADHmoj2r
	WzUvvTujOEqepHyf3ltULiaNcXLT0YFpd++QCTsUlMvaf7H97VJO78r79JxUgNKkESmn/w3XKcD
	ZjekZZ/zOemd7xAFYFsqwxMv9h+1wKSSSzHtlCZCuhGsLqxRDI5fWgOek1+7/yDnUKj4MpSUGHk
	euTpvB2mnl8nNpTVykDuAkjvONH3Kp86yl+P2WnhQ7DmxeDVzx2pk4rRgKU8kNbJm05rl4ZXvjj
	L2XUIjbnEVO8DHvJnZ/NU20Yoz2NXtPHHZuo5elZ0HALoejGZZdWev+8cDN82I7uDjtzGr5A1u+
	5GzBoy7GVXLWVjWS28fV+ASuhc18R1YHvCED7wZhjXS1FCrCLbWj6rVF9qxCDdE/9Z/yGc3Bljv
	tcx1XJZsdSTPRvPWTY38crfVCezRTizRh68H4=
X-Received: by 2002:a05:600c:4743:b0:493:c1a1:68f0 with SMTP id 5b1f17b1804b1-493e68c80b5mr47868815e9.20.1783555562192;
        Wed, 08 Jul 2026 17:06:02 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm15843755e9.13.2026.07.08.17.06.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:01 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/8] ksmbd: route stream FileDispositionInformation through stream delete flag
Date: Thu,  9 Jul 2026 02:01:04 +0200
Message-ID: <20260709000548.66445-2-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000548.66445-1-g.blivet@me.com>
References: <20260709000548.66445-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

Follow-up to
commit 78380c12125a ("ksmbd: route stream FileDispositionInformation
through stream delete flag"),
which added ksmbd_fd_set_delete_pending()/ksmbd_fd_clear_delete_pending()
to keep a stream's FileDispositionInformation from marking the whole
file for deletion, but used the inode-wide S_DEL_ON_CLS_STREAM flag to
do it -- the exact same problem class the commit was fixing, one level
up.

S_DEL_ON_CLS_STREAM lives on the shared ksmbd_inode, not on any
specific stream handle. If a file has multiple stream handles open and
one gets marked delete-pending via FileDispositionInformation, the
flag can't record *which* stream should be deleted: whichever stream
handle happens to close first (not necessarily the one that was
actually marked) sees S_DEL_ON_CLS_STREAM set and has its xattr
removed. Two clients (or two handles from the same client) touching
different streams on the same file can end up deleting the wrong one.

ksmbd_inode_pending_delete() has the same issue: it only checks
S_DEL_PENDING, which is never set for a stream handle, so a client
querying FileStandardInformation.DeletePending on a stream marked via
this path would incorrectly see 0.

Track this per-handle instead (stream_del_pending on struct
ksmbd_file), matching the file itself rather than the shared inode.
ksmbd_fd_set_delete_on_close() (the CREATE-time FILE_DELETE_ON_CLOSE
option, a separate call path from FileDispositionInformation) still
uses the inode-wide flag; __ksmbd_inode_close() now checks both, since
either one should trigger removing the stream's xattr on close.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/vfs_cache.c | 49 ++++++++++++++++++++++++++-------------
 fs/smb/server/vfs_cache.h |  7 ++++++
 2 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 2543dd7e8..1f225b16c 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -229,6 +229,16 @@ bool ksmbd_inode_pending_delete(struct ksmbd_file *fp)
 	struct ksmbd_inode *ci = fp->f_ci;
 	int ret;
 
+	/*
+	 * Stream delete-pending is tracked per-handle (see
+	 * ksmbd_fd_set_delete_pending()), not on the shared inode -- the
+	 * whole-file flags checked below would never see it set, and would
+	 * also incorrectly report a whole-file pending-delete as applying
+	 * to an unrelated stream handle on the same inode.
+	 */
+	if (ksmbd_stream_fd(fp))
+		return fp->stream_del_pending;
+
 	down_read(&ci->m_lock);
 	ret = (ci->m_flags & S_DEL_PENDING);
 	up_read(&ci->m_lock);
@@ -299,31 +309,27 @@ void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
  * mark the stream for deletion, not the whole file -- otherwise
  * deleting a single alternate data stream (e.g. AFP_AfpInfo) deletes
  * the entire file's data along with it.
+ *
+ * This is tracked on fp itself (stream_del_pending), not the shared
+ * ksmbd_inode: the inode-wide S_DEL_ON_CLS_STREAM flag used by
+ * ksmbd_fd_set_delete_on_close() can't record *which* stream should be
+ * deleted, so if a different stream handle on the same file closed
+ * first, it would delete the wrong stream.
  */
 void ksmbd_fd_set_delete_pending(struct ksmbd_file *fp)
 {
-	struct ksmbd_inode *ci = fp->f_ci;
-
-	if (ksmbd_stream_fd(fp)) {
-		down_write(&ci->m_lock);
-		ci->m_flags |= S_DEL_ON_CLS_STREAM;
-		up_write(&ci->m_lock);
-	} else {
+	if (ksmbd_stream_fd(fp))
+		fp->stream_del_pending = true;
+	else
 		ksmbd_set_inode_pending_delete(fp);
-	}
 }
 
 void ksmbd_fd_clear_delete_pending(struct ksmbd_file *fp)
 {
-	struct ksmbd_inode *ci = fp->f_ci;
-
-	if (ksmbd_stream_fd(fp)) {
-		down_write(&ci->m_lock);
-		ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
-		up_write(&ci->m_lock);
-	} else {
+	if (ksmbd_stream_fd(fp))
+		fp->stream_del_pending = false;
+	else
 		ksmbd_clear_inode_pending_delete(fp);
-	}
 }
 
 static void ksmbd_inode_hash(struct ksmbd_inode *ci)
@@ -446,6 +452,17 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 		}
 		up_write(&ci->m_lock);
 
+		/*
+		 * Per-handle delete-pending from ksmbd_fd_set_delete_pending()
+		 * (FileDispositionInformation on this stream) -- separate from
+		 * the inode-wide flag above, which only ever meant "some
+		 * stream on this file" with no way to say which one.
+		 */
+		if (fp->stream_del_pending) {
+			fp->stream_del_pending = false;
+			remove_stream_xattr = true;
+		}
+
 		if (remove_stream_xattr) {
 			const struct cred *saved_cred;
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 111a4e315..f796b6edc 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -118,6 +118,13 @@ struct ksmbd_file {
 	struct list_head		node;
 	struct list_head		blocked_works;
 	struct list_head		lock_list;
+	/*
+	 * Per-handle FileDispositionInformation delete-pending state for a
+	 * stream handle -- separate from ksmbd_inode's inode-wide m_flags,
+	 * which have no way to record which stream on a multi-stream file
+	 * was actually marked for deletion. See ksmbd_fd_set_delete_pending().
+	 */
+	bool				stream_del_pending;
 
 	unsigned int			durable_timeout;
 	unsigned int			durable_scavenger_timeout;

base-commit: 545c40084bb831530033265b654290ff7be5b090
-- 
2.43.0

