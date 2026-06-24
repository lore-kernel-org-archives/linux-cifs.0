Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A19E3A544C
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 11:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782302331; cv=none; b=QxmVmzzkP2mo5xo7qMjEjyoDvOmHX3XnrnwbelinL+rcr7biovoxaklkEiNIMXXuKMulBiS+Iln8+OdxV/Azd9RABmcx92x01ASescRbd+O7goint4GkEvr+fA1vK9cvib+y8aX4A/PuwayHnR01otmyJqMYTxPaFok58nSlvgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782302331; c=relaxed/simple;
	bh=SiDpiHDUcDGkcTTZaj5jmTTyyFYfCT7X71HEPxLTt5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBiyAuz8pModSQW7KbsTt2oGb1A7NZyadaOLBPpxQNWRgombxM+6C4/hl9NHLij9zLOCmKFTWcbBqyavSW7l3sxRKRs3cQ3Oqf7KbH53RBuACSesAIXFMAxoxLhEQAhgmoYvhFBLwM/3U3yOreAd3Pprqjg1UDo76eLsHXa/jk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hw+cDjxh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hw+cDjxh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782302327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F6dv38lkMbVidCMwZh3umBzwGuE5b7Ehwa5DFjmWEmE=;
	b=hw+cDjxh00j9zw0HZDDmWvJy5jHZqj6P6kg2P5vl5rzWPIbG4OV3atc064BEvTAgZv0Kmk
	9R81iOwUZHefwnfc2Ai6c6di/bklAvE8zZ7BF7+ICPp2ilXIfx93EzBT3wkIQrZCps/VSA
	Yj+LgKaun6z6pxhrNASN0wPFzT8TVMs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320--Y9tMmApOQaGymnlSd6siw-1; Wed,
 24 Jun 2026 07:58:44 -0400
X-MC-Unique: -Y9tMmApOQaGymnlSd6siw-1
X-Mimecast-MFC-AGG-ID: -Y9tMmApOQaGymnlSd6siw_1782302323
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7E0518005A9;
	Wed, 24 Jun 2026 11:58:42 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E8731800351;
	Wed, 24 Jun 2026 11:58:40 +0000 (UTC)
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
Subject: [PATCH v2 11/14] netfs: Fix writethrough to use collection offload
Date: Wed, 24 Jun 2026 12:57:32 +0100
Message-ID: <20260624115737.2964520-12-dhowells@redhat.com>
In-Reply-To: <20260624115737.2964520-1-dhowells@redhat.com>
References: <20260624115737.2964520-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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

