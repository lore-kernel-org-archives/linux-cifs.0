Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AE5190073
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jul 2024 16:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722270150; cv=none; b=h7mLRz+z+4zIwPwNqS1GkTAucfXDe3hA9L8ZNEtr2LzZHFWIc4GC9xIlfAjFn7Cuw6ysY5sxp9uI2aGb9uWG4+Ti/u2bUX+YCeKoqrglo4iJyFwgu8QUl6ep+0fzSsvLP8um5xQ8ndDMB3AzMkpsUTcFmSCQqOaCxPWWgcj8J7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722270150; c=relaxed/simple;
	bh=3UMfps3MS4tY9CuK1J7SRtFHrACvZi/2d9Tc1nHpwWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIjnhszlen4Bpmp/G4y1M3s7WnDohV3TwH3STvNFvJURoCfBfZTC7HKMV0b7u4BBnuTNJWXI1kODkfCxH2FoWFtvkcL2Mmphw6R1hClTy5WkVa+LufkjrJ2fgX9wDHbT/zOdv5QffOEkpYO+07+FcXyEmwlREFRrE1pvA+KX8og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iLbt1zH2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iLbt1zH2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722270148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OdyodcaxIsN9yjCj5kMWkPV/Ay0KIsoiyQ6+poCT0PE=;
	b=iLbt1zH2VX/zYK+oj1+ulNHW8PqL72BbK/VhtrHzY3RWStwtM+CCh+NNtKx2V3hTbEje+N
	9saNrI+Rwy/HwXIl/EIXs1AkA81Cz+p7hI2fh1PpE5fcxhEUliq0Mla3mHY+ifTy9LTXKu
	2bi8DNbKuQfhq+mX4cz1Xg/en77dTjE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-192-3LqD4uRGPwCG4qblk50iUw-1; Mon,
 29 Jul 2024 12:22:24 -0400
X-MC-Unique: 3LqD4uRGPwCG4qblk50iUw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5165A19560AA;
	Mon, 29 Jul 2024 16:22:20 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.216])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ACD471955D42;
	Mon, 29 Jul 2024 16:22:14 +0000 (UTC)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH 17/24] afs: Make read subreqs async
Date: Mon, 29 Jul 2024 17:19:46 +0100
Message-ID: <20240729162002.3436763-18-dhowells@redhat.com>
In-Reply-To: <20240729162002.3436763-1-dhowells@redhat.com>
References: <20240729162002.3436763-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Perform AFS read subrequests in a work item rather than in the calling
thread.  For normal buffered reads, this will allow the calling thread to
copy data from the pagecache to the application at the same time as the
demarshalling thread is shovelling data from skbuffs into the pagecache.

This will also allow the RA mark to trigger a new read before we've
finished shovelling the data from the current one.

Note: This would be a bit safer if the FS.FetchData RPC ops returned the
metadata (including the data version number) before returning the data.
This would allow me to flush the pagecache before installing the new data.

In future, it may be possible to asynchronously flush the pagecache either
side of the region being read.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-afs@lists.infradead.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/file.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index c3f0c45ae9a9..addb106dba4c 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -304,8 +304,9 @@ int afs_fetch_data(struct afs_vnode *vnode, struct afs_read *req)
 	return afs_do_sync_operation(op);
 }
 
-static void afs_issue_read(struct netfs_io_subrequest *subreq)
+static void afs_read_worker(struct work_struct *work)
 {
+	struct netfs_io_subrequest *subreq = container_of(work, struct netfs_io_subrequest, work);
 	struct afs_vnode *vnode = AFS_FS_I(subreq->rreq->inode);
 	struct afs_read *fsreq;
 
@@ -324,6 +325,12 @@ static void afs_issue_read(struct netfs_io_subrequest *subreq)
 	afs_put_read(fsreq);
 }
 
+static void afs_issue_read(struct netfs_io_subrequest *subreq)
+{
+	INIT_WORK(&subreq->work, afs_read_worker);
+	queue_work(system_long_wq, &subreq->work);
+}
+
 static int afs_symlink_read_folio(struct file *file, struct folio *folio)
 {
 	struct afs_vnode *vnode = AFS_FS_I(folio->mapping->host);

