Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEE93168F4
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758295843; cv=none; b=W6W7Gen0X8FlZbet59NzR+4USAk3VbIy+hT0nMw2CgP4F42Sb5s8jVMEOO3legzinyZdiiASv4CNZUEsPSjt9dGUIZlAWa45UGoWsJ6tWL0QXS+musp7y4pFP2BY3m7FPWptPDaT8W48SFmIluLJASaHtkBm2+Kdx5Netxj4FhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758295843; c=relaxed/simple;
	bh=UqXPtWlfbHLqFQ7eWikE52HLMF+DOmJFgVCDux4hr0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqwRT0STu4s6aOPzQLjNDjMprui66F744juWLLzquqnNBRSxjoFGhZzUvH0LedNS6OLEISk3R6FoktKmWORhcda25PZhkBdvdw/kpJ4kDFG7u/oCmdz1ONWqM8aKlirLuuNI9T5p8jkzIwi7TKp4qyPNDNaFUNZiZn7kVmJYxWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f5iWM20Y; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f5iWM20Y"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3f1153f4254so267727f8f.1
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 08:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758295840; x=1758900640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txzZSgYFEBqlkbT1f1H4fABfGoM/Ssf+mPrEeL7Zqpo=;
        b=f5iWM20YreLw6cyr8tM/1jppfuGAYzgwUMHsop9Q4uL+bpzNHsbFKa1nr3bHUFJbIN
         V4IDlA1gtd8RSNErCrJdTAOTZyl1852gYMxo9K+q7LQmPBfAZZQZ2OaCekYC08gTjajD
         1CGUsUTmbeXj33MrkkxMLcdohX1Pju05/Pm4NuvWzrMlLtyNE/qSIHoAuLCRT2Imr8O2
         +XNgf3FE0wl7UdSMvOIUho7xSJoszjlE4A7k0uA2zpPPO631mmdlUxz9vcxa4UlyCg9M
         kJocJNK5RDfAxwZIAisBq9UE5Gakk6Rk1wqkS1A/S1HfJne32vYMl7A4Cq1RGvTW/X00
         VBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758295840; x=1758900640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=txzZSgYFEBqlkbT1f1H4fABfGoM/Ssf+mPrEeL7Zqpo=;
        b=X52P0or8e3TdC1t3mxN5Q6977Sf1IQfUILOkpPBe0OMI1leIgwS+d4cIRmEW8jwnyn
         szUWsbC/NtumsPTjy4KHoDAVZAbolcZOTWUYu1KCT7GQ4DGMUWsj8/4tmT3Qk3HevoFy
         jhRiiqqPx4p7FWplX93CP541JEK1YdycAyFoO35kMdzv/XB+ujpAPgOUb/iDl4ZSzz3/
         PEvlMWAfpYKf94snAmMLp2+q+68g5Owa6YyHygZZY1uCorMIdHPfHqOh1rn2KDWmiP+5
         d/w7ilogQOI16lbP/DuWIoD0Cs2Y9fjAjOe9va84URqaljHISUF9XvIDa0TStCptDIGE
         ElhA==
X-Forwarded-Encrypted: i=1; AJvYcCWH8OQQDGEFLQJz6mlb8oIE9keOYljzfRw/k4ehoElHtlJRN/7DmLcfFVb8hSfp1rIoTTf01na2xDO7@vger.kernel.org
X-Gm-Message-State: AOJu0YxdKdx+GWb3z+YviYmyHhkpMoN1jRATz4menIF/RtwHxmg7Odwy
	KFFXnUzrDdEJh1P/3ieS5YRXlKd+d5L5Rtg5LbGrW1HvgLZzHWpKX9qzySfFgYyJeoc=
X-Gm-Gg: ASbGncsbgpI7bGre+FbXedzjE476qMVUvuuhShA8eEwErEO74ki56AxFR6G+UpAalpH
	8ti8LwKc0CkmmQ7i/avIDHid/lsjGujEqzgCMJQ88tDkTFurQwyZuYfRVnkdXdrYyuEvmPXPrGV
	yi2ioEYg3hKSP1ldthC2JcxGSns2Araw7N7PPr0B5eJ1+JnoEVWKUOCAknwoLau0coX4Ufdvv+S
	m3YLeZxwbdkhN6QOD99NZKS/5TJG8JlVpT/NS+rDHaL2gw9A/duRGjgDM4LDyzLZPi11oeLfxoE
	33lWz9XvciE7rOhvqraJ7VJyfDUUVSSmmq7DFQrqOOIsZP358EXMSoIsOdhQRrVuC2Nq39BfMI1
	pmG5mphLc9X3K
X-Google-Smtp-Source: AGHT+IED76eoXauVrRZdjZwAf2s8bHBJiYPGAROBT4C6i3RLWNgEBIHfZ0cMkuZW0CuUdriwsAoI5A==
X-Received: by 2002:a05:6000:178c:b0:3e7:615a:17de with SMTP id ffacd0b85a97d-3ee861f8336mr3100309f8f.47.1758295839736;
        Fri, 19 Sep 2025 08:30:39 -0700 (PDT)
Received: from precision ([2804:14c:658f:8614::1cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ecc735627sm5129683a91.1.2025.09.19.08.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:30:37 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: smfrench@gmail.com
Cc: ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 3/6] smb: client: short-circuit negative lookups when parent dir is fully cached
Date: Fri, 19 Sep 2025 12:24:37 -0300
Message-ID: <20250919152441.228774-3-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919152441.228774-1-henrique.carvalho@suse.com>
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
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
 fs/smb/client/dir.c | 48 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 56c59b67ecc2..d382fc76974f 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -683,6 +683,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	const char *full_path;
 	void *page;
 	int retry_count = 0;
+	struct cached_fid *cfid = NULL;
 
 	xid = get_xid();
 
@@ -722,6 +723,29 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
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
+		 *
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
@@ -755,6 +779,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		}
 		newInode = ERR_PTR(rc);
 	}
+
+out:
 	free_dentry_path(page);
 	cifs_put_tlink(tlink);
 	free_xid(xid);
@@ -765,7 +791,11 @@ static int
 cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 		  struct dentry *direntry, unsigned int flags)
 {
-	struct inode *inode;
+	struct inode *inode = NULL;
+	struct cifs_sb_info *cifs_sb;
+	struct cifs_tcon *tcon;
+	struct cached_fid *cfid;
+
 	int rc;
 
 	if (flags & LOOKUP_RCU)
@@ -812,6 +842,22 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 
 			return 1;
 		}
+	} else {
+		inode = d_inode(direntry->d_parent);
+		cifs_sb = CIFS_SB(inode->i_sb);
+		tcon = cifs_sb_master_tcon(cifs_sb);
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

