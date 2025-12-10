Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8FF30EF75;
	Wed, 10 Dec 2025 13:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765375189; cv=none; b=nMeFavNXTgAVW/7N/qY0gF0w0+oWYcZXCVGrUAzx45hzZM9Ya5/geERiaJQgqlpqCkyAQLjf0d4N2qGFFFrCm0Mck9Zi6r5oFcLtKEARXXHPm618tNGeO0Q3RE7X9elf/vWZNMGcxRUaQ/9RbqQr7O9xvlRNH//qbtzsuH66M+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765375189; c=relaxed/simple;
	bh=RebNYuRfoX4Yj8jydBW04p/P8mIT5OiHxq+3RzaFj5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BX+azSbepu/V0a4ku7kk+z9Iv2Qyx9aa2375jdRtP/F5q4OeFsnHLzR46HvG+znSOzhUlY2XU/3OI9qxcU9ByFrlyfCuj8GUPc8ikTF3zY6UzTGERUOeBH8JakcYU46bvYzjjD0ByouHiGJIyj2GCn23KsVvSPKgJ0dUespF+Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=gq7k1J8K; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="gq7k1J8K"
Received: from VelichayshiyPC.. (unknown [77.93.122.67])
	by mail.ispras.ru (Postfix) with ESMTPSA id 1E9CB400CDE4;
	Wed, 10 Dec 2025 13:52:29 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 1E9CB400CDE4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1765374749;
	bh=XKeuBlL4Brmw4J+3EC9u4xqKoy8ajsWzQPA5DOca5/Q=;
	h=From:To:Cc:Subject:Date:From;
	b=gq7k1J8Kdg0hrEmA+MY55xQuEQDocI7DKStPdqc1Gau3lecatDTuLdYovzzy+aWm9
	 HZVuotpxGuQgiYOuaeMtvq4X/syYDRfLuD1Nhe4/Klmqn7aTpBrtSHfA3Nrkn7Dggf
	 5vjhTHv6pFdguggNTJ0gFoCy31yZ2mRS+qH9JB8Q=
From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
To: a.velichayshiy@ispras.ru,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] ksmbd: remove redundant DACL check in smb_check_perm_dacl
Date: Wed, 10 Dec 2025 16:51:33 +0300
Message-ID: <20251210135149.10837-1-a.velichayshiy@ispras.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A zero value of pdacl->num_aces is already handled at the start of
smb_check_perm_dacl() so the second check is useless.

Drop the unreachable code block, no functional impact intended.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
---
 fs/smb/server/smbacl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 5aa7a66334d9..05598d994a68 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1307,9 +1307,6 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			granted |= le32_to_cpu(ace->access_req);
 			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 		}
-
-		if (!pdacl->num_aces)
-			granted = GENERIC_ALL_FLAGS;
 	}
 
 	if (!uid)
-- 
2.43.0

