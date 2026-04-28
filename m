Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF7047DD78
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382373; cv=none; b=J3Od3Gp97LkIeAzJgvwZ6tJ2KTSSLrzy33n7tBMSYeWitJvyyCWqskZQsOBoCtfhaO18M/ZVEUC2SkB/VG6z/VPPE1TkQqZ+aDBvf2P3bEC6Wn1vI9GaTZP0X7laNUASYLW1m8NM7TUVr/XalhxzCELsBi+4IFvFFQcZIY1DgYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382373; c=relaxed/simple;
	bh=PhAVIry4RH7jejSdAGIhxh3RBLwcrsEnhZBSvVNQ6sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0mVEayw/OAhYEpx3JtBJcbxVUa4b8dSa87EncoS5BYfwwFWGJUigmQLOopflXLXOb1cHDnhcPAxKiy8h4mp48PlpdZW0qNrFNtsIUWpOz6iSHCy3LgPcw3oPBMHxLlSACoFNqlT69o+tpxVMUE0fnqbT6/DE+c5N3o86PaKRpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RZmOQk9t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RZmOQk9t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777382369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YHPf6hGUWYEe9rJRq40F95gNcQEzsSyVW38x9qecVoo=;
	b=RZmOQk9tyByspPW9EXkzT+M/WnXeldzRPq+c9Kj3IgKxYv6okAvvizfNVJgQ+U/ZyD5xKw
	WTjIZcWhOEXJXGDj3jy7dc+ZU3hn8u4wQvvGD2u6rcZu7c2kSOi4ZKYQq7x7ENtPoZxsNR
	r9N8PZ7Sxm99jUZ20dOLOZ5c0pGU99w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-Rm4Xk0pOPTi4hjsMKKIbFw-1; Tue,
 28 Apr 2026 09:19:26 -0400
X-MC-Unique: Rm4Xk0pOPTi4hjsMKKIbFw-1
X-Mimecast-MFC-AGG-ID: Rm4Xk0pOPTi4hjsMKKIbFw_1777382363
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17465195DE6C;
	Tue, 28 Apr 2026 13:19:11 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 60A92180047F;
	Tue, 28 Apr 2026 13:19:08 +0000 (UTC)
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
Subject: [PATCH v5 14/24] netfs: Fix potential deadlock in write-through mode
Date: Tue, 28 Apr 2026 14:17:44 +0100
Message-ID: <20260428131756.922303-15-dhowells@redhat.com>
In-Reply-To: <20260428131756.922303-1-dhowells@redhat.com>
References: <20260428131756.922303-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix netfs_advance_writethrough() to always unlock the supplied folio.  It's
been marked for writeback and the caller is holding both inode->i_rwsem and
ictx->wb_lock, so there shouldn't be any danger of truncation, migration,
fallocation, flushing or other I/O interfering whilst the folio is
unlocked.

Note that this may be easier to deal with once the queuing of folios is split
from the generation of subrequests.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Closes: https://sashiko.dev/#/patchset/20260427154639.180684-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index b0e9690bb90c..0b07ebecb157 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -665,8 +665,10 @@ int netfs_advance_writethrough(struct netfs_io_request *wreq, struct writeback_c
 	}
 
 	wreq->len += copied;
-	if (!to_page_end)
+	if (!to_page_end) {
+		folio_unlock(folio);
 		return 0;
+	}
 
 	*writethrough_cache = NULL;
 	return netfs_write_folio(wreq, wbc, folio);
@@ -683,8 +685,10 @@ ssize_t netfs_end_writethrough(struct netfs_io_request *wreq, struct writeback_c
 
 	_enter("R=%x", wreq->debug_id);
 
-	if (writethrough_cache)
+	if (writethrough_cache) {
+		folio_lock(writethrough_cache);
 		netfs_write_folio(wreq, wbc, writethrough_cache);
+	}
 
 	netfs_end_issue_write(wreq);
 

