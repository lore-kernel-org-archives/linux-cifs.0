Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D226B2F39CC;
	Wed, 29 Oct 2025 16:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754980; cv=none; b=ozgSrgtA3QVJGhECREaxip06aJwYR9fmMZOQnqRMTuLEJWoicYLWRzm7OyUJ8eyezW+OimvBLyp2YuoMBBB0hDkaNfAy0IhDACdnlb8MEUExSPRVKYXIrLYvMMI9WJHeFEdNr+tE5zu/TBHW0+t3CymEqhpx407UmVI6oeZ4QeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754980; c=relaxed/simple;
	bh=YA57eG5M7WA68qsSEXXXRV/b20cAOLMLbgoIWoypgNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I5kGK1ws+H8fQhwnUeYGKHUb2wE1Yqef694Eqmne6Sh4aTIt5AnbiQw2zygeasd7hK7iyrxB0jqmdAxJswCR7Rq0d7p5D/brRD+MvGBhPW4uj9JVacJg/RU6cz7ztbBmxUEaccoSdqKmNvV3pyCYre2rBAMkyoXSg6aJwCbSfwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0VLSR0kg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0VLSR0kg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=gD2pViEOJpNMQ0zGd2aRTONTqmkucaWTWeVZjhTvoSo=; b=0VLSR0kgn4fnof5leSwCIZtQNt
	Gk3fCWPuiAQheWsBDdEIgGEYMlDUQkx5LihTo+HF6479rRG6sqwifDtHYRvS9w10ua7c2D6uH4Nyx
	93scI1glVpy2pAmZhj/+SJQCFNhaHG+Fkgw+s4IwY+P973x2D2aJ4j4qFzZT2w+wf7TXe8NY5GXci
	jxBH/7FAYDBNE7qF0uIaMaxslUEQCaKnBvHzRK5nkDRL3dht+Er2ZZyh3SglFc0RTmHV3ZgeUcMo0
	diWf1CoXp3paNmIetgbH6NtJqt4yVauTdr0VrqQPMtv7CuPikTjpw18uR2WMycyCm/hOvLBdKxXYU
	QV6jpVOyF5E8nhzjwD2JggB4/5qRIDqQRLTVsT+fUMc4dRPQBE6lFRMokvoAOvWUf7BCWVy3OeqBG
	VpODUiiT87t7QlltLGKrdOOBmm2XQykAb8zaoEQRo8ZHE/W6cgO/X/P5EwQ4z95TLmyogBvs0ytmk
	eO0OemdFdSZVgOxTLEOKZEyO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE8wl-00BhKi-1M;
	Wed, 29 Oct 2025 16:22:51 +0000
Message-ID: <67b38b36-b6fa-4cab-b14f-8ba271f02065@samba.org>
Date: Wed, 29 Oct 2025 17:22:50 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 02/15] net: build socket infrastructure for
 QUIC protocol
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
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
 <91ff36185099cd97626a7a8782d756cf3e963c82.1761748557.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <91ff36185099cd97626a7a8782d756cf3e963c82.1761748557.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Xin,

> This patch lays the groundwork for QUIC socket support in the kernel.
> It defines the core structures and protocol hooks needed to create
> QUIC sockets, without implementing any protocol behavior at this stage.
> 
> Basic integration is included to allow building the module via
> CONFIG_IP_QUIC=m.
> 
> This provides the scaffolding necessary for adding actual QUIC socket
> behavior in follow-up patches.
> 
> Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

...

> +module_init(quic_init);
> +module_exit(quic_exit);
> +
> +MODULE_ALIAS("net-pf-" __stringify(PF_INET) "-proto-261");
> +MODULE_ALIAS("net-pf-" __stringify(PF_INET6) "-proto-261");

Shouldn't this use MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_QUIC)
instead?

metze
