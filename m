Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D088346E75
	for <linux-cifs@vger.kernel.org>; Mon, 22 Dec 2025 22:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442672; cv=none; b=i5Se7EmKOgZHokqw2I2AWU64ZwOHOQjJxE3aWparmxoWA33O8UKtyzVDucIkoKsyw3VsbjpZHvhy2OlYryV1JC+Z13Yu/rluArnI4VMopyQeTXE36cnHn00OWnwcxVIooj+dy8xc7Vpu8gXdxXPIGdCJrDcH5mp1QgCEi8xMLcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442672; c=relaxed/simple;
	bh=l9zo0EXonEq03TFI/f6JGfF7B1OyrUbKh6aUqoUh/vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa89bP1nZciVYGc1eoos9Mt8Suc83e9T0Vuv5DdPA5l5LPJe+Nik4J1IPhxuVB2yXLcR1G1t3Q8sOxM0zO+7V5jdsgOkyDSx4iiqviq5lAAhpqq1Q0qVad6V5qGyI2izwcNXidQLCZcUUFMaEayCkEgwAkVRZvWyZ30JOQrxPAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f9GTpGxJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f9GTpGxJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766442669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJBBsTnUoSekD8Jtjh4VEvFM2BerBPLv40YPx1hJJCY=;
	b=f9GTpGxJAoGhc86cTtjRTGyuiPC+sFSvrgYO3UrofMhNO4UGRdtBXfD2J6GBVlfgfG3Wxl
	vvkwJD0OiQuOdtuQLo35yngMUpPR05RkW7A2grwZ0/ABHaKPAnBKK1yTXAJvmkzkdf92jP
	Y6okwuCi/i0AZMf7EAOczFThIm7SJiU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-75-Rzh3mCFFPAGEh4Ne7PYyRg-1; Mon,
 22 Dec 2025 17:31:05 -0500
X-MC-Unique: Rzh3mCFFPAGEh4Ne7PYyRg-1
X-Mimecast-MFC-AGG-ID: Rzh3mCFFPAGEh4Ne7PYyRg_1766442664
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A94A8195609F;
	Mon, 22 Dec 2025 22:31:04 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EC00F30001A2;
	Mon, 22 Dec 2025 22:31:02 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 17/37] cifs: Scripted clean up fs/smb/client/reparse.h
Date: Mon, 22 Dec 2025 22:29:42 +0000
Message-ID: <20251222223006.1075635-18-dhowells@redhat.com>
In-Reply-To: <20251222223006.1075635-1-dhowells@redhat.com>
References: <20251222223006.1075635-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/smb/client/reparse.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 19caab2fd11e..cfbb7dd28958 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -130,11 +130,12 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 				 struct cifs_fattr *fattr,
 				 struct cifs_open_info_data *data);
 int create_reparse_symlink(const unsigned int xid, struct inode *inode,
-				struct dentry *dentry, struct cifs_tcon *tcon,
-				const char *full_path, const char *symname);
-int mknod_reparse(unsigned int xid, struct inode *inode,
-		       struct dentry *dentry, struct cifs_tcon *tcon,
-		       const char *full_path, umode_t mode, dev_t dev);
-struct reparse_data_buffer *smb2_get_reparse_point_buffer(const struct kvec *rsp_iov, u32 *len);
+			   struct dentry *dentry, struct cifs_tcon *tcon,
+			   const char *full_path, const char *symname);
+int mknod_reparse(unsigned int xid, struct inode *inode, struct dentry *dentry,
+		  struct cifs_tcon *tcon, const char *full_path, umode_t mode,
+		  dev_t dev);
+struct reparse_data_buffer *smb2_get_reparse_point_buffer(const struct kvec *rsp_iov,
+							  u32 *plen);
 
 #endif /* _CIFS_REPARSE_H */

