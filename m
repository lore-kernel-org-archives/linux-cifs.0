Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509464749C1
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 13:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664088; cv=none; b=XUraSo/r4MgCE6bX4VjtVwemAALP+r5RaOXuQf/VJQt/LNswmFgZXy3J8VHr+dlsoobCwE3gV41vFZhI864lWnc2WE0VCqiVw0GKcVBwhDI2ps12i7MAwZVYNbmXRO8kgCppFDGYHd1piG30QQvSrXjEpzzXSpnRp74t7gWIYdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664088; c=relaxed/simple;
	bh=IizGxEfTjfhZJVkwhDscGC2P/a5HlqU4Kr8qrccX6z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBAyoI5wKqv4K836fsqeko1IL7Mtq1LIKI3r8XXWuP6+pYfd5Suz2s2vnu/uXdtITgUnG2hlGCKsmh+9MQMfqfV8ICetqCgVnw4fdHO9j7ASfVRqg7euSNrNk4NQ9cOgJGJv7TuRHio6LY6SSBQskLq4laor/5oAFnzb4NfIFnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FTyxCFJd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FTyxCFJd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787664072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPPEzvtBLG/nC8I1Bmob/2jRQbbQ9nOnJ6K+0h7yLO8=;
	b=FTyxCFJd9xvrChGP+do5BDlKkLAZDFawNAbZ7uxTivTVE9HQ5X8Vvqh7PcuI/40wbFpbO0
	KFV0SSsnxjG7cuPu6FgbgOAPCBeolrKDpNJ+Yv15Gb+LocavyGB7FAvnpiVCYAEOvo+812
	RiKk2VQ4zq4FTtuN5ftTo9qe9YpbOpg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-280-_zNZWTFXOgqQRslZ6mI2LA-1; Tue,
 25 Aug 2026 09:21:10 -0400
X-MC-Unique: _zNZWTFXOgqQRslZ6mI2LA-1
X-Mimecast-MFC-AGG-ID: _zNZWTFXOgqQRslZ6mI2LA_1787664068
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2BAA1955D4D;
	Tue, 25 Aug 2026 13:21:07 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 828501944EB6;
	Tue, 25 Aug 2026 13:21:04 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/9] netfs: Fix error vs transferred passed to ->ki_complete()
Date: Tue, 25 Aug 2026 14:20:37 +0100
Message-ID: <20260825132045.1000787-4-dhowells@redhat.com>
In-Reply-To: <20260825132045.1000787-1-dhowells@redhat.com>
References: <20260825132045.1000787-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix netfs_unbuffered_write_done() to pass the amount written to
->ki_complete() rather than the error in the event of a partially complete
transfer.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/direct_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 544a4243fc59..f7d7e1b54653 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -51,7 +51,7 @@ static void netfs_unbuffered_write_done(struct netfs_io_request *wreq)
 		wreq->iocb->ki_pos += written;
 		if (wreq->iocb->ki_complete) {
 			trace_netfs_rreq(wreq, netfs_rreq_trace_ki_complete);
-			wreq->iocb->ki_complete(wreq->iocb, wreq->error ?: written);
+			wreq->iocb->ki_complete(wreq->iocb, written ?: wreq->error);
 		}
 		wreq->iocb = VFS_PTR_POISON;
 	}

