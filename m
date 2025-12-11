Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C91D3101C4
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 12:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765455535; cv=none; b=klIY9GrTKAjya9NwDhhzuzfQ7STuXwps2O0MmzUFHoi0/f83XJCJ6AdUsD4ZcWrmE+Qzbq8rVYD4+D29KS6l1qvIQbABzCj2/HITFCvg7DdIZtbzXif/V04CIlY47Y/2bgSlzf2zDs2k81z5O7iN8wnxhUBwpPyl/VS/1huu9X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765455535; c=relaxed/simple;
	bh=l9zo0EXonEq03TFI/f6JGfF7B1OyrUbKh6aUqoUh/vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQ60aBYHlQiSXBdaRIKKaebSbdPAIyiGUO4MfiTCtHvfJk3nvHysiZ65mEWKvteXjATG4O6lngQlhgOW8m7XE4oeBwJRH0S/YPsF4fmDJ9pyXUhFgZU8/AmtgnlzVtHqCopuEOUnQ9XFs4AtBVWc0uUziLOYkhRUaURTSlxpn1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=blEuCVr7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="blEuCVr7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765455530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJBBsTnUoSekD8Jtjh4VEvFM2BerBPLv40YPx1hJJCY=;
	b=blEuCVr7YBSw/3iWqBz2UVPtH6i8TeAov4pF2YEgysW7NdGBz3FWhO0bPppUP42y/NQoD7
	M9yZzIMyDQ1AYJVTV10G820af27nXuKZhDSwXIHWxRFKLW9+InDgYtnUEbuzLHeDr9SjD8
	DBlXnYcLNQhm26Ze/ATFfmGRt6W/iPU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-YtZfbOEFOAGZpslpj4TF5w-1; Thu,
 11 Dec 2025 07:18:49 -0500
X-MC-Unique: YtZfbOEFOAGZpslpj4TF5w-1
X-Mimecast-MFC-AGG-ID: YtZfbOEFOAGZpslpj4TF5w_1765455528
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4BAC18009C0;
	Thu, 11 Dec 2025 12:18:47 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.14])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F8531956056;
	Thu, 11 Dec 2025 12:18:45 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 17/18] cifs: Scripted clean up fs/smb/client/reparse.h
Date: Thu, 11 Dec 2025 12:17:11 +0000
Message-ID: <20251211121715.759074-19-dhowells@redhat.com>
In-Reply-To: <20251211121715.759074-2-dhowells@redhat.com>
References: <20251211121715.759074-2-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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

