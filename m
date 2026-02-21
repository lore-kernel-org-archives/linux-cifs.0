Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9231A1C5D77
	for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771686015; cv=none; b=CLXZmlBI6/NQNXI23t2QLHmTgOOXqPp3xlTcyAYWqDreIExVYWBD6u2BJuQT4F4sVstqXpLVBxOZmP5ZNvWVURozKRdHGCNujeLfQik2iBrBarG0Wcye9cb68UjChciBu3pywLLQYf70sBjA8XXnd0o8ivq69xrZwls/dl3GkpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771686015; c=relaxed/simple;
	bh=QvKBTacd5z2P43CbYauz1u/x08KHhA7f2Nkz0BaL8og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prhgsRp/Gw5Gbvifi+1v2JRoH7CEzV964xAKQvEF/tKcDAxW/g8a3y2xcA3eO4vt+8BnKr1eO0RcwCtDpJ9h5ylD8Yhvv+i+rjbeSkY5/kiaFlNfL3N4ctu48uxoujMjaTi2B+UbV/pihgHoJVHEu9akiiYifUvCcP1EqWxbWv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FeNXLvmH; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FeNXLvmH"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ab077e3f32so12518735ad.3
        for <linux-cifs@vger.kernel.org>; Sat, 21 Feb 2026 07:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771686013; x=1772290813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Vj99fOR8e2nvanig9cWTi+niKOe1ygt4TyyqPTa8nU=;
        b=FeNXLvmHrHIpmt8JXR2o2hvWvgxiyIex4tVLvrjE3FRE4sl++ff9yZ/qZmqpwsOYIW
         g1n8gI/uv8OvdjIUtWywKvA/oh+AXVq/yft5jaJ4CpuCc5TUOGGrfiaCzxjgll2zJAAq
         MpD5M+uoHRsVHvZpjPpbSq9WeaiQCKm4vwri+5n8T7GUiWkjmGrNWj0ji8Wgc/2YC46f
         5wwIoqLv3P120IVhu0diTpsk1zRQvx5qIai+uDUWI6nippTPpsjO3h5VpY2pU2u+uthj
         fy3IldQtY3hhl5V0lGwpTL5MNaiBoS43OzXeaLxnXRVe177jq+SlzwhKs8BC+YMstGss
         NrJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771686013; x=1772290813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/Vj99fOR8e2nvanig9cWTi+niKOe1ygt4TyyqPTa8nU=;
        b=a6Z0xEpR7SmroJasdcdkHaQm/wWoptcwjxX//Qm8Jp9QX0BdGBJwgxpxLOZuZXnaV+
         62Esb7wB31O23e4+NMDMT1IwspLPGoMr4LuihdoeEw37+3I7/Vlm8hlO8DWL4rsz11nQ
         80rNvbofHfUXIi2YY+IjtD9rUNtz7VDxYP0sXpKgGp3GwQt53pTSE+dKQjjmWPctcINV
         aH61tffF6mJynPeTF2Mbmrz0aR41ixn00Pf8d0sITmSxlY5fBex9EoflTZzNrZNdD553
         uzqQMDFNoD3zhhaLTKxCyziQ/d7o2/DnAbQpDmeMs/5g2re3LXKaGxYDFC6q7te7+NuJ
         u/Rw==
X-Forwarded-Encrypted: i=1; AJvYcCVyj7ccv2QdoGE5Mt3xq4e2cQNeTW58F3F9meDoQTfaO8eo3wUDvBmH46CCpw/qxMBOY7YbssFHpheF@vger.kernel.org
X-Gm-Message-State: AOJu0YzlP3/WvXdqdsFPBWd/eFS5RL6m3NZEp3rZ6QK9ktd8cKnQUZ4p
	lkmdxgPzOaA9IUM4doKmSFjW0wYA6wLL8v2gHkDEJ0aDh7Xra21wxI0Z
X-Gm-Gg: AZuq6aJ65fqYrpoEPyjKBrRkQZKACJWOs42EifdHUDKGBr6sQFxoBLuKfXG5b2Ji1HT
	nBhsav+d3+1WEj2KHOfocLLQ3VL1gcjdy8vcZiQhxNRBiMEr21bgfQwqTd8Pof2pHbu8IWkZq7G
	p3xLVTd89HEAUKSI4cT2n6BfHWpXMDkIxXKgyMb/EE5eoj0hHEqLgnJKzPBpzh7vM0G3Cv+Z4VP
	akpU2cS1/4ly6ojQ91KX2AvJCHSZ8BZCoTIb4uzmroc5pYaTBP3RHLCfOind0Pcs7SHzqlBx4B9
	zzO08p3juXEcpD2q7ybdTQcZHFeNfyVQiHHQWvT1y32eZfKpV4e8dIqqKUvIbW+uNgmYfXxeWgo
	FVBQBNqflsEwFppoeHdeX4izyhNbkvPXeV993oWKh1LsH/yLnWsbstA2zgcJj3R9AwfoYh6ZfVb
	lQRlhcBAhXiE1LDtNSmCciUvSwbPgRvo8pl87vFJyCBhEC8LkRJUHpS0I=
X-Received: by 2002:a17:902:cf07:b0:2a9:322e:2473 with SMTP id d9443c01a7336-2ad7457e58dmr34715235ad.48.1771686012796;
        Sat, 21 Feb 2026 07:00:12 -0800 (PST)
Received: from toolbx ([103.230.182.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f4a4sm23730205ad.79.2026.02.21.06.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 07:00:11 -0800 (PST)
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
Subject: [PATCH v4 2/4] kselftest/openat2: test for OPENAT2_REGULAR flag
Date: Sat, 21 Feb 2026 20:45:44 +0600
Message-ID: <20260221145915.81749-3-dorjoychy111@gmail.com>
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

