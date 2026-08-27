Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6351C4756B3
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 13:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787838214; cv=none; b=m5HzAxQypCg+StOOvBU8+h09TPWGJVZkltV2bUQEJh1c9R6AxLynDPGZp2tGYDrvwizgXypKe1OaK+/MKCpxFWw8ONLmTUV0m6qhPPdUOBdfBkZSgY4maCWMAYkPwv2LuTjLoJKVgvqdqm2j/5Ptcql7UFvhXpUkpxgxhs9Sd/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787838214; c=relaxed/simple;
	bh=IizGxEfTjfhZJVkwhDscGC2P/a5HlqU4Kr8qrccX6z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9gmHekCe/UkvZtnQOTkI/vo6wK3ceA3zyEwCxWHP3Er5BwWe8O0qyZwMRoQCNOL+QEztoiI1ZcQO5YlFpQSHoA2B6+fBBlHcLKuEWKdOkQlh35tPpIx4SQAgn9r0wrK+sqEWzNTXN44zxlr/CcVnuREgc1u7BAhmSmxT6Hmo+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IzMq1zpf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IzMq1zpf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787838210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPPEzvtBLG/nC8I1Bmob/2jRQbbQ9nOnJ6K+0h7yLO8=;
	b=IzMq1zpfHuI3d3USEq6CS8f5zWOK+qzPRsUZj8FXzHP1Orqgzyo5xB8PB1GRGt7k90oIFL
	WRlYxT7QpNOlZKEsbvaktpiRmBZfSOr1Vk/wxvb7ASReC2RFo8GGeGqGYaRP9OghADPkIL
	88seurx/JIuweWCQAReW6uaye8h6xUI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-XRizu61CPsuLjMwlmWSQMA-1; Thu,
 27 Aug 2026 09:43:25 -0400
X-MC-Unique: XRizu61CPsuLjMwlmWSQMA-1
X-Mimecast-MFC-AGG-ID: XRizu61CPsuLjMwlmWSQMA_1787838204
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C8A41862D74;
	Thu, 27 Aug 2026 13:43:23 +0000 (UTC)
Received: from warthog.com (unknown [10.22.88.47])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 42F131955F70;
	Thu, 27 Aug 2026 13:43:21 +0000 (UTC)
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
Subject: [PATCH v4 03/10] netfs: Fix error vs transferred passed to ->ki_complete()
Date: Thu, 27 Aug 2026 14:42:56 +0100
Message-ID: <20260827134304.2075713-4-dhowells@redhat.com>
In-Reply-To: <20260827134304.2075713-1-dhowells@redhat.com>
References: <20260827134304.2075713-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix netfs_unbuffered_write_done() to pass the amount written to
->ki_complete() rather than the error in the event of a partially complete
transfer.

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
index 544a4243fc59..f7d7e1b54653 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -51,7 +51,7 @@ static void netfs_unbuffered_write_done(struct netfs_io_request *wreq)
 		wreq->iocb->ki_pos += written;
 		if (wreq->iocb->ki_complete) {
 			trace_netfs_rreq(wreq, netfs_rreq_trace_ki_complete);
-			wreq->iocb->ki_complete(wreq->iocb, wreq->error ?: written);
+			wreq->iocb->ki_complete(wreq->iocb, written ?: wreq->error);
 		}
 		wreq->iocb = VFS_PTR_POISON;
 	}

