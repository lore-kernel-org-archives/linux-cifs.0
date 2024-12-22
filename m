Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3A018D64B;
	Sun, 22 Dec 2024 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734880293; cv=none; b=ER9c9hCB2+7ojm4Zl2hWYMo05Z5NRrW2ZEFic54i0QaG8bfULsBS3ojRxDeehJ4fFgG8gfSCdI+TbivvFyuwfGHbeCGWNKCEh3OzYXh1ihHFrPRPMTLMm7yyWcXhHHZD8tUzqeRdsb/d56a74WzlHGYPFJjgNmziGbrKP7dWLT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734880293; c=relaxed/simple;
	bh=UC9WEuMDha+geEcna4SpEFBWR0gw4mN7a7iJDLN3BGs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=luyVPGHGI7pcZmviuSLFKqhaLvinEkJ/aCOjA5b+4Vu3nOrvS48MCMBIJBMgBAeprKf2yln8XcJ6Inf80NddAwZSKGCL1FwGKYOs66a9t8zBcAZuk/Zavv0VLKGZJcjk2hpdhoLG0X9/+v86WRa7rp/xvDKHaHVpT8z/TzYGzXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qeYuS8Vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qeYuS8Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FD4C4AF09;
	Sun, 22 Dec 2024 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734880293;
	bh=UC9WEuMDha+geEcna4SpEFBWR0gw4mN7a7iJDLN3BGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeYuS8VhQiBW6IOJtEY9HtcEhui9C7oXTPbQ3WLIW9yZ0Pt40ULZrR99Z9QfaWaBi
	 SvUMGAUq3bJEdRbTliNoloKZ0LmvJzOdUw5dK+4weGkpz5xQkNcC9QqYQVXOR35Mau
	 h1G8T/rubXWl58e8zCDc3Oq0SHcTbISQYzn78zUo3F5MLU2F9d4byi30XfrIZJkJxj
	 wrGoq7xfLTzTjG8DI4kFYPFBT+eQQKIvtIUFCF5ADdaFGk9+cz2/sDLLEeTI9GgiDC
	 u3nI5Bx+rt3wwqAPuPCX8KHUKyioiS4VI6mboLZ37G1fWLZGc+sqZACMAQINuthqsP
	 szz+BfqFvF8ig==
Received: by pali.im (Postfix)
	id 50EECD48; Sun, 22 Dec 2024 16:11:23 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] cifs: Add a new xattr system.smb3_ntsd_sacl for getting or setting SACLs
Date: Sun, 22 Dec 2024 16:10:50 +0100
Message-Id: <20241222151051.23917-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222151051.23917-1-pali@kernel.org>
References: <20241222151051.23917-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Access to SACL part of SMB security descriptor is granted by SACL privilege
which by default is accessible only for local administrator. But it can be
granted to any other user by local GPO or AD. SACL access is not granted by
DACL permissions and therefore is it possible that some user would not have
access to DACLs of some file, but would have access to SACLs of all files.
So it means that for accessing SACLs (either getting or setting) in some
cases requires not touching or asking for DACLs.

Currently Linux SMB client does not allow to get or set SACLs without
touching DACLs. Which means that user without DACL access is not able to
get or set SACLs even if it has access to SACLs.

Fix this problem by introducing a new xattr for accessing only SACLs
(without DACLs and OWNER/GROUP).

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/xattr.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 7d49f38f01f3..95b8269851f3 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -31,6 +31,7 @@
  * secure, replaced by SMB2 (then even more highly secure SMB3) many years ago
  */
 #define SMB3_XATTR_CIFS_ACL "system.smb3_acl" /* DACL only */
+#define SMB3_XATTR_CIFS_NTSD_SACL "system.smb3_ntsd_sacl" /* SACL only */
 #define SMB3_XATTR_CIFS_NTSD "system.smb3_ntsd" /* owner plus DACL */
 #define SMB3_XATTR_CIFS_NTSD_FULL "system.smb3_ntsd_full" /* owner/DACL/SACL */
 #define SMB3_XATTR_ATTRIB "smb3.dosattrib"  /* full name: user.smb3.dosattrib */
@@ -38,6 +39,7 @@
 /* BB need to add server (Samba e.g) support for security and trusted prefix */
 
 enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
+	XATTR_CIFS_NTSD_SACL,
 	XATTR_CIFS_NTSD, XATTR_CIFS_NTSD_FULL };
 
 static int cifs_attrib_set(unsigned int xid, struct cifs_tcon *pTcon,
@@ -160,6 +162,7 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 		break;
 
 	case XATTR_CIFS_ACL:
+	case XATTR_CIFS_NTSD_SACL:
 	case XATTR_CIFS_NTSD:
 	case XATTR_CIFS_NTSD_FULL: {
 		struct smb_ntsd *pacl;
@@ -187,6 +190,9 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 						    CIFS_ACL_GROUP |
 						    CIFS_ACL_DACL);
 					break;
+				case XATTR_CIFS_NTSD_SACL:
+					aclflags = CIFS_ACL_SACL;
+					break;
 				case XATTR_CIFS_ACL:
 				default:
 					aclflags = CIFS_ACL_DACL;
@@ -308,6 +314,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 		break;
 
 	case XATTR_CIFS_ACL:
+	case XATTR_CIFS_NTSD_SACL:
 	case XATTR_CIFS_NTSD:
 	case XATTR_CIFS_NTSD_FULL: {
 		/*
@@ -327,6 +334,9 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 		case XATTR_CIFS_NTSD:
 			extra_info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO;
 			break;
+		case XATTR_CIFS_NTSD_SACL:
+			extra_info = SACL_SECINFO;
+			break;
 		case XATTR_CIFS_ACL:
 		default:
 			extra_info = DACL_SECINFO;
@@ -448,6 +458,13 @@ static const struct xattr_handler smb3_acl_xattr_handler = {
 	.set = cifs_xattr_set,
 };
 
+static const struct xattr_handler smb3_ntsd_sacl_xattr_handler = {
+	.name = SMB3_XATTR_CIFS_NTSD_SACL,
+	.flags = XATTR_CIFS_NTSD_SACL,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
 static const struct xattr_handler cifs_cifs_ntsd_xattr_handler = {
 	.name = CIFS_XATTR_CIFS_NTSD,
 	.flags = XATTR_CIFS_NTSD,
@@ -493,6 +510,7 @@ const struct xattr_handler * const cifs_xattr_handlers[] = {
 	&cifs_os2_xattr_handler,
 	&cifs_cifs_acl_xattr_handler,
 	&smb3_acl_xattr_handler, /* alias for above since avoiding "cifs" */
+	&smb3_ntsd_sacl_xattr_handler,
 	&cifs_cifs_ntsd_xattr_handler,
 	&smb3_ntsd_xattr_handler, /* alias for above since avoiding "cifs" */
 	&cifs_cifs_ntsd_full_xattr_handler,
-- 
2.20.1

