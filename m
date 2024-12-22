Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1FC188CC9;
	Sun, 22 Dec 2024 15:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734882290; cv=none; b=BuejfDH1+6WPH3vZKQPWuUa5raiU8yHp43EYgvZbgYIMM+nKNkaR/ArCSB1VgCgGj/MgBAy9Xt2SLWspdZ7f3zKVWgwU/VtK7qb+LacllDT1fyCOGLatIhq2XseFxjCMhsN202qGrvkn3d3+4kHD1WV5k9LSCf51QqUxJ0RLB5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734882290; c=relaxed/simple;
	bh=hhLFChl282HxxjSG4TJYO7INCsXhOHPkcVj3YBbRMcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3Q6hx9ATecoNurF7GSNnILONLf5JjLi8F5/cugpPIziqYWFAJolM8lgn4QKWkcnSeXxVLtiSyt9j38z3Li8FY4TLZa/jEUxEKk04MLs+RAhJxeDKI6i663Pnxa6VwKjr/+nsoiywurbRPcE4DRirbN7dgUj/0cvmGb3YWALYno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2as0Tx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2as0Tx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3DBC4CED3;
	Sun, 22 Dec 2024 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734882290;
	bh=hhLFChl282HxxjSG4TJYO7INCsXhOHPkcVj3YBbRMcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2as0Tx525BoUPcfGFlp0OaBFgCRYfo1fYbircJ1kF/2n9lYLxY8Oc+ux0bMLzrEE
	 a6n2g5W/GkYqDyshg36aG+Ex2RiX3ZyPZ4k11sevET/zEEQq67CiIUUOgmnuKaaW7+
	 07tnf4nhsfs8ApLGPWAGh9z3FmalocvDF6FeBG2RgVx4/iFKWOrVkVJC3a6bV3B+hF
	 eGqytPX74mus39HHyhEZZeqFz0Ogm8tFT62dbvGQfckfkqHc2GAXgBnsn6s6NDuggJ
	 WxmKnUOp8zwWzdLmyqmKe50beSsr6k1Gfs/0BadXhnXs9GfdeeZZhV9/2PKmIJwkLy
	 cBh0kJ87IB1Ag==
Received: by pali.im (Postfix)
	id 49B01B9A; Sun, 22 Dec 2024 16:44:40 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] cifs: Add a new xattr system.reparse for querying repase point from SMB server
Date: Sun, 22 Dec 2024 16:43:38 +0100
Message-Id: <20241222154340.24104-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222154340.24104-1-pali@kernel.org>
References: <20241222154340.24104-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently SMB client fetches and parses only few reparse point types,
those which directly maps to Linux file types.

This change introduce a new xattr system.reparse which allows userspace
application to query reparse point buffer and then let application to parse
and handle it as needed.

Currently only get xattr is implemented. Setting new reparse point,
changing it or deleting via set xattr is not implemented yet.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/xattr.c | 46 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index b88fa04f5792..7fb7662afaea 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -39,7 +39,10 @@
 #define SMB3_XATTR_CREATETIME "smb3.creationtime"  /* user.smb3.creationtime */
 /* BB need to add server (Samba e.g) support for security and trusted prefix */
 
+#define SMB_XATTR_REPARSE "system.reparse"
+
 enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
+	XATTR_REPARSE,
 	XATTR_CIFS_NTSD_SACL, XATTR_CIFS_NTSD_OWNER,
 	XATTR_CIFS_NTSD, XATTR_CIFS_NTSD_FULL };
 
@@ -162,6 +165,11 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 		}
 		break;
 
+	case XATTR_REPARSE:
+		/* TODO: Implementing setting, changing and deleting reparse point */
+		rc = -EOPNOTSUPP;
+		break;
+
 	case XATTR_CIFS_ACL:
 	case XATTR_CIFS_NTSD_SACL:
 	case XATTR_CIFS_NTSD_OWNER:
@@ -319,6 +327,36 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 				full_path, name, value, size, cifs_sb);
 		break;
 
+	case XATTR_REPARSE: {
+		struct reparse_data_buffer *reparse_buf;
+		int rsp_buftype = CIFS_NO_BUFFER;
+		struct kvec rsp_iov = {};
+		u32 reparse_len;
+		u32 tag;
+
+		if (!pTcon->ses->server->ops->query_reparse_point)
+			goto out;
+
+		rc = pTcon->ses->server->ops->query_reparse_point(xid, pTcon,
+			cifs_sb, full_path, &tag, &rsp_iov, &rsp_buftype);
+		if (rc)
+			goto out;
+
+		reparse_buf = pTcon->ses->server->ops->get_reparse_point_buffer(&rsp_iov,
+										&reparse_len);
+
+		if (value) {
+			if (reparse_len > size)
+				reparse_len = -ERANGE;
+			else
+				memcpy(value, reparse_buf, reparse_len);
+		}
+		rc = reparse_len;
+
+		free_rsp_buf(rsp_buftype, rsp_iov.iov_base);
+		break;
+	}
+
 	case XATTR_CIFS_ACL:
 	case XATTR_CIFS_NTSD_SACL:
 	case XATTR_CIFS_NTSD_OWNER:
@@ -448,6 +486,13 @@ static const struct xattr_handler cifs_os2_xattr_handler = {
 	.set = cifs_xattr_set,
 };
 
+static const struct xattr_handler cifs_reparse_xattr_handler = {
+	.name = SMB_XATTR_REPARSE,
+	.flags = XATTR_REPARSE,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
 static const struct xattr_handler cifs_cifs_acl_xattr_handler = {
 	.name = CIFS_XATTR_CIFS_ACL,
 	.flags = XATTR_CIFS_ACL,
@@ -525,6 +570,7 @@ static const struct xattr_handler smb3_ntsd_full_xattr_handler = {
 const struct xattr_handler * const cifs_xattr_handlers[] = {
 	&cifs_user_xattr_handler,
 	&cifs_os2_xattr_handler,
+	&cifs_reparse_xattr_handler,
 	&cifs_cifs_acl_xattr_handler,
 	&smb3_acl_xattr_handler, /* alias for above since avoiding "cifs" */
 	&smb3_ntsd_sacl_xattr_handler,
-- 
2.20.1

