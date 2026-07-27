Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [178.154.239.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9DE42AF93
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 17:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785172876; cv=none; b=gK1BulH6OkAxZrE8ECUhQfmhkbBz8wqWnUgdC/MEUVWj0fNohpHShwhDcj4lXNKb5R0n7525Oh3cyfLEa5DyMbgF5jN4LxCwKGBZKDg3NylRUY3iLdvtkc+vipyLs+HmWcTgD/F1RUhBBNk00YOZo/CLWSxg8uBuBG8uHG98MJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785172876; c=relaxed/simple;
	bh=+o1+6EycefGK90p/hNogQBe0FJ+DmImFPP5S9cIujvY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kZPW4u+jiloVqECcaye6EMOYiz8oYgTc/xz5FFO5HbRe8HWGrt3+UudDELR5COyZy1Wc/uTwJuaGBqQAbvctw+k7EKhBjzbm0fd5wYQFVsR5HE+SnoUJWCAX1dshOgwGFfC6owIFEUvNSC1x/lx0Hx3D5XA83ZisKWgC79SUzXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=ju8p1ROm; arc=none smtp.client-ip=178.154.239.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="ju8p1ROm"
Received: from mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:1698:0:640:befc:0])
	by forward102b.mail.yandex.net (postfix) with ESMTPS id D454EC00E3;
	Mon, 27 Jul 2026 20:20:52 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (smtp) with ESMTPSA id oKguf1xg6a60-aRRNJ4l7;
	Mon, 27 Jul 2026 20:20:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1785172852; bh=0WXr+S/AYfnhdAFfpdhti8AG+06VFvtFUaUKyS3yheY=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=ju8p1ROmpAUKKdZAk6l2EogVH5Yrz0cJIqLkX5T01/T3XSflNF0QBIamuutZplnDC
	 liMmc9PM0z4GOxlTXldZiQRmDjgtIRfzJ58WTR17P5Ji128O/0dqlJLotlgVximSkF
	 0HZyLe9Pi3aQRsDuOffMHxI/Xm/VGodWmuSrFLiU=
Authentication-Results: mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] smb: client: simplify cifs_fscache_get_super_cookie()
Date: Mon, 27 Jul 2026 20:20:35 +0300
Message-ID: <20260727172035.397713-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid redundant 'strlen()' and use the convenient 'strreplace()'
to simplify 'cifs_fscache_get_super_cookie()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/smb/client/fscache.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/smb/client/fscache.c b/fs/smb/client/fscache.c
index 01424a5cdb99..9f66bbcd3801 100644
--- a/fs/smb/client/fscache.c
+++ b/fs/smb/client/fscache.c
@@ -38,7 +38,6 @@ int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct fscache_volume *vcookie;
 	const struct sockaddr *sa = (struct sockaddr *)&server->dstaddr;
-	size_t slen, i;
 	char *sharename;
 	char *key;
 	int ret = -ENOMEM;
@@ -73,10 +72,7 @@ int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
 		return PTR_ERR(sharename);
 	}
 
-	slen = strlen(sharename);
-	for (i = 0; i < slen; i++)
-		if (sharename[i] == '/')
-			sharename[i] = ';';
+	strreplace(sharename, '/', ';');
 
 	key = kasprintf(GFP_KERNEL, "cifs,%pISpc,%s", sa, sharename);
 	if (!key)
-- 
2.55.0

