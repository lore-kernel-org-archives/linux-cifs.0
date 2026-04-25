Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DE039B958
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121759; cv=none; b=GzNTNhDh1Mum/rMVut6/t0BDJjPsAgb4UPTEUiwEuAP+KAdQR0o+8HsNubBW++trQd6XWIfgDnk8pp4SRzchFJF0qEebRbyCdwI6WxVp003m27N7FC0hv0UvSPYztbYsvW5al4IgY4HzQbR8tEdo05mkbsU4QeEGxEQU7+SRW4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121759; c=relaxed/simple;
	bh=yF/XUG1fEGGiljws/ocbnY4IAhkOM1E5pMkNLbFWRK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jH2SQ84yutZUE6311Ju7NlXYjvi6wrqkEltqUDXHf0NVhRXQg9Gly4biQdLZwNXMSlKG+vMkZP7Vp59CHWPVvA4lwhr4ALkZBD/D3cbHJUALSUTlJuWL8xnKwA21seflC1f7auK1C5z67cZH2qjUij/5pN38QOCdvMbklsk3Y9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WR3hOmLr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WR3hOmLr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g1vxGFe1KJh0FZqySywfbvIcxTlJD3j+jfO/PbnF32U=;
	b=WR3hOmLrMXG5ZRaYoRKOZ0OD3eb8bxIdDiQ+wmahSrxZsB9njk+yK3g8Q0nsTXZnA1JT5o
	RxzwS5OfgpiKFu1/LyWiLr1Y4JH83JjAPI0kFm53aOZjJzJg36M6VSBMwSsjcB68InFRV/
	N9xlPapRB7b96oR+uNr68uzQl7RyF20=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-Na8Yz6jpPquSI5nYWvFL3g-1; Sat,
 25 Apr 2026 08:55:53 -0400
X-MC-Unique: Na8Yz6jpPquSI5nYWvFL3g-1
X-Mimecast-MFC-AGG-ID: Na8Yz6jpPquSI5nYWvFL3g_1777121751
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B19071800473;
	Sat, 25 Apr 2026 12:55:51 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B747C1944CED;
	Sat, 25 Apr 2026 12:55:48 +0000 (UTC)
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
Subject: [PATCH v3 16/19] netfs: Fix netfs_read_folio() to wait on writeback
Date: Sat, 25 Apr 2026 13:54:20 +0100
Message-ID: <20260425125426.3855807-17-dhowells@redhat.com>
In-Reply-To: <20260425125426.3855807-1-dhowells@redhat.com>
References: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix netfs_read_folio() to wait for an ongoing writeback to complete so that
it can trust the dirty flag and whatever is attached to folio->private
(folio->private may get cleaned up by the collector before it clears the
writeback flag).

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index f1cbd6e10ad7..2de849bd780f 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -506,6 +506,8 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	int ret;
 
+	folio_wait_writeback(folio);
+
 	if (folio_test_dirty(folio))
 		return netfs_read_gaps(file, folio);
 

