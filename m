Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748B6C4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 20:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E5723A31
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 20:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbgLQU65 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 15:58:57 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:57785 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbgLQU65 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Dec 2020 15:58:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608238737; x=1639774737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=YmPKlh6Z7zQjy5YM3miO0QALbeMXWiJWpI/BK+viLiI=;
  b=s0m6L6RoORwRO4oT/Jl9Y0fI1eexuumxbri+BrV9iK2aaVuvduXV2j+I
   ujPrNjDimhgoFIjNROAnd+UoKLe9aD4XRBIHty9aIwd0kw0AHsMKPQaYS
   mFNDILz1LE1jGFuXjRFybDT8UxVn0dpd7CvZuveSgKHQEf4NLM8OlUtot
   E=;
X-IronPort-AV: E=Sophos;i="5.78,428,1599523200"; 
   d="scan'208";a="104011435"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 17 Dec 2020 20:58:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 89702A1DA7;
        Thu, 17 Dec 2020 20:58:14 +0000 (UTC)
Received: from EX13D01UWB004.ant.amazon.com (10.43.161.157) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 20:58:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13d01UWB004.ant.amazon.com (10.43.161.157) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 17 Dec 2020 20:58:13 +0000
Received: from dev-dsk-pboris-1f-f9682a47.us-east-1.amazon.com (10.1.57.236)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 17 Dec 2020 20:58:13 +0000
Received: by dev-dsk-pboris-1f-f9682a47.us-east-1.amazon.com (Postfix, from userid 5360108)
        id 4C8C3A8C36; Thu, 17 Dec 2020 20:58:12 +0000 (UTC)
From:   Boris Protopopov <pboris@amazon.com>
To:     <pboris@amazon.com>
CC:     <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
        <samjonas@amazon.com>
Subject: [PATCH 2/2] Add SMB 2 support for getting and setting SACLs
Date:   Thu, 17 Dec 2020 20:58:08 +0000
Message-ID: <20201217205808.14756-1-pboris@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
In-Reply-To: <20201027204226.26906-1-pboris@amazon.com>
References: <20201027204226.26906-1-pboris@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix passing of the additional security info via version
operations. Force new open when getting SACL and avoid
reuse of files that were previously open without
sufficient privileges to access SACLs.

Signed-off-by: Boris Protopopov <pboris@amazon.com>
---

After further testing, I found that the security info was not being
passed correctly to opts->get_acl and opts->get_acl_by_fid(). Also,
it turned out that files open for read were being used to fetch
SACL without proper privileges. This patch fixes these issues, and
is meant to be squashed (comments dropped) with the earlier patch.

fs/cifs/cifsacl.c | 10 +++++-----
 fs/cifs/smb2ops.c |  4 ++--
 fs/cifs/smb2pdu.c |  4 +++-
 fs/cifs/xattr.c   | 10 ++++------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 353394d9ada8..6baa121952ce 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1245,7 +1245,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	int rc = 0;
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
 	struct smb_version_operations *ops;
-	const u32 unused = 0;
+	const u32 info = 0;
 
 	cifs_dbg(NOISY, "converting ACL to mode for %s\n", path);
 
@@ -1255,9 +1255,9 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	ops = tlink_tcon(tlink)->ses->server->ops;
 
 	if (pfid && (ops->get_acl_by_fid))
-		pntsd = ops->get_acl_by_fid(cifs_sb, pfid, &acllen, unused);
+		pntsd = ops->get_acl_by_fid(cifs_sb, pfid, &acllen, info);
 	else if (ops->get_acl)
-		pntsd = ops->get_acl(cifs_sb, inode, path, &acllen, unused);
+		pntsd = ops->get_acl(cifs_sb, inode, path, &acllen, info);
 	else {
 		cifs_put_tlink(tlink);
 		return -EOPNOTSUPP;
@@ -1295,7 +1295,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);
 	struct smb_version_operations *ops;
 	bool mode_from_sid, id_from_sid;
-	const u32 unused = 0;
+	const u32 info = 0;
 
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
@@ -1311,7 +1311,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 		return -EOPNOTSUPP;
 	}
 
-	pntsd = ops->get_acl(cifs_sb, inode, path, &secdesclen, unused);
+	pntsd = ops->get_acl(cifs_sb, inode, path, &secdesclen, info);
 	if (IS_ERR(pntsd)) {
 		rc = PTR_ERR(pntsd);
 		cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d28a29728fb1..f5e198860c16 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3315,9 +3315,9 @@ get_smb2_acl(struct cifs_sb_info *cifs_sb,
 	struct cifs_ntsd *pntsd = NULL;
 	struct cifsFileInfo *open_file = NULL;
 
-	if (inode)
+	if (inode && !(info & SACL_SECINFO))
 		open_file = find_readable_file(CIFS_I(inode), true);
-	if (!open_file)
+	if (!open_file || (info & SACL_SECINFO))
 		return get_smb2_acl_by_path(cifs_sb, path, pacllen, info);
 
 	pntsd = get_smb2_acl_by_fid(cifs_sb, &open_file->fid, pacllen, info);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0aeb63694306..b207e1eb6803 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3472,8 +3472,10 @@ SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 int
 SMB2_query_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	       u64 persistent_fid, u64 volatile_fid,
-	       void **data, u32 *plen, u32 additional_info)
+	       void **data, u32 *plen, u32 extra_info)
 {
+	__u32 additional_info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
+				extra_info;
 	*plen = 0;
 
 	return query_info(xid, tcon, persistent_fid, volatile_fid,
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 9318a2acf4ee..6b658a1172ef 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -340,21 +340,19 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 		 * fetch owner, DACL, and SACL if asked for full descriptor,
 		 * fetch owner and DACL otherwise
 		 */
-		u32 acllen, additional_info = 0;
+		u32 acllen, extra_info;
 		struct cifs_ntsd *pacl;
 
 		if (pTcon->ses->server->ops->get_acl == NULL)
 			goto out; /* rc already EOPNOTSUPP */
 
 		if (handler->flags == XATTR_CIFS_NTSD_FULL) {
-			additional_info = OWNER_SECINFO | GROUP_SECINFO |
-				DACL_SECINFO | SACL_SECINFO;
+			extra_info = SACL_SECINFO;
 		} else {
-			additional_info = OWNER_SECINFO | GROUP_SECINFO |
-				DACL_SECINFO;
+			extra_info = 0;
 		}
 		pacl = pTcon->ses->server->ops->get_acl(cifs_sb,
-				inode, full_path, &acllen, additional_info);
+				inode, full_path, &acllen, extra_info);
 		if (IS_ERR(pacl)) {
 			rc = PTR_ERR(pacl);
 			cifs_dbg(VFS, "%s: error %zd getting sec desc\n",
-- 
2.18.4

