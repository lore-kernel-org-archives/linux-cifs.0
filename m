Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0362322097
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767883902; cv=none; b=mb1n5TAQc48l0kYb4GPdVtBneiPzmOY/GxdkL6UOcUKJ/x5Qp5CszdI2F9aIxfaeA8/vOHrnysQRjqaaznmQCbRBtBlRSB5OYx1EJ6BqbdJNdyPBj0E6ZR9x654VlFpCIwglyvWMAYpTej7Bavr1yDlS2N9xW7NIer5V7dRSSdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767883902; c=relaxed/simple;
	bh=DXhgONYeIS9bChdWRL5MXzxkLSKekfV9hllD3azG3T8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LnTzTPhGUDgBKhA1XSBeHl+E+5uFM5AH9+2lzdGqalVbQbzgMSUpbKAWy0/ybCh8AfwUeSsLBDG2qoZwWMLNQvs3zYU3e+4tdKMVEYFL+BLDBIYTjP8+fuat6Z/+qCS+QioWu/Z5nywRLzD3zstdr/wvyJi2FPWfLYwNagodcBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WZmiTmoI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dIEfseNO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZmiTmoI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dIEfseNO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767883900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOEaS67jxDLLnbL0hp6gXDx5hl4Xnwdn7lV77ig2jkU=;
	b=WZmiTmoIUofRl8sr8F9/HwP7/5eQAnMWfSJHHewdgtexOO0cFD0DlxLi297bdfe3L0msCC
	xz62p5OLndM0MEcOhj5xzq9y7Zcr6dvTNZKhRWLzXSAl4hbWGNnmFN6x/K4rLxBgJwrc2z
	BhjUsSgEOdWrX/6biakx/mYH/QMLPjc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-T41oOgOpNtuMpGuzlgCMiQ-1; Thu, 08 Jan 2026 09:51:38 -0500
X-MC-Unique: T41oOgOpNtuMpGuzlgCMiQ-1
X-Mimecast-MFC-AGG-ID: T41oOgOpNtuMpGuzlgCMiQ_1767883898
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43102ac1da8so2343538f8f.2
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jan 2026 06:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767883898; x=1768488698; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sOEaS67jxDLLnbL0hp6gXDx5hl4Xnwdn7lV77ig2jkU=;
        b=dIEfseNO62Kx1NSJgTPJ5FMkwWJ+jPWFVMC6bs+UknVBoRSnA17z8fU4y4y1fC12wQ
         ArkAbyOXw/dcyOCZq0VctKF0+UNDPc5MG2R3z1geE/X11mc7a7oryN1NfbiUotxWDCe9
         EvPUYEUeQIRajp6TOyPs79VcEdjZ0ZEqEeb1PhZk421Q9aVBiNw0SUMb6qJS31iYYsJG
         6I0GxHEokhUOZvIq9SIty4dMWWnF5No/bF3UPdRSja8mRQqPJE0bO2bX1wrgj8G6OqkW
         vc5QuI9a6BWvY/ZrSPvzI30z44PXFT6b3Te/ycbPU5HBOJDxOK1dVnmBwr6gwLhl+/A6
         2Xmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767883898; x=1768488698;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sOEaS67jxDLLnbL0hp6gXDx5hl4Xnwdn7lV77ig2jkU=;
        b=qV4ie41nRcDWCrxMZIPlyP4ex7PpxdFSvUM0krxnKRmN4p4uoSBKH+5CuhskPFdBp8
         aHp63MekP/T4UTwnP0/nB2lfFKUFKvIiCK1YKJHL+Vmju6AdrkEh6nOjAHnKh7oc+PIp
         gv228ijNeUAA3+4+9TvWMwgARslH/2ojrJRcAppoRWKck6WJY8+6v0bR06vrdjIEcAUi
         nqZIPEsyTakRFWeqzX6xkWllgBapEVmrkxZ4ihCYLl4mHvyrHJMy47yZwEPzNoGkRtBJ
         eC2oRRfo61xtqkK0nzbg0fbLivDeEY4n1ziHud+lHsJqXGbli0A2gIYN0/ivFF1zOcw+
         rHTg==
X-Forwarded-Encrypted: i=1; AJvYcCWuiOk4WAc7dLsq1uk7jfpg1QOMs1Yog5tjsyb0XiukfyO53NHz4cjd+1wL5fQTyhWQ7N8hudkJGS6M@vger.kernel.org
X-Gm-Message-State: AOJu0YyICrQSiIsy3fdTS5TD2mcnSDX7LBEfsiuQ5O2FkApqJvn1PqKh
	ENVMMbXVAvN62MNqM0j4yq6pePfSZ5Va3v78Y+/gfVec2QPq3cgU/bKzojJvfwQb+DsNB09c8LJ
	yWKgFt/LoPzo7eYTBiju80XHsUV96I1hLbB+Hc3fj9upLOff6SLKEUkK2iPTipqc=
X-Gm-Gg: AY/fxX6Cpvv4/GTa9914/y3hGn4kiNtERGLmHR8HziLWA7ZfYrnuIXq4diuWPtLRvuy
	aCDLEhZCkQIlAy6WxJVTQwVtU8njEFTt2twhgi7qFyX4YxlDvQUoPdgTGgjVnqthv6P5ld7zlgD
	7r+q8AhDupjwdqoJ+/H1tWz1ge01JNGbpEWdG7yaCesHxmHXKq+x2LRCkhPiz0BhwxwpSMtMuOT
	Zl7T8RGiAkoim9Xhoef+subeQHjpmh1o9I18eqIM0sMjsLiOAy51ea+vAgXYDK/dke6hrGnPeEc
	6/KV5lJcu/gZIMXc5Dw9SEc3PISDH3DaZxT+7Fp/9BO9QCzKyGv/X7eVN5Cj21+K0WROm1pA+ST
	gLovXPEum0lz+5A==
X-Received: by 2002:a05:6000:250e:b0:430:fd69:9926 with SMTP id ffacd0b85a97d-432c377ece0mr7284115f8f.28.1767883897579;
        Thu, 08 Jan 2026 06:51:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGl69o07nid1rtv2ElvvEp5emJMaGD57S1+3wGIJzICQrcTyqY6I1e4bFP5EYxEC7EOfbCGWA==
X-Received: by 2002:a05:6000:250e:b0:430:fd69:9926 with SMTP id ffacd0b85a97d-432c377ece0mr7284095f8f.28.1767883897151;
        Thu, 08 Jan 2026 06:51:37 -0800 (PST)
Received: from [192.168.88.32] ([212.105.149.145])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ff1e9sm17585141f8f.41.2026.01.08.06.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jan 2026 06:51:36 -0800 (PST)
Message-ID: <32c5dc26-d200-4c45-bcd5-3739699e39eb@redhat.com>
Date: Thu, 8 Jan 2026 15:51:34 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 04/16] quic: provide family ops for address
 and protocol
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
 <d6526f74c99731fa08bdd43f97330f9c2dd78e43.1767621882.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <d6526f74c99731fa08bdd43f97330f9c2dd78e43.1767621882.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/5/26 3:04 PM, Xin Long wrote:
> Introduce QUIC address and protocol family operations to handle IPv4/IPv6
> specifics consistently, similar to SCTP. The new quic_family.{c,h} provide
> helpers for routing, skb transmit handling, address parsing and comparison
> and UDP socket config initializing etc.
> 
> This consolidates protocol-family logic and enables cleaner dual-stack
> support in the QUIC socket implementation.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Paolo Abeni <pabeni@redhat.com>

