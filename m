Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C061C1448E0
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jul 2024 14:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721398172; cv=none; b=F/CVIKbqrUSutw70+nuK+28GDumKHo4PFKzXIhUf2yHqo1vcEJ5K2fEqAD9LcpNIAtzmObtW0Vl4NzUaWZtwrvz6SrYPIG8GXFTTOlOYj+WM/NrvIYqg8g+jXVqD8/LZ9l6fdNtIoHyZ860gVHXSQOaO1wT9vtP+w4e7KcgFZYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721398172; c=relaxed/simple;
	bh=3bHFVVT0z9X5E5gWU4+elN0GsZs75sxue8LXJL23IlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAUavfAc9LOB+9g9+lzdApwNDtZVkw83y0EdEO4eYjSeOD23O9jjnxjeHW17b5w8e+/lgpl0BTDT6QXTGoJjYehrCVHgCNQ21BMX2pdcL0FZfWQmajOkyMAVcRCmNvfe6NK/ByZ/JQcSi/vKmPTRmJVn918hWUV/8qBEaKbrDso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AJRu5D2o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AJRu5D2o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721398168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7P/rCTVhwCXDkuvtD8nEjpoSCXpKNmz+wnvcy57As00=;
	b=AJRu5D2o/GjO6ClkajcDnYoLFWDWhaITUmjK9cTyfs8Dqz9LyYBV5AwMHewLmi9b4sjdYu
	yh9SRIrLBXOAFogvP7eQ0Jzg3GSUXLhBJxSdzLYJFO6AOreevwH+rnn5KLs6p/ih5xBl2a
	/Bn0VfmPp7uj7sMiXiAd9SGuqS0HfyI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-X7YxDAcsP_6ywm0VL5Yahg-1; Fri,
 19 Jul 2024 10:09:23 -0400
X-MC-Unique: X7YxDAcsP_6ywm0VL5Yahg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E82F11955D58;
	Fri, 19 Jul 2024 14:09:21 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.216])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1B1EC1955D4D;
	Fri, 19 Jul 2024 14:09:18 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	netfs@lists.linux.dev
Subject: [PATCH 2/4] cifs: Fix missing error code set
Date: Fri, 19 Jul 2024 15:09:02 +0100
Message-ID: <20240719140907.1598372-3-dhowells@redhat.com>
In-Reply-To: <20240719140907.1598372-1-dhowells@redhat.com>
References: <20240719140907.1598372-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

In cifs_strict_readv(), the default rc (-EACCES) is accidentally cleared by
a successful return from netfs_start_io_direct(), such that if
cifs_find_lock_conflict() fails, we don't return an error.

Fix this by resetting the default error code.

Fixes: 14b1cd25346b ("cifs: Fix locking in cifs_strict_readv()")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
cc: Steve French <stfrench@microsoft.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1374635e89fa..6178c6d8097d 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2877,6 +2877,7 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 		rc = netfs_start_io_direct(inode);
 		if (rc < 0)
 			goto out;
+		rc = -EACCES;
 		down_read(&cinode->lock_sem);
 		if (!cifs_find_lock_conflict(
 			    cfile, iocb->ki_pos, iov_iter_count(to),
@@ -2889,6 +2890,7 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 		rc = netfs_start_io_read(inode);
 		if (rc < 0)
 			goto out;
+		rc = -EACCES;
 		down_read(&cinode->lock_sem);
 		if (!cifs_find_lock_conflict(
 			    cfile, iocb->ki_pos, iov_iter_count(to),

