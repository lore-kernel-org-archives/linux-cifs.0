Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348CC38FA3
	for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771686030; cv=none; b=SXFdrVvb7l9BT9mRbP0kJkD8yN/M2Z3zSrN7oJ3OYhQvOgOaaBzSmzFEVi7efBwEb/HU3EHa8z/5Z5kMRxyF8ubMPMdHKOTNmWqgVCo5oKV7Wq8lBI6ytNRRvwdPmz/bEB+LVn7r08oIE4bJpoEw0wd0Z3F1wRU9u/bEB8RjB2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771686030; c=relaxed/simple;
	bh=Q9dm8LTnk+DFIEJAAB7tpFWixf8EizWYmak8EK7I1tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFHoQH5lwZFCzzwu/pcmkhlfx4X7O5sOGnNA9Z/2ekjpwphSNiFxTqu5fLEYkLgDHInWoreL49tKVm3A/7gFe3sYX4Erj/xZ5ZtINe9woWpIMUahJuosL+95KwAHO7ebmqIgaq43wMAmhAf19kOHodDgqfvmc7vOOpLj1QF1xpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BGqGnW7k; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BGqGnW7k"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a79ded11a2so19974825ad.3
        for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 07:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771686027; x=1772290827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q4HfR25bhfBsIe8RbNyIL8PstGgybd8nsB9r91rb4k4=;
        b=BGqGnW7kOylOdvyrZ4z1lT/ecUHtGqCYxKHr6UhAyPkl9syEx7FrPfoxqn+cYX7/ha
         6vhlJQQ5BpXg689JLYfif9oSifbLc7cZP1aDD7G24QoyJxmqLBOHqj7LPHQv1yBHjJL7
         kWeEsiRuG+7Z7/bP7XyqoKaKOOJNoJR3d8j4+G5K0SH7dahsmuLWDy6LnSGUPd2g5gS8
         yP0IbSfc9xmK29adTLYKqQTzV9U7v6x39Auzdv5eHQOkyvnk/rFZg5KMz2n6PyGFACxj
         qa4gdgzn7GmBFNKK7fBiVAWhESDIuEzTReqEdY2iCvLpl2QPY7M/83OsbcSLtZ2RFMdv
         tjgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771686027; x=1772290827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q4HfR25bhfBsIe8RbNyIL8PstGgybd8nsB9r91rb4k4=;
        b=b7nGuoEfhWhuZyQyLATcucYavRPd0dbu45UGCPSMTOtAGywj9nK1T69EhG+kRk51lR
         JJ8Y93ryrx3Y1S8P/H6TgsTbwnkiuscbxkxvO7f4QrabFt9sX3Hr/JYW9gIVJXgU/WM1
         FhrfOJ10du36okz4CzeJx21jO4AA6utmEW7Qe3/ZadYPbLI8l59vo29gHKJbwlmbIXnn
         uH6EdEUabONJWbQjjbYA+/sHJiOGnbB6MKxxnkC+x/k8+/wC7V6nU7IPhcxNVirotqT7
         5WMf9mZYMDhb2h5X6pfJs5tEJhvEG5Abirq4Keoym+A1DWrdwXn9SVS4hyC5Oq2dLtV5
         5Xyg==
X-Forwarded-Encrypted: i=1; AJvYcCXtmhRva8+m2TJ1kJ04KCPYvoe7d4tdKPIGPszoyNqkYZyiZLtwHwhBIBiErNKeRi4urRlI9+yUeYp7@vger.kernel.org
X-Gm-Message-State: AOJu0YxOWjLZjvjeZvrMqesG+Z/OGCAWII47GTga97VB22n6VfsaaKpM
	t/nxwr45NjzmpjljjLhX6HsU7xNgby+OkGgkoXT1FixW7qveG98GZxEu
X-Gm-Gg: AZuq6aIEji62BvbyEkpDcWk/IJnbSFxFuh/o44PsTecUjIGSAuynxLBymenf/Lu0uy5
	DmSYI6IhK+ZmDDfSE7Zz18iHJysH19PB6KBxKYgXGkuX+JH5TYTjTrYDhiDZiMi3CaWsndtTy8B
	bIXhPzblA/SZGxQGxPeg9U8pmq6voRzeQ6HZNtQM5gQMG5oJN7ygazCqlEtvLyeyYkAMKGeUi8p
	3Lx1xD6fnYeELehsL8rugzBC/uNKTCHELqz/1CBpvikCpjdcpaDN3x4x/kWEhzVUtSRNYSyf4F7
	TmkH1/XOnZjTwYQKY8q3A0mYvGuE9TaJe9b9IwyQYhG718IG/58P63TXgHYCpfGZz0vx79BgxDG
	qP4RoqYJwtvcfS++PboqULtw4gxgVJaAcInXuLzgEfE1EiHk9usFZZspgsvu9oWiSCzc1f6mttS
	2kGggrgUMQbXoFnv5IGaxaDNDSX54fNfwbrMhBlyH7GOU9Zv/AykvnrQk=
X-Received: by 2002:a17:903:3510:b0:2a0:fb1c:144c with SMTP id d9443c01a7336-2ad743fe17amr28627765ad.5.1771686027291;
        Sat, 21 Feb 2026 07:00:27 -0800 (PST)
Received: from toolbx ([103.230.182.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f4a4sm23730205ad.79.2026.02.21.07.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 07:00:27 -0800 (PST)
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
Subject: [PATCH v4 3/4] sparc/fcntl.h: convert O_* flag macros from hex to octal
Date: Sat, 21 Feb 2026 20:45:45 +0600
Message-ID: <20260221145915.81749-4-dorjoychy111@gmail.com>
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
 arch/sparc/include/uapi/asm/fcntl.h | 36 ++++++++++++++---------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/sparc/include/uapi/asm/fcntl.h b/arch/sparc/include/uapi/asm/fcntl.h
index bb6e9fa94bc9..33ce58ec57f6 100644
--- a/arch/sparc/include/uapi/asm/fcntl.h
+++ b/arch/sparc/include/uapi/asm/fcntl.h
@@ -2,23 +2,23 @@
 #ifndef _SPARC_FCNTL_H
 #define _SPARC_FCNTL_H
 
-#define O_APPEND	0x0008
-#define FASYNC		0x0040	/* fcntl, for BSD compatibility */
-#define O_CREAT		0x0200	/* not fcntl */
-#define O_TRUNC		0x0400	/* not fcntl */
-#define O_EXCL		0x0800	/* not fcntl */
-#define O_DSYNC		0x2000	/* used to be O_SYNC, see below */
-#define O_NONBLOCK	0x4000
+#define O_APPEND	0000000010
+#define FASYNC		0000000100	/* fcntl, for BSD compatibility */
+#define O_CREAT		0000001000	/* not fcntl */
+#define O_TRUNC		0000002000	/* not fcntl */
+#define O_EXCL		0000004000	/* not fcntl */
+#define O_DSYNC		0000020000	/* used to be O_SYNC, see below */
+#define O_NONBLOCK	0000040000
 #if defined(__sparc__) && defined(__arch64__)
-#define O_NDELAY	0x0004
+#define O_NDELAY	0000000004
 #else
-#define O_NDELAY	(0x0004 | O_NONBLOCK)
+#define O_NDELAY	(0000000004 | O_NONBLOCK)
 #endif
-#define O_NOCTTY	0x8000	/* not fcntl */
-#define O_LARGEFILE	0x40000
-#define O_DIRECT        0x100000 /* direct disk access hint */
-#define O_NOATIME	0x200000
-#define O_CLOEXEC	0x400000
+#define O_NOCTTY	0000100000	/* not fcntl */
+#define O_LARGEFILE	0001000000
+#define O_DIRECT        0004000000 /* direct disk access hint */
+#define O_NOATIME	0010000000
+#define O_CLOEXEC	0020000000
 /*
  * Before Linux 2.6.33 only O_DSYNC semantics were implemented, but using
  * the O_SYNC flag.  We continue to use the existing numerical value
@@ -32,12 +32,12 @@
  *
  * Note: __O_SYNC must never be used directly.
  */
-#define __O_SYNC	0x800000
+#define __O_SYNC	0040000000
 #define O_SYNC		(__O_SYNC|O_DSYNC)
 
-#define O_PATH		0x1000000
-#define __O_TMPFILE	0x2000000
-#define OPENAT2_REGULAR	0x4000000
+#define O_PATH		0100000000
+#define __O_TMPFILE	0200000000
+#define OPENAT2_REGULAR	0400000000
 
 #define F_GETOWN	5	/*  for sockets. */
 #define F_SETOWN	6	/*  for sockets. */
-- 
2.53.0

