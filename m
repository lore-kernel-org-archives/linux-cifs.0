Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BCD2F0C6E
	for <linux-cifs@vger.kernel.org>; Mon,  8 Sep 2025 09:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757323127; cv=none; b=ap3/ueLAdjVva0ro760IjUWRa8e6cyqtbQMzmmJTVQbzWQL13wyjjXUSVciiJkjOE8Q6WrCRZGwDgu+MXvApN3AFhnCcIGiGl57mo/Ql0htT3SQ5jg0U0ZIiXK9egCNLzPN5MKEtKsFLuHHzjvdMtP79MojTCjIL3EmrfTaDOPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757323127; c=relaxed/simple;
	bh=0FHEStZ3V8PkXZmk7YsJQztkfizgxZ+gPxBQK0ZooTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WLKvvS0c1caZgIbBV+rNWI4VdZz1hp1M/UmBIdV78eiYz2t3YjIgOZSJ97+vpKQcS/hk1N7I8D7MLYVvDHZwbhj1MTmoMT8li40SmUIZJrX0oMup7qm6c4srgQhqXCHGXad2Zy9J4sOOw/AcQjinI+KgJ1RTBiYTPVTEY9bXOXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=HbYCt3EP; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="HbYCt3EP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=K2P+4RW/NoGTiBE3/+HNNEvKYfYK8WVFWoWCp/BWX1E=; b=HbYCt3EPUDznij8FRanVfoSPlE
	kRbiRqptX9a3AV5c8j//DkNodW7QSOlQe/jkgDFTM47dK3deByP1VBvweJmgJLc6CM2A9wZPmsUUt
	gkpwwr2czRHTVQLBnoDBaEFX/smLHNjYRK50AQz7aqE85yYjPl30yYNr91Xmr5Rr8GaEqE9nOvDty
	V1gCybFGXlsVfjOWDQ1TtfUqd3jQOdGhh3w4Qhv1yRraEQmgGC5jaazFDyB4VvecMkDML9tur5o0r
	AnTPAu3bdoqDY9Qozw0qCHIPTTkW8vA53EqroUBfIRCymVAEp5oNF4pQQ2qt2ydcCBPBjOAlmiKYU
	qVERlLYMt0LMJEKPLHhE58kTU+qY4OMBFWmnX2BavHiyKsU88iw7VxejRFFNNVXmt9WTONvOJtG8z
	CVdSF8tuKdWZA5Pjl5CJ9bKtXHsRlE3EFM6nwWVEmrSIwpoXDJQzHNlAG+82S3TSkGY5kwaglseqA
	VvGsxEKtQT4VJAr7ERiLQXhU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uvY1K-0030aN-0K;
	Mon, 08 Sep 2025 09:18:42 +0000
Message-ID: <6e143477-2240-4034-a5ff-02d7c412382a@samba.org>
Date: Mon, 8 Sep 2025 11:18:41 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 098/142] smb: server: make use of
 smbdirect_socket.send_io.pending.{count,wait_queue}
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>
References: <cover.1756139607.git.metze@samba.org>
 <15e99e9490c6562e81d0f525526a91ee05f822a1.1756139607.git.metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <15e99e9490c6562e81d0f525526a91ee05f822a1.1756139607.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 25.08.25 um 22:40 schrieb Stefan Metzmacher:
> This will is used by the client already and will allow to create
> common helper functions.
> 
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/server/transport_rdma.c | 26 ++++++++++----------------
>   1 file changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
> index 62e13112a2b6..fd8d3fbdfa6c 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -106,9 +106,6 @@ struct smb_direct_transport {
>   	wait_queue_head_t	wait_send_credits;
>   	wait_queue_head_t	wait_rw_credits;
>   
> -	wait_queue_head_t	wait_send_pending;
> -	atomic_t		send_pending;
> -
>   	struct work_struct	post_recv_credits_work;
>   	struct work_struct	send_immediate_work;
>   
> @@ -341,9 +338,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
>   
>   	spin_lock_init(&t->receive_credit_lock);
>   
> -	init_waitqueue_head(&t->wait_send_pending);
> -	atomic_set(&t->send_pending, 0);
> -
>   	spin_lock_init(&t->lock_new_recv_credits);
>   
>   	INIT_WORK(&t->post_recv_credits_work,
> @@ -380,7 +374,7 @@ static void free_transport(struct smb_direct_transport *t)
>   	}
>   
>   	wake_up_all(&t->wait_send_credits);
> -	wake_up_all(&t->wait_send_pending);
> +	wake_up_all(&sc->send_io.pending.wait_queue);
>   
>   	disable_work_sync(&t->post_recv_credits_work);
>   	disable_work_sync(&t->send_immediate_work);
> @@ -834,8 +828,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
>   		smb_direct_disconnect_rdma_connection(t);
>   	}
>   
> -	if (atomic_dec_and_test(&t->send_pending))
> -		wake_up(&t->wait_send_pending);
> +	if (atomic_dec_and_test(&sc->send_io.pending.count))
> +		wake_up(&sc->send_io.pending.wait_queue);

In the rebase on top of "smb: server: let smb_direct_writev() respect SMB_DIRECT_MAX_SEND_SGES"
sc->send_io.pending.wait_queue will become sc->send_io.pending.zero_wait_queue in
order to make it clear it's woken when count reaches 0.

metze
