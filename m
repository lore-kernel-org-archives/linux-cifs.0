Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4390B389E1A
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 11:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782302338; cv=none; b=bUK5OigMW1PyT8lMGDRRne06cVQJUKPHcJy2Yg3SbEQJUrBaTAHIrnNVULoE8Eaw/T7MDAmgxDt7bJqJZ8YekgJPkXAf31bcyKrMxlLtWtcQct8d7kPMCNyAoeA649bUuu+lGjtVX39B9jtJxEmiRQewa2TlKSK/El+3kFCGL2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782302338; c=relaxed/simple;
	bh=RwAt3MSlG/ONZGVRygqzttUaCRCyVrGiYvhxyiEUhSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2T0WWTGaGdV8NohFbVxL/dkphCROJAm+Tba+HbaIpHT7w3NlEzTgjnLCi1uuRNaWic4QAjYrnpAbaMW2IDVPb7xUgfSwJyz47OQ/Yjt+u0CuIseU/oA7Uq9nhlikopRDx+hiKYlfRnF4iNSzT6nX9//xkR5UxefUski1pOi/c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jy/LB6o7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jy/LB6o7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782302336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eC9TaEemzBkRAGMHHkG2uG9PLx8V8MWirBLhS6odgqY=;
	b=Jy/LB6o7w9szHZBdLWg145Ad8gSlME457O0paZ2ddXl+bhXtbf3KoEl295U+5uhC8sW0r2
	oSHDbXqiTl8nxd0/2xYY5ZIgMZelWBTsmEdP674qDb+d8azo//RofmkwDubjdNCUGzar44
	/k3bPyg+uj/0hSLydorILXipgHOYiS0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-G89D9wEENYKKA1EPScX3RQ-1; Wed,
 24 Jun 2026 07:58:53 -0400
X-MC-Unique: G89D9wEENYKKA1EPScX3RQ-1
X-Mimecast-MFC-AGG-ID: G89D9wEENYKKA1EPScX3RQ_1782302331
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4EB81955F7E;
	Wed, 24 Jun 2026 11:58:51 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D05FA195609E;
	Wed, 24 Jun 2026 11:58:48 +0000 (UTC)
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
Subject: [PATCH v2 13/14] netfs: Fix folio state after ENOMEM whilst under writeback iteration
Date: Wed, 24 Jun 2026 12:57:34 +0100
Message-ID: <20260624115737.2964520-14-dhowells@redhat.com>
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

Fix the state of the current folio when ENOMEM occurs during writeback
iteration.  The folio needs to be redirtied and unlocked before the
terminal writeback_iter() is invoked.

Fixes: 06fa229ceb36 ("netfs: Abstract out a rolling folio buffer implementation")
Link: https://sashiko.dev/#/patchset/20260619140646.2633762-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index d1f98cca5d0f..6eb6cff12c17 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -334,8 +334,11 @@ static int netfs_write_folio(struct netfs_io_request *wreq,
 
 	_enter("");
 
-	if (rolling_buffer_make_space(&wreq->buffer) < 0)
+	if (rolling_buffer_make_space(&wreq->buffer) < 0) {
+		folio_redirty_for_writepage(wbc, folio);
+		folio_unlock(folio);
 		return -ENOMEM;
+	}
 
 	/* netfs_perform_write() may shift i_size around the page or from out
 	 * of the page to beyond it, but cannot move i_size into or through the

