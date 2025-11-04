Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14672ECEAC
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 12:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762260464; cv=none; b=OiftSKuDhW1NUEGw5qOyDO9F9ikFBK7ccMeceeeND8vbmAIhDhttw05yD0I3Fj35am/ryMok8TKQnxcxl2yRCgw0DDbLhWahUnsf1q4X1PazGSnERviJRAiY4I3MUKlP76PPkbJFd2Zphk0A+ZyN08vTbEhrn/yfkoSwqs64zOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762260464; c=relaxed/simple;
	bh=g4MzobWCgMAbdFKqXdws3q6G9OR+n0+6vpq9/2gGiYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a2KJMqDzIXfKk+cE9gB4mdUWId8nVKzeCN6h84ZXFYmd5PCIScewMFyYFFxwe3DpkpcAsbbHQeA8A7QZSzbcaft2o99+GLvxjtXOawgD5VM0XdUzlJNAeKs8Cox2YfdQCFV5CgrDc5tn6rgzsT6yiDH31iojbtZXpmhsdbtQrGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mp8b3IW6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKba1yXw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mp8b3IW6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKba1yXw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762260461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BWnifgGT0AcayVvuS2yfUcRlYF71GXMXDqlq2lq5xps=;
	b=Mp8b3IW68dk5F3iMH1X0sj/+wDHG+j01bA5G4NrkktUKG6qQn2NZwGAN/xcZwMXKmSBI8j
	N1Sidb9iXWwDnE3qSiZHBEK+Ire4EDoxSahfoweDBYPb4EupaL2O8RD5UHDB91GzywXur2
	uipVLuvRLEEHWgAN008PEj/C1FjuhfE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-VJew1EEoNsmGM5ADdomRBA-1; Tue, 04 Nov 2025 07:47:40 -0500
X-MC-Unique: VJew1EEoNsmGM5ADdomRBA-1
X-Mimecast-MFC-AGG-ID: VJew1EEoNsmGM5ADdomRBA_1762260459
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-429cceeeb96so1223893f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 04:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762260459; x=1762865259; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BWnifgGT0AcayVvuS2yfUcRlYF71GXMXDqlq2lq5xps=;
        b=VKba1yXwSlT1JSdoiZtO6T6xLfIlZxUkWQszQHB/6WwvFY4GG23P2xr6znm/fkx9MT
         szW9fqwrHt29xJLGFCMLXkkd2YN1fl8MRjJcSs8A29qVmLxoFtdwPOoFF3VNGr6xT+Vm
         ffFBnyJTJfSJqqoPqaLVZ6TDOypmdnWu90RHOxvYkShy+9Zc95b4nhxVW+5/RCWebyNw
         QccLTN0DGfhRods6hukqQ0dfJ0IwDsE/u8hvg4KP5AVHHQWkZMNLia7hJ0/p+fBgDJE+
         1jUuJNdhfduVfimFsucqmTnqe3WHa72MUk+LvA32mtpHezOmc08rUnEgvJ8QVQWWw93u
         7/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762260459; x=1762865259;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWnifgGT0AcayVvuS2yfUcRlYF71GXMXDqlq2lq5xps=;
        b=h2tTQ6Xn0vg8rNMkUqXjljeGtWJoo2+ugeMLHzUOG8USs1eG3JKHpBI/nuWGBQ4CFW
         jlQcQti4hIfrYYeiBHrkSFKkG84UnmkD+QjgCo5swUHKYkgHdKsCek4SLf+g0ybZMhra
         Pzv336DT/r0hn8zCf9yur2C6jlP+AqvPGGDgADRAEPHN6UPM1xReuiJhuPT/742kEa9D
         V9I9+4OY8DOK2EG0uqf38cf05c753WdC4FqrRkpFtk+N0UH6jttRwCAW6ZyoA4XOwx29
         tTcuf/M0Uy0BsyBBir55tXLZ9OcpgOYAGKfrewoap4f18oIAv7J2iS3h00v5CBspMH7K
         hK9w==
X-Forwarded-Encrypted: i=1; AJvYcCU40dBR7YWAYSgi7PoHNOoOdN/OxKsNfh0t3vj6mpHS+t5jHs94B+jLR7aza91vWPJ4clYyRxmu6TyJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1dY10MaBLzDFZ85DBs9BYLn6HxotZrZ/NieNRFOQievSMiWyT
	ybQVuuJxmP60DxjiDY7fv0Wm/qFp9D9XmJVoByvacQz0OG5BfeVHxO22qI+g6ytC7VWz8Owhz45
	vT3ew9hkOmXf1+YHXhnjCBG3MoW9OsYQEt2zQyDTEtLvwQP5srAb8y2xSGqXj+V8=
X-Gm-Gg: ASbGncvPdW148d/abnV3zaQ59HK994dmsTfsXu8usAZE41quetRcO+A0mX0Uik7DxbD
	3L2BmYk5Rlickfp/Em5qKiHCDeHBCUSrwm56XV27T7rssiLln/JTXi05QD0Rnd++KCBeVMmsJZ0
	yDtCX8ni7HND0zkpfTng5yK+GRY263vokIJitYd2yA1KBcSk0+oNffy+uQXvymnYoiNZCAFCAvz
	0SKvqaaoX2Nogw16JAbNf9n7+EMh+v1jbMReUDgW8QeTXKbj6FyPan22oump50PRgL/wqtOZyZg
	6h27aW4zfdUjgb/vng3IxYq7mpQHWxwkgTk+uOdz83jlHaM9A2rmVMaEoX2Jt28Uj4U2e+ayjdx
	mkjdiv8e7ASKw6WoOG5asyhpXyEaeiahpkoC2khtBCiNR
X-Received: by 2002:a05:6000:4b0f:b0:429:c965:afa with SMTP id ffacd0b85a97d-429c9650c2emr9026854f8f.36.1762260459278;
        Tue, 04 Nov 2025 04:47:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGiJ1SiVaPavd71LCb0yruPCRV4eS0waiUfxW8OCw2NKcYZLnottK8w5LOXobrD0/V4oRg99w==
X-Received: by 2002:a05:6000:4b0f:b0:429:c965:afa with SMTP id ffacd0b85a97d-429c9650c2emr9026809f8f.36.1762260458840;
        Tue, 04 Nov 2025 04:47:38 -0800 (PST)
Received: from ?IPV6:2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6? ([2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dbf53e86sm4620311f8f.0.2025.11.04.04.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 04:47:38 -0800 (PST)
Message-ID: <989d3df8-52cf-41db-bb4c-44950a34ce89@redhat.com>
Date: Tue, 4 Nov 2025 13:47:35 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 14/15] quic: add frame encoder and decoder
 base
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
 <56e8d1efe9c7d5db33b0c425bc4c1276a251923d.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <56e8d1efe9c7d5db33b0c425bc4c1276a251923d.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 3:35 PM, Xin Long wrote:
> +static void quic_frame_free(struct quic_frame *frame)
> +{
> +	struct quic_frame_frag *frag, *next;
> +
> +	if (!frame->type && frame->skb) { /* RX path frame with skb. */

Are RX path frame with !skb expected/possible? such frames will be
'misinterpreted' as TX ones, specifically will do `kfree(frame->data)`
which in turn could be a bad thing.

Possibly add a WARN on such scenario?

/P

