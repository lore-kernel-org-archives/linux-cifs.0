Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F402E36EC
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 01:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754442283; cv=none; b=WLi/c/YPe6sJx4Mayih+GNGutdSknHEjpRUGWm1vR7NTBXmudwkL4y2UU1U0LtGI/fLP+TuV/AiDmEo8AF2/g8KuLyyxGVE2TCRTgbrpoEm4MIGgGUMvPfbWfJ8VY/u+kge8zlQSj2DAxzJjUf1W/rIUb6GYocnu1R2dxKoLc+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754442283; c=relaxed/simple;
	bh=7xv4EuNJe9l+nHGwPOvCi5WPN3pL0wKiQw4xh+kWLKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S4cVAnaIUgnKSC6Kj24Kxzr4U4oVr4ZlfFcNmWb3IXA4qPjB/EN2/D9/uz1/aiREalZ6Cz+AjRyMB8buIeNkUJA8EcvZBNl9T6F9Lskx1JcUcSB4EQpk1sIVkmdeSh2dNOox7h97EGkZhjppnEioYno28Gewyn64h2Y4Xiro1s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eVVd3e1w; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eVVd3e1w"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754442277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a2FuUZ+f2cjOGCbD5ZW+D9cVIW5HzYCMplPAzNqlP4A=;
	b=eVVd3e1wE6kUIHZf/Gy/r0lt5HawdOmJBwAPpf+hJpL6xIfYDS/0NC67BeuFBPVvxNwDyc
	n7HKhMeEPZILTkqUNab3BTsQpozJRk/Hk72kX5imnkw2ahbvzlokGkWs7fuU+w+oLNxboC
	Yi2m98c4IApwXCpZ5fH73ByL8flMQno=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Hyunchul Lee <hyc.lee@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] smb: server: Fix extension string in ksmbd_extract_shortname()
Date: Wed,  6 Aug 2025 03:03:49 +0200
Message-ID: <20250806010348.61961-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In ksmbd_extract_shortname(), strscpy() is incorrectly called with the
length of the source string (excluding the NUL terminator) rather than
the size of the destination buffer. This results in "__" being copied
to 'extension' rather than "___" (two underscores instead of three).

Use the destination buffer size instead to ensure that the string "___"
(three underscores) is copied correctly.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Use three parameter variant of strscpy() for easier backporting
- Link to v1: https://lore.kernel.org/lkml/20250805221424.57890-1-thorsten.blum@linux.dev/
---
 fs/smb/server/smb_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 425c756bcfb8..b23203a1c286 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -515,7 +515,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 
 	p = strrchr(longname, '.');
 	if (p == longname) { /*name starts with a dot*/
-		strscpy(extension, "___", strlen("___"));
+		strscpy(extension, "___", sizeof(extension));
 	} else {
 		if (p) {
 			p++;
-- 
2.50.1

