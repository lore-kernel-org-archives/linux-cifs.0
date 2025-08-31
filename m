Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2A826A0C7;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=RRwWM/IdNsm+oNcTHTDqhemRHdaJkGEP3+DbXQlrd78BO0NR09OaHLAHhUrJ+TYFlbh0ptby/r00KAWJi5cDziBwvYP75ROFeYsqvGd45s9ZSGJXvM2moJ2Q/gDXDNLoh4JRKnoVvPqJiEcD1MBkaOTWHFaZQGHZjd0xlwbzExY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=sFpDM8FK52/mxVHxZVDv7mb5QxtBQgGkmwUad9YdCTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FA2lasTT9F/q519euIIyU5RJVr7tMr4c5SlfyIq/rhzRknRO1EdE/Sck1V7UOc0O5VAI7nfcyLKtQg/JW4WmMeEXUITnNroVV1nYx0f4gw4Egy8Wo4pe0qeVTGuuhrk/65QBkbyop23mPdMKKyPUSIneGLLPd02fV6WIezrKPCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utmcu6pR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utmcu6pR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6F8C4AF0C;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643798;
	bh=sFpDM8FK52/mxVHxZVDv7mb5QxtBQgGkmwUad9YdCTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utmcu6pRYBkYyu2x0i5fimlgRzvzl0xydkcn1bjlYd0oGV731wnNTUN73Y8uwMM+Y
	 io08NMRF+xZvHeuzQv+fQ+mtuGghOISzPiOgqLSW+Z4Vnq19+/JU3ApiSOd2G8S75y
	 jfLUeaGPlLq/+cQp/KLajkQYfKPGJR+RZGT6CO2MoK88FMetobXBe9CJuhTKEhBfsq
	 Rpy4s8w/PgouRgLh7P2QrHOW1GP06HxEoE7EemI1op6t+PqcT4rz1Knbd0hxCHeR21
	 kT/vGXvA2sJp0sDAFmUjGbB2rWbvOXaBZ28C0GrPSKfwP4HndmmyB14YkAYXCSy+Qi
	 IOIvJdu3NtvHw==
Received: by pali.im (Postfix)
	id C0C3DF12; Sun, 31 Aug 2025 14:36:36 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 29/35] cifs: Fix smb2_rmdir() on reparse point
Date: Sun, 31 Aug 2025 14:35:56 +0200
Message-Id: <20250831123602.14037-30-pali@kernel.org>
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

rmdir() should remove the directory node specified by the path and not the
path where reparse point can point. Open flag OPEN_REPARSE_POINT cause to
remove directory node itself.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c69293fcf26c..59d73e01ccd2 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1333,7 +1333,7 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 
 	drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name, DELETE,
-			     FILE_OPEN, CREATE_NOT_FILE, ACL_NO_MODE);
+			     FILE_OPEN, CREATE_NOT_FILE | OPEN_REPARSE_POINT, ACL_NO_MODE);
 	return smb2_compound_op(xid, tcon, cifs_sb,
 				name, &oparms, NULL,
 				&(int){SMB2_OP_RMDIR}, 1,
-- 
2.20.1

