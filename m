Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794482212;
	b=ob4Pwc3bZDFgnGlZnoDvVVxXjpHtLXo46NJa6kqIsgEjhNtnVJF3+JdADSAtJFqJvs8W
	 eMS1mYWdsogDdrFJfSTf3oRKYsNo+GcY82qlOryoi8SMGnbKy1sjQcMSV3qoT4bb08Eoh
	 ojcBxmfz6wK6lqmn+uIhTP/kBg2IcWxjm0E9fmXMkbJSiYQFE7aP3Ue/YFKgzNNIj1qce
	 xagbdtP3gby400EqquN21mafUPeG2IDCJab78Nfe21IDN+APe7JUlNY68lKInJfkRCfF4
	 +U3ku5USEfJmj/0e1eufwiLwvdSaIIURyyiTjg0uXRz8xxOqt/ro5Dwy07FemD8Hpew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794482212;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LzgHZsF/GUPFeF0jr1Q/JcuDmVc0PSDFgb7N6enWNZo=;
	b=GHCRAXvMt9/YbodcLLSD6LFSefRsv5II4yCAciV8S2O6Gyf3Xvgwp7zxvol8IBd8T6Cd
	 rvkCHPUjXHsRlcvpfqKL7Wu+SncJZv1D+7AUgyx74pc77yEBf2JBu43HXpt6klDlH3ssO
	 6mM//dss8xXI00AOIHB7t6sA3DOdRO4y4GIsD6ks21QXdNikbD5dp0SgDbzgM1nnB21MI
	 97mudtMeMJiR8YjVf6UJcHUOoKM8V6AKJQwJvUcAUTcVyMFVQRY7E/CX2ZDogGgsFGPQd
	 aVSYdcNhw7v45f+ePta71Mkb7IOkpXAHUhwfqXg+f7P60TVk0lx+ySdTVHeCnE0D8Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CHQomRVw;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB43606A321
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 11:16:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFB43606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CHQomRVw
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4b7252a32c8so44762785e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 03:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794482209; x=1795087009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LzgHZsF/GUPFeF0jr1Q/JcuDmVc0PSDFgb7N6enWNZo=;
        b=CHQomRVwCSPYaH/BkKwRL3qf+wWr/OEG0tXSF1x6DN2/QdB9qC1uiaehRQvGsg4lXV
         9/j04JVSUD+gsFAoIEsuvMXIdP/vDGuqDlHr5K54kcxr4AOhJU9wbLV5zMDrBcNeQzuR
         3XDTqXaBBOOdjNzCdp7P/PbyMCbawYOt5ADJkfxH1ZqQu9MpmzQgE2QSvqWnQamKxmLZ
         toDY/jycducA0YdDTex9f2Mo/dAteNB73flbr+gBk/OPA+PI3kloLCks+A1wJyMB9TEk
         aPg4EhiOcoU++hg4otgXxDKxYs+Hkb+BZrEdJeX9okLKeLemDn0dRzObnDWGinzfFrfv
         ABuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794482209; x=1795087009;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LzgHZsF/GUPFeF0jr1Q/JcuDmVc0PSDFgb7N6enWNZo=;
        b=zG63e0EJU5zm3POGCZe22QjDpzUDBXcnkwWw1alFdfj7f5V9FW+Pdr3a6FtqVNmzQt
         NtLcsvdL7ql4/Gtl6VpPbGa6RlQDU81WYJXoF6m5VjVC/yBOklS71qrr3zClMNPIaC4Q
         kWXG9Dq7WgLNERKHDx75oV6ogxfXjhL7kYK8+7+qLsIw6EKEkPG7PGp3Zn0wdAXAgbLT
         68OQj0mjcXQr5tXqvcVNBoKy4e7lwP8EJSvbtbKx0jrUEAUFn+ZBrjJKD9k3L0s596w3
         9rvSVvVulIZOPb25AANgkprm4+r+enSnV/0TCHmgyY70T8o6GSHtbcG6i4I9HxjhU/VN
         MDwQ==
X-Forwarded-Encrypted: i=1; AL+hErEuPZBY6t+j4lANeU7H7DxR4FLL56vY+aCerHP3U+1Is9aOjhQGGjlDY6qkW9fFCvw9YywvI/flF7jp@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZMd7OhtY2VFf3jgTs/y71c29p7qoWkdRIsWM/AuigEunoAy25
	c2tA7P1XAnARRfHCx7onE92YUR/J55K+QJtdPmUhFg4z1ZHrBNpclxGV
X-Gm-Gg: AYBFou2+HsXFB9QhDPC9LkiHJpFF+S/Ur5fk8NNRMPwWoj8Wp64NrGY+tF2XN8Lsh2H
	iW+ENQp2eY8jwmcbS0WQ1P3ZN8ISPkkb34miuohQ/nSqe3/7GWhdMjXqlGHS9xRLLMXB4ROyct+
	6lr5D8CYOBePIsTwClETJzTk0r5MByI6UxOfb59f7RuJoBXFxUb4K2WA4atojlecY2k9mHN27zt
	880vCXVAKfxvxs9uxmtqLVPbadtvGCA73x5XCTTB6Mx6YUuY3ApQFtieSdPnFCa8PtdKXXgepJV
	+818Cck1MPGrs2SWUDxCWoQ31WBkN46SHvjoU/iv1GBu2f3E1TOSQpqrQtG/K8eU7TWMHZeO8xo
	RUyNtMCeEsJNlFzRKgqPF3aSWlMFv+jPn4qZzdKxthP1F5qeUfWxz6v7x/NjQkXrIEPhD42UZzg
	VePmvYJZ6lJNCV8raSmhMAD/++FvCkC3kTNaTaCxeZ2Z3vCf7NOgl/9yHubjkOxcOq5q5llGxKp
	BKfGseiQVqztIXYRX3j7iX/f1pj1ZJ8ds0sm8hOL9Gi9dBu+U0aRLVW8N7CmTpdq61X0u01A5Le
	knGeteTNFtKMW6/xWXNt0t3pkg==
X-Received: by 2002:a05:600c:6994:b0:4a2:150f:1609 with SMTP id 5b1f17b1804b1-4ba09364b87mr99533965e9.8.1794482209235;
        Thu, 12 Nov 2026 03:16:49 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e267dcdsm59120225e9.11.2026.11.12.03.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 03:16:48 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: fix negative timestamps being saved to disk
Date: Thu, 12 Nov 2026 12:16:36 +0100
Message-ID: <20261112111637.184045-1-koray.fra@gmail.com>
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

When setting a timestamp before epoch 0, ksmbd converts it from NT
format to Unix format without normalizing it, leading to the nanoseconds
field to be saved (on-disk too) as a negative number, which leads to a
garbled stat command output and a reported +4 seconds in the timestamp.

This bug also violates a struct timespec64 invariant, as documented in
the set_normalized_timespec64() kernel-doc:
[...]
 * Note: The tv_nsec part is always in the range of 0 <= tv_nsec < NSEC_PER_SEC.
 * For negative values only the tv_sec field is negative !
 */

Reproducer, with /tmp as the local filesystem folder exported as [test]
in ksmbd.conf and /mnt as the smb folder mounted with mount -t cifs:

  mount -t cifs //127.0.0.1/test /mnt -o username=user,password=pass
  touch /mnt/test.txt
  touch -d "1969-07-20 20:17:40.123456789" /mnt/test.txt
  stat -c "Server local (/tmp):   %y" /tmp/test.txt
  stat -c "CIFS client  (/mnt):   %y" /mnt/test.txt --cached=never
  smbclient //127.0.0.1/test -U user%pass -c "allinfo test.txt"

which prints (stat output is garbled because of negative value):

  Server local (/tmp):   1969-07-20 20:17:41.()*+,--00 +0000
  CIFS client  (/mnt):   1969-07-20 20:17:45.+(/+)*/00 +0000
  altname: TESTT~K6.TXT
  [...]
  access_time:    Sun Jul 20 20:17:44 1969 UTC
  write_time:     Sun Jul 20 20:17:44 1969 UTC
  [...]

Fix this by using set_normalized_timespec64() in ksmbd_NTtimeToUnix().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.3
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
Yet another small fix I found while implementing ptime[1].
(Still not the last one :c)

Thanks.

[1]: https://lore.kernel.org/all/20261101015551.786044-1-koray.fra@gmail.com/T/#t

 fs/smb/server/misc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index 5037f37c9226..94781246b4d6 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -336,8 +336,7 @@ struct timespec64 ksmbd_NTtimeToUnix(__le64 ntutc)
 	if (t < 0) {
 		abs_t = -t;
 		ts.tv_nsec = do_div(abs_t, 10000000) * 100;
-		ts.tv_nsec = -ts.tv_nsec;
-		ts.tv_sec = -abs_t;
+		set_normalized_timespec64(&ts, -abs_t, -ts.tv_nsec);
 	} else {
 		abs_t = t;
 		ts.tv_nsec = do_div(abs_t, 10000000) * 100;

base-commit: f4692d0e3b5e16d32d4ec7b1e0e58d7dbe74aaf4
-- 
2.56.0

