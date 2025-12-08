Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995B02DC76B
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175013; cv=none; b=WPrVma2llR5BOUyRkGHFIPrgnidPLMLxLbKis9s4iVESa06i3Wj+OMy7TW3dyk25z8SB4bTtbFOX/u1W1AmwHmsojonhQVCpK55rvRCvLi3FT6VMpn8b0CCge7R9UrfppPUbFZH3U1ugeYhPNCIEMvIjeQVeNJDWW2sexQtg3Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175013; c=relaxed/simple;
	bh=n1zSusySdJp+Kk3R78OUhaCm++6eUPq6LYgtxK3tEV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLABwkWzhJNi0wK7D29AXmjez14ooa4gEucul42XUv+f/uEW1lKXujLrOxpHgKeqTZjQFnHQm1SRRlgnVcPY9UOiAFIR5963LscRtEggpNaDViYb9c2A2/aBSJqqOJTUpnQ25RbQVIQt4vB/gmoWsj+cm+zHOYSRAVibn1qvVs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TNKo5/PD; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TNKo5/PD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tyjZVoqYazpjp9poY9U+n5xVSreUjJKztp4p+eVljEM=;
	b=TNKo5/PDsRydnQHVEJfvUwkIBcElBkDJtD3LeJ4GLos9G3Kf4JxL/emGfl9wWkfrQiUhCr
	xPmFR+2ku0pctND3i9Q7Tr8GLml6vapjd6Ap7ERGp7NN22GCkB/lRPMHdqo56DGlD+wDfr
	KmzNVgPI/74xHtQxLFHzi0DY73xRlkY=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 19/30] smb/client: remove useless elements from nt_errs array
Date: Mon,  8 Dec 2025 14:20:49 +0800
Message-ID: <20251208062100.3268777-20-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

NT_STATUS_OK are zero, it is not needed.

The last element in the array is no longer needed.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 8d0007db6af9..faacec11c611 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -12,7 +12,6 @@
 #include "nterr.h"
 
 struct nt_err_code_struct nt_errs[] = {
-	{"NT_STATUS_OK", NT_STATUS_OK},
 	{"NT_STATUS_PENDING", NT_STATUS_PENDING},
 	{"NT_STATUS_MEDIA_CHANGED", NT_STATUS_MEDIA_CHANGED},
 	{"NT_STATUS_END_OF_MEDIA", NT_STATUS_END_OF_MEDIA},
@@ -684,7 +683,6 @@ struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_NO_SUCH_JOB", NT_STATUS_NO_SUCH_JOB},
 	{"NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP",
 	 NT_STATUS_NO_PREAUTH_INTEGRITY_HASH_OVERLAP},
-	{NULL, 0}
 };
 
 unsigned int nt_err_num = sizeof(nt_errs) /
-- 
2.43.0

