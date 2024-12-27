Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96031F193D;
	Fri, 27 Dec 2024 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735321153; cv=none; b=WiqOd5i3Zo5irXhVTWEIBfotu5AZF2T/R/iZWbx6E1fZyGUk0YzqSaWSHPPfEisNC6pVNn7pVuTZ4sHjtYimnB88gs0IyHtFlEJjCrczgT3R9UtF3Te2xnWDyzw47atPkVv+fB3DFnZwN/o1VeaJcYYalPLh0kXolbSAfrd1TkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735321153; c=relaxed/simple;
	bh=Pmk+Xvzz2GB6vpy3BvaB3JZVSZQ0honsC6HdZiuthvk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=oIxANOnVSQPm4PfxXpem6U+++eFp+/jtNsNJiVdyyAFu0S//x0h/72+5nbrCeFxQyYXsPO8i+nP/Yf6VPtE6pt9hHOPO1qwRWzapENgRjViU82tsiockFwowV3ykUIP3m7UXTA7QaLDYTUWwcKTNcn47hL4Vd0PWjALNHdVJdh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgMrkaUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgMrkaUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2456AC4CED0;
	Fri, 27 Dec 2024 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735321153;
	bh=Pmk+Xvzz2GB6vpy3BvaB3JZVSZQ0honsC6HdZiuthvk=;
	h=From:To:Cc:Subject:Date:From;
	b=LgMrkaUTtOcOc3va7THU1stKgi0pJz1EtfvDLQYnypylGVpc8eOr5JqmJyrRp0rn3
	 QZOgJmafekcbWwNa+T1CO70NJ2hoJiN/mgI0OK3+/VN5X0xt+qqhcjTyQQslly9m2Z
	 mrXbYaRGxgs2+Z4bJTHsRgpbf6NfizQFG9D1ntkIdrG0UIR493ZKbaHCoZGPfAS50w
	 vyY9KeWasD4m+ORce4DIckKPyqnYxHo7UGUXXHy0gKjJUi461Ofi3WNvI2v8oMnOSL
	 mhaNvj4FxmAAv65fgeKgZ6LJTzuiN8GI0fFBnu2aKaR/s8I2+nhWcHwDHPr65ZFzRu
	 +A+aNsaP8t85A==
Received: by pali.im (Postfix)
	id 10B24787; Fri, 27 Dec 2024 18:39:04 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] cifs: Remove symlink member from cifs_open_info_data union
Date: Fri, 27 Dec 2024 18:38:38 +0100
Message-Id: <20241227173841.22949-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Member 'symlink' is part of the union in struct cifs_open_info_data. Its
value is assigned on few places, but is always read throw another union
member 'reparse_point'. So to make code more readable, always use only
'reparse_point' member and drop whole union structure. No function change.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h | 5 +----
 fs/smb/client/inode.c    | 2 +-
 fs/smb/client/smb1ops.c  | 4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 5045ead02c43..e1deb5f6209d 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -251,10 +251,7 @@ struct cifs_cred {
 
 struct cifs_open_info_data {
 	bool adjust_tz;
-	union {
-		bool reparse_point;
-		bool symlink;
-	};
+	bool reparse_point;
 	struct {
 		/* ioctl response buffer */
 		struct {
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index b295d161373c..ac408e3e0478 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -990,7 +990,7 @@ cifs_get_file_info(struct file *filp)
 		/* TODO: add support to query reparse tag */
 		data.adjust_tz = false;
 		if (data.symlink_target) {
-			data.symlink = true;
+			data.reparse_point = true;
 			data.reparse.tag = IO_REPARSE_TAG_SYMLINK;
 		}
 		path = build_path_from_dentry(dentry, page);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 76e7353f2a72..73d4cc1534ff 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -546,7 +546,7 @@ static int cifs_query_path_info(const unsigned int xid,
 	int rc;
 	FILE_ALL_INFO fi = {};
 
-	data->symlink = false;
+	data->reparse_point = false;
 	data->adjust_tz = false;
 
 	/* could do find first instead but this returns more info */
@@ -587,7 +587,7 @@ static int cifs_query_path_info(const unsigned int xid,
 		/* Need to check if this is a symbolic link or not */
 		tmprc = CIFS_open(xid, &oparms, &oplock, NULL);
 		if (tmprc == -EOPNOTSUPP)
-			data->symlink = true;
+			data->reparse_point = true;
 		else if (tmprc == 0)
 			CIFSSMBClose(xid, tcon, fid.netfid);
 	}
-- 
2.20.1

