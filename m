Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DC62E62B1
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 12:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762257731; cv=none; b=TMVGmUVXWxdiv2RMoACbSmtom+D1HZLv9V0+hJBesmPmp1H/7iAX9lhL8t6x8ybZNScy+hVp8fX1bkPIHWQqZ+yflN05P9P1ZxvOThpoFtAlKfD5VGrB5wKYxYeyg6hRtG5Pf/aOeI79n2QM+sa4aQOd/M/J8pTHWTuXoeQMOYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762257731; c=relaxed/simple;
	bh=siDD7cjBMuaNTHwQly3VC8x+1gNlvhrCrFOU/ZhsCNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wd3MEFA7nbsaHkYQmkI7Lze/LFJUYCplvqt33PvXaY+1LHYJD0KlQaPZ5I+XGiBI6EMJWPVXm7cqmMb0YmF8siJtxA0ijjrsI3YyP6yh7g7/q1r0HqpQLz5WOQfeCwXKc19nc/2lJ7TUeY1bF4P5toxUD4o27iRcrK7ilBXMV5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IkWiy7lc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y0elEMjD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IkWiy7lc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y0elEMjD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762257728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ssdJLqXoynRieLG0swAQ2kxDsi5M4pN7LUYQOx6mmIg=;
	b=IkWiy7lcIjrRPf0Z4zrZi4h/Q7zpnm0eUYBuz5ySqhC9VknORNqwIFczU+GIeDGCOXs2QI
	BQasaGtYbBQgTL4xkx7z4f1G8LyNZVJ3VxbGThWddLCqAPAfDsR1th34+PKE+DN2Nywu7M
	VcDcQKYVQVIop9qvBGK7mL6sd4SXfbI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-hvC5bUaZMguCtnarQffLPg-1; Tue, 04 Nov 2025 07:02:05 -0500
X-MC-Unique: hvC5bUaZMguCtnarQffLPg-1
X-Mimecast-MFC-AGG-ID: hvC5bUaZMguCtnarQffLPg_1762257724
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-476b8c02445so43888105e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 04:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762257724; x=1762862524; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ssdJLqXoynRieLG0swAQ2kxDsi5M4pN7LUYQOx6mmIg=;
        b=Y0elEMjDenT2G3KxN4nffSB9MsLujKvstr6X8WQWEQMvpc3waWEPtan7RU7T0zt0+l
         kSpdKoT8mR08+JF7Yr9wQXHMyZJS6ec1ZPbdE1hOPhRvMJEeBYjqw3RvJOTGZlkFBZ3U
         gUVoiWlNbCQ/apNjTTDoWuj4nKEHToM2e3Mz1LXzLq8m4jVpXXP1/tK3jfc/Bx56lzJ3
         EfSl9H9jDhL845QIPXZYR7YpnXuKvf8fvMpqeYloh+R7hQTnlKqdRWpvQhRME01GNpsq
         r7P9gl5cuxbHtS8z5qVQO7T6+vUJZFMEmdkb+suci1HGatTHm8yx0SMsqtSqEaZGgDjg
         SpfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762257724; x=1762862524;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ssdJLqXoynRieLG0swAQ2kxDsi5M4pN7LUYQOx6mmIg=;
        b=RoJayB4RlE8Aaa2lfmynxj4XJOYLU93s5L7fG1YWo5iOewWhJENmuho0uLrbYTk94l
         5g1O/H0d34mF5NXMN0Pht6LQmPAYYEzLnJQaMuBeP4QmVRIVSMYYLfZKmsslMIPlnUci
         8SGWftjgQnb0ULGEbDcHV9DHMOD93bQvnlvwM44undbvLQVUmlpvrHZttOjX4wUVj1MW
         1FnvvqS6nWrj6RCp1BRh0emI2PmeCNMCdZHjAWkBkp4yHUJS6cHsKZWhEIz2Vjjtfjo2
         xuJZCbbinoVe9SSLyZ0n8Xq9aGo3EL2pSdWE5JwYNVIieYueIP87OSFRVstjrAYccn4D
         mbdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVGl8hVySJHqetRJ49Riwt/sqFXiIXqz6wfK4ongCI//lQTWJ8C13+HJ6/7SLvm++/OxdkxlSHJr+Z@vger.kernel.org
X-Gm-Message-State: AOJu0YxxmL1bNMGj7L3+5JUoYiL/UXXxQndrTXvlcxgNQpKN0j4Bsmo2
	gzPvg5XAym17fKu9wCzUsBBx6ryHmVJ/YURhAsCnEGCh9/Oim1Ci+lYm3PYF41OucqwvCIXQ00S
	TaesACys/aXuhm+zJ833cva6bjdRjEYaLAB10WqI1P8tLdq7S0iv9lwxm1HinjCE=
X-Gm-Gg: ASbGncu2HijDc9Eu34XjY7pVdLM6SG80UWBxhELes/WFwFEJ4eIMQoHzpGaFkNx6LxT
	MAIFG0du6hU3+rwnkAYNJUylnb+5BWjTNc+UhqdUVGiBYYi/nEGRdEqS8k7etUe3N/+3vOte6ei
	X8Q2pQCMQRr9p5d1y+BoXCwZB/VPi7glPGREVGwteHB7nZ2YKNdM8GxFVNziIhGVHMpSfqH9DVv
	I3R42vIZdgglKjgTZYjl/W8Uxet2NSYi+7SAe9y9yxe6zsKJ3quLx3AinMRbwcTvnOZgej1lBwF
	wKCK6XEodiMWdB1g+TFm02ythyIV7YrFGGD1zQDXtw6vqh47f6ryWk101l3OOjMWQX+n55vnIvn
	BtWky0hGli3eL0qYpsuPiM8vcy8+zBaSI7sqen0MJTA3p
X-Received: by 2002:a05:600c:828c:b0:476:651d:27e6 with SMTP id 5b1f17b1804b1-477308a8967mr141057915e9.36.1762257724139;
        Tue, 04 Nov 2025 04:02:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEauK+mynBX5rWHPCWx1RsWJ73mWra6y4dymOB8ucAA4aBwaSotD7FEFCtCpoVpD7tQTjZ43A==
X-Received: by 2002:a05:600c:828c:b0:476:651d:27e6 with SMTP id 5b1f17b1804b1-477308a8967mr141057435e9.36.1762257723669;
        Tue, 04 Nov 2025 04:02:03 -0800 (PST)
Received: from ?IPV6:2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6? ([2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477564d83e2sm31565865e9.3.2025.11.04.04.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 04:02:03 -0800 (PST)
Message-ID: <43ea4062-75a8-4152-bf19-2eca561036bd@redhat.com>
Date: Tue, 4 Nov 2025 13:02:00 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 09/15] quic: add congestion control
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
 <32c7730d3b0f6e5323d289d5bdfd01fc22d551b5.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <32c7730d3b0f6e5323d289d5bdfd01fc22d551b5.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 3:35 PM, Xin Long wrote:
> +/* Compute and update the pacing rate based on congestion window and smoothed RTT. */
> +static void quic_cong_pace_update(struct quic_cong *cong, u32 bytes, u32 max_rate)
> +{
> +	u64 rate;
> +
> +	/* rate = N * congestion_window / smoothed_rtt */
> +	rate = (u64)cong->window * USEC_PER_SEC * 2;
> +	if (likely(cong->smoothed_rtt))
> +		rate = div64_ul(rate, cong->smoothed_rtt);
> +
> +	WRITE_ONCE(cong->pacing_rate, min_t(u64, rate, max_rate));
> +	pr_debug("%s: update pacing rate: %u, max rate: %u, srtt: %u\n",
> +		 __func__, cong->pacing_rate, max_rate, cong->smoothed_rtt);

I think you should skip entirely the pacing_rate update when
`smoothed_rtt == 0`

[...]> +/* rfc9002#section-5: Estimating the Round-Trip Time */
> +void quic_cong_rtt_update(struct quic_cong *cong, u32 time, u32 ack_delay)
> +{
> +	u32 adjusted_rtt, rttvar_sample;
> +
> +	/* Ignore RTT sample if ACK delay is suspiciously large. */
> +	if (ack_delay > cong->max_ack_delay * 2)
> +		return;
> +
> +	/* rfc9002#section-5.1: latest_rtt = ack_time - send_time_of_largest_acked */
> +	cong->latest_rtt = cong->time - time;
> +
> +	/* rfc9002#section-5.2: Estimating min_rtt */
> +	if (!cong->min_rtt_valid) {
> +		cong->min_rtt = cong->latest_rtt;
> +		cong->min_rtt_valid = 1;
> +	}
> +	if (cong->min_rtt > cong->latest_rtt)
> +		cong->min_rtt = cong->latest_rtt;
> +
> +	if (!cong->is_rtt_set) {
> +		/* rfc9002#section-5.3:
> +		 *   smoothed_rtt = latest_rtt
> +		 *   rttvar = latest_rtt / 2
> +		 */
> +		cong->smoothed_rtt = cong->latest_rtt;
> +		cong->rttvar = cong->smoothed_rtt / 2;
> +		quic_cong_pto_update(cong);
> +		cong->is_rtt_set = 1;
> +		return;
> +	}
> +
> +	/* rfc9002#section-5.3:
> +	 *   adjusted_rtt = latest_rtt
> +	 *   if (latest_rtt >= min_rtt + ack_delay):
> +	 *     adjusted_rtt = latest_rtt - ack_delay
> +	 *   smoothed_rtt = 7/8 * smoothed_rtt + 1/8 * adjusted_rtt
> +	 *   rttvar_sample = abs(smoothed_rtt - adjusted_rtt)
> +	 *   rttvar = 3/4 * rttvar + 1/4 * rttvar_sample
> +	 */
> +	adjusted_rtt = cong->latest_rtt;
> +	if (cong->latest_rtt >= cong->min_rtt + ack_delay)
> +		adjusted_rtt = cong->latest_rtt - ack_delay;
> +
> +	cong->smoothed_rtt = (cong->smoothed_rtt * 7 + adjusted_rtt) / 8;

Out of sheer curiosity, is the compiler smart enough to use a 'srl 3'
for the above?

/P

