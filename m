Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900564;
	b=d4O0ckaMwGh8l6Vu8BXbHnDQzL2oexk/nEqLXcJQUx5JuInm9cOnqgV1ZoHUcZOLqC7D
	 W8LlHQF0HyI39lnMaZ0IiKeyInsz3bKKT+cai3QP2qyLVU6elXEg3P5XvxueZzzZYjqsh
	 6fWlt1yS/admaWknkZKtIvMCiKecHTdr9hEDGOhXyyMl38ghxbrq/OYarfVvpAdVygSA8
	 IO+xWjZXFnqARWxmeYEWKx87f6hA3dsdkE4KqdkXi23adAgYELAPz6hZVk9Ijo/XrjXBG
	 gfY2ozMxlQlliFKn0B91UvqMqQwC5G0kbfEuTfo8g67X+rsZ/RSiqC0PJT5mCvNvK5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900564;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lkKAejhpVXm9seL1ehybdpNol6UMeDxsIrY79fbHsys=;
	b=S4WcIE9p07Q9f/JdThwaBtz4bVi0CQnSjxV7csdzufBGErh/XkdyodYu9k3NdKWTwADt
	 E981kh9AcDwDeJAw/2aB1XWT7iXrYlLis23wIRaL9HYz5ZF8UhqvMOqlzX15yS0ohOwi+
	 EJLrc28mm2Wjo3NEvzHQGpqohOsexj/j0N14ualOHV0xiM2lBLcAh7K0j0oDU1K9rMb/X
	 UH0WsuTBXxjLreDlxhWEUvk1kt6aCpygkwWO23GFEwpxeuZGylw/9vhZYoQJkp9ZKGDeK
	 QF3AA9095nubkjpIi67jwAp4ZXAxCZa5Pxg64PPm9UfC74VdUbQYFHX4VhI4zvDCioQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0cCpBXcz;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD326606A326
	for <linux-cifs@vger.kernel.org>; Thu,  5 Nov 2026 17:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD326606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0cCpBXcz
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-14394530ec6so2984117c88.1
        for <linux-cifs@vger.kernel.org>; Thu, 05 Nov 2026 09:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793900563; x=1794505363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lkKAejhpVXm9seL1ehybdpNol6UMeDxsIrY79fbHsys=;
        b=0cCpBXczFYatbN465cchPeAyHME4783rqVh3+kL78PzF4IlkhKFBfE5QUc6pCUThe+
         p4WXpGfbMQ8mn8FpHx7MMTutgqAqvxPCVDJo9FwfTet0dJOYWpVxzkZX/UPxIsoCMuaW
         7zUEND9WP7c+PNDLfyL0V5Zr8Va+nAaPgI5xke5C5zjT6zZmNZ5141TVUikpJlNXh+tm
         e+A6AxIrh++VB6UJ2mgMHkfQUHhO4qPFtKv5ynToDcG+gYHr52aihGwah8BvrO40fgiz
         Krhff2dntNB/rAgijFx/fP1Zdw0haDcXxuF/yP6Od5kjUsLelS/3tyPYexfEotJ7bIe9
         KHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793900563; x=1794505363;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lkKAejhpVXm9seL1ehybdpNol6UMeDxsIrY79fbHsys=;
        b=eREV/kZSOhbrMLLkBz74ygHcm+TvMrnWME3hjBdiZa6lRmm2hKljpBNyGi+Sr4tyBW
         oSE3DHOdB7n5LvCn406bx+LShEsYnRFLpjVYjKlwe7lZ7l0gZde5yYDJ9RJNnUYAM8eK
         q5mc1N5CAMYYYDbHIWgQuwA6EugKmNfdG/85xn5Y4MeQp08/0DKcqXY/FtWnl00BJWxN
         Nv1NPbO2yy/H9nsAG/juLDkENHhb4Lqma0i3CCUhhKFYNSxQfiQRrVxmS8TtUK6RlLta
         DslUd9geTroT+fj9zPV4Niey1fIVOrME5MnVGqvbgzlWJn59Dh61TemgNtVdT6ByOHje
         JdEw==
X-Forwarded-Encrypted: i=1; AKwUvBz0SiVjJuMq1R8tr/2oZmCpvpFC8n2mlJ71ZqxezObOhzmNhx9deZSJtavSMD6gC/uKOSNbpNa0WGRg@vger.kernel.org
X-Gm-Message-State: APuU4Z/Aq4I8Z3F2BXSlTfN45ZacvY50hHKTf8N7RUwSSwhgm8Yo4VCH
	LVG0iXZlrMu1fQNset3lPQ08TyUQFvCyqrr5tXSphQYsHgiQ2VutVdTE
X-Gm-Gg: AYBFou1HvTAZmocj7LGxCSs5I3j2SynKDeUm/ME3usA9x8057qjeq4PQYHLvOH4u32u
	oWQsTpmDDvKdpzFZy9uT7S1MMBfPGH15SKIFn0p5oYv/pLaVJA3pIyKdb1HBVD7ykdBV6gvmQ54
	zohDIOs/i9QMNwfrXw3q0lfWlyBt0NME/AKnv/Ispc/3JfOzRgqvZPjUzqUI0OlSP3VZCsqL2ec
	jDGhgaS3rGZVTL2OWBFZs0W2ICIAi4148RbTU9vKSGogQZGt++yL0RH5GgwGJoIWvs6hnwWoB6M
	r8YBEDS4aHtavxqk4cdQE3FBuCOQOWPhxaGkrE3OXvrLCe5kvezHJWLJwphlSs+AUCdWB5uJmB/
	md3gmJEJ6QjWnSGmJ0y+6loss5VnSTh1qAUca+fU4GuYTaSTvXM7tBZ2SIJi6lI2XUHklHTcxl3
	spcDLEb5zhOgiTAlWlL1jEvXkmrnjio435MiWeUuyrIp1bNYpIn9k+zY91b2xUJAojFl267D/jL
	h/pba6luvv5urkxga3z345CHzORTSELp8D9rGgRGRR0sWjJocHDLyN87mZ+v42/AJ2Rkmp6e3dt
	4713pj61d5bDBvXdFCLo6BJ4NvMLBQLZoVOFEYUwGXCLUZu48bnv8zCXcURgk68XOA==
X-Received: by 2002:a05:701b:4550:10b0:1b2:4da6:bccd with SMTP id a92af1059eb24-1b24da6bf63mr5381543c88.34.1793900562754;
        Thu, 05 Nov 2026 09:42:42 -0800 (PST)
Received: from anon-laptop ([103.187.196.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca39b8eb3sm24291014eec.27.2026.11.05.09.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 09:42:41 -0800 (PST)
From: Wahid Khan <wahidzk0091@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wahid Khan <wahidzk0091@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: refuse to read a handle that is not open for reading
Date: Thu,  5 Nov 2026 23:08:38 +0530
Message-ID: <20261105173838.1882328-1-wahidzk0091@gmail.com>
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

smb2_create_open_flags() picks the open mode from the read and write
bits of the desired access. FILE_EXECUTE and FILE_READ_ATTRIBUTES select
neither, so a request for FILE_WRITE_DATA | FILE_EXECUTE |
FILE_READ_ATTRIBUTES opens the file O_WRONLY.

smb2_read() accepts FILE_READ_ATTRIBUTES and ksmbd_vfs_read() accepts
FILE_EXECUTE, so a later READ on that handle passes both checks and
reaches __kernel_read() on a file that has no FMODE_READ:

  WARNING: fs/read_write.c:518 at __kernel_read
   __kernel_read
   ksmbd_vfs_read
   smb2_read
   handle_ksmbd_work

Any client that can open a file with write access on a share, including
a guest session, can trigger it; with panic_on_warn it takes the machine
down.

Return STATUS_ACCESS_DENIED when the file is not readable.

Fixes: f44158485826 ("cifsd: add file operations")
Cc: stable@vger.kernel.org
Signed-off-by: Wahid Khan <wahidzk0091@gmail.com>
---
 fs/smb/server/vfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 1f2bc76f0..cb3f4f5fe 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -367,6 +367,10 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 	if (ksmbd_stream_fd(fp))
 		return ksmbd_vfs_stream_read(fp, rbuf, pos, count);
 
+	/* The access granted on open can include FILE_EXECUTE for a write-only file */
+	if (!(filp->f_mode & FMODE_READ))
+		return -EACCES;
+
 	if (!fp->is_posix_ctxt) {
 		int ret;
 
-- 
2.53.0
