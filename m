Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B780198E91;
	Sat,  5 Jul 2025 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751731047; cv=none; b=XCGA9qqb6jJ+2AgMj49q/Aqn28sMbHI/AKKCVjF5iiw3PHFsg1uvboQoa/Up8XOENP2CtwiTJEJFAsccRN+AtEb3Z4JaUq6k5fUVZ+0wPn0VHsaYQcU81j4SEyz7S0p/dxNprKou6wmy68OD/1ueVLkNL1pEgVFvTpU7WdsOn/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751731047; c=relaxed/simple;
	bh=Gt1eKTa6tIxKurKrdxjpWEUs1JtVLd/hrzYlnIwvltI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DERF4z1rZR3CgiSH/HNyIpWTw2Pv/HfXdO+8YQ+YwaiXEBQcXk/O57wSffSnCrcDXwIfPIWt/JQRY16tDxei0tKBu0kWDlpEqyd4GUsGj7pDfqoibELtr2jHvrM2Ac89Dw2gQUl5eRk2b3wTUs8xxi1C4dTRuQon7QewyeF4SaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WOVARa+C; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WOVARa+C"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-749248d06faso1458969b3a.2;
        Sat, 05 Jul 2025 08:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751731045; x=1752335845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=afPSfC4kVbMqCL3ZhWKf3H6Etjj2i6ZPDF9rDxYtYWg=;
        b=WOVARa+CG65xzgtVCSzZbFb7kmEi2REFJBK0I7FfihFGu8CXaeW5Eek2fTVV0zCr13
         5Vs2nOiHatKi5o5/YIeRpoDTowjHI/uZa0JAq5h4sp4dltkRH2N4P8aK4YfiWhQEN2Lk
         du1QcysTNbmZM3me2KXQ/5tzGqOMVQUx+eS2SaLYyT73kUhRhEZNy4WtO4XmVBXFVMkJ
         d3Q9pJ5Gmj2inSAWuBH8dHkX71ejyPu1DZ9+gkY6DlTp1AkGAQGCHINpILJ1mEXcQ6FH
         jWD757oKqbl+E1SiNBVReNPX8jlY55mu4QQHqErjkqRDpHwhyerM2eEBPiNPnSqKETeP
         Wqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751731045; x=1752335845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=afPSfC4kVbMqCL3ZhWKf3H6Etjj2i6ZPDF9rDxYtYWg=;
        b=vj/6pZHVqM+nW+ST1RkKC4aVtPHCVY6UzO1Uvscv1/S1K2C6GI1nQO6wYrBgb794H7
         wwb7hs2U7aT8JT9qkIzzUBnYygcgljcZwhlIdq+8Aev058p7cXkwKu+z+czNJ4pQjJZZ
         i7sV0bUTC2/AN4KGc0clNx3+KcHnWHwYh9drKnEDsnN2KJU9OusfUbZl9rIfMN951g/y
         CwN7rg8UwnOnomfxNTdcW4yVECCwnipwmLhZ2ijLlOze49fX7DB7y+hu99dADhnV9kER
         mfeHugx9EfNbUiEJJQDrPq7HAmChlpNZ9oEX8jD/0C7enQDs/hAfXXDVkj7uCwp63t8+
         /RRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2qcq1JcmD31pzteyNj3tHTbKdsT01qdR+9j0k7guHOYabcGyGSTpey9TyXZHy30y0N0lTsD3bqKXxtFtO@vger.kernel.org, AJvYcCVKSb45FMXqmr8KVJ/bxbnMaKz2nb1ZE4jTPtD4uuv1uzPi9TAlzprvheJeDVyFZccSg7lY2rZ6MPST@vger.kernel.org
X-Gm-Message-State: AOJu0Yx32mYc95KEGx7nWPD9vr2u8XxfP0NX66bcuxJWs8jER5sEKGQd
	yLXkX8Pl+4EcyAqZWW6Dac0F/+KmylXl1EpTVe91OUWBhVVxhmeZTd++
X-Gm-Gg: ASbGncuvnFyfSVwlPLhzWUQiRUzfeTA4wVJ0I/HtNVvBOBuYO81Wyi2Kj2LJDFZHa+r
	aIULun2Kui6xt9Q9qky6pU+EbegBLGirUwKIY6nrAG4L0UCVhmbNw2EEl3Zsj6mgWDKTvKpPZAj
	ClZ3ksBKKCz3BuUZ4xPcapFJYxJY2SbTRcw/g25riVSg4xuPfPHoRcAFoRKDnTt0PYa2ofiX2cd
	0dP+AqzXgjsLLYN6GD0jSu3KvdPHqmkfFGaOyFJ1n0QIOpbJKhQSy/TO+KxhheAK22N7suLXdiC
	hyMUudfddBNlLOyQEeonSe4yPljrhmEj5HwohANb2vbJiZ/Dw6z5VeXSEnGty/uMyZvcE/Io46S
	+dbP+rhNDCZDxlGI=
X-Google-Smtp-Source: AGHT+IGQceXr4LoeHtkNDedzNiN7bq81/QO67YRemkiM9QgZx4aV68p++p7C6lvxIBFPx5clI3QR1Q==
X-Received: by 2002:a05:6a21:699:b0:222:d63a:249d with SMTP id adf61e73a8af0-22720cbab8dmr4386269637.20.1751731045364;
        Sat, 05 Jul 2025 08:57:25 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:882f:293:70ba:30fe:2559:8217])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee450ce1sm4603799a12.11.2025.07.05.08.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 08:57:24 -0700 (PDT)
From: Abinash Singh <abinashlalotra@gmail.com>
X-Google-Original-From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Abinash Singh <abinashsinghlalotra@gmail.com>
Subject: [PATCH RFC] fs/smb : fix build warning in cifs_open()
Date: Sat,  5 Jul 2025 21:27:14 +0530
Message-ID: <20250705155714.805067-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function `cifs_open()` triggers
a large stack frame warning:
ld.lld: warning:
	fs/smb/client/file.c:949:0: stack frame size (1032) exceeds limit (1024) in function 'cifs_open'

Fix excess stack usgae by dynamically allocating `cifs_pending_open` struct.

Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
---
It only reduces only 40 bytes.But we can reduce it more
by allocating other structs on heap.
This is fine if this function is not performance critical,
Is it ?

Thank You
---
 fs/smb/client/file.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index e9212da32f01..818a3c1e6c72 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -959,9 +959,13 @@ int cifs_open(struct inode *inode, struct file *file)
 	const char *full_path;
 	bool posix_open_ok = false;
 	struct cifs_fid fid = {};
-	struct cifs_pending_open open;
+	struct cifs_pending_open *open __free(kfree) = NULL;
 	struct cifs_open_info_data data = {};
 
+	open = kmalloc(sizeof(*open),GFP_KERNEL);
+	if (!open)
+		return -ENOMEM;
+
 	xid = get_xid();
 
 	cifs_sb = CIFS_SB(inode->i_sb);
@@ -1057,7 +1061,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &fid);
 
-	cifs_add_pending_open(&fid, tlink, &open);
+	cifs_add_pending_open(&fid, tlink, open);
 
 	if (!posix_open_ok) {
 		if (server->ops->get_lease_key)
@@ -1066,7 +1070,7 @@ int cifs_open(struct inode *inode, struct file *file)
 		rc = cifs_nt_open(full_path, inode, cifs_sb, tcon, file->f_flags, &oplock, &fid,
 				  xid, &data);
 		if (rc) {
-			cifs_del_pending_open(&open);
+			cifs_del_pending_open(open);
 			goto out;
 		}
 	}
@@ -1075,7 +1079,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	if (cfile == NULL) {
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
-		cifs_del_pending_open(&open);
+		cifs_del_pending_open(open);
 		rc = -ENOMEM;
 		goto out;
 	}
-- 
2.43.0

