Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B7725CC63
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093661; cv=none; b=bX2W7LlNMOc46V0v14BUjRcGPtah+IJD+IOIc7Dbwy2qfIJvsdfq4FMJGk8grpthaGcRHc+u6e8gewlX6mWkAIieBbi1otRPVHGfD6Xsufk9hI2O4cLvJ9LOxtzzBefkJtYTWurENC63h08uT5sMVpD60qnT2jQSEO2y9wxCVbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093661; c=relaxed/simple;
	bh=gFq1nv5IH5JkuQUX9nimZCwWIVIE4Rb051u099YEcCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EchRul/SPjFtnL1fOVfl+M4N50NVwVkg+cf2vl8D76yrLsstIAc+AnOSB0CsBBPPtSzSeS/W/U5GdiGGFiv+HXwWospuv0AXN8kLv4P/Rcf/WkfvXJj8rc9G/WIza/7WIWe2Lba2mWbhxdTqhelBuHgr4T8rDbkKkjh+tqh5T/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=l9VNwLG6; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="l9VNwLG6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=jzupWyNj+MhdfsWHMq6FTS6bwH4NLUQh9F+UlYiUKFQ=; b=l9VNwLG6Sm2SpwOdwGeJV6rSfs
	ZC9MJbN9dbE/HxckkwL5n+2YYRnZPKN/QJBohXAZShFND2si/REtg9iMD2ej2YjHOKHGq1AECFMbM
	KAgzpSfA5XwT/1A3jw5R5nSCY5eeceeu5hU/uh6YN/JT602V8+RZYfgyOtnoeO7nPUvPrhiCEPKMu
	b0JZ9XLNv7oibAawHWu+JvHNd55hGU29ZX0SSkKF5gH2QIS0QnoL5hSj/KIU0p/Y3zhA2aQYDd4gn
	NBZNeVN6pzYyhMIrssYGYBdQIRFqXndhI6LBulZWwrhB6NA5YYevujQgP23wRRxMRgS3BjNU6VGUr
	BWHM127u6u10oHRJxyhx6aeh5KPc9SiuaMFywGWTTye0+C3u5hv1uOQ//4PHWkSvklCHYiXaG16KY
	7yjzKiYd/yHxEjaNLuiRWv+rVr3HG/p1U1J33Xcw99/IOpgs3j1wWNjZi87Q06MVKfUvWx498xsCS
	N9ESEHgJqnuAbXDFuRhkgIVO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxLR-00Fd76-1S;
	Tue, 25 Nov 2025 18:00:53 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 041/145] smb: smbdirect: introduce smbdirect_connection_recvmsg()
Date: Tue, 25 Nov 2025 18:54:47 +0100
Message-ID: <f752acca7635f4714c06c547c3f8a0d4767f8b11.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is basically a copy of smbd_recv() in the client.

And it's very similar to smb_direct_read() in the server.

It will replace both in the following commits.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 151 ++++++++++++++++++
 1 file changed, 151 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 5c4303093b15..71d2ee4030a2 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -1062,6 +1062,157 @@ static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 	}
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_connection_recvmsg(struct smbdirect_socket *sc,
+					struct msghdr *msg,
+					unsigned int flags)
+{
+	struct smbdirect_recv_io *response;
+	struct smbdirect_data_transfer *data_transfer;
+	size_t size = iov_iter_count(&msg->msg_iter);
+	int to_copy, to_read, data_read, offset;
+	u32 data_length, remaining_data_length, data_offset;
+	int ret;
+
+	if (WARN_ON_ONCE(flags))
+		return -EINVAL; /* no flags support for now */
+
+	if (WARN_ON_ONCE(iov_iter_rw(&msg->msg_iter) != ITER_DEST))
+		return -EINVAL; /* It's a bug in upper layer to get there */
+
+again:
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+		smbdirect_log_read(sc, SMBDIRECT_LOG_ERR,
+			"status=%s first_error=%1pe => %s\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+			errname(-ENOTCONN));
+		return -ENOTCONN;
+	}
+
+	/*
+	 * No need to hold the reassembly queue lock all the time as we are
+	 * the only one reading from the front of the queue. The transport
+	 * may add more entries to the back of the queue at the same time
+	 */
+	smbdirect_log_read(sc, SMBDIRECT_LOG_INFO,
+		"size=%zd sc->recv_io.reassembly.data_length=%d\n",
+		size, sc->recv_io.reassembly.data_length);
+	if (sc->recv_io.reassembly.data_length >= size) {
+		int queue_length;
+		int queue_removed = 0;
+		unsigned long flags;
+
+		/*
+		 * Need to make sure reassembly_data_length is read before
+		 * reading reassembly_queue_length and calling
+		 * smbdirect_connection_reassembly_first_recv_io. This call is lock free
+		 * as we never read at the end of the queue which are being
+		 * updated in SOFTIRQ as more data is received
+		 */
+		virt_rmb();
+		queue_length = sc->recv_io.reassembly.queue_length;
+		data_read = 0;
+		to_read = size;
+		offset = sc->recv_io.reassembly.first_entry_offset;
+		while (data_read < size) {
+			response = smbdirect_connection_reassembly_first_recv_io(sc);
+			data_transfer = (void *)response->packet;
+			data_length = le32_to_cpu(data_transfer->data_length);
+			remaining_data_length =
+				le32_to_cpu(
+					data_transfer->remaining_data_length);
+			data_offset = le32_to_cpu(data_transfer->data_offset);
+
+			/*
+			 * The upper layer expects RFC1002 length at the
+			 * beginning of the payload. Return it to indicate
+			 * the total length of the packet. This minimize the
+			 * change to upper layer packet processing logic. This
+			 * will be eventually remove when an intermediate
+			 * transport layer is added
+			 */
+			if (response->first_segment && size == 4) {
+				unsigned int rfc1002_len =
+					data_length + remaining_data_length;
+				__be32 rfc1002_hdr = cpu_to_be32(rfc1002_len);
+
+				if (copy_to_iter(&rfc1002_hdr, sizeof(rfc1002_hdr),
+						 &msg->msg_iter) != sizeof(rfc1002_hdr))
+					return -EFAULT;
+				data_read = 4;
+				response->first_segment = false;
+				smbdirect_log_read(sc, SMBDIRECT_LOG_INFO,
+					"returning rfc1002 length %d\n",
+					rfc1002_len);
+				goto read_rfc1002_done;
+			}
+
+			to_copy = min_t(int, data_length - offset, to_read);
+			if (copy_to_iter((u8 *)data_transfer + data_offset + offset,
+					 to_copy, &msg->msg_iter) != to_copy)
+				return -EFAULT;
+
+			/* move on to the next buffer? */
+			if (to_copy == data_length - offset) {
+				queue_length--;
+				/*
+				 * No need to lock if we are not at the
+				 * end of the queue
+				 */
+				if (queue_length)
+					list_del(&response->list);
+				else {
+					spin_lock_irqsave(
+						&sc->recv_io.reassembly.lock, flags);
+					list_del(&response->list);
+					spin_unlock_irqrestore(
+						&sc->recv_io.reassembly.lock, flags);
+				}
+				queue_removed++;
+				sc->statistics.dequeue_reassembly_queue++;
+				smbdirect_connection_put_recv_io(response);
+				offset = 0;
+				smbdirect_log_read(sc, SMBDIRECT_LOG_INFO,
+					"smbdirect_connection_put_recv_io offset=0\n");
+			} else
+				offset += to_copy;
+
+			to_read -= to_copy;
+			data_read += to_copy;
+
+			smbdirect_log_read(sc, SMBDIRECT_LOG_INFO,
+				 "memcpy %d bytes len-ofs=%u => todo=%u done=%u ofs=%u\n",
+				 to_copy, data_length - offset,
+				 to_read, data_read, offset);
+		}
+
+		spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
+		sc->recv_io.reassembly.data_length -= data_read;
+		sc->recv_io.reassembly.queue_length -= queue_removed;
+		spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
+
+		sc->recv_io.reassembly.first_entry_offset = offset;
+		smbdirect_log_read(sc, SMBDIRECT_LOG_INFO,
+			 "returning data_read=%d reassembly_length=%d first_ofs=%u\n",
+			 data_read, sc->recv_io.reassembly.data_length,
+			 sc->recv_io.reassembly.first_entry_offset);
+read_rfc1002_done:
+		return data_read;
+	}
+
+	smbdirect_log_read(sc, SMBDIRECT_LOG_INFO,
+		"wait_event on more data\n");
+	ret = wait_event_interruptible(sc->recv_io.reassembly.wait_queue,
+				       sc->recv_io.reassembly.data_length >= size ||
+				       sc->status != SMBDIRECT_SOCKET_CONNECTED);
+	/* Don't return any data if interrupted */
+	if (ret)
+		return ret;
+
+	goto again;
+}
+
 static bool smbdirect_map_sges_single_page(struct smbdirect_map_sges *state,
 					   struct page *page, size_t off, size_t len)
 {
-- 
2.43.0

