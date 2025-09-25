Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C764F2FF669;
	Thu, 25 Sep 2025 12:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758802449; cv=none; b=bYeWsWEKmiDv5Gm6MCPX1UUf/pennl32JcW1YVeuaN9VOe9a2QQOPwos5+oDSGTZoYtjW3DrAcmOjfWm1dkU2cPF76GzwD568Y1Iynt5aXPbbb2zAApP1ncSjXEdlNp6Z9alz4oy25pOM3p97wOie3g0fXY2iBFnvHMQNp+I26c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758802449; c=relaxed/simple;
	bh=h6H6ZhBZe1gKHmrNubWc5sUylhRVOXzZrHkkLa0lGmY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oTl1frbLHWkf1JdWoJKfqdrVdy6CHIDCjqf4mEQNO6d04VmKT+a2XKlRhOTln8D/P6AvrfbPlVCYmBZ1tn4Ze3G+aGaXVb/9n6THIwRy4Z/ffvBNGLkZy0BbthGBEyfKhw477SunRZXAnE/QL7gmKKY7hatHg9K281x5px0DqAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=knIl4HKq; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="knIl4HKq"
Received: from localhost.localdomain (unknown [178.69.159.70])
	by mail.ispras.ru (Postfix) with ESMTPSA id B7AC840A327F;
	Thu, 25 Sep 2025 12:13:57 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru B7AC840A327F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1758802438;
	bh=2EVHtjacVStoLork7wasnNmEVZ79Lr/9XpsbjrB7eNs=;
	h=From:To:Cc:Subject:Date:From;
	b=knIl4HKqaY0s6G0NSAM2HxjkVhzFpA/5HTSdLKOvFZsClpI2sxMITnXQHsTQbWzcx
	 ztXQB99p2WXyKSHHSa6P8m0QpPiknIGoXo0r2NbH6jjiTO5rqNMH41mxikeN0XTGds
	 X2O21CPWLMR07Tj4cfXfbxh0cg8Oj7bsHNcli4PA=
From: Matvey Kovalev <matvey.kovalev@ispras.ru>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: [PATCH] fix error code overwriting in smb2_get_info_filesystem()
Date: Thu, 25 Sep 2025 15:12:34 +0300
Message-ID: <20250925121255.1407-1-matvey.kovalev@ispras.ru>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If client doesn't negotiate with SMB3.1.1 POSIX Extensions, 
then proper error code won't be returned due to overwriting.

Return error immediately.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e2f34481b24db ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Matvey Kovalev <matvey.kovalev@ispras.ru>
---
 fs/smb/server/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a565fc36cee6d..a1db006ab6e92 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5628,7 +5628,8 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
 		if (!work->tcon->posix_extensions) {
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
-			rc = -EOPNOTSUPP;
+			path_put(&path);
+			return -EOPNOTSUPP;
 		} else {
 			info = (struct filesystem_posix_info *)(rsp->Buffer);
 			info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);
-- 
2.43.0.windows.1

