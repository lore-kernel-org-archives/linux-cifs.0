Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC5C472F62
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664074; cv=none; b=gaB5U0RiLcw12+t8gSCggRkDsOreqz+5LsYjFqL52YQkp/1rQZXxEVfyV6/WmqOBwn3gDM4995sFY3PrVUv64n7ByqFgvKdWzFl/Vo4lLNClct0rbxVUrbYzW18vEfr64MCitrtpzOM6FW6aDXUX9qGgn5FWvkGgnCcmhF6iV5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664074; c=relaxed/simple;
	bh=gZJj56dXZ3m5mpuWg5Y32mLuivOuA0n2jQSSKK4Lf/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siPp38SVH7Wkt6TJDzoag4t70AeZhxidZHNeG8CkjE4ABSA+IhlMI0ZFhCx7luzlUHwIlBNWxQUJfhs1oG+7+wxUbYC4A5iwKMfKdO9GK2sQaof1Cf2SiWDsEYM/7clEa1qmjpSHeP2jH+Yu7aXrT6KPiGCO2EsoOLBXHta3qXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JuquKssl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JuquKssl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787664064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b4i/vAlF7TVRLwxgQcCoqCNsYOQic8KZ0Txwd6Khtt8=;
	b=JuquKsslWPG6HXYVOA9VNnPldHe4cRK40aZGdLnV2r8B4/f7T7Kj/Ytifd5FCjvI1IqT9v
	xXGdJ9Tcmv0eujcifODbIZ3pokywrH4n41ePcVlIBorjLDqCBqDzqsxuLRq4gl++ovIeoq
	LAmNu8uiw41igPhDEzVP1NPIfdYeEoA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-373-yNrnZdQ8McWHxJjh7PxgbA-1; Tue,
 25 Aug 2026 09:21:01 -0400
X-MC-Unique: yNrnZdQ8McWHxJjh7PxgbA-1
X-Mimecast-MFC-AGG-ID: yNrnZdQ8McWHxJjh7PxgbA_1787664058
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 208C6195F152;
	Tue, 25 Aug 2026 13:20:58 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D57EC362;
	Tue, 25 Aug 2026 13:20:54 +0000 (UTC)
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
Subject: [PATCH v2 1/9] netfs: Fix uninitialized return value in netfs_unbuffered_write()
Date: Tue, 25 Aug 2026 14:20:35 +0100
Message-ID: <20260825132045.1000787-2-dhowells@redhat.com>
In-Reply-To: <20260825132045.1000787-1-dhowells@redhat.com>
References: <20260825132045.1000787-1-dhowells@redhat.com>
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
 

