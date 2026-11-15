Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794758003;
	b=26k6reAl0TN2jhnXTCI3VvBunJOc1YDk3Ef4MZPIHglqAgAzodPNNjKY9T2GhURb6zey
	 p3mJT8c4ZWhLV9II/m5fwwhYhNTvL8JMMsBHf1K+n1Tp0CXS8uHHk10eNQ939SSrFUHeA
	 dEsvvWGd4ioxaSVCbPknJEpEEnOjiF5aE1bBuQaH9pY3CGZgWNb0eBnQpqbkY0isf8b2T
	 oT4oy30Hv2hX66x+pqn7s7VevWxdSiLVqoH/ASYmTgjhg8aDgZo74+uxEijS3YufTca3p
	 IOj0Bta4BXjPWzlv6XBHIddHpUsyKZAP/mUW+0BvKEOSG/m8fFqEjr33bmD8iKt8UCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794758003;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ldHbDUMagHOYiQx23XtR0esOWK6zkJ8t5xfGmLjURSs=;
	b=ZFvMuCHgYrU65euCrZsg5BS5KWpx43YEz6deMGuuIvvhPgn2nqTd5SO4q8YkcsgFNDkR
	 fE6pwc/TIzHf86R1ekK+a51ms7hubf9/by1F87dyZMcLlnHzM22IUYKR92Ksa65WLpzvx
	 VDgwgTCGR67Hj3A217v6NemJB477wE+r4s03rh4bh4gVzARVe73YcqECW1P9Qgf2QLtth
	 0vn42g+uBT2BuP25QICGLaCFHlYOTLYtRLjFXJupHeiTFDS3E+p+Ht/l/y5Q2NWzmdmsf
	 YSkZMvFDYQwgm2iiJ34CGHLuvn84bZk3hSs9u00rgou5grtB5z4laWmVWI0APtADtrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mp74SfWj;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7E9606A31D
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 15:53:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F7E9606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mp74SfWj
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4919a880834so1228775f8f.0
        for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 07:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794758001; x=1795362801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ldHbDUMagHOYiQx23XtR0esOWK6zkJ8t5xfGmLjURSs=;
        b=Mp74SfWj/6yPQ2OxoZXwZHGeuzcILs4xrxNqhRnu2nw1d4TY+veEw7YFMUtAE+9Ls1
         8R5xOZUl7mKfEW1FteLjBDYrsJ5JWqW9Yv4yr+IGHmiaas4bSdjqjXcLhkcHMcZFKR/q
         c5MnZxde5oxPEuXm6QNwHYbXsC7WA11FVEdyw2ajm5v0+EwuJcH5M6XyV0acIevN2TKl
         4aq77CqNhjQFKJsmQNx2L20eDYFqQPC6d2DeN5s3Wt3FS6RPfTLpBj66erGaoPjnsxqG
         dtfL4Fi0RSyu8WPUp2UXQdfS8hWXNNio5J+FXvT+/dTg/qelKm9c5HdfRJJOnGndsS+W
         K+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794758001; x=1795362801;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ldHbDUMagHOYiQx23XtR0esOWK6zkJ8t5xfGmLjURSs=;
        b=rLsQ03MD5ZFweCgmcNMWhMVf6iY54lH3OX5bYM00jty41AmRann6VJd7cqCGQoIVl3
         J+CtASD9513mRDZuNwsmhLa6N4ccGdFzfGALgZuFdeLHSW0r+jRbu/QbnO8Vm7Txm+2F
         IJ+kbv0f7WSjcLhFEd5yGdWLGEQSSSCjUK3MrgfQIJPgpNwQCQD3sbZKWfTWXflrIRox
         EgR4es36zUojDhnn/rq51CFlcJw3nyF4/lzsjUzpMSG4jUQCy2RqKcs1hZqhdWZEbYWa
         2WeaJnTz4r41AlxtnCQVCAqizCOGDKYRG8F7gZMOATe3BjeZJBLNgrnEoNt1Qxv996/p
         1zmg==
X-Forwarded-Encrypted: i=1; AL+hErFfbtN5bibCfnFwDu6h2GPzM+gg6FO9UEv4Wjk20d4PQHIk2oasFbnG/3i7A39vneK840s3B5rhj8NB@vger.kernel.org
X-Gm-Message-State: APuU4Z+M43R7DxXsm9iiSkSd9F3kQL0AZFiFD1WIpOWOiRIzJawM3sR9
	jciJ8BbacmmNS+ptsaBZWB+yZlrfgqmaiNwuybU5UQosCJH4ZYGdiNUb
X-Gm-Gg: AYBFou0JYfgEGDAkJ5rTsW2Rsaxaw++6d2KgpGyvsfdaLXOAz/19iuvg5x8WPO6kcty
	5x+C9dzDWRLe/HWT6zPSurbu2mz0Qc1syEZhn7eZkbVIv3PEGDban+3cfR575suJOyu8qCYiAcF
	J6slM8k7ljmDjDe8KNTvaZIcvWkzQbmtzrKBAY9WFyRI1AtOg8R+DXDyfdcx6fd7F7Nr6qolIq4
	Q4PBJ3239mB8A4oLi4qe388AmYxTsj/1yIxmpWUwo7Qsn3J5IcX7W4Zozs5KnsqzWvf50dPVDtK
	xoXa8YB6ZT/qFXX7Cy4o+fyxY0LUJDPO/hUWkLRF8bfGbrl3zIHVdz6wkPG32dh7BlF6cWXemHT
	q7qkyR/AzwtkPwclxN/g72IdekVZUI6fu/aw+xgu3dCU4MzE4zd/DV5c6WTkh6Wlro4JkWIhDd2
	lapBDEDrihqlINZSk/zRfSdU3QkVMHQPV7lpbHPQGpsoYBmHjGR3NU7ETzAmYbVG7S+nM28bccM
	3UMJz6sbRAqxSC8g+huLAnB7LErPoNhCTPtTQrtoYT1DDvUKtMQo+V2+aqVp8ApIMlb9vanWmji
	+7BgmHPYdSpdjPEtThFRNDRy
X-Received: by 2002:a05:6000:2386:b0:48e:5071:420 with SMTP id ffacd0b85a97d-49c6e4a38e3mr20590911f8f.2.1794758000608;
        Sun, 15 Nov 2026 07:53:20 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f7828a4sm17215084f8f.23.2026.11.15.07.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 07:53:19 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v3 1/2] ksmbd: decode and honor DOS attribute validity flags
Date: Sun, 15 Nov 2026 16:53:07 +0100
Message-ID: <20261115155308.415734-1-koray.fra@gmail.com>
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
FSCTL_SET_COMPRESSION, or FileBasicInformation, ksmbd hardcodes
flags = 0x51 (XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
XATTR_DOSINFO_ITIME). This injects unrequested creation time and itime
into user.DOSATTRIB on disk, even though the client only requested an
attribute modification.

Furthermore, ndr_decode_dos_attr() discards validity flags on read by
reading them into NULL. Because of this, modifying an existing file via
FSCTL_SET_SPARSE or FSCTL_SET_COMPRESSION stripped flags down to 0x01
(XATTR_DOSINFO_ATTRIB) while leaving the creation timestamp on disk.
Conversely, on a file with only XATTR_DOSINFO_ATTRIB set (and with
create_time == 0 on disk), ksmbd treats the 0 as a valid timestamp and
reports NTTIME(0) instead of falling back to the underlying filesystem's
btime.

Fix this by:
1. decoding da->flags in ndr_decode_dos_attr(), which will get carried
   over when writing the xattr back;
2. updating create_time only if XATTR_DOSINFO_CREATE_TIME is set or if
   da.create_time > 0 (to retain stored timestamps on files written by
   older ksmbd versions), falling back to filesystem btime when zero (in
   smb2_update_xattrs() and ksmbd_vfs_fill_dentry_attrs());
3. setting only XATTR_DOSINFO_ATTRIB and the requested attributes
   instead of injecting timestamps by setting da.flags = 0 on new xattrs
   (in fsctl_set_sparse(), __ksmbd_vfs_set_compression() and
   set_file_basic_info());
4. self-healing damaged xattrs by setting XATTR_DOSINFO_CREATE_TIME when
   rewriting an existing xattr that has da.create_time > 0 (in
   fsctl_set_sparse(), __ksmbd_vfs_set_compression() and
   set_file_basic_info()).

Finally, keep reading DOS attributes unconditionally to match the
behaviour in Samba.

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
v3 changes (based on v2 feedback):
- keep DOS attribute reading unconditional to match Samba's behavior;
- add backwards-compatibility fallback (da.create_time > 0) to preserve
  creation times on files modified by older ksmbd writers;
- restore XATTR_DOSINFO_CREATE_TIME on write when rewriting an existing
  xattr with da.create_time > 0 to self-heal damaged xattrs;
- remove itime validity checks;
- split xattr version 3 field decoding out into a separate patch [2/2]
  as IMO they were out of place here.

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


 fs/smb/server/ndr.c     |  2 +-
 fs/smb/server/smb2pdu.c | 43 +++++++++++++++++++++++++++++++----------
 fs/smb/server/vfs.c     | 21 +++++++++++++++-----
 3 files changed, 50 insertions(+), 16 deletions(-)

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
index 9ef2d086fc4e..63dfbffbb575 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3874,7 +3874,13 @@ static void smb2_update_xattrs(struct ksmbd_tree_connect *tcon,
 	if (rc > 0) {
 		if (store_dos_attrs) {
 			fp->f_ci->m_fattr = cpu_to_le32(da.attr);
-			fp->create_time = da.create_time;
+			/*
+			 * Older ksmbd writers cleared XATTR_DOSINFO_CREATE_TIME on sparse
+			 * or compression updates. Fall back to using a non-zero stored time
+			 * for backwards compatibility.
+			 */
+			if ((da.flags & XATTR_DOSINFO_CREATE_TIME) || da.create_time > 0)
+				fp->create_time = da.create_time;
 			fp->itime = da.itime;
 		} else {
 			fp->f_ci->m_fattr &=
@@ -9050,12 +9056,24 @@ static int set_file_basic_info(struct ksmbd_file *fp,
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
+		} else if (da.create_time > 0) {
+			da.flags |= XATTR_DOSINFO_CREATE_TIME;
+		}
 		da.attr = le32_to_cpu(fp->f_ci->m_fattr);
-		da.flags = XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
-			XATTR_DOSINFO_ITIME;
+		da.flags |= XATTR_DOSINFO_ATTRIB;
 
 		rc = ksmbd_vfs_set_dos_attrib_xattr(idmap, &filp->f_path, &da,
 				false);
@@ -11892,10 +11910,15 @@ static inline int fsctl_set_sparse(struct ksmbd_work *work, u64 id,
 						     fp->filp->f_path.dentry, &da);
 		if (ret <= 0) {
 			da.version = 4;
-			da.itime = fp->itime;
-			da.create_time = fp->create_time;
-			da.flags = XATTR_DOSINFO_CREATE_TIME |
-				XATTR_DOSINFO_ITIME;
+			da.flags = 0;
+		} else {
+			/*
+			 * Heal the xattr damaged by older ksmbd writers which
+			 * wrongly cleared XATTR_DOSINFO_CREATE_TIME on sparse
+			 * updates.
+			 */
+			if (da.create_time > 0)
+				da.flags |= XATTR_DOSINFO_CREATE_TIME;
 		}
 
 		da.attr = le32_to_cpu(fp->f_ci->m_fattr);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 09dad151360c..da13f13f8980 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1936,7 +1936,13 @@ int ksmbd_vfs_fill_dentry_attrs(struct ksmbd_work *work,
 		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, dentry, &da);
 		if (rc > 0) {
 			ksmbd_kstat->file_attributes = cpu_to_le32(da.attr);
-			ksmbd_kstat->create_time = da.create_time;
+			/*
+			 * Older ksmbd writers cleared XATTR_DOSINFO_CREATE_TIME on sparse
+			 * or compression updates. Fall back to using a non-zero stored time
+			 * for backwards compatibility.
+			 */
+			if ((da.flags & XATTR_DOSINFO_CREATE_TIME) || da.create_time > 0)
+				ksmbd_kstat->create_time = da.create_time;
 		} else {
 			ksmbd_debug(VFS, "fail to load dos attribute.\n");
 		}
@@ -2481,10 +2487,15 @@ static int __ksmbd_vfs_set_compression(struct ksmbd_work *work,
 		rc = ksmbd_vfs_get_dos_attrib_xattr(idmap, dentry, &da);
 		if (rc <= 0) {
 			da.version = 4;
-			da.itime = fp->itime;
-			da.create_time = fp->create_time;
-			da.flags = XATTR_DOSINFO_CREATE_TIME |
-				XATTR_DOSINFO_ITIME;
+			da.flags = 0;
+		} else {
+			/*
+			 * Heal the xattr damaged by older ksmbd writers which
+			 * wrongly cleared XATTR_DOSINFO_CREATE_TIME on compression
+			 * updates.
+			 */
+			if (da.create_time > 0)
+				da.flags |= XATTR_DOSINFO_CREATE_TIME;
 		}
 
 		da.attr = le32_to_cpu(fp->f_ci->m_fattr);

base-commit: 3bc1fb9c3b20cd478c83496ab16addecb401770d
prerequisite-patch-id: 049ae0eba275b5be35a238833107e0b251a55aa2
-- 
2.56.0

