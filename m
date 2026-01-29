Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B34345754
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 16:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769705605; cv=none; b=lOljOamM0mUPQQuMkHUOW0SJ3nQKchfc5JcAkJ6orUDflEymcwjzEP52NsbsvzvIM738fa7ymUZUPxeFqUM8+c8a7DdW6qkmcJR5c3t3CVNupnaXXJ7GGdVDqbSCvcj9v+oECGD718sfxuhasnu077zWsd4Cqqr78gsgTOiPlpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769705605; c=relaxed/simple;
	bh=WOGhGhsnQIX0JLxRhL6uuprL7CVf0Nxffn2Etmsupas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BK6wMYFtk2EuR6jHNBwcgLxOVKddHtyWYlBEIv5GXbbmOr5c+087Za41k9zOEEWlNQv26mlb26XiwIpy9MJAIcUKl6Rzyw8S8lo64BeZUMBv4nAOADpiJAHmSosT8wb8ZD4KXkKs5jJJVeVnczX7DbeYhLn3qQ+4oytcQa2+KhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a/MNHPCX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cx4bKnN2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a/MNHPCX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cx4bKnN2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769705603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bxsJZ4lY7/i7NTzxVza1t8bxhbR1O4VQ7g3k6JdX5O0=;
	b=a/MNHPCXAOieH2EuOzbb1eWwaCIuAq6rPmj127bwxtwly9V6Z+FTt5jQuEWd6a7nKnnIfk
	B5HYVADOtfUdRyfKbOc9qKhsEVPXoQFMX6SKuy+Nwai80ZnFTkmzBK9et7pT3Zqrr/eqvW
	QoUIIUAmvh5/cv2DWxvK98jg7FuTE9g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-ZPCVX6liO-idzw6cTT1Wog-1; Thu, 29 Jan 2026 11:53:20 -0500
X-MC-Unique: ZPCVX6liO-idzw6cTT1Wog-1
X-Mimecast-MFC-AGG-ID: ZPCVX6liO-idzw6cTT1Wog_1769705599
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48079ae1001so7835545e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 08:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769705599; x=1770310399; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bxsJZ4lY7/i7NTzxVza1t8bxhbR1O4VQ7g3k6JdX5O0=;
        b=cx4bKnN23xNlNPkjVSliGWzQOYhrdEjGo2U01yQ5oJXM6nDK7FrqQbEw4KDWMbSk08
         bR3+ek+VXil+s00UnNPRv6+QKZzNxMLNEWhRz2R3CcHpYaPRo+o8EUemjhBeeFdzmLfU
         5NF4++VOTJduSzXEHlqTHcLqyR/8dRh0YHiGRW9vJmokPJPkV8eKRsm83Te9ZS90gqQ5
         wRf5zYhxkI2iBORHx7LclJLjcn5+6+5b0abcYIZQBj5TgS3GI/IUPT/bMLPemLu1EAua
         1AbVcKX6gfKFSpIrpUPeeClvtI/C0NtqJznrCy087PXVC+jQA8vhH72HHBop3PsQH8tV
         a1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769705599; x=1770310399;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bxsJZ4lY7/i7NTzxVza1t8bxhbR1O4VQ7g3k6JdX5O0=;
        b=c37FnoaViChxM6wyiHR+mWdrxK5o/PPDdfZsP7ac9WzuLbQLp/kTj8GdRKKDx5+GGR
         GJiwlHtD5JK+CQbYT1qFegX04ts4nfrbybL8JOVPXUe82GWQkyU4AJtloSfXtvVfsv8f
         Qw7CiJDfGv+30C3pWbdcwOr66+kGYW9N2Q/2UeYs13x9Z/+f5OCDXB5HqT6V9xWDQsxU
         hLtaA2YEUSKiuAGGToCXWtZjEnq3rlc+koopf60bsulC49u3ukAE33P4aQ3l6+Yppi7W
         70KAPjnkai7SqeTZgi3xAkqYnBy15XdkqVL/MY0Emuu+MJ7u38Ps8TvkyP/nXzN0ciss
         Vezg==
X-Forwarded-Encrypted: i=1; AJvYcCWpiKZ2HV/pYsFe1Qqwy3+dAF5lmsIUS1dUSvpT0SvtIdhCmg+p5ru5Obi+DFE5yOA16EILw6QhWsnm@vger.kernel.org
X-Gm-Message-State: AOJu0Yw63Ae68X11JHwZeRSA/s0jycSMaRujdwT5rmkzCT/XobGjgZ6+
	30sPOAxAlR8wpNs86gGQT/+HLoeHWuOduqkAQUCv7lbYPk52OpH7aiqLwEYn/EuqOkWgkxdQhst
	Pg5/lfSGhIKNt03OmTCXTsHmtb9QzyybYjmcV6RuXsl1lod1ci5B8GlNLTZJw8g4=
X-Gm-Gg: AZuq6aJPu/CdMia2NBW0AFNMIsWG1ESblw0IfK8BujQnoNPXrQsTng4iY1dJyahtsKW
	kvQg1sxN6uevzFZDQ3QjaU1EuStb5YcNQUrgHsupvK9UZC2635SocRtfw/rgZU/KnKRjTGWUJW8
	hDPjgPmiaYPVR1A2pQHSSGegCynDjElgpx7HiMgTk2LIOuh1EnMBxQ6P2DODdl1n8jTy2OQc4/U
	y32VYNMW5UQZEW/+6UByqgIxKJKDX+j2s5yhs64DIA9oDady2Rp0CHO/nOelyrRwpcPScdhWJvJ
	cadSMqRjDx4T1zZBESyQUFhDm3/o1MI0Sio8jASnlfoZn/yWHqQbO2yD0MJC2lzXyWo95+pQJY3
	ALp2t+6DGBNI1
X-Received: by 2002:a05:600c:4e90:b0:477:582e:7a81 with SMTP id 5b1f17b1804b1-48069c2a907mr105133585e9.4.1769705598732;
        Thu, 29 Jan 2026 08:53:18 -0800 (PST)
X-Received: by 2002:a05:600c:4e90:b0:477:582e:7a81 with SMTP id 5b1f17b1804b1-48069c2a907mr105133265e9.4.1769705598230;
        Thu, 29 Jan 2026 08:53:18 -0800 (PST)
Received: from [192.168.88.32] ([212.105.153.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-481a5e195ecsm793975e9.4.2026.01.29.08.53.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 08:53:17 -0800 (PST)
Message-ID: <bbbaf4e5-1c31-4c84-adb4-dbb94b8d07f4@redhat.com>
Date: Thu, 29 Jan 2026 17:53:14 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 15/15] quic: add packet parser base
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
References: <cover.1769439073.git.lucien.xin@gmail.com>
 <46f93cbee41da1e1f7b7f408b17915fd93b39ec1.1769439073.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <46f93cbee41da1e1f7b7f408b17915fd93b39ec1.1769439073.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/26/26 3:51 PM, Xin Long wrote:
> +/* Lookup listening socket for Client Initial packet (in process context). */
> +static struct sock *quic_packet_get_listen_sock(struct sk_buff *skb)
> +{
> +	union quic_addr daddr, saddr;
> +	struct quic_data alpns = {};
> +	struct sock *sk;
> +
> +	quic_get_msg_addrs(skb, &daddr, &saddr);
> +
> +	if (quic_packet_parse_alpn(skb, &alpns))
> +		return NULL;
> +
> +	local_bh_disable();

Is this really needed? If so, it needs some comment explaining the
rationale, otherwise please drop it.

/P

