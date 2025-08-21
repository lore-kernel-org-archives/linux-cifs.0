Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A463277B6
	for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 13:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755782266; cv=none; b=A1dMM+iSecV8uegSZ+eRNlmNheJQgqwARt3wxCf/FJ/h8JXF/ZVCA8uBuRcH8uvAvlBPCFxSY7yCjv3DPFRdOJ8vXiBxxtNuX9OCE4F5ZPeO302qawL1XadL6J94AnfpMfOCjoc7NdSKqChc4hvnWeKlCfQq7bplGICZJsjiZ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755782266; c=relaxed/simple;
	bh=bwFAOQRH2KQYfE+CAuwfRyBLCaRld0/730EcCpxmlXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XIKe88U5qWobu4TVlWUjFX8wdS/tuXW15w52IgB3viccjOeq910z+2pFdXKTzfqJlpYEjWeiCsyQnng/38CnszOf/xenhMxzenIaO5BN4T45Qg71dJbn0bOBGDljtHuhQjvGTLuubNC0gTTraPSF/TdxQDMsAo/uaZUATAcYJO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Embb5ciC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Embb5ciC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755782263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Afy5XNBwcOSovwamEVwVUrdjuD01YmpHvgt60RHlLnE=;
	b=Embb5ciC1t/rOl6awtAyYDUxpUJ8zL035GV5QpbL6Ct41pc71uBIQhcvcTqmyxJlGgytii
	XqJ8lJUU7+fQz3Am+shQvWtCAUWHkx2jO2Dn5U3lAR7YP95m1rJVu0WzrNZtwNY+WtS0pG
	POfg24PcmwX5AzGmY7n8fk+Iz1BL+T0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-yzsEq3zwMB6ffF_RIJc3fg-1; Thu, 21 Aug 2025 09:17:41 -0400
X-MC-Unique: yzsEq3zwMB6ffF_RIJc3fg-1
X-Mimecast-MFC-AGG-ID: yzsEq3zwMB6ffF_RIJc3fg_1755782260
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1ad21752so4356155e9.1
        for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 06:17:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755782260; x=1756387060;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Afy5XNBwcOSovwamEVwVUrdjuD01YmpHvgt60RHlLnE=;
        b=QPimuJyxP8OHusHfPc7wAQf9xeRZQuiyhCyYP0v3+0zC42257dK0XUMRkLDZ+njV6s
         7q5Rn+tADJxTzGx0CUzGf74se1wGf4quvu7C8nuwjYu9D6SjKk/tUzlGOYdCNP1otBzW
         eN5A/zZj0pSeHD4/eC4WPV0/P0iJoStApK6SmJRDQw+d3auFkwk+Otb158YymRqep9v0
         ygbtQGdedHQ14jN8iYOGRSU7/OAJH0dy0icvV9ZYZK0+Ol+zCj7zMwrwmcU5ERB5E4iy
         mhSPiq3KAuuocx0F2MEeFyqC8O9Tb0x8N/D2jJ4F+gLWkYSXpThj9xzNZYTKy6NoLp4n
         jG1A==
X-Forwarded-Encrypted: i=1; AJvYcCWGjxppMd0IZswrZzPJyzMO2hsFZ1dKPfsuMD0/fWY0RUzWsU0hx2SGXpQn8iSBUnHvJpXmSvt4aGrO@vger.kernel.org
X-Gm-Message-State: AOJu0YzSxYiUqXNxgQXI4Hv9et8dHS869pXr72w6smGQeIWTLSMwcC9n
	Gb+ZC4rljkDWZBh6nPIjC2M40PJpDzRJoEcRsW49hFN0ZmKNqLy+D4GpYueWaGbmevlKD9nah4F
	SjaxSeeiKkSchG3py7dsOOGDEpqasiPFv+S1Y3Nl/0lbnmRc/pocAESX86lCinMw=
X-Gm-Gg: ASbGnctgitFmk6HlkwIAx1VzeQVmBFiMjrj7FFf9CUMTEptvJgiPwCK4hCKQf9Dh2nZ
	An5eh0dHG81gMdFpXIA/lNcvaxmuDy2I9W3NY5VS66vE2WmBNdyonm/QePZzoa/226AFL8EYmby
	jCV95a4IiRnTigDVzEQLjpvk1cZKaWBp8n5Fp35BqMT1gW+In4RH2GRZPuxNu0+xE3z6SaYV5CO
	oPmnllXQdAx1ATWFhRQhxjrOLclMj930tkSHHAaM6AV+We8zmDwpuVpXsHlgMpnFEl6RN09S9pL
	BrE/W4vagX0GKE1cAW8Ng2dp5NyAnF+mtODbe6/bQFZz3l2pocDcEYIE0MGvOb6e/bcSH70dV7x
	7H61g058Sy4Q=
X-Received: by 2002:a05:600c:1d01:b0:455:f7d5:1224 with SMTP id 5b1f17b1804b1-45b4d9e900amr21732855e9.9.1755782259928;
        Thu, 21 Aug 2025 06:17:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKup3Bv+uTuJGCC0dd8vM3UgErwkB4o60xSOsgAT0YbFG9UXZs/zd4wk8y+8JlORfOl0DGxA==
X-Received: by 2002:a05:600c:1d01:b0:455:f7d5:1224 with SMTP id 5b1f17b1804b1-45b4d9e900amr21732515e9.9.1755782259493;
        Thu, 21 Aug 2025 06:17:39 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c3fab22726sm4908227f8f.37.2025.08.21.06.17.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 06:17:39 -0700 (PDT)
Message-ID: <7cfc62a6-b988-400d-829a-306211e1a156@redhat.com>
Date: Thu, 21 Aug 2025 15:17:36 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 04/15] quic: provide family ops for address
 and protocol
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
 <d208163af2fdd4c6ca5375e1305774e632676e5b.1755525878.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <d208163af2fdd4c6ca5375e1305774e632676e5b.1755525878.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/25 4:04 PM, Xin Long wrote:
> This patch introduces two new abstraction structures to simplify handling
> of IPv4 and IPv6 differences across the QUIC stack:
> 
> - quic_addr_family_ops: for address comparison, flow routing,
>   UDP config, MTU lookup, formatted output, etc.
> 
> - quic_proto_family_ops: for socket address helpers and preference.
> 
> With these additions, the QUIC core logic can remain agnostic of the
> address family and socket type, improving modularity and reducing
> repetitive checks throughout the codebase.

Given that you wrap the ops call in quick_<op>() helper, I'm wondering
if such abstraction is necessary/useful? 'if' statements in the quick
helper will likely reduce the code size, and will the indirect function
call overhead.

[...]
> +static void quic_v6_set_sk_addr(struct sock *sk, union quic_addr *a, bool src)
> +{
> +	if (src) {
> +		inet_sk(sk)->inet_sport = a->v4.sin_port;
> +		if (a->sa.sa_family == AF_INET) {
> +			sk->sk_v6_rcv_saddr.s6_addr32[0] = 0;
> +			sk->sk_v6_rcv_saddr.s6_addr32[1] = 0;
> +			sk->sk_v6_rcv_saddr.s6_addr32[2] = htonl(0x0000ffff);
> +			sk->sk_v6_rcv_saddr.s6_addr32[3] = a->v4.sin_addr.s_addr;
> +		} else {
> +			sk->sk_v6_rcv_saddr = a->v6.sin6_addr;
> +		}
> +	} else {
> +		inet_sk(sk)->inet_dport = a->v4.sin_port;
> +		if (a->sa.sa_family == AF_INET) {
> +			sk->sk_v6_daddr.s6_addr32[0] = 0;
> +			sk->sk_v6_daddr.s6_addr32[1] = 0;
> +			sk->sk_v6_daddr.s6_addr32[2] = htonl(0x0000ffff);
> +			sk->sk_v6_daddr.s6_addr32[3] = a->v4.sin_addr.s_addr;
> +		} else {
> +			sk->sk_v6_daddr = a->v6.sin6_addr;
> +		}
> +	}

You could factor the addr assignment in an helper and avoid some code
duplication.

/P

