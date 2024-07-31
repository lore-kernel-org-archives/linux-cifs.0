Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744241B143B
	for <linux-cifs@vger.kernel.org>; Wed, 31 Jul 2024 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722432242; cv=pass; b=AxDKoMcnGbLUGPdiQknIIfzJmL8CxgJ2PZs/HHautZ+nphm9bEpyVt+POZPfzrPQidsS2IHOiq6ZcXxFLhNk6yeQvPK9yIxsL8WIZETTUS+HkAFtBAA2GQWnyEmFih9yQ/QE1SENDZdf08TZ02jY01N6uNsZj+2g53f98gtMm6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722432242; c=relaxed/simple;
	bh=PumqrTpP63mA7j/if7Q1m6bW9pKYu8wwgnTG05utWRA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tkE6W7ZLkNmiErMuvT0YLViySd39p+WLXID2Ba5NN6CU2vLQwuNKY6COpTwhWFSSqlI3Ez+oMpbgc8r+uUc2076Vy0SRaBWRXPNu41tJBaPCtk6/knt2hQTXLFFaSUPdLv0UJnIGBldcjYYlwspsyFhIcvSjmLhLWbIzaBsdOf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=KtuTSNjQ; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="KtuTSNjQ"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1722432232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+kJulRbdC71NUomvl07khyyDM79mgv45QVw0ROpl0zY=;
	b=KtuTSNjQH7oaShFcJfHN9tvyf3qbpDQ9MbWLEJWUrOApr8+lOijqNgdX4X0lgYjGXzWmX5
	uO9C8VijPtUrvsMehW/jq8agwNoyfo43CPPZNjYDjoMyCwvbH8+u8Ox6hMVbamRmkAU/rO
	t5/bverVozO89Eyz3kO2kSBSJ4+nNWZx3y4/L2RKQ+LzlaqZRK+45NAzWM6rcRwGxs5BWN
	2gdEd/uH/xEO1M1zbsb5Qu3IG5zUJusbR6u6WbCH5WiiRTl+futUjehTVg/z5jlgkYZyaZ
	x4ctdBlnhw1/k9VHmS36rlhBzqf9l3ZloTjPOsKj6N/C7/J4rtT0AUNAvjyrxA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1722432232; a=rsa-sha256;
	cv=none;
	b=I3o8oLq6ypuioc2vRSb6xb78gRok4LYz4lx8F1x/uuhkYIWlYvsx0eR1hEF5zYCEvB7J+a
	KDf5aefDmO5YeTG29nNss44UnGmEKzKOKZIgtwOjKspRJ1ENqlik9vkBw6lkL0hxAzsWQ3
	f370xpobhVsGATQcpZ7OJFRUMB7dA5FUxcuheA/HfHs8cPaqJy2qPg32i8zlcl5GvM4X6l
	j6roeKF49/Gvt92OU5fqjvYBOQUY0qGIc4aF6bxtThhtIHNd0kCcIxQ+R0pLNdHn9Vlo+/
	qxaSPg/Gm12sJa2rbHQyOfimT49VbIUbEr6XAIQFw+LK3SwUlY8C/CfkTP1nLQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1722432232; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=+kJulRbdC71NUomvl07khyyDM79mgv45QVw0ROpl0zY=;
	b=KtCiRrlJElxjunKKrSu674orBzbq5gx+UNopV3a7UXHTCStTTyTTSua5uYYbYn7f2zFpvs
	vrmvzNl3UFK9UmXL0InpyKdQYnMUTK7iN/MGov5Gr8vpoVDBJ9iNaDS3giEDKANSPz64bw
	AK0YvZSCaaUhqBKRlYY+tiRV/a3Wt2oMTP3sF4uABbnclYunCU9XfZyW9dstSTi4gdbSKk
	OwHAXDBTf4oSoMo/NCs/KJJEf9BZw5yDJmzQV6KiAqYvlafsmcRZEF81L9llC2l6W828My
	qX/PVIUci5m2E3Z+NWRAZea8URIIXdwn0M2BvUW9+ymj4xY6G4vYTaxy84ochw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>
Subject: [PATCH] smb: client: handle lack of FSCTL_GET_REPARSE_POINT support
Date: Wed, 31 Jul 2024 10:23:39 -0300
Message-ID: <20240731132339.471321-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As per MS-FSA 2.1.5.10.14, support for FSCTL_GET_REPARSE_POINT is
optional and if the server doesn't support it,
STATUS_INVALID_DEVICE_REQUEST must be returned for the operation.

If we find files with reparse points and we can't read them due to
lack of client or server support, just ignore it and then treat them
as regular files or junctions.

Fixes: 5f71ebc41294 ("smb: client: parse reparse point flag in create response")
Reported-by: Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>
Tested-by: Sebastian Steinbeisser <Sebastian.Steinbeisser@lrz.de>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/inode.c     | 17 +++++++++++++++--
 fs/smb/client/reparse.c   |  4 ++++
 fs/smb/client/reparse.h   | 19 +++++++++++++++++--
 fs/smb/client/smb2inode.c |  2 ++
 4 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 4a8aa1de9522..dd0afa23734c 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1042,13 +1042,26 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 	}
 
 	rc = -EOPNOTSUPP;
-	switch ((data->reparse.tag = tag)) {
-	case 0: /* SMB1 symlink */
+	data->reparse.tag = tag;
+	if (!data->reparse.tag) {
 		if (server->ops->query_symlink) {
 			rc = server->ops->query_symlink(xid, tcon,
 							cifs_sb, full_path,
 							&data->symlink_target);
 		}
+		if (rc == -EOPNOTSUPP)
+			data->reparse.tag = IO_REPARSE_TAG_INTERNAL;
+	}
+
+	switch (data->reparse.tag) {
+	case 0: /* SMB1 symlink */
+		break;
+	case IO_REPARSE_TAG_INTERNAL:
+		rc = 0;
+		if (le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY) {
+			cifs_create_junction_fattr(fattr, sb);
+			goto out;
+		}
 		break;
 	case IO_REPARSE_TAG_MOUNT_POINT:
 		cifs_create_junction_fattr(fattr, sb);
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index a0ffbda90733..689d8a506d45 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -505,6 +505,10 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	}
 
 	switch (tag) {
+	case IO_REPARSE_TAG_INTERNAL:
+		if (!(fattr->cf_cifsattrs & ATTR_DIRECTORY))
+			return false;
+		fallthrough;
 	case IO_REPARSE_TAG_DFS:
 	case IO_REPARSE_TAG_DFSR:
 	case IO_REPARSE_TAG_MOUNT_POINT:
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 6b55d1df9e2f..2c0644bc4e65 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -12,6 +12,12 @@
 #include "fs_context.h"
 #include "cifsglob.h"
 
+/*
+ * Used only by cifs.ko to ignore reparse points from files when client or
+ * server doesn't support FSCTL_GET_REPARSE_POINT.
+ */
+#define IO_REPARSE_TAG_INTERNAL ((__u32)~0U)
+
 static inline dev_t reparse_nfs_mkdev(struct reparse_posix_data *buf)
 {
 	u64 v = le64_to_cpu(*(__le64 *)buf->DataBuffer);
@@ -78,10 +84,19 @@ static inline u32 reparse_mode_wsl_tag(mode_t mode)
 static inline bool reparse_inode_match(struct inode *inode,
 				       struct cifs_fattr *fattr)
 {
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct timespec64 ctime = inode_get_ctime(inode);
 
-	return (CIFS_I(inode)->cifsAttrs & ATTR_REPARSE) &&
-		CIFS_I(inode)->reparse_tag == fattr->cf_cifstag &&
+	/*
+	 * Do not match reparse tags when client or server doesn't support
+	 * FSCTL_GET_REPARSE_POINT.  @fattr->cf_cifstag should contain correct
+	 * reparse tag from query dir response but the client won't be able to
+	 * read the reparse point data anyway.  This spares us a revalidation.
+	 */
+	if (cinode->reparse_tag != IO_REPARSE_TAG_INTERNAL &&
+	    cinode->reparse_tag != fattr->cf_cifstag)
+		return false;
+	return (cinode->cifsAttrs & ATTR_REPARSE) &&
 		timespec64_equal(&ctime, &fattr->cf_ctime);
 }
 
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 5c02a12251c8..062b86a4936f 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -930,6 +930,8 @@ int smb2_query_path_info(const unsigned int xid,
 
 	switch (rc) {
 	case 0:
+		rc = parse_create_response(data, cifs_sb, &out_iov[0]);
+		break;
 	case -EOPNOTSUPP:
 		/*
 		 * BB TODO: When support for special files added to Samba
-- 
2.45.2

