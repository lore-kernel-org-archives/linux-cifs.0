Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CE034F27F
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 15:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777304829; cv=none; b=riwO4PtKgSUbl+EXBIVfn/e1hXPnJN7xHCW4LneP9ypvpWgzvMNh+NRymG3sXKUejYM5n72fynCI/gr1ykw5C6Dj9uEuEsY6p+Px1s4E2KIkG49pRsgBRcW+ssY71ku9ZuRQi2gYXfVT351L2CJlZUXcbNn1Z2ThNOnqoVb9NtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777304829; c=relaxed/simple;
	bh=4vDqPI8DVk4MKXgzTTYnAtb5Hin/PlJJp6BgfgK/hjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmEItgRLUO58M9VYu+olPID2HqIpkmaZKXlGGZaz9NeB6lHST4AA82EszSbTupYEIAjvBBEk7fGIbxP7stdK4nTT7VxBltvKl9c/R9cX7QxCMrw4qo81Plb7VVbtiTQERot6bW0PK0sTxWLFFYFqcXcDMiqnRjlw4RS7seUvGg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EZppV8DS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EZppV8DS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777304827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F1+6dfsU9EA3zra9BmDxqCEbg56ER/RAJitXxHpONYg=;
	b=EZppV8DSvnkGt7XiNFilNUH0Jx1LTC2dJeF8TtyeZy75hGTU6MZnLbWwCbqToMFl/3k+fG
	HDWXp4KZxTLfrV/Gr2OnJGxXZtBH3qs+yvSIao6F5grH7b2PI8LQG3ysJv2nnHVmb1jhK8
	8HsBM2EKMe9DIy0FTBzSfbTPDbmxZpo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-660-M65CsH5jPWKe8idtZ72r4Q-1; Mon,
 27 Apr 2026 11:47:04 -0400
X-MC-Unique: M65CsH5jPWKe8idtZ72r4Q-1
X-Mimecast-MFC-AGG-ID: M65CsH5jPWKe8idtZ72r4Q_1777304822
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0DDD18003FC;
	Mon, 27 Apr 2026 15:47:02 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF4EC1800348;
	Mon, 27 Apr 2026 15:46:59 +0000 (UTC)
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
Subject: [PATCH v4 04/22] netfs: Fix netfs_read_to_pagecache() to pause on subreq failure
Date: Mon, 27 Apr 2026 16:46:19 +0100
Message-ID: <20260427154639.180684-5-dhowells@redhat.com>
In-Reply-To: <20260427154639.180684-1-dhowells@redhat.com>
References: <20260427154639.180684-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix netfs_read_to_pagecache() so that it pauses the generation of new
subrequests if an already-issued subrequest fails.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Closes: https://sashiko.dev/#/patchset/20260425125426.3855807-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 3bc7d0c5c3b9..9c7a2f984be9 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -304,6 +304,11 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		}
 
 		netfs_issue_read(rreq, subreq);
+
+		if (test_bit(NETFS_RREQ_PAUSE, &rreq->flags))
+			netfs_wait_for_paused_read(rreq);
+		if (test_bit(NETFS_RREQ_FAILED, &rreq->flags))
+			break;
 		cond_resched();
 	} while (size > 0);
 

