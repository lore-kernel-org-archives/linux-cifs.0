Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E020D14A96
	for <linux-cifs@vger.kernel.org>; Sun, 11 Feb 2024 23:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707694216; cv=pass; b=LHtPb9542jAGdtr1uaYJEkm5svgO4+kWnByKJRoNW+kejafDQn9IabsjV0aMOtintUwG4JLqQWX3ruf5hlGw/3RLOOgwbEiKXmZCHVLH4gF/+9EFOw/Q/fcDngmBf5UE0B9PWFW0EQ6Ysf5mXqu6LNSx7GwdFlrBshnRDTAHHMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707694216; c=relaxed/simple;
	bh=IqiVs3gKh7IoGULlKYd1iA7e5jyHG0Na7Y/l7OB4hxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AU6gejIabuWThUfWIVBstUs8GsdOs7gGwqUG/68k4ZCZBvTKg9ArlBNs1SDZ4XiexQKpiFeO3XGhu2IuUZBZYXVP+I/Kf1vHwwgz3k0R8Wugl0PXxj/g/LFQ8pIB6TBKAYctmqN1lL/F86eOUn1l/CFS9cpiJc3zxLlF/EPy9XM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=QzYzwGXi; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="QzYzwGXi"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1707693645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CCeY2cxRdpkSGSfnNxsw6DBIuq4vr/0ARrZcgwVVxPs=;
	b=QzYzwGXidfPANV08bIT+rqWYYRzt47MDVX7WPDwRj3/b9pML/0nidsb+PrJnzA0KnrcjJ7
	n8Ng7ZEZQChDN5R3Eupx5v3CM1yheBuEnHWp7tEDJSBWjbUkWkB7bAEjUuGzhmXzqlup+z
	SZayxcpuMhD1R62dWI8OzUfw+EXGKqrSbMq9E3cMPOfqR9cyKUIQWPlxbUsxV5ts0yiZUR
	UEvhbw+CbTkhSzEAzAjyoxG+WRbbrQ38sQ32V/1T5MTdIn2EhhxDFGZM1rR6WL4B4P2BIX
	iC02YSV9zJ89Kyl6tw5Gpwx0ghfpIZPMS6T5AKcA4e3Rf4oc3ilb8+L80lW38g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1707693645; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=CCeY2cxRdpkSGSfnNxsw6DBIuq4vr/0ARrZcgwVVxPs=;
	b=LNMFMNf0Bs6Orh7Hx0xHAaj+3nX/qqpeKcrP9SLOZnEcnfiiLw/8lyiAT2a5o2JEwhd6dX
	x+xZ22sn25hcaYXIV3CsTVaVgd9WLeyrGJs/0Nu7U8l6Tuf8ro1R5KsGvwuVjq7ORYxylj
	oB2WPiFb7FCL3vdLQEsHZZIDq6fqeMMzD0b4OWl2VwVjA44e2mEV5JpbItf/Vj1sjrOdNq
	m5vzqxq/Lu40hYwjgVLxZ864GIO/I2atg4zmfcyTEtH8Y3HvkNKbvt5UsLbs758I9mk2sl
	11mPWThxOBC/ylzkWgZheFRaUL3v+dMvOGHsDgM5t+MzgqJlFSk57+skJUMEgQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1707693645; a=rsa-sha256;
	cv=none;
	b=X6DNWoD+pVz2R9wOeb09jvu3juGY6wZak5HaBG53q0mElbQNdlCqCcC7JhdAld4aj73pF9
	jWJkFvHe4g12yI0n9PNZG9wIwfwmQQCeMeTI1c7HdMtR/hMNmqHQ/vhl/STMYEfF1sbqwF
	M2iLprUn98w9M7qRgRYxR0h/4+VpwUidN/GOnsFJ+hSi9n/PiLaplJ6+OYhzeAf6g7Xxaa
	kSZs6ND2Q18Q2ZCvR+T5bFfLoipC1Lg8Cyfk4BJt785sD9GhiXPbZRN7eQogmuDb8AjED1
	iEIjcbK+eKeGGXX9NAY4olwOgULOTtkbTJlgF+L80XSH/CVcTohwuS2j90cajg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Shane Nehring <snehring@iastate.edu>
Subject: [PATCH 1/2] smb: client: set correct id, uid and cruid for multiuser automounts
Date: Sun, 11 Feb 2024 20:19:30 -0300
Message-ID: <20240211231931.185193-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When uid, gid and cruid are not specified, we need to set dynamically
set them into the filesystem context used for automounting otherwise
they'll end up reusing the values from the parent mount.

Fixes: 9fd29a5bae6e ("cifs: use fs_context for automounts")
Reported-by: Shane Nehring <snehring@iastate.edu>
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2259257
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/namespace.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/client/namespace.c b/fs/smb/client/namespace.c
index a6968573b775..4a517b280f2b 100644
--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -168,6 +168,21 @@ static char *automount_fullpath(struct dentry *dentry, void *page)
 	return s;
 }
 
+static void fs_context_set_ids(struct smb3_fs_context *ctx)
+{
+	kuid_t uid = current_fsuid();
+	kgid_t gid = current_fsgid();
+
+	if (ctx->multiuser) {
+		if (!ctx->uid_specified)
+			ctx->linux_uid = uid;
+		if (!ctx->gid_specified)
+			ctx->linux_gid = gid;
+	}
+	if (!ctx->cruid_specified)
+		ctx->cred_uid = uid;
+}
+
 /*
  * Create a vfsmount that we can automount
  */
@@ -205,6 +220,7 @@ static struct vfsmount *cifs_do_automount(struct path *path)
 	tmp.leaf_fullpath = NULL;
 	tmp.UNC = tmp.prepath = NULL;
 	tmp.dfs_root_ses = NULL;
+	fs_context_set_ids(&tmp);
 
 	rc = smb3_fs_context_dup(ctx, &tmp);
 	if (rc) {
-- 
2.43.0

