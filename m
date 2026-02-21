Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9C519B5A7
	for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 15:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771686045; cv=none; b=EMfl+4eZGYPLcd692vG5kFxh5BoNrpKo7Pf2WTrHtTynBCFdEAXmKIxseIo5Fp/mzQcZuLbjoTcwS+pE52+fcDOofHd5f6Gu6PaMw3XPG+ydOwSIopiBG62BY7ycx/9KO9FYvo5B6Z90+ntFkNohCY+yyG9zLbWUZ+HnUHVBqcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771686045; c=relaxed/simple;
	bh=EKC+gjybz5QCo3/A2SoLkAdJ9dHzP8glwvLLU31BmCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRXJopGRJk7n5o66hmYWXUmOcQkJ72qQyw1oQKj1k8EmJRJO27IJe26L95Q6JcbsZ5unP44xyYU8WV+UWVrARyGJ0VFt728VaeCPvLOOAo8uKEeuUro+QYMmgQozkqsOj5ABhFPkDzqugqAG0WvN0qNX6if/Yl8PdvnXeSaS3bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kk2tUUGw; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kk2tUUGw"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aaf9191da3so18705815ad.2
        for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 07:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771686042; x=1772290842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cE+gTqS6Acm3OjdFoCwcpAog50aFpqNiNU85af164dY=;
        b=Kk2tUUGwvD9uGvq0ltLEbkA6gi0NU9z4MP00tht7MoU2o6bKhEQ6dueKkPeMGPqu3T
         r+i2gbnfgZqBNGm9kfrCE7+uSZaWCNdYObcf3IJCxMQxdP8lSS640twG57Zp/TxJBeCH
         eKkXO17an2qluj9ez+oUTd/Mjhb0d5rImThkDbDzR/Zh2No26sF43Q7+08D7P7ZgelBW
         ac9A19JzfVstuTVnX1ktYq+qhw9iN5VSre+latY9KomlTbH81/2Sw0Il9oIKwc5VdSJ3
         cykMuY6M7c07+TCRFacC4SoRR3WRJCkXs+Tao3xNxLET/B8qr42QlE2DCWV09ZTsAoLd
         g+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771686042; x=1772290842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cE+gTqS6Acm3OjdFoCwcpAog50aFpqNiNU85af164dY=;
        b=Jx+LU0BUrxWHkanTxJtK3iZJZa6LjYhXxF00yx+HsxHdIH+20mLNq1bMN/H/DmjSRM
         W9Emb2sXRty7F5BKBZ/LVQONeO6JVriM47bFoD3xSB5vaLzmBBVQbEXbJUAU55N6D+cb
         /xqbgXn8Mnr8GfR5yZpL9Ag83pHqBds6i3K/qBV4WYzAf5duxDKdt111ccPvUsfdciud
         yPaIRnUBal0jjJ8QvZqNMnB0GHTzMwS9cDFUKEVhV7qfj8vwessy28xDdoFamrNDqbNe
         WugSqlkLg2ms7BE+FCr2RS80+rZW7ToYf+rxCBF/2h6R//m9/sPwg8dsfVkeljnCvX8A
         QJ1g==
X-Forwarded-Encrypted: i=1; AJvYcCXqwnyY6TI3LcU0m9d0yQXn2tDayfzKLb6mAFQ/RBUqHtsg12Zbm1L9rRjM2+cpW9UvW3XzYGQM0WGb@vger.kernel.org
X-Gm-Message-State: AOJu0Yzkkn9si3AO68dcVPnaDrM/XWba5yg5nfZiwU3XLlKlzOAmqVd4
	rFfsmavkHRzqCspZtuB5+OmoNX1m0V/ZGqVXOZk4kBjq7zD58lfrVmmL
X-Gm-Gg: AZuq6aIFz1GDyvTpx34mEdjL0Kj8P49rwi31vrLoz73oy+nf+nTbYIpx3M9ev9wy02w
	weMwW7Y0FNR0fPZO06ZPMahlg8w+eBpRnnEgJ4NwI3dH+OQVkv97tv7ok3rC+sSdSGuZ0Mybook
	QXuqfNx9TZQXOGvmuo1M+fn1R6YCf/4J5QeXgHhwSGCeHnZyGLBeES9vUOWaTxZaGpclwa18pSC
	Mbig6QQ3eHFbPd7Hwkvw/UZnaztHIodGelkO2rWKVpPSG5RCCzWpHQuvRehoww46Zck9tbUhW11
	VfpbuC8Psb0rVbpxbglCDwav6GZmkEIQzlScwtQJENkswpzr7poq81hpLRmCBKe9BGg/5oGsU99
	L1n517PKg6wq6JGewf6XciEgJ4DdtUJrYnUOCLJG2mV/lquQEQAf2zW2o7H4ed4zoaSpgwTA+S5
	Fu4+k9S0yy/ZR6VpJsdPRouHwtM4LFLe6XpbXzZgeP8eQxSxp8hMal0l8=
X-Received: by 2002:a17:902:ce90:b0:2a9:5b28:94c0 with SMTP id d9443c01a7336-2ad744e13bemr26077275ad.27.1771686041931;
        Sat, 21 Feb 2026 07:00:41 -0800 (PST)
Received: from toolbx ([103.230.182.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f4a4sm23730205ad.79.2026.02.21.07.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 07:00:41 -0800 (PST)
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	jlayton@kernel.org,
	chuck.lever@oracle.com,
	alex.aring@gmail.com,
	arnd@arndb.de,
	adilger@dilger.ca,
	mjguzik@gmail.com,
	smfrench@gmail.com,
	richard.henderson@linaro.org,
	mattst88@gmail.com,
	linmag7@gmail.com,
	tsbogend@alpha.franken.de,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	davem@davemloft.net,
	andreas@gaisler.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	slava@dubeyko.com,
	agruenba@redhat.com,
	trondmy@kernel.org,
	anna@kernel.org,
	sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	shuah@kernel.org,
	miklos@szeredi.hu,
	hansg@kernel.org
Subject: [PATCH v4 4/4] mips/fcntl.h: convert O_* flag macros from hex to octal
Date: Sat, 21 Feb 2026 20:45:46 +0600
Message-ID: <20260221145915.81749-5-dorjoychy111@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260221145915.81749-1-dorjoychy111@gmail.com>
References: <20260221145915.81749-1-dorjoychy111@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following the convention in include/uapi/asm-generic/fcntl.h and other
architecture specific arch/*/include/uapi/asm/fcntl.h files.

Signed-off-by: Dorjoy Chowdhury <dorjoychy111@gmail.com>
---
 arch/mips/include/uapi/asm/fcntl.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/mips/include/uapi/asm/fcntl.h b/arch/mips/include/uapi/asm/fcntl.h
index 0369a38e3d4f..6aa3f49df17e 100644
--- a/arch/mips/include/uapi/asm/fcntl.h
+++ b/arch/mips/include/uapi/asm/fcntl.h
@@ -11,15 +11,15 @@
 
 #include <asm/sgidefs.h>
 
-#define O_APPEND	0x0008
-#define O_DSYNC		0x0010	/* used to be O_SYNC, see below */
-#define O_NONBLOCK	0x0080
-#define O_CREAT		0x0100	/* not fcntl */
-#define O_TRUNC		0x0200	/* not fcntl */
-#define O_EXCL		0x0400	/* not fcntl */
-#define O_NOCTTY	0x0800	/* not fcntl */
-#define FASYNC		0x1000	/* fcntl, for BSD compatibility */
-#define O_LARGEFILE	0x2000	/* allow large file opens */
+#define O_APPEND	0000010
+#define O_DSYNC		0000020	/* used to be O_SYNC, see below */
+#define O_NONBLOCK	0000200
+#define O_CREAT		0000400	/* not fcntl */
+#define O_TRUNC		0001000	/* not fcntl */
+#define O_EXCL		0002000	/* not fcntl */
+#define O_NOCTTY	0004000	/* not fcntl */
+#define FASYNC		0010000	/* fcntl, for BSD compatibility */
+#define O_LARGEFILE	0020000	/* allow large file opens */
 /*
  * Before Linux 2.6.33 only O_DSYNC semantics were implemented, but using
  * the O_SYNC flag.  We continue to use the existing numerical value
@@ -33,9 +33,9 @@
  *
  * Note: __O_SYNC must never be used directly.
  */
-#define __O_SYNC	0x4000
+#define __O_SYNC	0040000
 #define O_SYNC		(__O_SYNC|O_DSYNC)
-#define O_DIRECT	0x8000	/* direct disk access hint */
+#define O_DIRECT	0100000	/* direct disk access hint */
 
 #define F_GETLK		14
 #define F_SETLK		6
-- 
2.53.0

