Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795711634;
	b=Ota5FiWRc9sGU46KYjHt1Hz1ggJ/9O/F4J0VLT59oWkz9xw5Pwqsoa+sdxTWikD6ZjlW
	 eSJFcgd4D3tMV7jf1VcTEBHTM+u/v2vCo+1Up/1BW+RPVEEYg3giEbtDm1FNtvlbAs16E
	 A+BW3QAZxSYSxw1Y/p1/cGIeZTCmZcrEAv+2VqXqzv5Va4DhiLgBTyZLTmmGm8amVd1kn
	 Ai6Q7OSoCcWHXEfxWiONge1w9dbzVUyDwKlriGkq7moAHXcQuJR73iXwTHES7aPBz1Z0l
	 nfR4Z7/ZL5FhaToaFXiRx+1JZ6orJYuTBuWPI1lG57QqbOdO9iYPi0RYEH/UUy1iDlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795711634;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=31/KaKCibvfmke/ZeXSDIVJkuF/p3zNHrOMuDiVyYJA=;
	b=43CjCU3ScgAr2AeFFcxjIPlIkMoJGOJCAgZ/dwDHbUE3UVjkFGVT8Ajt6BE7n9dLz7Vv
	 L2gGkwL62cRCprvoqEFhhh1UQtLva3ew84gVuhphZXo4fmScPxvVJSKw7CPzJAnzkd9XW
	 xEYp8TaKYorIC8qcLLQs7r4ykQmrR39ir2gwdk/1/B07KOEEKuI24mZ1KO13ip/cl3PKC
	 9y0fgghO+jhNLpTJu6xPinfF4g14Dx4v6rJcY8CTked54O0HAtuVpE47Y/v7ZRR25ypIK
	 +G0yeIuDAoAPI6hoFebXdBaQ8qBVrXcoRH1F2M2P2tqTrEakaEwLAXtyhfifxzkgjAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=OpaJpa5y;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05B8606A321
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 16:47:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E05B8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key, unprotected) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=OpaJpa5y
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=31/KaKCibvfmke/ZeXSDIVJkuF/p3zNHrOMuDiVyYJA=; b=OpaJpa5yuk+gnxl4+T98leO5Xv
	+5fkwERCdJMV2xXCDaf39VwbnVFnTB7aPFtknpsLwfIHyC1/zQvW0le5b2OfWUulSgN9pDttBBmZC
	BkY/gOtJejD6sDjV6GLgogslwI9/6iDpN1wZ/1d9dB7PGsfaY9v47xAWOP/wCSo6iMzt5kNbMc0Dg
	Qw+H6dLpVYzFZxTOoRcVmWB9NbiZcSAUP0cMcjB5jDbfw7iRbpIln/+RKUjp9nT1vgld3VzeV8RJm
	742nWOOu4MVcSbRAxTRdEUGQ5euJcgcytgKkvAPXR1JfjJLptqE2CA+VR9piWNqGGGeuTcVKIKB4H
	Xkwg7EfnmU7eN/rYIgZZVVpbh+ESkQ4pDuyLtjn+IiUVSkaT/p3IbXeZFYSg/vCgMpQmEoc5netf/
	dZ6ypqr1cyU3b59QR4ZdbDwTWnxZIUZ/VfhHFGrgPI1HnXPIXX1oDKKmyUPpArLFgXW00BiejSUbs
	Kkq4u+k/fEfGTh+l7EBiCI/+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWcci-000000018y6-0zBX;
	Thu, 26 Nov 2026 16:47:04 +0000
Message-ID: <eee2f3e6-029c-46d0-9481-78f175b1f5a1@samba.org>
Date: Thu, 26 Nov 2026 17:47:03 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] smb: client: protect server->smbd_conn with RCU and
 refcounting
To: Qican Ma <goonsomeway@gmail.com>, linkinjeon@kernel.org, pc@manguebit.org
Cc: tom@talpey.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 bharathsm@microsoft.com, linux-cifs@vger.kernel.org
References: <179570959875.92741.4311009098248753929@gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <179570959875.92741.4311009098248753929@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Qican,

thanks for looking into this! I already have fixes for this
(and the related zero-limit/NULL dereference in
smb3_negotiate_[rw]size()) in my queue, tested on real RDMA
hardware, which avoid waiting for references in smbd_destroy(),
which is called with cifs_server_lock() held:

smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()
https://git.samba.org/?p=metze/linux/wip.git;a=commit;h=bea8f6615fc2

smb: client: return the real error from smbd_get_connection()
https://git.samba.org/?p=metze/linux/wip.git;a=commit;h=a4b0de969d81

smb: client: change server->smbd_conn only under server->srv_lock
https://git.samba.org/?p=metze/linux/wip.git;a=commit;h=4b01286ea773

smb: client: pass server to smbd_get_parameters()
https://git.samba.org/?p=metze/linux/wip.git;a=commit;h=da5eb9054218

smb: client: pass server to smbd_register_mr()
https://git.samba.org/?p=metze/linux/wip.git;a=commit;h=eccd137e81d9

smb: client: don't use server->smbd_conn without a reference or lock
https://git.samba.org/?p=metze/linux/wip.git;a=commit;h=8c5a4aa267ee

smb: client: don't use zero RDMA limits without a connection
https://git.samba.org/?p=metze/linux/wip.git;a=commit;h=c7a1d04a3c14


I already tested these on top of v7.3-rc6 and wanted to retest on top
of v7.4-rcX before posting them.

I'll post them in the next days, please hold off on this patch
until then.

Thanks
metze

Am 26.11.26 um 17:13 schrieb Qican Ma:
> Several paths check and dereference server->smbd_conn without holding a
> lock that serializes against smbd_destroy() during reconnect or teardown
> (including smb2_new_read_req(), smb2_async_writev(), smbd_send(),
> cifs_readv_from_socket(), cifs_prepare_read/write(),
> smb3_negotiate_r/wsize(), and smbd_debug_proc_show()). Meanwhile
> smbd_destroy() releases the underlying socket and calls kfree(info)
> before clearing server->smbd_conn = NULL, exposing a use-after-free
> window to concurrent readers.
> 
> Annotate server->smbd_conn with __rcu and add a refcount and completion
> to struct smbd_connection. Readers acquire a short-lived reference via
> smbd_conn_get() under rcu_read_lock() and drop it with smbd_conn_put().
> In smbd_destroy(), clear server->smbd_conn first, shut down the socket to
> wake any blocked callers, wait for active references and an RCU grace
> period to complete, and then release the socket and free info in process
> context. Pass server directly to smbd_recv() and smbd_register_mr() so
> connection pinning stays encapsulated inside smbdirect.c.
> 
> In the cifs_prepare_read/write() hot paths, which only need the
> negotiated max_frmr_depth value, skip the refcount round trip entirely:
> guard on server->rdma and read the parameters under rcu_read_lock(),
> which is sufficient because smbd_destroy() waits for synchronize_rcu()
> before releasing the socket and freeing the connection.
> 
> Found with an LLM-assisted code review tool and verified by inspection on
> v7.4-rc4 (b6a9fa34ce4). Build-tested only; no RDMA-capable SMB server was
> available for runtime testing.
> 
> Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qican Ma <goonsomeway@gmail.com>
> ---
> v3: cifs_prepare_read/write() no longer bounce conn->refcount on every
>      I/O subrequest just to read max_frmr_depth; guard on server->rdma
>      and read the parameters under rcu_read_lock() instead, per sashiko's
>      review on v2.
> v2: resend via direct SMTP without line-wrapping corruption in the diff.
> 
>   fs/smb/client/cifsglob.h  |   2 +-
>   fs/smb/client/connect.c   |  11 ++--
>   fs/smb/client/file.c      |  35 +++++++----
>   fs/smb/client/smb2ops.c   |  72 ++++++++++++----------
>   fs/smb/client/smb2pdu.c   |   6 +-
>   fs/smb/client/smbdirect.c | 111 +++++++++++++++++++++++++----------
>   fs/smb/client/smbdirect.h |  16 +++--
>   fs/smb/client/transport.c |   4 +-
>   8 files changed, 172 insertions(+), 85 deletions(-)
> 
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 4e16347886ed..c0f75f756de0 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -760,7 +760,7 @@ struct TCP_Server_Info {
>   	/* use SMBD connection instead of socket */
>   	bool	rdma;
>   	/* point to the SMBD connection if RDMA is used instead of socket */
> -	struct smbd_connection *smbd_conn;
> +	struct smbd_connection __rcu *smbd_conn;
>   	struct delayed_work	echo; /* echo ping workqueue job */
>   	char	*smallbuf;	/* pointer to current "small" buffer */
>   	char	*bigbuf;	/* pointer to current "big" buffer */
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 750b5bb72dc7..03072d7a790a 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -774,8 +774,8 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
>   
>   		if (server_unresponsive(server))
>   			return -ECONNABORTED;
> -		if (cifs_rdma_enabled(server) && server->smbd_conn)
> -			length = smbd_recv(server->smbd_conn, smb_msg);
> +		if (cifs_rdma_enabled(server))
> +			length = smbd_recv(server, smb_msg);
>   		else
>   			length = sock_recvmsg(server->ssocket, smb_msg, 0);
>   
> @@ -1888,9 +1888,10 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>   		rc = -ENOENT;
>   		goto out_err_crypto_release;
>   #endif
> -		tcp_ses->smbd_conn = smbd_get_connection(
> -			tcp_ses, (struct sockaddr *)&ctx->dstaddr);
> -		if (tcp_ses->smbd_conn) {
> +		rcu_assign_pointer(tcp_ses->smbd_conn,
> +				   smbd_get_connection(tcp_ses,
> +						       (struct sockaddr *)&ctx->dstaddr));
> +		if (rcu_access_pointer(tcp_ses->smbd_conn)) {
>   			cifs_dbg(VFS, "RDMA transport established\n");
>   			rc = 0;
>   			goto smbd_connected;
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index d272320436b3..5d3cbaeeb0a0 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -391,11 +391,21 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
>   			      cifs_trace_rw_credits_write_prepare);
>   
>   #ifdef CONFIG_CIFS_SMB_DIRECT
> -	if (server->smbd_conn) {
> -		const struct smbdirect_socket_parameters *sp =
> -			smbd_get_parameters(server->smbd_conn);
> -
> -		stream->sreq_max_segs = sp->max_frmr_depth;
> +	if (server->rdma) {
> +		struct smbd_connection *conn;
> +
> +		/* A plain rcu read is enough here: smbd_destroy() clears
> +		 * server->smbd_conn and then waits for synchronize_rcu()
> +		 * before releasing the socket and freeing the connection,
> +		 * so the parameters memory stays valid for the read-side
> +		 * critical section.
> +		 */
> +		rcu_read_lock();
> +		conn = rcu_dereference(server->smbd_conn);
> +		if (conn)
> +			stream->sreq_max_segs =
> +				smbd_get_parameters(conn)->max_frmr_depth;
> +		rcu_read_unlock();
>   	}
>   #endif
>   }
> @@ -610,11 +620,16 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
>   			      cifs_trace_rw_credits_read_submit);
>   
>   #ifdef CONFIG_CIFS_SMB_DIRECT
> -	if (server->smbd_conn) {
> -		const struct smbdirect_socket_parameters *sp =
> -			smbd_get_parameters(server->smbd_conn);
> -
> -		rreq->io_streams[0].sreq_max_segs = sp->max_frmr_depth;
> +	if (server->rdma) {
> +		struct smbd_connection *conn;
> +
> +		/* See cifs_prepare_write() for why a plain rcu read is safe. */
> +		rcu_read_lock();
> +		conn = rcu_dereference(server->smbd_conn);
> +		if (conn)
> +			rreq->io_streams[0].sreq_max_segs =
> +				smbd_get_parameters(conn)->max_frmr_depth;
> +		rcu_read_unlock();
>   	}
>   #endif
>   	return 0;
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 298f549bd7ed..1e07557a42de 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -520,22 +520,26 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
>   	wsize = min_t(unsigned int, wsize, server->max_write);
>   #ifdef CONFIG_CIFS_SMB_DIRECT
>   	if (server->rdma) {
> -		const struct smbdirect_socket_parameters *sp =
> -			smbd_get_parameters(server->smbd_conn);
> -
> -		if (server->sign)
> -			/*
> -			 * Account for SMB2 data transfer packet header and
> -			 * possible encryption header
> -			 */
> -			wsize = min_t(unsigned int,
> -				wsize,
> -				sp->max_fragmented_send_size -
> -					SMB2_READWRITE_PDU_HEADER_SIZE -
> -					sizeof(struct smb2_transform_hdr));
> -		else
> -			wsize = min_t(unsigned int,
> -				wsize, sp->max_read_write_size);
> +		struct smbd_connection *conn = smbd_conn_get(server);
> +
> +		if (conn) {
> +			const struct smbdirect_socket_parameters *sp =
> +				smbd_get_parameters(conn);
> +
> +			if (server->sign)
> +				/*
> +				 * Account for SMB2 data transfer packet header and
> +				 * possible encryption header
> +				 */
> +				wsize = min_t(unsigned int, wsize,
> +					      sp->max_fragmented_send_size -
> +					      SMB2_READWRITE_PDU_HEADER_SIZE -
> +					      sizeof(struct smb2_transform_hdr));
> +			else
> +				wsize = min_t(unsigned int, wsize,
> +					      sp->max_read_write_size);
> +			smbd_conn_put(conn);
> +		}
>   	}
>   #endif
>   	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
> @@ -571,22 +575,26 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
>   	rsize = min_t(unsigned int, rsize, server->max_read);
>   #ifdef CONFIG_CIFS_SMB_DIRECT
>   	if (server->rdma) {
> -		const struct smbdirect_socket_parameters *sp =
> -			smbd_get_parameters(server->smbd_conn);
> -
> -		if (server->sign)
> -			/*
> -			 * Account for SMB2 data transfer packet header and
> -			 * possible encryption header
> -			 */
> -			rsize = min_t(unsigned int,
> -				rsize,
> -				sp->max_fragmented_recv_size -
> -					SMB2_READWRITE_PDU_HEADER_SIZE -
> -					sizeof(struct smb2_transform_hdr));
> -		else
> -			rsize = min_t(unsigned int,
> -				rsize, sp->max_read_write_size);
> +		struct smbd_connection *conn = smbd_conn_get(server);
> +
> +		if (conn) {
> +			const struct smbdirect_socket_parameters *sp =
> +				smbd_get_parameters(conn);
> +
> +			if (server->sign)
> +				/*
> +				 * Account for SMB2 data transfer packet header and
> +				 * possible encryption header
> +				 */
> +				rsize = min_t(unsigned int, rsize,
> +					      sp->max_fragmented_recv_size -
> +					      SMB2_READWRITE_PDU_HEADER_SIZE -
> +					      sizeof(struct smb2_transform_hdr));
> +			else
> +				rsize = min_t(unsigned int, rsize,
> +					      sp->max_read_write_size);
> +			smbd_conn_put(conn);
> +		}
>   	}
>   #endif
>   
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 7b7d25364e20..d407ec7c3b74 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -4651,7 +4651,7 @@ static inline bool smb3_use_rdma_offload(struct cifs_io_parms *io_parms)
>   		return false;
>   
>   	/* we can only offload on an rdma connection */
> -	if (!server->rdma || !server->smbd_conn)
> +	if (!server->rdma || !rcu_access_pointer(server->smbd_conn))
>   		return false;
>   
>   	/* we don't support signed offload yet */
> @@ -4721,7 +4721,7 @@ int smb2_new_read_req(void **buf, unsigned int *total_len,
>   		struct smbdirect_buffer_descriptor_v1 *v1;
>   		bool need_invalidate = server->dialect == SMB30_PROT_ID;
>   
> -		rdata->mr = smbd_register_mr(server->smbd_conn, &rdata->subreq.io_iter,
> +		rdata->mr = smbd_register_mr(server, &rdata->subreq.io_iter,
>   					     true, need_invalidate);
>   		if (!rdata->mr) {
>   			rc = -EAGAIN;
> @@ -5362,7 +5362,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
>   		struct smbdirect_buffer_descriptor_v1 *v1;
>   		bool need_invalidate = server->dialect == SMB30_PROT_ID;
>   
> -		wdata->mr = smbd_register_mr(server->smbd_conn, &wdata->subreq.io_iter,
> +		wdata->mr = smbd_register_mr(server, &wdata->subreq.io_iter,
>   					     false, need_invalidate);
>   		if (!wdata->mr) {
>   			rc = -EAGAIN;
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 563ef488a225..936988bad5db 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -194,6 +194,25 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
>   	return bytes;
>   }
>   
> +struct smbd_connection *smbd_conn_get(struct TCP_Server_Info *server)
> +{
> +	struct smbd_connection *info;
> +
> +	rcu_read_lock();
> +	info = rcu_dereference(server->smbd_conn);
> +	if (info && !refcount_inc_not_zero(&info->refcount))
> +		info = NULL;
> +	rcu_read_unlock();
> +
> +	return info;
> +}
> +
> +void smbd_conn_put(struct smbd_connection *info)
> +{
> +	if (info && refcount_dec_and_test(&info->refcount))
> +		complete(&info->destroy_done);
> +}
> +
>   /*
>    * Destroy the transport and related RDMA and memory resources
>    * Need to go through all the pending counters and make sure on one is using
> @@ -201,17 +220,22 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
>    */
>   void smbd_destroy(struct TCP_Server_Info *server)
>   {
> -	struct smbd_connection *info = server->smbd_conn;
> +	struct smbd_connection *info =
> +		rcu_dereference_protected(server->smbd_conn, 1);
>   
>   	if (!info) {
>   		log_rdma_event(INFO, "rdma session already destroyed\n");
>   		return;
>   	}
>   
> -	smbdirect_socket_release(info->socket);
> +	RCU_INIT_POINTER(server->smbd_conn, NULL);
> +	smbdirect_socket_shutdown(info->socket);
> +	if (!refcount_dec_and_test(&info->refcount))
> +		wait_for_completion(&info->destroy_done);
> +	synchronize_rcu();
>   
> +	smbdirect_socket_release(info->socket);
>   	kfree(info);
> -	server->smbd_conn = NULL;
>   }
>   
>   /*
> @@ -222,7 +246,7 @@ int smbd_reconnect(struct TCP_Server_Info *server)
>   {
>   	log_rdma_event(INFO, "reconnecting rdma session\n");
>   
> -	if (!server->smbd_conn) {
> +	if (!rcu_access_pointer(server->smbd_conn)) {
>   		log_rdma_event(INFO, "rdma session already destroyed\n");
>   		goto create_conn;
>   	}
> @@ -236,10 +260,11 @@ int smbd_reconnect(struct TCP_Server_Info *server)
>   
>   create_conn:
>   	log_rdma_event(INFO, "creating rdma session\n");
> -	server->smbd_conn = smbd_get_connection(
> -		server, (struct sockaddr *) &server->dstaddr);
> +	rcu_assign_pointer(server->smbd_conn,
> +			   smbd_get_connection(server,
> +					       (struct sockaddr *)&server->dstaddr));
>   
> -	if (server->smbd_conn) {
> +	if (rcu_access_pointer(server->smbd_conn)) {
>   		cifs_dbg(VFS, "RDMA transport re-established\n");
>   		trace_smb3_smbd_connect_done(server->hostname, server->conn_id, &server->dstaddr);
>   		return 0;
> @@ -303,6 +328,8 @@ static struct smbd_connection *_smbd_get_connection(
>   	info = kzalloc_obj(*info);
>   	if (!info)
>   		return NULL;
> +	refcount_set(&info->refcount, 1);
> +	init_completion(&info->destroy_done);
>   	ret = smbdirect_socket_create_kern(net, &sc);
>   	if (ret)
>   		goto socket_init_failed;
> @@ -393,14 +420,23 @@ struct smbd_connection *smbd_get_connection(
>    * consumed. But this will require more changes to upper layer code, and also
>    * need to consider packet boundaries while they still being reassembled.
>    */
> -int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
> +int smbd_recv(struct TCP_Server_Info *server, struct msghdr *msg)
>   {
> -	struct smbdirect_socket *sc = info->socket;
> +	struct smbd_connection *info = smbd_conn_get(server);
> +	struct smbdirect_socket *sc;
> +	int rc;
>   
> -	if (!smbdirect_connection_is_connected(sc))
> +	if (!info)
>   		return -ENOTCONN;
>   
> -	return smbdirect_connection_recvmsg(sc, msg, 0);
> +	sc = info->socket;
> +	if (!smbdirect_connection_is_connected(sc))
> +		rc = -ENOTCONN;
> +	else
> +		rc = smbdirect_connection_recvmsg(sc, msg, 0);
> +
> +	smbd_conn_put(info);
> +	return rc;
>   }
>   
>   /*
> @@ -412,9 +448,9 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
>   int smbd_send(struct TCP_Server_Info *server,
>   	int num_rqst, struct smb_rqst *rqst_array)
>   {
> -	struct smbd_connection *info = server->smbd_conn;
> -	struct smbdirect_socket *sc = info->socket;
> -	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(info);
> +	struct smbd_connection *info = smbd_conn_get(server);
> +	const struct smbdirect_socket_parameters *sp;
> +	struct smbdirect_socket *sc;
>   	struct smb_rqst *rqst;
>   	struct iov_iter iter;
>   	struct smbdirect_send_batch_storage bstorage;
> @@ -423,9 +459,16 @@ int smbd_send(struct TCP_Server_Info *server,
>   	int rc, i, rqst_idx;
>   	int error = 0;
>   
> -	if (!smbdirect_connection_is_connected(sc))
> +	if (!info)
>   		return -EAGAIN;
>   
> +	sc = info->socket;
> +	sp = smbd_get_parameters(info);
> +	if (!smbdirect_connection_is_connected(sc)) {
> +		error = -EAGAIN;
> +		goto out;
> +	}
> +
>   	/*
>   	 * Add in the page array if there is one. The caller needs to set
>   	 * rq_tailsz to PAGE_SIZE when the buffer has multiple pages and
> @@ -439,7 +482,8 @@ int smbd_send(struct TCP_Server_Info *server,
>   		/* assertion: payload never exceeds negotiated maximum */
>   		log_write(ERR, "payload size %d > max size %d\n",
>   			remaining_data_length, sp->max_fragmented_send_size);
> -		return -EINVAL;
> +		error = -EINVAL;
> +		goto out;
>   	}
>   
>   	log_write(INFO, "num_rqst=%d total length=%u\n",
> @@ -501,10 +545,9 @@ int smbd_send(struct TCP_Server_Info *server,
>   	if (unlikely(rc && !error))
>   		error = -EAGAIN;
>   
> -	if (unlikely(error))
> -		return error;
> -
> -	return 0;
> +out:
> +	smbd_conn_put(info);
> +	return error;
>   }
>   
>   /*
> @@ -514,16 +557,24 @@ int smbd_send(struct TCP_Server_Info *server,
>    * need_invalidate: true if this MR needs to be locally invalidated after I/O
>    * return value: the MR registered, NULL if failed.
>    */
> -struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
> -				 struct iov_iter *iter,
> -				 bool writing, bool need_invalidate)
> +struct smbdirect_mr_io *smbd_register_mr(struct TCP_Server_Info *server,
> +					 struct iov_iter *iter,
> +					 bool writing, bool need_invalidate)
>   {
> -	struct smbdirect_socket *sc = info->socket;
> +	struct smbd_connection *info = smbd_conn_get(server);
> +	struct smbdirect_mr_io *mr = NULL;
> +	struct smbdirect_socket *sc;
>   
> -	if (!smbdirect_connection_is_connected(sc))
> +	if (!info)
>   		return NULL;
>   
> -	return smbdirect_connection_register_mr_io(sc, iter, writing, need_invalidate);
> +	sc = info->socket;
> +	if (smbdirect_connection_is_connected(sc))
> +		mr = smbdirect_connection_register_mr_io(sc, iter, writing,
> +							 need_invalidate);
> +
> +	smbd_conn_put(info);
> +	return mr;
>   }
>   
>   void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
> @@ -545,17 +596,21 @@ void smbd_deregister_mr(struct smbdirect_mr_io *mr)
>   
>   void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
>   {
> +	struct smbd_connection *info;
> +
>   	if (!server->rdma)
>   		return;
>   
> -	if (!server->smbd_conn) {
> +	info = smbd_conn_get(server);
> +	if (!info) {
>   		seq_puts(m, "\nSMBDirect transport not available");
>   		return;
>   	}
>   
> -	smbdirect_connection_legacy_debug_proc_show(server->smbd_conn->socket,
> +	smbdirect_connection_legacy_debug_proc_show(info->socket,
>   						    server->rdma_readwrite_threshold,
>   						    m);
> +	smbd_conn_put(info);
>   }
>   
>   MODULE_IMPORT_NS("SMBDIRECT");
> diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
> index be205ec02077..e8cf8f901cac 100644
> --- a/fs/smb/client/smbdirect.h
> +++ b/fs/smb/client/smbdirect.h
> @@ -12,6 +12,9 @@
>   
>   #include "cifsglob.h"
>   
> +#include <linux/completion.h>
> +#include <linux/rcupdate.h>
> +#include <linux/refcount.h>
>   #include <linux/smbdirect.h>
>   
>   extern int rdma_readwrite_threshold;
> @@ -25,8 +28,13 @@ extern int smbd_receive_credit_max;
>   
>   struct smbd_connection {
>   	struct smbdirect_socket *socket;
> +	refcount_t refcount;
> +	struct completion destroy_done;
>   };
>   
> +struct smbd_connection *smbd_conn_get(struct TCP_Server_Info *server);
> +void smbd_conn_put(struct smbd_connection *info);
> +
>   /* Create a SMBDirect session */
>   struct smbd_connection *smbd_get_connection(
>   	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
> @@ -39,13 +47,13 @@ int smbd_reconnect(struct TCP_Server_Info *server);
>   void smbd_destroy(struct TCP_Server_Info *server);
>   
>   /* Interface for carrying upper layer I/O through send/recv */
> -int smbd_recv(struct smbd_connection *info, struct msghdr *msg);
> +int smbd_recv(struct TCP_Server_Info *server, struct msghdr *msg);
>   int smbd_send(struct TCP_Server_Info *server,
>   	int num_rqst, struct smb_rqst *rqst);
>   
>   /* Interfaces to register and deregister MR for RDMA read/write */
>   struct smbdirect_mr_io *smbd_register_mr(
> -	struct smbd_connection *info, struct iov_iter *iter,
> +	struct TCP_Server_Info *server, struct iov_iter *iter,
>   	bool writing, bool need_invalidate);
>   void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
>   				    struct smbdirect_buffer_descriptor_v1 *v1);
> @@ -60,8 +68,10 @@ static inline void *smbd_get_connection(
>   	struct TCP_Server_Info *server, struct sockaddr *dstaddr) {return NULL;}
>   static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1; }
>   static inline void smbd_destroy(struct TCP_Server_Info *server) {}
> -static inline int smbd_recv(struct smbd_connection *info, struct msghdr *msg) {return -1; }
> +static inline int smbd_recv(struct TCP_Server_Info *server, struct msghdr *msg) {return -1; }
>   static inline int smbd_send(struct TCP_Server_Info *server, int num_rqst, struct smb_rqst *rqst) {return -1; }
> +static inline struct smbd_connection *smbd_conn_get(struct TCP_Server_Info *server) {return NULL; }
> +static inline void smbd_conn_put(struct smbd_connection *info) {}
>   #endif
>   
>   #endif
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 375b821ab3ea..63d6700e5bd7 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -257,9 +257,7 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
>   	cifs_in_send_inc(server);
>   	if (cifs_rdma_enabled(server)) {
>   		/* return -EAGAIN when connecting or reconnecting */
> -		rc = -EAGAIN;
> -		if (server->smbd_conn)
> -			rc = smbd_send(server, num_rqst, rqst);
> +		rc = smbd_send(server, num_rqst, rqst);
>   		goto smbd_done;
>   	}
>   

