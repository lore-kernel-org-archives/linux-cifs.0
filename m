Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF033D34B9
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 21:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787260399; cv=none; b=lDbWi8DCTkJc8vWbyShF29/F+28RxHMJb0XyLNnY1p+QSCuXOgQRG2EYmcl5jbVULARi2YCWp4iCK4KTWOH048oKJ5ADvbyh1D+r4gDjXXLxU/+8h/CcXtp2f1U21/6PLu0xUU7Ss0QKKiag7j7SBzmTNtM79V9pEEkHrUOlALM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787260399; c=relaxed/simple;
	bh=FBkoHbnBpCFZvPSFxK+guNXnNiRJjA4cBZij8IaL6/o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JJYKl/xmaq5t0spR7lO+vdatS863a0pdi6tMtpZj/6h4i74vt+l3qqDCOZ9jEkknhqCkH/x+VDS5D+wB6NTqKtnReuB5EU+sDuc1naFXqcrH3YRTdi+eCWPiWURiE+0Xx5+3uPPP75CQy4hEtcynbHrbtqc7jYFFihAr8NFpN4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gw9eO9ng; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DsLiAFbc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gw9eO9ng";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DsLiAFbc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787260396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iALMLjNa5SNcOPSPrNeVDGsUnkRgdfi+5UonJPZ+nEo=;
	b=Gw9eO9ngHU7baMVUJRYoDz+jBAiX/fVLSTGA7p8cmeA/4WsYcUYl/zaExMYtJon30eu+S/
	mpA/eDwjqEf3AV8TZlNCKySuYlcvtSRZhklMHcTAZhhNRTqnut4d+SnKhS23dE+cDTLk4D
	FB1FoPC2wCpwgToJK9/LC52Q97bk0EY=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-vIhrIG0FNj-D39pFYl7jkw-1; Thu, 20 Aug 2026 17:13:14 -0400
X-MC-Unique: vIhrIG0FNj-D39pFYl7jkw-1
X-Mimecast-MFC-AGG-ID: vIhrIG0FNj-D39pFYl7jkw_1787260394
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b1bd347d5fso432051b6e.3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 14:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787260394; x=1787865194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iALMLjNa5SNcOPSPrNeVDGsUnkRgdfi+5UonJPZ+nEo=;
        b=DsLiAFbc6mcDQBqfL3kpK0tNSykVxl4NfRjSgDNb0DuYq/KdbHyvcVQ5XqBJhEjBtE
         rhL4YdSKiLQQ9UnFPMy+FAf4SvZUW9CpjM2cPFNxVwSqtuVs9O11TPKG/BuUtCI7REsX
         xVWznpb/RfvSRrDbKN6SMWOGgNAWhbEqoiD577ZJEsmgAm6Tc29fs4/2zBxL+k3PCzRl
         cnzpUsmVREoUhBsnAnFSuwCUpZBKPOMYEV+Vz9tJWK+MhA1miJw1IOj6bD91EVe/0AER
         PlXFuyPdY2Wz/wZc6jUayexbtiIpIkJ4eKGna+lOIEXt3drFdC1OSOi1ahaYSS9+uN8N
         BMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787260394; x=1787865194;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iALMLjNa5SNcOPSPrNeVDGsUnkRgdfi+5UonJPZ+nEo=;
        b=rtw7lAkt8PO+q0t6vVtBLL/JKbr4MhdfWHp68IumslR+MzI4wubW/SYDdw2GGCROpI
         NGOuXwIgpridHvyoegarQ6yOXgw1RS179ie2iRaHV0fX1ypQBttWR/WterwzRfcn3mBQ
         LIPJ9DhOLC5MlSiaJNKQoM3QJODkZtY36YVGBbG4ojrugwDCWk2hAI3VkzPDgD0VdrQT
         VwoUOOUyudvlRgWo5PXgF3DwYvCH6+173DOEX+TGNj5GGqUiQm6KWIrwfeS/DmJ8GVlD
         gX+wc5NlS6rngNkYscU00dFrU2MkwAq6QOpC+Tk7UzWP9EFPmcKJukCeu7tIpX10CM8C
         D7yw==
X-Gm-Message-State: AOJu0YzpsyAmVQSeHBhbX/dSqSTYfxw9vPDp81IuIR9fJD4wZ9lDtde4
	Matt36UGuQwRNZi6adAuxFiKj87tLJXC3WtS/W5ssv/wov8T3Eocuk5co64Tf/bNd5tle+Xrvq6
	oFJQMw9yV0bLMhnNOskBcwGkU4d02QxuAoCFCO/Rht8EmWFo14l6NSIF1KripSFQteditfVQvwa
	QPKeCRJz9GJBt4yNWVc5aVCvk2NiVgXcMIhA7sQlfCJ1Mu2vQ=
X-Gm-Gg: AR+sD11hbqHlgQboRhHOlmd5irbrE2KfoorrFnd6kS3ItJQ6EMc11Fx5bdYuvJN4p+t
	B+IBcq8m4oh+xh8Dm9xeUNspHjy19r34gMP55BNYWTie82xInfch34RNDT63KDLDDkD2PQgoal/
	EQ0VmAqkK8SWlwLm/gjphz+K5yXwonMULK+PbKprJbDJ9aGbYZ9IlECUnvBZXIDBv95ldEzZsoO
	D5QRrjhntxTMQkG+dTpIhhpOvbcVFFL02YW6f3UEtM7T6vJBsAsE59bxoQ6J9Zk877ZAO6KuZ5d
	yGMeuUhtmgcAerlk6tCbWDv3ha+CHPWoKJ/5+IdOehN34UZa5yuIE2sYDzfKO3IOMTGQpCVzhbK
	q6YxE3xpZDw5iNqN5u07P5pYmojuCrgxgrCPJR3C14jhXrqXgOPhyrbjY4pxDKhQDOA==
X-Received: by 2002:a05:6808:13c2:b0:4b2:6ca6:9cd8 with SMTP id 5614622812f47-4b2ef25db7bmr1099582b6e.1.1787260393817;
        Thu, 20 Aug 2026 14:13:13 -0700 (PDT)
X-Received: by 2002:a05:6808:13c2:b0:4b2:6ca6:9cd8 with SMTP id 5614622812f47-4b2ef25db7bmr1099547b6e.1.1787260393363;
        Thu, 20 Aug 2026 14:13:13 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b2d6711e15sm2957409b6e.1.2026.08.20.14.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 14:13:12 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org,
	David Howells <dhowells@redhat.com>
Subject: [PATCH] cifs: call pagecache_isize_extended() in cifs_setsize() when extending
Date: Thu, 20 Aug 2026 16:13:10 -0500
Message-ID: <20260820211310.1471930-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_setsize() calls truncate_pagecache() but skips
pagecache_isize_extended() on extension.  truncate_setsize() shows
the correct pattern:

  i_size_write(inode, newsize);
  if (newsize > oldsize)
      pagecache_isize_extended(inode, oldsize, newsize);
  truncate_pagecache(inode, newsize);

pagecache_isize_extended() zeroes the tail of the page straddling old
EOF.  Without it, dirty bytes in that region can be written back to
the server, exposing stale data in the newly extended range.

Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index d459b6f602ca..a5aa1ae23c5f 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3059,6 +3059,8 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 		inode->i_blocks = blocks;
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	if (offset > old_size)
+		pagecache_isize_extended(inode, old_size, offset);
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
 }
-- 
2.55.0

