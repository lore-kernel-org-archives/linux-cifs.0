Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FB645FFA7
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 13:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787838207; cv=none; b=Pf+r0jRL7uWPT3fVaPhUFZH6tSDGolo480ARY5HPCSEPA4tecc317k4FVedu8HukRN9o3Y1HugeySPBMGqCetndGddQV30ak5K7vzZJ5kApVguoenhw4O6nbruFZVQn7z6SeqaE0kMZQk1O6yFHu0TUx4MclXxO6C9jWGC8sG7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787838207; c=relaxed/simple;
	bh=txJCVMXbXZvWlCXPrv6gBGpM1BgXhBKNdFGr0ZEG6w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgxTObdO8iXoO2pBcehuIqhmz+QMcGDxJMTr8I8fkrsAJmTteCWepeot1dnH2JlEdDx1pxyF1jLNN9XD9SNhjF8vtoUr/v8S6Ed+AyovyypMX/AY8z0+zBOsqzYxA8y3989nMnpuB+cGUq9lNocVbY5/k9kv8oJVFcYOYUPnD6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FV557vuM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FV557vuM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787838203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0CGY+glbrnxXmLvEdK2C6tXXpmZuhxXjkwnlUGFD0SY=;
	b=FV557vuMCaFeEJ5ftIOIAEezdw/qU1MXg5wzABMN3bNUC9EcB3gjb0c5vc6mfZpMTNzmUS
	07FvIh4qSV2tVw+ZkrgdeAXerfwAdIQytvuu+9PbnxJPX0tizFpTworBZHL7mITuBPVC+h
	A7pMxQH0oBZG/hW5LW3mD8XAS4hdOUA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-GLyhZIivMGyir14htsIE-g-1; Thu,
 27 Aug 2026 09:43:22 -0400
X-MC-Unique: GLyhZIivMGyir14htsIE-g-1
X-Mimecast-MFC-AGG-ID: GLyhZIivMGyir14htsIE-g_1787838200
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D02B19775D7;
	Thu, 27 Aug 2026 13:43:20 +0000 (UTC)
Received: from warthog.com (unknown [10.22.88.47])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 70A5A1800348;
	Thu, 27 Aug 2026 13:43:17 +0000 (UTC)
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
Subject: [PATCH v4 02/10] netfs: Fix unbuffered/DIO write partial transfer error return
Date: Thu, 27 Aug 2026 14:42:55 +0100
Message-ID: <20260827134304.2075713-3-dhowells@redhat.com>
In-Reply-To: <20260827134304.2075713-1-dhowells@redhat.com>
References: <20260827134304.2075713-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix unbuffered/DIO write to return the amount of data transferred in
preference to an error if a partial transfer has been achieved, and to
prefer an error stashed in the request over the one returned by
netfs_unbuffered_write() (likely -EINTR or -ERESTARTSYS).

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/direct_write.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index b04019097ab8..544a4243fc59 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -139,13 +139,11 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 		if (test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags)) {
 			retry = true;
 		} else if (test_bit(NETFS_SREQ_FAILED, &subreq->flags)) {
-			ret = subreq->error;
-			wreq->error = ret;
+			wreq->error = subreq->error;
 			netfs_see_subrequest(subreq, netfs_sreq_trace_see_failed);
 			subreq = NULL;
 			break;
 		}
-		ret = 0;
 
 		if (!retry) {
 			netfs_unbuffered_write_collect(wreq, stream, subreq);
@@ -288,11 +286,11 @@ ssize_t netfs_unbuffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *
 		ret = -EIOCBQUEUED;
 	} else {
 		ret = netfs_unbuffered_write(wreq);
-		if (ret < 0) {
-			_debug("begin = %zd", ret);
-		} else {
+		if (wreq->transferred) {
 			iocb->ki_pos += wreq->transferred;
-			ret = wreq->transferred ?: wreq->error;
+			ret = wreq->transferred;
+		} else if (wreq->error) {
+			ret = wreq->error;
 		}
 
 		netfs_put_request(wreq, netfs_rreq_trace_put_complete);

