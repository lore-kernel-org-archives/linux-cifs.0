Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B9A22156A
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764337802; cv=none; b=Y+1YglHuxk8AVNym4y8efPvXgirk8kXYtTrQ+cScMSMT4cElIsUu+OYp9eQ31JI2C0FtiHm7aFOMLLTBYZhndirXEFcM4oPKAgqegdFI8G1Ri2QEFPViUZgd2KOQUGeNZC2aG5EupIb0CEYkXR55QEpyw2/DsHmy64c+W1WQN/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764337802; c=relaxed/simple;
	bh=LUGxzwdyfbqsyh7Z+kGxgvJ2uUbrJDc4uhnSRiTXrbE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kHk0F0opW58+hUw+mfwm7+FOA/sKmRGRzciHoh/02FVsWmKAoe8AZeoyYqSsF7OUDDnlY+XJ5Xb3JSClK0UunrETFT4IL+FKjrynoDoOZsnJgLCNX2KrflxxWH1UJNIw3FkWAAiIV1wb0d0yEElFlF8W4zU3XSTpaclwniR64Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=eu3rOJnl; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="eu3rOJnl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=t1+PK9VnGZvCZHbEcDo4QTE4lHc3Q7EfeGH4nuGiFHM=; b=eu3rOJnlUAsMpaNhTiaY/2mYU9
	2/1NLnQgzoXmBJo25nwcqnALd9M503ZJ3TAt6pScWj/iAg4yip6GoD/PWxSDUePXjSDdf/YfURZd6
	X9P/15H5HobwKftETuswM+JB+/g7yrhQZQpAb7rMjUIMgx41y6pHXPA5VMxhJjxX+290oA75h/1SH
	4wBD/mHtU3O3tTe2FvWD6Jxvc3gU6zWs8uCgw7+zfpzhJEK30vla9M2MOhdXKMqvXAHKaoXJIc/Vn
	gTew4EtFMcU7avnlO9E9W4UHIL7d6saSF7rf9BrD7YOphrcnPfI4vc8BpjT9RmKn/+BAz63RpUicE
	4Y6vNUg3BeeEP0XdJTltNswf3oLV/rzqD5gLs3EiKK2o4la46uiDCTViz/0PnTv5HP1+Bo3f9CNyr
	0RY2kHtmxyAIgA7Puw0/Ho2emyCPZjRZYu8ZEvZyLT2DRJfp5kGlJ7lrFAM/oeT+INnqk5DhiZNgN
	a5WA/CpBttyjN3kkHLeZP0LF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vOyrF-00G9HC-09;
	Fri, 28 Nov 2025 13:49:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] MAINTAINERS: change git.samba.org to https
Date: Fri, 28 Nov 2025 14:49:51 +0100
Message-ID: <20251128134951.2331836-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the preferred way to access the server.

Cc: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 047d242faf68..d55c1c263e71 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6179,7 +6179,7 @@ L:	linux-cifs@vger.kernel.org
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 S:	Supported
 W:	https://wiki.samba.org/index.php/LinuxCIFS
-T:	git git://git.samba.org/sfrench/cifs-2.6.git
+T:	git https://git.samba.org/sfrench/cifs-2.6.git
 F:	Documentation/admin-guide/cifs/
 F:	fs/smb/client/
 F:	fs/smb/common/
@@ -13611,7 +13611,7 @@ R:	Sergey Senozhatsky <senozhatsky@chromium.org>
 R:	Tom Talpey <tom@talpey.com>
 L:	linux-cifs@vger.kernel.org
 S:	Maintained
-T:	git git://git.samba.org/ksmbd.git
+T:	git https://git.samba.org/ksmbd.git
 F:	Documentation/filesystems/smb/ksmbd.rst
 F:	fs/smb/common/
 F:	fs/smb/server/
-- 
2.43.0

