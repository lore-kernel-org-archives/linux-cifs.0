Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403ED190674
	for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2024 18:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734373922; cv=none; b=azqGh6J5+zyWG4XFH3Ab26TeuEl9902R6rv21tVnJmIlvhG93a94AygBQ2hyknsGgwwH62YxovlHE5Mg2ll07qZ7md558qkrliGKClB5G9sj+AyuPmwtiT5g5Bmj99VldWhAThI0z6jBaiHObvVYbmkF91dJSwEcUkJQaPV4AVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734373922; c=relaxed/simple;
	bh=a9JfPJzYopSNL6rXFJo5c5DzJyJOBzrPC3dI9BI69q0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cQ1CLoJpOuyWbrA3imLnJVzI5F8gWjL/CHsFetBSqHz5trfkHzVsB3I1sFQbmfP6EwB5Ln9a9XdQBuchzRaODrc6dI4EKGlXgyVnp/Zvslp5eQ5R2xqQ7vHQKRas3NBKxEtMSZRPTJE98e6JVb/oV7SGUiFSVxD31la8Ep0L9OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=craansmA; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="craansmA"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-725ef0397aeso3909546b3a.2
        for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2024 10:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734373920; x=1734978720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/5BuJMQWdxGaX9Vsp6m161sVX1PJlD7e79C00UFHCBw=;
        b=craansmA7XzvKUAk6oYnpk6Rqvr3K+xsVtoR3FE4JmvvySOWFDXqQEIUMPEczDloot
         n6tX93f4YIjk90RnCr7Zfxk9YaG12N5NAqphZvtZIZ6mbK3t6OuuQ6GEUYfTUarF5s1H
         H0YlH+gawYrnrFYtMulbBO3TJ/KU50nuIUaO7yegjcdjbFqG4Bqjkb6vSQW1jqwtdQz9
         K5nQETcCTo9FZLc3mdU30btHFgZDlG24/OS+/f0OhaO36y72EVD0ayw04UmtnTJYloqc
         kocrC8FI5BXCdZmJbsi7YGMFemGq7oJGbxAz5PHkGKON4+ICLVnOd9RuHojOiOmG6xwl
         eTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734373920; x=1734978720;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/5BuJMQWdxGaX9Vsp6m161sVX1PJlD7e79C00UFHCBw=;
        b=n4hhiPNcIW49EUimV87yJ9FpfZKnhI++wS+io2vtpDoNcauJKJCEPk+RjX1ilZQ7xv
         uNJc+WubZvhRNpbgdB2XXM0zMHrS7soDSLTgKzZ9tTNZHuwBzUeBvQX/xBOMdpuG8ntK
         TOkRYpVcz6vvmoUrpBmkjd60K1hf5fI0pXTPX8duszZrAwoMRrqJ3sYJH52ghFmxCqF+
         dLgULtm2fZORjF01L6+Fx+eN+e9A0puw6RCy61evptx3bI5g6+gN0Q7WPi8nkubFLdYX
         f2iXZXc8+FPoHzRGDgdbuNNQj5WNtSFTL4VJbUNts/f5sIb1goyxdfSMtBuMsFM4JUP6
         Ks3Q==
X-Gm-Message-State: AOJu0YzjkiqAMcD/C2q+LD2krREGTdSYyTD5RSHFqolG7GwEypbGZjp4
	GBf2QQKLEIDdNyw4J2fXRRbSZZYaYKlz2yCJKzk4M4urmUi4sJCRQW2gVhy5
X-Gm-Gg: ASbGnctGFWw2EfnEwLBB2ehwgTegztRbHoTnzJnsTQy7HEJIp7TwJb5NyvjszTr1NOa
	nGLgVW+ug+s5oXji8NUurAiakNNSh+giqPxdSWVJD1Ch9cAJmTAUUEcECod8chFpxizy7i3x2F9
	f9MSX6PJrnuv8gRSjlqzDp350ereiTIrXu2W4Pnux89y2m2/+jLWKlKpaH6NuT+cCGOQ4NpKh9d
	BC/vMGddTunHc9eN1WD6Gs9nadF7UX0aFhcw2Elk4m0k+GmACS+v9VM4lTxFft0KJ04+EJzf8RZ
	czmDPtfx
X-Google-Smtp-Source: AGHT+IGrK0er33BrkeA4vAU6NTHzgS863jqDo28Mbq9fhYrSCqUNZuCG7rJrFKN6616eswZzvkHh7w==
X-Received: by 2002:a05:6a20:db0a:b0:1e1:72ce:fefc with SMTP id adf61e73a8af0-1e1dfdcb7famr20102114637.22.1734373920206;
        Mon, 16 Dec 2024 10:32:00 -0800 (PST)
Received: from bharathsm-Virtual-Machine.. ([131.107.160.189])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-801d5c3a513sm4459967a12.72.2024.12.16.10.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2024 10:31:59 -0800 (PST)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	sfrench@samba.org,
	pc@manguebit.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	ronniesahlberg@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] smb: enable reuse of deferred file handles for write operations
Date: Tue, 17 Dec 2024 00:01:48 +0530
Message-ID: <20241216183148.4291-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, deferred file handles were reused only for read
operations, this commit extends to reusing deferred handles
for write operations.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index a58a3333ecc3..98deff1de74c 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -990,7 +990,11 @@ int cifs_open(struct inode *inode, struct file *file)
 	}
 
 	/* Get the cached handle as SMB2 close is deferred */
-	rc = cifs_get_readable_path(tcon, full_path, &cfile);
+	if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
+		rc = cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+	} else {
+		rc = cifs_get_readable_path(tcon, full_path, &cfile);
+	}
 	if (rc == 0) {
 		if (file->f_flags == cfile->f_flags) {
 			file->private_data = cfile;
-- 
2.43.0

