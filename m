Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5DB474252
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 13:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664094; cv=none; b=ROH38x6wX23X+y78f+69BNvOHB1+de9HCMvdN7trMnkaSX5hT1FXEZadpcedxq3AaE/NVbPqyKoHNe1NKQaoPiIva6y4S5OmFja3Gs0oX9gt5KvzQgdSrg4p0UXam8xK710Z5lygqdbmzYN7PLA82OVn+dzMnxL6qGpMvVEiBtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664094; c=relaxed/simple;
	bh=FzRo1GPNzAWelnrKwWW+888gA+zU/UXIf9GDxf2VjrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUz/Zod0eYfxiRMsI6yTvuFwlrGtc3ENeOvwsTjj0QqxQlI25I/dKyUFSW88SLrJJJFrweLEiNk8eVJ3yHvpstf539/s+21Ijlo2chUEdYgeW+YoBaZ/HKtKPRj8dawm85VzLRotvBRC4AyKxSy20gnTESS5OZLgj3u/s+gota4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OQ1pNB6S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OQ1pNB6S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787664084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M/Qxd7N6jCXPKHznu5KtiQXyFK2J5SiupV4se6oGxR0=;
	b=OQ1pNB6SZGnWS9XZBKA3VtLJhMhkzcDH2adtKFWe9BGjM4Cj31wghxS24UrWSMjE+l9R5c
	5Ns5LlycTHL1Gg3KsueJWkVuoliyJtEapkM+SOg3w673DTmshdsTxEbqu444W9LZ0DxDvh
	2Vv5Z1ZeNyEMnxk3URhAQzy9vMeGXi8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-VS0MFFZINZafYnIVEXtWbg-1; Tue,
 25 Aug 2026 09:21:18 -0400
X-MC-Unique: VS0MFFZINZafYnIVEXtWbg-1
X-Mimecast-MFC-AGG-ID: VS0MFFZINZafYnIVEXtWbg_1787664077
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DBAF1978F71;
	Tue, 25 Aug 2026 13:21:17 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2ECAD1955F08;
	Tue, 25 Aug 2026 13:21:13 +0000 (UTC)
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
Subject: [PATCH v2 5/9] netfs: Fix subreq ref leak
Date: Tue, 25 Aug 2026 14:20:39 +0100
Message-ID: <20260825132045.1000787-6-dhowells@redhat.com>
In-Reply-To: <20260825132045.1000787-1-dhowells@redhat.com>
References: <20260825132045.1000787-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix a subrequest ref leak in netfs_unbuffered_write() in the event that
subreq->io_iter ends up zero length during preparation.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/direct_write.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index f33ccddaa826..fbcfadb232ee 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -121,8 +121,14 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 		}
 
 		iov_iter_truncate(&subreq->io_iter, wreq->len - wreq->transferred);
-		if (!iov_iter_count(&subreq->io_iter))
+		if (!iov_iter_count(&subreq->io_iter)) {
+			pr_warn("netfs: Unexpected zero-length iterator R=%08x\n",
+				wreq->debug_id);
+			__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+			netfs_write_subrequest_terminated(subreq, -EIO);
+			wreq->error = -EIO;
 			break;
+		}
 
 		subreq->len = netfs_limit_iter(&subreq->io_iter, 0,
 					       stream->sreq_max_len,

