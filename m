Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501E51B5812
	for <linux-cifs@vger.kernel.org>; Thu, 20 Jun 2024 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718904770; cv=none; b=t4qrzNNu8eEoLwFP2xSfGZCHQJjlLx5P6Bzri4e8BlcTVvDR8POcIXygraP8r0FJF83vCd2qJZZ6nsvEzTPZeWMm8+XTd0qyjB01q3Ypom7xiW7QGtDO2zS/cDroXJtRodAfJKZ/VG2pU3hzMc32tfE2mxV/laznnqrfw4tsTso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718904770; c=relaxed/simple;
	bh=++FZtOyTYIJI/XEHDGIcpQZYCcY6q8jpP5Q3welVLhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guJryohwvZbzanlvTy8d0cZ4UbD/NIxF+wBm0/NmpHIO4u1rYHibhzEtXQyLeKIzQv6epwG3rPksOyTary3+exuyJnF/cQb9XQA+XkufmsRKy7rOZXPleS7B2PAXGuzrdhqAHQiB/1zRN4+svF3UpvDdiuC0dQxB9Z3mNZLsnx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iwMJxZaE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iwMJxZaE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718904768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h+6UwHgWPCU3as5VcBuF/bmsEb6ZpHwJQoR4UTelMjE=;
	b=iwMJxZaEeeo95zMPxd6WNOptpuLBFOt01a4O3cFcaY3Ijbd3MD/k9MUVbtCHDi0deV1DCk
	MO5SSJRRQEN3zo27eMHmgtk3lVfW/sBa/gfloYY+pQx35NcAzKOIIxdTHVqN/yvx903/W/
	7W4pzIjZA3HIZDrqogDjADLgo/A4a4s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-6nmBBFraPjiFkZ70vE544A-1; Thu,
 20 Jun 2024 13:32:45 -0400
X-MC-Unique: 6nmBBFraPjiFkZ70vE544A-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B7B2E19560A0;
	Thu, 20 Jun 2024 17:32:40 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.39.195.156])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C0BA41956052;
	Thu, 20 Jun 2024 17:32:33 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>
Subject: [PATCH 06/17] 9p: Enable multipage folios
Date: Thu, 20 Jun 2024 18:31:24 +0100
Message-ID: <20240620173137.610345-7-dhowells@redhat.com>
In-Reply-To: <20240620173137.610345-1-dhowells@redhat.com>
References: <20240620173137.610345-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Enable support for multipage folios on the 9P filesystem.  This is all
handled through netfslib and is already enabled on AFS and CIFS also.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Van Hensbergen <ericvh@kernel.org>
cc: Latchesar Ionkov <lucho@ionkov.net>
cc: Dominique Martinet <asmadeus@codewreck.org>
cc: Christian Schoenebeck <linux_oss@crudebyte.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: v9fs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/9p/vfs_inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index fd72fc38c8f5..effb3aa1f3ed 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -295,6 +295,7 @@ int v9fs_init_inode(struct v9fs_session_info *v9ses,
 			inode->i_op = &v9fs_file_inode_operations;
 			inode->i_fop = &v9fs_file_operations;
 		}
+		mapping_set_large_folios(inode->i_mapping);
 
 		break;
 	case S_IFLNK:

