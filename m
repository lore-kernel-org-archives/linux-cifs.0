Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9336028B516;
	Wed,  6 Aug 2025 13:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754488680; cv=none; b=qRQUs+BRTXYpx1rBB+SgU/alV7ctmJcJcO5FOyCkZ/LKftFeI+udd6Q9xGLlbmR7NF5zWgFGjjvAziXyyPrKtoxl6W6+/Idd6q/lKS1AWuSRbmPmi3y0HaRe/BFAgaxlP0N+Fj/ISTZ9F7K/3b51CRjEYfHUbeDYJGFUiZcIGZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754488680; c=relaxed/simple;
	bh=t6uig3ov/NbPQ0m9pNa2ettAxkzswOWZIb3NitFRcc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q5kOOQ8NEGSNVo2P0U+y44uQUOgV1CMUb6izA0WuucteB/Y4kK+NCVJ0L7N1eKn7+k5OmoAXkfeSR7FrFiKvbnG6qRrluEj9TIn77u7MrqoTiCk2R7MLX0PcQIOU/EWz1J/4ADboekw41dmaDVJaIcElRYe7/SKP9EvqLemg8ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xTakyPQ8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xTakyPQ8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=+88mmlwu0Nm7OIJ3HtcXAQRPm1cSYqICgM3gFbzJwno=; b=xTakyPQ8sh795O1Y6m4RfdY21P
	hzPLtgBTRgvqs8GPonMvzt2bDQ5e3l0T6lWipVtiscak3O2KaGS9EW6t8BkCqTyJxyZDn8Ph2c/0I
	Ou6paN1Zo9h61F7IqIHgZ9MkkFnyf5RmkQj1iX6Ip22F9sh3ImmfVHVRpeEn5/UykOfUYA/tLmnXT
	lOKLxiYbS6qlz4QyCIVsPt+aim7qeMBqQNDtBtalAkjLM83Mh8r9f9e5hmCpc8V3H1ka1UsqIBYL3
	JYlBM+DpOCNzvRbhGhBaNNInPChTH8KqMVqF3KGraXhYQkj9Tfo4FA8/AcjsEvfXVxi5FW4LMMwaD
	FeF4nWSnu5MqjxPngpxpftkE1gXbMLQhOKRRtJO8JPBOhvlZ+ySq8P4nm+7dPgjy3DyzvuPhkZj+t
	wfZozl56+LJjFARrFJKdxSHNPARqm3PMi0s2efjaWdg3zRxQWRK12nMHpXA6opPeYxNeMI1xsvx9f
	dwErFK/pzhhIRPVHC+TJOonA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujeeR-001Mac-2r;
	Wed, 06 Aug 2025 13:57:56 +0000
Message-ID: <91f09266-b81e-4e28-95c3-4272096a0fca@samba.org>
Date: Wed, 6 Aug 2025 15:57:55 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmbd: add kcov remote coverage support via ksmbd_conn
To: Yunseong Kim <ysk@kzalloc.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, syzkaller@googlegroups.com,
 linux-kernel@vger.kernel.org, notselwyn@pwning.tech
References: <20250806135224.116724-2-ysk@kzalloc.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20250806135224.116724-2-ysk@kzalloc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yunseong,

> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
> index 3f04a2977ba8..21352f37384f 100644
> --- a/fs/smb/server/connection.c
> +++ b/fs/smb/server/connection.c
> @@ -93,6 +93,9 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
>   	down_write(&conn_list_lock);
>   	list_add(&conn->conns_list, &conn_list);
>   	up_write(&conn_list_lock);
> +
> +	ksmbd_conn_set_kcov_handle(conn, kcov_common_handle());
> +
>   	return conn;
>   }

...

> +
> +static inline void ksmbd_conn_set_kcov_handle(struct ksmbd_conn *conn,
> +				       const u64 kcov_handle)
> +{
> +#ifdef CONFIG_KCOV
> +	conn->kcov_handle = kcov_common_handle();
> +#endif
> +}

The caller passes kcov_common_handle() as argument, which is not used
but kcov_common_handle() is called again...

metze

