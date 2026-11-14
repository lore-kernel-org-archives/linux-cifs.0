Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794619679;
	b=mjU/wIJabA5TURKWCGEVNMmw2CJg3ZLKJP4c878Yv/3MhzTJc2Pxmvo6yEKHzpao72lS
	 WcuX0RAJA7hZL5L2aOpxjemdaIzQAPGN6JEFparggwy/hXX52Yd+b7y0mCUsD0Mvc2rz3
	 zf7OrSgbLtyeBvoPY+bZ8irtU9Tm2k8k8ZEDBvasW77DP1F0E2Yh3JlErXF0V8okLCsJr
	 LRKUi6ZIVc34H5K8lZ7JNdOjxDtVbm2Yie5Fsk8kD3fsKhoR8OBvTXkadTL8biXicoB3E
	 6cdM3PEU1ZyZE5o6w5hGh30e2vQHoZHtdzb6Pj8I3yT1iqJcF+pJrADlA0ZroLoGiIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794619679;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6CvH9xDs6NNAjm4CdXogsoT63KOhmd6mIYSEOWAkQKA=;
	b=k6XZJChv5k/pQSRxLoQamn3iaBHXZNnFAzamAjyTrVkvOUsliHugBwovSgUZNEd3hTeU
	 4A26RwbZkVOZlzRZAwupN5v9DFez+/4eEjlAxD5sWcKGmiCjP5prrvsCMiBrfDoypkwIf
	 F5FC86Aym8nd9TrueX/kuP+sFLVWO/2YqNr1HQ7eElzZGkxx15OFOSpYkaEvhqqTEP9NG
	 VnAMkk3PHF7qflBvJqmV1bj48IzaeRMgmPdz5zBd3crVGndmBdRY4YynRbhHC5ZRTJ2IP
	 HwMZYdWAY0Gbac7nRCW99QgijnUWaH9DKu9GuvkQaFTLddrpdpLZ8/QO0aZ2t/wXdgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B6VMhVGV;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B099F606A32E
	for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 01:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B099F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B6VMhVGV
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so7648655e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 13 Nov 2026 17:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794619677; x=1795224477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6CvH9xDs6NNAjm4CdXogsoT63KOhmd6mIYSEOWAkQKA=;
        b=B6VMhVGVelQ9ZrSDC03pRf4miM7zCDR9HUs2ANt98LCkadIWUyeYORv3dqoYws0ndV
         /q6lhXmAjYSkJkCizR+vwNLly8V5y76WkHz1ESTA2rDEE4VTYnfZpuqA4AF4SGWeghLW
         njas1NYqvep3tyNevmQWOCOoqnzu16DWaA8iXiEutmUGiHx0IbknsjrhCqPmpE6wbP5F
         upNqJaHz7K/B1yTyjOWY8xh4PtDAzLi6524msoRpDVQqBKMOJcuZWv24LYCakgDn5Y1t
         dWNJdWNW5lwVOnOz8ugGME3GtlyFsZ5VrG1727tZH55R+N3skVd0J5lB/n+AMC/T5672
         BCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794619677; x=1795224477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6CvH9xDs6NNAjm4CdXogsoT63KOhmd6mIYSEOWAkQKA=;
        b=FyEyzecJjIn79JxGCEMgTm2e5SH3ffAdiS7AHw0YZ6UjuDqqLEg30UUisG34EuFnBz
         sdxRb4J/8KY78IWWu9K9hCg9ggKofbGPX56AafmZGWFSTHL2JfZY15R9SFJBe6SHTsby
         rYbtDKQhZVwfMhWGaIv8vGIcvOlBvPmWSpTo/nnJy89AUQ4hk89ZIHoZH+ODZjJqtI3e
         DRyKV25vO7bXEtzP6Ka4Y3eDIOnKMjjbq2KUIo3/7T3p6OnopMqFIBmxNVC6qWWWBI6T
         f/jirK/2a8VvXdWuZsS8tpA944trvFfICezp11Lt40AU25+Rb9rQPydcRalrxNBjfOhm
         iOOA==
X-Forwarded-Encrypted: i=1; AL+hErG3XjWUGF6L2uGmVYlaf1lWawj1hjnr4ohNVgu8CVYsa6JsBvIjHhe0d0z3CTyYI9ZPjxXzt7zbHmg/@vger.kernel.org
X-Gm-Message-State: APuU4Z9LrSQ+FA32dtqutFif+3EIl54hWYeIFCooD7WTHGwL/T97tJi6
	RxZvP1HYqe/0IFdOW3QnExYxP/GFGLugz2u5GXm1+uek4zk+DJyOv/rJWoL6dSX4
X-Gm-Gg: AYBFou18zaY6dVnnZiwydo0fethEFWuEP2R6y7Hk/I06k0/sJeN9Y+PzUdh4Ggpfpab
	DBm2svDHG8FEhORK1+dWMqfnUileRifkKtxnML1uBWoEvyWwpQrzLVADNfHzXUAKhpvwp8iPFc8
	gFmPs70cp7d8rk795RhNs66isx+ZPIhttGz4qepzEGz4DaD4zupFJqvJf1QAHhrYsAStejqAHNH
	P/EYqTc5tjLlgLhzkfdMpt5BPSJr69xitiIcSYl3+z2IcUO9PIvG5KUQmsobFOCUvSgWB4Odw06
	jEiK1SJKPnmKp1Ch33xGkiJa3vwg7mMToPjbfcU7tmhq6wxcxW1A5m8rGvp+SHzzQHesK9ZHQrK
	DsfSvpXBpWcC1la5q/Bzsu2BgMWJuj4IaYnywfZGrBCNsqke+J3H+Clbv1NprR8mBlNQYLyAQJG
	p1x3HwDRmJ0w38dTBVaQr/uJaaXlGgqh2IdLmru2IVuu2XNMyprzq8cQQWAWCC3rPMdR2ALWiA0
	nhq7TlQ0iiVVPLBgTGXX23nqw8zlDe23OVKPPW35HcP/48MggQ4vzX5s1kD6mrTCxpuMPMvXAO9
	4mX8G+mLAQVcTYaxMh4A0yTt
X-Received: by 2002:a5d:5f46:0:b0:48e:68d5:81a6 with SMTP id ffacd0b85a97d-49c72306b88mr9208114f8f.34.1794619676936;
        Fri, 13 Nov 2026 17:27:56 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c609c602dsm7904342f8f.46.2026.11.13.17.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 17:27:56 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v2] ksmbd: decode and honor DOS attribute validity flags
Date: Sat, 14 Nov 2026 02:27:36 +0100
Message-ID: <20261114012736.639171-1-koray.fra@gmail.com>
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
v2 changes:
- Check XATTR_DOSINFO_ATTRIB on read in smb2_update_xattrs() and
  ksmbd_vfs_fill_dentry_attrs() to prevent overwriting in-memory attributes
  with 0 when an xattr lacks DOS attributes (found by sashiko[2]);
- unconditionally preserve current attributes and set XATTR_DOSINFO_ATTRIB
  in set_file_basic_info() so setting CreationTime alone does not write
  zeroed attributes to disk (found by sashiko[2]);
- decode version 3 fields (ea_size, size, alloc_size, change_time) in
  ndr_decode_dos_attr() instead of reading into NULL so preserving flags on
  version 3 xattrs retains their values (found by sashiko[2]).

This should be (hopefully) the last of the fixes needed to implement ptime[1].
Thanks for testing all of them and merging them <3

Best,
koraynilay

[1]: https://lore.kernel.org/all/20261101015551.786044-1-koray.fra@gmail.com/T/#t
[2]: https://sashiko.dev/#/patchset/20261113221610.392113-1-koray.fra%40gmail.com


 fs/smb/server/ndr.c     | 10 +++++-----
 fs/smb/server/smb2pdu.c | 34 ++++++++++++++++++++++------------
 fs/smb/server/vfs.c     | 11 +++++------
 3 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/fs/smb/server/ndr.c b/fs/smb/server/ndr.c
index 7e546c22e284..1376d5a59fc8 100644
--- a/fs/smb/server/ndr.c
+++ b/fs/smb/server/ndr.c
@@ -256,7 +256,7 @@ int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 		return -EINVAL;
 	}
 
-	ret = ndr_read_int32(n, NULL);
+	ret = ndr_read_int32(n, &da->flags);
 	if (ret)
 		return ret;
 
@@ -271,15 +271,15 @@ int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 
 		ret = ndr_read_int64(n, &da->create_time);
 	} else {
-		ret = ndr_read_int32(n, NULL);
+		ret = ndr_read_int32(n, &da->ea_size);
 		if (ret)
 			return ret;
 
-		ret = ndr_read_int64(n, NULL);
+		ret = ndr_read_int64(n, &da->size);
 		if (ret)
 			return ret;
 
-		ret = ndr_read_int64(n, NULL);
+		ret = ndr_read_int64(n, &da->alloc_size);
 		if (ret)
 			return ret;
 
@@ -287,7 +287,7 @@ int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 		if (ret)
 			return ret;
 
-		ret = ndr_read_int64(n, NULL);
+		ret = ndr_read_int64(n, &da->change_time);
 	}
 
 	return ret;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index dac7cd05e023..748061a0899d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3866,9 +3866,12 @@ static void smb2_update_xattrs(struct ksmbd_tree_connect *tcon,
 					    path->dentry, &da);
 	if (rc > 0) {
 		if (store_dos_attrs) {
-			fp->f_ci->m_fattr = cpu_to_le32(da.attr);
-			fp->create_time = da.create_time;
-			fp->itime = da.itime;
+			if (da.flags & XATTR_DOSINFO_ATTRIB)
+				fp->f_ci->m_fattr = cpu_to_le32(da.attr);
+			if (da.flags & XATTR_DOSINFO_CREATE_TIME)
+				fp->create_time = da.create_time;
+			if (da.flags & XATTR_DOSINFO_ITIME)
+				fp->itime = da.itime;
 		} else {
 			fp->f_ci->m_fattr &=
 				~(FILE_ATTRIBUTE_COMPRESSED_LE |
@@ -9039,12 +9042,22 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 	    (crtime > 0 || file_info->Attributes)) {
 		struct xattr_dos_attrib da = {0};
 
-		da.version = 4;
-		da.itime = fp->itime;
-		da.create_time = fp->create_time;
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
 		da.attr = le32_to_cpu(fp->f_ci->m_fattr);
-		da.flags = XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
-			XATTR_DOSINFO_ITIME;
+		da.flags |= XATTR_DOSINFO_ATTRIB;
 
 		rc = ksmbd_vfs_set_dos_attrib_xattr(idmap, &filp->f_path, &da,
 				true);
@@ -11877,10 +11890,7 @@ static inline int fsctl_set_sparse(struct ksmbd_work *work, u64 id,
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
index 0c95d4668370..40d86abaad7a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1935,8 +1935,10 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 
 		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, dentry, &da);
 		if (rc > 0) {
-			ksmbd_kstat->file_attributes = cpu_to_le32(da.attr);
-			ksmbd_kstat->create_time = da.create_time;
+			if (da.flags & XATTR_DOSINFO_ATTRIB)
+				ksmbd_kstat->file_attributes = cpu_to_le32(da.attr);
+			if (da.flags & XATTR_DOSINFO_CREATE_TIME)
+				ksmbd_kstat->create_time = da.create_time;
 		} else {
 			ksmbd_debug(VFS, "fail to load dos attribute.\n");
 		}
@@ -2475,10 +2477,7 @@ static int __ksmbd_vfs_set_compression(struct ksmbd_work *work,
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

base-commit: 2cc92355992022c1c6edad59499c49814e17cac0
prerequisite-patch-id: 049ae0eba275b5be35a238833107e0b251a55aa2
-- 
2.56.0

