Received: from forward204b.mail.yandex.net (forward204b.mail.yandex.net [178.154.239.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF0172604;
	Thu,  4 Sep 2025 12:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756989250; cv=none; b=mNh6XkhxorUnPuQQOXq7reiE0Y5OiQOTaHtjQ81Ng4tZ+fqJDEFrt7KlX6K2nHtKEmOP/sJ7YmZEoorKA5L3Shs+J3MCINImIxkDMwySc1HUqGx77mTjbzufp18D5G/zlsVApuf2ERZ3CSW3Gobj6Te9mWNYFul1XLweuEHvi0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756989250; c=relaxed/simple;
	bh=vwm7GGsrLL/OVj0CpPOITZLD/fK5xL4QobL+2xI45HA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nJgI0CEFQDfjtnW3LUYs4o3cNSMuv3z33c15ksWpPr92/f3KM461E3SPoWLoSNGsB3fBYFb+Hx6Opslt9hO0eRsEU6I9M9KUHRpP5s1isX511Gs0qa468zhUGj1isNpOiepXetLisguKok3w8vgV+yhVMl1z7teYs8V9rMvEH9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tssltd.ru; spf=pass smtp.mailfrom=tssltd.ru; dkim=pass (1024-bit key) header.d=tssltd.ru header.i=@tssltd.ru header.b=K17XNy8E; arc=none smtp.client-ip=178.154.239.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tssltd.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tssltd.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tssltd.ru header.i=@tssltd.ru header.b="K17XNy8E"
Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d103])
	by forward204b.mail.yandex.net (Yandex) with ESMTPS id D330783B36;
	Thu, 04 Sep 2025 15:25:57 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-70.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-70.sas.yp-c.yandex.net [IPv6:2a02:6b8:c1c:2e14:0:640:43be:0])
	by forward103b.mail.yandex.net (Yandex) with ESMTPS id E7FE6C00E9;
	Thu, 04 Sep 2025 15:25:47 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-70.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id VPgvX4AMwW20-OKyITQBl;
	Thu, 04 Sep 2025 15:25:46 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tssltd.ru; s=mail;
	t=1756988747; bh=DSMtOUnaIgJT+68cQ7DFikj09QnC79n67WWGzOI7FMU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=K17XNy8Eueq73JoE8kjsPtJqZAyAIufzZNax7aKR/XI+T0k7s7soCinHY7aRj47ej
	 9VqBhs7dQhdFME07f0OfWWosFvGkaS6l4vT6Nix1YiLEw0YBEG+Qu+08Sp7Ks0IGGs
	 I4E6sO916wrsR17N6jPnCJDhVnA9K2fwpRzhvMJA=
Authentication-Results: mail-nwsmtp-smtp-production-main-70.sas.yp-c.yandex.net; dkim=pass header.i=@tssltd.ru
From: Makar Semyonov <m.semenov@tssltd.ru>
To: Steve French <sfrench@samba.org>
Cc: Makar Semyonov <m.semenov@tssltd.ru>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cifs: prevent NULL pointer dereference in UTF16 conversion
Date: Thu,  4 Sep 2025 15:25:12 +0300
Message-ID: <20250904122515.1680767-1-m.semenov@tssltd.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There can be a NULL pointer dereference bug here. NULL is passed to
__cifs_sfu_make_node without checks, which passes it unchecked to
cifs_strndup_to_utf16, which in turn passes it to
cifs_local_to_utf16_bytes where '*from' is dereferenced, causing a crash.

This patch adds a check for NULL 'src' in cifs_strndup_to_utf16 and
returns NULL early to prevent dereferencing NULL pointer.

Found by Linux Verification Center (linuxtesting.org) with SVACE

Signed-off-by: Makar Semyonov <m.semenov@tssltd.ru>
---
 fs/smb/client/cifs_unicode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index 4cc6e0896fad..1a9324bec7d6 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -628,6 +628,9 @@ cifs_strndup_to_utf16(const char *src, const int maxlen, int *utf16_len,
 {
 	int len;
 	__le16 *dst;
+
+	if (!src)
+		return NULL;
 
 	len = cifs_local_to_utf16_bytes(src, maxlen, cp);
 	len += 2; /* NULL */
-- 
2.43.0

