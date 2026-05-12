Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6546F3A48EF
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 12:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589358; cv=none; b=YzQMAUJhuJPgRWfJbxFSaLrau8AyQa5El22hfWZr74BNQWrvS2cx7cdElcppKc5k/VML8PqDpig9ReJuRgVy13xdvcatXLF5im0zkLrTqNsj/gIZP7UCQNPf7JbYtQA3+tOgFCncMvvlTuVV7FBVmim9ZbYQMlUAINtdo4/DclM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589358; c=relaxed/simple;
	bh=CZ1hkvb+zk4+78/FeV2tQid3NFFqakn7Eb83+Pd3X70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyyfgSm7+ZhTBlm99M//SzC+CMSB0z5SoUHWETdAXDz7ADV57CYxymQYDucwDYuE+OOvmmxQE/OIwRf3Of0TFJuzxu0AGVeQ7llpIdC5g5/Ydag8Iy+d49HPXp7qtRdFP2ffpu3lGDb9brgWwqRRFH7SuFn/sXGm2NZM2c+8K+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cDSckIsy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cDSckIsy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778589340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=znYeqs6YKQf3OpDNaC9p5cRmGyGWOUeOdSW228VSP5w=;
	b=cDSckIsycxWOv//47RIGIOqvqITlcdp4DW10JJZ0om8fItyvz02zATgYcFCHuCwTVTYzFA
	Gh+1f14xVi9732Ae9/JBFyZvwMM4FJ5Ey4Ay11QCmzgWaNOQkFniYLUYprhbysO3kQhsw/
	T8XH9W1UHNzbMlLG/w+cSmNSEuvNqrg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-346-_Vo223qnO82GLsZlmRqG_A-1; Tue,
 12 May 2026 08:35:39 -0400
X-MC-Unique: _Vo223qnO82GLsZlmRqG_A-1
X-Mimecast-MFC-AGG-ID: _Vo223qnO82GLsZlmRqG_A_1778589337
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7414A1956095;
	Tue, 12 May 2026 12:35:37 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.83])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 78F1D1800347;
	Tue, 12 May 2026 12:35:34 +0000 (UTC)
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
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 18/24] netfs: Fix leak of request in netfs_write_begin() error handling
Date: Tue, 12 May 2026 13:33:55 +0100
Message-ID: <20260512123404.719402-19-dhowells@redhat.com>
In-Reply-To: <20260512123404.719402-1-dhowells@redhat.com>
References: <20260512123404.719402-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix netfs_write_begin() to not leak our ref on the request in the event
that we get an error from netfs_wait_for_read().

Fixes: 4090b31422a6 ("netfs: Add a function to consolidate beginning a read")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index e7ad511e494c..004d426c02b4 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -687,9 +687,9 @@ int netfs_write_begin(struct netfs_inode *ctx,
 
 	netfs_read_to_pagecache(rreq, NULL);
 	ret = netfs_wait_for_read(rreq);
+	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	if (ret < 0)
 		goto error;
-	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 
 have_folio:
 	ret = folio_wait_private_2_killable(folio);

