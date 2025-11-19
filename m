Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E2F32ABDC
	for <linux-cifs@vger.kernel.org>; Wed, 19 Nov 2025 13:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763557387; cv=none; b=rmJRCEl02Kyw1Gtc/sEswL47IozcWYs/cMaVa3UtyBoOx7UJ6OVNvM/q+lG6DNv0/0ZzuE5a+afiBj/urV5J0yoWHXO/XbE4qAtL8fQ7NbpK1fCo2XAA7FWA/WFZIHYQ/v+7K/kgoWGqZjM4yw5Qh6nDOxsleghWau3JmriW2+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763557387; c=relaxed/simple;
	bh=lokf8+0AvhEyv7vqXFg5/f3662WM7AqTStYVDGufHvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tf594s88Q1kNnvSssjdshFaIFFhph/AsxUhRQRW3DCalwr0GjuneOvTkxqHAXlpbdhzJjmxm0DoFXySUBkt3jTFdpRA40orrhoni01OKRp65cnLWFdmdeS4WEveWJZYekdypV2V7eXycR3ghohD/u054WlTuQxJYXLE5+IhjaZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XXNOaOxC; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XXNOaOxC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763557372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2KXDy9PdC32jEAfsmQBmrN4zOWZ8tgVUzdmSzfFa5hw=;
	b=XXNOaOxCH++JhF0el1ubtHdpSNrOrHuJpik9pO/8ejl6J2UVl9f07YwZcWR7sFN976eoML
	mApEM4s1C9NyHNUxuCO1gxX2lrVGR7LG2//YfaVGl3giX/DjqHSnnD3MB5zH1EE2TkNAUD
	oLMRfyoTDtAjjANh66s3+Ep2poK/OaQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: David Laight <david.laight.linux@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] ksmbd: Replace strcpy + strcat to improve convert_to_nt_pathname
Date: Wed, 19 Nov 2025 14:02:30 +0100
Message-ID: <20251119130231.171352-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strcpy() is deprecated [1] and using strcat() is discouraged. Replace
them by assigning the prefix directly and by using memcpy() to copy the
pathname. Using memcpy() is safe because we already know the length of
the source string and that it is guaranteed to be NUL-terminated.

Allocate only as many bytes as needed and replace kzalloc() with
kmalloc() since memcpy() overwrites the entire buffer anyway.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Assign the prefix directly if needed
- Use memcpy() instead of scnprintf() (David)
- Allocate only as many bytes as needed
- Replace kzalloc() with kmalloc()
- Update patch title and description
- Link to v1: https://lore.kernel.org/lkml/20251118122555.75624-2-thorsten.blum@linux.dev/
---
 fs/smb/server/misc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index cb2a11ffb23f..a543ec9d3581 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -164,6 +164,8 @@ char *convert_to_nt_pathname(struct ksmbd_share_config *share,
 {
 	char *pathname, *ab_pathname, *nt_pathname;
 	int share_path_len = share->path_sz;
+	size_t ab_pathname_len;
+	int prefix;
 
 	pathname = kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);
 	if (!pathname)
@@ -180,15 +182,18 @@ char *convert_to_nt_pathname(struct ksmbd_share_config *share,
 		goto free_pathname;
 	}
 
-	nt_pathname = kzalloc(strlen(&ab_pathname[share_path_len]) + 2,
-			      KSMBD_DEFAULT_GFP);
+	ab_pathname_len = strlen(&ab_pathname[share_path_len]);
+	prefix = ab_pathname[share_path_len] == '\0' ? 1 : 0;
+	nt_pathname = kmalloc(prefix + ab_pathname_len + 1, KSMBD_DEFAULT_GFP);
 	if (!nt_pathname) {
 		nt_pathname = ERR_PTR(-ENOMEM);
 		goto free_pathname;
 	}
-	if (ab_pathname[share_path_len] == '\0')
-		strcpy(nt_pathname, "/");
-	strcat(nt_pathname, &ab_pathname[share_path_len]);
+
+	if (prefix)
+		*nt_pathname = '/';
+	memcpy(nt_pathname + prefix, &ab_pathname[share_path_len],
+	       ab_pathname_len + 1);
 
 	ksmbd_conv_path_to_windows(nt_pathname);
 
-- 
2.51.1

