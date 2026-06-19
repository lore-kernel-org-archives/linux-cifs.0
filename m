Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF453976A0
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jun 2026 14:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781878076; cv=none; b=tl/turPWbXWE6sW+Mw7Vz4VY3OhbSkkKX97fzG3QsePzRSCbmF51zQ87JL5Qe+9IKxJIgaOLNlvwFNZppx0Mqv6N2ow2Kq6N0YneJCNzysd625Te9hsj5nqPZeNDatsmZMTYQI/j5A9T75Z85kktRQESgpzGb7jLJAt0FPP71d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781878076; c=relaxed/simple;
	bh=SiDpiHDUcDGkcTTZaj5jmTTyyFYfCT7X71HEPxLTt5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAkreres3QKQ+sktJhTrZO5o/U0PMcWf/3+JQrYpNfQADb9dwT1rp0K3neCMEjLb13ldvVc1mRi2egj/hMmzFHJ0d5gxpfNswFl/Cj3pGrk/oCXvHe98YaP6u/pPcq2eOHRLXrKNBHMuy82ZrG4IgO6H7YKwAnK6yAanLe9KyuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W5FoTdFR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W5FoTdFR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781878074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F6dv38lkMbVidCMwZh3umBzwGuE5b7Ehwa5DFjmWEmE=;
	b=W5FoTdFRLUJUx6RiDRveYJ1KzDlmaoATMxh0DN3so83sHwcbklBPQVd+4UZq4OpTHtnh7w
	xm1klBZkJSH4IThHthNfgXZurye92n9j8IxLVD+/aPDTZ57RK8ftpC1HP5A+7bvIZZ/di+
	31JwQsBVSQTDPMBMXVZ6HZj53Y1b020=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-aTBpRM8zPymLxWXwVxd3nA-1; Fri,
 19 Jun 2026 10:07:51 -0400
X-MC-Unique: aTBpRM8zPymLxWXwVxd3nA-1
X-Mimecast-MFC-AGG-ID: aTBpRM8zPymLxWXwVxd3nA_1781878069
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C24A8195DBA4;
	Fri, 19 Jun 2026 14:07:49 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 237B43000238;
	Fri, 19 Jun 2026 14:07:46 +0000 (UTC)
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
Subject: [PATCH 11/11] netfs: Fix writethrough to use collection offload
Date: Fri, 19 Jun 2026 15:06:15 +0100
Message-ID: <20260619140646.2633762-12-dhowells@redhat.com>
In-Reply-To: <20260619140646.2633762-1-dhowells@redhat.com>
References: <20260619140646.2633762-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Fix writethrough write to set NETFS_RREQ_OFFLOAD_COLLECTION on the request
so that collection is processed asynchronously rather than only right at
the end - and also so that asynchronous O_SYNC writes get collected at all.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Closes: https://sashiko.dev/#/patchset/20260616100821.2062304-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 437bb50ce175..e5d4f9ba3d6b 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -620,6 +620,7 @@ struct netfs_io_request *netfs_begin_writethrough(struct kiocb *iocb, size_t len
 	}
 
 	wreq->io_streams[0].avail = true;
+	__set_bit(NETFS_RREQ_OFFLOAD_COLLECTION, &wreq->flags);
 	trace_netfs_write(wreq, netfs_write_trace_writethrough);
 	return wreq;
 }

