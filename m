Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70EB3C4174;
	Tue, 29 Sep 2026 02:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790649874; cv=none; b=obVzy6N/fgw4t82QSsX6KlTNpRPsbZ3pRlxRRfEwLI5y2chthLY9hG6twFfukE1kMhd96YXjXcK99jFujZdu0E1Wuh6Z76q8J0taykLRHt+AbeHRmH1Se+ahDa5oS2K4lKML7xfFYt4ZcQgE+/gx0UHnJ8p0ou7Owt7D6B2DUwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790649874; c=relaxed/simple;
	bh=NOur+8iD3NIPL2xjR2PDIFgZIgu7k894cHjpMcwXrFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhBepN/a0ra9t2JRVSSjPMc5TpHatqYO5P5rkSyXjSI5bUauio/Wp1wPCUeROdS4JA1U2YF7L//cYVQ1gesB4IzKEWzqD1mmUAkM/j7kN0wPP1s0Zt6DGScDnwsXyUeO+iiplRhkwr3b87ryPU7XQhM6OZp+/W7hbUVSIRUqcP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=Wylr4zjD; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WJEG626a; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="Wylr4zjD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WJEG626a"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id DFD851D00109;
	Mon, 28 Sep 2026 22:44:31 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 28 Sep 2026 22:44:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790649871;
	 x=1790736271; bh=2/52RGbRVYUek+UlktvNaStIDvl7p4ic9TSPFC0w9vI=; b=
	Wylr4zjDK7aK7wH4rkPgYkQ5IiW9ng2TOi2m0ZfJqH38wlH7t8NhzacrhSO0DfsN
	LwztGIS2iPi+eaX54k80K6/Wbfe4z9MZxY8mpixwApSKnnC896j+gq2y/uIdFx7B
	9e/mul/cnfAdyjaEagTkjCdCNmS2o7wHbf2LbIahla1pBoansCsmaThnbNd/+rmm
	GN63h41dFj5fI5qrdFrY4DX0oAhpN3Kw7TZYbpaXPGilqdOD1GkpYCkkWSR8UpMY
	Pu1mHmkUVO8qxbRpy5xZ5pbCGUoWP5zFu2GZ0iCqz1J7LbRpGqAzeUDwf4GL72g+
	2fiNnqKSJqR9I1W6/uI2Fw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790649871; x=1790736271; bh=2
	/52RGbRVYUek+UlktvNaStIDvl7p4ic9TSPFC0w9vI=; b=WJEG626aLsIRwzQsc
	AbCaZs8mVoeG/cLQvXAsZw09xILNPO8p7XTscJl2A2GkLBuIcJKOLSO1/p3F9ncQ
	4cOR6FUYz/Rk8CyrFN1M7V3SGm3iPjmCGcKtDtYNQvEhAN/aRsi4c3A1mKIYhgYe
	gROP0PR5q30sWmY1SrNc7oGd+X0Q4WWYvRLBhz6SMZTSpLdDwZZyGC1On1toesCe
	3tIuytyb8FDL4yYYOsgEsSb4xW46ye1JAf+X9IXrtlUkItfNS60wFxa5k79jDQMo
	RO1PGIwdVqfGC+YslrrAJFqYkIXMSYmX4ySEvZOBdisvoL8d5RWIse2y8iY3GWaN
	ATDtg==
X-ME-Sender: <xms:Dya7akdAeaLjm2EWS6zRP_tmbtCuULznPCgbCqFSJZw-p2SpcW3whQ>
    <xme:Dya7apQpSSEGGm-faburVbEGkug_DwlG-IhoOLsycmYzGpEDhuNqKBydD8ZuAbvp2
    PE6TVH1487h6h7zNSuhPwT9fhoku0PmUO0whvOWTJk4s1ZofBk>
X-ME-Received: <xmr:Dya7agKED_BUBXKnOfZD7gLXVmUTX46QFXq2HtkuwHEac0tzyu6Yzi7Cu1vlQpYCf1NY7pCnzNkzc6iS8oz-JcTzhWvpnJI>
X-ME-Proxy-Cause: dmFkZTGAETtLDaRhdK6zWwmD1skNo8oznbv/e2xQZSM2ujkSFd8PU+upR8wF9a9fwoqrPi
    faFoaFPojV/QsMDEtCK+pCBky2JCKDOeWUD5950YGVNewPYv1IqWWG2tHJT/nOvQXrcJ2C
    /dpBuqeOPU2uOmbufh4kWWa+l7OFQMxu6h0qLmDFlSzqkcbyXgnWtP7/5Hlg9k5TDoNx7W
    Lnhj8TKJndVGVDvl1jI4nKhIHo66v/mWkc8wAAFi0DtOQRMaKIvR3BY7zTw13iHmHBEtzh
    xF5p/hKrSHHFxZfSHEj+9lI/7B/SyYuQzS+5bRvoY3OjIJ4y7CH2qWNNwosk4t5FaLNCql
    ccIBmDO1lwzW4/2wZh+pgAeosGL8W2q6tcUX+aQQiCpTzlIu0NwQjVmJq9iVx0jJlsTTE3
    s4u9hLHgjAGjKAAtXpohrcmFV0uSwTKk6E33I7A3RHXjeWDQXaaZ+5sC0P2Tc4OLT6VXP0
    /Ew3+KnmiiVdaO49Qr/nL/dM540+rjtSJpMKVmdIsCRTmueMqimZAvAsdqkX4bXvrwjOrS
    Ilz4YaveVtdXNPJ2+lxYRzvfvLJJikHeVNzfaT03nc8vsPY75yoX2pPCQrj3VOcylaDElu
    xtSiYWbJ3cPBMuix6s0yTIrEnUDiUiWxq/qcDEBGNxTFHmLodgTsfhlRT49Q
X-ME-Proxy: <xmx:Dya7amJ4D24XJ8uGloIKqTMmnu32-h563_CUcoaySWaTw5-6WuAUQg>
    <xmx:Dya7ari21kzXKx_QEDyEvCzflwE2YDm40h51EgYV9XjE3OHox820sQ>
    <xmx:Dya7agMtp2NadnMWT4P_c6w1O1S-zQqJJFbV5KcaeArPIJlHJ7JCrQ>
    <xmx:Dya7amqe3ULI0OZz0W6MuTfsIXEcipQdow9p8euK-rJyZmxlRudMmw>
    <xmx:Dya7apgUguoO3a2YOHg9m8AkDrfTsusLa_x8-hUBtu3cFM1UEkiuewgE>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 22:44:28 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] smb/client: use d_alloc_trylock in cifs_silly_fullpath()
Date: Tue, 29 Sep 2026 12:40:02 +1000
Message-ID: <20260929024352.1433257-3-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929024352.1433257-1-neilb@ownmail.net>
References: <20260929024352.1433257-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

Rather than performing a normal lookup (which will be awkward with future
locking changes) use d_alloc_trylock() to find a dentry for an
unused name, and use an open-coded lookup_slow() to see if it is free on
the server.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/dir.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 88fff65320f5..70ca3da28913 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -1183,23 +1183,36 @@ char *cifs_silly_fullpath(struct dentry *dentry)
 	unsigned char name[CIFS_SILLYNAME_LEN + 1];
 	int retries = 0, max_retries = 16;
 	size_t namesize = sizeof(name);
-	struct dentry *sdentry = NULL;
+	struct dentry *sdentry = NULL, *alias;
 	char *path;
 
 	do {
 		dput(sdentry);
 		scnprintf(name, namesize, CIFS_SILLYNAME_PREFIX "%x",
 			  atomic_inc_return(&cifs_sillycounter));
-		sdentry = lookup_noperm(&QSTR(name), dentry->d_parent);
+		sdentry = d_alloc_trylock(dentry->d_parent, &QSTR(name));
+		if (sdentry == ERR_PTR(-EWOULDBLOCK)) {
+			sdentry = NULL;
+			continue;
+		}
 		if (IS_ERR(sdentry))
 			return ERR_CAST(sdentry);
-		if (d_is_negative(sdentry)) {
-			dput(sdentry);
-			path = alloc_parent_path(dentry, CIFS_SILLYNAME_LEN);
-			if (!IS_ERR(path))
-				strcat(path, name);
-			return path;
+		if (!d_in_lookup(sdentry))
+			continue;
+		alias = cifs_lookup(sdentry->d_parent->d_inode, sdentry, 0);
+		d_lookup_done(sdentry);
+		/* It is safest to return -EBUSY if there is an error in lookup */
+		if (IS_ERR(alias))
+			break;
+		if (alias || d_is_positive(sdentry)) {
+			dput(alias);
+			continue;
 		}
+		dput(sdentry);
+		path = alloc_parent_path(dentry, CIFS_SILLYNAME_LEN);
+		if (!IS_ERR(path))
+			strcat(path, name);
+		return path;
 	} while (++retries < max_retries);
 	dput(sdentry);
 	return ERR_PTR(-EBUSY);
-- 
2.50.0.107.gf914562f5916.dirty

