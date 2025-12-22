Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D663330304
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442642; cv=none; b=hygU9uzX+64GDJLk0I2VZhT1BvEE1Gxu1Nq6oBr0gRS72+DhlD1kk2fp7Uac0YC8lRi3zEmHHzq5bsB3J2aeQ7CJgPORR6tp3N9fan9WkWOgqXvHhIGOnfGHw2Aqdi1difcRsgp/nCr29ml2mpXCcoyBXwsngI00vBLgF5KR+Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442642; c=relaxed/simple;
	bh=oMNuP5eMo7QZMktDt0t9C7WFXYZ0Qqbx4FwV3y0/MjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZX6qovTB5SlXnesA0Q++X6gjR2o3Q1FlmtIZKk40YW7xHZ33q6u20V9yEgOdvbUndnJ2akbDCMSsFAZp1q/ge1j6HnZKBpnk4Cn4azG/GVne4mPwOgJoaZRi04r7LoP24sUfUBtYysbD57VXf3ndrLVz+tTIwAFzA8L6dXEDHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TAX86pwK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TAX86pwK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YfsFPnOcbltfq8I/LYPyEFBTp8hIt6U9UoZ8nzClcJE=;
	b=TAX86pwKb9ALRGTTnHjze8QTubnkZckWMcoIflkxwFznR417JcPtrtyMEbIlFKtQ2s2qth
	AwxW7iAdYm2bcJTqBomXD4hok6NFczyu/aHrnBxeQxZ1VpY9OESr3ILJKez8O2FKhATstm
	UdzxcDpyiKgcAv6N/yQCVMdUgPqe5LE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-awN-jyr8MgC7JLyswVIp_g-1; Mon,
 22 Dec 2025 17:30:35 -0500
X-MC-Unique: awN-jyr8MgC7JLyswVIp_g-1
X-Mimecast-MFC-AGG-ID: awN-jyr8MgC7JLyswVIp_g_1766442634
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53803195608F;
	Mon, 22 Dec 2025 22:30:34 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 93D9A180049F;
	Mon, 22 Dec 2025 22:30:32 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/37] cifs: Scripted clean up fs/smb/client/dfs_cache.h
Date: Mon, 22 Dec 2025 22:29:32 +0000
Message-ID: <20251222223006.1075635-8-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/dfs_cache.h | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/dfs_cache.h b/fs/smb/client/dfs_cache.h
index 18a08a2ca93b..c99dc3546c70 100644
--- a/fs/smb/client/dfs_cache.h
+++ b/fs/smb/client/dfs_cache.h
@@ -37,17 +37,22 @@ int dfs_cache_init(void);
 void dfs_cache_destroy(void);
 extern const struct proc_ops dfscache_proc_ops;
 
-int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses, const struct nls_table *cp,
-		   int remap, const char *path, struct dfs_info3_param *ref,
+int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
+		   const struct nls_table *cp, int remap, const char *path,
+		   struct dfs_info3_param *ref,
 		   struct dfs_cache_tgt_list *tgt_list);
 int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
 			 struct dfs_cache_tgt_list *tgt_list);
-void dfs_cache_noreq_update_tgthint(const char *path, const struct dfs_cache_tgt_iterator *it);
-int dfs_cache_get_tgt_referral(const char *path, const struct dfs_cache_tgt_iterator *it,
+void dfs_cache_noreq_update_tgthint(const char *path,
+				    const struct dfs_cache_tgt_iterator *it);
+int dfs_cache_get_tgt_referral(const char *path,
+			       const struct dfs_cache_tgt_iterator *it,
 			       struct dfs_info3_param *ref);
-int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tgt_iterator *it, char **share,
-			    char **prefix);
-char *dfs_cache_canonical_path(const char *path, const struct nls_table *cp, int remap);
+int dfs_cache_get_tgt_share(char *path,
+			    const struct dfs_cache_tgt_iterator *it,
+			    char **share, char **prefix);
+char *dfs_cache_canonical_path(const char *path, const struct nls_table *cp,
+			       int remap);
 int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb);
 void dfs_cache_refresh(struct work_struct *work);
 

