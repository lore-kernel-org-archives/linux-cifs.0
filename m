Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B837E47D947
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 13:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786628750; cv=none; b=cpF+U+WmotwR3aa2SGGnF/OuTZ9+HJJ5xZkMVmOcg+Dgv3ougpO1fYLg9Rw25k5KfsAfGoStQbMBJoyFZEWjROrxl4ykmhHIE5QRxzcAn+jWmJdQQ44PBtW7R+xLxxDVC2Eqo8xc3WeQLd2b5UXq378MuvMZDkgM7WOalEVvkbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786628750; c=relaxed/simple;
	bh=gZJj56dXZ3m5mpuWg5Y32mLuivOuA0n2jQSSKK4Lf/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2IILNh6NGkJ9xN4V86Y5nxZ5x34Q+7KHC0kHfr850jyoiiatkV/7Clo+A6hLmfyCtZV9kvGPyssrjpi8hLvEGkIYL1EZOahA67AH5DgduZOpf6vLNGkj9hZh+85hbL+pi2+X9RC4/SXVJnrfpiwUn41Mjb4bzzFr97M92x0MUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lvw1Dc1h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lvw1Dc1h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786628747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b4i/vAlF7TVRLwxgQcCoqCNsYOQic8KZ0Txwd6Khtt8=;
	b=Lvw1Dc1hOr/jVpzkVaiV17Q98VtG3deGnxzcQlR5rq+FRFSkY3MgqG0vFNzcfLZNXzTtRB
	HYj9ku5DmMdnK4VAQT70OLtOF1i2Rv0auvo0/Dd6wBfSa3uBbyQ8UNRDJG57mJ4HXMt8F3
	H1Roc5nJSOlITMZobZdRXDzbsLjZ7YE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-OXFYIG_jNaODMJaGLoc66A-1; Thu,
 13 Aug 2026 09:45:46 -0400
X-MC-Unique: OXFYIG_jNaODMJaGLoc66A-1
X-Mimecast-MFC-AGG-ID: OXFYIG_jNaODMJaGLoc66A_1786628744
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F91619560B2;
	Thu, 13 Aug 2026 13:45:44 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.44])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1B1C5427;
	Thu, 13 Aug 2026 13:45:40 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] netfs: Fix uninitialized return value in netfs_unbuffered_write()
Date: Thu, 13 Aug 2026 14:45:31 +0100
Message-ID: <20260813134533.1174132-2-dhowells@redhat.com>
In-Reply-To: <20260813134533.1174132-1-dhowells@redhat.com>
References: <20260813134533.1174132-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

From: Karl Mehltretter <kmehltretter@gmail.com>

If preparation of the first subrequest fails,
netfs_unbuffered_write() exits its loop before ret is initialized. The
empty-iterator check can do the same.

For synchronous writes, netfs_unbuffered_write_iter_locked() may then
return an unrelated error instead of wreq->error. This is reachable
through CIFS if cifs_prepare_write() fails to reopen the file or obtain
credits.

Initialize ret to 0 so the caller returns wreq->error if no data was
written, or the number of bytes already written otherwise.

Found with Clang's -Wconditional-uninitialized.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 fs/netfs/direct_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index c16fbad286a1..b04019097ab8 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -95,7 +95,7 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 {
 	struct netfs_io_subrequest *subreq = NULL;
 	struct netfs_io_stream *stream = &wreq->io_streams[0];
-	int ret;
+	int ret = 0;
 
 	_enter("%llx", wreq->len);
 

