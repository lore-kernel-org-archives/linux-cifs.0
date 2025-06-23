Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D2A246BAC
	for <linux-cifs@vger.kernel.org>; Mon, 23 Jun 2025 13:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750683911; cv=none; b=H6HmI3FrzAihufzzBM2OsTJ5I+c9AS8FYbbZaJu9XVthsTBowaXYyZJKZA04b5tiphwwXV+71Ktjk3OsSVdDPr9L/mKvHufuu8443IBVwPjThMR+N9hC3O/GEy6vQskaB1PDULFP9ImK42JEqHG4hLPgmkLhZc78GzcsT4GxEuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750683911; c=relaxed/simple;
	bh=ghi6qa9R1EmGSJvlju+LgziByPgW1fEZ07xu3qszDtA=;
	h=From:To:Cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=A+6YucqnZ8756v2LFePCrnd7sMiip0wo9PeQgrswScNkUrgivCLhp8zHj48U6abaEDw24q+Zdvjy+tYxUSLKLd2yXiIC6O/UqNidya88or/3smPS+ffYQ+JrhRJ6uVnnJBBrqIDp0ER3zqRDjL06TQdsG/EhC5EDD5de9RV8Y1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O74sCd1j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O74sCd1j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750683905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0jx1yAJHWToP2OfjrBAmR+S+N3PMqq+Lkg4mJ5sNOGY=;
	b=O74sCd1j2PxZlNO2iotHiD2hJsJepOOXOLbmE17KlRpmwPTr6BYSi40OcWY1NbBiOKMPRj
	746kpa0x1wkvbnQ2ipbuIOR91HHEabsvHvtvG5TQ7RLXDyMV8mphk497l1DGMeEPyxb0xp
	9eG6MIh7PrGXkFhOnClUgAVA2jCD5tE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-142-UyOhfOAvP_iIv5TwVkfx7g-1; Mon,
 23 Jun 2025 09:05:02 -0400
X-MC-Unique: UyOhfOAvP_iIv5TwVkfx7g-1
X-Mimecast-MFC-AGG-ID: UyOhfOAvP_iIv5TwVkfx7g_1750683900
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C99E19560A3;
	Mon, 23 Jun 2025 13:05:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.81])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2BC41195608D;
	Mon, 23 Jun 2025 13:04:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Tom Talpey <tom@talpey.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    Steve French <sfrench@samba.org>,
    Stefan Metzmacher <metze@samba.org>,
    Paulo Alcantara <pc@manguebit.com>,
    Matthew Wilcox <willy@infradead.org>,
    CIFS <linux-cifs@vger.kernel.org>
Subject: [PATCH] cifs: Collapse smbd_recv_*() into smbd_recv() and just use copy_to_iter()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1107689.1750683895.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Jun 2025 14:04:55 +0100
Message-ID: <1107690.1750683895@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

    =

Collapse smbd_recv_buf() and smbd_recv_page() into smbd_recv() and just us=
e
copy_to_iter() instead of memcpy().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <stfrench@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: Stefan Metzmacher <metze@samba.org>
cc: Paulo Alcantara (Red Hat) <pc@manguebit.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/smbdirect.c |  116 +++++++---------------------------------=
------
 1 file changed, 20 insertions(+), 96 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 5ae847919da5..dc64c337aae0 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1747,35 +1747,39 @@ struct smbd_connection *smbd_get_connection(
 }
 =

 /*
- * Receive data from receive reassembly queue
+ * Receive data from the transport's receive reassembly queue
  * All the incoming data packets are placed in reassembly queue
- * buf: the buffer to read data into
+ * iter: the buffer to read data into
  * size: the length of data to read
  * return value: actual data read
- * Note: this implementation copies the data from reassebmly queue to rec=
eive
+ *
+ * Note: this implementation copies the data from reassembly queue to rec=
eive
  * buffers used by upper layer. This is not the optimal code path. A bett=
er way
  * to do it is to not have upper layer allocate its receive buffers but r=
ather
  * borrow the buffer from reassembly queue, and return it after data is
  * consumed. But this will require more changes to upper layer code, and =
also
  * need to consider packet boundaries while they still being reassembled.
  */
-static int smbd_recv_buf(struct smbd_connection *info, char *buf,
-		unsigned int size)
+int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 {
 	struct smbdirect_socket *sc =3D &info->socket;
 	struct smbd_response *response;
 	struct smbdirect_data_transfer *data_transfer;
+	size_t size =3D msg->msg_iter.count;
 	int to_copy, to_read, data_read, offset;
 	u32 data_length, remaining_data_length, data_offset;
 	int rc;
 =

+	if (WARN_ON_ONCE(iov_iter_rw(&msg->msg_iter) =3D=3D WRITE))
+		return -EINVAL; /* It's a bug in upper layer to get there */
+
 again:
 	/*
 	 * No need to hold the reassembly queue lock all the time as we are
 	 * the only one reading from the front of the queue. The transport
 	 * may add more entries to the back of the queue at the same time
 	 */
-	log_read(INFO, "size=3D%d info->reassembly_data_length=3D%d\n", size,
+	log_read(INFO, "size=3D%zd info->reassembly_data_length=3D%d\n", size,
 		info->reassembly_data_length);
 	if (info->reassembly_data_length >=3D size) {
 		int queue_length;
@@ -1811,9 +1815,12 @@ static int smbd_recv_buf(struct smbd_connection *in=
fo, char *buf,
 			 * transport layer is added
 			 */
 			if (response->first_segment && size =3D=3D 4) {
-				unsigned int rfc1002_len =3D
+				unsigned int len =3D
 					data_length + remaining_data_length;
-				*((__be32 *)buf) =3D cpu_to_be32(rfc1002_len);
+				__be32 rfc1002_len =3D cpu_to_be32(len);
+				if (copy_to_iter(&rfc1002_len, sizeof(rfc1002_len),
+						 &msg->msg_iter) !=3D sizeof(rfc1002_len))
+					return -EFAULT;
 				data_read =3D 4;
 				response->first_segment =3D false;
 				log_read(INFO, "returning rfc1002 length %d\n",
@@ -1822,10 +1829,9 @@ static int smbd_recv_buf(struct smbd_connection *in=
fo, char *buf,
 			}
 =

 			to_copy =3D min_t(int, data_length - offset, to_read);
-			memcpy(
-				buf + data_read,
-				(char *)data_transfer + data_offset + offset,
-				to_copy);
+			if (copy_to_iter((char *)data_transfer + data_offset + offset,
+					 to_copy, &msg->msg_iter) !=3D to_copy)
+				return -EFAULT;
 =

 			/* move on to the next buffer? */
 			if (to_copy =3D=3D data_length - offset) {
@@ -1870,6 +1876,8 @@ static int smbd_recv_buf(struct smbd_connection *inf=
o, char *buf,
 			 data_read, info->reassembly_data_length,
 			 info->first_entry_offset);
 read_rfc1002_done:
+		/* SMBDirect will read it all or nothing */
+		msg->msg_iter.count =3D 0;
 		return data_read;
 	}
 =

@@ -1890,90 +1898,6 @@ static int smbd_recv_buf(struct smbd_connection *in=
fo, char *buf,
 	goto again;
 }
 =

-/*
- * Receive a page from receive reassembly queue
- * page: the page to read data into
- * to_read: the length of data to read
- * return value: actual data read
- */
-static int smbd_recv_page(struct smbd_connection *info,
-		struct page *page, unsigned int page_offset,
-		unsigned int to_read)
-{
-	struct smbdirect_socket *sc =3D &info->socket;
-	int ret;
-	char *to_address;
-	void *page_address;
-
-	/* make sure we have the page ready for read */
-	ret =3D wait_event_interruptible(
-		info->wait_reassembly_queue,
-		info->reassembly_data_length >=3D to_read ||
-			sc->status !=3D SMBDIRECT_SOCKET_CONNECTED);
-	if (ret)
-		return ret;
-
-	/* now we can read from reassembly queue and not sleep */
-	page_address =3D kmap_atomic(page);
-	to_address =3D (char *) page_address + page_offset;
-
-	log_read(INFO, "reading from page=3D%p address=3D%p to_read=3D%d\n",
-		page, to_address, to_read);
-
-	ret =3D smbd_recv_buf(info, to_address, to_read);
-	kunmap_atomic(page_address);
-
-	return ret;
-}
-
-/*
- * Receive data from transport
- * msg: a msghdr point to the buffer, can be ITER_KVEC or ITER_BVEC
- * return: total bytes read, or 0. SMB Direct will not do partial read.
- */
-int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
-{
-	char *buf;
-	struct page *page;
-	unsigned int to_read, page_offset;
-	int rc;
-
-	if (iov_iter_rw(&msg->msg_iter) =3D=3D WRITE) {
-		/* It's a bug in upper layer to get there */
-		cifs_dbg(VFS, "Invalid msg iter dir %u\n",
-			 iov_iter_rw(&msg->msg_iter));
-		rc =3D -EINVAL;
-		goto out;
-	}
-
-	switch (iov_iter_type(&msg->msg_iter)) {
-	case ITER_KVEC:
-		buf =3D msg->msg_iter.kvec->iov_base;
-		to_read =3D msg->msg_iter.kvec->iov_len;
-		rc =3D smbd_recv_buf(info, buf, to_read);
-		break;
-
-	case ITER_BVEC:
-		page =3D msg->msg_iter.bvec->bv_page;
-		page_offset =3D msg->msg_iter.bvec->bv_offset;
-		to_read =3D msg->msg_iter.bvec->bv_len;
-		rc =3D smbd_recv_page(info, page, page_offset, to_read);
-		break;
-
-	default:
-		/* It's a bug in upper layer to get there */
-		cifs_dbg(VFS, "Invalid msg type %d\n",
-			 iov_iter_type(&msg->msg_iter));
-		rc =3D -EINVAL;
-	}
-
-out:
-	/* SMBDirect will read it all or nothing */
-	if (rc > 0)
-		msg->msg_iter.count =3D 0;
-	return rc;
-}
-
 /*
  * Send data to transport
  * Each rqst is transported as a SMBDirect payload

