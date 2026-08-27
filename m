Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1C841DED8
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 09:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787823543; cv=none; b=FwRTNi+GNwg5OGFxgjo8l/k3I5yiaT86pzxmtR7kmWw3YcX0t5ZRY/lHErnhPVkJZ+9SJ1sgulVP3kTArffhehfjucyyJkuHQOo9WWRjCDeIXc7c/bfXZ6yizZ16bwgawv3lJp5ngga6WVOOXqSx27l0d9i8FUwD3kOKxclkaI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787823543; c=relaxed/simple;
	bh=txJCVMXbXZvWlCXPrv6gBGpM1BgXhBKNdFGr0ZEG6w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwLR49TbtxPh/jN2yEftV1NwFQ2ECymQitQb23aCNv5LVu7jfHkkVl7PjZbHiflJ5B/OI120kH4889No0uLy4pHTNPd93wFqxy2prL0zK47gJaVKjxv3GNqEniqe5qbscVPLMjCeGLeAO4emA52n8dTumxYLpnvY5FgpfkOZk2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GNwyJiNr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GNwyJiNr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787823535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0CGY+glbrnxXmLvEdK2C6tXXpmZuhxXjkwnlUGFD0SY=;
	b=GNwyJiNrvIpFwb/Za0p+OuOowgGvIUaswasoE+XASFAWBd9dLKSwye0liGgHgKrg+rutnP
	MqcvgZWE14mOpQ994m+dB/KoKDigPVsLU6zMut5tHDy5NUCaguuKpdPxeXjd6GeBEEUAiz
	dGQcu0WYaWIvUez1LTzFNJuDV8/z004=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-297-XCKAzDz8OzWc03-SyXxUDw-1; Thu,
 27 Aug 2026 05:38:51 -0400
X-MC-Unique: XCKAzDz8OzWc03-SyXxUDw-1
X-Mimecast-MFC-AGG-ID: XCKAzDz8OzWc03-SyXxUDw_1787823530
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 399271956046;
	Thu, 27 Aug 2026 09:38:50 +0000 (UTC)
Received: from warthog.com (unknown [10.22.88.47])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 742DE434;
	Thu, 27 Aug 2026 09:38:47 +0000 (UTC)
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
Subject: [PATCH v3 02/10] netfs: Fix unbuffered/DIO write partial transfer error return
Date: Thu, 27 Aug 2026 10:38:17 +0100
Message-ID: <20260827093828.1956211-3-dhowells@redhat.com>
In-Reply-To: <20260827093828.1956211-1-dhowells@redhat.com>
References: <20260827093828.1956211-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

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

