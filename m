Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9A14D956E
	for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2026 12:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790772145; cv=none; b=CXEOdVBqtCD4pJgtyZ1/Z/DO/mDo4kv5YnN1iPTqoR5ny1m/rxlQxpBfsLrfjyPKUqe1yz/qGLRv7VB7/Gu7k+PTAlWvapjrLHi2BxhLcyPzW632yP5UFHb3/gYO276oAxcush3/febz8nHU9kx577ShQk6vWR1yxNr1szT+0BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790772145; c=relaxed/simple;
	bh=tTc//LGv9TAVpyPw7gFAbmUplMi6wHMNTuAZCOvjqk4=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=huljmAvMthHzWh0wJGmK6DKGMbbU0x3UN2Oo2kMHCZrs+WyPUadgzIhHt8bR7G+7ki89SRtr7O8N0YSXW8BnIty17DqgNxrlO7uFYQuQdV1nD+TNBBYwc4aQjQZlkOnghqcfTLoKwHnZRLR2kbjWJdhsLNETQGfKa5qeRIQVJ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gSbUy3MR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gSbUy3MR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790772129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qNJSgJbR6fMVZzNmYweTnjm7bTXvXcgIpTbJtn9BRBQ=;
	b=gSbUy3MR0oNaDawhSS/jdQiU3n2m+DNvb/fpifZNIC/+a7vLXdUHSIvZFzIQcKqrEDDFa0
	nngYOkKVrRlJqMFs2WYkQTYdzCONxJe+eerFXiCv9cQ90CNlBHFtQG57S8FDO4YQMX46aB
	Q0hx/iBTzYOpo01L94E1bhF4zKmmkMM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-ZO5yj58aPu67-DmS2bvXjg-1; Wed,
 30 Sep 2026 08:42:05 -0400
X-MC-Unique: ZO5yj58aPu67-DmS2bvXjg-1
X-Mimecast-MFC-AGG-ID: ZO5yj58aPu67-DmS2bvXjg_1790772124
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BCCB18BAA29;
	Wed, 30 Sep 2026 12:42:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.54])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CC2695BC;
	Wed, 30 Sep 2026 12:41:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <brauner@kernel.org>
cc: dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
    Paulo Alcantara <pc@manguebit.org>,
    Matthew Wilcox <willy@infradead.org>, linux-cifs@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: cachefiles: Fix unset error when calling netfs_prepare_write_failed()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3227745.1790772118.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 13:41:58 +0100
Message-ID: <3227746.1790772118@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Fix cachefiles to set subreq->error before calling
netfs_prepare_write_failed() otherwise netfslib will try (and fail) to
retry the subrequest (it shouldn't retry writes to the cache, but rather
abandon them).  This causes it to hang waiting for the request to complete=
.

Reported-by: Marc Dionne <marc.dionne@auristor.com>
Fixes: 1a9fe4b6e787 ("cachefiles: Don't rely on backing fs storage map for=
 most use cases")
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/cachefiles/io.c     |    2 ++
 fs/netfs/write_issue.c |    1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
index 4f547d97356e..d05059822288 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -528,10 +528,12 @@ static void cachefiles_prepare_write_subreq(struct n=
etfs_io_subrequest *subreq)
 =

 	if (!cachefiles_cres_file(cres)) {
 		if (!fscache_wait_for_operation(cres, FSCACHE_WANT_WRITE)) {
+			subreq->error =3D -ENOBUFS;
 			trace_netfs_sreq(subreq, netfs_sreq_trace_cache_waitfail);
 			return netfs_prepare_write_failed(subreq);
 		}
 		if (!cachefiles_cres_file(cres)) {
+			subreq->error =3D -ENOBUFS;
 			trace_netfs_sreq(subreq, netfs_sreq_trace_cache_nofile);
 			return netfs_prepare_write_failed(subreq);
 		}
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 9de73c0edad2..b255a1167bb1 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -148,6 +148,7 @@ struct netfs_io_request *netfs_create_write_req(struct=
 address_space *mapping,
  */
 void netfs_prepare_write_failed(struct netfs_io_subrequest *subreq)
 {
+	WARN_ON_ONCE(!subreq->error);
 	__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
 	trace_netfs_sreq(subreq, netfs_sreq_trace_prep_failed);
 }

