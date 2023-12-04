Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Js3gTNA0"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D3190
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 06:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701698563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P1gifRJOo6LAX3L9+qffyHKYdps0XhxXC9y8grgMIB8=;
	b=Js3gTNA0CcERwHdhNBRIi8zw+RiEL+0gUasGonemV1L0EdbiSFKkFtVUaPAasyf/FFXFzt
	y45mh5ieTNFwh6prp+DijDcwpgjl/sq35smEV5m6F7XyIs0NpKvJgHKldJClOaoAQJtb2g
	kgwqBnVXCR8XbgEGrbE32+xSltO+u6k=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-199-yPxiSqXGPyamQt2Z2R0ZKA-1; Mon,
 04 Dec 2023 09:02:36 -0500
X-MC-Unique: yPxiSqXGPyamQt2Z2R0ZKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F3623C11C71;
	Mon,  4 Dec 2023 14:02:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.161])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B4F05C1290F;
	Mon,  4 Dec 2023 14:01:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
cc: dhowells@redhat.com, Dave Chinner <david@fromorbit.com>,
    Xiaoli Feng <fengxiaoli0714@gmail.com>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    Rohith Surabattula <rohiths.msft@gmail.com>,
    Jeff Layton <jlayton@kernel.org>,
    Darrick Wong <darrick.wong@oracle.com>, fstests@vger.kernel.org,
    linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix non-availability of dedup breaking generic/304
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <250052.1701698519.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 04 Dec 2023 14:01:59 +0000
Message-ID: <250053.1701698519@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Deduplication isn't supported on cifs, but cifs doesn't reject it, instead
treating it as extent duplication/cloning.  This can cause generic/304 to =
go
silly and run for hours on end.

Fix cifs to indicate EOPNOTSUPP if REMAP_FILE_DEDUP is set in
->remap_file_range().

Note that it's unclear whether or not commit b073a08016a1 is meant to caus=
e
cifs to return an error if REMAP_FILE_DEDUP.

Fixes: b073a08016a1 ("cifs: fix that return -EINVAL when do dedupe operati=
on")
Suggested-by: Dave Chinner <david@fromorbit.com>
cc: Steve French <sfrench@samba.org>
cc: Xiaoli Feng <fengxiaoli0714@gmail.com>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Darrick Wong <darrick.wong@oracle.com>
cc: fstests@vger.kernel.org
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/3876191.1701555260@warthog.procyon.org.uk/
---
 fs/smb/client/cifsfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 4d8927b57776..96a65cf9b5ec 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1276,7 +1276,9 @@ static loff_t cifs_remap_file_range(struct file *src=
_file, loff_t off,
 	unsigned int xid;
 	int rc;
 =

-	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
+	if (remap_flags & REMAP_FILE_DEDUP)
+		return -EOPNOTSUPP;
+	if (remap_flags & ~REMAP_FILE_ADVISORY)
 		return -EINVAL;
 =

 	cifs_dbg(FYI, "clone range\n");

