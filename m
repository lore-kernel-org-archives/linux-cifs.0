Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA0B191493;
	Sun, 22 Dec 2024 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734880294; cv=none; b=raNw95aCsZBpgeJ+1GeN1M8ptmYoqbVIeLTzxKnSkJyCP4NZ1hTO6QBKiSJAIe3pT9Z4G2i+iFSJLw6ylVBuVi4jqaIiZFREmKyljoHvWC+K2v4Drnc9zorwpo06kxOe/OlolkFQM61VBLMkdZUU6d7dYNUOqCc5aGyMSrFOQOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734880294; c=relaxed/simple;
	bh=kEKyY3zHrznWfA5YcZAgbJQi1JdoYvKGAJGSmYsejl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hkBUTZFyl1cXfkMFrNHDIOdybmT9G0QoSk5Ayzv7dPmEZaJp0rmbRSXbMm/HmiafaVX3kN9WsrFLz17xj3q7nQjI9jKEWq79eU+ZRLiVdCnsz+E1EDA7kkEC3zAoo4nw6FuUn63KtdOLO6B9kSvAYz88e8o3PiCiN+o8r8NlNSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rbYAOBVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rbYAOBVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6080FC4CED3;
	Sun, 22 Dec 2024 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734880293;
	bh=kEKyY3zHrznWfA5YcZAgbJQi1JdoYvKGAJGSmYsejl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbYAOBVX5uRVx9ok7BnjyD+HugNjxT/lnLe9lpTrne/9ePnr+Jotsz/LWj/GFPt7k
	 nlQLWqyUihujC0xrOqo1xFUoEvSPmX7u90DKxABhKpB3RcAzYU12sVihLYTb+bFz4l
	 zMQTF18dpIoT2wLslWAOnpopBXUt4uA8POY2Nkh/IgXnEKW8ydGot2bINHK6ulrOnr
	 tBCliqtV24KPu2WkMu3U+IO1kf6nlyNQ3zRJ2mm2x5eRt1s45jnWd/bRpTAchb5r0h
	 QJUZ90T13Kzgq/iJPTzkgsgGQr1yv0ZGp9XfbXGdsKRmFJJlKj25MVOfdZDByYw0Ea
	 IUH6zHF+k9iWg==
Received: by pali.im (Postfix)
	id 99C45EEC; Sun, 22 Dec 2024 16:11:23 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] cifs: Add a new xattr system.smb3_ntsd_owner for getting or setting owner
Date: Sun, 22 Dec 2024 16:10:51 +0100
Message-Id: <20241222151051.23917-5-pali@kernel.org>
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

Changing owner is controlled by DACL permission WRITE_OWNER. Changing DACL
itself is controlled by DACL permisssion WRITE_DAC. Owner of the file has
implicit WRITE_DAC permission even when it is not explicitly granted for
owner by DACL.

Reading DACL or owner is controlled only by one permission READ_CONTROL.
WRITE_OWNER permission can be bypassed by the SeTakeOwnershipPrivilege,
which is by default available for local administrators.

So if the local administrator wants to access some file to which does not
have access, it is required to first change owner to ourself and then
change DACL permissions.

Currently Linux SMB client does not support to do this, because it does not
provide a way to change owner without touching DACL permissions.

Fix this problem by introducing a new xattr for setting only owner part of
security descriptor.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/xattr.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index 95b8269851f3..b88fa04f5792 100644
--- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -32,6 +32,7 @@
  */
 #define SMB3_XATTR_CIFS_ACL "system.smb3_acl" /* DACL only */
 #define SMB3_XATTR_CIFS_NTSD_SACL "system.smb3_ntsd_sacl" /* SACL only */
+#define SMB3_XATTR_CIFS_NTSD_OWNER "system.smb3_ntsd_owner" /* owner only */
 #define SMB3_XATTR_CIFS_NTSD "system.smb3_ntsd" /* owner plus DACL */
 #define SMB3_XATTR_CIFS_NTSD_FULL "system.smb3_ntsd_full" /* owner/DACL/SACL */
 #define SMB3_XATTR_ATTRIB "smb3.dosattrib"  /* full name: user.smb3.dosattrib */
@@ -39,7 +40,7 @@
 /* BB need to add server (Samba e.g) support for security and trusted prefix */
 
 enum { XATTR_USER, XATTR_CIFS_ACL, XATTR_ACL_ACCESS, XATTR_ACL_DEFAULT,
-	XATTR_CIFS_NTSD_SACL,
+	XATTR_CIFS_NTSD_SACL, XATTR_CIFS_NTSD_OWNER,
 	XATTR_CIFS_NTSD, XATTR_CIFS_NTSD_FULL };
 
 static int cifs_attrib_set(unsigned int xid, struct cifs_tcon *pTcon,
@@ -163,6 +164,7 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 
 	case XATTR_CIFS_ACL:
 	case XATTR_CIFS_NTSD_SACL:
+	case XATTR_CIFS_NTSD_OWNER:
 	case XATTR_CIFS_NTSD:
 	case XATTR_CIFS_NTSD_FULL: {
 		struct smb_ntsd *pacl;
@@ -190,6 +192,10 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 						    CIFS_ACL_GROUP |
 						    CIFS_ACL_DACL);
 					break;
+				case XATTR_CIFS_NTSD_OWNER:
+					aclflags = (CIFS_ACL_OWNER |
+						    CIFS_ACL_GROUP);
+					break;
 				case XATTR_CIFS_NTSD_SACL:
 					aclflags = CIFS_ACL_SACL;
 					break;
@@ -315,6 +321,7 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 
 	case XATTR_CIFS_ACL:
 	case XATTR_CIFS_NTSD_SACL:
+	case XATTR_CIFS_NTSD_OWNER:
 	case XATTR_CIFS_NTSD:
 	case XATTR_CIFS_NTSD_FULL: {
 		/*
@@ -334,6 +341,9 @@ static int cifs_xattr_get(const struct xattr_handler *handler,
 		case XATTR_CIFS_NTSD:
 			extra_info = OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO;
 			break;
+		case XATTR_CIFS_NTSD_OWNER:
+			extra_info = OWNER_SECINFO | GROUP_SECINFO;
+			break;
 		case XATTR_CIFS_NTSD_SACL:
 			extra_info = SACL_SECINFO;
 			break;
@@ -465,6 +475,13 @@ static const struct xattr_handler smb3_ntsd_sacl_xattr_handler = {
 	.set = cifs_xattr_set,
 };
 
+static const struct xattr_handler smb3_ntsd_owner_xattr_handler = {
+	.name = SMB3_XATTR_CIFS_NTSD_OWNER,
+	.flags = XATTR_CIFS_NTSD_OWNER,
+	.get = cifs_xattr_get,
+	.set = cifs_xattr_set,
+};
+
 static const struct xattr_handler cifs_cifs_ntsd_xattr_handler = {
 	.name = CIFS_XATTR_CIFS_NTSD,
 	.flags = XATTR_CIFS_NTSD,
@@ -511,6 +528,7 @@ const struct xattr_handler * const cifs_xattr_handlers[] = {
 	&cifs_cifs_acl_xattr_handler,
 	&smb3_acl_xattr_handler, /* alias for above since avoiding "cifs" */
 	&smb3_ntsd_sacl_xattr_handler,
+	&smb3_ntsd_owner_xattr_handler,
 	&cifs_cifs_ntsd_xattr_handler,
 	&smb3_ntsd_xattr_handler, /* alias for above since avoiding "cifs" */
 	&cifs_cifs_ntsd_full_xattr_handler,
-- 
2.20.1

