Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00F6241C8C
	for <linux-cifs@vger.kernel.org>; Mon, 22 Jun 2026 01:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782090775; cv=none; b=bz1b9+ndleFBr7b2vzEG2QlTs1/CJNKM8XsdJX8wP0ww0vW/H2eVrk/mfGGy+JxVrxMatm1K5lmEMQrbhNDS3nJdgLrksAVh/cSCQVOk0qfffMZ+We3Ewt3TD57X/oC4aLgq78diMIJ5cYToJwSdKpwY5OvjC9qC2sATk715Izc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782090775; c=relaxed/simple;
	bh=j94HQK6oZ0r8NQs9hVhnpkh1dynCNV5NjnR+rHJVplU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WflAHuUhLYz5xrbV28m38G9uE2ozmCg9AvawCisOueGRyyyS72k3esUmzxVWMEfEX2efW9ji0hW2AO81AygLSdkcVvBY2cWUXAQD9WCXv5ITRKtiGdC8IujVhEn7VylGnV5hGJZj8iyseXX+IIkClPl0GQqqVUuyr3EhqGzm4fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l+wPjFOD; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l+wPjFOD"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-440df1c768bso2422078fac.1
        for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 18:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782090773; x=1782695573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3a9PPciCr47HimGYz06wh3ROlaOsQ1tPkQ9F4Y9Wec=;
        b=l+wPjFODwGgs5jlwHXUNR3MWbjzGgF6okEFyWO1Q2k+ByBwVEJla4p+H6wxWjBQ3zz
         DAK0tP+3pmnGEuw8zlaN+/GO/0lb59qw9bv4Wf0LZ7hVc2GO0d8d1qG0i2dHqaa/Jzcc
         UdsG0FbGkelsmEdXN6wyBnJs23rCGpuh7xL2U5X2aE77NaFtbl8NEi16M+OEhsoBjf21
         T9VSjVSxx0xMzOWIEMttKamhErF7sSfbdbkstm/bSsnquX2oU2Vwg6J0hioTOuftVVes
         7/1CThrzVSvJDtJDTi8qh/wbPDs3tWosd2Qsvfe0Wcngbc9go3E0W5mzQLZkf40FYyRb
         L+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782090773; x=1782695573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v3a9PPciCr47HimGYz06wh3ROlaOsQ1tPkQ9F4Y9Wec=;
        b=NYMHG33KTdY4kGvF+S1ORVDCBgVN7D4WamWqxK2/a0kKg6VWKE9wDYJih5ZATQQC6n
         IeAVDv62C+25WbAzgOhFqJLXmwArlFA4S51tVNuvOJZQhVUiZwPD3SLOoZmnEf7eJLgR
         dezcN9AHg0Ha8pCyURxKvCCqTAD/a35eqUrNhci8FnMFxGRdwW09L982KJUfYr6mvcYU
         dONuudf1h21wNfE4FjDGB/sipZ3A2uRVYelYldqm06+u9OZUTnMIb7RpWfggSZlAHaUD
         B94nKCCkGwnS6manZbr13eXJtdjIx6apkXWb6ta9lzFQTcBkYe8b8Xc6fgDrs1e5npeW
         IY1g==
X-Gm-Message-State: AOJu0Yxu8m5YNb6+7oQe6yrCsXSlQBYsxrzLJcYj2dVTESbXi5Az5sOg
	asbv9kixvQF9s0eL5FzMkXDFWqsuREvldZP+pervY/PMvhqZIUQ7l4Ff37xfdPPj
X-Gm-Gg: AfdE7ckZDL8eb2QyIwq6qv69/84TRmm7MdDtU8KwrxDCGunZVV0yicP4dyJR9HRzE7e
	OJnirdYdnKiMrVBBwmgHlQ+ZofbN0itnfhnE7XDNo0U/o0FQ8XnzU7pPt/FoAFxer4XdloThghG
	hlgn+Rim8hDqB/QQLqUJXScS2kiu3lyYblHmMFs/ZrqxOsygY4puAL+ol89De0e9yW0/5kssV/g
	/o1M9LJoUlzN35IWsKZ6i82f3w5lITavHqfRZ7+fxCc96VG61R9MwC+/u7gyP6WdUwtFSSuqJTZ
	NxBAWs0lIrhNIr/FOL4sc6nh34MKaYRJUHKEw/fGmgKNQBVZeM6yLwCVR6J6AvyYTW5OhlU+a89
	1e/HkrBPbcrmHMA54kI44wZxqSoJrOt3lBHy3VQ4kdeVGazvvzVECyo3cFPIBXFn6zeSneqrsmb
	R/ZkvDQGlENvYdLqSZw/BfORhFBhz5xqt6K8SMhmpYG2dztIS+m98fQvsBVnmhrby+KIUafJv17
	Edmsr1vFSCkHMmdtqPDzsoop/T8BjfGXniN+WYZ9C+PjlGaWQXtEHQVBWUeU9iEORawWnlZlVrO
	hcKJosWvdZ37S2OwiPJ0p9M8mXJfJjJHvkD3EA==
X-Received: by 2002:a05:6820:905:b0:69e:b788:36e0 with SMTP id 006d021491bc7-6a0d8cd341cmr9696671eaf.34.1782090772772;
        Sun, 21 Jun 2026 18:12:52 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:fe9d:7f65:95c3:3c73])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472ec52815sm5206853fac.1.2026.06.21.18.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 18:12:52 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>,
	stable@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 3/3] smb/client: fix chown/chgrp with SMB3 POSIX Extensions
Date: Sun, 21 Jun 2026 20:08:17 -0500
Message-ID: <20260622010838.107524-3-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260622010838.107524-1-stfrench@microsoft.com>
References: <smfrench@gmail.com>
 <20260622010838.107524-1-stfrench@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ralph Boehme <slow@samba.org>

Ownership (chown) and group (chgrp) modifications were being ignored when
mounting with SMB3 POSIX Extensions unless CIFS_MOUNT_CIFS_ACL or
CIFS_MOUNT_MODE_FROM_SID were also explicitly set.

Fix this by checking for posix_extensions in cifs_setattr_nounix() when
updating UID and GID, ensuring that id_mode_to_cifs_acl() is called to map
and set the ownership/group information on the server.

Cc: stable@vger.kernel.org
Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 51fb7c418d52..56b0f109e41b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3376,7 +3376,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_GID)
 		gid = attrs->ia_gid;
 
-	if (sbflags & (CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_MODE_FROM_SID)) {
+	if ((sbflags & (CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_MODE_FROM_SID)) ||
+	    cifs_sb_master_tcon(cifs_sb)->posix_extensions) {
 		if (uid_valid(uid) || gid_valid(gid)) {
 			mode = NO_CHANGE_64;
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
-- 
2.53.0

