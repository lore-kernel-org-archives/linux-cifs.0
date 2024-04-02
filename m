Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D03CA73
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 01:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022279; cv=pass; b=QsMBiuejw98E8WctyMnL+/3/H/qFLPutYYKuBSpbKk7cY8isZYvGZtB3DcScuqtIzLbLBAu3b0fkbuqufKJPguREGzZ1civIb8qgmztziE6uBYmGKCspyYv6G0pftWSEw5ERq+oAG+OgGMVAViBlRVplshCokvkFYd+vhRbUbtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022279; c=relaxed/simple;
	bh=ZzvSIhFYuztPc2KFXhV+PP7OHzRZk1UcjZox0BezZbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrGYyPhrzYjtmZ7QpQM0fNPHwmUbAXCeOThE/5fjRZZEt/Ex0+ErZdZjzL/UvO1YUgtjhIrS+B7E64JuOeQAey6Tr05/zsHidhF64UGa7NiziUfs6i0bNiT6Ef2jGqBe8+VOPzCNaMhz4Ig4ZhL8MvtBacSJNZH0fR/uFpv/JKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=i6Xe/jI6; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="i6Xe/jI6"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712022275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/LLv72x59w6qa6wfGeApJJcz55tU4H2C7RZR4vn6CNU=;
	b=i6Xe/jI6rChRjjDRK2Uszb8qAJt7NzXlwJJdcw3oqanaiuSopFrx4Aigl2oPzWbYofyd0W
	Q7QYJG66rrLyXKAaY7F9Tebj7MEFIhOtcqcg7lg6Zg1C1G7hNu3dC75Tl1VNVTIwElNP6T
	9tjBi9ibkRngpH2isV5/Lj/AN991WlrsjdxcQlbO20O+ghZZZTRaFqXzbXCU1YJiAALmeF
	NWSljsKoxSY0ED+Ko1RKm9VVAR0EUGNjelHB4dZ6JtsA4mwFzl96HoaATsd7Vdm/MN84AT
	dOh7CaZYvwd8V4Gs+iAfdrARNZ5+9+NdFAr/+mRNlRRrrWf31tDLi+Xiqk+6eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712022275; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/LLv72x59w6qa6wfGeApJJcz55tU4H2C7RZR4vn6CNU=;
	b=MYwO2mKxgw6yh6NtjAFTkX6XtXjUzieCN8Z/M/1pTUypppN/GY3fQ6lynAHwtmyLF9lcu+
	Wo5VP935AjRdkHA3BQvD69sglNOs+qvnIEj57HdRt6KnRIr8lP9WU5fd9sO6PMohUvWr/d
	GbXSp1//LF6nCdeG/h9e4w/moWg0f3DqLRuxvf7kLDv01RecuddWi1m4FvLoue2CZt1ap2
	tDup/Ih5HezxEXBdmAxJ0YW2q46XPR/rdf29TpvEQCoaqO2mQHQZL3nrX20b6k0Qzk7YQB
	BIeVw6DRcZsJIpAzdgHcIzaR3e9NLEqagpOK9Itd3grDfKEdwhHFQHEJHxPQ6w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712022275; a=rsa-sha256;
	cv=none;
	b=K7VbIhyV5tgL5dDwY9H5BibHdtZOced4popAnJjCRpUVWuAza4CcCE2Qt7b/EICADAm6gg
	ymUl+aftiOOyYwlIxtaAYfUC5jWM9onIX8yz2dI2HSMMxGZHLrJ+7Nt3Ctitu29GQJYodX
	kv/XaUX9H/HWcLfvMPnmiltAmB179pIoeMc9yh8HxD+4Dl4ZTPMFEA02PUC3lU/FXUKVlf
	2tZ2TtK/x/FUp88OXH74lHRaD7mDkmzv4+Rsu1iDPgpqpVIN529lqrak/twb9Vm3r+7xN8
	AoKZlKmwIL6/mctRb2rckDunJZuuJ5kKg0sxsdZjskMYXwToi7CXCx/Ga0nLIg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 4/4] smb: client: serialise cifs_construct_tcon() with cifs_mount_mutex
Date: Mon,  1 Apr 2024 22:44:09 -0300
Message-ID: <20240402014409.145562-4-pc@manguebit.com>
In-Reply-To: <20240402014409.145562-1-pc@manguebit.com>
References: <20240402014409.145562-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Serialise cifs_construct_tcon() with cifs_mount_mutex to handle
parallel mounts that may end up reusing the session and tcon created
by it.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/connect.c    | 13 ++++++++++++-
 fs/smb/client/fs_context.c |  6 +++---
 fs/smb/client/fs_context.h | 12 ++++++++++++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index cc0568c3f085..27d9f262eccb 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3988,7 +3988,7 @@ cifs_set_vol_auth(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 }
 
 static struct cifs_tcon *
-cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
+__cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 {
 	int rc;
 	struct cifs_tcon *master_tcon = cifs_sb_master_tcon(cifs_sb);
@@ -4082,6 +4082,17 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	return tcon;
 }
 
+static struct cifs_tcon *
+cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
+{
+	struct cifs_tcon *ret;
+
+	cifs_mount_lock();
+	ret = __cifs_construct_tcon(cifs_sb, fsuid);
+	cifs_mount_unlock();
+	return ret;
+}
+
 struct cifs_tcon *
 cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb)
 {
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index bdcbe6ff2739..b7bfe705b2c4 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -37,7 +37,7 @@
 #include "rfc1002pdu.h"
 #include "fs_context.h"
 
-static DEFINE_MUTEX(cifs_mount_mutex);
+DEFINE_MUTEX(cifs_mount_mutex);
 
 static const match_table_t cifs_smb_version_tokens = {
 	{ Smb_1, SMB1_VERSION_STRING },
@@ -783,9 +783,9 @@ static int smb3_get_tree(struct fs_context *fc)
 
 	if (err)
 		return err;
-	mutex_lock(&cifs_mount_mutex);
+	cifs_mount_lock();
 	ret = smb3_get_tree_common(fc);
-	mutex_unlock(&cifs_mount_mutex);
+	cifs_mount_unlock();
 	return ret;
 }
 
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 7863f2248c4d..8a35645e0b65 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -304,4 +304,16 @@ extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 #define MAX_CACHED_FIDS 16
 extern char *cifs_sanitize_prepath(char *prepath, gfp_t gfp);
 
+extern struct mutex cifs_mount_mutex;
+
+static inline void cifs_mount_lock(void)
+{
+	mutex_lock(&cifs_mount_mutex);
+}
+
+static inline void cifs_mount_unlock(void)
+{
+	mutex_unlock(&cifs_mount_mutex);
+}
+
 #endif
-- 
2.44.0

