Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2F528C869
	for <linux-cifs@vger.kernel.org>; Tue,  2 Jun 2026 10:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780397999; cv=none; b=J+HPOCipucV3x7KpTxmA/AtQzVx4uWN1X52LjkkTeLfneq+u67R6qLs3sgNYZ2h1tQIPhPN2rSfXmR8XwCiLgnshjf47pikTlDEpzXvrhMG1ERcA9nWv7vSQ9JHQrKsVO5gc4PoYgJrt3o2U8XsE/2IohZiVJ17k+0Gw4BUgoRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780397999; c=relaxed/simple;
	bh=sIVdK1xaNSNQwCVlOv/Pixr8w05CIer7htOyvmA6LMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oTFyzmZvXQDkUtZTK7SV75PTDtxeOnPcqHFxk/WF05sO8W/Eg2nQYgurAEMiEP3QQUhr4ztHHFWsURC33hRlQ+7ZaXwHnh1fbjKlB+wsrT9pzK0bxrl03L4Mg71457MMBF2/xUyP7nFOD0MolsSkITsggDCwQ1VtQPSAKXSTAls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KSevwFm2; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KSevwFm2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780397994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=L7qFB5lGQwqgEPRL6y70lO8/D+BdYgzCoInieJvnhd8=;
	b=KSevwFm2BvgNYbFO7QQhqBlE/B4OevYRz4JYVpB/oAlsDT4fmLA2lbOfabXG5JuDAx6/BM
	K0sqMuVdV1+q6cm+4PP3JQc9C2u3ERNoUskbSOwRVfKydPh/w9Ur0euDe14cbJ97o4Hl6S
	eGCmbf9rP4h7mBkPDeFx2ujkjsqoKxE=
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
Subject: [PATCH] smb/client: always return a value for FS_IOC_GETFLAGS
Date: Tue,  2 Jun 2026 18:59:30 +0800
Message-ID: <20260602105930.713403-1-huiwen.he@linux.dev>
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
index ac33ebaa1f97..9a624e88bca7 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -459,13 +459,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
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

