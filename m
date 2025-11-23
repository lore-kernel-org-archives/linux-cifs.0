Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DEA212574
	for <linux-cifs@vger.kernel.org>; Sun, 23 Nov 2025 02:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763866468; cv=none; b=LeC+WwE2JVR1/uJaP79eTIt+UGUb7QZksMbSxPa8z5nk4BKp3xxXSoFRM7n3sJZ3qYSdWJxp6ERnryKdhOSO7KcAUjpSTV2We3bliO0A4qAPGkGazjjgHmMiR8U7Ei1KRvtHyRShfttAZ3JjFdd0PFiRW/KV51LehELNgt2R2P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763866468; c=relaxed/simple;
	bh=VPSEhOnB2RE6eQydB0Smr96MaVFBkvWgt2EDOEnbyuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mUb5t2zBOioN/LPv7z0+dNJVQC7VipCNj0PhIYUyiSQLUIGQ4uPMzgezkB9QSVVUXIHLV0qwUwqODymDQQX+ciE+CROAfCwcD9ddJUp+eciJPafTChE7D6CF+mkLYCQ+qB8cvN+bfYI1GuWXkaVZgjZWwj42VqGazzU61hdxxwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ru2Kf5ta; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ru2Kf5ta"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-bceaaed0514so261799a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 22 Nov 2025 18:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763866464; x=1764471264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rWyDuox+fsgvKye3HBmJxKH4MrEcdZHrSZHWuNczAU=;
        b=Ru2Kf5taPfYQ76Wzf60aQ1WFd4/4hmtFhaFR4sWgTn+4DLVmceCuRBZZZgx+hFe0lr
         kFdD3SB2rV2uXwgrTLfn7tVzzjJPrxyPhhh+4cKAPKCK6jIO8OjvBftVf9VkyW+pbIdc
         9uPxsky22hcfz3TP+CSpP1ztoJB4/P3XNgYFzlnxAijH1RNi1MG/BHim2e5VyBu2ohN7
         gt6siTEHi7ChlBR1usICkfmmR82o8Sz0ekY281FmFbF/jLx3asoOU8JIvzV/Dd4J6CL1
         6m8I6+zuO7mm8vKuP+ARnallH5rDm1PiyZ5/gyP6kIsC/PEIj9IaSbJF5ZjhIylCj+K1
         kI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763866464; x=1764471264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+rWyDuox+fsgvKye3HBmJxKH4MrEcdZHrSZHWuNczAU=;
        b=gcFtkceTHY0nno9MTlTHJ9AXwqweI55BtrIg0fhQH/Dw3Afbb4GlhqH3Vp5TpL0P/y
         sSGUmyueeypJBSIpbvQloYFVChxFCIYKF8Z5G2Pv1039pFHi/5dxqSPP08Cg7W2NgvA6
         uYb5iwUH/Y0/Yfm+ho2TlcGwJO9569XrrN//cRfwHi7C5dxTv3/E3YbyhlTEVgMo+hTh
         VIOWnQHCiPgRCucvVNagjo/CjyIWEoZahQ04UkW6ryXbrlf985UeYJrqhwk03aCvPnds
         HG86TyN8t26h1nbYqnRAxIXOnxg/j+aySOvJIgH8SEvoBg0lEKq8ooM5fZZ7HCySKmwV
         R+IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVOPRusDn8kdMDbMEuQXf6JsuJ0t9pyqmG0SOp+M3RlQvr/luQxkRq/TZuaL7mCkKe2EfVeP16VIj5@vger.kernel.org
X-Gm-Message-State: AOJu0YxzOAtJbXuMgPySCa8sRl1i6xDHdQ0j6IoG7syDWMJt3Q7rdDLZ
	UfeeDvh6qbigK2XvpSaXKLurDyBN0f9Cfo2i+5I6xUzHFg3ctmUYaxAv
X-Gm-Gg: ASbGnct4CYv0CaCSFcGoVRD7dwVlTCwJnRblVovz9GBp07k0KtVjyMglCfQ8EfrGm88
	rzotAI8gNZZqH+L7w1uLOi4cGegBGQLOY9Jw/cKGFN99TzsNlvhL/pyukVB8tyqNYBrO6sdoKLx
	wRToe2dF+NkJSPq9kY1qLMrMliRl/+XldeDXgUxVYngWMnCXH/aFRuR+/s7b7wgJGJB4/9oQ4h6
	/x1QBLeiCxx+PebZHy44ayQzSnFF6YnbZKMOyuVx8tb3k1liUMo2g6i2XzusimJ2hiA3Tx14KGp
	xRj/dYCyoaYy0dP3OHDgw9H8xzOBF055hU/JgGCpwakXP3+2Cx2kbbnWs8Qph/1fARPFryuEumz
	s71fWprUoM679cbMO6NeFYsWHDYtD77f0SvBm9dQtB+X7txeq/IRPABd3VlDRGsYDiGTPhgZVmJ
	OLvxnc48Q6YTJgt9fkOVDxisnb7W8hoP6927uvSGSIrvTaax5wC7fxdo0Xein79ulq897xV02w
X-Google-Smtp-Source: AGHT+IEOwgcBpDEpwRs7NjxIYRpA59LU4lAa4Z5co3ra/2xjeKkaDavEtEeAipX/NV+VPLbSZ81R9Q==
X-Received: by 2002:a17:90b:3e8b:b0:340:e0f3:8212 with SMTP id 98e67ed59e1d1-34736bdad39mr4096260a91.8.1763866464426;
        Sat, 22 Nov 2025 18:54:24 -0800 (PST)
Received: from poi.localdomain (KD118158218050.ppp-bb.dion.ne.jp. [118.158.218.50])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345b03e04e5sm8281266a91.6.2025.11.22.18.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 18:54:23 -0800 (PST)
From: Qianchang Zhao <pioooooooooip@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: gregkh@linuxfoundation.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: vfs: fix race on m_flags in vfs_cache
Date: Sun, 23 Nov 2025 11:54:14 +0900
Message-Id: <20251123025414.644641-1-pioooooooooip@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAKYAXd_v9sLxB7a10iwHwci_c38jNJiNNCQprb0Hu9TmaQE7gg@mail.gmail.com>
References: <CAKYAXd_v9sLxB7a10iwHwci_c38jNJiNNCQprb0Hu9TmaQE7gg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd maintains delete-on-close and pending-delete state in
ksmbd_inode->m_flags. In vfs_cache.c this field is accessed under
inconsistent locking: some paths read and modify m_flags under
ci->m_lock while others do so without taking the lock at all.

Examples:

 - ksmbd_query_inode_status() and __ksmbd_inode_close() use
   ci->m_lock when checking or updating m_flags.
 - ksmbd_inode_pending_delete(), ksmbd_set_inode_pending_delete(),
   ksmbd_clear_inode_pending_delete() and ksmbd_fd_set_delete_on_close()
   used to read and modify m_flags without ci->m_lock.

This creates a potential data race on m_flags when multiple threads
open, close and delete the same file concurrently. In the worst case
delete-on-close and pending-delete bits can be lost or observed in an
inconsistent state, leading to confusing delete semantics (files that
stay on disk after delete-on-close, or files that disappear while still
in use).

Fix it by:

 - Making ksmbd_query_inode_status() look at m_flags under ci->m_lock
   after dropping inode_hash_lock.
 - Adding ci->m_lock protection to all helpers that read or modify
   m_flags (ksmbd_inode_pending_delete(), ksmbd_set_inode_pending_delete(),
   ksmbd_clear_inode_pending_delete(), ksmbd_fd_set_delete_on_close()).
 - Keeping the existing ci->m_lock protection in __ksmbd_inode_close(),
   and moving the actual unlink/xattr removal outside the lock.

This unifies the locking around m_flags and removes the data race while
preserving the existing delete-on-close behaviour.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
---
 fs/smb/server/vfs_cache.c | 114 +++++++++++++++++++++++++++++---------
 1 file changed, 87 insertions(+), 27 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index dfed6fce8..b44e0d618 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -112,40 +112,88 @@ int ksmbd_query_inode_status(struct dentry *dentry)
 
 	read_lock(&inode_hash_lock);
 	ci = __ksmbd_inode_lookup(dentry);
-	if (ci) {
-		ret = KSMBD_INODE_STATUS_OK;
-		if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
-			ret = KSMBD_INODE_STATUS_PENDING_DELETE;
-		atomic_dec(&ci->m_count);
-	}
 	read_unlock(&inode_hash_lock);
+	if (!ci)
+		return ret;
+	down_read(&ci->m_lock);
+	if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
+		ret = KSMBD_INODE_STATUS_PENDING_DELETE;
+	else
+		ret = KSMBD_INODE_STATUS_OK;
+	up_read(&ci->m_lock);
+
+	atomic_dec(&ci->m_count);
 	return ret;
 }
 
 bool ksmbd_inode_pending_delete(struct ksmbd_file *fp)
 {
-	return (fp->f_ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
+	struct ksmbd_inode *ci;
+	bool ret;
+
+	if (!fp)
+		return false;
+
+	ci = fp->f_ci;
+	if (!ci)
+		return false;
+
+	down_read(&ci->m_lock);
+	ret = ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS);
+	up_read(&ci->m_lock);
+
+	return ret;
 }
 
 void ksmbd_set_inode_pending_delete(struct ksmbd_file *fp)
 {
-	fp->f_ci->m_flags |= S_DEL_PENDING;
+	struct ksmbd_inode *ci;
+
+	if (!fp)
+		return;
+
+	ci = fp->f_ci;
+	if (!ci)
+		return;
+
+	down_write(&ci->m_lock);
+	ci->m_flags |= S_DEL_PENDING;
+	up_write(&ci->m_lock);
 }
 
 void ksmbd_clear_inode_pending_delete(struct ksmbd_file *fp)
 {
-	fp->f_ci->m_flags &= ~S_DEL_PENDING;
+	struct ksmbd_inode *ci;
+
+	if (!fp)
+		return;
+
+	ci = fp->f_ci;
+	if (!ci)
+		return;
+
+	down_write(&ci->m_lock);
+	ci->m_flags &= ~S_DEL_PENDING;
+	up_write(&ci->m_lock);
 }
 
-void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp,
-				  int file_info)
+void ksmbd_fd_set_delete_on_close(struct ksmbd_file *fp, int file_info)
 {
-	if (ksmbd_stream_fd(fp)) {
-		fp->f_ci->m_flags |= S_DEL_ON_CLS_STREAM;
+	struct ksmbd_inode *ci;
+
+	if (!fp)
+		return;
+
+	ci = fp->f_ci;
+	if (!ci)
 		return;
-	}
 
-	fp->f_ci->m_flags |= S_DEL_ON_CLS;
+	down_write(&ci->m_lock);
+	if (ksmbd_stream_fd(fp))
+		ci->m_flags |= S_DEL_ON_CLS_STREAM;
+	else
+		ci->m_flags |= S_DEL_ON_CLS;
+	up_write(&ci->m_lock);
 }
 
 static void ksmbd_inode_hash(struct ksmbd_inode *ci)
@@ -255,29 +303,41 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 	struct ksmbd_inode *ci = fp->f_ci;
 	int err;
 	struct file *filp;
+	bool remove_stream_xattr = false;
+	bool do_unlink = false;
 
 	filp = fp->filp;
-	if (ksmbd_stream_fd(fp) && (ci->m_flags & S_DEL_ON_CLS_STREAM)) {
-		ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
-		err = ksmbd_vfs_remove_xattr(file_mnt_idmap(filp),
-					     &filp->f_path,
-					     fp->stream.name,
-					     true);
-		if (err)
-			pr_err("remove xattr failed : %s\n",
-			       fp->stream.name);
+
+	if (ksmbd_stream_fd(fp)) {
+		down_write(&ci->m_lock);
+		if (ci->m_flags & S_DEL_ON_CLS_STREAM) {
+			ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
+			remove_stream_xattr = true;
+		}
+		up_write(&ci->m_lock);
+
+		if (remove_stream_xattr) {
+			err = ksmbd_vfs_remove_xattr(file_mnt_idmap(filp),
+						     &filp->f_path,
+						     fp->stream.name,
+						     true);
+			if (err)
+				pr_err("remove xattr failed : %s\n",
+				       fp->stream.name);
+		}
 	}
 
 	if (atomic_dec_and_test(&ci->m_count)) {
 		down_write(&ci->m_lock);
 		if (ci->m_flags & (S_DEL_ON_CLS | S_DEL_PENDING)) {
 			ci->m_flags &= ~(S_DEL_ON_CLS | S_DEL_PENDING);
-			up_write(&ci->m_lock);
-			ksmbd_vfs_unlink(filp);
-			down_write(&ci->m_lock);
+			do_unlink = true;
 		}
 		up_write(&ci->m_lock);
 
+		if (do_unlink)
+			ksmbd_vfs_unlink(filp);
+
 		ksmbd_inode_free(ci);
 	}
 }
-- 
2.34.1

