Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D0531280D
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762248028; cv=none; b=hN+3fS9Ft0qEGNVEn6w2Zc2lSAqwF+WJfoiyREzg2bgP7VC0U6dr4IErKvCuuW+Gr474HTrzgmJjaIafIPIkMNxjlZZtvDjBkOKXxKmfQ6b9/MyytOqpZIUSKurlv5UVkKYfxPi+jLiMQ6GJUhDtanowidwDMVBFQp2R/iwKqrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762248028; c=relaxed/simple;
	bh=pUKJPrLx0M2WMbh/ePs7QzJ4DazqZizbc++rbelECWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sZyq1mOwujbJY9FKeu9bbX+4qmP/5RWNy+UaLKvM2CAATXxJf3Erih1uI1hfT8rY8eYwUXMnDXF3ALgNH0Dyatcl7IAgaLNEA/0Nowss53ykc0Fw3yhVul9dqGu12KvVCZvl7VoXt68iLL1ewPc6f11qQc4vx+qfeX9vrYqJ3Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hT0PfY1P; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ov3OiwST; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hT0PfY1P";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ov3OiwST"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762248025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ltNFnYEQmixQZpMP12HbSmJnNGHT1YgJ5lkpfeO1BNA=;
	b=hT0PfY1PSRvkPoh3XVfgEdNs+/C5tgjjXg0wDVS4m1xvEwAQPvYFX7TLCqo9dotCLALY1m
	W2cQCVhsR/CeY4ssu6LaogLK4mVD79DYeDB5KKeCUIEWJyCSR3hiIpEpKNP0ubyPGcV7pi
	sEWxn8u1O9H22q42TP9tAceWdHXR4YA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-LSui1cG_N3Gw8JF6ibfcLQ-1; Tue, 04 Nov 2025 04:20:24 -0500
X-MC-Unique: LSui1cG_N3Gw8JF6ibfcLQ-1
X-Mimecast-MFC-AGG-ID: LSui1cG_N3Gw8JF6ibfcLQ_1762248023
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-471168953bdso42645295e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 01:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762248023; x=1762852823; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ltNFnYEQmixQZpMP12HbSmJnNGHT1YgJ5lkpfeO1BNA=;
        b=ov3OiwSTqzZ+PqgaPUK2pdkKejhplolMVaqodVcienexwYM1mKPACT1MA2OmPbuPy4
         Dq/UP4yx858h06omh6Tn6IuLT1RIqTeM9Qdq2RzAoEVUvx1Ql8hWt39jmWcbRNXyR0Jo
         2iYep/1Li+3yfLaGVo49r2RhU6s9nBmg0TSK5DdhkV5Uaxz1kWoR8uGqQD+yg72o2mJq
         b0lS5HITU8p7suFwnVpSSquJBbVIcAYxlK1aie8QVsTzKDi1VY9DWBsTPE9dNi98dYqz
         cnOqrit97OcJNmuJPcFfKPJCPqGtfrOPgcKhtcbOEW8E/iQhD+i/+yFFWubK5BFZeaER
         6L/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762248023; x=1762852823;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ltNFnYEQmixQZpMP12HbSmJnNGHT1YgJ5lkpfeO1BNA=;
        b=qvrhI454g/BVV4ZTDztBGsjdWinSKzn+XyXvaMbpCpxEDwsXDuZC19W6vVa7v5mHeB
         uZUthVkF4sLRTPIiM1DeR0kJvW1OkKF8MhLCcLKCkkTMnpwUL7glKv/7/1f+s/POSMB+
         qWSxpeSmHtB6vF+TTp13KLT00vZGX38UXLGVAUvREqeBd7gOpNSt2BK4XxmMX3FuNuR1
         fvMNt4eUVuB0XAS1bXb+oFDsfhhET6KnbpZpGRQIczyp0BrYsUVmXJpwj6zXs8p/o6se
         vTXwahi+qGzYLA3UKcPFJFGidWmD+EpFbCx4OOkf+/zZwayHrmDZT2nf5/YaP73J1bSe
         PCdg==
X-Forwarded-Encrypted: i=1; AJvYcCVOwOe2Ybw0ovqHvX0hV8TZcRTMnr2yL/ceXqoAYAWsYcxjLKJ8vL43CelxVEbQEPDjxgvuzVabHKaQ@vger.kernel.org
X-Gm-Message-State: AOJu0YyW0uCBCW12gzwKFWBlUhHmc1hXNuzp+bseWq+VPXGG7zzySgbM
	nu7UP+NLKWrLdZShcPqnho6Ile00NnRQxNN1vfJPi3KvItPygp0SFd3UQW011naLKnO+KGUjv3e
	dBwzSjxA3TeDrt2RDc1/gKxQcUfAUvSxXkNemuWM/gPqFnZmppuvM+ZX/zq0IFC8=
X-Gm-Gg: ASbGncsMWkXx7nDbdQRCxJr2662QQm1QO4Mv1LGLxl53EBOImRcqxXV8FYkzbLytaO4
	METJ7gYdRZFrahDcIlPocabxNPDY/pBzPP17u0wjG9BgL9S7RFO4i9NXz2oc8wZ6EQuekvALuxw
	cvLjh9Y0/LSkgYisKdET2IqtmBLXbT/a+UVwAcRuaCu1jgVDv5jvwPJmCSEMxKfDsly007R2lKZ
	SKgdlyYnk0RieHZUdF//Dt8syy9QKqtDV2mC0rj+4yHWKKyw1hwc7UZ/YLrDHRzNGBSi3glPkNp
	uwHnrRzN24IvraPXwJKab7VWXJeKOK+psXJ88ioh6CBUaPZT0C1eD2HnKkgItiXfUr1e7JAH1dD
	AO4aV8v45j023SR3bMc0o/RGWobfN1oUa4Nv+agOJloG1
X-Received: by 2002:a05:600c:488a:b0:477:5639:ff66 with SMTP id 5b1f17b1804b1-477563a0172mr7271965e9.13.1762248023158;
        Tue, 04 Nov 2025 01:20:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/p/JinMYxs2wrDLzSGvdns88BAErQtC1F7WbaqV2NdVF5IW/VkWgEi7rHVWoViH0BqwGtQA==
X-Received: by 2002:a05:600c:488a:b0:477:5639:ff66 with SMTP id 5b1f17b1804b1-477563a0172mr7271755e9.13.1762248022677;
        Tue, 04 Nov 2025 01:20:22 -0800 (PST)
Received: from ?IPV6:2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6? ([2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1fdef7sm3539621f8f.43.2025.11.04.01.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 01:20:22 -0800 (PST)
Message-ID: <a0fee8ef-329d-4286-aa8f-b569b9e4ab03@redhat.com>
Date: Tue, 4 Nov 2025 10:20:19 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 01/15] net: define IPPROTO_QUIC and SOL_QUIC
 constants
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
 <c02ccb3edc527cbb1aa64145a679994dd149d0da.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <c02ccb3edc527cbb1aa64145a679994dd149d0da.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 3:35 PM, Xin Long wrote:
> This patch adds IPPROTO_QUIC and SOL_QUIC constants to the networking
> subsystem. These definitions are essential for applications to set
> socket options and protocol identifiers related to the QUIC protocol.
> 
> QUIC does not possess a protocol number allocated from IANA, and like
> IPPROTO_MPTCP, IPPROTO_QUIC is merely a value used when opening a QUIC
> socket with:
> 
>   socket(AF_INET, SOCK_STREAM, IPPROTO_QUIC);
> 
> Note we did not opt for UDP ULP for QUIC implementation due to several
> considerations:
> 
> - QUIC's connection Migration requires at least 2 UDP sockets for one
>   QUIC connection at the same time, not to mention the multipath
>   feature in one of its draft RFCs.
> 
> - In-Kernel QUIC, as a Transport Protocol, wants to provide users with
>   the TCP or SCTP like Socket APIs, like connect()/listen()/accept()...
>   Note that a single UDP socket might even be used for multiple QUIC
>   connections.
> 
> The use of IPPROTO_QUIC type sockets over UDP tunnel will effectively
> address these challenges and provides a more flexible and scalable
> solution.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Paolo Abeni <pabeni@redhat.com>

