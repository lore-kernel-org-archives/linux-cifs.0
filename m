Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9558837B41F
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 23:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789342096; cv=none; b=kSpgtBThS2KWoltHtFRKFIoDiQ5IPVIcd600447VXAvy6mFI0+gArui4K0EQg52VhXrNRvYvZldBvR29rFX+vvWvz2wRxYxUP43QoUzdUA0Otc8y+wlFFatUD1oJnD9P6OuWhLLoskcoF3D6zdRAowKeWnbKmSjf9plnayS/QcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789342096; c=relaxed/simple;
	bh=blq7OQHAGqP5+dty+wpTPH422zohrf9FXG1IaSXd52I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uywXjIPhOQRr/Jp4utBnnisN27Lu9gx2SoIgq6Yikd5faicnFpV4J1eeehlOwC0FF1EtT5E8Zk9HM9Uww0VfOrEqk/tJH47cPLk/euF3kd04I5ZfCdu4V3jEXrP4GGwnCXLHOOAoDFfLPZ5Zuqb3jUikFa0ED22XMjaLKbrfrLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h7THdrC8; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h7THdrC8"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b965f447cso9680205e9.3
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 16:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789342093; x=1789946893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o8eC+3Yn+xzTNX15r9U41LFIJ1eIVM79PPkv032nyCo=;
        b=h7THdrC8DYVxT7nixhp5ytgWueQJLp9Ru9u9SBjVwR8jOPJZZhB5pvl4J0pnJb6QeA
         /RVe6+/y7v4eU/S2MkBP83cyV56opLrEJ4st2UOa2ooEHRFaBVT0cWotWGJ8XwbmPF4M
         AqxgxiCg7lziKmv5JYi3v8iYnYln1VnNnA4h0OMJDIOOrTCOJ93X7LEbkQ9Zi+Qx/F1S
         AsPEDxca/1sNXERH6t4rS4aQRs2ZMe0PdLCUN4yXZ1U86JooPvkU7qQmE8sKpSHZ3FzJ
         mtCDqDwyJNbeaJ7da309cTyukJO+vqyXhV2lqzWncNxCk11ICszah19j9KXEDvW0qLb3
         7BBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789342093; x=1789946893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o8eC+3Yn+xzTNX15r9U41LFIJ1eIVM79PPkv032nyCo=;
        b=Zy3p2uYHwep1OEyPVVz5jZHXeoDQJY7Co3kzt6xumasFk6cp8vZfK2rw+9KXfooWHh
         zieA6gaUj2hVb+3XBgM29uDaqTEe3rcD0oIGuePQcp6Ik9XaghnuLNrmsYphveAvKLs2
         oA5ixCgsH5tut2ggBQY9xHRYqEu7JWN3/yenGMRa1zeQZlWtvtHQdrH2kAuaY/Gpof8J
         JwhikYLgsPHai3fKYEDBYFkJi6slKIXFKzJdyRhAp8iv5ppRokqlyIAs0HgXeIK+U8Z2
         le43ODBjxfFlTqR6pAiVm/qjKohnhIqAT7tMp1wAyruytAT8cK01RXwZX9mMVzzHrUEW
         Pjmg==
X-Forwarded-Encrypted: i=1; AKwUvBwQDappqqA5u3aqm465IYVgEvh4L+zS6r0PkmtsDooy1MU6z2jdqnBD5wlXGOKRjVIMdTMXdDBkJ7dU@vger.kernel.org
X-Gm-Message-State: AFuF++mrAGoY/F9I06FpOavS3X10EQaWHjbIblwCpt+7x8fl+iRbPEk/
	bVPsAjkRd8kVbZI+DyUpBo9rVm/RbKUqd0vNapdU6dVnD7AMXVU5RBfXhx34qQ==
X-Gm-Gg: AYBFou1tCrpzA+NlqqIGKxb9AmPBR1ModX95wi76/LTfMgJFijckIDzZWXRjsq5onMX
	MyJdOySn+S0VNFsLg0JnPk17c1iHTdtylC0w+sx1x/V+ZWKAx57Y+ZBfQN0s79U2ukpakvWgsyV
	yTrXTxu/aKZFzHm1P0zxfjAskthav4RKfCGWqEsxfXgrXUf/MrnecdcxZcTqq+WJZZFO686QYAO
	UCc/N50g+1kDvf9mqhYftULKswmDvjKn/nS8SIq7RgZw0fNRv8IBNwcwQszzxPTqof0rmirezXM
	HmwyoagqW9m3Jpq99eqBkd7pcDg2JhlH4eI5EEv7bYDLoDbGI3eXdmCuTz23Enn+XTsbOqYd6xl
	L+P3sWNC6zuQOxjQr1AgGs16ccWUNioQ+IwNYxdMMUfC82TozO7jlBhh256q7+9L5jVX5//0YhC
	Oc/Nayd61RDKxYuSIG5DiUHUexgO5LMixDJKdWH/8GS98jMmTNDTlTn0zPGcRC4I/WQNRKClPeR
	DFXDFdwL8xWJsG4rvytaws=
X-Received: by 2002:a05:600c:4e89:b0:49e:6b55:22b8 with SMTP id 5b1f17b1804b1-49e7a6386b8mr1265455e9.4.1789342092387;
        Sun, 13 Sep 2026 16:28:12 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6499d57bsm396657625e9.3.2026.09.13.16.28.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 16:28:11 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 2/4] ksmbd: look up stream size by exact xattr name
Date: Mon, 14 Sep 2026 01:26:36 +0200
Message-ID: <20260913232737.51704-3-g.blivet@me.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913232737.51704-1-g.blivet@me.com>
References: <20260913232737.51704-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

get_file_stream_info() walks the xattr list from a single
ksmbd_vfs_listxattr() and sizes each stream it finds with
ksmbd_vfs_casexattr_len(), which matches with strncasecmp(). Linux
xattr names are case-sensitive, so two streams differing only in case
report each other's size.

The loop already holds the exact name, so query it directly with
ksmbd_vfs_xattr_len(), which is what casexattr_len() calls once its
search succeeds. Make it non-static and declare it in vfs.h, and drop
the comment above it, which describes a different bug and no longer
matches the code.

This also drops a full listing per stream: casexattr_len() runs its own
listxattr on every call, so enumerating a file with N xattrs cost N
listings instead of one.

Fixes: 689f1eb3719d ("ksmbd: report actual xattr value length in stream enumeration")
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-opus-5
---
 fs/smb/server/smb2pdu.c | 13 ++-----------
 fs/smb/server/vfs.c     |  4 ++--
 fs/smb/server/vfs.h     |  2 ++
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d5def8a3becc..79b0cd165562 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6951,17 +6951,8 @@ static int get_file_stream_info(struct ksmbd_work *work,
 		streamlen *= 2;
 		kfree(stream_buf);
 		file_info->StreamNameLength = cpu_to_le32(streamlen);
-		/*
-		 * stream_name_len is the byte length of the xattr's *name*,
-		 * not its value -- same class of bug ksmbd_stream_eof()
-		 * (smb2pdu.c) already fixes for EndOfFile/AllocationSize on
-		 * a stream handle; this enumeration path needs the same
-		 * real xattr value length, not the name length reused as a
-		 * size.
-		 */
-		slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
-						path->dentry, stream_name,
-						strlen(stream_name) + 1);
+		slen = ksmbd_vfs_xattr_len(file_mnt_idmap(fp->filp),
+					   path->dentry, stream_name);
 		ssize = slen < 0 ? 0 : (loff_t)slen;
 		file_info->StreamSize = cpu_to_le64(ssize);
 		file_info->StreamAllocationSize = cpu_to_le64(ssize);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index c2bd972261c6..db0f2de2bab3 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -842,8 +842,8 @@ ssize_t ksmbd_vfs_listxattr(struct dentry *dentry, char **list)
 	return size;
 }
 
-static ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
-				   struct dentry *dentry, char *xattr_name)
+ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
+			    struct dentry *dentry, char *xattr_name)
 {
 	return vfs_getxattr(idmap, dentry, xattr_name, NULL, 0);
 }
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 2c53ca5bed7e..566c670c90be 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -108,6 +108,8 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
 			   struct dentry *dentry,
 			   char *xattr_name,
 			   char **xattr_buf);
+ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
+			    struct dentry *dentry, char *xattr_name);
 ssize_t ksmbd_vfs_getcasexattr(struct mnt_idmap *idmap,
 			       struct dentry *dentry, char *attr_name,
 			       int attr_name_len, char **attr_value);
-- 
2.53.0

