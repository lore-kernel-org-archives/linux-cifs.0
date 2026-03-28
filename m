Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78C03590CD
	for <linux-cifs@vger.kernel.org>; Sat, 28 Mar 2026 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774718652; cv=none; b=BL0jadRpLT5C3lemjdoTAxNPRxedE/PvcO/KqcN7ro858JzK37BsBnHf42yGcs2WDdLXJWA8sRxGdFwT4x4LSyWwrDtXf9gxZScmUxMzDilEoudQGaK4FPmG6qhON5SSk53VGMdZ82vm63iQI3p6i+SaEI8mTRbL5y9lqiiavr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774718652; c=relaxed/simple;
	bh=QvKBTacd5z2P43CbYauz1u/x08KHhA7f2Nkz0BaL8og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NR10s+JUui0kKIa5xh8Weo4GvkpzDpM5gP9J1A9TsZ8vZgRqiKTgigzvojyX3dh2KvXse49YwIF0I+4xadnlhznjVUNq3Tn44H0B57phfh4Ut0Wn6eXFrP1qqN+kp//Xvwew0B23/gVidWQfs95BugM35VhUzLARqdaPF7vTPyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lnk5RSPO; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lnk5RSPO"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35d99031e4eso257613a91.1
        for <linux-cifs@vger.kernel.org>; Sat, 28 Mar 2026 10:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774718650; x=1775323450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Vj99fOR8e2nvanig9cWTi+niKOe1ygt4TyyqPTa8nU=;
        b=lnk5RSPO5uaZzdvoYplj50n4Pdtn+IjdotyTh0EqRdl95MlH9XHvqx40Q/bH7sXudC
         m/87dqBHYnZMw8YXKzWk9pIvZkucoFMsFUgueCgMWoF6JQteXbdUudF5qj4JQBi27/RR
         OAjcQGQJ9/dINc8bZ263JhPxPxZJX5y/UofCbwEybJ7ma4Sgtz51okm3POF4gNkgNgEm
         /42sOkx4X5LBDAUb1nbwbXfMloVd7i9IdURNwKPk/oiSqEMvfbvlv6QEHEFqMjVntep6
         T2vGonEWlWtxfXjEGKsjnrLZQMBM2yxBhMfdi8Pr2EX7UL4lM/ELJHByPdWR7MIIFY2a
         /7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774718650; x=1775323450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/Vj99fOR8e2nvanig9cWTi+niKOe1ygt4TyyqPTa8nU=;
        b=gFlxV6lhv0oEOe4GuccrCBxHWdWwQjktY8KSk/OGzBDR4HEn97/+52vxzstkzNlz84
         fGYngyb4pd37XUO00sw6JSUgRV9qpLttxh70Z8SGAHZKr2b4rIWNmVQVUxqBSwmREfuN
         KuHqEhyRErG06/aoMwIQIHh27WBuoPl3ipjYod2LuJ5mp+nnfoBRAz8aRLC5i9nDYIN3
         bw7f6c5692Xp94eCYCI8+0xkq6oNWRdUd2vo8hbBjff34rhNdlTESZxftHMm7uV2FrWY
         JZUmZFwvgzL4fbdC/TXeeDFg7glQVSynppSFw+muk649b2OdskHAEl9SxmU7zjteomp1
         zc5A==
X-Forwarded-Encrypted: i=1; AJvYcCUGFASxn/JRR620wgQvdIopKgxv8+Wf4QCWTsMjbE2wR2wIq9xU89eZdZjCEHg9FK5JNPgKBlAZCFeh@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ9fyrXlwOGfZqGYrLsq7EqmpvxkSx4GZ70byv7Qr1gFdgXEDE
	u2MdawUHoGBkIUPkwnK37qBZg78oLbPEGXnNRNiGdDzmcF0PaqXeJCdW
X-Gm-Gg: ATEYQzyQcS0GUbKyF4ytpj0HdhtXEZIimQk2pfFG5duXdq/fiYgNhKSpQKf35giwHn7
	u56Pj7oUP3dupu1CWxVIykKP81vbVJxXcLKL45guQxGQWxSSnXIWiCqtHGOF5Hp4u9aCC9krQtD
	fS3zexnbs1ULhFMbG2X/hgZbZDcHoIU64bErpABHRXPuambh0wOjnef221Au/kz5b8fXbHN9o81
	+QG8h0tgkt6cXBEwG31HekXDrmBxETApVyoOS3525bLc/TrAzMn5WzTFF2Cd9Pkm46pQwuxkvpL
	CqFG+vCsHE/fqrqir73JxAr/48U+KgE7pI8oj9TMZzvWCoqAmD+jDrvAP1AogeOcNZSwTi+giMW
	tc1/5m5vFPQmsLV9FRrCSk4MnofHuVlzJf1WGphIqcyeJWBUQ8vhpX3GGBWIJiiE+LCr8lygRMr
	xQ5BBpPOCXavok9+yKaYW7A8rUJv8mXxSiApaCcvQDm3nz6EMnOV43m6k=
X-Received: by 2002:a17:90b:164a:b0:359:f2e1:5906 with SMTP id 98e67ed59e1d1-35c2ffb6610mr6349220a91.4.1774718649869;
        Sat, 28 Mar 2026 10:24:09 -0700 (PDT)
Received: from toolbx ([103.103.35.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22a5570esm10513773a91.3.2026.03.28.10.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 10:24:09 -0700 (PDT)
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
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
Subject: [PATCH v6 2/4] kselftest/openat2: test for OPENAT2_REGULAR flag
Date: Sat, 28 Mar 2026 23:22:23 +0600
Message-ID: <20260328172314.45807-3-dorjoychy111@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260328172314.45807-1-dorjoychy111@gmail.com>
References: <20260328172314.45807-1-dorjoychy111@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just a happy path test.

Signed-off-by: Dorjoy Chowdhury <dorjoychy111@gmail.com>
---
 .../testing/selftests/openat2/openat2_test.c  | 37 ++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index 0e161ef9e9e4..e8847f7d416c 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -320,8 +320,42 @@ void test_openat2_flags(void)
 	}
 }
 
+#ifndef OPENAT2_REGULAR
+#define OPENAT2_REGULAR 040000000
+#endif
+
+#ifndef EFTYPE
+#define EFTYPE 134
+#endif
+
+void test_openat2_regular_flag(void)
+{
+	if (!openat2_supported) {
+		ksft_test_result_skip("Skipping %s as openat2 is not supported\n", __func__);
+		return;
+	}
+
+	struct open_how how = {
+		.flags = OPENAT2_REGULAR | O_RDONLY
+	};
+
+	int fd = sys_openat2(AT_FDCWD, "/dev/null", &how);
+
+	if (fd == -ENOENT) {
+		ksft_test_result_skip("Skipping %s as there is no /dev/null\n", __func__);
+		return;
+	}
+
+	if (fd != -EFTYPE) {
+		ksft_test_result_fail("openat2 should return EFTYPE\n");
+		return;
+	}
+
+	ksft_test_result_pass("%s succeeded\n", __func__);
+}
+
 #define NUM_TESTS (NUM_OPENAT2_STRUCT_VARIATIONS * NUM_OPENAT2_STRUCT_TESTS + \
-		   NUM_OPENAT2_FLAG_TESTS)
+		   NUM_OPENAT2_FLAG_TESTS + 1)
 
 int main(int argc, char **argv)
 {
@@ -330,6 +364,7 @@ int main(int argc, char **argv)
 
 	test_openat2_struct();
 	test_openat2_flags();
+	test_openat2_regular_flag();
 
 	if (ksft_get_fail_cnt() + ksft_get_error_cnt() > 0)
 		ksft_exit_fail();
-- 
2.53.0

