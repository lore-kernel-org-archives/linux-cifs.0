Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B65A36655C
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418482; cv=none; b=bPBPyJqd9tY8JeC0pMhPM5sh+2GT5zyYZTzWFpIaCUdNNCK44/To5lvJFdZ7fLnij4d1h/jY/Dk4ImFvFwiCFxM6V7FpzuA91AHfYPs1VX20xhggAb+IvuJwfEJp712QCs2KE8AstjQpSmhCmLTrE+n7h56ZoHjxAqlUdz9U6KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418482; c=relaxed/simple;
	bh=kgfauQuFNlO5We3TMkTbcvmbnULFh13bIX9688rbKUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Io300Kh54gaVksQ58yj4cHR6sa4lcErKR3Hpn1MeIB1u+bBaPDgNqOG7hzxf9kJtNYUFNXWDycy554m22I0s8Z1QCjqBnmpRIYIhJG/RbMSfYFuqV4khlyKg7XjmbDSzDkdvlvZebVjz7gYVtXvvg6r6/l0O6TZNoN+h6O0At58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGO0CMlk; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGO0CMlk"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so1958571f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418477; x=1784023277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ivSoZbV7cSgQtMCmPa64P5ecliJPFKjL0bylQloWrCg=;
        b=LGO0CMlksrwvQ4feExtaTjIsdTTG8vfu7isnurtCkTtzkNaeOMAVKuPEyCQXpGUg5L
         ru+da3JFRlLCBFzPq4QAtWi9/MJKg5DzvVrysa/moe6hsWxk0Q4D/orCH1XUcUCMng3+
         XbIBY/4hfcnyfcKCGWqGSQWqnLbblUXgu/clMDcHvq6TFAsd531JQwqfqZa7RYyxhZI3
         L4Ukgo9BJkGxYg3fmVKUJUJXxvtY9ihnt8hhYHum4uy6kJvz+uv+PopB6jgHhhrPbdwg
         G1ugwRH3RKaOEs329gsZQhpNC4U0vlcUyYQP64DM3efVVK8pWc0wn0ym80Hm2GHmeHO8
         /GnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418477; x=1784023277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ivSoZbV7cSgQtMCmPa64P5ecliJPFKjL0bylQloWrCg=;
        b=pVUSSRABHiW3MrJBD7haYYQBJai6WiUO31peQdRgppHj1+UMLzaJkDgUOuJBpn1iGU
         BKKxqW3Yh+eJc4bzGGKNtjEz4LbqCK3alIojBXVbpW+dMBkHgN8+ZeihopwA/DwD2Gbz
         RuYRgfHABt+Jwshxeam6Y2gONg//uUDtj8wjm62kdKXRtZESrdC02wI0nuK0TH1JNpHB
         +4i3O90AkoDp2amreX9U3t+6sUzrVkLSaKqNttzBDGcKGl5h5rKOT4I9ikXo4jzFuW2x
         yhTeSSWDX6LXqFqElbEL5eGQ7hfQ/3iIOmwSPXMqAE/TYDy5qLKBEsWTxReyiDx9CMwQ
         7LEw==
X-Forwarded-Encrypted: i=1; AHgh+RrZO2sUSxr9uBvr3vABo+OsEVUDfI0g3/iVh0F8X1iHIruW+IbaUZFDNdoLo9aoas0GdsTNPrGfsl+I@vger.kernel.org
X-Gm-Message-State: AOJu0YxiW2ZQSIZ9AQJvtIjCxWdn4dxV8P9xyACCdIMSMaCrSnJrGRLr
	y/f7wH4lHEATZOmjDvZFH2u5bFUTCn0EyDSi0Q0qTCoRO8snC7DgEoOi
X-Gm-Gg: AfdE7cl0U8hdESnOntzJ6XfcYRqD4itLoQVWTE2cFGbDGBlSllpke2Z2HSbEeBa6W88
	RCUxxJiIXBjq0Ogo8D0fOufpWfCvIjNpGRwk70AFAmaBvC5eLOTrhZFbBPe+ghXDoFxviwz+Ofc
	LDln7npt8urBga1XvWGba0rX1ZQJn5UblVhJpBQGQiCmxS3yCKa1n3Kh3tEMZHHMcfT8Yar2AuU
	Eksn9Hk1I8Ks+NELz24ilHzn/wtAYltr936tR7+PV8i/J+VxFRn/gGpWSSlM3J86gCjPGefMY/x
	YiH4vAUAZYao3VpNq+dZjRnr5dE9e8ySSWbLa2rFqWDj9p/ydR8VIqaKjTU7Nf0iWr3Y3XIT2XW
	tZsb+9Rm58wehBahYH5KTGSBGeVpJUIzeWfAkPoeeyWmmV3Db0Fd43cxzKhUIP5WakK2y6N+LU/
	3BrM+r4jqkMPFL6kWHfI4qZ0cOhAtFNo3/p1U=
X-Received: by 2002:adf:fd86:0:b0:474:6a5b:85f5 with SMTP id ffacd0b85a97d-47de6697cbcmr3669045f8f.3.1783418476741;
        Tue, 07 Jul 2026 03:01:16 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm33908295f8f.26.2026.07.07.03.01.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:16 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 2/7] ksmbd: route stream FileDispositionInformation through stream delete flag
Date: Tue,  7 Jul 2026 11:55:02 +0200
Message-ID: <20260707100033.47512-3-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260707100033.47512-1-g.blivet@me.com>
References: <20260707100033.47512-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

set_file_disposition_info() calls ksmbd_set_inode_pending_delete() /
ksmbd_clear_inode_pending_delete() unconditionally, which always sets
S_DEL_PENDING on the whole inode (ci->m_flags), regardless of whether
the handle being closed is a regular file or an alternate data stream.

Requesting delete-pending on a single stream handle (e.g. deleting
just an alternate data stream some clients keep alongside a file)
would therefore incorrectly schedule deletion of the entire file's
data, not just the stream.

Add ksmbd_fd_set_delete_pending()/ksmbd_fd_clear_delete_pending(),
following the same stream-vs-whole-file routing pattern already used
by ksmbd_fd_set_delete_on_close() for the CREATE-time DeleteOnClose
option, and switch set_file_disposition_info() to use them.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c   |  4 ++--
 fs/smb/server/vfs_cache.c | 32 ++++++++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  2 ++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 39188bb84..e6d0f58d2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7117,9 +7117,9 @@ static int set_file_disposition_info(struct ksmbd_work *work,
 		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
 			return -EBUSY;
 		smb_break_all_levII_oplock_for_delete(work, fp);
-		ksmbd_set_inode_pending_delete(fp);
+		ksmbd_fd_set_delete_pending(fp);
 	} else {
-		ksmbd_clear_inode_pending_delete(fp);
+		ksmbd_fd_clear_delete_pending(fp);
 	}
 	return 0;
 }
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index d95c405ea..2543dd7e8 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -294,6 +294,38 @@ void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
 	up_write(&ci->m_lock);
 }
 
+/*
+ * FileDispositionInformation (SET_INFO) on a stream handle must only
+ * mark the stream for deletion, not the whole file -- otherwise
+ * deleting a single alternate data stream (e.g. AFP_AfpInfo) deletes
+ * the entire file's data along with it.
+ */
+void ksmbd_fd_set_delete_pending(struct ksmbd_file *fp)
+{
+	struct ksmbd_inode *ci = fp->f_ci;
+
+	if (ksmbd_stream_fd(fp)) {
+		down_write(&ci->m_lock);
+		ci->m_flags |= S_DEL_ON_CLS_STREAM;
+		up_write(&ci->m_lock);
+	} else {
+		ksmbd_set_inode_pending_delete(fp);
+	}
+}
+
+void ksmbd_fd_clear_delete_pending(struct ksmbd_file *fp)
+{
+	struct ksmbd_inode *ci = fp->f_ci;
+
+	if (ksmbd_stream_fd(fp)) {
+		down_write(&ci->m_lock);
+		ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
+		up_write(&ci->m_lock);
+	} else {
+		ksmbd_clear_inode_pending_delete(fp);
+	}
+}
+
 static void ksmbd_inode_hash(struct ksmbd_inode *ci)
 {
 	struct hlist_head *b = inode_hashtable +
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index b9e27307a..111a4e315 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -214,6 +214,8 @@ void ksmbd_set_inode_pending_delete(struct ksmbd_file *fp);
 void ksmbd_clear_inode_pending_delete(struct ksmbd_file *fp);
 void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
 				  int file_info);
+void ksmbd_fd_set_delete_pending(struct ksmbd_file *fp);
+void ksmbd_fd_clear_delete_pending(struct ksmbd_file *fp);
 int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp);
 int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 				  struct ksmbd_file *fp, char *name);
-- 
2.43.0

