Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5462D3ECA
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174959; cv=none; b=tCT/2KikKaHN1vRxuQgqiKMb33FFp/nWgOudLio2dtxIzPIF3c6xn2d1dXMeSfIlugXqAOs//GSu0DEhehZxxmixakCb3CYU7aFbwBkFokztAQZYgSHGy82x6CCogA1uAxHN29Y8+NLkeSvgsEuGSAeO2uk0opZjG88S9MePURk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174959; c=relaxed/simple;
	bh=lcAs1Fsz0TjlB0lJkxLtm0FqyyhH/K2PrJ7/khVDaho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PO6z9JE9Wpjp+6GmHoUqrXsWCeE7QJwjr811VRCZgM7N0jWcZxP7pODXx5hL/HiNjUDC/WPKZUNpRiyt1oYjixPz5+Wx/5KR3CNZfQO7iEgjaufdiKQN8qKmSevEgfZGpN64SaHNjRDxcf9zaEzY6kmYGIV4hncEBmcY4uxphEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sWeArTJK; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sWeArTJK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n2Ri2o1HP+R9Uc1SOQ2MmfbmlcK+dh/U72QvKcwWbtI=;
	b=sWeArTJKgYPO1PpEfw1FgTslHK7n+3bVevYSV8N3v69mTEx3Dt/SVu1mUOg8jOjc+y836d
	ivkYdQTAEkb8keBpamQcGv4pAbIUbVI0k7OIYwPVE8uIQPb7W4uyspjsWXO3DUQv6HdqBo
	PXCb/FtwZ+XKnbxVoqYyajKFgQWCpXA=
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
Subject: [PATCH 02/30] smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
Date: Mon,  8 Dec 2025 14:20:32 +0800
Message-ID: <20251208062100.3268777-3-chenxiaosong.chenxiaosong@linux.dev>
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

See MS-ERREF 2.3.1 STATUS_DEVICE_DOOR_OPEN. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 4fd79a82c817..90a5eee157ea 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -44,7 +44,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NO_DATA_DETECTED 0x80000022
 #define NT_STATUS_STOPPED_ON_SYMLINK 0x8000002d
 #define NT_STATUS_DEVICE_REQUIRES_CLEANING 0x80000288
-#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000288
+#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000289
 #define NT_STATUS_UNSUCCESSFUL 0xC0000000 | 0x0001
 #define NT_STATUS_NOT_IMPLEMENTED 0xC0000000 | 0x0002
 #define NT_STATUS_INVALID_INFO_CLASS 0xC0000000 | 0x0003
-- 
2.43.0

