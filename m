Received: from forward103d.mail.yandex.net (forward103d.mail.yandex.net [178.154.239.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EBC27E7DA;
	Thu,  4 Sep 2025 12:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756988308; cv=none; b=mwEeKu/yygdOqFJyDGuUd2cEeqw4beNxvzPYTgVrHH5g+Hfnc+kHqnczMZdegIUqExEchQe/VIPyYt6f+von2wp1debvEWEC7PAVDz+6H/EypDUHujPw6uWtj+RlSmyOloIPq/Z/uBI55dsw/Mw17HojinWp1n7JcaAkwstyx+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756988308; c=relaxed/simple;
	bh=nWLD3219mEX9eLoMharp+SAPmuPOFJVNtzN3FzCNCS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U3VD2DrOaPAXlLV2whemTRdPU0ATfxce0cpNccKO+jyqgPchJVXfUEMh4fU2va43yFT87Zzv8vmC8d53idYZLqpkfuq2zB3eZa2KIeKGaGkBqal1pFSCXWZ4LlrZFR3xciyAW1SzsWXandYJnFVcXGKYdBy5nupWlp1+isA8bWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tssltd.ru; spf=pass smtp.mailfrom=tssltd.ru; dkim=pass (1024-bit key) header.d=tssltd.ru header.i=@tssltd.ru header.b=Wx+sKZAy; arc=none smtp.client-ip=178.154.239.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tssltd.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tssltd.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tssltd.ru header.i=@tssltd.ru header.b="Wx+sKZAy"
Received: from mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:37a7:0:640:7089:0])
	by forward103d.mail.yandex.net (Yandex) with ESMTPS id D169BC00DD;
	Thu, 04 Sep 2025 15:18:15 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 0IgxvuwL08c0-U9d5OJpp;
	Thu, 04 Sep 2025 15:18:15 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tssltd.ru; s=mail;
	t=1756988295; bh=VXTyxlvyxZgPwuZeJnsHDe9e+6Oi1CMf/DpK5r1q3P0=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=Wx+sKZAylqd8SrjaIFODzGb1yOQhgYyveOgIQ2NemiehsVOjz35bQfq3GkqfRPbH9
	 CX2RpVTChLdPifVssguWyrSQNt/C/P7GIcM41Z9e/aUSI2yLQC5KZ+zIIsN5D1Z76Q
	 3v4innOwloM0NruZdELfVwnjOP0wJ6k6aQA0zR6o=
Authentication-Results: mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net; dkim=pass header.i=@tssltd.ru
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
Subject: 
Date: Thu,  4 Sep 2025 15:17:54 +0300
Message-ID: <20250904121757.1679560-1-m.semenov@tssltd.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Date: Thu, 4 Sep 2025 15:00:27 +0300
Subject: [PATCH] cifs: prevent NULL pointer dereference in UTF16
 conversion

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

