Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB6029A322
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174962; cv=none; b=SVs7Re1CyQwQJR/2OMPO/9Fs9Vp6UaeKX6O/2X20qwp1PZw0fkH1wRAFayIpkGK/txqT6dSM459zIBlxzdq2dMRnEYXusAQvq0gtPRs+pVcBnayjwISBN/G6LYEOSgjhN9KsqgCqziEBuMBgJoKm2dZiFT0Be9XCZnQ3I9JAY6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174962; c=relaxed/simple;
	bh=wwdF7dJFg3UswgRyiXnlCFpCS0y2rQIxNWB3TSn/lEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCtZZYAQGSwGSoRMQsc2b3O0nTVLfsxY4dl5F53DGtuhA3LTINSlkyRRj9bsVP5quWUKFFyPcU79giNfjD+LaNF2thuA5n/4svKxKxEj0Bt21cQB/JRE3Dwi1ne6kpcvE67X3MDFe7pl+iPmZ5GgSq46VHoV/EobAPWjOCyj/oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rq3dF5kn; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rq3dF5kn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9csoTjDdNxKRkO1J7Y9JjPudIL8HDhzHNDbpTGiuli0=;
	b=rq3dF5kngpQl9Jl5rJeHNHhl2ADfvNlEbsMdbHTtu95U3EuXFLTmweWZld8ADYRcTbeFb3
	/FBkQCu8bwVbE8GB1smseuS5w6MovbVZe4rOb/FcjMKl6gI7uFoNgayuOAK9WqRgaQEHoO
	a0lgnIY6klEnF69JJ4Zag9cQjFpuJ/A=
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
Subject: [PATCH 03/30] smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
Date: Mon,  8 Dec 2025 14:20:33 +0800
Message-ID: <20251208062100.3268777-4-chenxiaosong.chenxiaosong@linux.dev>
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

This was reported by the KUnit tests in the later patches.

See MS-ERREF 2.3.1 STATUS_UNABLE_TO_FREE_VM. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 90a5eee157ea..09263c91d07a 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -70,7 +70,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NO_MEMORY 0xC0000000 | 0x0017
 #define NT_STATUS_CONFLICTING_ADDRESSES 0xC0000000 | 0x0018
 #define NT_STATUS_NOT_MAPPED_VIEW 0xC0000000 | 0x0019
-#define NT_STATUS_UNABLE_TO_FREE_VM 0x80000000 | 0x001a
+#define NT_STATUS_UNABLE_TO_FREE_VM 0xC0000000 | 0x001a
 #define NT_STATUS_UNABLE_TO_DELETE_SECTION 0xC0000000 | 0x001b
 #define NT_STATUS_INVALID_SYSTEM_SERVICE 0xC0000000 | 0x001c
 #define NT_STATUS_ILLEGAL_INSTRUCTION 0xC0000000 | 0x001d
-- 
2.43.0

