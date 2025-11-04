Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7322EB5B8
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 11:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762257008; cv=none; b=NhqUAHkSH2jhq+HvhauXNq0OSjRWYchF8MCUaaPNWNa8Zjc4Cik4hP/oa/ao+lOkSX36oi9d1uQATvnqiDkOtk4opZv97Rar838mGK4tfIt32eu34y4AeBsQMXWxPEiOaObRh3NHWn5MTmjnPnTwfcV/USxRRPADTkVY4FDClIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762257008; c=relaxed/simple;
	bh=cZ5gDjz2QbKshZsqDifQYTuFk5BFj4GdybCog3FXEJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kt5lHT0W8tVt7Fi8PuUmVWtIWJeSPMrxkw+SEdzsqIoeOwa54AUhqUPIr+52as7WkiykA2n69nzJkuWOOG68l7zvZBNTS9bqInhWUDhZAnRySJlE3SVW/VXhmMMQakGMPJ17ln3W4FbAr4B7x6Sk6Vm1Zf6Gv3dO+zq+ZqTs/mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XUgJZq4/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gm2uMext; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XUgJZq4/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gm2uMext"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762257006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7NKqzRwzFTMUyXUXOrE/y+2M+CzQozAf5NhVcAFiTKA=;
	b=XUgJZq4/Qr6aB6gfsgi76iGiWacQFkazbKwsaFmQoUmQQzsDhafk/kelJpHB/mh7BbClqp
	cYEwjylmPur34lka/aacPLBiUIF0S3T8LsqfFfbCwVTUnS69YE4vsSEjztQLbjyYXOpKD+
	bYs2YKAEI9LFyENqq2i2u1USjv7VSq8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-_3Yhd7PqPlaHUHzYig7QrQ-1; Tue, 04 Nov 2025 06:50:05 -0500
X-MC-Unique: _3Yhd7PqPlaHUHzYig7QrQ-1
X-Mimecast-MFC-AGG-ID: _3Yhd7PqPlaHUHzYig7QrQ_1762257004
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471168953bdso44102665e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 03:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762257004; x=1762861804; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7NKqzRwzFTMUyXUXOrE/y+2M+CzQozAf5NhVcAFiTKA=;
        b=Gm2uMextK4v9c8RcxH3DzdChT29mpShqZ4JbeU8Q8sj/v5l1a8xh3DSKXwJb61VQ2i
         3pMK4jjbwQu10wUDHyMciL0lm7Yl7xgfP1oCaqXQMqMycrqksZWFgeeQs/qEAvlo0zmm
         g83bca4KslGAQfGiRWeZP8YWyTDrMVnEUNpY9PhiYNqhI2/FOgNn5FLnWVsLZNrtgQDX
         yUKPv9tt/JYlMp31qC+eRC3Q6OqPpHQdkWMzPAnwggWb5SJ1+3zQH7YEReeUVBIpO93W
         HTyBTuxh8TUhK+eZavJbaN4dxEPCPXk6KZ4LyOUkFWGHkhTE1U4Ylb/opZqcvHEfjUOT
         QbOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762257004; x=1762861804;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7NKqzRwzFTMUyXUXOrE/y+2M+CzQozAf5NhVcAFiTKA=;
        b=UrrczEmelmdApDuy3s/Ag+NE7iOopIMSTIGcp5mj9q0/+mWQXnuErMEYytai4bKjar
         ESX+OpqSxaFUrrUcxU7fawjTbclwQebNN994d04UcHXd8BR6ebkZ/JUykhnUl6XrG5Rl
         fqct/W54alBFpovU49cVSK+rBDQ26phXKvFBMKCoed7s33MJuNidkwbMU3y05C5zP6tP
         dyd2qB+SPOXgWMa42dJ7Gft8Ism+UdSBbLXg+C445DKLjTnJ2EXuuaFu2N+qnEwE8kP0
         LKBrhBbvQlSpCerHHR75qLfZq85x/DpsNIIJ0lqpWs3A13M3WMSKZPKh0Wit/q8PNJEf
         jkRA==
X-Forwarded-Encrypted: i=1; AJvYcCXNW4ba1QuwbAyhiiY5uogZE/36VDJUvKGX/fXtrA0wB+eOl6QVg+5OvjuJeTfMXNBV15AfK8rRr5LN@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7OFDClMiIvmrtr8BkLYsaXhdphVyupa5M1f+lKIh9J7+pCihu
	YfxaMjH7haGsVIHs1xO6BTQSNyVIidc/WgVjSCyHYdwh0waVgaWJMEui4pzKzblFvjRnxkR9ntf
	EP4VG97LuEPQUMYV7iiPrWDVU+c45W6qzDivjGJ2jP2Audvx9rMoCyBmNH4G6ej0=
X-Gm-Gg: ASbGncuW07Mx1nFPv/TK0wWX/0YutcZ+TF69YDR7gH7LzvrvNZIW6hPm+IuYIoujPyu
	buX3VOi9jl//gHYEgkK3BNPWsjWkzW9QqHQYs0fI/P/Gatoaf2ENMDginwV79PioI+YQOApe5SH
	FZ/RmJD+lIth++RkIFcjZuZuQsVIRQMWU5JYVZJFPjfwiVHxvfmgSbn+NxiFjEG7lYnZUi0xxYR
	sBXETSvu2f7/4HLZfwfUC0NbDfFKbuTkTAA+l26YWUZNG3FsVriBCsJKksm8kW7wr0X02iaak6J
	FeoJByil+iJw44Uq6ryC7Rd2Q7w4SntaXeNOOt/h6yKUs3s7dGSUiiWXlIbAMrvuzv/azx4N9OG
	wlmp9z155ohjkvow9fFPKjp9EF7l72S6lyAoHKDQmeWn2
X-Received: by 2002:a05:6000:2889:b0:401:c55d:2d20 with SMTP id ffacd0b85a97d-429dbd3c7bfmr2751759f8f.26.1762257003797;
        Tue, 04 Nov 2025 03:50:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFrHCmmk8I9jZU38ly0GkES+iMhlTFtfqgEF6bGR4ojffkjtcXHlyZQ+AKtVRy8Dar+aGGTw==
X-Received: by 2002:a05:6000:2889:b0:401:c55d:2d20 with SMTP id ffacd0b85a97d-429dbd3c7bfmr2751707f8f.26.1762257003406;
        Tue, 04 Nov 2025 03:50:03 -0800 (PST)
Received: from ?IPV6:2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6? ([2a0d:3341:b8a2:8d10:2aab:5fa:9fa0:d7e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc19227csm4291317f8f.11.2025.11.04.03.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 03:50:02 -0800 (PST)
Message-ID: <914b0331-8fab-4ad6-a6a8-e511a4352cea@redhat.com>
Date: Tue, 4 Nov 2025 12:50:00 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 08/15] quic: add path management
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
 <0ccfc094d8f69e079cc84c96bd86a31e008e1aaf.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <0ccfc094d8f69e079cc84c96bd86a31e008e1aaf.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/25 3:35 PM, Xin Long wrote:
> This patch introduces 'quic_path_group' for managing paths, represented
> by 'struct quic_path'. A connection may use two paths simultaneously
> for connection migration.
> 
> Each path is associated with a UDP tunnel socket (sk), and a single
> UDP tunnel socket can be related to multiple paths from different sockets.
> These UDP tunnel sockets are wrapped in 'quic_udp_sock' structures and
> stored in a hash table.
> 
> It includes mechanisms to bind and unbind paths, detect alternative paths
> for migration, and swap paths to support seamless transition between
> networks.
> 
> - quic_path_bind(): Bind a path to a port and associate it with a UDP sk.
> 
> - quic_path_free(): Unbind a path from a port and disassociate it from a
>   UDP sk.

I find the above name slightly misleading, as I expect such function to
free the path argument. Possibly quic_path_unbind?

/{

