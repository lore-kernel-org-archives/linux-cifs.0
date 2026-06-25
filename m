Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA0D360EEA
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396502; cv=none; b=bBHqOcn2sbObs0/CpjiWYFb7QODXKzXu+Eq8q0IkgPSbQSk0KCQ1SfW1C/d13REEA6ipMf4+vy9BFOlI84HYCZdZmTseF0rlxufGCyyESBOunsI/gK4HydIAaYpnREvPYjhAXMmzWuWR+ABmoV8RtRlcj7vvnFkslxjjn4BOMTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396502; c=relaxed/simple;
	bh=J7N3LfaCZEl3u7MqmzlDY25hDe3GHF6ZhPA2zYyXLJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezFpXLGPtaa9HVw1Q3j+Rav41/KTdrtCc0WBhGFxhAMF5iqLrGcHkuS7H4WZvbnvA3l6hXqaQ9iWsoYRmpjOSNiHYf/QFtgTJrV5AQ+uKsUoiv77X0rYKEDkqnDbeu2WpFEHG7T1c19nNj3wfB7xZXhw6qyVzixRb3di6NvVitw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eRNhhDOM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eRNhhDOM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782396500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8eQpn2DxVVlAysyqP0fiZy6BHi38PFlf6WR7Omr8vFE=;
	b=eRNhhDOMeuMsKkvfmB+cssUdgPcQ+THA13SIv10bhkUKVKiF3Ui43XxhZT3wpI0yPyslrY
	yHLHJqjgKgOBk3CzbacJ6hk3VHfktfTgHNHPRJje8kp5lXjpjrpKz+yReoJDREJQlQsZPx
	Pe0CD5FN/8pLfQqBif8p6Xru1/fS5NM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-fNE8G0NGNp-PiX8MnKgxCg-1; Thu,
 25 Jun 2026 10:08:15 -0400
X-MC-Unique: fNE8G0NGNp-PiX8MnKgxCg-1
X-Mimecast-MFC-AGG-ID: fNE8G0NGNp-PiX8MnKgxCg_1782396493
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF40918A0E0D;
	Thu, 25 Jun 2026 14:08:12 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E58FD180059F;
	Thu, 25 Jun 2026 14:08:08 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Christoph Hellwig <hch@infradead.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com,
	hongao <hongao@uniontech.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH v3 15/15] netfs: Fix DIO write retry for filesystems without a ->prepare_write()
Date: Thu, 25 Jun 2026 15:06:33 +0100
Message-ID: <20260625140640.3116900-16-dhowells@redhat.com>
In-Reply-To: <20260625140640.3116900-1-dhowells@redhat.com>
References: <20260625140640.3116900-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix netfs_unbuffered_write() so that it doesn't re-issue a write twice when
the filesystem doesn't have a ->prepare_write().  The resetting of the
iterator and the call to netfs_reissue_write() should just be removed as
almost everything it does is done again when the loop it's in goes back to
the top.

It does, however, still need the IN_PROGRESS flag setting, so that (and the
stat inc) are moved out of the if-statement.

Further, the MADE_PROGRESS flags should be cleared and wreq->transferred
should be updated, so fix those too.

Reported-by: syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3c74b1f0c372e98efc32
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: hongao <hongao@uniontech.com>
cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/direct_write.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 25f8ceb15fad..c16fbad286a1 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -166,13 +166,16 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 		 */
 		subreq->error = -EAGAIN;
 		trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
-		if (subreq->transferred > 0)
+		if (subreq->transferred > 0) {
 			iov_iter_advance(&wreq->buffer.iter, subreq->transferred);
+			wreq->transferred += subreq->transferred;
+		}
 
 		if (stream->source == NETFS_UPLOAD_TO_SERVER &&
 		    wreq->netfs_ops->retry_request)
 			wreq->netfs_ops->retry_request(wreq, stream);
 
+		__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 		__clear_bit(NETFS_SREQ_BOUNDARY, &subreq->flags);
 		__clear_bit(NETFS_SREQ_FAILED, &subreq->flags);
@@ -186,17 +189,10 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 
 		netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);
 
-		if (stream->prepare_write) {
+		if (stream->prepare_write)
 			stream->prepare_write(subreq);
-			__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
-			netfs_stat(&netfs_n_wh_retry_write_subreq);
-		} else {
-			struct iov_iter source;
-
-			netfs_reset_iter(subreq);
-			source = subreq->io_iter;
-			netfs_reissue_write(stream, subreq, &source);
-		}
+		__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
+		netfs_stat(&netfs_n_wh_retry_write_subreq);
 	}
 
 	netfs_unbuffered_write_done(wreq);

