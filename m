Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA9635E943
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 21:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783979257; cv=none; b=RRBYZADFlA2Yp5xV9DcRjyAuw7zCWD1T6rzKCMJSnJqC554qfg2bLWZbBdilo4DSyFR1mZm7suXn2SXyRDH1AOIpEPFhN5rRwsye0yV+1rzYUbFlPjR4bIa4LnmrFobttzk/fs99YdnPFTwz7UhxhBPsZVQFKsDGcHnk7EePZSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783979257; c=relaxed/simple;
	bh=1gETNjfMdDd9M/st8EXM8vdHaZOiKeFQedwkMVPkXW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOA0uembIeFUcDZiGdsOBgnLeJxs33A9vgULJOONTn1B0ZoBCiisnrb8ffJb/vP+WLef6x3opcSkjD9egTDbyYOjo/jR04ysOCG1f2wqPbzfqYOJJxXGrzl8PwUOaXuJipWhblwc9w5L+1dD4+rRpL+LH+Y2C2Yb0j/iEi+DDiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oANrp5NM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7t3L7Q8I; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yVdsn0Rx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=96CIYG4+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oANrp5NM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7t3L7Q8I";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yVdsn0Rx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="96CIYG4+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E1DEC3E13;
	Mon, 13 Jul 2026 21:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9zWBnA1Jr2XMAfVzMIL+DiB3ZmYLzKFaB9CUKXEwwA=;
	b=oANrp5NMI2adWEdP9UHBzjRyXFeT1MmY8djFyvi32eWfWM1MGfygTR0MbR6+HMrpVIVQzs
	jV0e8ftTOtSTrEqMJmaVyAPRP7x5fuLlfHj1g7A9pbBgrjOiKBY9aKj7IL5MzdoncS09Ts
	nIfH3TpeJCHj8SMWyiJb2n7SHQlDknk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979254;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9zWBnA1Jr2XMAfVzMIL+DiB3ZmYLzKFaB9CUKXEwwA=;
	b=7t3L7Q8IxtWItlc1U7TYlHB/zwJWgFDiaq4ElqK5VBa2vhBDDZDXKNtEQouQ9R9PbAja52
	Y7aXbwZb6R/8yvAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yVdsn0Rx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=96CIYG4+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783979253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9zWBnA1Jr2XMAfVzMIL+DiB3ZmYLzKFaB9CUKXEwwA=;
	b=yVdsn0RxowhiXLCq107VqM2fEsHIkCUffI9eVEZqI+VvnBOH8n5HzDpNHTSuzKzObcpkYr
	SA8nL+gxQEy8+m0DjKGicdufh6vYwfCPsavov2BfjLWFJcqN//yFMZh0q4q2uJx+I6qUHU
	yCBeg7WQyZ54zKFoLLOttrPTHwr0bvQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783979253;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9zWBnA1Jr2XMAfVzMIL+DiB3ZmYLzKFaB9CUKXEwwA=;
	b=96CIYG4+ptf8zOfvd5pbYptdQKxgaatYneiMPgUK+tHRdIfQtqNv33G+kmsGA8lKRptXP6
	ftuyA8ffdjoe/nCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F493779AE;
	Mon, 13 Jul 2026 21:47:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jL+qDfVcVWrDUQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 13 Jul 2026 21:47:33 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	linkinjeon@kernel.org,
	senozhatsky@chromium.org,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 09/10] smb: client: add support for decompressing READs
Date: Mon, 13 Jul 2026 18:46:44 -0300
Message-ID: <20260713214645.550580-9-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260713214645.550580-1-ematsumiya@suse.de>
References: <20260713214645.550580-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.org,microsoft.com,talpey.com,suse.com,kernel.org,chromium.org,suse.de];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E1DEC3E13
X-Spam-Score: -3.01

Implement decompression support for SMB2 READ messages.

Changes:
- add smb2ops.c::receive_compressed()
- add check_decompress() helper in smb2ops.c
- smb/common/compress/compress.h: add is_compress_hdr() and
  decompressed_size() helpers
- check for compress header in smb3_is_transform_hdr() as well so we
  fall into the same path handling offloaded READ decryption

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/smb2ops.c           | 145 +++++++++++++++++++++++++++++-
 fs/smb/client/smb2pdu.c           |   6 ++
 fs/smb/common/compress/compress.h |  27 ++++++
 3 files changed, 177 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d60bc537ecf1..e05dbf02d3b7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -30,6 +30,8 @@
 #include "fs_context.h"
 #include "cached_dir.h"
 #include "reparse.h"
+#include "../common/compress/compress.h"
+#include "compress.h"
 
 /* Change credits for different ops and return the total number of credits */
 static int
@@ -4714,7 +4716,7 @@ smb3_is_transform_hdr(void *buf)
 {
 	struct smb2_transform_hdr *trhdr = buf;
 
-	return trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM;
+	return (trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) || is_compress_hdr(buf);
 }
 
 static int
@@ -5246,6 +5248,136 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	return ret;
 }
 
+static int receive_compressed(struct TCP_Server_Info *server)
+{
+	struct mid_q_entry *mid;
+	void *src, *dst = NULL;
+	u32 slen, dlen;
+	int ret;
+
+	slen = server->pdu_size;
+	src = kvzalloc(slen, GFP_KERNEL);
+	if (unlikely(!src))
+		return -ENOMEM;
+
+	ret = server->total_read;
+	memcpy(src, server->smallbuf, ret);
+
+	ret = cifs_read_from_socket(server, src + ret, slen - ret);
+	if (ret < 0)
+		goto err_free;
+
+	server->total_read += ret;
+
+	dlen = decompressed_size(src);
+	dst = kvzalloc(dlen, GFP_KERNEL);
+	if (unlikely(!dst)) {
+		ret = -ENOMEM;
+
+		goto err_free;
+	}
+
+	ret = smb_compression_decompress(server->compression.alg, server->compression.pattern,
+					 src, slen, dst, dlen);
+	if (likely(!ret)) {
+		const struct smb2_hdr *shdr = dst;
+
+		if (unlikely(shdr->ProtocolId != SMB2_PROTO_NUMBER)) {
+			cifs_dbg(VFS, "decompressed message is not an SMB2 message (got ProtocolId 0x%x)\n",
+				 shdr->ProtocolId);
+			ret = -ECONNRESET;
+			goto err_free;
+		}
+	} else {
+		/*
+		 * We _must_ disconnect on any failed decompression.
+		 * Actually, there's not much we can do to handle different decompression errors
+		 * here, so forcing a reconnect (which will disable compression) is our best option
+		 * as the request should be retried.
+		 */
+		ret = -ECONNRESET;
+		goto err_free;
+	}
+
+	mid = smb2_find_dequeue_mid(server, dst);
+	if (!mid) {
+		ret = -EIO;
+
+		goto err_free;
+	}
+
+	ret = handle_read_data(server, mid, dst, dlen, NULL, 0, true);
+	if (!ret) {
+		struct cifs_io_subrequest *rdata = mid->callback_data;
+#ifdef CONFIG_CIFS_STATS2
+		mid->when_received = jiffies;
+#endif
+		if (server->ops->is_network_name_deleted)
+			server->ops->is_network_name_deleted(dst, server);
+
+		rdata->iov[0].iov_base = dst;
+		rdata->iov[0].iov_len = server->vals->read_rsp_size;
+		mid_execute_callback(server, mid);
+	} else {
+		spin_lock(&server->srv_lock);
+		if (server->tcpStatus == CifsNeedReconnect) {
+			spin_lock(&server->mid_queue_lock);
+			mid->mid_state = MID_RETRY_NEEDED;
+			spin_unlock(&server->mid_queue_lock);
+			spin_unlock(&server->srv_lock);
+
+			mid_execute_callback(server, mid);
+		} else {
+			spin_lock(&server->mid_queue_lock);
+			mid->mid_state = MID_REQUEST_SUBMITTED;
+			mid->deleted_from_q = false;
+			list_add_tail(&mid->qhead, &server->pending_mid_q);
+			spin_unlock(&server->mid_queue_lock);
+			spin_unlock(&server->srv_lock);
+		}
+	}
+
+	release_mid(server, mid);
+err_free:
+	kvfree(src);
+	kvfree(dst);
+
+	if (unlikely(ret == -ECONNRESET)) {
+		spin_lock(&server->srv_lock);
+		server->tcpStatus = CifsNeedReconnect;
+		spin_unlock(&server->srv_lock);
+	}
+
+	return ret;
+}
+
+static inline int check_decompress(struct TCP_Server_Info *server, const void *buf)
+{
+	const u32 len = decompressed_size(buf);
+	u32 max_len;
+
+	if (len == 0)
+		return 0;
+
+	if (WARN_ON_ONCE(!server))
+		return -EINVAL;
+
+	if (unlikely(len < server->vals->read_rsp_size)) {
+		cifs_server_dbg(VFS, "uncompressed message too small (%u, min %zu)\n", len,
+				server->vals->read_rsp_size);
+		return -EINVAL;
+	}
+
+	max_len = 256 + SMB2_COMPRESSION_PAYLOAD_BASE_LEN +
+		  max3(server->maxBuf, server->max_read, server->max_write);
+	if (unlikely(len > max_len)) {
+		cifs_server_dbg(VFS, "uncompressed message too big (%u, max %u)\n", len, max_len);
+		return -EINVAL;
+	}
+
+	return 1;
+}
+
 static int
 smb3_receive_transform(struct TCP_Server_Info *server,
 		       struct mid_q_entry **mids, char **bufs, int *num_mids)
@@ -5254,6 +5386,15 @@ smb3_receive_transform(struct TCP_Server_Info *server,
 	unsigned int pdu_length = server->pdu_size;
 	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
 	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
+	int ret;
+
+	ret = check_decompress(server, buf);
+	if (ret > 0)
+		return receive_compressed(server);
+
+	if (unlikely(ret < 0))
+		/* Reset connection on any error */
+		return -ECONNABORTED;
 
 	if (pdu_length < sizeof(struct smb2_transform_hdr) +
 						sizeof(struct smb2_hdr)) {
@@ -5296,6 +5437,8 @@ static int smb2_next_header(struct TCP_Server_Info *server, char *buf,
 		*noff = le32_to_cpu(t_hdr->OriginalMessageSize);
 		if (unlikely(check_add_overflow(*noff, sizeof(*t_hdr), noff)))
 			return -EINVAL;
+	} else if (hdr->ProtocolId == SMB2_COMPRESSION_TRANSFORM_ID) {
+		*noff = 0;
 	} else {
 		*noff = le32_to_cpu(hdr->NextCommand);
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ba2c601f290e..a94f0c0cf8de 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4880,6 +4880,12 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 		flags |= CIFS_HAS_CREDITS;
 	}
 
+	if (should_compress(io_parms.tcon, &rqst)) {
+		struct smb2_read_req *req = (struct smb2_read_req *)buf;
+
+		req->Flags |= SMB2_READFLAG_REQUEST_COMPRESSED;
+	}
+
 	rc = cifs_call_async(server, &rqst,
 			     cifs_readv_receive, smb2_readv_callback,
 			     smb3_handle_read_data, rdata, flags,
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
index 93be0ad732f2..adc8b11910cf 100644
--- a/fs/smb/common/compress/compress.h
+++ b/fs/smb/common/compress/compress.h
@@ -152,6 +152,33 @@ static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
 	return false;
 }
 
+static __always_inline bool is_compress_hdr(const void *buf)
+{
+	const struct smb2_compression_hdr *hdr = buf;
+
+	if (!buf)
+		return false;
+
+	return (hdr->ProtocolId == SMB2_COMPRESSION_TRANSFORM_ID);
+}
+
+static __always_inline u32 decompressed_size(const void *buf)
+{
+	const struct smb2_compression_hdr *hdr = buf;
+	u32 len;
+
+	if (!buf || !is_compress_hdr(buf))
+		return 0;
+
+	len = le32_to_cpu(hdr->OriginalCompressedSegmentSize);
+
+	/* When unchained, we must account for the offset part (usually SMB2 header) as well. */
+	if (le16_to_cpu(hdr->Flags) == SMB2_COMPRESSION_FLAG_NONE)
+		len += le32_to_cpu(hdr->Offset);
+
+	return len;
+}
+
 /**
  * smb_compress_alloc_size() - Compute total allocation size required for compressed (dst) buffer.
  * @size:		uncompressed size
-- 
2.54.0

