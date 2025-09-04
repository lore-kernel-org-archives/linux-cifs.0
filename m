Received: from forward206b.mail.yandex.net (forward206b.mail.yandex.net [178.154.239.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203512F3C01;
	Thu,  4 Sep 2025 12:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756989347; cv=none; b=ofOMajjGSwMWj9iOVDl2SwN/PqOdMkBw45RIARkwu9QUVYd71TBWtNfR3CN1DMZfzj7KOnBA7zSazaeuxOPVC8Ps7UtQEh0gKOl8B+7/sU8Ze7IsvGrSKycTEl0uREsqxJDSLfUgCqTZqR+ply8O6Wf+NaqOjjgp2KaQOQ3g378=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756989347; c=relaxed/simple;
	bh=vwm7GGsrLL/OVj0CpPOITZLD/fK5xL4QobL+2xI45HA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d+M3XMYl7fkNtKe7LJ3Z1a/+u0WOxqP/4sl9p2U27+MoBMDxIy24edu3gYaiK3Vkaqiw3bIUq0UNDMbJHjFdHCn1Yf9NyCGYZEdP2lF9R+oaWWi52uT09zxX3K7K4XIT+EqCKKJ7g7WFDJUmz7xGRc6QviLP1vQIxjeQadXI0Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tssltd.ru; spf=pass smtp.mailfrom=tssltd.ru; dkim=pass (1024-bit key) header.d=tssltd.ru header.i=@tssltd.ru header.b=nGIPwpbA; arc=none smtp.client-ip=178.154.239.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tssltd.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tssltd.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tssltd.ru header.i=@tssltd.ru header.b="nGIPwpbA"
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d100])
	by forward206b.mail.yandex.net (Yandex) with ESMTPS id 81D81829E9;
	Thu, 04 Sep 2025 15:29:21 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:2f3c:0:640:7ca0:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id 2D5F680711;
	Thu, 04 Sep 2025 15:29:11 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id nSgbpT5MRW20-C7MjhCiI;
	Thu, 04 Sep 2025 15:29:10 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tssltd.ru; s=mail;
	t=1756988950; bh=DSMtOUnaIgJT+68cQ7DFikj09QnC79n67WWGzOI7FMU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=nGIPwpbArRkGpB8XlgmJiSHi+WtV62qHtPdgU6VY/rFLCdynS1APKaCQcc99sEJVp
	 3rwhOAQzKcsJPisdhVlrD00dBh8bALkYFMJ1+DHLvLCaEJas3C7PmLH+E6I3b/6eJP
	 IyVdKXcugxdrsPTcdJhKQzxxAzLrYPYP8wGYZsvg=
Authentication-Results: mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net; dkim=pass header.i=@tssltd.ru
From: Makar Semyonov <m.semenov@tssltd.ru>
To: Steve French <sfrench@samba.org>
Cc: Makar Semyonov <m.semenov@tssltd.ru>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cifs: prevent NULL pointer dereference in UTF16 conversion
Date: Thu,  4 Sep 2025 15:28:41 +0300
Message-ID: <20250904122843.1681269-1-m.semenov@tssltd.ru>
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

