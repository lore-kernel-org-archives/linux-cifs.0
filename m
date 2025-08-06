Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4B12C15A2
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 20:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754512715; cv=none; b=iDf+zaOXkXd5CKutNIxvWpSPjOk/y2mBg4Xi3UGKKSc4/wooP1QoXTBjT3Rm4jAMyjrTW4CqcWAsR0WlU9N1pjrdT9BvtuLHKiNTigdkx+VFeieRTJksdbK5Ma6OxLU0aDqM1QjvYrFIz6K4GazEv+gque5/ZhmrcDT+vVWOyfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754512715; c=relaxed/simple;
	bh=VnqapvoeUl8a0mWesAi40SyStyvdPjrMa3U/I1C8HPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0q0KdcACr0P+o3hzXTv9FCe0aGixVGYVArCM6qUg0r9npxHbqx7aLG1K2FwCI/O2VAMUMr1RFHQ6zUxYEQOZQhQy9LG4w6XCguQA7+ZZBDDC7Js/JUNmiZgfYK/Vcz2KUf8qw9MyxZKU1/hl8nNu6kYpWl12R9E5EjgO4Cp+Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ybb3oTkC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ybb3oTkC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754512711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nsDK5Zd7b247EgGukZBaGMeBw3sasv4i13b60wegV74=;
	b=Ybb3oTkC+tkY8MmcYLS/1S0rsU/t1mWMdYoddv4/vfmPp8T1Q2IG53cRcChilahAbqLZ6f
	z2YyOb/baoKrcfoXUXS+SzjpfyMzHjA6K7G1kdy4F5i9GnIakcmllGnGfzzJkP05zu8aC0
	4+dwFRD6cigkcYOCGrehM54npVjgGgE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-166-uJdsIU7PNimj8aT6PLh88A-1; Wed,
 06 Aug 2025 16:38:30 -0400
X-MC-Unique: uJdsIU7PNimj8aT6PLh88A-1
X-Mimecast-MFC-AGG-ID: uJdsIU7PNimj8aT6PLh88A_1754512708
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D50A180035B;
	Wed,  6 Aug 2025 20:38:28 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.17])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2EDED3000198;
	Wed,  6 Aug 2025 20:38:24 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 15/31] cifs: Use netfs_alloc/free_folioq_buffer()
Date: Wed,  6 Aug 2025 21:36:36 +0100
Message-ID: <20250806203705.2560493-16-dhowells@redhat.com>
In-Reply-To: <20250806203705.2560493-1-dhowells@redhat.com>
References: <20250806203705.2560493-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Use netfs_alloc/free_folioq_buffer() rather than doing its own version.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com> (RDMA, smbdirect)
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/smb2ops.c | 73 ++++++-----------------------------------
 1 file changed, 10 insertions(+), 63 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 0ad4a2a012a0..161cef316346 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4446,61 +4446,6 @@ decrypt_message(struct TCP_Server_Info *server, int num_rqst,
 	return rc;
 }
 
-/*
- * Clear a read buffer, discarding the folios which have the 1st mark set.
- */
-static void cifs_clear_folioq_buffer(struct folio_queue *buffer)
-{
-	struct folio_queue *folioq;
-
-	while ((folioq = buffer)) {
-		for (int s = 0; s < folioq_count(folioq); s++)
-			if (folioq_is_marked(folioq, s))
-				folio_put(folioq_folio(folioq, s));
-		buffer = folioq->next;
-		kfree(folioq);
-	}
-}
-
-/*
- * Allocate buffer space into a folio queue.
- */
-static struct folio_queue *cifs_alloc_folioq_buffer(ssize_t size)
-{
-	struct folio_queue *buffer = NULL, *tail = NULL, *p;
-	struct folio *folio;
-	unsigned int slot;
-
-	do {
-		if (!tail || folioq_full(tail)) {
-			p = kmalloc(sizeof(*p), GFP_NOFS);
-			if (!p)
-				goto nomem;
-			folioq_init(p, 0);
-			if (tail) {
-				tail->next = p;
-				p->prev = tail;
-			} else {
-				buffer = p;
-			}
-			tail = p;
-		}
-
-		folio = folio_alloc(GFP_KERNEL|__GFP_HIGHMEM, 0);
-		if (!folio)
-			goto nomem;
-
-		slot = folioq_append_mark(tail, folio);
-		size -= folioq_folio_size(tail, slot);
-	} while (size > 0);
-
-	return buffer;
-
-nomem:
-	cifs_clear_folioq_buffer(buffer);
-	return NULL;
-}
-
 /*
  * Copy data from an iterator to the folios in a folio queue buffer.
  */
@@ -4526,7 +4471,7 @@ void
 smb3_free_compound_rqst(int num_rqst, struct smb_rqst *rqst)
 {
 	for (int i = 0; i < num_rqst; i++)
-		cifs_clear_folioq_buffer(rqst[i].rq_buffer);
+		netfs_free_folioq_buffer(rqst[i].rq_buffer);
 }
 
 /*
@@ -4561,8 +4506,10 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 		new->rq_nvec = old->rq_nvec;
 
 		if (size > 0) {
-			buffer = cifs_alloc_folioq_buffer(size);
-			if (!buffer)
+			size_t cur_size = 0;
+			rc = netfs_alloc_folioq_buffer(NULL, &buffer, &cur_size,
+						       size, GFP_NOFS);
+			if (rc < 0)
 				goto err_free;
 
 			new->rq_buffer = buffer;
@@ -4894,7 +4841,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 	}
 
 free_pages:
-	cifs_clear_folioq_buffer(dw->buffer);
+	netfs_free_folioq_buffer(dw->buffer);
 	cifs_small_buf_release(dw->buf);
 	kfree(dw);
 }
@@ -4932,9 +4879,9 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct smb_message **smb,
 	dw->len = len;
 	len = round_up(dw->len, PAGE_SIZE);
 
-	rc = -ENOMEM;
-	dw->buffer = cifs_alloc_folioq_buffer(len);
-	if (!dw->buffer)
+	size_t cur_size = 0;
+	rc = netfs_alloc_folioq_buffer(NULL, &dw->buffer, &cur_size, len, GFP_NOFS);
+	if (rc < 0)
 		goto discard_data;
 
 	iov_iter_folio_queue(&iter, ITER_DEST, dw->buffer, 0, 0, len);
@@ -4995,7 +4942,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct smb_message **smb,
 	}
 
 free_pages:
-	cifs_clear_folioq_buffer(dw->buffer);
+	netfs_free_folioq_buffer(dw->buffer);
 free_dw:
 	kfree(dw);
 	return rc;

