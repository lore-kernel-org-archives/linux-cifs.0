Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270CD4A99C
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 22:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707173876; cv=none; b=CRvc43U8hcUI8sCQ9hqBEorbOosilJDWABc2tP6BKKl9yVMl5tpRVhfsFO/VScj0LoTQyEbBei2bIGW+AOwtdDCwqnvmnSpK9q42st6hQa6cQTjpFx5OTxEpdb1AUGCcT4H1fI1r4OSB6RMa8OdcZY5xuyVB1xiHNY34GkA/L9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707173876; c=relaxed/simple;
	bh=dLHPCDdqZyYqcKsH5vxgCp7lOfDq1Dp1o0GtCoHXsMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW+inTHGibSn3i5ppZOzCb0qQxkq0/FYqYdj31R/z5KotrMXy2UW5ntIVo0v8vpIIGwVL2Na3QqK/+h74KTGQo2tHCIPySi/FX9oSk18/wdqftkp+k9UALX2ZknveiPGb+Zsd3z9duWLtNDDCXpC/pgtWI5S5HS3hwZagh3E3cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FdeI9Oso; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FdeI9Oso"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707173874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3wa+MhW5WY7m0Mgt6HSqvOGHHNP0rK9YvsBe6EDxi5k=;
	b=FdeI9Oso9kHnSBAuS6Tde9+wqwMCk0DcVgNQKE6rqsr82/3/BQVQABO0ZqX8Qql/9RjRNw
	ZKzvEk9A9p5EqCW0xgDctT4pfvz52WCHCgoosuD1kkSXUvB5kkcGwk+7NzC54A082ccv4P
	8CnkfyHz9xP3jKCPlWQc7E2zmN3r7cE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-QlhvDllSPfKdJhAef6Pv0g-1; Mon,
 05 Feb 2024 17:57:51 -0500
X-MC-Unique: QlhvDllSPfKdJhAef6Pv0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1131F3CBD509;
	Mon,  5 Feb 2024 22:57:50 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.245])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1EAB02166B31;
	Mon,  5 Feb 2024 22:57:48 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Christian Brauner <christian@brauner.io>,
	netfs@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>
Subject: [PATCH v5 07/12] cifs: Replace the writedata replay bool with a netfs sreq flag
Date: Mon,  5 Feb 2024 22:57:19 +0000
Message-ID: <20240205225726.3104808-8-dhowells@redhat.com>
In-Reply-To: <20240205225726.3104808-1-dhowells@redhat.com>
References: <20240205225726.3104808-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Replace the 'replay' bool in cifs_writedata (now cifs_io_subrequest) with a
flag in the netfs_io_subrequest flags.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/smb/client/cifsglob.h | 1 -
 fs/smb/client/file.c     | 2 +-
 fs/smb/client/smb2pdu.c  | 4 ++--
 include/linux/netfs.h    | 1 +
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index dd0cef742a64..1dfed3eddaa2 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1479,7 +1479,6 @@ struct cifs_io_subrequest {
 	unsigned int			xid;
 	int				result;
 	bool				have_credits;
-	bool				replay;
 	struct kvec			iov[2];
 	struct TCP_Server_Info		*server;
 #ifdef CONFIG_CIFS_SMB_DIRECT
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index ce5f24206be0..14602ed6bc39 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3645,7 +3645,7 @@ cifs_resend_wdata(struct cifs_io_subrequest *wdata, struct list_head *wdata_list
 			if (wdata->cfile->invalidHandle)
 				rc = -EAGAIN;
 			else {
-				wdata->replay = true;
+				set_bit(NETFS_SREQ_RETRYING, &wdata->subreq.flags);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 				if (wdata->mr) {
 					wdata->mr->need_invalidate = true;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2ecc5f210329..84e3675eb41e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4797,7 +4797,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	struct cifs_io_parms *io_parms = NULL;
 	int credit_request;
 
-	if (!wdata->server || wdata->replay)
+	if (!wdata->server || test_bit(NETFS_SREQ_RETRYING, &wdata->subreq.flags))
 		server = wdata->server = cifs_pick_channel(tcon->ses);
 
 	/*
@@ -4882,7 +4882,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	rqst.rq_nvec = 1;
 	rqst.rq_iter = wdata->subreq.io_iter;
 	rqst.rq_iter_size = iov_iter_count(&rqst.rq_iter);
-	if (wdata->replay)
+	if (test_bit(NETFS_SREQ_RETRYING, &wdata->subreq.flags))
 		smb2_set_replay(server, &rqst);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (wdata->mr)
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 61195cf16d6e..455ccfe8bffa 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -224,6 +224,7 @@ struct netfs_io_subrequest {
 #define NETFS_SREQ_SEEK_DATA_READ	3	/* Set if ->read() should SEEK_DATA first */
 #define NETFS_SREQ_NO_PROGRESS		4	/* Set if we didn't manage to read any data */
 #define NETFS_SREQ_ONDEMAND		5	/* Set if it's from on-demand read mode */
+#define NETFS_SREQ_RETRYING		6	/* Set if we're retrying the op */
 };
 
 enum netfs_io_origin {

