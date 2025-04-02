Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9511E1BBBF7
	for <linux-cifs@vger.kernel.org>; Wed,  2 Apr 2025 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743623673; cv=none; b=rkwdF/ZserZZxIrYo57K06YBM6p2cedGWX3TE5z2WAqZlcLjxzJ9uSFYiQgvdoY6m0q0Zo9C0DmBwiMZH3e7Cs2XccfCtxVMh82l7JtrM4MlEtpzz0bV6YV20mqONOFIvASKvVvU4pTEGYqKHoB2+00Fu+BEfbpJ05zMqV0VoqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743623673; c=relaxed/simple;
	bh=utIXTH4vT0+07U5145S2rL36xjzRGd42Miknc992klQ=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=NL889VqKFDJ9ycstGrCBkKTbjA11fn6/ijXkCl2Sufxsgmlbv4w3AKF62OUeKTp0P9cmGND9kQY8hCtWY1VUCulpogSI9nDUlxIiOh5eLjnr+yMCZCf+zpPk0OSo3ZId57dRjC/S0dCtYCuHOcIXiOHt6UNJe3Hq0nos9vJPZyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y3Z5U43C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y3Z5U43C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743623670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4qTK7aH8hzh7kegtXlFSz+v4OWqyPhLQufAIqPrXTA4=;
	b=Y3Z5U43C9sPHrrZ08xeC8narr4hII3kWZpku+BRZH5H3cOonDX6X73l/Kh9jbSASIQHKY8
	9cfkwW0qDaL1hNzzoiyjU6WkHYDzdk8YoT8J8aO8/xmZzrJfYureo8W5UKEiicYfMipknH
	dR+TUjGyDGE0dLDtx5Y2ggT8ZwCgyE0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-ZdHQTSbYPIGup9qap95Hag-1; Wed,
 02 Apr 2025 15:54:27 -0400
X-MC-Unique: ZdHQTSbYPIGup9qap95Hag-1
X-Mimecast-MFC-AGG-ID: ZdHQTSbYPIGup9qap95Hag_1743623665
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC7881809CA6;
	Wed,  2 Apr 2025 19:54:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.40])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 03A8D3001D0E;
	Wed,  2 Apr 2025 19:54:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <49b8b758-2d72-4de9-b0f1-dbf9a7124cdf@talpey.com>
References: <49b8b758-2d72-4de9-b0f1-dbf9a7124cdf@talpey.com> <b8dbed47-8824-4b3a-b373-061e139ee7a4@talpey.com> <78c910b0-3391-484e-aa44-42e2f9ff4637@talpey.com> <563557.1743526559@warthog.procyon.org.uk> <659109.1743536087@warthog.procyon.org.uk> <7e1fc71c-2821-4294-833c-746c5fd7ee69@talpey.com> <803441.1743613785@warthog.procyon.org.uk> <CAH2r5ms2J06tJr4VEVDgmcj_1uqOnhYzbC1ybrMWDm=f8wVDoA@mail.gmail.com> <843601.1743622017@warthog.procyon.org.uk>
To: Tom Talpey <tom@talpey.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    Steve French <sfrench@samba.org>,
    Stefan Metzmacher <metze@samba.org>,
    Paulo Alcantara <pc@manguebit.com>,
    Matthew Wilcox <willy@infradead.org>,
    CIFS <linux-cifs@vger.kernel.org>
Subject: [RFC PATCH] cifs: Collapse smbd_recv_*() into smbd_recv() and just use copy_to_iter()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <849584.1743623661.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Apr 2025 20:54:21 +0100
Message-ID: <849585.1743623661@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Tom Talpey <tom@talpey.com> wrote:

> I guess so. That code has been there all long and I haven't
> looked into changing it. The comment at the top certainly says
> it's something to consider.
> =

> The SMB Direct reassembly stuff is the non-RDMA path, where a
> message payload is too large for a single ~1KB datagram, but
> was not registered for direct placement. This would mainly be
> fsctl's and small reads. I wouldn't get too worked up about
> highly optimizing those.

The idea is to get rid of struct page entirely from the kernel.

I've attached an untested patch that should clean up smbd_recv() for your
perusal.

David
---
commit dec3911780bf7849d637cd31e697b9b9ba2f67da
Author: David Howells <dhowells@redhat.com>
Date:   Wed Apr 2 20:27:26 2025 +0100

    cifs: Collapse smbd_recv_*() into smbd_recv() and just use copy_to_ite=
r()
    =

    Collapse smbd_recv_buf() and smbd_recv_page() into smbd_recv() and jus=
t use
    copy_to_iter() instead of memcpy().
    =

    Signed-off-by: David Howells <dhowells@redhat.com>
    cc: Steve French <stfrench@microsoft.com>
    cc: Tom Talpey <tom@talpey.com>
    cc: Stefan Metzmacher <metze@samba.org>
    cc: Paulo Alcantara (Red Hat) <pc@manguebit.com>
    cc: Matthew Wilcox <willy@infradead.org>
    cc: linux-cifs@vger.kernel.org
    cc: netfs@lists.linux.dev
    cc: linux-fsdevel@vger.kernel.org

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b0b7254661e9..4d3c3b50af99 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1718,35 +1718,40 @@ struct smbd_connection *smbd_get_connection(
 	return ret;
 }
 =

+
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
 	struct smbd_response *response;
 	struct smbd_data_transfer *data_transfer;
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
@@ -1782,9 +1787,12 @@ static int smbd_recv_buf(struct smbd_connection *in=
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
@@ -1793,10 +1801,9 @@ static int smbd_recv_buf(struct smbd_connection *in=
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
@@ -1841,6 +1848,8 @@ static int smbd_recv_buf(struct smbd_connection *inf=
o, char *buf,
 			 data_read, info->reassembly_data_length,
 			 info->first_entry_offset);
 read_rfc1002_done:
+		/* SMBDirect will read it all or nothing */
+		msg->msg_iter.count =3D 0;
 		return data_read;
 	}
 =

@@ -1861,89 +1870,6 @@ static int smbd_recv_buf(struct smbd_connection *in=
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
-	int ret;
-	char *to_address;
-	void *page_address;
-
-	/* make sure we have the page ready for read */
-	ret =3D wait_event_interruptible(
-		info->wait_reassembly_queue,
-		info->reassembly_data_length >=3D to_read ||
-			info->transport_status !=3D SMBD_CONNECTED);
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

