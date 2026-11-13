Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794608183;
	b=eMfGds9bnomyxRsyUajVPM6JnUdTZ51M5BhZJUyZESea3ygPE4cFW/PXbQmkZwoL6AZa
	 jMT/oCvg/xgkacppxCoRnTQQ6A/dlQ718nkbYD21ZCn8ddq0VXF303aKqDmWhbaWWQpuI
	 1kySQSrWm0Au47DVpPpdaCk6RyeheIgaqOMCsrUDEsrPIpbFkqSJBfgKClKkI9EquPKwl
	 5pWcowYkMVK9nLMjhY8LEXAy7Yg6DKxUuKHQgpDTmfSluhEmIkvTksBV81joSCGVK2osp
	 fwQRIgReN21qPH+8GwVQaQO0o7UVfxLulLpOWQjqhs43dHVRrUkoHx+YMFr4RVetZNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794608183;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SoW2Aa9wnKqCBhzzqwgKhpO45URIDTy0erzxkHEcwYI=;
	b=isbI9+ZjehJRksB9J2MYXTy5QcmWusMIONSR+ExLa/djEsmLQ7VWsEiFrQIcxmezuVaW
	 JCIuJrYxMgnBYoO7JCpXoMLdyWX/xr9A2rftgT7oJPKwpMBVUwzKurk5jkaU7h9HYR0Ff
	 conu34gZuNuZ7Yk5zTyaT0QsMlqWzDnmuhZvIr3cy+T4R/tKRNyZVJ5I0+LtGOkPCseKE
	 bMdrxrBk+OuhPXCJbmJJVOAP8Wo5q5cNxFxhOtOWn4NBQWPEvAvDqXe2xovu9SRBf9YGy
	 cMe3lvsejhjuXOXrGRURAOPagsiE/2fgGBRNc47Zvq3iQcgDNJ1vLDxluXJ7vO53FMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CeV24HrL;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982A6606A883
	for <linux-cifs@vger.kernel.org>; Fri, 13 Nov 2026 22:16:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 982A6606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CeV24HrL
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso10366925e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 13 Nov 2026 14:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794608181; x=1795212981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SoW2Aa9wnKqCBhzzqwgKhpO45URIDTy0erzxkHEcwYI=;
        b=CeV24HrLv37ZW3bFRXPn5UY/rcNajvccUekt8DDHJOsPiKnb9WRTPnyHZsTl6bMBFO
         zZctgSiGmMHcQqszCdpuFsAJU39bqQNkctyS+1qXKGmO64NQcovcZlEuApkX6CUJzvYb
         1Wak53Pmdyhwi8dCxs72wctw3WVxyRlbcOzVF52guutvu4ysCu04B7qzb3b8rzZaJXjE
         7JLQc6OR/eM52kzbA3hQ+oTAvftyCoWMFcFoqfFcB/K6qFLrPZTYQcTt3nay/nzm1dPy
         hcKAZ9rt1NW6bgMSmWF5C7Wn1jCBcgV0x06jUO9AB5npJT9oGcVixW1pRnx+W+DwKAzZ
         66WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794608181; x=1795212981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SoW2Aa9wnKqCBhzzqwgKhpO45URIDTy0erzxkHEcwYI=;
        b=Apf5txolFVuCfwIKZTnxH6N5DFBhR3v/fpEYa2iSAu/KoTI+Vzhy9GSweWAF0BBg2X
         RRq57ktmtZhrNxIWNSJ4z9zxM+EA5FY/xd6y5wZloKdlLqBXZG0FZvHQb7WRL6QkL0UY
         mT+VCk7Icngx2CmDvk7iO5/RhAhQw7hqyZqODho6N44sDVz8oZZ0wDdYUtdMqj5+gEVW
         HcmQj3XHokKci/P29pBw3iUWkagku/PBv6OKA5K1whnOR1iFC3/bGINqE7KKhxbPR39w
         TXFPMmhCLlbYlD5dhLvkFmqJeldgwymon7FrwGJHNOTPZ/0CV/dvRbtar6YJ3Gw9fsGm
         S2dw==
X-Forwarded-Encrypted: i=1; AL+hErHSsvyoqiU1W3ZgtY6jPCQB/DA/R1gIS9ieP9qa0L8Vy4J8MrdQsBwYmKQe0CbKDjs4YjdRpa9yU6At@vger.kernel.org
X-Gm-Message-State: APuU4Z8bhG7xtkI8Nj1PVZokQy3+2PpLpQ+zcYTzHOVCAJ3IM4CGtgDr
	boUq5FN5c0MNpRJvMYm+2cM9YSbp79MPLlFLyRr7xUQQz3MYvjKvVWqL
X-Gm-Gg: AYBFou23TL1h2K55dpQk7U8T9f0PuC+TRdpDGCCMlbXF/gWuBIrrRbBfOSFc90V8uQq
	8Cr4ektWPEK1LwZXWMJj8SNMyLfK4OhD7E1UVV/gyX5ymi8GBjoOfovcgt4McHyLlFR/5QxdOoC
	uD9it4LOlWJGnoyQcKnddl8Lh3VJlenijGZmjZY5xv/fnSyBxk7iKkUZOBVLyasvEztMaZU8jqh
	e/Sk8ezd8CzZIyixu7GDw9L2/HES9V0L6iESVTO0VI7X9vRGKRoikgeLKNevxHZ91tYDy5qyYot
	R54l3ZYYwUSDvlgNvTWGo5LzMJHANOBzhqIv//w7L+loRMrmBBfMRDxUR7nHTbJp0BKMn6vOfLJ
	4ayPOWt3xMXFYHkGCPuw6ibWxNaWq1rSmf9sVcoBLC/Fu0bUiXgULDvFcppelU07cwcJ71wvXWZ
	xvnjjmBuQpSvtLIgNf67GjLCXA8pmRncaZdqgt8LqsYx0jj2L6Hww+/wE+3nJG2PRJ7MaH6ujQn
	+nIKmquB2vqi1LrVtlx6kGsCi6sj8GTst8ah0GkqMzjuAIqVpDzZBf4+pKIdEy6/VAKFdR3JSZ5
	Gkb6nK/ZayGFUiAWwpuMqg/lTJmBtjGyJENgKF0SsmzIbs0=
X-Received: by 2002:a05:600c:3487:b0:4a4:f48e:78fa with SMTP id 5b1f17b1804b1-4bb55a4ea9dmr86275815e9.12.1794608180781;
        Fri, 13 Nov 2026 14:16:20 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55ac0e1esm84635595e9.3.2026.11.13.14.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:16:20 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH] ksmbd: decode and honor DOS attribute validity flags
Date: Fri, 13 Nov 2026 23:16:10 +0100
Message-ID: <20261113221610.392113-1-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when setting file attributes via FSCTL_SET_SPARSE,
FSCTL_SET_COMPRESSION or FileBasicInformation, ksmbd hardcodes
flags = 0x51 (XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
XATTR_DOSINFO_ITIME). This injects unrequested creation time and itime
into user.DOSATTRIB on disk, even though the client only requested an
attribute modification.

Furthermore, ndr_decode_dos_attr() discards the validity flags on read
by reading them into NULL. When reading a file with an attribute-only
xattr (flags = 0x01, where create_time on disk is 0), ksmbd treats the 0
as a valid timestamp and reports NTTIME(0) instead of falling back to
the underlying filesystem's btime. Modifying any attribute via
set_file_basic_info() then clobbers the xattr back to 0x51.

Fix this by:
1. decoding da->flags in ndr_decode_dos_attr() and only updating
   create_time and itime if their validity flags are set (in
   smb2_update_xattrs() and ksmbd_vfs_fill_dentry_attrs());
2. reading existing attributes and only setting XATTR_DOSINFO_ATTRIB in
   fsctl_set_sparse(), __ksmbd_vfs_set_compression(), and
   set_file_basic_info() so unrequested timestamps are not injected.

Reproducer, with /tmp as the local filesystem folder exported as [test]
in ksmbd.conf and /mnt as the smb folder mounted with mount -t cifs:

  mount -t cifs //127.0.0.1/test /mnt -o username=user,password=pass

test with sparse (for compression, use chattr +c instead of fallocate):

  echo data > /tmp/sparse.txt
  chmod 777 /tmp/sparse.txt

  stat -c 'Local btime (%n): %w' /tmp/sparse.txt
  getfattr -n user.DOSATTRIB -e hex /tmp/sparse.txt

  # punching hole via CIFS triggers FSCTL_SET_SPARSE
  fallocate -p -o 0 -l 4 /mnt/sparse.txt
  getfattr -n user.DOSATTRIB -e hex /tmp/sparse.txt

  stat -c 'CIFS btime (%n):  %w' /mnt/sparse.txt
  smbclient //127.0.0.1/test -U user%pass -c 'allinfo sparse.txt'

  # evict cache so btime is read fresh again
  umount /mnt
  mount -t cifs //127.0.0.1/test /mnt -o username=user,password=pass
  stat -c 'CIFS btime (%n):  %w' /mnt/sparse.txt

which prints:

  Local btime (/tmp/sparse.txt): 2026-11-13 21:13:27.167926440 +0000
  /tmp/sparse.txt: user.DOSATTRIB: No such attribute

  # file: tmp/sparse.txt
  user.DOSATTRIB=0x000004000400000051000000200200000000000000000000209542d3b373dd01
     0x51 = 0x1 | 0x10 | 0x40 -----^^         |      unrequested --^^^^^^^^^^^^^^^^
   (ATTRIB | CREATE_TIME | ITIME)             |   creation time = btime
                                     SPARSE --^
  CIFS btime (/mnt/sparse.txt):  2026-11-13 21:13:27.167926400 +0000
  [...]
  create_time:    Fri Nov 13 21:13:27 2026 UTC
  [...]
  CIFS btime (/mnt/sparse.txt):  2026-11-13 21:13:27.167926400 +0000

test with setmode:

  echo data > /tmp/attrib.txt
  chmod 777 /tmp/attrib.txt

  stat -c 'Local btime (%n): %w' /tmp/attrib.txt
  getfattr -n user.DOSATTRIB -e hex /tmp/attrib.txt

  # modify attribute via CIFS
  smbclient //127.0.0.1/test -U user%pass -c 'setmode attrib.txt +r'
  getfattr -n user.DOSATTRIB -e hex /tmp/attrib.txt

  stat -c 'CIFS btime (%n):  %w' /mnt/attrib.txt
  smbclient //127.0.0.1/test -U user%pass -c 'allinfo attrib.txt'

  # evict cache so btime is read fresh again
  umount /mnt
  mount -t cifs //127.0.0.1/test /mnt -o username=user,password=pass
  stat -c 'CIFS btime (%n):  %w' /mnt/attrib.txt

which prints:

  Local btime (/tmp/attrib.txt): 2026-11-13 21:13:27.195647069 +0000
  /tmp/attrib.txt: user.DOSATTRIB: No such attribute

  # file: tmp/attrib.txt
  user.DOSATTRIB=0x000004000400000051000000210000000000000000000000f6cf46d3b373dd01
     0x51 = 0x1 | 0x10 | 0x40 -----^^       |        unrequested --^^^^^^^^^^^^^^^^
   (ATTRIB | CREATE_TIME | ITIME)           |     creation time = btime
                                 READONLY --^
  CIFS btime (/mnt/attrib.txt):  2026-11-13 21:13:27.195647000 +0000
  [...]
  create_time:    Fri Nov 13 21:13:27 2026 UTC
  [...]
  CIFS btime (/mnt/attrib.txt):  2026-11-13 21:13:27.195647000 +0000

After this patch, the outputs should be:

sparse:

  Local btime (/tmp/sparse.txt): 2026-11-13 21:20:25.856425751 +0000
  /tmp/sparse.txt: user.DOSATTRIB: No such attribute
  # file: tmp/sparse.txt
  user.DOSATTRIB=0x0000040004000000010000002002000000000000000000000000000000000000
          0x01 = 0x1 (ATTRIB) -----^^         | no creation time --^^^^^^^^^^^^^^^^
                                     SPARSE --^
  CIFS btime (/mnt/sparse.txt):  2026-11-13 21:20:25.856425700 +0000
  create_time:    Fri Nov 13 21:20:26 2026 UTC
  CIFS btime (/mnt/sparse.txt):  2026-11-13 21:20:25.856425700 +0000

setmode:

  Local btime (/tmp/attrib.txt): 2026-11-13 21:20:25.976415893 +0000
  /tmp/attrib.txt: user.DOSATTRIB: No such attribute
  # file: tmp/attrib.txt
  user.DOSATTRIB=0x0000040004000000010000002100000000000000000000000000000000000000
          0x01 = 0x1 (ATTRIB) -----^^       |   no creation time --^^^^^^^^^^^^^^^^
                                 READONLY --^
  CIFS btime (/mnt/attrib.txt):  2026-11-13 21:20:25.976415800 +0000
  create_time:    Fri Nov 13 21:20:26 2026 UTC
  CIFS btime (/mnt/attrib.txt):  2026-11-13 21:20:25.976415800 +0000

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3") # ndr decode/basic info
Fixes: f44158485826 ("cifsd: add file operations") # ksmbd_vfs_fill_dentry_attrs
Fixes: 159e727f763d ("ksmbd: persist FSCTL_SET_SPARSE state") # sparse
Fixes: 0fb327626ad9 ("ksmbd: support file compression attributes") # compression
Cc: stable@vger.kernel.org
Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.3
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
This should be (hopefully) the last of the fixes needed to implement ptime[1].
Thanks for testing all of them and merging them <3

Best,
koraynilay

[1]: https://lore.kernel.org/all/20261101015551.786044-1-koray.fra@gmail.com/T/#t


 fs/smb/server/ndr.c     |  2 +-
 fs/smb/server/smb2pdu.c | 35 +++++++++++++++++++++++------------
 fs/smb/server/vfs.c     |  8 +++-----
 3 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/ndr.c b/fs/smb/server/ndr.c
index 7e546c22e284..b5190528340f 100644
--- a/fs/smb/server/ndr.c
+++ b/fs/smb/server/ndr.c
@@ -256,7 +256,7 @@ int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 		return -EINVAL;
 	}
 
-	ret = ndr_read_int32(n, NULL);
+	ret = ndr_read_int32(n, &da->flags);
 	if (ret)
 		return ret;
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 806748ac2cb8..605f45e6801b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3733,8 +3733,10 @@ static void smb2_update_xattrs(struct ksmbd_tree_connect *tcon,
 	if (rc > 0) {
 		if (store_dos_attrs) {
 			fp->f_ci->m_fattr = cpu_to_le32(da.attr);
-			fp->create_time = da.create_time;
-			fp->itime = da.itime;
+			if (da.flags & XATTR_DOSINFO_CREATE_TIME)
+				fp->create_time = da.create_time;
+			if (da.flags & XATTR_DOSINFO_ITIME)
+				fp->itime = da.itime;
 		} else {
 			fp->f_ci->m_fattr &=
 				~(FILE_ATTRIBUTE_COMPRESSED_LE |
@@ -8905,12 +8907,24 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 	    (crtime > 0 || file_info->Attributes)) {
 		struct xattr_dos_attrib da = {0};
 
-		da.version = 4;
-		da.itime = fp->itime;
-		da.create_time = fp->create_time;
-		da.attr = le32_to_cpu(fp->f_ci->m_fattr);
-		da.flags = XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
-			XATTR_DOSINFO_ITIME;
+		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, fp->filp->f_path.dentry, &da);
+		if (rc <= 0) {
+			da.version = 4;
+			da.flags = 0;
+		}
+
+		/*
+		 * itime gets preserved when reading the xattr if already present
+		 * otherwise don't write it as it wasn't asked for by the client
+		 */
+		if (crtime > 0) {
+			da.create_time = fp->create_time;
+			da.flags |= XATTR_DOSINFO_CREATE_TIME;
+		}
+		if (file_info->Attributes) {
+			da.attr = le32_to_cpu(fp->f_ci->m_fattr);
+			da.flags |= XATTR_DOSINFO_ATTRIB;
+		}
 
 		rc = ksmbd_vfs_set_dos_attrib_xattr(idmap, &filp->f_path, &da,
 				true);
@@ -11743,10 +11757,7 @@ static inline int fsctl_set_sparse(struct ksmbd_work *work, u64 id,
 						     fp->filp->f_path.dentry, &da);
 		if (ret <= 0) {
 			da.version = 4;
-			da.itime = fp->itime;
-			da.create_time = fp->create_time;
-			da.flags = XATTR_DOSINFO_CREATE_TIME |
-				XATTR_DOSINFO_ITIME;
+			da.flags = 0;
 		}
 
 		da.attr = le32_to_cpu(fp->f_ci->m_fattr);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 0c95d4668370..f48c6b37b78a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1936,7 +1936,8 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, dentry, &da);
 		if (rc > 0) {
 			ksmbd_kstat->file_attributes = cpu_to_le32(da.attr);
-			ksmbd_kstat->create_time = da.create_time;
+			if (da.flags & XATTR_DOSINFO_CREATE_TIME)
+				ksmbd_kstat->create_time = da.create_time;
 		} else {
 			ksmbd_debug(VFS, "fail to load dos attribute.\n");
 		}
@@ -2475,10 +2476,7 @@ static int __ksmbd_vfs_set_compression(struct ksmbd_work *work,
 		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, dentry, &da);
 		if (rc <= 0) {
 			da.version = 4;
-			da.itime = fp->itime;
-			da.create_time = fp->create_time;
-			da.flags = XATTR_DOSINFO_CREATE_TIME |
-				XATTR_DOSINFO_ITIME;
+			da.flags = 0;
 		}
 
 		da.attr = le32_to_cpu(fp->f_ci->m_fattr);

base-commit: e9399de313199e9ffc1035755479a65ae4b3c5cf
prerequisite-patch-id: 049ae0eba275b5be35a238833107e0b251a55aa2
-- 
2.56.0

