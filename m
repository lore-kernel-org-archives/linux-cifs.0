Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192FF26B2DA
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 15:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512118; cv=none; b=GituYHbonYZH8tOguOlgVBdTJdKvpR5kuELE1pN/Be/iPDZULNE0bWQF6Py4ukJZL43u0xnUwkQlYh9H7E4sBgs7IVRd8ZaldlKmE6h4VwxTPiekNPV24OHsXssmf7E9Ko+XDTAMUnJvkcGuGhUEBz8W2UHwTGF1I+SgZ9sSqQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512118; c=relaxed/simple;
	bh=yCiJM9M7OSxRZ2pR6LXvazE152Qlgq079HQBiwdxZsA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bg5B22DtD0LCBA1gI4Q62y5lySQmt3Rk1KNpgpxwANDrewOK+l0vGQe1MCFPekbmMeO35kksj8PWuQVKNxMSG9zxrjZw0v9t2rFjhb9Tcz4sQOjWk5t7R2zNsesDmc1tvOCUQHdZJ+NXkOoaUjWlRm9Y6zCIdS10Q1UOQASFUsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gA+kXiCe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=X3u8a5FY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gA+kXiCe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="X3u8a5FY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785512116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ec2YztIOmCfQ6RjUNNYXDrx+f1Ba6t2+VTVM8hBlTs4=;
	b=gA+kXiCeI/Hy5XvGyKsKOLcAKHNIK6Barl0PM9v9oZDpa37TCzo/F7HOeuA9QsAwesYIq2
	8rAmGevVdz+rcdX5Xk6u2yctg9GygfC/+uVYMbdCjMYk3Nzz2JBT4lb1Z4icikq3eLZg/W
	GdMnXsx+CC9N0VInpTnnyNCUo3v6G1k=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-t0OLKw3gPgSIV-ZNmbISqw-1; Fri, 31 Jul 2026 11:35:14 -0400
X-MC-Unique: t0OLKw3gPgSIV-ZNmbISqw-1
X-Mimecast-MFC-AGG-ID: t0OLKw3gPgSIV-ZNmbISqw_1785512114
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-495b8b30310so1482082b6e.1
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 08:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785512114; x=1786116914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ec2YztIOmCfQ6RjUNNYXDrx+f1Ba6t2+VTVM8hBlTs4=;
        b=X3u8a5FYzg3E1OgHtQPUzB5GlNYqYuL2PxY4tVjl/16PfdnZjgYeM3KbdMYdJo9+Fa
         vHQ/zUU1i+Gt1BEaEuEw8zz/M3FJECfTKG8fWrSUVdKOBASfsBI38p72ISrqEzF3WnR5
         UVs8BT2DAN/3o7pfSmPpojFD/emgHufmnu1LZC9wqPyVBWFzAUTHYdsVgQT4GjTQSJe/
         Pt0xAs2XbGNFweBSRm8roJAwblsDJEfesiP3NKuQ3h5vfeoPhU8GFLQyPgGWf3Tgf2J/
         8oeoZJ8t92u6H0uZFjXcPX2gmsJRrFUnVhK2Gc1JGr5+gsOWMglumLH1q/49q0mAvbAm
         HklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512114; x=1786116914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ec2YztIOmCfQ6RjUNNYXDrx+f1Ba6t2+VTVM8hBlTs4=;
        b=gllxjgEnDCftCskI2MgZB6o0uumWWx1d9TpngSqmDW6AT9LQrhdNgHpP/QI5Wo54gY
         gNxpUQy5mjTsqnOoVkI5U25VGl10KSR5M8YbOWzDqw1O3V7e6jl7dxuBn717M4kKRula
         AMUIkDpPq80+YWKz18HYku/mPHnF7DgNxv4Cv0zikmKm8HtRY7GIk3+eR2kqu2uhtvd5
         5Jb3znXIYIbD2KJ2w9ZYhppq4h7qirTiY9Ekd5dHdyXITBI+SanXYxTlTcfIjD9xBb3O
         nnckNvSD/zBKR0Z/bw4kJlSxJWFo3Rq/oJ4oI/EHhTvy+vB8cHeTCKJEjqjrRjbvG/fX
         Fzlg==
X-Gm-Message-State: AOJu0Yy07LGMKrxtD+EHgYIF5mBIBecyoZQKjJ4vTL/Bddrz36nxXI8R
	SioWMO/Ht28/dx2asATijprSkwYsYPpKmic2WjuZ4zFGIYSBWjnugtHrMlBMM1CPbjEhbamDqj3
	qFUuCzpq8wFrneqMSTs9HZspZrYnsNfF8uE9IaBtHvkyCcq1jQpxoYRtQ0DDbdpzMpDgJnem09U
	l9Cm4I36TaHknzToENtB336eR9j3yK12bSgy1FB7gSOcoQ/L8=
X-Gm-Gg: AR+sD13oLAWsFiIvtunWvE+KjrifzXYMZoxxkyVNp/TXV+2PfseNNEfYKvnUZuTMYfq
	+KcXsPlw9MR9ohC39YPDiCdBPzFdrjjUlyosJdml1WZ7rMnFCNHI++7cCIAugNX7IqmW1LQH23W
	knmFaTGCwSEDNvczxHoZRHD1/v6JRW5xyzvYUM5CoPY+lLEXaEilzO2+MkuKthAHRGez/1gwRz5
	voFDBLOx2ZPbfSiAqMgwB+zx80VubD6ta+2OWaVp5mJawAUqbB4KqpnWoeFeddenIZ2dFari/JY
	yUhuBOSjsxmz657vh/ZgWwiS6BRGU87pn7jc7TKDMKUCCVrX2pjMdHeiwXAYJ0xG9qheZN3WI8l
	IZpIb4Oxbl2dtWoDOAhoGGEXVioO9dfalM9oC0FAKR2ZIYUveak2jAOwa4pjZ
X-Received: by 2002:a05:6808:1310:b0:495:e5a5:d62 with SMTP id 5614622812f47-4af5e031ed4mr754417b6e.6.1785512113807;
        Fri, 31 Jul 2026 08:35:13 -0700 (PDT)
X-Received: by 2002:a05:6808:1310:b0:495:e5a5:d62 with SMTP id 5614622812f47-4af5e031ed4mr754349b6e.6.1785512113258;
        Fri, 31 Jul 2026 08:35:13 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4af58ce144esm855813b6e.1.2026.07.31.08.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:35:11 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com,
	hehuiwen@kylinos.cn
Subject: [PATCH v2 4/4] cifs: remove dead size-update blocks in cifs_setattr_unix/nounix
Date: Fri, 31 Jul 2026 10:35:00 -0500
Message-ID: <20260731153500.660569-5-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731153500.660569-1-sorenson@redhat.com>
References: <20260731153500.660569-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 110fee6b9bb5 ("smb: client: fix missing timestamp updates with
O_TRUNC") introduced cifs_file_set_size(), which calls netfs_resize_file()
and cifs_setsize() on success.  cifs_setsize() calls i_size_write(),
updating i_size to the new value.  The subsequent blocks in both
cifs_setattr_unix() and cifs_setattr_nounix():

    if ((attrs->ia_valid & ATTR_SIZE) &&
        attrs->ia_size != i_size_read(inode)) {
        truncate_setsize(inode, attrs->ia_size);
        netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
        fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
    }

are therefore unreachable on the success path: attrs->ia_size ==
i_size_read(inode) always holds after cifs_file_set_size() succeeds.
On the failure path, execution jumps to out/cifs_setattr_exit before
reaching these blocks.

truncate_setsize() and netfs_resize_file() are redundant with what
cifs_file_set_size() already did; fscache_resize_cookie() was moved there
by commit fa724e235cfd ("cifs: add fscache_resize_cookie() to
cifs_setsize()").  Remove both dead blocks.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/inode.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index eaf27a9cf4f5..10a3322e89aa 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3306,13 +3306,6 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	if (rc)
 		goto out;
 
-	if ((attrs->ia_valid & ATTR_SIZE) &&
-	    attrs->ia_size != i_size_read(inode)) {
-		truncate_setsize(inode, attrs->ia_size);
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
-	}
-
 	setattr_copy(&nop_mnt_idmap, inode, attrs);
 	mark_inode_dirty(inode);
 
@@ -3518,13 +3511,6 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (rc)
 		goto cifs_setattr_exit;
 
-	if ((attrs->ia_valid & ATTR_SIZE) &&
-	    attrs->ia_size != i_size_read(inode)) {
-		truncate_setsize(inode, attrs->ia_size);
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		fscache_resize_cookie(cifs_inode_cookie(inode), attrs->ia_size);
-	}
-
 	setattr_copy(&nop_mnt_idmap, inode, attrs);
 	mark_inode_dirty(inode);
 
-- 
2.55.0

