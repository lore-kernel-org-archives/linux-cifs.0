Received: from forward200d.mail.yandex.net (forward200d.mail.yandex.net [178.154.239.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16E97E792
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 04:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786681358; cv=none; b=jNtrXQqNxn0k70S7mGtTJ7kZDxAAhDo2PBbdulsvM+QVHpdMOZkOR9FB1glgf2VK2RAbop8F/3jxO18FQiJhm4Y/E11dmQQ7vHcV27BNvXFmOfn8DEKzvl3B35jNaKxYxdCq2rzz5nf0vZdpJHxFoqqSI9OobFxwuL00/NLIDSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786681358; c=relaxed/simple;
	bh=w8uY1H+FuKwM3r1apqdcRe/T/hUyeXNJCH8meQWm82w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uf02RPdFWA4lGswGJjwGcm6YUZnHOe9bFTyQTuiIwm2PuyIyAP8Adq9Uya5qGax6XxWVW8ox/FW0yKSLM2vTukbKzFGZ7ISMEX0WU1IZXq9UA/ldutBbjW0z01lK5xidQXdy57eMkBz5fd9UPkWubIlAWJsXSJgpwDYBxK9pMi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=HYO7IDx2; arc=none smtp.client-ip=178.154.239.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="HYO7IDx2"
Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d100])
	by forward200d.mail.yandex.net (postfix) with ESMTPS id 0DD5F82331
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 07:14:44 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2007:0:640:5fb2:0])
	by forward100d.mail.yandex.net (postfix) with ESMTPS id 6094EC00F7;
	Fri, 14 Aug 2026 07:14:36 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net (smtp) with ESMTPSA id YEIvoxTdVSw0-h0IQZOML;
	Fri, 14 Aug 2026 07:14:35 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1786680875; bh=HCFdOdBPVzriDwSFuRgpAUSPz9BpigNjfsNM1HiM8oI=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=HYO7IDx2K65jdG8bFhNqF1ZvJzUch4zMMYVMb3a0LqI8l9APuoV7MO1b0ZGic8vwm
	 GCRMtOGXHLD0DYZP58AAlBxe4VmWSY0Vv0oUi2on7P4d+yO4SJtQtzZuYiGuacZ6xV
	 /KrVYHOKAyG8GOs/rg0Ua3HobhnCtjXGXuSTGwB8=
Authentication-Results: mail-nwsmtp-smtp-production-main-77.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] smb: client: simplify __build_path_from_dentry_optional_prefix()
Date: Fri, 14 Aug 2026 07:14:18 +0300
Message-ID: <20260814041418.1216774-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the convenient 'strreplace()' to simplify
'__build_path_from_dentry_optional_prefix()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/smb/client/dir.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 88a4a1787ff0..e966526a7e2f 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -115,11 +115,7 @@ char *__build_path_from_dentry_optional_prefix(struct dentry *direntry, void *pa
 	}
 	if (dirsep != '/') {
 		/* BB test paths to Windows with '/' in the midst of prepath */
-		char *p;
-
-		for (p = s; *p; p++)
-			if (*p == '/')
-				*p = dirsep;
+		strreplace(s, '/', dirsep);
 	}
 	if (dfsplen) {
 		s -= dfsplen;
-- 
2.55.0

