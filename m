Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77244325704
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782126; cv=none; b=jieJEvmjOULD7+ikSRLc8G9mz88uN0VSGpXOGB3vhsIORyJOn2Ia467o61AWdVsDucB28tignrEtyRQSb4M3ZMH5ml84B2gKV9eoL5spe98jrCNnH/fNWLszmfbiylpIIP4aRCeVFLuNhBh9vg2qbuHdz1Dd2kgg9vltNtK0u9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782126; c=relaxed/simple;
	bh=UOcMdPDxPqW5N6cbH8kVHUjKp3GyIayCM4LnYH2aNRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T95OWMtsXaNcATJwUbXtrgDuuOTopV+QXGRPoJhvaJ8JlSs9GeEFotgIKiWs+oVv+Qca+eAdDM4UXSkyXNg89+Gla7JY+e0iLlqHQHvsDuNkM5rYgew5+PfKZ7Ws8eMZO2hpLZN1trXaumiMsaqOmAM8+v2QgFW6ra79ErqEAh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oV7fy/pJ; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oV7fy/pJ"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c80167f56cdso3535378a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778782125; x=1779386925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCpVBwBWO+1IrxDgHzHTN2IrKn+ScyFNwA3gK4phwGQ=;
        b=oV7fy/pJVKTTgEHYhBhiCuwQ/ky2C9dl7QeZtLjEOn1u3+sW4cidO4gIlplzti4WWU
         HnvgeOUHcHHuXl9upooBRryNEP77DcVMgS2EEKEAKp9L/BKo3h2vJlrkE5qG2uLDNQIc
         DQra60xCg8WhZ37ZESxqBvO4XNKIdabe1B9bvnYAvmVDVPs6BDyRLgnSbsdkd/uyhjet
         0h6eCJ4H/6XCixTiD89dN9FPwPylsoSIDp2ESI15CcYd3FzY95ep3cPyumgFNZRmFF5u
         pd+8GJbZR8Lb2cRBnZC0JQtsVrEZ+kqSWC6rN55rM4WF8ZvYaDAvzuQZ+aIYSL8dwlyz
         Uofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778782125; x=1779386925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PCpVBwBWO+1IrxDgHzHTN2IrKn+ScyFNwA3gK4phwGQ=;
        b=Q2MfqFoAue6tPeWMdQD7Y9vHmKzZzgKN0dkbNrnojrUbYx7PIciYkQJfBwWsa0zHVi
         Yld7IiFleXFGkq/SBp2XdMNT/jSCPZSbX6TiPNOnFPNtJq5gocVQj+xOjrx+dOsQIWyN
         QszuLYxiAAO3gZNUXjg9/m0z68zmV9F2y9/Sr77GEa8IWO4U2Nt8FubwDGPd+TFlivk9
         ch84sSgzAA9AFS+SYIBTo+md5ZCHioUBoZG5kniKaeW7aBrUm71jPmExgALkSxlUDMdi
         piGfqqLpZlTWZdHsnSpWZAGuJYznbmwE8PjKhmjeXP/ll1SUY7xCAjdZiKiP8TCOB2xD
         zT/Q==
X-Gm-Message-State: AOJu0YyH1cq0Er/kVTkavOaiMaX03IkFAvvMkfLG9Iq7/AK3U5t6jEb2
	Vw9sj8EQ0Jm72WDrUWYvGHF3jp1Ym63HvdTVNRUqqw9nw09fgIlMJEookMVkah+aZzQ=
X-Gm-Gg: Acq92OEI9oEfo/LQXYJ8c2hC2vWpLdzBGCrL46stqlIyoedBNW7NsHJ7GfG/AMiw93Q
	HtTPEIsZXZbi4pIXbMIjSluv4AmJYrrLqRveBpYxY6+7lL2hk3ql7XPUK1kCFakECYu111M5Vi+
	i5ZcWFdrtCv92hQOp3rGP8V0dNRaPB4adHyOjbT3OKYYEOUIaR8A2WY723BqrfhcKcEbJwj4mUD
	H0FoWny2SNj/8rUfASTNY8TTR/g2Dz6mlv+cHKbeBbvH9b5xauesPMTFfj9yl6dg/iMbLBmzGI1
	7C8wOkMVcqK9IcV09eJCBnKf338S+OEpfnKNDN+3z8ULNTiRRHL63wG7n9zF/SRRrE/J44yIPh+
	IW6e1mp0KpDAOL1t7pxHMNwlRFQH/10vx1KaYif+rP5l2tcqg7cLAn/kzva3SlmVsbgTtP5qvWz
	HNFCVcBnCOnD355eQ5x3rz+Etp5b5Qq1TqeRWJqiky9Ru3DoDMHv6DGQ==
X-Received: by 2002:a05:6a20:9190:b0:39c:787:f196 with SMTP id adf61e73a8af0-3b22e72fb3amr377126637.16.1778782124522;
        Thu, 14 May 2026 11:08:44 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm3134589a12.30.2026.05.14.11.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:08:44 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v5 12/17] cifs: option to set unlimited number of cached dirs
Date: Thu, 14 May 2026 23:38:18 +0530
Message-ID: <20260514180823.497293-12-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260514180823.497293-1-sprasad@microsoft.com>
References: <20260514180823.497293-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today we can control the number of cached dirs on the system using
the mount option max_cached_dirs. The default value is 16.

This change allows setting this option to a special value of 0,
which means unlimited number of cached dirs. Shrinker can still
evict the cached dirs.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c |  5 +++--
 fs/smb/client/fs_context.c | 10 +++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 921a6f2c3c51b..ecdc6907cf6d1 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -1255,9 +1255,10 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	if (lookup_only) {
 		return NULL;
 	}
-	if (cfids->num_entries >= max_cached_dirs) {
+
+	if (max_cached_dirs && cfids->num_entries >= max_cached_dirs)
 		return NULL;
-	}
+
 	cfid = init_cached_dir(path);
 	if (cfid == NULL) {
 		return NULL;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b63ec7ab6e513..1ecf819dbbce6 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1468,12 +1468,12 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->max_channels = result.uint_32;
 		break;
 	case Opt_max_cached_dirs:
-		if (result.uint_32 < 1) {
-			cifs_errorf(fc, "%s: Invalid max_cached_dirs, needs to be 1 or more\n",
-				    __func__);
-			goto cifs_parse_mount_err;
+		if (result.uint_32 > 0) {
+			ctx->max_cached_dirs = result.uint_32;
+		} else {
+			/* 0 means unlimited */
+			ctx->max_cached_dirs = 0;
 		}
-		ctx->max_cached_dirs = result.uint_32;
 		break;
 	case Opt_handletimeout:
 		ctx->handle_timeout = result.uint_32;
-- 
2.43.0

