Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F781DF271
	for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 11:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755775074; cv=none; b=nTJIikXDvzmMA7Y7IcTvrIbd7SAQ6Z8df+E5XfyAN4cXc1FqIL7ScY40ednL7WwVGD3mbqWyeytHmycX1w4saqqK+4vHKjt71iBv5sW+Hwl60DYZxEwaf4mUqzScr2em9QLjEwSvNITFV7+FNAEaxH9CS8o1aGCNILXmyTufqgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755775074; c=relaxed/simple;
	bh=0eZh22ExobVFn9QdpDSpMbExsBJy4p5TIuWrfygp2ng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NGmRv8KiFbjwLMeh0wekEj6Qn/4GxQ26nnNvyYgshO34GH1zdFkMenEp09u10PBea8z1habbPTLhCaCHku1F4W+f1uczXHTvmTV5x0vYFJj5gcTOgjKBZGls9kE+rgXHD3MloIQx4nJgX5GaYCQxXV0bawRUbjIUocXMZyH/+ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cKPwSyWm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cKPwSyWm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755775072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vTF7fdaBAf09RlYCJCvUZk3IkcMydLaKtpCtjA+Wsos=;
	b=cKPwSyWm0RVSYuUBxUqPmDYtMtrwwAZG8EAlPWbdtYnAE7SoZRcyygfzuBA15VwfzP7hTv
	B2GcZ5yY/MIOx/waJbakXOiOgbHFUQ93DZ7OL/Au+DaL7wI1E3D2XOjp/APT4mh05m1vQH
	3Hw7cQ+BBCDPJBMSqYb2ze+iEoZG0xw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-_9mpruznN8SULfbJegD-Dg-1; Thu, 21 Aug 2025 07:17:51 -0400
X-MC-Unique: _9mpruznN8SULfbJegD-Dg-1
X-Mimecast-MFC-AGG-ID: _9mpruznN8SULfbJegD-Dg_1755775071
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e87062832bso232018385a.2
        for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 04:17:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755775070; x=1756379870;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vTF7fdaBAf09RlYCJCvUZk3IkcMydLaKtpCtjA+Wsos=;
        b=jdnFjcirnfuvKElKzEGwvgy5ftkzah6pB9vKzfqXxQHhcnEIYrsgaLzjVUav5vi63a
         t5tQDoXeAHYTaiDCo8i6+vrLSybsGAp6YmX8sNTKyAe5jYqz8ENpA9/rQK7adx+EOnDC
         CeugffV2z9Aq3fJxzDcpuT34K1qbXp8G11pmDZvtlgxpXXDhQitYUMN/R2kzycpyn/IY
         aWWd3JCQ/+hSk15+zhtr6E/Eq5ZhLBZnKYfkAo3pdWh/5gnp90uRFOs/Y1DxepO6sKKM
         NjqWN3BEPiQ+5oGBjShgVpFU09Gab5bOGlzFvkH755KudNRBZlUvVLabkdjKhg0E8Hxw
         SMNw==
X-Forwarded-Encrypted: i=1; AJvYcCXVqAZuJUAyuA0pa59nxl+o3fRecIhgsmi5mW7gp+PI9mFMPiHXQ0a3hSDxsZ2dok4m02INkmj5y4Nl@vger.kernel.org
X-Gm-Message-State: AOJu0YzvVwwdUdYbTQ0oKF/7jodqToiEUaDKJqcvRbrGm2HRXrDfzK52
	LhrEKv6yuijrGkmK3Z7uAIr9Ze31DWYF2zpLqDGVMatvw/zxs8OWGXsk671hESw8uJ94XUr68NY
	25FkfQLFlS650DUD5DRFXeL7zniBm+Rns/l+CPx56JGKwbK+19qcOk0J3WTLY0tY=
X-Gm-Gg: ASbGncuo+sHWWhWkc+au4oXGIdvx9r++RxR0ipNTiHrJqsPpSlvHW4VGUAnimSrto0m
	0qZKgsNR7QbfUYFfIz6o9HupeWbpm7uOheH/1ebbxFIpVmWSjCdeCqcDT7rf+AHaAdQbZ8rhYrH
	dvGUIrvbbCME9FKu1LYGliALd0xoyftfqaV31lz8VQtXHqXcF0XRnjjyuNdZOLAP5gV3I4ZtY1S
	SNMIJPE1RPRDun7kWcvzqTXlBI2MvE2zfqnZ7471NTF24ikUs6ZCDFLYOXlVmlaSS3f5hGsa4fM
	bX6yQEeftnIxeUNs/ilaTac6HsGKa2g5JdZ4WUElxGbvnByktQKdsg3c47gK5Xj1PI+71zY2N3g
	fgWu77OnDyBY=
X-Received: by 2002:a05:620a:4153:b0:7e9:f820:2b87 with SMTP id af79cd13be357-7ea08ea6badmr221665085a.72.1755775070655;
        Thu, 21 Aug 2025 04:17:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKExl4TKOYXLwhVSd7hxOBflNKJUSf9wwh0aonmAI1AB6dLc57LZaBS4sxU5LAnOMYXuVEEQ==
X-Received: by 2002:a05:620a:4153:b0:7e9:f820:2b87 with SMTP id af79cd13be357-7ea08ea6badmr221660085a.72.1755775070157;
        Thu, 21 Aug 2025 04:17:50 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e87f16f9ecsm1080143785a.24.2025.08.21.04.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 04:17:49 -0700 (PDT)
Message-ID: <ec99ef48-c805-4ce8-99d5-dcf254f6e189@redhat.com>
Date: Thu, 21 Aug 2025 13:17:44 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 02/15] net: build socket infrastructure for
 QUIC protocol
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
 <0456736751c8beb50a089368d8adb71ecccb32b1.1755525878.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <0456736751c8beb50a089368d8adb71ecccb32b1.1755525878.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/25 4:04 PM, Xin Long wrote:
> diff --git a/net/Makefile b/net/Makefile
> index aac960c41db6..7c6de28e9aa5 100644
> --- a/net/Makefile
> +++ b/net/Makefile
> @@ -42,6 +42,7 @@ obj-$(CONFIG_PHONET)		+= phonet/
>  ifneq ($(CONFIG_VLAN_8021Q),)
>  obj-y				+= 8021q/
>  endif
> +obj-$(CONFIG_IP_QUIC)		+= quic/
>  obj-$(CONFIG_IP_SCTP)		+= sctp/
>  obj-$(CONFIG_RDS)		+= rds/
>  obj-$(CONFIG_WIRELESS)		+= wireless/
> diff --git a/net/quic/Kconfig b/net/quic/Kconfig
> new file mode 100644
> index 000000000000..b64fa398750e
> --- /dev/null
> +++ b/net/quic/Kconfig
> @@ -0,0 +1,35 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +#
> +# QUIC configuration
> +#
> +
> +menuconfig IP_QUIC
> +	tristate "QUIC: A UDP-Based Multiplexed and Secure Transport (Experimental)"
> +	depends on INET
> +	depends on IPV6

What if IPV6=m ?

> +	select CRYPTO
> +	select CRYPTO_HMAC
> +	select CRYPTO_HKDF
> +	select CRYPTO_AES
> +	select CRYPTO_GCM
> +	select CRYPTO_CCM
> +	select CRYPTO_CHACHA20POLY1305
> +	select NET_UDP_TUNNEL

Possibly:
	default n

?
[...]
> +static int quic_init_sock(struct sock *sk)
> +{
> +	sk->sk_destruct = inet_sock_destruct;
> +	sk->sk_write_space = quic_write_space;
> +	sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
> +
> +	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sysctl_quic_wmem[1]));
> +	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sysctl_quic_rmem[1]));
> +
> +	local_bh_disable();

Why?

> +	sk_sockets_allocated_inc(sk);
> +	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
> +	local_bh_enable();
> +
> +	return 0;
> +}
> +
> +static void quic_destroy_sock(struct sock *sk)
> +{
> +	local_bh_disable();

Same question :)

[...]
> +static int quic_disconnect(struct sock *sk, int flags)
> +{
> +	quic_set_state(sk, QUIC_SS_CLOSED); /* for a listen socket only */
> +	return 0;
> +}

disconnect() primary use-case is creating a lot of syzkaller reports.
Since there should be no legacy/backward compatibility issue, I suggest
considering a simple implementation always failing.

/P

