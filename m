Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC97C389DEC
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 18:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784918886; cv=none; b=rP9L0tf2hP/7TfhZ8PIZk0KiLn+IFHHmnGUhrFtOxEFScUpQ+xubY8020J/xOyhHUPQiiLpRI9Tlws+M+Y+YiPLIMdeF2c5yM24cMi9oRS6EWEJV/uGHcuZDM3ZKOR3cwDr9q7ngxFSjmDdXJlIAXxbp5/M4zcDh7MYMaAY9xHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784918886; c=relaxed/simple;
	bh=MB1ARuhcLDoc0HU7f9faKdME0mb9QLxkn3iQ00IjaLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lf54MoI6OW/YvO6N2OOwPCH0hsMOIg1jfBGEaSxJ4DSLk9XTDGqsL9ZfDWeXLpWnfvbyzlyvxB4sVF+616+N2ke3uV91v8ye56cWOB9T9RDhe/ngNT/4TIRmMIwLZ064v7sKlRLI9GOlhZRGlP282mHl5Efuo0xpHTZF6/Jl9Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dH8+0zYn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GJtGQkNE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dH8+0zYn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GJtGQkNE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784918880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N406NhHNRarOiCpmNzhvLrYTVW7/Nzu87dD/ueM2CnA=;
	b=dH8+0zYndh05/WzMiGO5nM5KNXe9Wv3Md4WptHtTkLDNEyyayUxFxpaMaIwCP/bhpZAbZN
	moIopByq4NmCMIwIy0aknOJoQCUtWMJPxbvOucYBvZRV6QhGmgvSLu2G29TJyfWcgKW0qA
	QeOzapt8mb5nUwuXNWTEaPAj1dtvcLs=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-RRy5oBeeM1O2cAmSY00PNw-1; Fri, 24 Jul 2026 14:47:58 -0400
X-MC-Unique: RRy5oBeeM1O2cAmSY00PNw-1
X-Mimecast-MFC-AGG-ID: RRy5oBeeM1O2cAmSY00PNw_1784918878
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-49ab6a82cd5so805762b6e.2
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 11:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784918878; x=1785523678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=N406NhHNRarOiCpmNzhvLrYTVW7/Nzu87dD/ueM2CnA=;
        b=GJtGQkNEa4foKT5lv+ulJ9PfjWCAd99qQxjT5ANl2rI1dacAQnBd0Ne5KoUoJyGGjw
         lZsjpLlG7zhGTSllVAbOmUVd+RmclGMLiFustzyjvRKG10k9Olg+eUaST7joHFyQB6Dz
         oz4RYTyk/kljYIl9J1c0wnZhlkONaPgGKleLz9UeTHMM1RPAkcABukNbHtcQZkRRHObB
         cDbkn0Rp0b3mCYu35U/Gze1zXnZf8LSo0GZPr0dpYiqEN/VRQODbbZSF2rBEQL9WqjPB
         5tcr7wCR33r96uYWHeyZhv8fYU4kuy70ZUjxk4eRcxco3UjeO8ce5pYGLVdCX9WRI/kV
         sULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784918878; x=1785523678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N406NhHNRarOiCpmNzhvLrYTVW7/Nzu87dD/ueM2CnA=;
        b=EdCYPHzTh2Ch/bf8Dk1HG9ER9R5VnL1EiRYAnLUt3tn9SbuL+Yjwo/TaRolA57hbsz
         Td6KV88Y/2Mlacv2+peFrgYKIsNXEiPqexqXuRH2OnCQ8b/uPZ8UYFKS3KlxOyBUwuzi
         6CkJUpxlQ4ozSI7WR+0NuxJvW/20qCk6VL1RzW9zzFZFNafXdNgz8dOal6R2ug97dSJc
         RazG1aFTZaWvlsFN5dy2QYVQ/J9efomKGAuHVsMUEc3yQE3QNWqrOT4lK9pgCJMrR+Xy
         a4FEt0yxLKBISBfBHpQcJjBiAe+WHk0M053fmWRSYk1wpEPy60urYPcx1nSPnRaTWPjS
         R+EA==
X-Gm-Message-State: AOJu0YxpGobuW2mPIxtBrPMejWOigE4WK+MIoE2buSV8NMa+uuIHhNNb
	jJqmnyAE3fmoEpSEfAKwGDdlY4Bx+QLkEghj9c9ty/EQ0dzkFxEbVrQYElYjYQenKGjHHehb2sR
	+6iPlXI7jHSQjgrteFGmTffWuMGnuiwxpxDbm8i3GCG4D3qKI38IneHgq1XXK9z7fiiXIcPoI2O
	ko/dyNnrHcmUg8NtyTtQKSko50uS5vDmi+pyb7deomrW+pCYo=
X-Gm-Gg: AR+sD10gWKr5yWuoVTYO2nmf4ttZaiU0/g00DB98QxaXYEzf0bZHya6MCm5Cd9XpOaX
	m+QLXlABVQm0kY83W6HDc5gVCPcsVAZpfncxbbBmWLU/Wn3sdJP87IGu+ofwVKEgmlCrG5bEvLX
	ZS4MO2Eg8LucoxN008oT/pNmK6NaiY3iguZdO2MGXIcwQ9WjhMaINPz3X0QFMQR8uzL9+fq90tK
	k4z+1CbTNKYBPVvezFmzYbkfRqum2ZLFv/LreasZfgLERMQc6eGdC4FK8h98Wj9OnHCwB2JwGnT
	X8ZfOe9GzMKs1SoJSMVg+hSJjOBjNkGH8XabQUB6f5FTBxgpnr3h47SLD7u+UDeaJ+iwogjv5Ym
	2k1UI6m1Um+20mGbOyU/3FrpGfCEi4SedsWAX/anMkm0R9/Ow3QFwmwxUyByE
X-Received: by 2002:a05:6808:3506:b0:496:2b3:ae70 with SMTP id 5614622812f47-4ab35466e19mr5221906b6e.25.1784918877811;
        Fri, 24 Jul 2026 11:47:57 -0700 (PDT)
X-Received: by 2002:a05:6808:3506:b0:496:2b3:ae70 with SMTP id 5614622812f47-4ab35466e19mr5221878b6e.25.1784918877274;
        Fri, 24 Jul 2026 11:47:57 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ab3cc35415sm3580396b6e.6.2026.07.24.11.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 11:47:56 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Cc: stable@vger.kernel.org,
	David Howells <dhowells@redhat.com>
Subject: [PATCH] cifs: fix missing fscache_resize_cookie() call on truncate
Date: Fri, 24 Jul 2026 13:47:55 -0500
Message-ID: <20260724184755.2708212-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 70431bfd825d ("cifs: Support fscache indexing rewrite") intended
to resize the fscache cookie when file size changes via truncate, adding
fscache_resize_cookie() calls in cifs_setattr_unix() and
cifs_setattr_nounix().  However, both calls were placed in the dead
block guarded by:

    if ((attrs->ia_valid & ATTR_SIZE) &&
        attrs->ia_size != i_size_read(inode))

This guard is never true on the success path: the truncation function
already calls cifs_setsize() at its set_size_out label, which calls
i_size_write(), so attrs->ia_size == i_size_read(inode) always holds by
the time this guard is evaluated.  On the failure path, execution jumps
to out/cifs_setattr_exit before reaching the block.
fscache_resize_cookie() has therefore never been called on successful
truncation.

Fix this by adding the call to cifs_file_set_size() at set_size_out,
where the size change is committed to the VFS inode and page cache.

Fixes: 70431bfd825d ("cifs: Support fscache indexing rewrite")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 808085eb0cdc..e4ca82c52e7b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3127,6 +3127,7 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 	if (rc == 0) {
 		netfs_resize_file(&cifsInode->netfs, size, true);
 		cifs_setsize(inode, size);
+		fscache_resize_cookie(cifs_inode_cookie(inode), size);
 	}
 
 	return rc;
-- 
2.55.0

