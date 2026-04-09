Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADC3388E40
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 09:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775728798; cv=none; b=Ex/KFwctRsijO+01g+b5kY8dLDGUnrhkfQYV3PnpxzWxy+UX/nDeIslCyOilV6wQlI4bcPy/ocKhPuCE6FBG5hyTi/WKuoATqPo8qWepS3SVpEVBQW3ORPAn2m2shPNwqJU/vhypPs3uuHPtu6j4DumwymJtJT5O/NRYp+gm2oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775728798; c=relaxed/simple;
	bh=vvd0M/Mz+711aOsS601VbRuhF4hK7peQspPb9+5ynKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSl4nffGrBMQhQJRz/xUoq/eFUrc3PgN+u5Slaa/RI93jvEi7S5Qd/+8iVjaNsyB8R+XgNG65P++PgIpkbQ/R8njxtWalCsvQIE0rqyH/x3Syh8vhlSyftAOGz9lYHfRH5llgAHcIAGxliIUoCnbNEQ2HcOdIkoirSEJut+53LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HcdRBy64; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HcdRBy64"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82c68339cf0so419489b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2026 02:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775728792; x=1776333592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j08sVRHBiUq1wf14pHnVtUsNqT84yk77IOh7rJh2w3I=;
        b=HcdRBy64vSqlU7VzToytyGQBUuK3bluU39PiHOnZ0P4Kn2bS2Sii7Z7vNfODqa/e4K
         yDx83w2QzSqu0iRL/3eb5cgFZTv8o4pjeWoMPQdmtXhmNF6sW+dbrvrFdX2sJHMlPKFE
         LUlmKA0ppwWeNOzyONme7e8Rm12oIv7XpRor8SaFefrWfNFYjLwya76ZLxdejqoLVZxH
         y9Ge5DmKY93WdjyIUns6aDuDfFlWQjzKLDwN03jcJpKrZWeHRrlibuRwxIoMFZr+kV9m
         1An/F1JJq6aaUqCbcSGQTXThD0R0wyovLudzv/9yF+UjD/5So18oZS0SSkxVSZgEPUk2
         WprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775728792; x=1776333592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j08sVRHBiUq1wf14pHnVtUsNqT84yk77IOh7rJh2w3I=;
        b=fGwmR98Y5NfwUeidjiEwVsFajt+frwcy80kAARjrHG6jaQ/7JmQT25F4h10E318xuN
         cEuhUwaQfoxUaIg747c5XM8Dw/oA7YLoURyNJo3f7awVGx98uRYgcj3m63wgiGKRbGkJ
         Rh3kN9bj4F1yCRuXy/tI1UTwB8gN5DzQyuT56ov8AEY3UneVO5L/ZW3j0EvvAe0ORPFK
         CvW10V88LMkS4MG94+WM57B9kZlMQOaCVQ1Qi0SGQGi8EbXqwEdGjWJgpYxpqXka1A5O
         D1nwljuhf2nUdLEV0CPVTsA53q41ecVQSDVRvoSEsT/nKkW7pwxA5Rxjj3ugylSwBhWv
         9BUg==
X-Forwarded-Encrypted: i=1; AJvYcCWVMb5rdAL1Z9AWGTucdTlGjCCz7NV8YTMP8Hj9j+T020py9uqXCI1g/LWIUH91VZRqKTMa7x67jnpv@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0q1kfs198z8Uit6RvjKK7bLQND5LdMnDQE8onl+UD05iInASi
	K13tsVcRBJwbJCRSW3ahCJQWiftui1GhzMrheafM20gkj14kjQRx8yAo
X-Gm-Gg: AeBDiev481CS6DwI3CV5QTgnOuRVDnOVRax86ing56ldqoiz2gGU5xww4YRyUzr80r2
	lUmuNxcdOQ5SSeyEGSmeaTIwezpDmX7gy5tpojXr2Sy1e+rS+APVN/CaHz7DoEleznU/CFMPSIQ
	zYQPH4QHwi3+eIrMlgVIhJCxcaHFWClXsmuKg7NKBrSr4Z37VqnI8X+x16aWTQWE/2E90CPCNOj
	MgPX3MafRIlA1TphdIrsHm8Znr8i42iphwfBuL+mcE3Evkv7O3FoQ7uIt78L5m2RuWyQaSuSmXc
	r2GRJkioV97YqqhL47u+grbsy7O71Wq5EXnvb6oZU1nApsLBSxEBa4UJAxnsiXWVyJJ6S0oocXG
	hZjTqKJyfYq+o0Yhg0/0gBW2YYR8jYKkQrcyYNvS45sF3OBwo/DVa0olQCyf2DsNlR412gdEjqJ
	iC7YH+bUeBQkoF/995Gcqr7mfXFTXhVp71yO0uHb+PRF1iauRS9BbXbemtbFh/Y62GgXRRMtnr8
	9e6Tz7LrLyQSiQmf2q6Ku08zhbmkII9FA==
X-Received: by 2002:a05:6a00:f86:b0:81f:5acb:55fc with SMTP id d2e1a72fcca58-82dd8ab8823mr2419175b3a.10.1775728792393;
        Thu, 09 Apr 2026 02:59:52 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6b80dsm29113671b3a.42.2026.04.09.02.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 02:59:51 -0700 (PDT)
From: rajasimandalos@gmail.com
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	metze@samba.org,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 2/9] smb: client: allow both 'lease' and 'nolease' mount options
Date: Thu,  9 Apr 2026 09:59:19 +0000
Message-ID: <20260409095926.905020-2-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409095926.905020-1-rajasimandalos@gmail.com>
References: <20260409095926.905020-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Change the nolease mount option from fsparam_flag() to fsparam_flag_no()
so that both 'lease' and 'nolease' are accepted as valid mount options.

Previously, only 'nolease' was recognized. Passing 'lease' would fail
with an unknown parameter error (or be silently ignored with 'sloppy').

With this change:
  - 'nolease' disables lease requests (same behavior as before)
  - 'lease' explicitly enables lease requests

This also renames the enum value from Opt_nolease to Opt_lease and uses
result.negated to set ctx->no_lease, which is the standard pattern used
by other flag_no options in the cifs mount option parser.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 6 +++---
 fs/smb/client/fs_context.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 0f6c1eb8e274..e1bf7bad5be6 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -80,7 +80,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_flag_no("forcegid", Opt_forcegid),
 	fsparam_flag("noblocksend", Opt_noblocksend),
 	fsparam_flag("noautotune", Opt_noautotune),
-	fsparam_flag("nolease", Opt_nolease),
+	fsparam_flag_no("lease", Opt_lease),
 	fsparam_flag_no("hard", Opt_hard),
 	fsparam_flag_no("soft", Opt_soft),
 	fsparam_flag_no("perm", Opt_perm),
@@ -1572,8 +1572,8 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	case Opt_noautotune:
 		ctx->noautotune = 1;
 		break;
-	case Opt_nolease:
-		ctx->no_lease = 1;
+	case Opt_lease:
+		ctx->no_lease = result.negated;
 		break;
 	case Opt_nosparse:
 		ctx->no_sparse = 1;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 0b64fcb5d302..a80a5caff23c 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -102,7 +102,7 @@ enum cifs_param {
 	Opt_forcegid,
 	Opt_noblocksend,
 	Opt_noautotune,
-	Opt_nolease,
+	Opt_lease,
 	Opt_nosparse,
 	Opt_hard,
 	Opt_soft,
-- 
2.43.0

