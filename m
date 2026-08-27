Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C234C43BDB3
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 09:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787823553; cv=none; b=uZ/+r34Mh5kVgTDiPPebId9XnwMnd3WVxAR9KVhEr2+AqFQB9cXjKkBGXL/ktnI5fS8xf2Vr93lQhfAIcXv8k0qyNLnvS+7noWMvGwBtBSm4MnTRUAgCcwnjCWDOOgXpbF/41u1vcYyFwf5AcKmxWpmRtduFTpNlFlEmSLf3fbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787823553; c=relaxed/simple;
	bh=TbyvXkUkP/iFkWLvIM6Uiy2D1Zai+6kwljmDrYii1Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUusZadH8L5K5cE3OkmUZjURh5lMwL0i19N5wiEbewOcHHQbju1320GgIKJ6BqJ1NvHh/8JeHS2cC7dNlte1SoQBgEyCzjIFnHr+zvF9LQxKZAwHltKSc+g+9wraHfYsF5boWk7/yo3wCOhsNcMstlg39zZ55CXwOIgqZMcgO0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YGQdmUuO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YGQdmUuO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787823540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r3vRJq2sMz9APK4rZhV/g2MBBVrXWqzKAsYSWHku/NM=;
	b=YGQdmUuOKtqp5szERhIGvLXS3lQwlCNuQ9w7SCXHLsCnJdVXo8Xl1NJqB2J8e/fisK+/IS
	bfvWn4rE7ZsQa3/aPN9bGDKlDiJi0st5qgispaQaNzaiyJeo1aMe0n7Y9VW2Jy9ewvearz
	hfgNWEtrbHd0MEIXIcXqXCMeKndIpeA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-NSYaUZP2NiqDaqXLYIHHkg-1; Thu,
 27 Aug 2026 05:38:59 -0400
X-MC-Unique: NSYaUZP2NiqDaqXLYIHHkg-1
X-Mimecast-MFC-AGG-ID: NSYaUZP2NiqDaqXLYIHHkg_1787823538
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4879718052CA;
	Thu, 27 Aug 2026 09:38:57 +0000 (UTC)
Received: from warthog.com (unknown [10.22.88.47])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BB0B71800346;
	Thu, 27 Aug 2026 09:38:54 +0000 (UTC)
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
Subject: [PATCH v3 04/10] netfs: Fix i_size update for partial transfer
Date: Thu, 27 Aug 2026 10:38:19 +0100
Message-ID: <20260827093828.1956211-5-dhowells@redhat.com>
In-Reply-To: <20260827093828.1956211-1-dhowells@redhat.com>
References: <20260827093828.1956211-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Fix netfs_unbuffered_write_done() to pass the amount written to
netfs_update_i_size() in the event of a partial transfer that ends in an
error.

That said, it might be better for the filesystem to mark the inode data as
invalid and recheck it in case something like a network error occurred that
prevented the reply from the server from being received.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/direct_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index f7d7e1b54653..f33ccddaa826 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -21,7 +21,7 @@ static void netfs_unbuffered_write_done(struct netfs_io_request *wreq)
 	/* Okay, declare that all I/O is complete. */
 	trace_netfs_rreq(wreq, netfs_rreq_trace_write_done);
 
-	if (!wreq->error)
+	if (wreq->transferred)
 		netfs_update_i_size(ictx, &ictx->inode, wreq->start, wreq->transferred);
 
 	if (wreq->origin == NETFS_DIO_WRITE &&

