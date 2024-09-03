Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429F9187855
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 11:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725363140; cv=none; b=POpw62HgCD4jAmrrQx3a2S24EO/sb6v0SHJ3Q2MiJ3BJMxUoVrgJ4G30Cu2HTfv8xnueK1fxrGl2pPlVdfXvyb9uKZ5184IkTexmsmZGbO0mwRKaGQ+uc8mooStBPRRwl4ZFODSmFedVU5Q5cQcKLpP+A6CsjqXO+UPTgdjtoT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725363140; c=relaxed/simple;
	bh=9AIxAuuz4et+iF2SW/ELNf85ountzQthpvC1Ybg30WY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FOdE69dA89YIAhjhvik/WC4at2mnD1JWy3BGtoEuPvuR1NjYxdkcVHRfw/MQBchLII8KltLyWx7DiNIX++Ntb+8vsDZni3f5QZMhXdPA+N7Ib5y0DSzR2K5uBf/IdIplND++hSVkv8hDeuQrNdhh+VZ5fKhEcMx+zvzV1ljAhMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7143ae1b560so2736971b3a.1
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2024 04:32:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725363138; x=1725967938;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vRRNislgXMooCIGiRYk2PtdvP83YlGLIFuT88kzom30=;
        b=ONTC29qU1aqYznFOm10dUeyRZFC9jIYmPC+J/MiFEv/trksEAXTFuopVIXwb1X7/t/
         urT/6FDN2N5vROwNyJkL1rW3oAlytVg5eWU4bmbx3i7Wk6ZhYD7pLsra/xzcPfna1T0K
         UsJ54FAswmtVCukdcnqF8Il2ZUbnfTTQJFDkNh5xA9RtBWquxlIvaa7EGXPh8ksR2QqM
         vAyVCQBJ5zK6l4MNktrg4p2/G4Gj7kDOiJEUhYh+Z4FnbVF9HB0juKUSXyqEVXYdth2U
         lYAuphIapp8UHdnfGQgm6dCAVM4rnuHhg8K2D+VIml4UkxXzXdxXANGcHGDE2oWDJDeP
         EiBA==
X-Gm-Message-State: AOJu0YwqdbBt9BqH7GkM1fm/a3/FUpmC+rDJW1UAoLVXPtyHGl0pw79G
	0z/ihRgfxv7uXSSKsoq7BQL1aAAskhk9wSSPNHzU/8Q0Dsw+3oAcASHxRQ==
X-Google-Smtp-Source: AGHT+IFxYLOx7bJuKDXUN2ZhBkrW+miTUu+dvgeB/8vGUwPMswucKJR1G3rfa0afRIc/5eIDptgkzw==
X-Received: by 2002:a05:6a00:2345:b0:714:2d05:60df with SMTP id d2e1a72fcca58-7173c30f3c6mr11203585b3a.15.1725363138097;
        Tue, 03 Sep 2024 04:32:18 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-715e56d8889sm8574021b3a.143.2024.09.03.04.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 04:32:17 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: allow write with FILE_APPEND_DATA
Date: Tue,  3 Sep 2024 20:31:46 +0900
Message-Id: <20240903113147.6886-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Windows client write with FILE_APPEND_DATA when using git.
ksmbd should allow write it with this flags.

Z:\test>git commit -m "test"
fatal: cannot update the ref 'HEAD': unable to append to
 '.git/logs/HEAD': Bad file descriptor

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 9e859ba010cf..19900625d5d2 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -496,7 +496,7 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 	int err = 0;
 
 	if (work->conn->connection_type) {
-		if (!(fp->daccess & FILE_WRITE_DATA_LE)) {
+		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE))) {
 			pr_err("no right to write(%pD)\n", fp->filp);
 			err = -EACCES;
 			goto out;
-- 
2.25.1

