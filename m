Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673101DFD96
	for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 17:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768844420; cv=none; b=jU1ovLjHUZmduzz1hAUJCH12DlcLtT7GgeYHk90PL0zGVrdb8rzMTK4aIt0LEsTZhhkAmRlibDHC85lCrEd1yZavoV6eAtb0+om6L2DiyM01KG6+fp2wqsmhoWtEgTrlcvtaol+T1X1/7B0NBAl59GuVqhtxI2ZEZvtRnO48c3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768844420; c=relaxed/simple;
	bh=CMMAIIdEjpLnpscZ2hH06Echdg8/FASBikQlRRq7850=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R1QT+y8G7QpXmsos2f3Xdtp+LSxUDm4W+kTkcj6sRJo/ogi8ZbkhziS+JrjXWpfuOXM6qrxlMWvPi55+GZHUaZiSIr6UFFooRyev11cPIkPIIo6GNXeJhDo3V3579ilLPYS37ro6BjYxyzHcY/naBBedi/uS57OcbNox2T65p4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jk+nGN/3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jk+nGN/3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=ikmWwKT3tpdgBnH0Hb4PzSvHtuJOgJWXWF+JurZVkEA=; b=jk+nGN/3AjOMkZGVG95dZF6l6p
	8C2mU0sw3WxXVrNsQ+ENtvS31z1HCDMfsU9J4M1JLSxC+BSDlguLSgClVegOsGTTxxPuDPlt0wM52
	S5PhKWLnjT7oZ2QA54zX/zuPc6zGjSOFAmQj4M5JI9Jhg8p2oNbJ31NsmgQ5cMoraFLMdeedM+idD
	vIIfs/MNiIfOPMVCbhvdKzIJ2fr3Q2D9YOsZKQFj2VwTxQuP9sBKTZI3BvfDSr/t5stKUeYv5+mNN
	vdVGnqX6xp5IbCSW8phJuU/W8mXb4NHj+bRUQVh8DLvowb1cF6USuTUZmdezZtT1HK4TeFfjn3/ev
	1pvKRwgLQ2rJ/l93KqPTrD0zdv9yrDPN4HwRrBCk5HET90ZwmW85lE70eLU40lpYDzTO6mlX1pVs1
	ERhSjsddB9NYhThmQeMnOv3M4TNVhqS54elGqpSMbO1CPNCnFKiaAeAlwUvaQexD6uirBfkqDid4v
	6Mg5bga9vUvhUslG3dbz5dFW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vhtEd-00000001BD7-2Inb;
	Mon, 19 Jan 2026 17:40:15 +0000
Message-ID: <b5b92cae-d92a-426e-b6ad-fcaa9691b980@samba.org>
Date: Mon, 19 Jan 2026 18:40:15 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: server: reset smb_direct_port =
 SMB_DIRECT_PORT_INFINIBAND on init
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>
References: <20251208154919.934760-1-metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20251208154919.934760-1-metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Namjae,

can this be merged? It makes testing between roce and iwarp
much easier.

I have infrastructure to listen on both iwarp and roce
at the same time, but I haven't written the patches for
ksmbd.ko to use it. I'll hopefully find the time
in the next days.

Thanks!
metze


Am 08.12.25 um 16:49 schrieb Stefan Metzmacher:
> This allows testing with different devices (iwrap vs. non-iwarp) without
> 'rmmod ksmbd && modprobe ksmbd', but instead
> 'ksmbd.control -s && ksmbd.mountd' is enough.
> 
> In the long run we want to listen on iwarp and non-iwarp at the same time,
> but requires more changes, most likely also in the rdma layer.
> 
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/server/transport_rdma.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
> index f585359684d4..05f008ea51cd 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -2708,6 +2708,7 @@ int ksmbd_rdma_init(void)
>   {
>   	int ret;
>   
> +	smb_direct_port = SMB_DIRECT_PORT_INFINIBAND;
>   	smb_direct_listener.cm_id = NULL;
>   
>   	ret = ib_register_client(&smb_direct_ib_client);

