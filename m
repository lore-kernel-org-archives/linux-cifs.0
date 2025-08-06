Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA551B4F1F
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 11:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754480372; cv=none; b=SHAD7OQkpe2ihYXJVSHBN+M7cW8F61SMP7qh3arLSjDd/QLRNWLZEppbObuR+OiTcBzyNZN2R0HAfVhCNHA5yT3v+Reju+sIeA0CkINMqup0EH2BjK2cjbapUA8s2aWIugzHKoHEjfNGLqDEkdJErvRCehSGg9831n5bUCBpHtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754480372; c=relaxed/simple;
	bh=M2sRovWHt4yUFVajwBgrOQg28LvGMvoF8BW8CiY0cLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oyqnduiGfkuGEKn9fjXBuT3EXeKVWFwVX4u46/FljDnHXonrYrZyaLjdAhy3555b8OEN8xIYnzXaTP+aPGXz/5GeeeuGrHXaUcndJSG0y+eF8TDCygORuU6J2/1/J1odE76iM6tgH4A84vNJGWYqEKfc3Wk0D75FuYgoAPEduXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yGuso2rj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yGuso2rj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=YgL9UHXWpCfyNoJe7nDYl3W+0F276Rjidc8HzG8GZXk=; b=yGuso2rjeMTbM95fNOu9/5TiXE
	JtC5qZaZNbIFaQeGOVp0bBYkK7EaqoR/6U3u4DWvUP3nyauSeNxkjDanz/rExtd7KHH7hHprg5L18
	rE44+jG9YNx0Ia3tHmGSB5VATjSoTBR3JJlSS4okaECBDhIXS2MOxhR8wf7kfKqwZc3YHPZlnm5uQ
	6/MD808AeOEL6zgIulzIZ2RZW5G9RURYEt+cPQ7n3Fg7pfC0AlYskdULKFqFnUQGAxCJzDZNOzmnU
	MegokuUFyS/NuxBR7tXLIqrmuIRNGpKgXHRhmksjlJ+6W1Nu2LMqSKpk1JGxRaen14NXJeKzGXspf
	vxpU9n48H/9OLF6I13Rvh1PRQbQQ0hWMgSN4cHRqGXJRWJy8cG771w6ehKfE4yzEIcMECqNrFBIEA
	otB+UoM/7vUPdQEY9IqCobdhzbQbLt9CAQcnwn3wmq/5bYoKYkhUiCcchzxKy2T+FjHDDwV7mB0qK
	ywjIPLEOtr9tknfEFRF1YwUz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujcUP-001KeF-3B;
	Wed, 06 Aug 2025 11:39:26 +0000
Message-ID: <a9dc02a1-ab9c-4bc6-8a69-b0794bf258fd@samba.org>
Date: Wed, 6 Aug 2025 13:39:25 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] smb: client: let send_done() cleanup before calling
 smbd_disconnect_rdma_connection()
To: Steve French <stfrench@microsoft.com>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Long Li <longli@microsoft.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 Samba Technical <samba-technical@lists.samba.org>
References: <cover.1754308712.git.metze@samba.org>
 <0b80cf1a140280ca75ac21d5577a141e433d35f7.1754308712.git.metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <0b80cf1a140280ca75ac21d5577a141e433d35f7.1754308712.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

can you please squash this into the commit? Otherwise it introduces
as new use-after-free problem with request->info.

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 7377216e033d..5d1fa83583f6 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -286,8 +286,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
  	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
  		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
  			wc->status, wc->opcode);
-		mempool_free(request, request->info->request_mempool);
-		smbd_disconnect_rdma_connection(request->info);
+		mempool_free(request, info->request_mempool);
+		smbd_disconnect_rdma_connection(info);
  		return;
  	}

Thanks!
metze

Am 04.08.25 um 14:10 schrieb Stefan Metzmacher:
> We should call ib_dma_unmap_single() and mempool_free() before calling
> smbd_disconnect_rdma_connection().
> 
> And smbd_disconnect_rdma_connection() needs to be the last function to
> call as all other state might already be gone after it returns.
> 
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/client/smbdirect.c | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 754e94a0e07f..b6c369088479 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -281,18 +281,20 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
>   	log_rdma_send(INFO, "smbd_request 0x%p completed wc->status=%d\n",
>   		request, wc->status);
>   
> -	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
> -		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
> -			wc->status, wc->opcode);
> -		smbd_disconnect_rdma_connection(request->info);
> -	}
> -
>   	for (i = 0; i < request->num_sge; i++)
>   		ib_dma_unmap_single(sc->ib.dev,
>   			request->sge[i].addr,
>   			request->sge[i].length,
>   			DMA_TO_DEVICE);
>   
> +	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
> +		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
> +			wc->status, wc->opcode);
> +		mempool_free(request, request->info->request_mempool);
> +		smbd_disconnect_rdma_connection(request->info);
> +		return;
> +	}
> +
>   	if (atomic_dec_and_test(&request->info->send_pending))
>   		wake_up(&request->info->wait_send_pending);
>   

