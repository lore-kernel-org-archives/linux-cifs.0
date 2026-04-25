Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727DD399013
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121730; cv=none; b=KnwU3CioHhevLi6fkfxouns+sQ5Aoxh7NL0kaavgoBFslcGxI/qEL3d+WDKHrdhR4f/waFmkqA053tgRWqpF5b5XCrJeIGhnP5VoWS13+HMo40mOluj/Y/znQdA6AY/6Rfq13uLJqCO2rM90e0qg3Gbeoj90SGlWg5EPgMTAK38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121730; c=relaxed/simple;
	bh=pB+TlCdoIzRiaUB++xVaBhEiYx4ICCnZHBrrumr5qEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4x+1wg9adwjmniD34EGXayuTzmjWrnn/TJA+du8hQmUCLT+Kv5pXqcR/SzdHJzOoRzvBH3r61yoBdrP6q0pQ0+W3EHYyVk0n5EJo0MPJGBR0Jn2Kfz/e5K4Zr0eRXOC4x2c6lmoQ9TjCkcVIFrgIIEl0Ygvw2idkWQueX/XxFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TYKp8Dg2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYKp8Dg2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/BtyRY9+hFtAe12V1Tupp9IRsYh3wXdEmKBtkAVoEyc=;
	b=TYKp8Dg2Qt23j+U/uRcVodqe2BkJBcGhOZ+Z5W0SUpEto+W1sbHChHvCgIA/KJ7RsxKWds
	5hlMxHwLGq7NrPdn+TIpfv9BpzagtlShl3CtgEZpQwPU20FP5c15qLkqQhO5jmY2+AKqeN
	h0ExCeAX5Qvfqzi3JqhXDm65F/47Gd0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-152-q9477iFjMsCcR9bZuxU6dw-1; Sat,
 25 Apr 2026 08:55:25 -0400
X-MC-Unique: q9477iFjMsCcR9bZuxU6dw-1
X-Mimecast-MFC-AGG-ID: q9477iFjMsCcR9bZuxU6dw_1777121723
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BC10195608B;
	Sat, 25 Apr 2026 12:55:23 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5F3473007572;
	Sat, 25 Apr 2026 12:55:20 +0000 (UTC)
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
Subject: [PATCH v3 10/19] netfs: Fix leak of request in netfs_write_begin() error handling
Date: Sat, 25 Apr 2026 13:54:14 +0100
Message-ID: <20260425125426.3855807-11-dhowells@redhat.com>
In-Reply-To: <20260425125426.3855807-1-dhowells@redhat.com>
References: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
index 3fe129a9b1c3..0ba224d23f0f 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -689,9 +689,9 @@ int netfs_write_begin(struct netfs_inode *ctx,
 
 	netfs_read_to_pagecache(rreq, NULL);
 	ret = netfs_wait_for_read(rreq);
+	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	if (ret < 0)
 		goto error;
-	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 
 have_folio:
 	ret = folio_wait_private_2_killable(folio);

