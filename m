Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4756D2EFDB5
	for <linux-cifs@vger.kernel.org>; Tue, 17 Jun 2025 20:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750191915; cv=none; b=WUZstA4YLJEcPq8foirotJgqZhSLfFxYgWQOhYhewcG9CqGvQJu92nJqOh7BxExSvgTHKH602OoYYq8XAnQNlNd/yADvTyDHYdmOSnIZReLyxtepxY29tn73Lc9OcJuLAzGE65UhiliWDb0VUi0U2xp2BYiW1QwfcjOU2Wndigg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750191915; c=relaxed/simple;
	bh=GqnNTXVndRWI0PiUNLLEgHd6YnRr20qoT2O2RMi6Y9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NjWHri1FXebo1/UnyZPD7V2HuATuigiz3FIDJwPFgXOVeCh/d5F5Zxd88KQ8R73v1zXDoseX8mMDNAo8uEwGgmOHKBJFD7mN381/h/80hpYIK0XYX+0JK3MJa/p1T6kV2uUUW6qrKoVekqXtzoSLE0u3OLs6BZtc5ukMmCGOEQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=GS9eTwia; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="GS9eTwia"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=HagecfYwoT+tuXv3QdbeL8glXW9WWuC85+3o60bnf9s=; b=GS9eTwiaU4ArZNr7TD0DV759Xw
	pmLZAyisUrl95bIY5OvqjMGlFcPtxwn1JnNpxIFFg0DRZzJo5gSQ7VCwdctqk4Qnbc/OETS4YZDHF
	NW4DkTisNaKj2QohUEz2P712Q/uWQgo+xWNT57DTCYP6lPq8WoAM/eH44M6sXr2wh+WcgrTb1zMem
	PlLWJBLsuDTSrA4NBzZJhXaGY/OySU7AHYx0wDVlZAb3zV4Gw0bUv7JKLFQ3/QBC6LIrniOtZQRx9
	DolaTUDIvA+R7DgHIscnPup/qBQbP5kWyFE2PL2V0jePaRzS3GiQggKyAItK5ldqSirJhxshz8eW/
	GQ98mT5P4BY0EcgX7sSwV3kB11uJtz43vYwgvoWH3+SV4AZk+veuuSjsybd8gh3EdH1mEMQV5NsOx
	S8/N28qWOGLcA9c3R/Od1Cq7za/L7jmxNr1ydSItzttC7IP/HoeQxrPVGX9WTw2GnW4dKat8Ph9za
	f3VpFdw4tQ3VLItvXejzk/ho;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uRchW-00B9x4-0d;
	Tue, 17 Jun 2025 20:14:34 +0000
Message-ID: <2e660165-b071-4239-b52d-bcd4a9b45f24@samba.org>
Date: Tue, 17 Jun 2025 22:14:32 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: add free_transport ops in ksmbd connection
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
 atteh.mailbox@gmail.com
References: <20250610100405.9367-1-linkinjeon@kernel.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20250610100405.9367-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 10.06.25 um 12:04 schrieb Namjae Jeon:
> free_transport function for tcp connection can be called from smbdirect.
> It will cause kernel oops. This patch add free_transport ops in ksmbd
> connection, and add each free_transports for tcp and smbdirect.
> 
> Fixes: 21a4e47578d4 ("ksmbd: fix use-after-free in __smb2_lease_break_noti()")
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Stefan Metzmacher <metze@samba.org>

> ---
>   fs/smb/server/connection.c     |  2 +-
>   fs/smb/server/connection.h     |  1 +
>   fs/smb/server/transport_rdma.c | 10 ++++++++--
>   fs/smb/server/transport_tcp.c  |  3 ++-
>   4 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
> index 83764c230e9d..3f04a2977ba8 100644
> --- a/fs/smb/server/connection.c
> +++ b/fs/smb/server/connection.c
> @@ -40,7 +40,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
>   	kvfree(conn->request_buf);
>   	kfree(conn->preauth_info);
>   	if (atomic_dec_and_test(&conn->refcnt)) {
> -		ksmbd_free_transport(conn->transport);
> +		conn->transport->ops->free_transport(conn->transport);
>   		kfree(conn);
>   	}
>   }
> diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
> index 6efed923bd68..dd3e0e3f7bf0 100644
> --- a/fs/smb/server/connection.h
> +++ b/fs/smb/server/connection.h
> @@ -133,6 +133,7 @@ struct ksmbd_transport_ops {
>   			  void *buf, unsigned int len,
>   			  struct smb2_buffer_desc_v1 *desc,
>   			  unsigned int desc_len);
> +	void (*free_transport)(struct ksmbd_transport *kt);
>   };
>   
>   struct ksmbd_transport {
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
> index 4998df04ab95..64a428a06ace 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -159,7 +159,8 @@ struct smb_direct_transport {
>   };
>   
>   #define KSMBD_TRANS(t) ((struct ksmbd_transport *)&((t)->transport))
> -
> +#define SMBD_TRANS(t)	((struct smb_direct_transport *)container_of(t, \
> +				struct smb_direct_transport, transport))
>   enum {
>   	SMB_DIRECT_MSG_NEGOTIATE_REQ = 0,
>   	SMB_DIRECT_MSG_DATA_TRANSFER
> @@ -410,6 +411,11 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
>   	return NULL;
>   }
>   
> +static void smb_direct_free_transport(struct ksmbd_transport *kt)
> +{
> +	kfree(SMBD_TRANS(kt));
> +}
> +
>   static void free_transport(struct smb_direct_transport *t)
>   {
>   	struct smb_direct_recvmsg *recvmsg;
> @@ -455,7 +461,6 @@ static void free_transport(struct smb_direct_transport *t)
>   
>   	smb_direct_destroy_pools(t);
>   	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
> -	kfree(t);
>   }
>   
>   static struct smb_direct_sendmsg
> @@ -2281,4 +2286,5 @@ static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
>   	.read		= smb_direct_read,
>   	.rdma_read	= smb_direct_rdma_read,
>   	.rdma_write	= smb_direct_rdma_write,
> +	.free_transport = smb_direct_free_transport,
>   };
> diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
> index abedf510899a..4e9f98db9ff4 100644
> --- a/fs/smb/server/transport_tcp.c
> +++ b/fs/smb/server/transport_tcp.c
> @@ -93,7 +93,7 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
>   	return t;
>   }
>   
> -void ksmbd_free_transport(struct ksmbd_transport *kt)
> +static void ksmbd_tcp_free_transport(struct ksmbd_transport *kt)
>   {
>   	struct tcp_transport *t = TCP_TRANS(kt);
>   
> @@ -656,4 +656,5 @@ static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
>   	.read		= ksmbd_tcp_read,
>   	.writev		= ksmbd_tcp_writev,
>   	.disconnect	= ksmbd_tcp_disconnect,
> +	.free_transport = ksmbd_tcp_free_transport,
>   };

