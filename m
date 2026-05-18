Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24D43921DC
	for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 21:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779138815; cv=none; b=lONW2ykKIf8+bMk7290AdCTK3sH2X0lBptZrzK+70D0i4S2+72d5ew3D8yb4KF7xF0CJCyRjcCUOKilq1MoxsJVexI5Ht4nw/hfB8Syn16tq74G5TKCsyk74g5OBmn9hJKwQdcxxLH9mRe8uMyTqVfnHMox2FA6Kx2Y9vWFuroI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779138815; c=relaxed/simple;
	bh=o/+rN4fO9ViHhv/UqBYorE9OXwCsK8MWPNhtt1y++Lw=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=fZ0WfSuzPOERplM7HgLaLH22AjufVihYVSyg54EkNn0rYDcUnfNUmfqQ/LQ4Ej71cttu9ztzmHofovfyF719+7+iew56R7nsjsxPrIzQYk1kQtYWNC0QzRZSuZb+NTEglcls3F65rRyJN9eeH0nuMCKf+T/tsAzCdnSiMaIGR18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N3SJhv6M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N3SJhv6M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779138802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+3RDtzrQ1Czo/IGpos4A/0bras1DkEJY4PPaUs+z+xw=;
	b=N3SJhv6MaMjJJTez6D7rePjIaJZ4v/tiBLOBQmC3Ybg0UoXFIHJtyOEQVIcFTQlacMnyTu
	ZW5r5YoPdwBIQBXVPXA8DMImV0z7WalEJ98g4wF4GnxdK6CQy8oIZdCZBzA1WFsAcJpXHb
	AB0lQycuQATxAa9969s6j4TkWRTezwU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-iK9HikplP56Rylpm-5s4yA-1; Mon,
 18 May 2026 17:13:17 -0400
X-MC-Unique: iK9HikplP56Rylpm-5s4yA-1
X-Mimecast-MFC-AGG-ID: iK9HikplP56Rylpm-5s4yA_1779138795
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F00BC195608D;
	Mon, 18 May 2026 21:13:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.33])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 131E51956053;
	Mon, 18 May 2026 21:13:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
cc: dhowells@redhat.com, Nathan Chancellor <nathan@kernel.org>,
    kernel test robot <lkp@intel.com>,
    Paulo Alcantara <pc@manguebit.org>,
    Matthew Wilcox <willy@infradead.org>,
    Christian Brauner <brauner@kernel.org>,
    Linus Torvalds <torvalds@linux-foundation.org>,
    linux-cifs@vger.kernel.org, netfs@lists.linux.dev,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix undefined variables
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <413532.1779138789.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 18 May 2026 22:13:09 +0100
Message-ID: <413536.1779138789@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix a couple of undefined variables introduced by the patch to fix tearing
on ->remote_i_size and ->zero_point.  For some reason, make W=3D1 with gcc
doesn't give undefined variable warnings (but clang does).

Fixes: 2c8f4742bb76 ("netfs: Fix potential for tearing in ->remote_i_size =
and ->zero_point")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605031459.eX5UbO3K-lkp@in=
tel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202605021450.ca5QGqLH-lkp@in=
tel.com/
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christian Brauner <brauner@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifsfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index feac491c5070..f557eb7875c7 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1304,7 +1304,7 @@ static loff_t cifs_remap_file_range(struct file *src=
_file, loff_t off,
 	struct cifsFileInfo *smb_file_src =3D src_file->private_data;
 	struct cifsFileInfo *smb_file_target =3D dst_file->private_data;
 	struct cifs_tcon *target_tcon, *src_tcon;
-	unsigned long long i_size, old_size, new_size, zero_point;
+	unsigned long long i_size, new_size;
 	unsigned long long destend, fstart, fend;
 	unsigned int xid;
 	int rc;
@@ -1372,7 +1372,7 @@ static loff_t cifs_remap_file_range(struct file *src=
_file, loff_t off,
 		goto unlock;
 =

 	spin_lock(&target_inode->i_lock);
-	if (fend > zero_point)
+	if (fend > target_cifsi->netfs._zero_point)
 		netfs_write_zero_point(target_inode, fend + 1);
 	i_size =3D target_inode->i_size;
 	spin_unlock(&target_inode->i_lock);
@@ -1387,7 +1387,7 @@ static loff_t cifs_remap_file_range(struct file *src=
_file, loff_t off,
 	if (target_tcon->ses->server->ops->duplicate_extents) {
 		rc =3D target_tcon->ses->server->ops->duplicate_extents(xid,
 			smb_file_src, smb_file_target, off, len, destoff);
-		if (rc =3D=3D 0 && new_size > old_size) {
+		if (rc =3D=3D 0 && new_size > i_size) {
 			truncate_setsize(target_inode, new_size);
 			fscache_resize_cookie(cifs_inode_cookie(target_inode),
 					      new_size);

