Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6DF7E573
	for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 13:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716298597; cv=none; b=hoCqSrJHw4jox+xqY9spaXjq1/GNvqVrMN+Qa/TmFjVWhusUJE0YcTuZCvjCBgmUWyiT/BanoIjGDYeAYdkVtn5e/QKjeN2uG8j8102kkfl7QKtZQlwuPHMeptCPMuaYEt5ubyU4MfkT/dsGzEqyVeQaVhJwyzdgtRwzAP3X/0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716298597; c=relaxed/simple;
	bh=wooh8rG/Ageclm++Zoo32v4gpqwOYEvywXeGxlbSL1c=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=FLo9X+6b/6uC4lfFPAB6w3etpbTSPXAn2CHRxzKMDQ41eknvBTA+loj6G8/2eOmBjDQz3+Md98YpC5YQvmV4nG1lr9pg0QdpzlTJa3CgzBEclbMV9xiktmQWSjJ/otNyHsi6xCMQ1soWzyhqy4wYNypCgCpdo06uptU9jFQX3ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U1/1cCNh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U1/1cCNh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716298594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tQ93YOLA+ZarT84k8WHzLRGgN4pa3R9T2oT8BE3LSw4=;
	b=U1/1cCNhueMTsclJTn9V+sm3pyiBrO+XRhsFKk7Ow8GF+euzA88wbCviPfIulfasawm3BM
	V7xxNSPLwpDv2U8L5CNXBOr6/F4AScARiHRQHaY0TPJB4auuI1Yi0tkcZtsWx5Kga6x35A
	YmJVqVB0LtkXtsZfuIB8XzlFA0TyPkw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-IRM4g2I6Pu-_TFIqfGEhVw-1; Tue, 21 May 2024 09:36:30 -0400
X-MC-Unique: IRM4g2I6Pu-_TFIqfGEhVw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D422818188A1;
	Tue, 21 May 2024 13:36:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6CA4E200A35C;
	Tue, 21 May 2024 13:36:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <stfrench@microsoft.com>
cc: dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
    Enzo Matsumiya <ematsumiya@suse.de>,
    Christian Brauner <brauner@kernel.org>, netfs@lists.linux.dev,
    v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
    linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH] netfs: Fix AIO error handling when doing write-through
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <295051.1716298587.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 May 2024 14:36:27 +0100
Message-ID: <295052.1716298587@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

If an error occurs whilst we're doing an AIO write in write-through mode,
we may end up calling ->ki_complete() *and* returning an error from
->write_iter().  This can result in either a UAF (the ->ki_complete() func
pointer may get overwritten, for example) or a refcount underflow in
io_submit() as ->ki_complete is called twice.

Fix this by making netfs_end_writethrough() - and thus
netfs_perform_write() - unconditionally return -EIOCBQUEUED if we're doing
an AIO write and wait for completion if we're not.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: netfs@lists.linux.dev
cc: v9fs@lists.linux.dev
cc: linux-afs@lists.infradead.org
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index e190043bc0da..acbfd1f5ee9d 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -636,7 +636,12 @@ int netfs_end_writethrough(struct netfs_io_request *w=
req, struct writeback_contr
 =

 	mutex_unlock(&ictx->wb_lock);
 =

-	ret =3D wreq->error;
+	if (wreq->iocb) {
+		ret =3D -EIOCBQUEUED;
+	} else {
+		wait_on_bit(&wreq->flags, NETFS_RREQ_IN_PROGRESS, TASK_UNINTERRUPTIBLE)=
;
+		ret =3D wreq->error;
+	}
 	netfs_put_request(wreq, false, netfs_rreq_trace_put_return);
 	return ret;
 }

