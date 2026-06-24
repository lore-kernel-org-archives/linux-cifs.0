Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0873AE19F
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 11:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782302336; cv=none; b=qi5zeFVUJ2Ebych3Wtma4zSJ11rckRcAFfrbSsvmSB4kqDZMtV3QmgW+l6vGROcn2DP9gcgjZdQUoBEDSsGlw7gwYrriN/a64GDrv9W2ae1fPuZSkzgOBms0ztysSIerSCr49s3Y6qmPllegAa8jdLJlhQgB/QTzuhS1LNz40pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782302336; c=relaxed/simple;
	bh=c24Yit3599uQLRElsJbGFusA/7JcG/6iJ0D3gBMzT4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6hi1ozKPw15oVZrqHSnKXqJsMAZMIGstysdYllCcmG+RBDMgAYTxFDZ/GJNwkF0uO/GImR9kDs0QgCF758byYqQ5I5ZCk0/HIld2JvSHDPkRHkyBgLx2TgSbuyqeEnDqd7J5xapM+DZIiaX24EuI/OL+c74CP84h8JocNXuQa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c3F58sNo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c3F58sNo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782302334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+j9T14/yKCuYIYjsdLnru9vHvjv9poR+Pk5ADqQQzV8=;
	b=c3F58sNoUW9Wy7NqF2yxTZI3VubJiAWZaEcHzKpy4CzYOlv1G+m5Ihnu7awTvyqWgBmv0M
	XwiJ57B9aZDUnQNJ8GfwQTEq8/cYvv5TxIbC9coC+DduDtARivP8YfMjuGD7IPpfJeM8Y7
	P/mbyJJVkzvqyBmt0VEL7/7ZMCjcFKI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-L0sgAPIIMFiJlli9RKjw3g-1; Wed,
 24 Jun 2026 07:58:48 -0400
X-MC-Unique: L0sgAPIIMFiJlli9RKjw3g-1
X-Mimecast-MFC-AGG-ID: L0sgAPIIMFiJlli9RKjw3g_1782302327
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E943195608F;
	Wed, 24 Jun 2026 11:58:47 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 74F42195609E;
	Wed, 24 Jun 2026 11:58:44 +0000 (UTC)
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
Subject: [PATCH v2 12/14] netfs: Fix writeback error handling
Date: Wed, 24 Jun 2026 12:57:33 +0100
Message-ID: <20260624115737.2964520-13-dhowells@redhat.com>
In-Reply-To: <20260624115737.2964520-1-dhowells@redhat.com>
References: <20260624115737.2964520-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix the error handling in writeback_iter() loop.  If an error occurs,
writeback_iter() needs to be called again with *error set to the error so
that it can clean up iteration state.  Further, the current folio needs
unlocking and redirtying.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Link: https://sashiko.dev/#/patchset/20260619140646.2633762-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index e5d4f9ba3d6b..d1f98cca5d0f 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -582,8 +582,6 @@ int netfs_writepages(struct address_space *mapping,
 		}
 
 		error = netfs_write_folio(wreq, wbc, folio);
-		if (error < 0)
-			break;
 	} while ((folio = writeback_iter(mapping, wbc, folio, &error)));
 
 	netfs_end_issue_write(wreq);
@@ -594,6 +592,9 @@ int netfs_writepages(struct address_space *mapping,
 	return error;
 
 couldnt_start:
+	folio_redirty_for_writepage(wbc, folio);
+	folio_unlock(folio);
+	writeback_iter(mapping, wbc, folio, &error);
 	netfs_kill_dirty_pages(mapping, wbc, folio);
 out:
 	netfs_wb_end(ictx);

