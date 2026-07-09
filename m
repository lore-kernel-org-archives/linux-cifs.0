Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3C739A7F2
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 16:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783615912; cv=none; b=BoZtSwahjM6lfKEx7UUhojqFNO23eDVzWmUYzHQmDSMpyK//2Vznfm0xKRBTu5BJbxbuUvIEZUJWKdzz7tTl+LTYKaFuJyKsLJQUriG7z0n55LCbxCXes8Ufobr5WUn9eyqshgBIC07O+tY04CWN3kEvfFWOxyZbVcjeV5hCCko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783615912; c=relaxed/simple;
	bh=mrifFOvqetAuGjDroEfRweuwLpBjtZ/CxXAKLZB/U+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QgHGfT1UdI5C69frCBX5Fm5PM/Z1bvcFUMJTey7CnxodaCJ5m+oICR2AVIdRAlWJ8n8IYNEMNELDHSU+58xjWhPX+GVpzkE1ZxP3veTAeGZbFJxcjK0GhfmZg7IWoB5JdPZwqAurg29zVybWN9WEn9l+UMI73sK/iK9/zy4rh88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S+LmAyGh; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S+LmAyGh"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493b27c7451so14806255e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783615910; x=1784220710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bEqsbsUIsSBTfZ9ZWklcGrAOqQ1Z5SUh9Lb7ZVTT7Cw=;
        b=S+LmAyGhDRLTsl1ntM5va6d7EwAgY+ujE6QwOmxIzz+U8zagGEYb/U+XrUhIApA9Zn
         e7CzAYoJA7GGAEvGbleglfDrz87tk999Z5Auq5IONu/j1LSvNFgcsUZTSIlX3YpCoRMC
         x7cWozlszjQ/2VluDxuJlehKvSr+LHiIFguU7zvj9/6IdjEeLfkMZ1CfzDtnnET/jNG6
         FJ5BOHvgCe5+IRlFd6dn0YKKvlgogxAFT26ZwDG7bj0Ot8ymcekBdEEcCIeKVGCgl1f3
         DyfEKOGUyATYYNrHDTH7uqWEiRa9Tvvj+SJnHJcEI5PDO7k71a8BOYAjCi2Ne9SiRkW/
         aHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783615910; x=1784220710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bEqsbsUIsSBTfZ9ZWklcGrAOqQ1Z5SUh9Lb7ZVTT7Cw=;
        b=CBpILhITPkFWuIQQlOVe8fqz5vU9HLEgq2z1LPgcUEmdX6B/vlDgJM++YSXg5G7ymO
         W4B7L+v1ExXYvOmnOAz0tl4g+1t6mq07Ao1LqpSlSEtBEWmzA+UXO6g0aP8cP+EBIH+J
         l/YrVF0aNlY7r5Nay3P5UbSvUyymZFab9z/g+BOIKvTAIip3gv27DaRAHXCfaJb0MOpV
         2IQqT/vimTARI7Eq4lxuiI8vLoX6cx1ipQM8vwCop+1gjM9LOFtjjvwSkHwlXDmiUpfw
         ibwsR2ewxr8qECK3t7BZ2nqOTc8oTl0KB+453ze7Igw5x/OTtyKxoHJUEZtekvvTG/kf
         Iabg==
X-Forwarded-Encrypted: i=1; AHgh+RrOI3r/eXO6fqSYsWLIIkCY2M3lSGII5nEr4O0jgceNO+wbugldvfpZQ9e88QYfxuRO/u23mAAr9Y03@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8YxRTX1Rwmt7H0PHv09wlTpKf4YUprL6qjpoJ/nGiDMpEAvee
	1ELigWlVbXI7j6A8853YYOFTKp8Cws1k4BShr8bLe3AEMHbuXEIa1EUPD5Fs7DWk
X-Gm-Gg: AfdE7clNUpEETeT8qyMSNGeUlRhLp7/0soYEoWCtna/DSfmacoMLhQ7tXsDCY+HTx7d
	YKgvOp/NdmiZGU7dUENQeoXHfboJlmxOh9mcbf2I/8XDktGaPc+yIGzQm3FUHb+T9Yz3isr9v8u
	i6L51DJkynZbzk5/cOJlHuwvDkNCBtp0NVygnGZeKV9JWV87cne3TNC+eB0RMTsSahhoWWw6r6p
	YK5wd+P5aZMt7xSYs7JnNc0uftd75Rc+uszNWnvEp9tnMj9VTq2wPu43J+tR+ulkyTnqY9AqZVA
	mTVc5Wn0Vuz9K6TrV3hy81K481g8WKVF01zUnL3WS+iUgOooxCqp51YFWOAPIPObuiybQU46Z/q
	iBgPKdOrTk8xg8GOXE9RRTSNkDJjB3eH3VGpykQuOZkdDVUiN0CWiL8bUoK+sLlPqc1ovGEfUp6
	vKS4V1I72U4zgq+1zmA94TjfR7fwVCU+URndE=
X-Received: by 2002:a05:600c:4c93:b0:493:e686:6134 with SMTP id 5b1f17b1804b1-493f2a96253mr526955e9.7.1783615909446;
        Thu, 09 Jul 2026 09:51:49 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d8410sm53974738f8f.15.2026.07.09.09.51.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 09 Jul 2026 09:51:48 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: protect stream_del_pending with fp->f_lock
Date: Thu,  9 Jul 2026 18:50:44 +0200
Message-ID: <20260709165141.2111-1-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

Follow-up to commit 36442851a4d1 ("ksmbd: route stream
FileDispositionInformation through stream delete flag"): fp's
stream_del_pending is read and written from three call sites
(ksmbd_inode_pending_delete(), ksmbd_fd_set_delete_pending()/
ksmbd_fd_clear_delete_pending(), and __ksmbd_inode_close()) with no
locking at all, unlike every other piece of shared per-handle mutable
state in this file, which uses fp->f_lock.

A FileDispositionInformation SET_INFO racing a concurrent close on the
same handle can see a stale value and skip removing the stream's
xattr even though the client asked for deletion.

Protect all three touch points with fp->f_lock, matching the existing
convention (e.g. notify_pendings).

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/vfs_cache.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index b393290b8..42b03e449 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -236,8 +236,14 @@ bool ksmbd_inode_pending_delete(struct ksmbd_file *fp)
 	 * also incorrectly report a whole-file pending-delete as applying
 	 * to an unrelated stream handle on the same inode.
 	 */
-	if (ksmbd_stream_fd(fp))
-		return fp->stream_del_pending;
+	if (ksmbd_stream_fd(fp)) {
+		bool pending;
+
+		spin_lock(&fp->f_lock);
+		pending = fp->stream_del_pending;
+		spin_unlock(&fp->f_lock);
+		return pending;
+	}
 
 	down_read(&ci->m_lock);
 	ret = (ci->m_flags & S_DEL_PENDING);
@@ -318,18 +324,24 @@ void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
  */
 void ksmbd_fd_set_delete_pending(struct ksmbd_file *fp)
 {
-	if (ksmbd_stream_fd(fp))
+	if (ksmbd_stream_fd(fp)) {
+		spin_lock(&fp->f_lock);
 		fp->stream_del_pending = true;
-	else
+		spin_unlock(&fp->f_lock);
+	} else {
 		ksmbd_set_inode_pending_delete(fp);
+	}
 }
 
 void ksmbd_fd_clear_delete_pending(struct ksmbd_file *fp)
 {
-	if (ksmbd_stream_fd(fp))
+	if (ksmbd_stream_fd(fp)) {
+		spin_lock(&fp->f_lock);
 		fp->stream_del_pending = false;
-	else
+		spin_unlock(&fp->f_lock);
+	} else {
 		ksmbd_clear_inode_pending_delete(fp);
+	}
 }
 
 static void ksmbd_inode_hash(struct ksmbd_inode *ci)
@@ -458,10 +470,12 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 		 * the inode-wide flag above, which only ever meant "some
 		 * stream on this file" with no way to say which one.
 		 */
+		spin_lock(&fp->f_lock);
 		if (fp->stream_del_pending) {
 			fp->stream_del_pending = false;
 			remove_stream_xattr = true;
 		}
+		spin_unlock(&fp->f_lock);
 
 		if (remove_stream_xattr) {
 			const struct cred *saved_cred;

base-commit: 5e6eeafe46a4a19559808c5ef36ea36ea4f2a204
-- 
2.43.0

