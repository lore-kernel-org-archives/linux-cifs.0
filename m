Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795230609;
	b=TKKUOis5hlXUzYs2FmEnioc+Sno2zjnMlTfBaUEkx9pvqsKS586X5v9z6RnAJrZzO3x9
	 ZuwCK5voFrNNb9oGvs2oEfcwFKOjGSIg5vJDRz5u5CBOMWXglCuNvb7vHVvotLj0XWST5
	 ThWL7imOBV/RvddpBvksvD0HFnPWK50T5v1ZsTzZR45VIH70INl/eQ2Dd6EPM/nY7GSoL
	 NGsOGqF1JsGY5YEbe3eOh+Y133NM2s4TDi2NIggbicG5aXK6Nvxz66apim2PsFXYm/jZz
	 bZ/ktdFxQKxQHLbdzdX256LIE63YzCHBfQZT1CbWhARfEOuLqsUOq57Go9AhVWKhj5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795230609;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Kk0j6F4u8RyOwIi48XCNaJybmEVI2lLpJDiNK74Ze0s=;
	b=JgHvEwLPZTv+rahr4qjrCtHDgL7XB2Z/U2aukrOKy4farbWhuBCj+fsNt8sXUt9cMiW6
	 yTZq6Zh2RWLs57crNt3aoSdtQHfbDK0Gro2l1jhKfsmxk8tc9NQgSbX9NXPHkVCzPdaSZ
	 IQIvr7b0I4O+cmHcowHPHkYuDDqHh5+7TqCLmrt/J/4DRSQHFF8CwVjrlMqKlU1JK2GXW
	 pva9woD3mYJeyruKcSrw2xbOCOHnm7RJP36a32HArM5xgAppiQYKXZmrglmaimHz+lQV0
	 mHeo8bh62pBW3YzhZWeH+qrgLPAt2dAZvBxNjymmWlRDPBOFVVvTLHlp5oj+72Ipt/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KsnBmaIa;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB0B606A697
	for <linux-cifs@vger.kernel.org>; Sat, 21 Nov 2026 03:10:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CB0B606A697
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KsnBmaIa
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-38699cf08dfso517933eec.1
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 19:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795230601; x=1795835401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kk0j6F4u8RyOwIi48XCNaJybmEVI2lLpJDiNK74Ze0s=;
        b=KsnBmaIaRGc5OUE0Ft0dc+1GePSOdQ5k+IWHdHyRvwT9Hhhw3KaJXrW/fuTQc2vod2
         EZsCawxL7ZSvd74RNTzC5GL7VbiOx1NyW7Xjbu5pcmQT1l3kf1fp6q1G7lYISYKGxMwW
         GhTvpmmh9Y4Jxi/PwD6MHfjdwHYJWZqcbKoxuRXmPiVvqnzl/TR6Vx+VR8XByUUIBUxK
         2LOkMW3qRDol7f4xv38JQUMjO1HqwsmfvGEO687iku6fz/T0kpZO9q6+5JjP35fkgEMD
         csc/JxIw38NXVMZF3xyhuvc7PMZCuMPUw6ZXXk24RlqbOO9DCxZITpAHdaFApv6LXYzK
         2yvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795230601; x=1795835401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kk0j6F4u8RyOwIi48XCNaJybmEVI2lLpJDiNK74Ze0s=;
        b=d1E0j/uuHnltJaJJLB2QTcCGQLc7OUpHtQnfen4a2ae6FZS9h/qmbU48MF9nJS9llw
         Cca1bQaRqrbqX+jI+6zgkBkNkSppqO8/2unDP0X0jF1Pw4XiVoDDKknXQNj/e2QJY7vH
         dt2NjpvBazVRcM+JH3Ia3NcFxq4iDQ8vFGKVEIH489gu5lX+pfOLcYrdK7wFcmUKA07F
         XQJCmbpwFdue//qKhL0wvweXBjdOPmgcEqbHXd2ZW/HA9KMON81vroS860k+JRG36A9z
         VXehh7e8GEjdrzdHn+ZWgL1SV4ptfxE7Fo5o/YySoi0bOMZFrZYuJoxAatVFSpy4y8fH
         sGxw==
X-Forwarded-Encrypted: i=1; AL+hErHcoxK0pWEa0/WtWSUQiDtPWlex/mvG7uVs2n2WSQM8gauV5XFcXgv5OWjs5q8tKEA1yaC3IuXNE0EG@vger.kernel.org
X-Gm-Message-State: APuU4Z/O8h+dSSX6FgVPjpj1wB61I9CoFQZbzLmGTFL+14pyYrW2CIn0
	LOrmtdOhrPhrbWhtLxpzsofRS3URiFZtfgf0VriUdzs6Wbk82Z+/Z/ze
X-Gm-Gg: AZFdTZcDH1Ja4MmVJkapUoXzqr1JQQCfoxeLyvlPiDqrrp6Njjg+Nq5gOrVBwXooquF
	gpFMUsDPBVj3LOtDg49NyAbRDk3xeHO3muSljGnX0kPY0NU1NgfyPsH0sUVm7zasfNY9hp5lUg+
	nKvfWrphms6RfQNdbvipc1Lyk1essJR0m1uXdaPd1R1YJmawxHyDIlXgyzfZIBfoFhO/Gmb3czk
	WFn1aNSo0Elfcxlzzw9yPCXNpOSvgNsYs2zmWsn6OqwPiHtaTo3mNHYvYel42xjJbZzidxkQ2eE
	YDRaOb5d/jqkbd+B7avMc2cC0pEBMSFA+ym7cl23uWpflk4PX6H85FRegDvw12pQ4MNu1hXUbY2
	DN2WVw7w01oikcCOBI91t4sIkNa/jiqjVnMcAgqXqw/+jJLZQgiTsmwVC0yXU0cuK+dXngVrKiZ
	BX74sezREYVIsL0O41P/x2rsn0JpQSl//U9I7eH9l0NbS1rwQ0QHcUIexi2bMnbE3tIOZycqC20
	nHTJNWSh6TnbKKaonyEb4Y1Jz7GWXyW02nUts51kIZwZvxWDB7cbByARkiPgzppcGF0q1kp2322
	itQISm63QOexBeKmGQzjo6arLQ6jUQ2W0gbfRfzzitLOS0+ka8wKbKxiF/tkI+iQWtmcqHGI
X-Received: by 2002:a05:7301:6285:b0:369:f182:8e99 with SMTP id 5a478bee46e88-38570554684mr5874137eec.35.1795230601058;
        Fri, 20 Nov 2026 19:10:01 -0800 (PST)
Received: from fred-server.tail1cd3ef.ts.net ([2600:381:4c20:1067::7ff])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e99fdsm15806890eec.5.2026.11.20.19.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 19:10:00 -0800 (PST)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: convert DFS prefix from cache charset on reconnect
Date: Sat, 21 Nov 2026 03:09:51 +0000
Message-ID: <20261121030951.1470502-1-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The DFS referral cache stores paths and target strings in UTF-8
(cache_cp), whereas cifs_sb->prepath must be encoded in the mount's
local charset (cifs_sb->local_nls).

When reconnecting a DFS link in tree_connect_dfs_target(),
dfs_cache_get_tgt_share() returns @prefix in cache_cp, which was
passed directly to cifs_update_super_prepath(). On mounts using a
non-UTF-8 iocharset such as iso8859-1, this overwrites
cifs_sb->prepath with UTF-8 bytes. Subsequent operations then
re-encode cifs_sb->prepath to UTF-16LE using cifs_sb->local_nls,
corrupting non-ASCII characters on the wire and causing lookups to
fail with -ENOENT.

Add dfs_cache_local_path() to convert a path from cache_cp to a
caller-specified codepage via UTF-16, and use it in a new
set_super_prepath_from_cache() helper called by
tree_connect_dfs_target() so cifs_sb->prepath stays in
cifs_sb->local_nls across reconnects.

Tested against Samba with iocharset=utf8 and iocharset=iso8859-1
across multiple smbd restarts.

Fixes: c870a8e70e68 ("cifs: handle different charsets in dfs cache")
Cc: stable@vger.kernel.org
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/dfs.c       | 18 +++++++++++++++++-
 fs/smb/client/dfs_cache.c | 31 +++++++++++++++++++++++++++++++
 fs/smb/client/dfs_cache.h |  1 +
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 788cdda9a573..efef00c33321 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -404,6 +404,22 @@ static int target_share_matches_server(struct TCP_Server_Info *server, char *sha
 	return rc;
 }
 
+/* @prefix is in the DFS cache charset, the superblock prefix in the mount charset */
+static int set_super_prepath_from_cache(struct cifs_sb_info *cifs_sb, const char *prefix)
+{
+	char *lprefix = NULL;
+	int rc;
+
+	if (prefix && *prefix) {
+		lprefix = dfs_cache_local_path(prefix, cifs_sb->local_nls);
+		if (IS_ERR(lprefix))
+			return PTR_ERR(lprefix);
+	}
+	rc = cifs_update_super_prepath(cifs_sb, lprefix);
+	kfree(lprefix);
+	return rc;
+}
+
 static int tree_connect_dfs_target(const unsigned int xid,
 				   struct cifs_tcon *tcon,
 				   struct cifs_sb_info *cifs_sb,
@@ -444,7 +460,7 @@ static int tree_connect_dfs_target(const unsigned int xid,
 		rc = ops->tree_connect(xid, tcon->ses, tree,
 				       tcon);
 		if (islink && !rc && cifs_sb)
-			rc = cifs_update_super_prepath(cifs_sb, prefix);
+			rc = set_super_prepath_from_cache(cifs_sb, prefix);
 		break;
 	}
 
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 02864f7acefc..168f563d5ef6 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -105,6 +105,37 @@ char *dfs_cache_canonical_path(const char *path, const struct nls_table *cp, int
 	return npath;
 }
 
+/**
+ * dfs_cache_local_path - convert a path from the DFS cache charset
+ *
+ * @path: path in the DFS cache charset
+ * @cp: codepage to convert to
+ *
+ * Return the converted path, which the caller must free, or an error pointer.
+ */
+char *dfs_cache_local_path(const char *path, const struct nls_table *cp)
+{
+	char *tmp, *npath;
+	int plen = 0;
+
+	if (!path || !cp || unlikely(!cache_cp))
+		return ERR_PTR(-EINVAL);
+
+	if (!strcmp(cp->charset, cache_cp->charset)) {
+		npath = kstrdup(path, GFP_KERNEL);
+		return npath ?: ERR_PTR(-ENOMEM);
+	}
+
+	tmp = (char *)cifs_strndup_to_utf16(path, strlen(path), &plen,
+					    cache_cp, NO_MAP_UNI_RSVD);
+	if (!tmp)
+		return ERR_PTR(-ENOMEM);
+
+	npath = cifs_strndup_from_utf16(tmp, plen, true, cp);
+	kfree(tmp);
+	return npath ?: ERR_PTR(-ENOMEM);
+}
+
 static inline bool cache_entry_expired(const struct cache_entry *ce)
 {
 	struct timespec64 ts;
diff --git a/fs/smb/client/dfs_cache.h b/fs/smb/client/dfs_cache.h
index c99dc3546c70..636eb1554311 100644
--- a/fs/smb/client/dfs_cache.h
+++ b/fs/smb/client/dfs_cache.h
@@ -53,6 +53,7 @@ int dfs_cache_get_tgt_share(char *path,
 			    char **share, char **prefix);
 char *dfs_cache_canonical_path(const char *path, const struct nls_table *cp,
 			       int remap);
+char *dfs_cache_local_path(const char *path, const struct nls_table *cp);
 int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb);
 void dfs_cache_refresh(struct work_struct *work);
 
-- 
2.53.0

