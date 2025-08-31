Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3D12638BF;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643796; cv=none; b=BP8L4Kv0f0ZZqfRVmaJcIqq0Av9bvDEt8ZtX8dTyuGYea8oARXQDwDH+2HqGoOsebA7qOW6AreSAHV+YKNZeO5Nzk8rmFAxC9fA6nXJA1Q9Sq3j/XD3GrWyodRua4CrctekbSquQoD6XjkTCtoFwj699WJv9PQa80hL593fFk/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643796; c=relaxed/simple;
	bh=+QzW6WS770qe8L4U8LsmAd3yFbVgCPbv0vehCJ85w1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YwW/OgDB7WdvLXY5kbrWzofmhGdq+6D1CHG0RNMTYiBOdXIVPep9YYHpg0eB4nPFtFayBOPDB12idb7VMrW/wbYJwlKv3kMKDf7Yvni/sL4nw9D/ecr2B2LWTDwxHmMnSnO1+HDwhvdcwFZbX0IOZom+n45NXbNmorXwhT2or4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBzApElm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBzApElm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F046C4CEF6;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643796;
	bh=+QzW6WS770qe8L4U8LsmAd3yFbVgCPbv0vehCJ85w1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBzApElmB76e9kqne+3ADizGg0v5RqPjbcFkvb4DzqwHOslQN60GKUnhgaCJBSU5p
	 lc0G7DiqYvXFz1s50RmuV5vMcH58IxGNIoATSmBVztmFD0OAslYGZXaz8kG0wyj19T
	 HWSeYUNccm1oI9U0UiY83OFN2PBQT5EwZsV+IzEdAtL6rfhwRP6paIXtpbwLDoygC5
	 11xeR6sNgqsXYSGnnx06oxHSVWuVb22KsXNs3ncJ9+i3AtDd4jndyJfvmCP/FN3Ahu
	 Jdb1PtvIpdQPw44TA90W0SEJHgg2ZCZhSZ/ROqteBe9bhbcxZ0bId2+ED98g40xr+V
	 0K0pPAc/Wft3g==
Received: by pali.im (Postfix)
	id E121812ED; Sun, 31 Aug 2025 14:36:32 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/35] cifs: Fix random name construction for cifs_rename_pending_delete()
Date: Sun, 31 Aug 2025 14:35:38 +0200
Message-Id: <20250831123602.14037-12-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently the random name for SMB1 silly rename used in
cifs_rename_pending_delete() is generated as:

    cifs<mid>

This is not very unique and can cause conflicts. Also it does not match the
comment which says something different.

Change the way how it is generated and use the algorithm from nfs client
and construct random name as:

    .smb<inodenum><counter>

Where counter is global counter incremented for each request and generated
name is checked if it really does not exist before it is used. NFS client
uses same pattern but instead of ".smb" it has ".nfs".

Move random name construction code from CIFSSMBRenameOpenFile() function to
cifs_rename_pending_delete() function as it is the place where silly rename
is implemented.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 12 +-----------
 fs/smb/client/inode.c   | 38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 0d773860fd6c..8d9f6f28c17e 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2320,7 +2320,6 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
 	struct smb_com_transaction2_sfi_rsp *pSMBr = NULL;
 	struct set_file_rename *rename_info;
 	char *data_offset;
-	char dummy_string[30];
 	int rc = 0;
 	int bytes_returned = 0;
 	int len_of_str;
@@ -2354,21 +2353,12 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
 	pSMB->TotalParameterCount = pSMB->ParameterCount;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 	pSMB->DataOffset = cpu_to_le16(offset);
-	/* construct random name ".cifs_tmp<inodenum><mid>" */
 	rename_info->overwrite = cpu_to_le32(1);
 	rename_info->root_fid  = 0;
 	/* unicode only call */
-	if (target_name == NULL) {
-		sprintf(dummy_string, "cifs%x", pSMB->hdr.Mid);
-		len_of_str =
-			cifsConvertToUTF16((__le16 *)rename_info->target_name,
-					dummy_string, 24, nls_codepage, remap);
-	} else {
-		len_of_str =
-			cifsConvertToUTF16((__le16 *)rename_info->target_name,
+	len_of_str = cifsConvertToUTF16((__le16 *)rename_info->target_name,
 					target_name, PATH_MAX, nls_codepage,
 					remap);
-	}
 	rename_info->target_name_len = cpu_to_le32(2 * len_of_str);
 	count = sizeof(struct set_file_rename) + (2 * len_of_str);
 	byte_count += count;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index cd06598eacbd..a37dfd50f33d 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -6,6 +6,7 @@
  *
  */
 #include <linux/fs.h>
+#include <linux/namei.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
@@ -1689,6 +1690,13 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
  * and rename it to a random name that hopefully won't conflict with
  * anything else.
  */
+#define SILLYNAME_PREFIX ".smb"
+#define SILLYNAME_PREFIX_LEN ((unsigned int)sizeof(SILLYNAME_PREFIX) - 1)
+#define SILLYNAME_FILEID_LEN ((unsigned int)sizeof(u64) << 1)
+#define SILLYNAME_COUNTER_LEN ((unsigned int)sizeof(unsigned int) << 1)
+#define SILLYNAME_LEN (SILLYNAME_PREFIX_LEN + \
+		SILLYNAME_FILEID_LEN + \
+		SILLYNAME_COUNTER_LEN)
 int
 cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 			   const unsigned int xid)
@@ -1704,12 +1712,40 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	struct cifs_tcon *tcon;
 	__u32 dosattr, origattr;
 	FILE_BASIC_INFO *info_buf = NULL;
+	unsigned char sillyname[SILLYNAME_LEN + 1];
+	int sillyname_len;
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 
+	/* construct random name ".smb<inodenum><counter>" */
+	while (true) {
+		static unsigned int sillycounter; /* globally unique */
+		bool sillyname_available = false;
+		struct dentry *sdentry = NULL;
+
+		sillycounter++;
+		sillyname_len = scnprintf(sillyname, sizeof(sillyname),
+				 SILLYNAME_PREFIX "%0*llx%0*x",
+				 SILLYNAME_FILEID_LEN, (unsigned long long)cifsInode->uniqueid,
+				 SILLYNAME_COUNTER_LEN, sillycounter);
+		sdentry = lookup_noperm(&QSTR(sillyname), dentry->d_parent);
+		if (IS_ERR(sdentry)) {
+			rc = -EBUSY;
+			goto out;
+		}
+
+		if (d_inode(sdentry) == NULL) /* need negative lookup */
+			sillyname_available = true;
+
+		dput(sdentry);
+
+		if (sillyname_available)
+			break;
+	}
+
 	/*
 	 * We cannot rename the file if the server doesn't support
 	 * CAP_INFOLEVEL_PASSTHRU
@@ -1761,7 +1797,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	}
 
 	/* rename the file */
-	rc = CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, NULL,
+	rc = CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, sillyname,
 				   cifs_sb->local_nls,
 				   cifs_remap(cifs_sb));
 	if (rc != 0) {
-- 
2.20.1

