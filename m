Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA68502BE
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 14:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810598; cv=none; b=ddvj5bbj8PXOIqqpjRfl0+SBQHnbOqzrf7JmnrpNADRl3vfZSRpfLqiduotNGIk14AbpkrShnVI0Npv2Q9nzf+gWiVlymZyB8RGqcW/GwAA4kfjCCWg5IWdWjo2kev/7uU0YmPOr/g1r8LnhT58O3txjrz1T947w8uS3RcFsop4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810598; c=relaxed/simple;
	bh=TvfenPjlxNku3857ne1PP8thyywocG889skBxH8te5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X4YpeG8mHXPfxVeRIExwIED/TwkaQ1v4vd7bvIW6lLAmKFOVeNCuXaFT2oN2QhtEpwmWpkRzK0FxqMPEpfIFSy3Ny7//qXFtJU0tQCoCwc02Dx0BCjFgl+JNb/KGKtPBjreAd2QUQpDCpZghCM5fn6/hECkFkq0wxY0LAHmizDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TDIXrQIB; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TDIXrQIB"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-4060b4b1200so1143332f8f.3
        for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 07:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758810594; x=1759415394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=buQGwTTJtRaukDyvd7UOo/+zAJjuJcOCWwjjJYcgr0o=;
        b=TDIXrQIByeFi4t4Q0Esat3OPwo1cq4UP25Gcy/oZjgUvgjZHmg6LRShQ+kvL/dUu1f
         oAjQkNI6bFThyPFPkpCSwJ4buAU8TC48DEIdh+WAwqi8n20tgCMjAFGsFi99N7owwSBe
         6QmHE5OiYbIJMuRM8zMJoMvNw+UJpqWO+l10yTxqhYfY+sKe8oGyqGo1Qx3gUntSnlNc
         X9DdMsm/HzL2NyYSrg3zhiOtVFF4EAzvZ+j8jiw1YCuxXVzYZK2v/CTDeZNTy56XLKTm
         ZjoRPttO6/+77ZRlGtvtjFjwgQiXcaTjnwuUKo6E8lm5etgn3DC8nkNVxUTAt4VGKIer
         zWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758810594; x=1759415394;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=buQGwTTJtRaukDyvd7UOo/+zAJjuJcOCWwjjJYcgr0o=;
        b=qd/Qr/ZwYUcGyD22c/WnUs3iXpeo8JqQlC0okLLowkoNkNS/K0lJhP5hJkN5sqr0Qq
         2t57lfFJHPC0LszbXPF96FCqKh3o14n7QLRJ+/MYo0xmMiuevzb7OAzsYJf64eH47xzY
         kGuIzg/9NWrM9apRJq7bWN4OooUsi4H3Xy6uXfkqcSrl26pAs+PdeyVCGennLT6QuYUe
         Wq1/8FOjMTmTXcyOUSFlhniyOJN6GQBD88lnVeGNhtGrVOlmNIVeDxSLWgra1pKFoQsu
         IYpsp5dfnV0aSGS9EjkmmYp38dmVXj+bVdsLfZpa+UEdN+swFBi0Q3lJYPBM6SsWS0xT
         MQ6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUikgOApBLiL3oPx9ozjU8LEl0r3fVprOioKqRBVbRy3/kNcZ//6rpMssfTZSLHCrbp9J2PL+iG2ATb@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6pxZDthzmhlRToh94DdCcRIDE+9cC4079n7IjpURFIKlFLcp+
	zZB6hAXtnsl+Dg4HSziv7VNmZUcVlHTzi64gGahWxyW2tRSiBWeG/3RIgFfVxvxl/0U=
X-Gm-Gg: ASbGnctx/trZ4d+L1jkWv/IO8uzSBGE0Q4WrZqbLsCkZxlQc5QleRB+ID8VTZVivL2A
	UrVo4Vsu9lioZOdZ/1ZZbBz8BRDHks0H1IJHq05GU1QHgBzOkhEJcCjeahgVlekgVEXij063N11
	XmFew4bpt05XktUQf6NVZozL1ltiw1/t1kXOh87lLoQoEB+4uHkLPayzfVkVkxrY1q+6Dhq4rBR
	7GUzSsTk785dukaLLOX1O0rXpaaxCHDnQUCQVkn8nlod5seAyRhaEocy5BLWcedtN5YICFTyrGQ
	CQbT4Lh8UmQr7lrUBlf8fr/NBE+v+wZNvwr3iq8SiEPMVZCAJSIyvq8s0ZYYkfGK8lBVlV5/e3d
	W9mrGtJ0/u0diHklBosWfhIaZJvXMoSFwXteHPLvNtQ==
X-Google-Smtp-Source: AGHT+IHrkx4khYHUBiNIR+bUzzzRb4zopimRX/17sOSfSkAa1iVTuOQ2rIVzX5oCx9SrQdJXEYv5iA==
X-Received: by 2002:a5d:588c:0:b0:3e9:a1cb:ea8f with SMTP id ffacd0b85a97d-40e4d40aa40mr3602268f8f.52.1758810593571;
        Thu, 25 Sep 2025 07:29:53 -0700 (PDT)
Received: from precision ([2804:7f0:bc00:781b:d1e0:cce1:50f4:d7cd])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3347224b2fdsm2600876a91.10.2025.09.25.07.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 07:29:53 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 3/6] smb: client: short-circuit negative lookups when parent dir is fully cached
Date: Thu, 25 Sep 2025 11:25:36 -0300
Message-ID: <20250925142536.166664-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the parent directory has a valid and complete cached enumeration we
can assume that negative dentries are not present in the directory, thus
we can return without issuing a request.

This reduces traffic for common ENOENT when the directory entries are
cached.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V1 -> V2:
- style only changes (code and comment cleanup, variable declarations)


 fs/smb/client/dir.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 56c59b67ecc2..bc145436eba4 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -683,6 +683,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	const char *full_path;
 	void *page;
 	int retry_count = 0;
+	struct cached_fid *cfid = NULL;
 
 	xid = get_xid();
 
@@ -722,6 +723,28 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		cifs_dbg(FYI, "non-NULL inode in lookup\n");
 	} else {
 		cifs_dbg(FYI, "NULL inode in lookup\n");
+
+		/*
+		 * We can only rely on negative dentries having the same
+		 * spelling as the cached dirent if case insensitivity is
+		 * forced on mount.
+		 *
+		 * XXX: if servers correctly announce Case Sensitivity Search
+		 * on GetInfo of FileFSAttributeInformation, then we can take
+		 * correct action even if case insensitive is not forced on
+		 * mount.
+		 */
+		if (pTcon->nocase && !open_cached_dir_by_dentry(pTcon, direntry->d_parent, &cfid)) {
+			/*
+			 * dentry is negative and parent is fully cached:
+			 * we can assume file does not exist
+			 */
+			if (cfid->dirents.is_valid) {
+				close_cached_dir(cfid);
+				goto out;
+			}
+			close_cached_dir(cfid);
+		}
 	}
 	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
 		 full_path, d_inode(direntry));
@@ -755,6 +778,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		}
 		newInode = ERR_PTR(rc);
 	}
+
+out:
 	free_dentry_path(page);
 	cifs_put_tlink(tlink);
 	free_xid(xid);
@@ -765,7 +790,8 @@ static int
 cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 		  struct dentry *direntry, unsigned int flags)
 {
-	struct inode *inode;
+	struct inode *inode = NULL;
+	struct cached_fid *cfid;
 	int rc;
 
 	if (flags & LOOKUP_RCU)
@@ -812,6 +838,21 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 
 			return 1;
 		}
+	} else {
+		struct cifs_sb_info *cifs_sb = CIFS_SB(dir->i_sb);
+		struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+
+		if (!open_cached_dir_by_dentry(tcon, direntry->d_parent, &cfid)) {
+			/*
+			 * dentry is negative and parent is fully cached:
+			 * we can assume file does not exist
+			 */
+			if (cfid->dirents.is_valid) {
+				close_cached_dir(cfid);
+				return 1;
+			}
+			close_cached_dir(cfid);
+		}
 	}
 
 	/*
-- 
2.50.1

