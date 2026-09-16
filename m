Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618CA51E445
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572606; cv=none; b=PxH25ucKcJvv7ykb5nZneAS+PZzIRUqNFQLZnGg9CQYUbHq3I1X6h4Ic9FZf+ZNguzhxOw4vY+cFcG6SxO4HE/SnGYGz/9nk5k/LQE5t6yt1swnBOQlUmwkw+WlIyFMCQ7avAgNiq5vb9qd7tV3cHj5o1hFQato07/g9gamlQZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572606; c=relaxed/simple;
	bh=kKGeABVZuyugMCrWl0lmOHYN4NEc0jbpZchbbvlt6Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gpas6rWLYfkQipqmgv2mykF4qKQMlYi8iYxbaPnSvw6wlwIiZBPV8KF6ptSKs8/QsTn1YeccoQFD3/9b2xQPdjR3QDaVqtqE1Hn9L5FJsRTC9JcpC7PIgJeyV6VSU37E2dvDkege6crQWWTOtJStUypRAKyWBMCC3ddJagbVLrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=kHqd7hbK; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="kHqd7hbK"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccdaea76so431472a91.0
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789572597; x=1790177397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S/ZFIdjymUBuujD6nCl1vDC5+XRxkr32/skLq/kvB6E=;
        b=kHqd7hbK43oDeski7KEnoFUkweV9RvQKI68vK3PA2OIot2KQOF6qNjJdsDohr1FaSv
         AfIQ/dpxj63F2ER3RBpovXSQBQH3Kn7nQePtd9iFQYE27STcPR5dkBAQeRJTKDW+sbJz
         tNbOmsoI10KqOCZDlNAxLwRHC/VEJTuV/XG1nF6QI7iVNPG6mwEP7JZ+54i038AO9KXW
         VvVRBUC5u3DwZVVZca9Wkxzw7/AJhhkodSboa0/+2yBG1pe01avVdn6NywPPu3dezQLi
         OLUCKVi6DLxJJo8nzvZXv6I9/wB2oTKHvkdOxIppzE5wQpGMAXJ3rtxn3gU90wfE3qCJ
         kQZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789572597; x=1790177397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S/ZFIdjymUBuujD6nCl1vDC5+XRxkr32/skLq/kvB6E=;
        b=gH/EzOyYYHgIRN9++bhAQ1agMFRvLXIqi8EffbkuGQOxWu86t49uAbbeSlGt9tjvHk
         Cz+6TZpqEiwzIBILlpHddukRAxvASQcVr80so3QxZi0egbGcIrLqk0QOdoARdG4erWzY
         FQX7xT6L7qecIEsIs4YvQuv38r2EG9QK4GVttsa13Jq8IjOB6b1A3OcGdWyUb0q3tUbS
         2gdSgij1Mf4Ne6OoBG1ad943j4wBF8OjSDsp2ndRbwEnL6N1r4LJ5iKLVwIc2xtpexd/
         yTLuAeAHBSL0UBDALbz6k4vR685WTKF64JOayxkk0SbKokOZSg1Ea6FNal03b8hlQP+e
         GHlA==
X-Forwarded-Encrypted: i=1; AKwUvByt5cmMPzbW/ic8XE6NsZlqhO2Sa5nhoR9NVwQccXx5QTlhq8V0jCLM595+gAxQcnXqYjH2JuHv1YVe@vger.kernel.org
X-Gm-Message-State: AFuF++mB7DfyfiGlF72N6cWyNE2UHn0PrOqO1aGX06IJ/Wj2JKrgQuIx
	umm6OqYEvxkDFr1mo8KmhToSx7fPWLheM+nei3lklgdL43M5tl7s1uqUkD3bK443+pLD
X-Gm-Gg: AYBFou20a5JiaRA11HqnXX95MgSjuMoRJevwQMd/PwiQ8GaM2Z8DWk/XfxiVK5Tk32u
	zfcQbsJRou+RwAod0Fh6xTqLvT06dwxrHu9gCxhF1PG8gjUfS/3UMlT3HRfQvjm/KRIHA+8PqkE
	FWXcC0itR/gt3bqo7d3kvQPBuz4f4MWzBI8YPob2Br68zYMELR8BHOqO77HCCg4dah/27pMEPMb
	8k90sbXKniEShQktWNf6QcyH4lrm1Nd8PAswVSqJmubBDkkJKAMZPXw9+RgN6HXYaUXgdA0isL1
	YO8NYgtyXbKTizERedE6iSRUkKIy4lQYZvIkQINk5NFoKI8b0SiiDDodRLyHRz7HkyH59+I9Ia+
	0FTng36KEeHudJAX1MPC/kA/5XElXossBrGUcZzw8D0SPYiRhn0T/GzU5MjM+0KEdnI7NghDIGG
	FUdHq5NHkRK4eUMXSe47nnPW5jOAV1HUtLUEFnm2R1J9S7V60uJd9tjkYH+ro6OOtkt3HglBhCQ
	AwvNmIzN8U9xnt50huduA4n3PlBFw==
X-Received: by 2002:a17:90b:3881:b0:395:8124:ac53 with SMTP id 98e67ed59e1d1-39e35f71c5bmr7531a91.6.1789572596915;
        Wed, 16 Sep 2026 08:29:56 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35dab2e9sm28214a91.1.2026.09.16.08.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:29:56 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: pc@manguebit.org
Cc: linkinjeon@kernel.org,
	zihanx@nebusec.ai,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH v4 4/6] smb: client: clean up failed cached directory opens
Date: Wed, 16 Sep 2026 15:29:27 +0000
Message-ID: <c4f44045f681cea07089ac9d1e2104449be68911.1789478666.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789478666.git.zihanx@nebusec.ai>
References: <cover.1789478666.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

open_cached_dir() sends CREATE and QUERY_INFO as a compound request. If
the CREATE succeeds but a later command returns an error, the function
must retain the CREATE FID so common cleanup can issue SMB2_close(). It
also must not treat a response error as a valid CREATE.

Validate the CREATE response before using its fields, record the FIDs, and
mark the handle open before handling errors from later compound commands.
Move the -EREMCHG reconnect handling before response validation so a
missing response does not hide the reconnect request. Count the handle
when it is marked open; confirmed close responses decrement the counter,
while existing close retry behavior remains best effort on transport
failures.

Fixes: b0f6df737a1c ("cifs: cache FILE_ALL_INFO for the shared root handle")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>

---
changes in v4:
  - Validate CREATE status and FIDs before marking the cached-directory handle
    open, preserve reconnect handling, and balance cleanup accounting.
  - Keep the cached-directory Fixes attribution at b0f6df737a1c.
  - v3 Link: https://lore.kernel.org/all/cover.1788516372.git.zihanx@nebusec.ai/
changes in v3:
  - Split the POSIX handler check into a separate patch and corrected the
    parser Fixes history.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
changes in v2:
  - Add cached-directory cleanup for failed compound opens.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/

---
 fs/smb/client/cached_dir.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 88d5e9a32f28b..647fa26da4d24 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -8,6 +8,7 @@
 #include <linux/namei.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
+#include "../common/smb2status.h"
 #include "cifs_debug.h"
 #include "smb2proto.h"
 #include "cached_dir.h"
@@ -323,25 +324,37 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	rc = compound_send_recv(xid, ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
-	if (rc) {
-		if (rc == -EREMCHG) {
-			tcon->need_reconnect = true;
-			pr_warn_once("server share %s deleted\n",
-				     tcon->tree_name);
-		}
-		goto oshr_free;
+	if (rc == -EREMCHG) {
+		tcon->need_reconnect = true;
+		pr_warn_once("server share %s deleted\n",
+			     tcon->tree_name);
 	}
-	cfid->is_open = true;
 
-	spin_lock(&cfids->cfid_list_lock);
+	if (!rsp_iov[0].iov_base || rsp_iov[0].iov_len < sizeof(*o_rsp)) {
+		if (!rc)
+			rc = -EIO;
+		goto oshr_free;
+	}
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
+	if (o_rsp->hdr.Status != STATUS_SUCCESS) {
+		if (!rc)
+			rc = -EIO;
+		goto oshr_free;
+	}
+
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
 #ifdef CONFIG_CIFS_DEBUG2
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
+	cfid->is_open = true;
+	atomic_inc(&tcon->num_remote_opens);
 
+	if (rc)
+		goto oshr_free;
+
+	spin_lock(&cfids->cfid_list_lock);
 
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
 		spin_unlock(&cfids->cfid_list_lock);
@@ -408,7 +421,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		close_cached_dir(cfid);
 	} else {
 		*ret_cfid = cfid;
-		atomic_inc(&tcon->num_remote_opens);
 	}
 	kfree(utf16_path);
 
-- 
2.43.0

