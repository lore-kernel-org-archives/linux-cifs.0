Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0532352016;
	Tue, 19 May 2026 10:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186988; cv=none; b=CuCScb2iqwV4w1ujtYgPWJ55+Q9F7GewgsSzxrXB/n4w4nPj05fObCcGELw3GIi//jXZTuMiUKtaeVGfjdmi/D7kEub8N7xSx0PN1/6vXih8JQh59klA9Phb/spGSv5sjNmuWQALAcdka0x/l89+57Ckn4d25G61cmSmsj0l42Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186988; c=relaxed/simple;
	bh=iJGYvXkw8THWW4ZCHMRI8xTGotyPiMzjXdcRBPh3yiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bqN+Hn/+Al/eqtEdbDe1nftb2twhBPoXAJjlckIA1KcyxkHsR+kgCmIhCDXPNBaxJBnhKLYN2MLPb4NL8ZiQvqJYw+F2YHUYXEAabjm1SG/7JUtFFcEmCR/Co7e31G99MXg2xQsnW4AaXvHJg7rqviHWnPDzQWsoeBcoiHa7xQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ukk+Pepz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ukk+Pepz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=88efu7SKWFfziXCA0eX8GLKZkRj/heGOt3I4LG/V2RM=; b=ukk+Pepz6ZRto07Dr+60cwGatn
	c4krgTTftXLM8oROgzCqRSKUqtpqsFEH3uQR2aH8SgDP0TVskjEDJV+kA4fhFPanteGRbqGGOvOP7
	mCNNw+2aHXiLbL95Zj7GtCjJLNpX073kqyfSVajH9y80PJIe+cwnwJvXYc/Pali11jVJ6Js9yHkEn
	g+uy4Bmh1xlDYu7OYJULacVa/gRshgGP61I0Lxad5lLcUin6ppsYQuwwYO7GvRC8HGI5OhP3DVtm8
	qc6i/DZ/T17ATm4ijPf3WI8/8fR4OexCfUt0/JWltiOY5zyPK8nkETNbTsoH4M88oWWrHl9neOho0
	BqzG43+Q2vJ68w/9BlOHnIFX4w4ZLqQ8on7ouEahhz0xNN3gGEgk1EJTgzlQTL9rJ7XrknTHwe/G4
	dbYzhni7AsqD7qHm1InTUj5MKykVbe+qIYV1Y8vvGBIMQ7uuI+kxbOiYyuHOYHwG2XQIInVKesTwz
	8H+9W/R4FuDTrg/tXoe9kssW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wPHoD-0000000A65G-3xvx;
	Tue, 19 May 2026 10:36:22 +0000
Message-ID: <c90da0d5-008c-47f5-be76-cadc9f337855@samba.org>
Date: Tue, 19 May 2026 12:36:21 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 16/36] cifs: Rewrite base TCP transmission
To: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Mina Almasry <almasrymina@google.com>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
References: <20260519102158.592165-1-dhowells@redhat.com>
 <20260519102158.592165-17-dhowells@redhat.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260519102158.592165-17-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 19.05.26 um 12:21 schrieb David Howells:
> Rewrite the base TCP transmission in cifs to copy all the content in a
> (compound) message into a buffer of pages in a bvecq chain.  In future, the
> pages in this bvecq chain will be allocated from the netmem allocator so
> that the advance DMA/IOMMU handling will be done.
>
> This list of pages can then be attached to an ITER_BVEC_QUEUE-type iov_iter
> and passed in a single call to sendmsg() with MSG_SPLICE_PAGES, thereby
> avoiding the need to copy the data in the TCP stack.

If smbd_send() would just call smbdirect_connection_send_iter()
the iov_iter_advance(iter, 4); is no longer needed.

It also allows me to make these static:
smbdirect_connection_send_batch_flush
smbdirect_init_send_batch_storage
smbdirect_connection_send_single_iter
smbdirect_connection_send_wait_zero_pending

And it will help with the transition to use
sendmsg() with MSG_SPLICE_PAGES for smbdirect too.

Below are some inline comments basically saying the same.

Thanks!
metze

> The encryption code can also be simplified as it only needs to encrypt the
> data stored in those pages, with the bonus that the content in the pages is
> correctly aligned for the encryption in place such that it does not need to
> copy the data whilst encrypting it.
> 
> It could be arranged for the data to be held in contiguous pages if
> possible and if necessary such that crypto can be offloaded to devices that
> only permit a single contiguous buffer.
> 
> Note that with this patch, "mount -o compress,seal" will now compress
> writes and then encrypt them.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Steve French <sfrench@samba.org>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Shyam Prasad N <sprasad@microsoft.com>
> cc: Tom Talpey <tom@talpey.com>
> cc: linux-cifs@vger.kernel.org
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> ---
>   fs/smb/client/cifsglob.h      |   6 +-
>   fs/smb/client/cifsproto.h     |   3 +-
>   fs/smb/client/compress.c      | 146 ++++++++-----
>   fs/smb/client/compress.h      |  10 +-
>   fs/smb/client/smb1ops.c       |   5 +-
>   fs/smb/client/smb2ops.c       | 273 +-----------------------
>   fs/smb/client/smb2proto.h     |   4 +
>   fs/smb/client/smb2transport.c | 113 ++++++++++
>   fs/smb/client/smbdirect.c     | 105 ++-------
>   fs/smb/client/smbdirect.h     |   5 +-
>   fs/smb/client/transport.c     | 387 +++++++++++++++++++++++-----------
>   11 files changed, 517 insertions(+), 540 deletions(-)
> 
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 2cb858495bc1..f7c12d24e2ea 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -571,8 +571,10 @@ struct smb_version_operations {
>   	long (*fallocate)(struct file *, struct cifs_tcon *, int, loff_t,
>   			  loff_t);
>   	/* init transform (compress/encrypt) request */
> -	int (*init_transform_rq)(struct TCP_Server_Info *, int num_rqst,
> -				 struct smb_rqst *, struct smb_rqst *);
> +	int (*init_transform_rq)(struct TCP_Server_Info *server,
> +				 int num_rqst, const struct smb_rqst *rqst,
> +				 struct smb2_transform_hdr *tr_hdr,
> +				 struct iov_iter *iter);
>   	enum securityEnum (*select_sectype)(struct TCP_Server_Info *,
>   			    enum securityEnum);
>   	int (*next_header)(struct TCP_Server_Info *server, char *buf,
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 8dedfd677f8d..1c9ac67b7294 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -106,8 +106,7 @@ int compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>   		       int *resp_buf_type, struct kvec *resp_iov);
>   int cifs_sync_mid_result(struct smb_message *mid,
>   			 struct TCP_Server_Info *server);
> -int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
> -		    struct smb_rqst *rqst);
> +int __smb_send_rqst(struct TCP_Server_Info *server, struct iov_iter *iter);
>   int wait_for_free_request(struct TCP_Server_Info *server, const int flags,
>   			  unsigned int *instance);
>   int cifs_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
> diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
> index be9023f841e6..a9496983ac56 100644
> --- a/fs/smb/client/compress.c
> +++ b/fs/smb/client/compress.c
> @@ -16,6 +16,7 @@
>   #include <linux/kernel.h>
>   #include <linux/uio.h>
>   #include <linux/sort.h>
> +#include <linux/vmalloc.h>
>   
>   #include "cifsglob.h"
>   #include "../common/smb2pdu.h"
> @@ -191,7 +192,7 @@ static int collect_sample(const struct iov_iter *source, ssize_t max, u8 *sample
>    * Tests shows that this function is quite reliable in predicting data compressibility,
>    * matching close to 1:1 with the behaviour of LZ77 compression success and failures.
>    */
> -static bool is_compressible(const struct iov_iter *data)
> +bool is_compressible(const struct iov_iter *data)
>   {
>   	const size_t read_size = SZ_2K, bkt_size = 256, max = SZ_4M;
>   	struct bucket *bkt = NULL;
> @@ -295,74 +296,123 @@ bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
>   		if (le32_to_cpu(wreq->Length) < SMB_COMPRESS_MIN_LEN)
>   			return false;
>   
> -		return is_compressible(&rq->rq_iter);
> +		return true;
>   	}
>   
>   	return (shdr->Command == SMB2_READ);
>   }
>   
> -int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq, compress_send_fn send_fn)
> +/*
> + * vmap the pages from a BVECQ-type iterator.
> + */
> +static void *vmap_bvecq(struct iov_iter *iter, pgprot_t prot)
>   {
> -	struct iov_iter iter;
> -	u32 slen, dlen;
> -	void *src, *dst = NULL;
> -	int ret;
> +	struct page **pages = NULL;
> +	ssize_t size, offset;
> +	void *map;
>   
> -	if (!server || !rq || !rq->rq_iov || !rq->rq_iov->iov_base)
> -		return -EINVAL;
> +	if (WARN_ON(!iov_iter_is_bvecq(iter)))
> +		return ERR_PTR(-EIO);
>   
> -	if (rq->rq_iov->iov_len != sizeof(struct smb2_write_req))
> -		return -EINVAL;
> +	size = iov_iter_extract_pages(iter, &pages, INT_MAX, INT_MAX, 0, &offset);
> +	if (size < 0)
> +		return ERR_PTR(size);
>   
> -	slen = iov_iter_count(&rq->rq_iter);
> -	src = kvzalloc(slen, GFP_KERNEL);
> -	if (!src) {
> -		ret = -ENOMEM;
> -		goto err_free;
> +	if (size == 0 || offset > 0) {
> +		kvfree(pages);
> +		return ERR_PTR(-EIO);
>   	}
>   
> -	/* Keep the original iter intact. */
> -	iter = rq->rq_iter;
> +	map = vmap(pages, DIV_ROUND_UP(size, PAGE_SIZE), 0, prot);
> +	kvfree(pages);
> +	if (!map)
> +		return ERR_PTR(-ENOMEM);
> +	return map;
> +}
> +
> +int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
> +		 struct bvecq **bq)
> +{
> +	struct smb2_compression_hdr *z_hdr;
> +	struct smb2_write_req *w_hdr;
> +	struct smb2_hdr *shdr;
> +	struct iov_iter tmp;
> +	struct bvecq *sbq = *bq, *dbq = NULL;
> +	void *src, *dst = NULL;
> +	u32 slen, dlen, hlen, datalen;
> +	int ret;
>   
> -	if (!copy_from_iter_full(src, slen, &iter)) {
> -		ret = smb_EIO(smb_eio_trace_compress_copy);
> +	/* We need contiguous buffers for the compression algorithm. */
> +	slen = iov_iter_count(iter);
> +	src = vmap_bvecq(iter, PAGE_KERNEL_RO);
> +	if (IS_ERR(src)) {
> +		ret = PTR_ERR(src);
> +		src = NULL;
>   		goto err_free;
>   	}
>   
> +	shdr = src;
> +	hlen  = le16_to_cpu(shdr->StructureSize);
> +	w_hdr = src;
> +	hlen = le16_to_cpu(w_hdr->DataOffset);
> +	datalen = le32_to_cpu(w_hdr->Length);
> +	if (datalen != slen - hlen) {
> +		pr_warn("datalen %x != slen-hlen %x\n", datalen, slen - hlen);
> +		return -EMSGSIZE;
> +	}
> +
> +	/*
> +	 * This is just overprovisioning, as the algorithm will error out if @dst reaches 7/8
> +	 * of @slen.
> +	 */
>   	dlen = lz77_compressed_alloc_size(slen);
> -	dst = kvzalloc(dlen, GFP_KERNEL);
> -	if (!dst) {
> +	dlen = sizeof(*z_hdr) + slen;
> +	dbq = bvecq_alloc_buffer(dlen, GFP_NOFS);
> +	if (!dbq) {
>   		ret = -ENOMEM;
>   		goto err_free;
>   	}
>   
> -	ret = lz77_compress(src, slen, dst, &dlen);
> -	if (!ret) {
> -		struct smb2_compression_hdr hdr = { 0 };
> -		struct smb_rqst comp_rq = { .rq_nvec = 3, };
> -		struct kvec iov[3];
> -
> -		hdr.ProtocolId = SMB2_COMPRESSION_TRANSFORM_ID;
> -		hdr.OriginalCompressedSegmentSize = cpu_to_le32(slen);
> -		hdr.CompressionAlgorithm = SMB3_COMPRESS_LZ77;
> -		hdr.Flags = SMB2_COMPRESSION_FLAG_NONE;
> -		hdr.Offset = cpu_to_le32(rq->rq_iov[0].iov_len);
> -
> -		iov[0].iov_base = &hdr;
> -		iov[0].iov_len = sizeof(hdr);
> -		iov[1] = rq->rq_iov[0];
> -		iov[2].iov_base = dst;
> -		iov[2].iov_len = dlen;
> -
> -		comp_rq.rq_iov = iov;
> -
> -		ret = send_fn(server, 1, &comp_rq);
> -	} else if (ret == -EMSGSIZE || dlen >= slen) {
> -		ret = send_fn(server, 1, rq);
> +	iov_iter_bvec_queue(&tmp, ITER_DEST, dbq, 1, 0, dlen);
> +	dst = vmap_bvecq(&tmp, PAGE_KERNEL);
> +	if (IS_ERR(dst)) {
> +		ret = PTR_ERR(dst);
> +		dst = NULL;
> +		goto err_free;
>   	}
> -err_free:
> -	kvfree(dst);
> -	kvfree(src);
> +	z_hdr = dst;
> +	dst  += sizeof(*z_hdr) + hlen;
> +	dlen -= sizeof(*z_hdr) + hlen;
> +
> +	ret = lz77_compress(src + hlen, slen - hlen, dst, &dlen);
> +	if (ret)
> +		goto err_free;
> +
> +	dlen += sizeof(*z_hdr) + hlen;
> +	dst -= hlen;
> +	memcpy(dst, src, hlen);
>   
> +	z_hdr->ProtocolId			= SMB2_COMPRESSION_TRANSFORM_ID;
> +	z_hdr->OriginalCompressedSegmentSize	= cpu_to_le32(datalen);
> +	z_hdr->CompressionAlgorithm		= SMB3_COMPRESS_LZ77;
> +	z_hdr->Flags				= SMB2_COMPRESSION_FLAG_NONE;
> +	z_hdr->Offset				= cpu_to_le32(hlen);
> +
> +	vunmap(z_hdr);
> +	vunmap(src);
> +
> +	dbq->bv[0] = sbq->bv[0];
> +	memset(&sbq->bv[0], 0, sizeof(sbq->bv[0]));
> +	bvecq_shorten_buffer(dbq, 1, dlen);
> +	bvecq_dump(dbq);
> +
> +	bvecq_put(sbq);
> +	*bq = dbq;
> +	return dlen;
> +
> +err_free:
> +	vunmap(z_hdr);
> +	vunmap(src);
> +	bvecq_put(dbq);
>   	return ret;
>   }
> diff --git a/fs/smb/client/compress.h b/fs/smb/client/compress.h
> index 2679baca129b..48812b0e7476 100644
> --- a/fs/smb/client/compress.h
> +++ b/fs/smb/client/compress.h
> @@ -30,9 +30,10 @@
>   typedef int (*compress_send_fn)(struct TCP_Server_Info *, int, struct smb_rqst *);
>   
>   
> -int smb_compress(struct TCP_Server_Info *server, struct smb_rqst *rq,
> -		 compress_send_fn send_fn);
> +int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
> +		 struct bvecq **bq);
>   bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq);
> +bool is_compressible(const struct iov_iter *data);
>   
>   /*
>    * smb_compress_alg_valid() - Validate a compression algorithm.
> @@ -58,11 +59,14 @@ static __always_inline int smb_compress_alg_valid(__le16 alg, bool valid_none)
>   	return false;
>   }
>   #else /* !CONFIG_CIFS_COMPRESSION */
> -static inline int smb_compress(void *unused1, void *unused2, void *unused3)
> +static inline
> +int smb_compress(struct TCP_Server_Info *server, struct iov_iter *iter,
> +		 struct bvecq **bq)
>   {
>   	return -EOPNOTSUPP;
>   }
>   
> +static inline bool is_compressible(const struct iov_iter *data) { return false; }
>   static inline bool should_compress(void *unused1, void *unused2)
>   {
>   	return false;
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index 042d44788321..8477440bbcc2 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -142,6 +142,7 @@ send_nt_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
>   	       struct smb_rqst *rqst, struct smb_message *smb,
>   	       unsigned int xid)
>   {
> +	struct iov_iter iter;
>   	struct smb_hdr *in_buf = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
>   	struct kvec iov[1];
>   	struct smb_rqst crqst = { .rq_iov = iov, .rq_nvec = 1 };
> @@ -162,13 +163,15 @@ send_nt_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
>   		return rc;
>   	}
>   
> +	iov_iter_kvec(&iter, ITER_SOURCE, iov, 1, iov[0].iov_len);
> +
>   	/*
>   	 * The response to this call was already factored into the sequence
>   	 * number when the call went out, so we must adjust it back downward
>   	 * after signing here.
>   	 */
>   	--server->sequence_number;
> -	rc = __smb_send_rqst(server, 1, &crqst);
> +	rc = __smb_send_rqst(server, &iter);
>   	if (rc < 0)
>   		server->sequence_number--;
>   
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 3c30417a3ea6..6125184d9826 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2746,9 +2746,7 @@ void
>   smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
>   {
>   	struct smb2_hdr *shdr;
> -	struct cifs_ses *ses = tcon->ses;
> -	struct TCP_Server_Info *server = ses->server;
> -	unsigned long len = smb_rqst_len(server, rqst);
> +	size_t len = 0;
>   	int num_padding;
>   
>   	shdr = (struct smb2_hdr *)(rqst->rq_iov[0].iov_base);
> @@ -2757,6 +2755,10 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
>   		return;
>   	}
>   
> +	for (int i = 0; i < rqst->rq_nvec; i++)
> +		len += rqst->rq_iov[i].iov_len;
> +	len += iov_iter_count(&rqst->rq_iter);
> +
>   	/* SMB headers in a compound are 8 byte aligned. */
>   	if (IS_ALIGNED(len, 8))
>   		goto out;
> @@ -4326,105 +4328,6 @@ smb2_dir_needs_close(struct cifsFileInfo *cfile)
>   	return !cfile->invalidHandle;
>   }
>   
> -static void
> -fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
> -		   struct smb_rqst *old_rq, __le16 cipher_type)
> -{
> -	struct smb2_hdr *shdr =
> -			(struct smb2_hdr *)old_rq->rq_iov[0].iov_base;
> -
> -	memset(tr_hdr, 0, sizeof(struct smb2_transform_hdr));
> -	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
> -	tr_hdr->OriginalMessageSize = cpu_to_le32(orig_len);
> -	tr_hdr->Flags = cpu_to_le16(0x01);
> -	if ((cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
> -	    (cipher_type == SMB2_ENCRYPTION_AES256_GCM))
> -		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
> -	else
> -		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
> -	memcpy(&tr_hdr->SessionId, &shdr->SessionId, 8);
> -}
> -
> -static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst *rqst,
> -				 int num_rqst, const u8 *sig, u8 **iv,
> -				 struct aead_request **req, struct sg_table *sgt,
> -				 unsigned int *num_sgs)
> -{
> -	unsigned int req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
> -	unsigned int iv_size = crypto_aead_ivsize(tfm);
> -	unsigned int len;
> -	u8 *p;
> -
> -	*num_sgs = cifs_get_num_sgs(rqst, num_rqst, sig);
> -	if (IS_ERR_VALUE((long)(int)*num_sgs))
> -		return ERR_PTR(*num_sgs);
> -
> -	len = iv_size;
> -	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
> -	len = ALIGN(len, crypto_tfm_ctx_alignment());
> -	len += req_size;
> -	len = ALIGN(len, __alignof__(struct scatterlist));
> -	len += array_size(*num_sgs, sizeof(struct scatterlist));
> -
> -	p = kzalloc(len, GFP_NOFS);
> -	if (!p)
> -		return ERR_PTR(-ENOMEM);
> -
> -	*iv = (u8 *)PTR_ALIGN(p, crypto_aead_alignmask(tfm) + 1);
> -	*req = (struct aead_request *)PTR_ALIGN(*iv + iv_size,
> -						crypto_tfm_ctx_alignment());
> -	sgt->sgl = (struct scatterlist *)PTR_ALIGN((u8 *)*req + req_size,
> -						   __alignof__(struct scatterlist));
> -	return p;
> -}
> -
> -static void *smb2_get_aead_req(struct crypto_aead *tfm, struct smb_rqst *rqst,
> -			       int num_rqst, const u8 *sig, u8 **iv,
> -			       struct aead_request **req, struct scatterlist **sgl)
> -{
> -	struct sg_table sgtable = {};
> -	unsigned int skip, num_sgs, i, j;
> -	ssize_t rc;
> -	void *p;
> -
> -	p = smb2_aead_req_alloc(tfm, rqst, num_rqst, sig, iv, req, &sgtable, &num_sgs);
> -	if (IS_ERR(p))
> -		return ERR_CAST(p);
> -
> -	sg_init_marker(sgtable.sgl, num_sgs);
> -
> -	/*
> -	 * The first rqst has a transform header where the
> -	 * first 20 bytes are not part of the encrypted blob.
> -	 */
> -	skip = 20;
> -
> -	for (i = 0; i < num_rqst; i++) {
> -		struct iov_iter *iter = &rqst[i].rq_iter;
> -		size_t count = iov_iter_count(iter);
> -
> -		for (j = 0; j < rqst[i].rq_nvec; j++) {
> -			cifs_sg_set_buf(&sgtable,
> -					rqst[i].rq_iov[j].iov_base + skip,
> -					rqst[i].rq_iov[j].iov_len - skip);
> -
> -			/* See the above comment on the 'skip' assignment */
> -			skip = 0;
> -		}
> -		sgtable.orig_nents = sgtable.nents;
> -
> -		rc = extract_iter_to_sg(iter, count, &sgtable,
> -					num_sgs - sgtable.nents, 0);
> -		iov_iter_revert(iter, rc);
> -		sgtable.orig_nents = sgtable.nents;
> -	}
> -
> -	cifs_sg_set_buf(&sgtable, sig, SMB2_SIGNATURE_SIZE);
> -	sg_mark_end(&sgtable.sgl[sgtable.nents - 1]);
> -	*sgl = sgtable.sgl;
> -	return p;
> -}
> -
>   int
>   smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
>   {
> @@ -4454,172 +4357,6 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
>   	return -EAGAIN;
>   }
>   
> -/*
> - * Encrypt @rqst message. @rqst[0] has the following format:
> - * iov[0]   - transform header (associate data),
> - * iov[1-N] - SMB2 header and pages - data to encrypt.
> - * On success return encrypted data in iov[1-N] and pages, leave iov[0]
> - * untouched.
> - */
> -static int
> -encrypt_message(struct TCP_Server_Info *server, int num_rqst,
> -		struct smb_rqst *rqst, struct crypto_aead *tfm)
> -{
> -	struct smb2_transform_hdr *tr_hdr =
> -		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
> -	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
> -	int rc = 0;
> -	struct scatterlist *sg;
> -	u8 sign[SMB2_SIGNATURE_SIZE] = {};
> -	u8 key[SMB3_ENC_DEC_KEY_SIZE];
> -	struct aead_request *req;
> -	u8 *iv;
> -	DECLARE_CRYPTO_WAIT(wait);
> -	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
> -	void *creq;
> -
> -	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), 1, key);
> -	if (rc) {
> -		cifs_server_dbg(FYI, "%s: Could not get encryption key. sid: 0x%llx\n",
> -				__func__, le64_to_cpu(tr_hdr->SessionId));
> -		return rc;
> -	}
> -
> -	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
> -		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
> -		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
> -	else
> -		rc = crypto_aead_setkey(tfm, key, SMB3_GCM128_CRYPTKEY_SIZE);
> -
> -	if (rc) {
> -		cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n", __func__, rc);
> -		return rc;
> -	}
> -
> -	rc = crypto_aead_setauthsize(tfm, SMB2_SIGNATURE_SIZE);
> -	if (rc) {
> -		cifs_server_dbg(VFS, "%s: Failed to set authsize %d\n", __func__, rc);
> -		return rc;
> -	}
> -
> -	creq = smb2_get_aead_req(tfm, rqst, num_rqst, sign, &iv, &req, &sg);
> -	if (IS_ERR(creq))
> -		return PTR_ERR(creq);
> -
> -	if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
> -	    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
> -		memcpy(iv, (char *)tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
> -	else {
> -		iv[0] = 3;
> -		memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
> -	}
> -
> -	aead_request_set_tfm(req, tfm);
> -	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
> -	aead_request_set_ad(req, assoc_data_len);
> -
> -	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -				  crypto_req_done, &wait);
> -
> -	rc = crypto_wait_req(crypto_aead_encrypt(req), &wait);
> -
> -	if (!rc)
> -		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
> -
> -	kfree_sensitive(creq);
> -	return rc;
> -}
> -
> -/*
> - * Copy data from an iterator to the pages in a bvec queue buffer.
> - */
> -static bool cifs_copy_iter_to_bvecq(struct iov_iter *iter, size_t size,
> -				    struct bvecq *buffer)
> -{
> -	for (; buffer; buffer = buffer->next) {
> -		for (int s = 0; s < buffer->nr_slots; s++) {
> -			struct bio_vec *bv = &buffer->bv[s];
> -			size_t part = umin(bv->bv_len, size);
> -
> -			if (copy_page_from_iter(bv->bv_page, bv->bv_offset,
> -						part, iter) != part)
> -				return false;
> -			size -= part;
> -		}
> -	}
> -	return true;
> -}
> -
> -void
> -smb3_free_compound_rqst(int num_rqst, struct smb_rqst *rqst)
> -{
> -	for (int i = 0; i < num_rqst; i++)
> -		bvecq_put(rqst[i].rq_buffer);
> -}
> -
> -/*
> - * This function will initialize new_rq and encrypt the content.
> - * The first entry, new_rq[0], only contains a single iov which contains
> - * a smb2_transform_hdr and is pre-allocated by the caller.
> - * This function then populates new_rq[1+] with the content from olq_rq[0+].
> - *
> - * The end result is an array of smb_rqst structures where the first structure
> - * only contains a single iov for the transform header which we then can pass
> - * to crypt_message().
> - *
> - * new_rq[0].rq_iov[0] :  smb2_transform_hdr pre-allocated by the caller
> - * new_rq[1+].rq_iov[*] == old_rq[0+].rq_iov[*] : SMB2/3 requests
> - */
> -static int
> -smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
> -		       struct smb_rqst *new_rq, struct smb_rqst *old_rq)
> -{
> -	struct smb2_transform_hdr *tr_hdr = new_rq[0].rq_iov[0].iov_base;
> -	unsigned int orig_len = 0;
> -	int rc = -ENOMEM;
> -
> -	for (int i = 1; i < num_rqst; i++) {
> -		struct smb_rqst *old = &old_rq[i - 1];
> -		struct smb_rqst *new = &new_rq[i];
> -		struct bvecq *buffer = NULL;
> -		size_t size = iov_iter_count(&old->rq_iter);
> -
> -		orig_len += smb_rqst_len(server, old);
> -		new->rq_iov = old->rq_iov;
> -		new->rq_nvec = old->rq_nvec;
> -
> -		if (size > 0) {
> -			rc = -ENOMEM;
> -			buffer = bvecq_alloc_buffer(size, GFP_NOFS);
> -			if (!buffer)
> -				goto err_free;
> -
> -			new->rq_buffer = buffer;
> -			iov_iter_bvec_queue(&new->rq_iter, ITER_SOURCE,
> -					    buffer, 0, 0, size);
> -
> -			if (!cifs_copy_iter_to_bvecq(&old->rq_iter, size, buffer)) {
> -				rc = smb_EIO1(smb_eio_trace_tx_copy_iter_to_buf, size);
> -				goto err_free;
> -			}
> -		}
> -	}
> -
> -	/* fill the 1st iov with a transform header */
> -	fill_transform_hdr(tr_hdr, orig_len, old_rq, server->cipher_type);
> -
> -	rc = encrypt_message(server, num_rqst, new_rq, server->secmech.enc);
> -	cifs_dbg(FYI, "Encrypt message returned %d\n", rc);
> -	if (rc)
> -		goto err_free;
> -
> -	return rc;
> -
> -err_free:
> -	smb3_free_compound_rqst(num_rqst - 1, &new_rq[1]);
> -	return rc;
> -}
> -
>   int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
>   				struct dentry *dentry, struct cifs_tcon *tcon,
>   				const char *full_path, umode_t mode, dev_t dev,
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 0b3df644222b..3b4bc946d1bb 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -115,6 +115,10 @@ int smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
>   int smb2_push_mandatory_locks(struct cifsFileInfo *cfile);
>   void smb2_reconnect_server(struct work_struct *work);
>   int smb3_crypto_aead_allocate(struct TCP_Server_Info *server);
> +int smb3_init_transform_rq(struct TCP_Server_Info *server,
> +			   int num_rqst, const struct smb_rqst *rqst,
> +			   struct smb2_transform_hdr *tr_hdr,
> +			   struct iov_iter *iter);
>   unsigned long smb_rqst_len(struct TCP_Server_Info *server,
>   			   struct smb_rqst *rqst);
>   void smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst);
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
> index 1086877e9d84..874956515322 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -886,6 +886,119 @@ static void *smb2_get_aead_req_new(struct crypto_aead *tfm, const struct iov_ite
>   	return p;
>   }
>   
> +/*
> + * Encrypt the message in the buffer described by the iterator.
> + * On success return encrypted data in iov[1-N] and pages, leave iov[0]
> + * untouched.
> + */
> +static int
> +encrypt_message(struct TCP_Server_Info *server,
> +		struct smb2_transform_hdr *tr_hdr,
> +		struct iov_iter *iter, struct crypto_aead *tfm)
> +{
> +	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
> +	int rc = 0;
> +	struct scatterlist *sg;
> +	u8 key[SMB3_ENC_DEC_KEY_SIZE];
> +	struct aead_request *req;
> +	u8 *iv;
> +	DECLARE_CRYPTO_WAIT(wait);
> +	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
> +	void *creq;
> +	size_t sensitive_size;
> +
> +	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), 1, key);
> +	if (rc) {
> +		cifs_server_dbg(FYI, "%s: Could not get encryption key. sid: 0x%llx\n",
> +				__func__, le64_to_cpu(tr_hdr->SessionId));
> +		return rc;
> +	}
> +
> +	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
> +		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
> +		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
> +	else
> +		rc = crypto_aead_setkey(tfm, key, SMB3_GCM128_CRYPTKEY_SIZE);
> +
> +	if (rc) {
> +		cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n", __func__, rc);
> +		return rc;
> +	}
> +
> +	rc = crypto_aead_setauthsize(tfm, SMB2_SIGNATURE_SIZE);
> +	if (rc) {
> +		cifs_server_dbg(VFS, "%s: Failed to set authsize %d\n", __func__, rc);
> +		return rc;
> +	}
> +
> +	creq = smb2_get_aead_req_new(tfm, iter, tr_hdr->Signature, &iv, &req, &sg,
> +				     &sensitive_size);
> +	if (IS_ERR(creq))
> +		return PTR_ERR(creq);
> +
> +	if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
> +	    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
> +		memcpy(iv, (char *)tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
> +	else {
> +		iv[0] = 3;
> +		memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
> +	}
> +
> +	aead_request_set_tfm(req, tfm);
> +	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
> +	aead_request_set_ad(req, assoc_data_len);
> +
> +	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				  crypto_req_done, &wait);
> +
> +	rc = crypto_wait_req(crypto_aead_encrypt(req), &wait);
> +
> +	kvfree_sensitive(creq, sensitive_size);
> +	return rc;
> +}
> +
> +static void
> +fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
> +		   const struct smb_rqst *old_rq, __le16 cipher_type)
> +{
> +	struct smb2_hdr *shdr = (struct smb2_hdr *)old_rq->rq_iov[0].iov_base;
> +
> +	*tr_hdr = (struct smb2_transform_hdr){
> +		.ProtocolId		= SMB2_TRANSFORM_PROTO_NUM,
> +		.OriginalMessageSize	= cpu_to_le32(orig_len),
> +		.Flags			= cpu_to_le16(0x01),
> +		.SessionId		= shdr->SessionId,
> +	};
> +	if ((cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
> +	    (cipher_type == SMB2_ENCRYPTION_AES256_GCM))
> +		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
> +	else
> +		get_random_bytes(&tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
> +}
> +
> +/*
> + * This function encrypts the content in the buffer described by the iterator
> + * and fills in the transform header.  The source request buffers are provided
> + * for reference.
> + */
> +int
> +smb3_init_transform_rq(struct TCP_Server_Info *server,
> +		       int num_rqst, const struct smb_rqst *rqst,
> +		       struct smb2_transform_hdr *tr_hdr,
> +		       struct iov_iter *iter)
> +{
> +	size_t orig_len = iov_iter_count(iter) - sizeof(*tr_hdr);
> +	int rc;
> +
> +	fill_transform_hdr(tr_hdr, orig_len, rqst, server->cipher_type);
> +
> +	iov_iter_advance(iter, offsetof(struct smb2_transform_hdr, Nonce));
> +
> +	rc = encrypt_message(server, tr_hdr, iter, server->secmech.enc);
> +	cifs_dbg(FYI, "Encrypt message returned %d\n", rc);
> +	return rc;
> +}
> +
>   /*
>    * Decrypt the PDU in the iterator.  The PDU begins with the transform header.
>    */
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 563ef488a225..e20fbc10c82e 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -164,36 +164,6 @@ do {									\
>   #define log_rdma_mr(level, fmt, args...) \
>   		log_rdma(level, LOG_RDMA_MR, fmt, ##args)
>   
> -static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
> -				    struct smbdirect_send_batch *batch,
> -				    struct iov_iter *iter,
> -				    u32 remaining_data_length)
> -{
> -	int bytes = 0;
> -
> -	/*
> -	 * smbdirect_connection_send_single_iter() respects the
> -	 * negotiated max_send_size, so we need to
> -	 * loop until the full iter is posted
> -	 */
> -
> -	while (iov_iter_count(iter) > 0) {
> -		int rc;
> -
> -		rc = smbdirect_connection_send_single_iter(sc,
> -							   batch,
> -							   iter,
> -							   0, /* flags */
> -							   remaining_data_length);
> -		if (rc < 0)
> -			return rc;
> -		remaining_data_length -= rc;
> -		bytes += rc;
> -	}
> -
> -	return bytes;
> -}
> -
>   /*
>    * Destroy the transport and related RDMA and memory resources
>    * Need to go through all the pending counters and make sure on one is using
> @@ -405,85 +375,46 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
>   
>   /*
>    * Send data to transport
> - * Each rqst is transported as a SMBDirect payload
> - * rqst: the data to write
>    * return value: 0 if successfully write, otherwise error code
>    */
> -int smbd_send(struct TCP_Server_Info *server,
> -	int num_rqst, struct smb_rqst *rqst_array)
> +int smbd_send(struct TCP_Server_Info *server, struct iov_iter *iter)
>   {

I think this can become a tiny wrapper just calling
smbdirect_connection_send_iter()

>   	struct smbd_connection *info = server->smbd_conn;
>   	struct smbdirect_socket *sc = info->socket;
>   	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(info);
> -	struct smb_rqst *rqst;
> -	struct iov_iter iter;
>   	struct smbdirect_send_batch_storage bstorage;
>   	struct smbdirect_send_batch *batch;
> -	unsigned int remaining_data_length, klen;
> -	int rc, i, rqst_idx;
> -	int error = 0;
> +	size_t size = iov_iter_count(iter);
> +	int rc, error = 0;
>   
>   	if (!smbdirect_connection_is_connected(sc))
>   		return -EAGAIN;
>   
> -	/*
> -	 * Add in the page array if there is one. The caller needs to set
> -	 * rq_tailsz to PAGE_SIZE when the buffer has multiple pages and
> -	 * ends at page boundary
> -	 */
> -	remaining_data_length = 0;
> -	for (i = 0; i < num_rqst; i++)
> -		remaining_data_length += smb_rqst_len(server, &rqst_array[i]);
> -
> -	if (unlikely(remaining_data_length > sp->max_fragmented_send_size)) {
> +	if (unlikely(size > sp->max_fragmented_send_size)) {
>   		/* assertion: payload never exceeds negotiated maximum */
> -		log_write(ERR, "payload size %d > max size %d\n",
> -			remaining_data_length, sp->max_fragmented_send_size);
> +		log_write(ERR, "payload size %zu > max size %d\n",
> +			  size, sp->max_fragmented_send_size);
>   		return -EINVAL;
>   	}
>   
> -	log_write(INFO, "num_rqst=%d total length=%u\n",
> -			num_rqst, remaining_data_length);
> +	log_write(INFO, "size=%zu\n", size);
>   
> -	rqst_idx = 0;
> +	/*
> +	 * smbdirect_connection_send_single_iter() respects the negotiated
> +	 * max_send_size, so we need to loop until the full iter is posted
> +	 */
>   	batch = smbdirect_init_send_batch_storage(&bstorage, false, 0);
> -	do {
> -		rqst = &rqst_array[rqst_idx];
> -
> -		cifs_dbg(FYI, "Sending smb (RDMA): idx=%d smb_len=%lu\n",
> -			 rqst_idx, smb_rqst_len(server, rqst));
> -		for (i = 0; i < rqst->rq_nvec; i++)
> -			dump_smb(rqst->rq_iov[i].iov_base, rqst->rq_iov[i].iov_len);
> -
> -		log_write(INFO, "RDMA-WR[%u] nvec=%d len=%u iter=%zu rqlen=%lu\n",
> -			  rqst_idx, rqst->rq_nvec, remaining_data_length,
> -			  iov_iter_count(&rqst->rq_iter), smb_rqst_len(server, rqst));
> -
> -		/* Send the metadata pages. */
> -		klen = 0;
> -		for (i = 0; i < rqst->rq_nvec; i++)
> -			klen += rqst->rq_iov[i].iov_len;
> -		iov_iter_kvec(&iter, ITER_SOURCE, rqst->rq_iov, rqst->rq_nvec, klen);
> -
> -		rc = smbd_post_send_full_iter(sc, batch, &iter, remaining_data_length);
> +	while (iov_iter_count(iter) > 0) {
> +		rc = smbdirect_connection_send_single_iter(sc,
> +							   batch,
> +							   iter,
> +							   0, /* flags */
> +							   iov_iter_count(iter));
>   		if (rc < 0) {
>   			error = rc;
>   			break;
>   		}
> -		remaining_data_length -= rc;
> -
> -		if (iov_iter_count(&rqst->rq_iter) > 0) {
> -			/* And then the data pages if there are any */
> -			rc = smbd_post_send_full_iter(sc, batch, &rqst->rq_iter,
> -						      remaining_data_length);
> -			if (rc < 0) {
> -				error = rc;
> -				break;
> -			}
> -			remaining_data_length -= rc;
> -		}
> -
> -	} while (++rqst_idx < num_rqst);
> +	}
>   
>   	rc = smbdirect_connection_send_batch_flush(sc, batch, true);
>   	if (unlikely(!rc && error))
> diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
> index be205ec02077..a5c17e796ff9 100644
> --- a/fs/smb/client/smbdirect.h
> +++ b/fs/smb/client/smbdirect.h
> @@ -40,8 +40,7 @@ void smbd_destroy(struct TCP_Server_Info *server);
>   
>   /* Interface for carrying upper layer I/O through send/recv */
>   int smbd_recv(struct smbd_connection *info, struct msghdr *msg);
> -int smbd_send(struct TCP_Server_Info *server,
> -	int num_rqst, struct smb_rqst *rqst);
> +int smbd_send(struct TCP_Server_Info *server, struct iov_iter *iter);
>   
>   /* Interfaces to register and deregister MR for RDMA read/write */
>   struct smbdirect_mr_io *smbd_register_mr(
> @@ -61,7 +60,7 @@ static inline void *smbd_get_connection(
>   static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1; }
>   static inline void smbd_destroy(struct TCP_Server_Info *server) {}
>   static inline int smbd_recv(struct smbd_connection *info, struct msghdr *msg) {return -1; }
> -static inline int smbd_send(struct TCP_Server_Info *server, int num_rqst, struct smb_rqst *rqst) {return -1; }
> +static inline int smbd_send(struct TCP_Server_Info *server, struct iov_iter *iter) {return -1; }
>   #endif
>   
>   #endif
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 3f4d1a52b45c..3ead26f76112 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -23,6 +23,9 @@
>   #include <linux/sched/signal.h>
>   #include <linux/task_io_accounting_ops.h>
>   #include <linux/task_work.h>
> +#include <linux/iov_iter.h>
> +#include "rfc1002pdu.h"
> +#include "cifspdu.h"
>   #include "cifsglob.h"
>   #include "cifsproto.h"
>   #include "cifs_debug.h"
> @@ -252,51 +255,100 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
>   	return 0;
>   }
>   
> -unsigned long
> -smb_rqst_len(struct TCP_Server_Info *server, struct smb_rqst *rqst)
> +/*
> + * smb_sendmsg - send a buffer to the socket
> + * @server:	Server to send the data to
> + * @iter:	The data to send (not advanced)
> + * @sent:	The amount of data sent
> + *
> + * Our basic "send data to server" function. Should be called with srv_mutex
> + * held. The caller is responsible for handling the results.
> + */
> +static int smb_sendmsg(struct TCP_Server_Info *server, const struct iov_iter *iter,
> +		       size_t *sent)
>   {
> -	unsigned int i;
> -	struct kvec *iov;
> -	int nvec;
> -	unsigned long buflen = 0;
> -
> -	if (!is_smb1(server) && rqst->rq_nvec >= 2 &&
> -	    rqst->rq_iov[0].iov_len == 4) {
> -		iov = &rqst->rq_iov[1];
> -		nvec = rqst->rq_nvec - 1;
> -	} else {
> -		iov = rqst->rq_iov;
> -		nvec = rqst->rq_nvec;
> -	}
> +	struct socket *ssocket = server->ssocket;
> +	struct msghdr msg = {
> +		/*
> +		 * MSG_SPLICE_PAGES causes tcp_sendmsg() to splice in the pages
> +		 * in the iterator rather than copying from them.
> +		 */
> +		.msg_flags	= MSG_NOSIGNAL | MSG_SPLICE_PAGES,
> +		.msg_iter	= *iter,
> +	};
> +	int retries = 0;
> +	int rc = 0;
> +
> +	*sent = 0;
> +	if (server->noblocksnd)
> +		msg.msg_flags = MSG_DONTWAIT;
> +
> +	while (msg_data_left(&msg)) {
> +		/*
> +		 * If blocking send, we try 3 times, since each can block for 5
> +		 * seconds. For nonblocking we have to try more but wait
> +		 * increasing amounts of time allowing time for socket to
> +		 * clear.  The overall time we wait in either case to send on
> +		 * the socket is about 15 seconds.  Similarly we wait for 15
> +		 * seconds for a response from the server in SendReceive[2] for
> +		 * the server to send a response back for most types of
> +		 * requests (except SMB Write past end of file which can be
> +		 * slow, and blocking lock operations). NFS waits slightly
> +		 * longer than CIFS, but this can make it take longer for
> +		 * nonresponsive servers to be detected and 15 seconds is more
> +		 * than enough time for modern networks to send a packet.  In
> +		 * most cases if we fail to send after the retries we will kill
> +		 * the socket and reconnect which may clear the network
> +		 * problem.
> +		 */
> +		rc = sock_sendmsg(ssocket, &msg);
> +		if (rc == -EAGAIN) {
> +			retries++;
> +			if (retries >= 14 ||
> +			    (!server->noblocksnd && (retries > 2))) {
> +				cifs_server_dbg(VFS, "sends on sock %p stuck for 15 seconds\n",
> +					 ssocket);
> +				return -EAGAIN;
> +			}
> +			msleep(1 << retries);
> +			continue;
> +		}
> +
> +		if (rc < 0)
> +			return rc;
> +
> +		if (rc == 0) {
> +			/* should never happen, letting socket clear before
> +			   retrying is our only obvious option here */
> +			cifs_server_dbg(VFS, "tcp sent no data\n");
> +			msleep(500);
> +			continue;
> +		}
>   
> -	/* total up iov array first */
> -	for (i = 0; i < nvec; i++)
> -		buflen += iov[i].iov_len;
> +		*sent += rc;
>   
> -	buflen += iov_iter_count(&rqst->rq_iter);
> -	return buflen;
> +		/* send was at least partially successful */
> +		retries = 0; /* in case we get ENOSPC on the next send */
> +	}
> +	return 0;
>   }
>   
> -int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
> -		    struct smb_rqst *rqst)
> +int
> +__smb_send_rqst(struct TCP_Server_Info *server, struct iov_iter *iter)
>   {
> -	int rc;
> -	struct kvec *iov;
> -	int n_vec;
> -	unsigned int send_length = 0;
> -	unsigned int i, j;
> -	sigset_t mask, oldmask;
> -	size_t total_len = 0, sent, size;
>   	struct socket *ssocket = server->ssocket;
> -	struct msghdr smb_msg = {};
> -	__be32 rfc1002_marker;
> +	sigset_t mask, oldmask;
> +	size_t total_to_send = iov_iter_count(iter), sent = 0;
> +	int rc;
>   
>   	cifs_in_send_inc(server);
>   	if (cifs_rdma_enabled(server)) {
>   		/* return -EAGAIN when connecting or reconnecting */
>   		rc = -EAGAIN;
> -		if (server->smbd_conn)
> -			rc = smbd_send(server, num_rqst, rqst);
> +		if (server->smbd_conn) {
> +			iov_iter_advance(iter, 4);

This is not needed if smbd_send() just calls
smbdirect_connection_send_iter()

> +			rc = smbd_send(server, iter);
> +		}
>   		goto smbd_done;
>   	}
>   
> @@ -314,10 +366,6 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
>   	/* cork the socket */
>   	tcp_sock_set_cork(ssocket->sk, true);
>   
> -	for (j = 0; j < num_rqst; j++)
> -		send_length += smb_rqst_len(server, &rqst[j]);
> -	rfc1002_marker = cpu_to_be32(send_length);
> -
>   	/*
>   	 * We should not allow signals to interrupt the network send because
>   	 * any partial send will cause session reconnects thus increasing
> @@ -328,83 +376,44 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
>   	sigfillset(&mask);
>   	sigprocmask(SIG_BLOCK, &mask, &oldmask);
>   
> -	/* Generate a rfc1002 marker */
> -	{
> -		struct kvec hiov = {
> -			.iov_base = &rfc1002_marker,
> -			.iov_len  = 4
> -		};
> -		iov_iter_kvec(&smb_msg.msg_iter, ITER_SOURCE, &hiov, 1, 4);
> -		rc = smb_send_kvec(server, &smb_msg, &sent);
> -		if (rc < 0)
> -			goto unmask;
> -
> -		total_len += sent;
> -		send_length += 4;
> -	}
> -
> -	cifs_dbg(FYI, "Sending smb: smb_len=%u\n", send_length);
> -
> -	for (j = 0; j < num_rqst; j++) {
> -		iov = rqst[j].rq_iov;
> -		n_vec = rqst[j].rq_nvec;
> -
> -		size = 0;
> -		for (i = 0; i < n_vec; i++) {
> -			dump_smb(iov[i].iov_base, iov[i].iov_len);
> -			size += iov[i].iov_len;
> -		}
> -
> -		iov_iter_kvec(&smb_msg.msg_iter, ITER_SOURCE, iov, n_vec, size);
> +	cifs_dbg(FYI, "Sending smb: smb_len=%zu\n", iov_iter_count(iter));
> +	rc = smb_sendmsg(server, iter, &sent);
>   
> -		rc = smb_send_kvec(server, &smb_msg, &sent);
> -		if (rc < 0)
> -			goto unmask;
> -
> -		total_len += sent;
> -
> -		if (iov_iter_count(&rqst[j].rq_iter) > 0) {
> -			smb_msg.msg_iter = rqst[j].rq_iter;
> -			rc = smb_send_kvec(server, &smb_msg, &sent);
> -			if (rc < 0)
> -				break;
> -			total_len += sent;
> -		}
> -	}
> -
> -unmask:
>   	sigprocmask(SIG_SETMASK, &oldmask, NULL);
>   
> -	/*
> -	 * If signal is pending but we have already sent the whole packet to
> -	 * the server we need to return success status to allow a corresponding
> -	 * mid entry to be kept in the pending requests queue thus allowing
> -	 * to handle responses from the server by the client.
> -	 *
> -	 * If only part of the packet has been sent there is no need to hide
> -	 * interrupt because the session will be reconnected anyway, so there
> -	 * won't be any response from the server to handle.
> -	 */
> -
> -	if (signal_pending(current) && (total_len != send_length)) {
> -		cifs_dbg(FYI, "signal is pending after attempt to send\n");
> -		rc = -ERESTARTSYS;
> -	}
> -
>   	/* uncork it */
>   	tcp_sock_set_cork(ssocket->sk, false);
>   
> -	if ((total_len > 0) && (total_len != send_length)) {
> -		cifs_dbg(FYI, "partial send (wanted=%u sent=%zu): terminating session\n",
> -			 send_length, total_len);
> +	if (sent > 0) {
> +		/*
> +		 * If signal is pending but we have already sent the whole
> +		 * packet to the server we need to return success status to
> +		 * allow a corresponding mid entry to be kept in the pending
> +		 * requests queue thus allowing to handle responses from the
> +		 * server by the client.
> +		 *
> +		 * If only part of the packet has been sent there is no need to
> +		 * hide interrupt because the session will be reconnected
> +		 * anyway, so there won't be any response from the server to
> +		 * handle.
> +		 */
> +		if (signal_pending(current)) {
> +			cifs_dbg(FYI, "signal is pending after attempt to send\n");
> +			rc = -ERESTARTSYS;
> +		}
> +
>   		/*
>   		 * If we have only sent part of an SMB then the next SMB could
>   		 * be taken as the remainder of this one. We need to kill the
>   		 * socket so the server throws away the partial SMB
>   		 */
> -		cifs_signal_cifsd_for_reconnect(server, false);
> -		trace_smb3_partial_send_reconnect(server->current_mid,
> -						  server->conn_id, server->hostname);
> +		if (sent != total_to_send) {
> +			cifs_dbg(FYI, "partial send (wanted=%zu sent=%zu): terminating session\n",
> +				 total_to_send, sent);
> +			cifs_signal_cifsd_for_reconnect(server, false);
> +			trace_smb3_partial_send_reconnect(server->current_mid,
> +							  server->conn_id, server->hostname);
> +		}
>   	}
>   smbd_done:
>   	/*
> @@ -424,41 +433,167 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
>   	return rc;
>   }
>   
> +static size_t smb3_copy_data_iter(void *iter_from, size_t progress, size_t len,
> +				  void *priv, void *priv2)
> +{
> +	struct iov_iter *iter = priv;
> +	return copy_to_iter(iter_from, len, iter) == len ? 0 : len;
> +}
> +
> +/*
> + * Copy the data into a buffer that we can use for encryption in place and also
> + * pass to sendmsg() with MSG_SPLICE_PAGES.  This avoids a lot of copies in TCP
> + * at the expense of doing it upfront here.  A spare slot is left in the bvec
> + * queue at the front for the header(s).
> + *
> + * TODO: In future, the buffers should be allocated by the marshalling code.
> + */
> +static int smb_copy_data_into_buffer(struct TCP_Server_Info *server,
> +				     int num_rqst, struct smb_rqst *rqst,
> +				     struct iov_iter *iter, struct bvecq **_bq)
> +{
> +	struct bvecq *bq;
> +	size_t total_len = 0, offset = 0;
> +
> +	for (int i = 0; i < num_rqst; i++) {
> +		struct smb_rqst *req = &rqst[i];
> +		size_t size = iov_iter_count(&req->rq_iter);
> +
> +		for (int j = 0; j < req->rq_nvec; j++)
> +			size += req->rq_iov[j].iov_len;
> +		total_len = ALIGN8(total_len);
> +		total_len += size;
> +	}
> +
> +	bq = bvecq_alloc_buffer(total_len, GFP_NOFS);
> +	if (!bq)
> +		return -ENOMEM;
> +
> +	iov_iter_bvec_queue(iter, ITER_DEST, bq, 1, 0, total_len);
> +
> +	for (int i = 0; i < num_rqst; i++) {
> +		struct smb_rqst *req = &rqst[i];
> +		size_t size = iov_iter_count(&req->rq_iter);
> +
> +		if (offset & 7) {
> +			unsigned int tmp = offset;
> +			offset = ALIGN8(offset);
> +			iov_iter_zero(offset - tmp, iter);
> +		}
> +
> +		for (int j = 0; j < req->rq_nvec; j++) {
> +			size_t len = req->rq_iov[j].iov_len;
> +			if (copy_to_iter(req->rq_iov[j].iov_base, len, iter) != len)
> +				goto error;
> +			offset += len;
> +		}
> +
> +		if (iterate_and_advance_kernel(&req->rq_iter,
> +					       size, iter, NULL,
> +					       smb3_copy_data_iter) != size)
> +			goto error;
> +
> +		offset += size;
> +	}
> +
> +	if (WARN_ONCE(offset != total_len,
> +		      "offset=%zx total_len=%zx\n", offset, total_len)) {
> +		goto error;
> +	}
> +	iov_iter_bvec_queue(iter, ITER_DEST, bq, 1, 0, total_len);
> +	*_bq = bq;
> +	return 0;
> +error:
> +	bvecq_put(bq);
> +	*_bq = NULL;
> +	return -EIO;
> +}
> +
>   static int
>   smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
>   	      struct smb_rqst *rqst, int flags)
>   {
> -	struct smb2_transform_hdr tr_hdr;
> -	struct smb_rqst new_rqst[MAX_COMPOUND] = {};
> -	struct kvec iov = {
> -		.iov_base = &tr_hdr,
> -		.iov_len = sizeof(tr_hdr),
> -	};
> +	struct iov_iter iter;
> +	struct bvecq *bq;
> +	u32 content_len;
>   	int rc;
>   
> -	if (flags & CIFS_COMPRESS_REQ)
> -		return smb_compress(server, &rqst[0], __smb_send_rqst);
> -
> -	if (!(flags & CIFS_TRANSFORM_REQ))
> -		return __smb_send_rqst(server, num_rqst, rqst);
> -
> -	if (WARN_ON_ONCE(num_rqst > MAX_COMPOUND - 1))
> -		return smb_EIO1(smb_eio_trace_tx_max_compound, num_rqst);
> -
> -	if (!server->ops->init_transform_rq) {
> +	if ((flags & CIFS_TRANSFORM_REQ) &&
> +	    !server->ops->init_transform_rq) {
>   		cifs_server_dbg(VFS, "Encryption requested but transform callback is missing\n");
>   		return smb_EIO(smb_eio_trace_tx_need_transform);
>   	}
>   
> -	new_rqst[0].rq_iov = &iov;
> -	new_rqst[0].rq_nvec = 1;
> +	rc = smb_copy_data_into_buffer(server, num_rqst, rqst, &iter, &bq);
> +	if (rc)
> +		return rc;
> +	content_len = iov_iter_count(&iter);
> +
> +	{
> +		struct smb2_transform_hdr *tr_hdr;
> +		unsigned int hdr_len = 4, troff = 0;
> +		__le32 *rfc1002;
> +		void *hdr_blob;
> +
> +		if (flags & CIFS_TRANSFORM_REQ) {
> +			troff = hdr_len;
> +			hdr_len += sizeof(*tr_hdr);
> +		}
> +
> +		/* TODO: Allocate netmem here */
> +		rc = -ENOMEM;
> +		hdr_blob = (void *)__get_free_page(GFP_NOFS);
> +		if (!hdr_blob)
> +			goto error;
> +		bvec_set_virt(&bq->bv[0], hdr_blob, hdr_len);
> +
> +		if (flags & CIFS_COMPRESS_REQ) {
> +			struct smb2_write_req *whdr = bvec_virt(&bq->bv[1]);
> +			size_t doff = le16_to_cpu(whdr->DataOffset);
> +
> +			iov_iter_bvec_queue(&iter, ITER_SOURCE, bq, 1, doff,
> +					    content_len - doff);
> +
> +			if (is_compressible(&iter)) {
> +				iov_iter_bvec_queue(&iter, ITER_SOURCE, bq, 1, 0,
> +						    content_len);
> +
> +				rc = smb_compress(server, &iter, &bq);
> +				if (rc > 0) {
> +					content_len = rc;
> +				} else if (rc == -EMSGSIZE) {
> +					/* Fall back to uncompressed. */
> +				} else {
> +					if (rc == 0)
> +						rc = -EIO;
> +					goto error;
> +				}
> +			}
> +		}
> +
> +		if (flags & CIFS_TRANSFORM_REQ) {
> +			iov_iter_bvec_queue(&iter, ITER_SOURCE, bq, 0, 0,
> +					    hdr_len + content_len);
> +			iov_iter_advance(&iter, troff);
> +			tr_hdr = hdr_blob + troff;
> +
> +			rc = server->ops->init_transform_rq(server, num_rqst, rqst, tr_hdr, &iter);
> +			if (rc)
> +				goto error;
> +			content_len += sizeof(*tr_hdr);
> +		} else {
> +			bvec_set_virt(&bq->bv[0], hdr_blob, hdr_len);
> +		}
> +
> +		/* Set the RFC1002 header at the front. */
> +		rfc1002 = hdr_blob;
> +		*rfc1002 = cpu_to_be32(RFC1002_SESSION_MESSAGE << 24 | content_len);
>   
> -	rc = server->ops->init_transform_rq(server, num_rqst + 1,
> -					    new_rqst, rqst);
> -	if (!rc) {
> -		rc = __smb_send_rqst(server, num_rqst + 1, new_rqst);
> -		smb3_free_compound_rqst(num_rqst, &new_rqst[1]);
> +		iov_iter_bvec_queue(&iter, ITER_SOURCE, bq, 0, 0, 4 + content_len);
>   	}
> +	rc = __smb_send_rqst(server, &iter);
> +error:
> +	bvecq_put(bq);
>   	return rc;
>   }
>   
> 

