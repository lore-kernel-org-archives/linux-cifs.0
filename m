Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3E32E5B19
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 12:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762258656; cv=none; b=kH/6vo6EKUzwds+FLGD/rlKm1lauNrCNJlfuAENO+hdpf2fQYbCSSIVtbUthRktZAGP1iBuZEj5f734HI0clj3oq5gA5CGD4FnDM0rvo2YC9wllLMpWgkW+jrqa85oeXFj47V43lFmpaNvQi3NeyncRZDIHt8RyBhP2YpfwOWZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762258656; c=relaxed/simple;
	bh=P0QOjc+Y/i4SUjAz9hyI1Est9kQhNqP0MO2eaNzC2o0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FNC9XcRHExeFLiCT86ICZrjcI2cqT8pjrSzLXMnF7poWlQMSs+dU12qtwgyulT3GzN9YpPhctHsLQYE1t8mCpUitueReudnCynZGZh01RY4M6XjDpwgvqSiKunUCpSdrpulQIvjnssg7yywQK8cgowKGuWRcxNMZpTg9TDQ5H70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZuJ/wiPV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DAXRxqSG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZuJ/wiPV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DAXRxqSG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762258653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrVv52+Wup10TuV26Al3G9RFtHr2QH+o3/M+H4STBAA=;
	b=ZuJ/wiPVaV2kFPl4w7jI67n5inMCnjHDHGCnf+4/rhtRetIgVaHXH6OSBKpN8LFrYsCYFh
	mJy/BxSM5CK7W+TpdftiHXPdWBamZSEemhlkcP/2ouEpo+lx+9+GkR5e3WZTFprwWMRdSy
	fbIzCcRWN4gm+29kv3EVrINKu+rNhbM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-2DGq_4shN-KSWx5dBqZllg-1; Tue, 04 Nov 2025 07:17:32 -0500
X-MC-Unique: 2DGq_4shN-KSWx5dBqZllg-1
X-Mimecast-MFC-AGG-ID: 2DGq_4shN-KSWx5dBqZllg_1762258650
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-426d4f59cbcso3450888f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 04:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762258650; x=1762863450; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SrVv52+Wup10TuV26Al3G9RFtHr2QH+o3/M+H4STBAA=;
        b=DAXRxqSGaR7gXhm83ZvcIJNnx+BstnhQWeOs1FZVeKdCaBq0GHP0a6oNAMiwceMfnj
         uBXP8ubu70STs/7IjpbD9Xzz13PoqRZM2ek1C9rDJ1a3QfPmdBfu9PKvkY5iieHfB+6m
         KCilcropuWEItOtuFtj1CaDLDFojFeR0Per4sGTLQ3q+81Q4d/wLZawGdJfossyY6WY4
         6p2XlCIWT7j7dQRISam6UeJljRHFdbFCfnbypq6cvOhtq1kJHMEUVQSGTIivSQr9coeS
         wndyDHLxY8z5GvSt7dFAGLXFvinPe764WJs3Lr/ZBbjE5VfNPFHxC84vLBH+R9KunJij
         keuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762258650; x=1762863450;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SrVv52+Wup10TuV26Al3G9RFtHr2QH+o3/M+H4STBAA=;
        b=pQFtQ0uaPYuyHT/lKjW1msYG8ItxCrNXgkbAfZqDhP4RyYzANuCZbj9/DZWK+CH+Dn
         woIHIiX+uFOmsFdSbs3UhHWCzDRKfpPbxTJT79ReYFdshQRrs5WN6D1k+uH0f2wuADwG
         gXcLZIHGoWzbnHjbH+nVMow1SXIyGOBSbrdvMuzPt3Qz8ru+4XUGuGyDsaUU/IPaJiuS
         mnUEdPDysoOBGBba06XvbRe5sbrwYh0DVKjrYfXoloNT8UFnGoqMF9POeDsYbmSgyjIp
         FLTPPcu0i9j2klJm9FSnVZ0wpkBlkT2n0kJqZVGUeTgNI7bNL38Oc9mTnba3WA1hfnXp
         HLLw==
X-Forwarded-Encrypted: i=1; AJvYcCVyTcaspH/1CxgrsuPkA/xa9eBkQcmLhUDrpKd1kGyAWkk+Et9uVyxM/j5FdpNeqHbNKw4t6nIYXYao@vger.kernel.org
X-Gm-Message-State: AOJu0YwHLsARfryQc5Zo8vY5UGFcgnemuS9+suNVdfMLjptUwnxacPSB
	LMCapwbmNmnH2rXCMckVgp0n3f+a9QsmP2Wb2wSh10C4U5T5zWRiOrP35LzywP7psq4YjxsTA6H
	qgLhCPVZQBlpSNHzRNH2B8A9oPjL6nVkKj7v1dZmYdpY1eB68q3uNlgMAHyNTNqs=
X-Gm-Gg: ASbGncuiLFYyo/xENLvNhjMttwdk/eTOaS1/oL+NL4nd/0fwkWuciesF8flTm8/bRgx
	JTNOozz+5XJ2lP+4KIsNZSQkBRKTbYusy1IviPlgUfafxxqbKZcVIp03I44RzE1tfvPJFjeeb3c
	fCRf7ZRalTEH+KqSeMv57QZCAp/PrBWUmKwJB7vu8zZw4rydbIk91qGkTWb5lXgtL2L+e/cq4+E
	QV5BTlXToCty1sARQKSMaVlI9Y42fuMNLvSVMeIdZ0UePdblkrvXx6xyapWmVLerUWhOblIqNec
	aV0pZJq06b9kVDmCNQ6Tfh2OJ/2B3+i6Ri8kM5bCO5UQvr6Aw5m8cboPHKvQ6/zKB1QAOHo67KW
	Gu/T+OOKuTMU8apl+vcOK5S68M2rr9W72OHLFhZyToRVZ
X-Received: by 2002:a05:6000:40de:b0:429:d290:22f9 with SMTP id ffacd0b85a97d-429dbcabe53mr2945305f8f.4.1762258650445;
        Tue, 04 Nov 2025 04:17:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IElFwJq3LBE7DNZtfuVK0eheDgsp8L8ZPbTvbUgjo7k2WL6IDip2GsX5myepH9Q0/Tu9JOyzw==
X-Received: by 2002:a05:6000:40de:b0:429:d290:22f9 with SMTP id ffacd0b85a97d-429dbcabe53mr2945262f8f.4.1762258649949;
        Tue, 04 Nov 2025 04:17:29 -0800 (PST)
Received: from ?IPV6:2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6? ([2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1f5a7fsm4316521f8f.24.2025.11.04.04.17.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 04:17:29 -0800 (PST)
Message-ID: <635b0dad-98bf-41e9-b7b6-1f28da48fc00@redhat.com>
Date: Tue, 4 Nov 2025 13:17:26 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 10/15] quic: add packet number space
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
 Benjamin Coddington <bcodding@redhat.com>, Steve Dickson
 <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1761748557.git.lucien.xin@gmail.com>
 <a1df61880c9f424b49b2d4933e0d6ea0bf6da268.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <a1df61880c9f424b49b2d4933e0d6ea0bf6da268.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 3:35 PM, Xin Long wrote:
> +struct quic_pnspace {
> +	/* ECN counters indexed by direction (TX/RX) and ECN codepoint (ECT1, ECT0, CE) */
> +	u64 ecn_count[QUIC_ECN_DIR_MAX][QUIC_ECN_MAX];
> +	unsigned long *pn_map;	/* Bit map tracking received packet numbers for ACK generation */
> +	u16 pn_map_len;		/* Length of the packet number bit map (in bits) */
> +	u8  need_sack:1;	/* Flag indicating a SACK frame should be sent for this space */
> +	u8  sack_path:1;	/* Path used for sending the SACK frame */
> +
> +	s64 last_max_pn_seen;	/* Highest packet number seen before pn_map advanced */
> +	u32 last_max_pn_time;	/* Timestamp when last_max_pn_seen was received */
> +	u32 max_time_limit;	/* Time threshold to trigger pn_map advancement on packet receipt */
> +	s64 min_pn_seen;	/* Smallest packet number received in this space */
> +	s64 max_pn_seen;	/* Largest packet number received in this space */
> +	u32 max_pn_time;	/* Time at which max_pn_seen was received */
> +	s64 base_pn;		/* Packet number corresponding to the start of the pn_map */
> +	u32 time;		/* Cached current time, or time accept a socket (listen socket) */

There are a few 32 bits holes above you could avoid reordering the fields.

Otherwise LGTM,

Acked-by: Paolo Abeni <pabeni@redhat.com>

