Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5789613790B
	for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755784514; cv=none; b=M6DvOFe96/DhBgCXm/UJ5dm3O+3l//E8PYLZCHwkfTO17H+A6lFVK/gin7ukINVIqburQIHYOHxJdLIqi1glEnyrdiZtSoOO1XaZIf79rbt0S8Z+MM+vyjkVEeUMK0+FC7rJoHtOwPxtitWNuHxj6JrxiJlMyOb8U0VNU3Ddy2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755784514; c=relaxed/simple;
	bh=ZviIfSbh0VhjgD45Fn9oFgsDkrDTP6rt7QaE5xDyGGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TIKIQXVz5hjVfF22sAwfpgSmRC1Lb05T/2sUfTWOj8EOBEdcIeK09/ZFjZix51aFbokim/0tGN1s7KcKaREiFw3bpJi2ZHASMnsowBKzCHr7X566E2hWun8d9JjQYh4ychiyCw8G675zah0NOciNLCsUSpxooVsdQQtN33SyMCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J8S5g0+f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J8S5g0+f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755784511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vqpCFdTzBLh9g0B1TnAyisbVI0QorOaFpispw1JN7Gc=;
	b=J8S5g0+f2PiAybLCt6WOQpicHF54hvBMyA5eXKVYsNIVGO/CDB9NIwxfaDRenSRmp7eNuB
	U1rwyw2EFr/9ziPegDzYjSm6jT6n8qTez5D/erNa9guXOQT3GAMEA+fSyZ2y3cTrumnpPZ
	SFg2PbXP6YGeevD+B9T217GQFXJrpLA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-ZbiCVIsiMriPQwAuQnog9g-1; Thu, 21 Aug 2025 09:55:09 -0400
X-MC-Unique: ZbiCVIsiMriPQwAuQnog9g-1
X-Mimecast-MFC-AGG-ID: ZbiCVIsiMriPQwAuQnog9g_1755784509
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9e4117542so511184f8f.2
        for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 06:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755784508; x=1756389308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vqpCFdTzBLh9g0B1TnAyisbVI0QorOaFpispw1JN7Gc=;
        b=wrg6NWhqIKcXjxEXfF0+g12FiyZO3rTaWjcqwyv6CbdecL1kjScIgX4dhfTPgOKWT0
         v+N0JV+vMFEk8Hucc55yWlts21ngqz6dbE8uNKY/sJ8wHjAq1jcdfgidAdrazlOYe2wb
         lbu+NN/7T2mdvgJIdqZzHh15/dtMjB8Nw/P8gYPYZ/IKu0TfcdSR/V+vk0uBm1pEeW6f
         /kcJZSr3aO5DyZupYYJA3yeZ23z8v+/J2pAAGWd2CHeHrlkEo/dTKzDM5yaBnFds+Vl+
         YGeAJ6qbl91/toWRr4kTb3PrHUSH4SQXbPUo1YxO8ZzP4SKzK3tK5YglGzARvplZG9wV
         zOBA==
X-Forwarded-Encrypted: i=1; AJvYcCWYL7oYq4lWMzikM4eskylvU7abL2UudGYIt/RhwGaWOz9ffGsPfugUwLI1KwP0yRd85jlMB3Fw9dxO@vger.kernel.org
X-Gm-Message-State: AOJu0YynbfUA9vE459SvsfIqKpibdPVPG65IGKtSMEhGM3FeaHp9O21o
	HWujZM0Ho0+eQ+wuGN+ZGjV4apbVl2V9HBHDEnXlcAfncS8jExPhhWK2+lc/XkOoKUabaYEfsBF
	VIvDO24KC839T0IRKdh1tmqGQ5j+Sx6K8mkO9JLIQXybu+p8RC5lH6MJEX4nCYPw=
X-Gm-Gg: ASbGncv+b9mRsacyvEzd2fvFNI3fAZ8FgzquB7kwKV/FYPagWO+rwF7o9W+eJjEheGk
	wb5ImtBI9tNbMbIFwetvaH0jhVk4hCKY+3RSpWmhPT+OpA/cJPtoPFsuzhtr9R4hi5PLcl/+mZV
	+763H2L3X7SG5AxwOlYfvJlsmh7WLIgFFDwIPbN+0VtctYivdmEfrP7Fr0wqWAA8rHr9RXVaty/
	4MKmzuwndI5BdPd/NakDLy9s+dgBQjkmf2sjSiV+G9u03Wyx/ihUdIS5hFLYruvY4QRhXh03i6c
	nhNMo3L5KzKBSuWlHm8DkBvzhCkLnt7dwvUSv8U4+CrFxyY7Vu7FAEmkaeq2gedsdS5V5DDjm0x
	gkvoBOq8P+wQ=
X-Received: by 2002:a05:6000:2f82:b0:3b7:926f:894c with SMTP id ffacd0b85a97d-3c49549d32emr2167547f8f.23.1755784508483;
        Thu, 21 Aug 2025 06:55:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIy5n1DLX30C0ab+YmzKYVMr4r0vuN7yISHYHRZ6gAfhK+7oL5iHJc2LHbMR17R330Ik8K6w==
X-Received: by 2002:a05:6000:2f82:b0:3b7:926f:894c with SMTP id ffacd0b85a97d-3c49549d32emr2167519f8f.23.1755784507860;
        Thu, 21 Aug 2025 06:55:07 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c3da114eabsm5262534f8f.8.2025.08.21.06.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 06:55:07 -0700 (PDT)
Message-ID: <1cf31726-bfb9-4909-a077-6c2c45e0720a@redhat.com>
Date: Thu, 21 Aug 2025 15:55:04 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 07/15] quic: add connection id management
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Benjamin Coddington <bcodding@redhat.com>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1755525878.git.lucien.xin@gmail.com>
 <e7d5e3954c0d779e999dc50a9b03d9f7ed94dbd2.1755525878.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <e7d5e3954c0d779e999dc50a9b03d9f7ed94dbd2.1755525878.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/25 4:04 PM, Xin Long wrote:
> This patch introduces 'struct quic_conn_id_set' for managing Connection
> IDs (CIDs), which are represented by 'struct quic_source_conn_id'
> and 'struct quic_dest_conn_id'.
> 
> It provides helpers to add and remove CIDs from the set, and handles
> insertion of source CIDs into the global connection ID hash table
> when necessary.
> 
> - quic_conn_id_add(): Add a new Connection ID to the set, and inserts
>   it to conn_id hash table if it is a source conn_id.
> 
> - quic_conn_id_remove(): Remove connection IDs the set with sequence
>   numbers less than or equal to a number.

It's unclear how many connections are expected to be contained in each
set. If more than an handful you should consider using RB-tree instead
of lists.

[...]
> +static void quic_source_conn_id_free(struct quic_source_conn_id *s_conn_id)
> +{
> +	u8 *data = s_conn_id->common.id.data;
> +	struct quic_hash_head *head;
> +
> +	if (!hlist_unhashed(&s_conn_id->node)) {
> +		head = quic_source_conn_id_head(sock_net(s_conn_id->sk), data);
> +		spin_lock_bh(&head->s_lock);
> +		hlist_del_init(&s_conn_id->node);
> +		spin_unlock_bh(&head->s_lock);
> +	}
> +
> +	/* Freeing is deferred via RCU to avoid use-after-free during concurrent lookups. */
> +	call_rcu(&s_conn_id->rcu, quic_source_conn_id_free_rcu);
> +}
> +
> +static void quic_conn_id_del(struct quic_common_conn_id *common)
> +{
> +	list_del(&common->list);
> +	if (!common->hashed) {
> +		kfree(common);
> +		return;
> +	}
> +	quic_source_conn_id_free((struct quic_source_conn_id *)common);

It looks like the above cast is not needed.

> +}
> +
> +/* Add a connection ID with sequence number and associated private data to the connection ID set. */
> +int quic_conn_id_add(struct quic_conn_id_set *id_set,
> +		     struct quic_conn_id *conn_id, u32 number, void *data)
> +{
> +	struct quic_source_conn_id *s_conn_id;
> +	struct quic_dest_conn_id *d_conn_id;
> +	struct quic_common_conn_id *common;
> +	struct quic_hash_head *head;
> +	struct list_head *list;
> +
> +	/* Locate insertion point to keep list ordered by number. */
> +	list = &id_set->head;
> +	list_for_each_entry(common, list, list) {
> +		if (number == common->number)
> +			return 0; /* Ignore if it is already exists on the list. */
> +		if (number < common->number) {
> +			list = &common->list;
> +			break;
> +		}
> +	}
> +
> +	if (conn_id->len > QUIC_CONN_ID_MAX_LEN)
> +		return -EINVAL;
> +	common = kzalloc(id_set->entry_size, GFP_ATOMIC);
> +	if (!common)
> +		return -ENOMEM;
> +	common->id = *conn_id;
> +	common->number = number;
> +	if (id_set->entry_size == sizeof(struct quic_dest_conn_id)) {
> +		/* For destination connection IDs, copy the stateless reset token if available. */
> +		if (data) {
> +			d_conn_id = (struct quic_dest_conn_id *)common;
> +			memcpy(d_conn_id->token, data, QUIC_CONN_ID_TOKEN_LEN);
> +		}
> +	} else {
> +		/* For source connection IDs, mark as hashed and insert into the global source
> +		 * connection ID hashtable.
> +		 */
> +		common->hashed = 1;
> +		s_conn_id = (struct quic_source_conn_id *)common;
> +		s_conn_id->sk = data;
> +
> +		head = quic_source_conn_id_head(sock_net(s_conn_id->sk), common->id.data);
> +		spin_lock_bh(&head->s_lock);
> +		hlist_add_head(&s_conn_id->node, &head->head);
> +		spin_unlock_bh(&head->s_lock);
> +	}
> +	list_add_tail(&common->list, list);

It's unclear if/how id_set->list is protected vs concurrent accesses.

/P

