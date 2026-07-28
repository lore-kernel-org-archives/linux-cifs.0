Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28013414A0E
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 21:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785273292; cv=none; b=CUcGPkob3RFNNIx3KfHro9rBzqZLLOxOWjjqo6Rx/rDi+LDxK4G0O28Mliyc+61cDWCWxXUnk9b1mf1BXiBq8fMw+mhY4VZwg68ZwPUEcf3dfBu3ejXE7XpU4M3GZVj4n2BieRih/LF8u8jg9To+8K5JORU0y+BQTAW4MPS++Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785273292; c=relaxed/simple;
	bh=/VOTQ9CBlqttncLK0BnW/nU4RlQhDm2ucIfCb+IJNZ8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rG3iLHaApEcPSqAAiuTVlXb5PYiNj18LJ/qUyFz4asitkuzxlsDombub/MZPGdT4n9e38w0fIbT1PrnISWVW2iCSP2QLS3JUVyjVY74WH7Oh3tAH33kaNeUPvIioez1l/xJkB+qwjestgPAwElrh+b+2coA3TmXfCO9/LnSGy1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WwORVPFH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=U6qElnk2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WwORVPFH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6qElnk2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785273290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xm7/nOsuYlUxI5tRYoP0H10KOjTschHGQUdgoa3tA5I=;
	b=WwORVPFHcBDS9ksluxFpNsWaXWyYD1tJ4Ak5MMl1Jy+AdEvccIhJcnpvWUZmupO3dY+pwK
	YiVb4sqYhFfFRDlTf+CuUNIqemmDd6y3kQ0HhGwXsG1VcaZScHPmQr3ks05lTn603MtJWh
	/cfD4jj/PmaDDqTKs1I4dnlCzE2KodA=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-qVEJbZYUMjaSpqo9pC3bCg-1; Tue, 28 Jul 2026 17:14:48 -0400
X-MC-Unique: qVEJbZYUMjaSpqo9pC3bCg-1
X-Mimecast-MFC-AGG-ID: qVEJbZYUMjaSpqo9pC3bCg_1785273288
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-49001defc4dso259407b6e.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 14:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785273288; x=1785878088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Xm7/nOsuYlUxI5tRYoP0H10KOjTschHGQUdgoa3tA5I=;
        b=U6qElnk2AjOJRiVarBaAHU8/gT7DfOkXAZXNKiNlbWZEBcz/4jwqwcWnDhIsQkOhVT
         h1ewO5z1c4QTnIVVHQfqqTpzTpsPl12f9/i9pXMLRc/gfaXgPQlhvaBm11QsVLo7+wCm
         ThCNt1AlzJOUAcRX+sutUebDYVESyBfgdO5HQBqf66eZ8ko6/SqbE6+YSWxUqPH/WEhg
         ReOU/aBTUi96SyT3j36TWfpK/LIJL6Ip1FhuCpI4OgAP3/7KGyD0sP13P2qPHKgF/ZTl
         vzabdfqMaANIPKcg6EqUYxYWBPLFyaGhSLgvWQEQPJK+H0+DjzPtirj/Gic6FUfODqwy
         wW2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785273288; x=1785878088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Xm7/nOsuYlUxI5tRYoP0H10KOjTschHGQUdgoa3tA5I=;
        b=ib1gd9/5b8KUMPAdZCOD9fjcEuzRJXlA2/+G34youZxjOO6/zhn8ph4mqerrAimkap
         X+owZBbS0nbbge4qhD8//3UEnxzW7nkXU/t4sOzvo9DgkuaP+ep7ucIGumcpsZ6lUOoK
         k4xIj17Y+0bHOiIUqS81pte30o8FGiCEeG+GhSHAqT69+U2FBvinD696sxNrT4kadQnd
         r099AKwuNMeSjisLz12Dd0PpK7dWMrQO0iCCKS8I4UMW5su2DF1T4wl6e1ExQypnf7G3
         Oj2SS0HqAOj3xBunPCZKfKCFvDEUDKsR76N+qoFA1hDsGkwp27WG0FpIlOfIvg0+fvVk
         RaPA==
X-Gm-Message-State: AOJu0YyV+IjAfg1KnxLqpN5K6VQqvaJMOfTZH6yF+7q+5AeWAPjX6U69
	Jvb9lJk0BTaGKzklaNjlLqX8m7OEI7w5A3VKygYuHGzCBTfXrm4OuMIC0yslmbqJOF+vP4eK3+p
	2pZrfaYHFSD8Rh8IcUoLSSSETBlAXDR48RL1+qc8pQmoP8KRRKTDPbVSDBg7HlqbI7M9qiI4msT
	AtZZS/a7Y7FrFIHZanmlgbYt2KRdCAXLGRtIvf0X/EfoQpws0=
X-Gm-Gg: AR+sD136fl8fXRbORtIxKhFaS3AzL17J9/KqxutaBO5/n2NcDd9SkSxv3ainFuwnyN/
	RlTVxAmPLb8gfrknq1+xxYBhz3F71/W2kUjz+7f8XD6+qq53p785i9GXjAfA1+4QXVU5qw4Gtxp
	N/LggEmhvWJrqqoIIPciKZkXSvYJywGvxdBqzVmjxCSPu08Cjm7TT566yG+5l9k88lCAdA9FC8p
	MqDjAJEVAVui5EKmXXFg02AqYM4PRLfqtk36xd0rIXc+/ARyF8iQSmC+5X6+BahMw25j9ntBkq0
	c66pLUzPnpC6C/DfGugLZ6Qt7gllUSMJCTTd9vk3FwMVeYqF/8HIrY9trEd9ma469/Fjx3/h4Wm
	D0H8HScbPiElK/Bonaki7o9QHNURCoWEE45KeLVi83fWcod8QH3hW0jrnbvV5
X-Received: by 2002:a05:6808:14d4:b0:495:f74a:407d with SMTP id 5614622812f47-4ad5bb46b6emr2384629b6e.23.1785273287783;
        Tue, 28 Jul 2026 14:14:47 -0700 (PDT)
X-Received: by 2002:a05:6808:14d4:b0:495:f74a:407d with SMTP id 5614622812f47-4ad5bb46b6emr2384606b6e.23.1785273287300;
        Tue, 28 Jul 2026 14:14:47 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ad6ed2dedasm231357b6e.7.2026.07.28.14.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:14:46 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org,
	stfrench@microsoft.com
Subject: [PATCH 3/3] cifs: remove dead size-update blocks in cifs_setattr_unix/nounix
Date: Tue, 28 Jul 2026 16:14:38 -0500
Message-ID: <20260728211438.3859107-4-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728211438.3859107-1-sorenson@redhat.com>
References: <20260728211438.3859107-1-sorenson@redhat.com>
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
cifs_file_set_size() already did; fscache_resize_cookie() is now handled
there as well (by commit fa724e235cfd).  Remove both dead blocks.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/inode.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 0afff761aab9..d5543a5bf072 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3289,13 +3289,6 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
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
 
@@ -3501,13 +3494,6 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
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

