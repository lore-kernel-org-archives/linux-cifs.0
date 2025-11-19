Received: from forward203d.mail.yandex.net (forward203d.mail.yandex.net [178.154.239.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20578352F9E
	for <linux-cifs@vger.kernel.org>; Wed, 19 Nov 2025 11:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763551270; cv=none; b=BhKba6J0799SzIZG1mRZk2WNkhkGEifQ0AdwtXcQLmbyhF1gw8hCaRwktWIuQWhuG2e1fvk83bDKv8yj5pNpePtKwwWVkQ0PNWLP9UqaMFzOTJQWusl28RTggB7gaa6BIVz2C8Dz+jw4l6mYE55cN+cB4BIP6JL+FJ5L32apYbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763551270; c=relaxed/simple;
	bh=8rOgBh6kdEDTlVkWKXrhGIvNXCf6sFcBmRPRI5HDzxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RcV29RXMO9CMg1KlbiNm4gw0Tk5dtnfCR7I3MYgJU1w6GR4boaZZEGeBrW6VABda6nrvulRWq1cZE0ENby5AwWNYn0WGN+rBdGhwVYWR2xzii0QqoA9zoKACmOG2qCl1X7vDcpW7AexGDPIpPqfacvwY9c2wI5H8yo6xaF8XAb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=ZXlX3Nwq; arc=none smtp.client-ip=178.154.239.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="ZXlX3Nwq"
Received: from forward101d.mail.yandex.net (forward101d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d101])
	by forward203d.mail.yandex.net (Yandex) with ESMTPS id 852108AB1B
	for <linux-cifs@vger.kernel.org>; Wed, 19 Nov 2025 14:13:09 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-80.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-80.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:3cca:0:640:f0e1:0])
	by forward101d.mail.yandex.net (Yandex) with ESMTPS id 9EF13C00BA;
	Wed, 19 Nov 2025 14:13:01 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-80.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id xCUT8UEL9Cg0-24KusPNr;
	Wed, 19 Nov 2025 14:13:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1763550780; bh=Mi6xNYQUd1z5dpoBbjwo9JiXQTVZqDMMG1YKBl6QDs8=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=ZXlX3NwqqevxjRx7nAnpRklJw9CzEdwwJ8lfe809DNPC+ZEoCqtHzGBSy6f7BrMAS
	 aiBU9Je4taSpnPTc/Dn8v2EmuXojn4VmJMiojQHQI0/koNoRkwhhUMpAg+XK0M9W5E
	 pFbJUQkTXH9UtJ7U6FPP58z0pCPk1CeIG++Sshq0=
Authentication-Results: mail-nwsmtp-smtp-production-main-80.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] cifs: avoid deprecated strcat() in smb21_set_oplock_level()
Date: Wed, 19 Nov 2025 14:12:57 +0300
Message-ID: <20251119111257.19400-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not use deprecated 'strcat()' (which is redundant to build the
string character by character anyway) in 'smb21_set_oplock_level()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/smb/client/smb2ops.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1e39f2165e42..2f8ddb0836f9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4087,7 +4087,7 @@ static void
 smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 		       __u16 epoch, bool *purge_cache)
 {
-	char message[5] = {0};
+	char message[5] = {0}, *p = message;
 	unsigned int new_oplock = 0;
 
 	oplock &= 0xFF;
@@ -4102,18 +4102,20 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 
 	if (oplock & SMB2_LEASE_READ_CACHING_HE) {
 		new_oplock |= CIFS_CACHE_READ_FLG;
-		strcat(message, "R");
+		*p++ = 'R';
 	}
 	if (oplock & SMB2_LEASE_HANDLE_CACHING_HE) {
 		new_oplock |= CIFS_CACHE_HANDLE_FLG;
-		strcat(message, "H");
+		*p++ = 'H';
 	}
 	if (oplock & SMB2_LEASE_WRITE_CACHING_HE) {
 		new_oplock |= CIFS_CACHE_WRITE_FLG;
-		strcat(message, "W");
+		*p++ = 'W';
 	}
 	if (!new_oplock)
 		strscpy(message, "None");
+	else
+		*p = 0;
 
 	cinode->oplock = new_oplock;
 	cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
-- 
2.51.1

