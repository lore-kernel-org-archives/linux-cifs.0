Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011662AE6D
	for <linux-cifs@vger.kernel.org>; Thu, 10 Jul 2025 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752166394; cv=none; b=f5ddjqxpjLFG+/i+S4vGIsd0vjLsjqXRei6r+FmrIZ+j/BncpqJMzebmq4d0NaIUHdI6IXt6El9yDw7dvfOpBF0qDm/bSrGZtuED22S0+qydv5VIsTfISv+fbCvpzHDYuaNNrBmdZQ8uys/VomGtw830bqtfErYEel+2sl/a3Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752166394; c=relaxed/simple;
	bh=z4Wq8TqyeIjjgk+V/Gm4DspBzsLgkVjkd8sZF5ysnNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hw/f2IZ2HU+eRhsVOwNz1gqPa7MrIrjZmYBdwXGrlhI0IzfsZD7UPHj1Q0Xg8Kzgvn5uZkBvJhnZqHxIVDdApKvDzx0JycEd1Fs6Gv2eipfiwckkp6wlzlDTN4hUKB4bQcvPqHMMN5QAjj3+nildf82pcf7hiWaqgdm8Is7dRkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BysCcMAO; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BysCcMAO"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3a4f379662cso1191518f8f.0
        for <linux-cifs@vger.kernel.org>; Thu, 10 Jul 2025 09:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1752166390; x=1752771190; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8Q1IK3GqKF8NVWixUC1jFkt7PBtdZyjJHmShjCXxIzw=;
        b=BysCcMAOKMpMRDVCns2GhQYaLNO8M8KXsi67VbnAYGRPAiXcSjsaDG+sEjcak98sFF
         kiZkPrsPqvoRwmdVWWUT3agwLp6+Uy2lQt6XT04JiX3a31XvyvBgX7WMcduzLVB061he
         p8dqMgNCr5oDnly3NQrNDdf5wMFlSgIZwKb1GX+ipsygSBhnLSseMOtx62bmVl8X+4NS
         jL143QmGsCBXnAnjVGZ4XIc+iqPw72wNkHeXfnLhDy68slI9jr+DOOPt/IxLVC57UD5a
         RbNDGIoQiGMbe8lRkXQCcfyw834Fd90ZK2P0TxOKKMoeaZMTOza2WHQV9WVDOeFQoLgC
         c0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752166390; x=1752771190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Q1IK3GqKF8NVWixUC1jFkt7PBtdZyjJHmShjCXxIzw=;
        b=SjlhL6Hat6FJJnondc/V4+MCbvV+2geGopT3Q71fGHFkG59XLzrrdJbCjbtu0L5EqW
         +ihu1cYhYUnSBnJC5grxx11PIsx70jDwWuowe+q2fTxXl3N6h7iDc/Fd1tQUCVnoEQ6i
         7gHShjSi1lRF6hDyHK0i/gP45H5e1BycoHjBFOo6GBcJHkKR24mBQOVO+twIj44zAVJe
         t+Cp+AB26ncVDfs2oKfQOmF0pWC2Veg57ykCNpn0QKqKuuuNTy2Cfw5nLqheLvi589lU
         pybznusAwDxpvi6UlYi5Yhr3Ja2DgulEjEYHGGIi3rp/1jG99kIOIy46eWVreQVWtFM7
         gLaQ==
X-Gm-Message-State: AOJu0Yxe21ajcC6H5JeRFgDjgUYXIv1bbOUL7WhDZ3Ui5+rRYXGHF7t/
	idqUSFSLUhqgLDkViWMAJ/HgcdGEi7gSGhJXgk5RG15+rPiZiBIUMUoiLIBsaKE7xYY=
X-Gm-Gg: ASbGncueM3lcdFwy8uh/vZy3rqCwSmsML2VX2XeG6SUA3wuT0G8daPvvPY87b4QRbQF
	pQv+TLNLWn0DMkuIHsw7Q1UBnh9be+B7iQAVBkrNwXM22E7IVTbA7S0NmX1nWEzZCOQGypKVRCO
	XWExvIe+ONWqu0JM+dK1SakLzSo2EmfSw+Dw3q5ZXQsuSG+QgGY1vtrgLmrp4weu+90il5MIdTp
	A37mJpZ0ET1Om4gdHlvfcK/TJvW4hvhZW6zC4rxbdrlhLoi3KT3t+Ts+XN/d5ZzEQ/XDjDbl53f
	NgDCWB7P+IJX6yJKnsVgsZtE/Js4HAGMvdiKCAZNIoifwBNpSqwM3Kx1R1y2XUcrA6T//Ksdd1n
	8E5ZjIyfRljc=
X-Google-Smtp-Source: AGHT+IGrdz31l8ytEw4slUi213DBNuveM59F6Vrt68zhWC15A/FqHaYihvruZySsSw86Xhh/El72Ng==
X-Received: by 2002:a05:6000:220e:b0:3a1:fa6c:4735 with SMTP id ffacd0b85a97d-3b5f1891105mr288332f8f.35.1752166390078;
        Thu, 10 Jul 2025 09:53:10 -0700 (PDT)
Received: from localhost.localdomain ([2804:7f0:bc00:fc9b:1aa7:f529:d2f7:747d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9f1b54bsm2852250b3a.90.2025.07.10.09.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 09:53:09 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: stable@vger.kernel.org,
	smfrench@gmail.com,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Laura Kerner <laura.kerner@ichaus.de>
Subject: [PATCH 6.6.y] smb: client: support kvec iterators in async read path
Date: Thu, 10 Jul 2025 13:50:40 -0300
Message-ID: <20250710165040.3525304-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 3ee1a1fc39819906f04d6c62c180e760cd3a689d upstream.

Add cifs_limit_kvec_subset() and select the appropriate limiter in
cifs_send_async_read() to handle kvec iterators in async read path,
fixing the EIO bug when running executables in cifs shares mounted
with nolease.

This patch -- or equivalent patch, does not exist upstream, as the
upstream code has suffered considerable API changes. The affected path
is currently handled by netfs lib and located under netfs/direct_read.c.

Reproducer:

$ mount.cifs //server/share /mnt -o nolease
$ cat - > /mnt/test.sh <<EOL
echo hallo
EOL
$ chmod +x /mnt/test.sh
$ /mnt/test.sh
bash: /mnt/test.sh: /bin/bash: Defekter Interpreter: Eingabe-/Ausgabefehler
$ rm -f /mnt/test.sh

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Reported-by: Laura Kerner <laura.kerner@ichaus.de>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1245449
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/file.c | 46 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index d883ed75022c..4878c74bae6f 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3527,6 +3527,42 @@ static size_t cifs_limit_bvec_subset(const struct iov_iter *iter, size_t max_siz
 	return span;
 }
 
+static size_t cifs_limit_kvec_subset(const struct iov_iter *iter, size_t max_size,
+				     size_t max_segs, unsigned int *_nsegs)
+{
+	const struct kvec *kvecs = iter->kvec;
+	unsigned int nkv = iter->nr_segs, ix = 0, nsegs = 0;
+	size_t len, span = 0, n = iter->count;
+	size_t skip = iter->iov_offset;
+
+	if (WARN_ON(!iov_iter_is_kvec(iter)) || n == 0)
+		return 0;
+
+	while (n && ix < nkv && skip) {
+		len = kvecs[ix].iov_len;
+		if (skip < len)
+			break;
+		skip -= len;
+		n -= len;
+		ix++;
+	}
+
+	while (n && ix < nkv) {
+		len = min3(n, kvecs[ix].iov_len - skip, max_size);
+		span += len;
+		max_size -= len;
+		nsegs++;
+		ix++;
+		if (max_size == 0 || nsegs >= max_segs)
+			break;
+		skip = 0;
+		n -= len;
+	}
+
+	*_nsegs = nsegs;
+	return span;
+}
+
 static int
 cifs_write_from_iter(loff_t fpos, size_t len, struct iov_iter *from,
 		     struct cifsFileInfo *open_file,
@@ -4079,6 +4115,13 @@ cifs_send_async_read(loff_t fpos, size_t len, struct cifsFileInfo *open_file,
 	int rc;
 	pid_t pid;
 	struct TCP_Server_Info *server;
+	size_t (*limit_iov_subset)(const struct iov_iter *iter, size_t max_size,
+				   size_t max_segs, unsigned int *_nsegs);
+
+	if (iov_iter_is_kvec(&ctx->iter))
+		limit_iov_subset = cifs_limit_kvec_subset;
+	else
+		limit_iov_subset = cifs_limit_bvec_subset;
 
 	server = cifs_pick_channel(tlink_tcon(open_file->tlink)->ses);
 
@@ -4113,8 +4156,7 @@ cifs_send_async_read(loff_t fpos, size_t len, struct cifsFileInfo *open_file,
 
 		max_len = min_t(size_t, len, rsize);
 
-		cur_len = cifs_limit_bvec_subset(&ctx->iter, max_len,
-						 max_segs, &nsegs);
+		cur_len = limit_iov_subset(&ctx->iter, max_len, max_segs, &nsegs);
 		cifs_dbg(FYI, "read-to-iter len=%zx/%zx nsegs=%u/%lu/%u\n",
 			 cur_len, max_len, nsegs, ctx->iter.nr_segs, max_segs);
 		if (cur_len == 0) {
-- 
2.47.0

