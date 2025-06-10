Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60A622338
	for <linux-cifs@vger.kernel.org>; Tue, 10 Jun 2025 00:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749515604; cv=none; b=I8lUcQ9Gf5GQBlUsRQXCe5QWZ4kIIKyYuITnqPrRjuCE/SYfWKLggFc/7IFJIah9ebZeGzU7aiRZ4Y32JYVc10R5yOVal7GE+7V0pEf7maQLXdyaqCQcwoq5X2WKvdIZuBrC3DRYKMFPWgcpdCSiDjCDNLpIabxASDI4wwLiMtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749515604; c=relaxed/simple;
	bh=5pYUBmzAIqmidVYBUwjpMJZluf+0bvdmjAqbz50RdSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIxAl4gP9gYrWwFoG1l5sr+qyZgVXgmRW76NHwZoccDQYIQrBMKzL2yyk3TGs7wraSA5hG2puP9I0QJClkPOV5yEru+Grd14mVDqWI71XoZ8dmq0QyvDJy8pDFRhjm6z9eF9ICMqUz+mj9Uo3ORTCg2Jh32BdXkKKHdxhTk2FaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=NpgQdTWM; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="NpgQdTWM"
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2FEB5446FC
	for <linux-cifs@vger.kernel.org>; Tue, 10 Jun 2025 00:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1749515594;
	bh=/yjCKpdkysKVogcBe7BPdtsfa4RVW+v+Z8LRFVMd1LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=NpgQdTWM+ud5G4dhlLdous9Ip3+ciW5Xj8xN0NaYGpoo3TnIB86s82tE9dinnoEat
	 V53LHkKvmcs2nCFYH1gFVIxLWvOV0i9pT6p95S0QrGCSftm3VLWQOHcC86CA6prbqm
	 REM2gogfiNPZ8aFQf/54IdJS7uZ+I3UFW54NNJPjt4laHE5ibCQ9lEIbNg101fadfx
	 dpEUS574xySX6vSPFF56ndX8BsPxS16lVP+gc71116NNT15LtgdRQhDrqYuNPaUv4o
	 bvB+iW4WRfF+E0QQgMlCBXUmUEZVsyXPtHQPVtpylRnHS0Ul/p5KPQe0C6GG9e0h1T
	 2igwpGezdro6w==
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b1442e039eeso3067071a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 09 Jun 2025 17:33:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749515592; x=1750120392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/yjCKpdkysKVogcBe7BPdtsfa4RVW+v+Z8LRFVMd1LU=;
        b=JaguxyrPZYQtoGzlpnuuLXv6Sf9pIL0zXGMb4O5BHXB9d3dAduLyIA3pLfTr52qPyY
         +gIlkHDy/me65ziRKO7kXUvPGHhcM5cwUBGmZPWAk0lOqAW3A3tu80UARAbfijtfg1OJ
         70XBn5cNCHARho8ZTmQ++cohcuBrBb215LdOSWEXyrULqRKY0/aadOnUCYCA+4QfzvED
         ivvaL3YIpWW/ULwZYLaqHLRsXmq7Ivb7eZ4RH8MtwC4hSjUgbzIYxbTP+nciTnAIB9Te
         J5Pc8v7WvcdnPeE0TR4QKaidwdkdXgiZDHcxvofUt05FZrPpU3trtqT6DUJXNeDkjW+c
         ESwg==
X-Gm-Message-State: AOJu0Ywzf62IPIhgMCMOBmXa43d05d/iKfSTWLLdCp01ZDDDLPgSfew1
	bpk6R9WGn/Tx5YYOf9PkEQvmyAjGLg3I2DB6SnV+xPRsCKoGrLHoDi7i+eMfKgdqv/U3OtRidHx
	tonQpEVJ1BOPgP4KJooGJMVDmWvOA5v/v43q7bbtkLPPqTYtTxPNsGn2+lqvrF84oBsTB94n38e
	EwASI=
X-Gm-Gg: ASbGncuAhPTFC9F6JrC7Xo3J8iRahAodeze6C0r0qctaMMZtmft4qa2foLyiDSwu3yN
	WnEq4SXmqFvIIzh+TVfkbIjREnZB6GWTTLLyyZ5FiYyyjy05s5PcvBOEf3pAS4zAZhEfH5wge0W
	BR8lfLuETknGIoew4duirOdXPkWWTk35AKAWu+gfXGSmmHkjwA1LWdWGL2CUmxbqXd+ZVLux2G3
	x6s+3m/Lqc6mZqfZSpV5Y59Xf+4p8oqiUuDiucTI/Eo4p8XVGQCRKJne+jV99FCsq63Pd3csVRq
	SKKYTlHl9+mJTH4eoUCMqqxS5jBfeB3ADFvQ1HLmVD8DYiIdyXI6K/+fLtvGmwU82LEz/auFag=
	=
X-Received: by 2002:a17:902:dac3:b0:234:cb4a:bc1b with SMTP id d9443c01a7336-23601dd8a74mr219308965ad.49.1749515592437;
        Mon, 09 Jun 2025 17:33:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEl6dceGCFGWY+N7WeXzm1HhF/qv2zdO5bHPvwTCdyhccpvtn8NIHmxvdKKObm0SKVPdU5cng==
X-Received: by 2002:a17:902:dac3:b0:234:cb4a:bc1b with SMTP id d9443c01a7336-23601dd8a74mr219308605ad.49.1749515592093;
        Mon, 09 Jun 2025 17:33:12 -0700 (PDT)
Received: from ThinkPad-X1.. (125-238-29-131-adsl.sparkbb.co.nz. [125.238.29.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23603405e6esm60119595ad.170.2025.06.09.17.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 17:33:11 -0700 (PDT)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	henrique.carvalho@suse.com,
	rbudhiraja@microsoft.com,
	bharathsm@microsoft.com
Subject: [PATCH 1/1][cifs-utils] cifs.upcall: Fix regression in accessing ccache in env for users of UPTARGET_UNSPECIFIED
Date: Tue, 10 Jun 2025 12:32:59 +1200
Message-ID: <20250610003259.19242-2-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250610003259.19242-1-matthew.ruffell@canonical.com>
References: <20250610003259.19242-1-matthew.ruffell@canonical.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A regression in cifs.upcall was caused by a missed UPTARGET_UNSPECIFIED
statement, which caused users of unpatched kernels without
db363b0a1d9e ('CIFS: New mount option for cifs.upcall namespace resolution')
to not be able to get the kerberos credential cache from any environment
variables like KRB5CCNAME.

Fix this by adding UPTARGET_UNSPECIFIED to get_cachename_from_process_env().

Fixes: 89b679228cc1 ('CIFS.upcall to accomodate new namespace mount opt')
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 cifs.upcall.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 678b140..71ff1d4 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1573,7 +1573,9 @@ int main(const int argc, char *const argv[])
 	 * look at the environ file.
 	 */
 	env_cachename =
-		get_cachename_from_process_env((env_probe && (arg->upcall_target == UPTARGET_APP)) ? arg->pid : 0);
+		get_cachename_from_process_env((env_probe &&
+			(arg->upcall_target == UPTARGET_APP || arg->upcall_target == UPTARGET_UNSPECIFIED))
+			? arg->pid : 0);
 
 	rc = setuid(uid);
 	if (rc == -1) {
-- 
2.48.1

