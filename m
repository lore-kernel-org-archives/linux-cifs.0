Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F51B23D2BF;
	Wed,  6 Aug 2025 12:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754482861; cv=none; b=WSyKTMfrBKYfiCMxq+S2uQxQ9xjGeSJQc2bIt79dV6L0mOeek4dIxkJae5Zx2XeRt78KRsjKSU2oYBhrbP8RlQnV0SbruZB7wTOjFHeNqsCJ7OflC7GNJ8R4ZcXxXPUQeAoriZlDjMeHbFKj2QSJS6ZK0MPGGLCDj8DIwe1BVq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754482861; c=relaxed/simple;
	bh=POhIbQCNR6Aj2gXT+9WgOUHHxojKMSYi6FKS6jC02t0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwrD46BXxKWVSbcsg730cGE/HFALVJihXUcT0+gA7gpWEXdDFVn/OPcRMkeKxOk2JK4CL82/MxXa0997eNh/3XOpPq/H0cOyHfAzl7T4L5lYC/+ySrd7d/PVGMjoH/P5k6reKsRLOexBJfzynotfgXupDjffVxqRa2gCSuYFbmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XGw9shob; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XGw9shob"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=ap/g2AjFZIDWCZF6J1P5m3S2uCAGI9se2g24LPdaTTs=; b=XGw9shobOLw7XZEJpyWiEkswb1
	N6IW0N57tvudzaavd5CeBPrbysKohptUUms1DAO+8zMiH50qU/hIek3+uBzNI0p+5hsj2AK8w/a31
	c+Y8V28Xm8wDlrKIXq54VCKPK1fkC7Lx61mqJsgoU/NX2UNRXOjrYCrDEs/VIww1YCPz73ozhuLCE
	d3qDgAZCZS9QT6Yu5A6OOeO2dPLedU6amK8+Yu1kmkXj1bF/3Taq1uQ9Y5JyxxIAHSfW67AwJCKhm
	w971sHmAw9ulSwhmVJoggozX62lJkZwkP3uuThzWrkizqP/B+KRUmnjM49f4WRys3B8+Y0qtn6ONs
	BkRLID3TyW3WPiVpFUUn4bYtIDV9hRPydDVHD46SzshDk2BYcTXgACJTiXM6BcC2oT6MKwX5mDVer
	+swBtram1mjkhnIzpimxc8E3PDuxxmPMJEHo5b0Z7DUvhi9zinaihWiDahbHF5cGbr8UwZjj60DVL
	3Mf+m5zD0Ie8uMXyVh77RcdN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujd8a-001LCN-1Z;
	Wed, 06 Aug 2025 12:20:56 +0000
Message-ID: <ad2e9d94-2d95-4351-b800-627f20672209@samba.org>
Date: Wed, 6 Aug 2025 14:20:56 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] smb: client: Fix use after free in send_done()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
References: <aJNASZzOWtg8aljM@stanley.mountain>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <aJNASZzOWtg8aljM@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dan,

> The mempool_free() function frees "request".  Don't free the request
> until after smbd_disconnect_rdma_connection() to avoid a use after free
> bug.
> 
> Fixes: 5e65668c75c0 ("smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>   fs/smb/client/smbdirect.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 58321e483a1a..162f8d1c548a 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -286,8 +286,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
>   	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
>   		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
>   			wc->status, wc->opcode);
> -		mempool_free(request, request->info->request_mempool);
>   		smbd_disconnect_rdma_connection(request->info);
> +		mempool_free(request, request->info->request_mempool);

The correct fix is to use 'info' instead of 'request->info'
other than that the order needs to stay that way.

I already asked Steve to squash such a change into the
original commit (which is not yet upstream).

See:
https://lore.kernel.org/linux-cifs/cover.1754308712.git.metze@samba.org/T/#m98a8607d7b83a11fd78547306836a872a2a27192

What was the test that triggered the problem?
Or did you only noticed it by looking at the code?

Thanks!
metze
