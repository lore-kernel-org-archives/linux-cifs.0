Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD47325494
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780934324; cv=none; b=h+blmWleqeXwfpBZO12qTMj29ByJCVeZBThtgVteha0rHZEobEo89jaIS0ZP340NW5Ou11uARH7QEmlkM+k73XPsK1ubD2rlQnYkauTeaRjEfdP8P+edU+v5znnGh/NCnGghPUmUExi5fxT32JTjDw5Tty/pHFJ7iV36rfXJqpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780934324; c=relaxed/simple;
	bh=+M7GgwdT/XBDrwnQJWfCXFQJUGbJ7PTdgrz60YYP+ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJAhaHeVhaw5MsphKI+f74Iu4sFGAmw6Vj2krCeTSFUiBOYBZt6K8kwjgCAbitHb29Qs41hwYtl2FBGpxfgt5Gm0UztXLmPsqrzvOaaZH/I2uWVPP6VjzKTYCV+TRB3260hbNs+ccRHuCPlc85hhmsGWd9uuyKDDhOrVOIL7qcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TS59ZBZ1; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TS59ZBZ1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780934321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aXhf2v2dGMFA5vb7lNhGNR0ZJhAP4rEN5rwgxZgTwXY=;
	b=TS59ZBZ10Jyh9lVOXl+HPSh8CITRBCeUNG6EfU3dDVvrM8t216T2Qq2lhDn7iLtbuhFOzT
	jvuqeKyKD2D/w2ewwYpOSnwxw4fizo8mn6OlmfpMYEPfdo4qHQeMyNHuwywauUTgQSGNOG
	OKtxyQtqQYScVHy0YYqrqmEMRGK/KqU=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 1/3] smb/client: always return a value for FS_IOC_GETFLAGS
Date: Mon,  8 Jun 2026 23:57:29 +0800
Message-ID: <20260608155731.634984-2-huiwen.he@linux.dev>
In-Reply-To: <20260608155731.634984-1-huiwen.he@linux.dev>
References: <20260608155731.634984-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Currently, repeated lsattr calls on a regular CIFS file without the
compressed attribute may show random flags:

	$ touch test.bin
	$ lsattr test.bin
	s-S-ia-A-EjI---------m test.bin
	$ lsattr test.bin
	------d-cEjI---------m test.bin

The lsattr reproducer depends on the previous contents of its userspace
buffer, so it may not reproduce on every setup. A deterministic
reproducer is to initialize the ioctl argument before FS_IOC_GETFLAGS
on a file without the compressed attribute:

        int flags = 0x7fffffff;
        ioctl(fd, FS_IOC_GETFLAGS, &flags);

On an affected kernel, flags remains 0x7fffffff. With the fix, it is
set to 0.

This happens because when the cached inode does not have the compressed
bit set, the CIFS fallback path in FS_IOC_GETFLAGS returns success
without calling put_user() to write the zero flags value into the user
buffer. As a result, the caller observes stale contents from its own
buffer.

Fix this by always writing the visible flags value back to the user
buffer before returning success, even when the value is zero.

Fixes: 64a5cfa6db94 ("Allow setting per-file compression via SMB2/3")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/ioctl.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 17408bb8ab65..746d70091f3d 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -392,13 +392,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			}
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 #endif /* CONFIG_CIFS_POSIX */
-			rc = 0;
-			if (CIFS_I(inode)->cifsAttrs & ATTR_COMPRESSED) {
-				/* add in the compressed bit */
-				ExtAttrBits = FS_COMPR_FL;
-				rc = put_user(ExtAttrBits & FS_FL_USER_VISIBLE,
-					      (int __user *)arg);
-			}
+			if (CIFS_I(inode)->cifsAttrs & FILE_ATTRIBUTE_COMPRESSED)
+				ExtAttrBits |= FS_COMPR_FL;
+
+			rc = put_user(ExtAttrBits & FS_FL_USER_VISIBLE,
+				      (int __user *)arg);
 			break;
 		case FS_IOC_SETFLAGS:
 			if (pSMBFile == NULL)
-- 
2.43.0

