Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE41F2E093B
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 20:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764016932; cv=none; b=Lx3YWZ9kD8KV2t2CQEP3WILjCgRwTEGM+065XjzLQskOY+E+eNnJPeOu+UX+5McLuWfGQ99MBdM6MtYN7WvvYUmJWMDGmiZVhw/8yYby/BQk65pLNOCHswy7em07YMfr26NYHTFSAs7UVvVr4Ni90QsXESeepp3dWl58ug3AcU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764016932; c=relaxed/simple;
	bh=f3vGzE4DnxVotYJfKGhVEP3ajga8hb5ViMTlivFbRYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VImHBaGNaPws17Yj5wJm3eg+RlMaE/fC4hI63+hWrCqiTN+j/8MJ3LEKW5TbEnFU4xbD3v+7uODznWTS1F67A1oRvBd6Ak8Md6s1aW2Z0kDQaUlOVR7DeK4EEQqLYxIFGRb9+nak3UX4dFdQh4ItMvI6INBuzcD5JWKXEZ+PaMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=UiMk7sLj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UiMk7sLj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=WsY6RKPrC3cMsQYr2AyxREi+VSSiGojNgEpbR+NstlQ=; b=UiMk7sLjP5ZQAUJHvUbIn8H7GY
	YprLoOz2Bbz0AT2QCC9gAGagJtlVqMgAru387GvgoM0IOJ7xUO+ICiLbrrNtYFu4EJ7FpYPjVrfda
	Zw8D5kkc9S9OnCPfO4w4YuSG4I3/7DmwXlmoXAnFQrI09hSyPltsrxBDzdZY+9rnPNyEANX82u9/F
	22RZ7rgv+vlXUCVQiuxAZPx8omhH+O5NBlerrmqdhDxPbuEL90ZFTPGbvE9uBFBnX06GDE+MNKf/R
	jatQmxn43YeggjF22WtOcGJ/ANoWBHBrcvvpg7UvN+L0cuscf9dT57MQaW5jNgJ1rZBcFy7UVIbqQ
	G6LHZwAAI04o3J2BOwphap2fvV+GAATaAmXC87xrWzPdy2OnVgw+gYYwJcGhl66c0Jd3K7rCVphQ1
	gblrNLykbo026GOLiQNh6AJQbtddnX/Hxv8c+Ty/aFILbK3c6TXW2m4/fhgcBNPsK7yzi+ew/tuCf
	DnRx8pbkGLuMJlPbHl0zy76t;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNdNt-00FSW6-0Z;
	Mon, 24 Nov 2025 20:42:05 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 1/4] smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
Date: Mon, 24 Nov 2025 21:41:44 +0100
Message-ID: <ec95c47122e0376afec06c63ffc6d238afb9b3b5.1764016346.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764016346.git.metze@samba.org>
References: <cover.1764016346.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This can be used like this:

  int err = somefunc();
  pr_warn("err=%1pe\n", SMBDIRECT_DEBUG_ERR_PTR(err));

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index ee5a90d691c8..611986827a5e 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -74,6 +74,19 @@ const char *smbdirect_socket_status_string(enum smbdirect_socket_status status)
 	return "<unknown>";
 }
 
+/*
+ * This can be used with %1pe to print errors as strings or '0'
+ * And it avoids warnings like: warn: passing zero to 'ERR_PTR'
+ * from smatch -p=kernel --pedantic
+ */
+static __always_inline
+const void * __must_check SMBDIRECT_DEBUG_ERR_PTR(long error)
+{
+	if (error == 0)
+		return NULL;
+	return ERR_PTR(error);
+}
+
 enum smbdirect_keepalive_status {
 	SMBDIRECT_KEEPALIVE_NONE,
 	SMBDIRECT_KEEPALIVE_PENDING,
-- 
2.43.0

