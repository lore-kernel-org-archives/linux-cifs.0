Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794889433;
	b=ptdr7GBv4xc/AmAY1ix3IJwN+rBvfRce7+WJM8Iek/o5hd8gERh7Dn/sXkhTlxIlDdns
	 DaiGTUbuBgFzS9h50l4y//sc8AAGNBquEbQGvvN8TId0KcLjmKrvE0g84fQmSRLA7GROd
	 FX3crcqz0KgfPYVf5JQnHMfCc2EQQhLIW4Sv5xyni4m+y+kSZqIi7Oy6RBizJ+xXhXnZA
	 hP/i2/Qra60kMhygHxT3+I9n5jKv7JHrkVZyV9zry3nZ979pnusM4qXldVPdlIf1f28w3
	 IPug4pfAVtqwfcNt/NUVk/hepSDD7p2ufGVN/VJZsPG9kN7wov5nYcxj2FjZCPgF1Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794889433;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MJFJXL0qA7EgCzo1DXahTwcwkNU+5s7BLIy9HpDlOOY=;
	b=mUL7NKDlyyG3Ed4xZfk/Pwy+GCWtMtLCS1i0O5vVXw1EhXvF+cTQqZuRcdNZelClZ1/K
	 gTZuEN0sZxg6GFJIKbdmLvksL+CrRTvoQAGF6VAQzHuSfoehTS7+Dxxz9ETXda952HC2f
	 jSfmwvBAOq4D1w/StD3+Qoav5qKyWHMunx5f7Qzs61ynJzuHcpWadUB9s+/QzBzyUujdh
	 uQXYTkK90k8lXlHmBvt93aFgHsTm7Kp8KJ3wx/mnQpT1jd+MqZ1rUOIZi5yE/j8toLwG+
	 PqTTUASc/yFioH7xMbzxZ2jHh/RxnqLuoczNbRTN76+3XHaqLBYBqdIC1iMpHCZDYOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lBXCOm5p;
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E771606A331
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 04:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E771606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lBXCOm5p
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cd6acc50b8dso2064685a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 20:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794889432; x=1795494232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MJFJXL0qA7EgCzo1DXahTwcwkNU+5s7BLIy9HpDlOOY=;
        b=lBXCOm5pef64nqws0Ad4zRtr/Dzy8QWuZeXGQX7VDUF81eeF9+yeWLppPVAKQ8gmO3
         XVIQojYrU1z4+rTQV5vx4vmGcXwhtELC40Jq61sHsB5ZZnjy+DvL+T6rRnXTtd5tIY4I
         U1MF1QjzchHtOT/Xnnh03L4pQuPJASsNhKTyVR8UlfiTQycPzolKTP0lgV86RsqCfIBs
         ZGajV+uy4QBJmdMzqgafBs/8z6ts28HcRM4pr6pedLE9J858hqwlqZ7KlNgKzpV0mFgs
         s00MxfKcgya9ubqnXiPw2JQEjqxYZnlbp/AbpF9H0zvjmD9oIryIPCT8FwimLKFrtZSD
         hLog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794889432; x=1795494232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MJFJXL0qA7EgCzo1DXahTwcwkNU+5s7BLIy9HpDlOOY=;
        b=oJ5MDnLwtJoC9UT6gRHBZLtZ6vn9xtB/ZFrSeSTkUG8DHI1myU0K5sVl5kUl7Y6fqK
         w0HvSXP+B6MqvQRJ/4SFsfItx+onkVKMDVll9qoMDj0AuADa2v4oa1TS+QnZEd6uB6LV
         vh5tsDOUz/4VZKteDLeR460wDK2A36pf0uYIgq/ogsaS0m/X9FQNFZFM5siehLsnwjTq
         pmvIJlXs7uqwPICz1COlnEObOu9Vg3Frm/Q7ucgpAAWsnyKGPWKOLVPxl51Xumln2Yyt
         INrp16LK4G5scmsTZvw1dw4Z55gnmSPG0qtcrcdl8MOlrMjzE8iSlJZKtuCeq9mv3T0x
         E/IQ==
X-Forwarded-Encrypted: i=1; AL+hErHgGQS2/3t370+POJOxpNJFvQ2osL3GtuM1ZQTgSjZnKcxXmfCM0YXo+84Wgyv189dkKkAyRLzadbTv@vger.kernel.org
X-Gm-Message-State: APuU4Z+1GqFCQvJuwDI7gvv8EKna0v/4jYeqan8KURa8/JyczBBYGFvv
	EmWeg5znM4UWia72+zmj72zf2d7l/13gSNEIYmTPaNFs4vUCCMyTO3QA
X-Gm-Gg: AZFdTZduWzi64TQouhKiwlPx+EXw95biK1COUaU8OD9UnXthwwupH0ugqzi1AWg0h4v
	pbW4brwZD4Rl2E9KHEcq3Q5TF0b1KmpUlx66QqusPdC7lNS5DhSqDmQhJFSHvbYBP1pvkEnogrM
	LfcVBr+1fWNcmetcexxKsM2DfXFE/heif4bM3L6wG5hXKdiwJiWMR0bCwRl2/T06b76wSKgMWh9
	0nAAT6mX5GXwGSnPnLqSFUmfVG+vXLoLiAvmitreNcTcHyODgCMrfVYdQAFjvb3BVK8DVqzs5pi
	DWbk04dx1qU8clpMx7xkI4WrTVhq2etdRojj3ycGyjZconkEupQ/OGj82JbOa0zrtUe5XFzyGzm
	jaYw++lgK0aO6BsrrfveQj5bi+2DOoGvEuzCdcOcUFNjlm8XCQOMMt3AH2h7v9Jj0Lw8k5JXRTd
	3CyzItHW4/jG3PfSvFF3SQ1mM/jFVR2V8Ced4v6HM+zEsKhsL3YY2lHPhCIGvLKEANI/pDCV10Y
	KVDQNM14ME3KgtaKcpyqc/M5dsTGi9F+Oc7IXtB9U8MmBxR4nds5dyueoEiPr7WQogfefgDPleN
	Fh5fGZ8bQWodBOIuOd0NKlYgv0txWxu8A7ysdpuXLC2AxZ2n
X-Received: by 2002:a17:90b:1f86:b0:3ac:4e18:237c with SMTP id 98e67ed59e1d1-3b1b05b4590mr12347836a91.0.1794889432387;
        Mon, 16 Nov 2026 20:23:52 -0800 (PST)
Received: from hj.. ([163.239.22.29])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b39d73c9sm10484995a91.2.2026.11.16.20.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 20:23:51 -0800 (PST)
From: Hyunjung Ko <hj351016@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org,
	Hyunjung Ko <hj351016@gmail.com>
Subject: [PATCH] ksmbd: reject SMB2 read on a file opened without read access
Date: Tue, 17 Nov 2026 13:23:41 +0900
Message-ID: <20261117042341.4023597-1-hj351016@gmail.com>
X-Mailer: git-send-email 2.43.0
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

smb2_create_open_flags() maps a DesiredAccess that has FILE_EXECUTE but no
FILE_READ_DATA (e.g. FILE_EXECUTE | FILE_WRITE_DATA) to O_WRONLY, since
FILE_READ_DESIRED_ACCESS_LE does not include FILE_EXECUTE_LE. The resulting
file is opened without FMODE_READ, yet fp->daccess still carries
FILE_EXECUTE_LE.

ksmbd_vfs_read() only checks fp->daccess & (FILE_READ_DATA_LE |
FILE_EXECUTE_LE), so such a handle passes the access check and reaches
kernel_read(), which hits WARN_ON_ONCE(!(file->f_mode & FMODE_READ)) in
__kernel_read(). A remote client can therefore trigger a kernel warning (and
a crash under panic_on_warn) by opening a file for execute+write and issuing
a read.

Reject the read when the underlying file was not opened for reading.

Cc: stable@vger.kernel.org
Signed-off-by: Hyunjung Ko <hj351016@gmail.com>
---
 fs/smb/server/vfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 1f2bc76f0d09..cb3f4f5fe9cf 100644
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
2.43.0

