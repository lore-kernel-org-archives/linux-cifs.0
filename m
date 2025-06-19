Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3302C22D7BC
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750333751; cv=none; b=n3I909QB3l0i3pIObwjUAaLLtHGbvk93IGZWza7ndX5W5yKSw3DyIFAZOMpTAkkacXagR6FU7evPyfoqM88E0oi2PpQT8yytgEcxX21lOiHEaJnhdTky5PwBnmVPC8TLqdHUAddI9EjVDEK0RVmr0HR79Az//R/NYjMsKr4Z6Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750333751; c=relaxed/simple;
	bh=7ml2f1JSTGZ/OUrwmIzt3PfU+dI6KWpmUmdWhRxcdhI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=s9RTF+x9r5/JnPm8CoNFc7qOBRlkxDefO+bxQrt0uPh5OzTA6/AjpC20oZNSDoA3SZ/aGIgi/JBYdzZNafDU3c7mD23yna5uzp8e+DLzfllHsiIPTNFPJWDooWckaQ8T3O7pVvKgUJvjcjF9hjh6i6smNzgsW46nJJhU1pzr34I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S2WAxMZ2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S2WAxMZ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750333748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gs7tdjof+61E6ncMSJfmEBg3uzF6tSUvPjSoL9ZDzzg=;
	b=S2WAxMZ2VPOFjqpq6DxaSIhXxX7juTPkY5qZYTX4xgN3qrLXS6VjtuCiSF4fUaQNjSnt6D
	yqyhnxvRj2g+nrDpyoVUcRrfG1EVA6QNBJ8dMxvktL+8TX2KN5YHz7U7k8Tuy7KtFvYmeB
	cG6uurs4A82C6v6a2GZjf67nV6qVZc4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-9nYXXOQKPeSIC_noR547AQ-1; Thu,
 19 Jun 2025 07:49:05 -0400
X-MC-Unique: 9nYXXOQKPeSIC_noR547AQ-1
X-Mimecast-MFC-AGG-ID: 9nYXXOQKPeSIC_noR547AQ_1750333744
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9AE621800288;
	Thu, 19 Jun 2025 11:49:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1A63F180035C;
	Thu, 19 Jun 2025 11:49:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
References: <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org> <cover.1750264849.git.metze@samba.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org,
    Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <850316.1750333740.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Jun 2025 12:49:00 +0100
Message-ID: <850317.1750333740@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Stefan Metzmacher <metze@samba.org> wrote:

> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index cbc85bca006f..3a41dcbbff81 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -842,7 +842,7 @@ static int smbd_post_send(struct smbd_connection *in=
fo,
>  =

>  static int smbd_post_send_iter(struct smbd_connection *info,
>  			       struct iov_iter *iter,
> -			       int *_remaining_data_length)
> +			       unsigned int *_remaining_data_length)

I would recommend size_t...

>  {
>  	struct smbdirect_socket *sc =3D &info->socket;
>  	struct smbdirect_socket_parameters *sp =3D &sc->parameters;
> @@ -907,8 +907,10 @@ static int smbd_post_send_iter(struct smbd_connecti=
on *info,
>  			.local_dma_lkey	=3D sc->ib.pd->local_dma_lkey,
>  			.direction	=3D DMA_TO_DEVICE,
>  		};
> +		size_t payload_len =3D min_t(size_t, *_remaining_data_length,
> +					   sp->max_send_size - sizeof(*packet));

... and umin().

>  =

> -		rc =3D smb_extract_iter_to_rdma(iter, *_remaining_data_length,
> +		rc =3D smb_extract_iter_to_rdma(iter, payload_len,
>  					      &extract);
>  		if (rc < 0)
>  			goto err_dma;
> @@ -970,8 +972,16 @@ static int smbd_post_send_iter(struct smbd_connecti=
on *info,
>  	request->sge[0].lkey =3D sc->ib.pd->local_dma_lkey;
>  =

>  	rc =3D smbd_post_send(info, request);
> -	if (!rc)
> +	if (!rc) {
> +		if (iter && iov_iter_count(iter) > 0) {
> +			/*
> +			 * There is more data to send
> +			 */
> +			goto wait_credit;
> +		}
> +

This fix isn't mentioned in the patch description.

>  		return 0;
> +	}
>  =

>  err_dma:
>  	for (i =3D 0; i < request->num_sge; i++)
> @@ -1007,7 +1017,7 @@ static int smbd_post_send_iter(struct smbd_connect=
ion *info,
>   */
>  static int smbd_post_send_empty(struct smbd_connection *info)
>  {
> -	int remaining_data_length =3D 0;
> +	unsigned int remaining_data_length =3D 0;

size_t?

>  =

>  	info->count_send_empty++;
>  	return smbd_post_send_iter(info, NULL, &remaining_data_length);

Apart from the above:

Reviewed-by: David Howells <dhowells@redhat.com>

