Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5389612E1DC
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 15:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767887559; cv=none; b=ckQTABLGUr03Y6JTnEfY2XXS+FIt36Wqe2bI16NxhrxpfXkvfXajmW+rWF3+THpQr6qogrBFYC3FWR7WoclrRkV1uLoo+LXmkV1qXoC1xhjm6QwFxtPxtos+y4aeQiJDzsrTDGEUYbnEnqiaSJfi+NeHwcHjVVW9QaDed7Hjm8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767887559; c=relaxed/simple;
	bh=Ecl1PbKVRyx23lmWYgMZH9CBPlfIEVtqzYUAkJfKTuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dESKQXoCEZ7YJ57pp0uoHmChkMsWifSGkjtWidGTYXgd9CRhQqM4nL/Hnqf7hpOOyBsSJXpu097o+KNWvIhc3SvkfCq8mUVA+S7EhL4JYzJlYYAqypODT4kUbNZ0x5pqYKn2VfUydAFeou2agpmHC5y6wAKVSfHqWqJm3ebiwmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XM5657gX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a4ZZcx7w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XM5657gX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a4ZZcx7w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767887557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=74FrBsYB82BggKYVQEFS4TeWY2PiI4VLCk/K0yOsgeU=;
	b=XM5657gXhOGCL/7HLJDHYOqaImCt5a5a6RfhUpxOoqrh89qvFfmSmFwtBqqu3e/KaJ498j
	SL9P5BDpmiETP6TGpi61LnY3AwvrNe5nAvmozU5mFPb5hskH1kWob5KAuAv3wE/IieDi0Q
	/ifaLkZPgOAS0b6qquQMDYZjBVFZcCE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-Jeahc5l6N26tfjl-fv7P-Q-1; Thu, 08 Jan 2026 10:52:36 -0500
X-MC-Unique: Jeahc5l6N26tfjl-fv7P-Q-1
X-Mimecast-MFC-AGG-ID: Jeahc5l6N26tfjl-fv7P-Q_1767887555
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43284f60a8aso2036454f8f.3
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jan 2026 07:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767887555; x=1768492355; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=74FrBsYB82BggKYVQEFS4TeWY2PiI4VLCk/K0yOsgeU=;
        b=a4ZZcx7woWeTQqz4PZ1w1w/4/qbd//HOTz2K8PU81iKAtX9nb8eB0WRmRCzw/gPlAJ
         urmqZu/RZS/qmcBUYPEGiJ8NJ6js3t8D4YGVvAoLk3i+FQZMDmyg/GsUa2vHGb3kOnhh
         78NadC27nvVhJtwNQpIExFavAzdQeENKk25Rac0rH/a8yDrBpheTUmHUV1VtlN7CUSqx
         h29wxcUpvVI40wMsv86AAcCOicDsVX672OVY/f7kczbVAHZuqUAsVpRLGjXuawjv1bJS
         XJfvbr2NbI9dNvgagItm5/sIGKOWaAGqQN+VgcXu9xZo9gvP3eefzmX/foRm80nJZMw2
         y1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767887555; x=1768492355;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=74FrBsYB82BggKYVQEFS4TeWY2PiI4VLCk/K0yOsgeU=;
        b=X/SarRH091cEKyUU8hZREc4uwL3fpmvFEMqkBJT4gDMpaPpgeam0StD1IND45fjVIC
         +4f5RNDnC+IqflfdRyscp90OFya2h7JOvirYoJyYNhzPw3OmsJNNzbJevv2Mp3dguht5
         sI5NRhGLfiGjlHMvt3DZ0yTysvm53bOP6oyRDSt4HCJ2NhSreh+cbvz7Hq8yE2+QvXf8
         tWYZEvDmfeN/NoMf10gsbxgQ4z4063PQn2SEHxOC2fCyTfSP6d6TnYW9jI+UlfYJrH94
         b4aTimX7d3bgMD4FpEq4OqtUXZE6EdNqxYnY1D1hJTegx0IsfViiMB/uAqfCK3Fcstd3
         kXjA==
X-Forwarded-Encrypted: i=1; AJvYcCU9OM6irSgU+90O8tXX/GlcAzLSY5mshNA/oc/BNpc2Kevyk1svggp82Z+loI/xsv98fYlNGwwV0r2V@vger.kernel.org
X-Gm-Message-State: AOJu0YxvT+pC7bpQhyIpoxgVtv+k/XcSa1Ntso82YtBAfHnZfXXod9bE
	cYp8jCpXbQfYEOB9vbQQqU3x5unAtwkd16LVtoWR0aXL3tpoxzq40TXv+2ejAqeNZrOSnHuMjTC
	ujscB27rO6sRqI3EjJCRSlOt3PWVqxLNbRnmXxcLS3nLusPKhNZNiyKU8yqotJ3E=
X-Gm-Gg: AY/fxX4O54C6AK4ejuqMas5hsiRENH7vLRcr1l+0aqUKyqZfpIArtt0+YZ/uj0tmGax
	QGdDA3ij1BF/sdUNWGt2Cp7H3gIUdpHQfTWBH7pi1E58uxku9ndl9a+YBkDn26nIsmK3Plyx8Ue
	Q2mjjA+uteu9HLC/UIikE/WthSCJuXfKnUlH7RRIOKdUzYF5r+EwuXKoCHzVmRsO/DSfNrTaKAr
	2T6mf7p0jkP8l98eh17pAoVuujmG0fEbgyJvAzkjNw+LobVvZ/3arQHPvrYEudr+P2ldc0dWP62
	6Bttm3yNwGHJ6bkLowqZR/ZSzUdPkRERw+ERtsUREANj16J8J9/hofZxBNKQQGLLC0z2WlYUhTN
	syxlvqk3ul7dPXw==
X-Received: by 2002:a05:6000:4284:b0:432:bc90:2cfa with SMTP id ffacd0b85a97d-432c374f5b2mr9200054f8f.33.1767887554980;
        Thu, 08 Jan 2026 07:52:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSKdamN7KlUBs3N2vJJPlmjw5J/9h4DJzDryl8KQLv679zn5HwyVK1QASMGXWGmNWePQJKlQ==
X-Received: by 2002:a05:6000:4284:b0:432:bc90:2cfa with SMTP id ffacd0b85a97d-432c374f5b2mr9200014f8f.33.1767887554566;
        Thu, 08 Jan 2026 07:52:34 -0800 (PST)
Received: from [192.168.88.32] ([212.105.149.145])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ff319sm17169574f8f.43.2026.01.08.07.52.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jan 2026 07:52:34 -0800 (PST)
Message-ID: <ec28c852-e80a-41c9-94ce-a0fce8ee07e7@redhat.com>
Date: Thu, 8 Jan 2026 16:52:31 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 07/16] quic: add connection id management
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1767621882.git.lucien.xin@gmail.com>
 <79bf90a6e105c6e6ac692de21a90ec621af47cc5.1767621882.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <79bf90a6e105c6e6ac692de21a90ec621af47cc5.1767621882.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/5/26 3:04 PM, Xin Long wrote:
> +/* Remove connection IDs from the set with sequence numbers less than or equal to a number. */
> +void quic_conn_id_remove(struct quic_conn_id_set *id_set, u32 number)
> +{
> +	struct quic_common_conn_id *common, *tmp;
> +	struct list_head *list;
> +
> +	list = &id_set->head;
> +	list_for_each_entry_safe(common, tmp, list, list) {
> +		if (common->number <= number) {
> +			if (id_set->active == common)
> +				id_set->active = tmp;
> +			quic_conn_id_del(common);
> +			id_set->count--;
> +		}

Since the list is sorted by number you could break the loop as soon as
common->number > number.
		
> +	}
> +}
> +
> +struct quic_conn_id *quic_conn_id_find(struct quic_conn_id_set *id_set, u32 number)
> +{
> +	struct quic_common_conn_id *common;
> +
> +	list_for_each_entry(common, &id_set->head, list)
> +		if (common->number == number)
> +			return &common->id;

Same here, you can break the loop when common->number > number


> +static inline u32 quic_conn_id_first_number(struct quic_conn_id_set *id_set)
> +{
> +	struct quic_common_conn_id *common;
> +
> +	common = list_first_entry(&id_set->head, struct quic_common_conn_id, list);

id_set can be empty at creation time. The above assumes it contains at
least an element. Does the caller need to check for such condition?
Possibly moving the check here would simplify the code?

/P

