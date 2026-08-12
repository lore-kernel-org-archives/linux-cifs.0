Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6122449B39
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 13:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539740; cv=none; b=Nt4WMrFJTDCeunt5F7AwqCdHouZno5Jx9f/3Mj8rPxxpP7zRZ/9jWstvCzcpoEcqqB9XH8Q09QAlG75+5DaG5OHF5zMW+J7mZCyXHQKjEzWgqSGkb08MLT5yPdFqikNylRtO9i4ZxdN9mxG5Ri+NtUPc9bMpsHNF8+IXUjI73M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539740; c=relaxed/simple;
	bh=DvnegeIrv6OKOPiHrXojj6LcsSY3WCVv03dvXayuoa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iypFys20veLXeZ9ooD1Swet4zqLPVYXkA3JPx8iaca6nidVUwnmfLqsW0jb8v/0hBmlLxMA+m0DYGDp2muL6DI98BtPkFT9LawSbj+DRUicyTOr1P/CdGn5tOjojf8qA6FNUBxekBCq0y8nwdd9h73ywHdf5mKl35Dqfm3IXK2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EjR2b0LC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EjR2b0LC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786539737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xmRZHJXqO4JoOnDlM4sZvDjttBJFD86ZhVfCRofRcjE=;
	b=EjR2b0LC1aY9fKgxAE4sV6rtVYd+m+/oSZsyTLQjYduZw9C2agIYgn3jCJA0oCBPPcw84B
	wfprFwNdk2kDRhKcVsmOL9hOa6YQLrQAjQdM764MAXgxSJd65ts/jYqSUXokXgfnchAkTk
	tz+czno3YUKoTwBxMJNpDwp0pcVs7R0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-tq2pPfS2MkmbLGo145cStA-1; Wed,
 12 Aug 2026 09:02:14 -0400
X-MC-Unique: tq2pPfS2MkmbLGo145cStA-1
X-Mimecast-MFC-AGG-ID: tq2pPfS2MkmbLGo145cStA_1786539733
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18DDC1954B08;
	Wed, 12 Aug 2026 13:02:13 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A5FB195DF96;
	Wed, 12 Aug 2026 13:02:09 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] smb: client: Avoid leaking sensitive data to the heap in connect.c
Date: Wed, 12 Aug 2026 15:01:52 +0200
Message-ID: <20260812130152.2861834-6-thuth@redhat.com>
In-Reply-To: <20260812130152.2861834-1-thuth@redhat.com>
References: <20260812130152.2861834-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Thomas Huth <thuth@redhat.com>

TCP_Server_Info contains a preauth_sha_hash[] and a cryptkey[] array
that might contain sensitive data. Thus free its memory with
kfree_sensitive() to avoid that we are leaking this information to
the heap.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/smb/client/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ba749ec25a59f..5675d7fc2c818 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1143,7 +1143,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	put_net(cifs_net_ns(server));
 	kfree(server->leaf_fullpath);
 	kfree(server->hostname);
-	kfree(server);
+	kfree_sensitive(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
 	if (length > 0)
-- 
2.55.0

