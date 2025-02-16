Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EC019D89B
	for <linux-cifs@vger.kernel.org>; Sun, 16 Feb 2025 21:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739739780; cv=none; b=GNkZ8khRtWYI19fFu0z/Ah18InxgQg6v7RGWDlIguNzEKmW5kp0EiqwR2vEs4cfxBaLWFMf5vFUz/A5zOKa0kkuv9LZlyE32MlSSDtNPZCrr3bA0a88DIGaAlmX3z+0GziyvNEsa7ghRo7TIto3mwQXr/8uM3whz4espPVP8x6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739739780; c=relaxed/simple;
	bh=zUl8iwnUm1WU14t1bR7UanLgkUFGlKnCevtYucCiJSg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OVQZJI3bQQIiR4pht1HcBdz3izWD6a0IduZxzvGvZQz5Kk5BK5+QUj/YKBDcD5T/nXXxrZZ2ffzjKL0P2kdmUEa/1UcK06QPOgZ5sqvU1RNL+UfJKPV/VuFYKM1GAI+E/K8dZYxBwjYSFvHVLYduLevb8TX8FEMGxvubLSjZBJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=tEItFFcZ; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="tEItFFcZ"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1739739770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0mUDWilM/BHGX3QE+jzAQm51Byuz16Ca+nyWv/v+PJU=;
	b=tEItFFcZ3a79DJ6Y60af0getp0HF1+61olD3Kalb/iYY7GxuXBbH/T7474A5XO/Czw8Lc4
	9UZd2P3OfMcSAtT2a2xg7I2JYfbaBm9p6QvpcOwB4BHRt3GVce2wTxZp4aYzIpbdJBrZUF
	TKr6ugt2c6z/NLA4v3B+TzkRtIGw+dmnQTirc2MenYaYSq5sctsHvtgakPkJsJQ6NPcltM
	PaTvtvMw6ZLKRy/6bqdf73iH1DyQT1IlugifaEUOGxF00B/MpX31rQmmZ2ZfWv+l5lDgV3
	WWXZaxUALmrn6sjP8AgzxR1XGDqKaj/z+75xPXdF8dI7ABZinXq/1eQlTolrcg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Horst Reiterer <horst.reiterer@fabasoft.com>
Subject: [PATCH] smb: client: fix chmod(2) regression with ATTR_READONLY
Date: Sun, 16 Feb 2025 18:02:47 -0300
Message-ID: <20250216210247.190316-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the user sets a file or directory as read-only (e.g. ~S_IWUGO),
the client will set the ATTR_READONLY attribute by sending an
SMB2_SET_INFO request to the server in cifs_setattr_{,nounix}(), but
cifsInodeInfo::cifsAttrs will be left unchanged as the client will
only update the new file attributes in the next call to
{smb311_posix,cifs}_get_inode_info() with the new metadata filled in
@data parameter.

Commit a18280e7fdea ("smb: cilent: set reparse mount points as
automounts") mistakenly removed the @data NULL check when calling
is_inode_cache_good(), which broke the above case as the new
ATTR_READONLY attribute would end up not being updated on files with a
read lease.

Fix this by updating the inode whenever we have cached metadata in
@data parameter.

Reported-by: Horst Reiterer <horst.reiterer@fabasoft.com>
Closes: https://lore.kernel.org/r/85a16504e09147a195ac0aac1c801280@fabasoft.com
Fixes: a18280e7fdea ("smb: cilent: set reparse mount points as automounts")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 214240612549..616149c7f0a5 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1421,7 +1421,7 @@ int cifs_get_inode_info(struct inode **inode,
 	struct cifs_fattr fattr = {};
 	int rc;
 
-	if (is_inode_cache_good(*inode)) {
+	if (!data && is_inode_cache_good(*inode)) {
 		cifs_dbg(FYI, "No need to revalidate cached inode sizes\n");
 		return 0;
 	}
@@ -1520,7 +1520,7 @@ int smb311_posix_get_inode_info(struct inode **inode,
 	struct cifs_fattr fattr = {};
 	int rc;
 
-	if (is_inode_cache_good(*inode)) {
+	if (!data && is_inode_cache_good(*inode)) {
 		cifs_dbg(FYI, "No need to revalidate cached inode sizes\n");
 		return 0;
 	}
-- 
2.48.1

