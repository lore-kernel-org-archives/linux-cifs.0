Return-Path: <SRS0=Aa8Y=2J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD512C43603
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 16:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A611E2146E
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 16:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VSopvtiC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfLSQxB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Dec 2019 11:53:01 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36289 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfLSQxB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Dec 2019 11:53:01 -0500
Received: by mail-qk1-f196.google.com with SMTP id a203so5549275qkc.3;
        Thu, 19 Dec 2019 08:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ASbUfDCYHbt3Y67CGPVPZ89yMthCCT2FPfcqAT4MypI=;
        b=VSopvtiCElW5kTzSFVCRvQ1lxh5EIzdbMQiZ1M/U7j36ZN5PVjv4TbzMs5Z++mMuCX
         81De++WFPEfA61I0s6s4Nz5TEINn2DiHDXMft14fE3eX71i1SJDvB/PITiQsi+QYxIZv
         hndjmTu+JpwU6GrDD95iHqg6imKvPuaxR2q3yQswCzt9K6cmdb1AAMEV/kxg5OqQFJav
         eyxQlCCTYFo+5L+BCETNWR/tBqakjaD0YxFn5YHi9lK7w9q3CMt1YteOUaMbz+BVQkLd
         W4aI7HhqqGooTe1Yabx58Dt0cscim7AiRmV7y4K2n+dz8F6wskeFYUinspqQvfSIPAU6
         ksLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ASbUfDCYHbt3Y67CGPVPZ89yMthCCT2FPfcqAT4MypI=;
        b=TIOiMBjKp7BIiUGWrhwAg4+gSDzFN9Aldu91fIkOiwfuzO0LiTXWIkLnLaXK3q0Drq
         pqD+4N2o5DVytKP+jelcVPrhYuOYYf3lFYCXp2TXiaZ94TOZ0Cw6ctILw9CyugziT+LV
         KGK51Txq213fQ8PJanVKGSMV0+dlh/7W3PMUEyAlxsnzB7jKMUOvAuS5ot9G94RswAjT
         +wvMZGRBVvR9sFgC5htLs3XI2kOg7wc4hh4/31QHdYceBKdgDdEZ6zKWi3CH+BiTWgY+
         3wt3GVyJumnh8W0sImdJxJ2FNK4zpDLor8Zf0xWjiQSXvGTomDQ8XuB5eLJRZugYnfCC
         ZAvg==
X-Gm-Message-State: APjAAAW9W72NfzxHez0uULr4KAFscD0poWw1u987mlZLjlRfizQuW28i
        Qis47XQMvKqo2WQD3+iUjYM0G3FaeTSGTQ==
X-Google-Smtp-Source: APXvYqxEpAwD5rlZ5E+ac5zUv/2p3o53HH92IcRAUrbZAH3vGlu+3wpqmMX6Qmd8YbM3H6wwFEWu7g==
X-Received: by 2002:a37:4f95:: with SMTP id d143mr9535910qkb.161.1576774379187;
        Thu, 19 Dec 2019 08:52:59 -0800 (PST)
Received: from ip-172-31-1-121.ec2.internal (ec2-3-231-202-5.compute-1.amazonaws.com. [3.231.202.5])
        by smtp.gmail.com with ESMTPSA id q34sm2073960qtc.33.2019.12.19.08.52.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Dec 2019 08:52:58 -0800 (PST)
From:   Boris Protopopov <boris.v.protopopov@gmail.com>
X-Google-Original-From: Boris Protopopov <bprotopopov@hotmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     sblbir@amazon.com, boris.v.protopopov@gmail.com,
        Boris Protopopov <bprotopopov@hotmail.com>,
        Steve French <sfrench@samba.org>,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Add support for setting owner info, dos attributes, and create time
Date:   Thu, 19 Dec 2019 16:52:50 +0000
Message-Id: <20191219165250.2875-1-bprotopopov@hotmail.com>
X-Mailer: git-send-email 2.24.1.485.gad05a3d8e5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add extended attribute "system.cifs_ntsd" (and alias "system.smb3_ntsd")
to allow for setting owner and DACL in the security descriptor. This is in
addition to the existing "system.cifs_acl" and "system.smb3_acl" attributes
that allow for setting DACL only. Add support for setting creation time and
dos attributes using set_file_info() calls to complement the existing
support for getting these attributes via query_path_info() calls. 

Signed-off-by: Boris Protopopov <bprotopopov@hotmail.com>
---
 fs/cifs/xattr.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 117 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 9076150758d8..c41856e6fa22 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -32,7 +32,8 @@
 #include "cifs_unicode.h"
 
 #define MAX_EA_VALUE_SIZE CIFSMaxBufSize
-#define CIFS_XATTR_CIFS_ACL "system.cifs_acl"
+#define CIFS_XATTR_CIFS_ACL "system.cifs_acl" /* DACL only */
+#define CIFS_XATTR_CIFS_NTSD "system.cifs_ntsd" /* owner plus DACL */
 #define CIFS_XATTR_ATTRIB "cifs.dosattrib"  /* full name: user.cifs.dosattrib */
 #define CIFS_XATTR_CREATETIME "cifs.creationtime"  /* user.cifs.creationtime */
 /*
@@ -40,12 +41,62 @@
  * confusing users and using the 20+ year old term 'cifs' when it is no longer
  * secure, replaced by SMB2 (then even more highly secure SMB3) many years ago
  */
-#define SMB3_XATTR_CIFS_ACL "system.smb3_acl"
+#define SMB3_XATTR_CIFS_ACL "system.smb3_acl" /* DACL only */
+#define SMB3_XATTR_CIFS_NTSD "system.smb3_ntsd" /* owner plus DACL */
 #define SMB3_XATTR_ATTRIB "smb3.dosattrib"  /* full name: user.smb3.dosattrib */
 #define SMB3_XATTR_CREATETIME "smb3.creationtime"  /* user.smb3.creationtime */
 /* BB need to add server (Samba e.g) support for security and trusted prefix */
 
-enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT };
+enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
+	XATTR_CIFS_NTSD };
+
+static int cifs_attrib_set(unsigned int xid, struct cifs_tcon *pTcon,
+			   struct inode *inode, char *full_path,
+			   const void *value, size_t size)
+{
+	ssize_t rc = -EOPNOTSUPP;
+	__u32 *pattrib = (__u32 *)value;
+	__u32 attrib;
+	FILE_BASIC_INFO info_buf;
+
+	if ((value == NULL) || (size != sizeof(__u32)))
+		return -ERANGE;
+
+	memset(&info_buf, 0, sizeof(info_buf));
+	info_buf.Attributes = attrib = cpu_to_le32(*pattrib);
+
+	if (pTcon->ses->server->ops->set_file_info)
+		rc = pTcon->ses->server->ops->set_file_info(inode, full_path,
+				&info_buf, xid);
+	if (rc == 0)
+		CIFS_I(inode)->cifsAttrs = attrib;
+
+	return rc;
+}
+
+static int cifs_creation_time_set(unsigned int xid, struct cifs_tcon *pTcon,
+				  struct inode *inode, char *full_path,
+				  const void *value, size_t size)
+{
+	ssize_t rc = -EOPNOTSUPP;
+	__u64 *pcreation_time = (__u64 *)value;
+	__u64 creation_time;
+	FILE_BASIC_INFO info_buf;
+
+	if ((value == NULL) || (size != sizeof(__u64)))
+		return -ERANGE;
+
+	memset(&info_buf, 0, sizeof(info_buf));
+	info_buf.CreationTime = creation_time = cpu_to_le64(*pcreation_time);
+
+	if (pTcon->ses->server->ops->set_file_info)
+		rc = pTcon->ses->server->ops->set_file_info(inode, full_path,
+				&info_buf, xid);
+	if (rc == 0)
+		CIFS_I(inode)->createtime = creation_time;
+
+	return rc;
+}
 
 static int cifs_xattr_set(const struct xattr_handler *handler,
 			  struct dentry *dentry, struct inode *inode,
@@ -86,6 +137,23 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 
 	switch (handler->flags) {
 	case XATTR_USER:
+		cifs_dbg(FYI, "%s:setting user xattr %s\n", __func__, name);
+		if ((strcmp(name, CIFS_XATTR_ATTRIB) == 0) ||
+		    (strcmp(name, SMB3_XATTR_ATTRIB) == 0)) {
+			rc = cifs_attrib_set(xid, pTcon, inode, full_path,
+					value, size);
+			if (rc == 0) /* force revalidate of the inode */
+				CIFS_I(inode)->time = 0;
+			break;
+		} else if ((strcmp(name, CIFS_XATTR_CREATETIME) == 0) ||
+			   (strcmp(name, SMB3_XATTR_CREATETIME) == 0)) {
+			rc = cifs_creation_time_set(xid, pTcon, inode,
+					full_path, value, size);
+			if (rc == 0) /* force revalidate of the inode */
+				CIFS_I(inode)->time = 0;
+			break;
+		}
+
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
@@ -95,7 +163,8 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 				cifs_sb->local_nls, cifs_sb);
 		break;
 
-	case XATTR_CIFS_ACL: {
+	case XATTR_CIFS_ACL:
+	case XATTR_CIFS_NTSD: {
 		struct cifs_ntsd *pacl;
 
 		if (!value)
@@ -106,12 +175,25 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 		} else {
 			memcpy(pacl, value, size);
 			if (value &&
-			    pTcon->ses->server->ops->set_acl)
-				rc = pTcon->ses->server->ops->set_acl(pacl,
-						size, inode,
-						full_path, CIFS_ACL_DACL);
-			else
+			    pTcon->ses->server->ops->set_acl) {
+				rc = 0;
+				if (handler->flags == XATTR_CIFS_NTSD) {
+					/* set owner and DACL */
+					rc = pTcon->ses->server->ops->set_acl(
+							pacl, size, inode,
+							full_path,
+							CIFS_ACL_OWNER);
+				}
+				if (rc == 0) {
+					/* set DACL */
+					rc = pTcon->ses->server->ops->set_acl(
+							pacl, size, inode,
+							full_path,
+							CIFS_ACL_DACL);
+				}
+			} else {
 				rc = -EOPNOTSUPP;
+			}
 			if (rc == 0) /* force revalidate of the inode */
 				CIFS_I(inode)->time = 0;
 			kfree(pacl);
@@ -179,7 +261,7 @@ static int cifs_creation_time_get(struct dentry *dentry, struct inode *inode,
 				  void *value, size_t size)
 {
 	ssize_t rc;
-	__u64 * pcreatetime;
+	__u64 *pcreatetime;
 
 	rc = cifs_revalidate_dentry_attr(dentry);
 	if (rc)
@@ -244,7 +326,9 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 				full_path, name, value, size, cifs_sb);
 		break;
 
-	case XATTR_CIFS_ACL: {
+	case XATTR_CIFS_ACL:
+	case XATTR_CIFS_NTSD: {
+		/* the whole ntsd is fetched regardless */
 		u32 acllen;
 		struct cifs_ntsd *pacl;
 
@@ -382,6 +466,26 @@ static const struct xattr_handler smb3_acl_xattr_handler = {
 	.set = cifs_xattr_set,
 };
 
+static const struct xattr_handler cifs_cifs_ntsd_xattr_handler = {
+	.name = CIFS_XATTR_CIFS_NTSD,
+	.flags = XATTR_CIFS_NTSD,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
+/*
+ * Although this is just an alias for the above, need to move away from
+ * confusing users and using the 20 year old term 'cifs' when it is no
+ * longer secure and was replaced by SMB2/SMB3 a long time ago, and
+ * SMB3 and later are highly secure.
+ */
+static const struct xattr_handler smb3_ntsd_xattr_handler = {
+	.name = SMB3_XATTR_CIFS_NTSD,
+	.flags = XATTR_CIFS_NTSD,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
 static const struct xattr_handler cifs_posix_acl_access_xattr_handler = {
 	.name = XATTR_NAME_POSIX_ACL_ACCESS,
 	.flags = XATTR_ACL_ACCESS,
@@ -401,6 +505,8 @@ const struct xattr_handler *cifs_xattr_handlers[] = {
 	&cifs_os2_xattr_handler,
 	&cifs_cifs_acl_xattr_handler,
 	&smb3_acl_xattr_handler, /* alias for above since avoiding "cifs" */
+	&cifs_cifs_ntsd_xattr_handler,
+	&smb3_ntsd_xattr_handler, /* alias for above since avoiding "cifs" */
 	&cifs_posix_acl_access_xattr_handler,
 	&cifs_posix_acl_default_xattr_handler,
 	NULL
-- 
2.14.5

