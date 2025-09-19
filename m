Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7D2BE7B5
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 06:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758264243; cv=none; b=V8nFrmIP9vNDGu6Q8qaU2GCPcc2+RxG0Duec7xPlIMU0GS/TQjzIVLkdPlOQmb2VbymV8vGziBWltifnAU9YgaqQXE/slE1cm5mBderKHaWVlr1upAZqmn9FjJSG2mzrfRhbeChytMDEX9UV9gKfbfTkDcDE2zbaGv/YUOoBN8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758264243; c=relaxed/simple;
	bh=oJL1088tzJ9Ynw4qu8KbOGHLxMaIiOI9jiYlvbVK2Ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R9XvoOe6Ffaa5V82wGVvlu6QUYk1qC8/AW/z/ggCnR/pwfPUYmb9z4TLYTzy/dLaR16grCnDeHFMKMQbbwOdKrvrikJBh+OusBrAuxuiLuf4DnDS8wFwyvDL/zD7CATOMAyfcV6IwlMhUp6a/5L/3g60Y/+xCfvaYQ9oqoRMg6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=S16y91gL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=inB+BuKM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=S16y91gL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=inB+BuKM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="S16y91gL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="inB+BuKM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="S16y91gL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="inB+BuKM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 744551F7D8;
	Fri, 19 Sep 2025 06:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758264239; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SU1XwyJ/x3FSkoNfvVK4PGz+1j7XItecpRFigL4nkW8=;
	b=S16y91gLcHLKBbq7oXWC4TNPrOmcniR2lG814SwRlzJidx45+7oNjyGwLdjE6WYXkufvlk
	DSHPgIvdHgiklgndY1FgJ2tPDQVyxQ02XY1pF++hjXavocLbDpIRq7P9/ByvkJspT7ioUa
	Lep8MdrYDHnFS6BJVIybimV4RSlGbQY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758264239;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SU1XwyJ/x3FSkoNfvVK4PGz+1j7XItecpRFigL4nkW8=;
	b=inB+BuKMFezEiIv8H+9cg46r47tUUC38CArwP28pj/tBBrFepGP9mn/Q9ieXZbaGmpfUnv
	mQ0xNOA83pxFr3Dg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=S16y91gL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=inB+BuKM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758264239; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SU1XwyJ/x3FSkoNfvVK4PGz+1j7XItecpRFigL4nkW8=;
	b=S16y91gLcHLKBbq7oXWC4TNPrOmcniR2lG814SwRlzJidx45+7oNjyGwLdjE6WYXkufvlk
	DSHPgIvdHgiklgndY1FgJ2tPDQVyxQ02XY1pF++hjXavocLbDpIRq7P9/ByvkJspT7ioUa
	Lep8MdrYDHnFS6BJVIybimV4RSlGbQY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758264239;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SU1XwyJ/x3FSkoNfvVK4PGz+1j7XItecpRFigL4nkW8=;
	b=inB+BuKMFezEiIv8H+9cg46r47tUUC38CArwP28pj/tBBrFepGP9mn/Q9ieXZbaGmpfUnv
	mQ0xNOA83pxFr3Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7142013A39;
	Fri, 19 Sep 2025 06:43:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id crMrGq77zGjLAQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 19 Sep 2025 06:43:58 +0000
Message-ID: <c64e0dde-ce6a-4528-ad11-bfe3a90c2623@suse.de>
Date: Fri, 19 Sep 2025 08:43:58 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 00/15] net: introduce QUIC infrastructure and
 core subcomponents
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>,
 Tyler Fanelli <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Benjamin Coddington <bcodding@redhat.com>, Steve Dickson
 <steved@redhat.com>, Alexander Aring <aahringo@redhat.com>,
 David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>,
 John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>,
 "D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1758234904.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <cover.1758234904.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 744551F7D8
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[34];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org,lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,protonmail.com];
	FREEMAIL_CC(0.00)[davemloft.net,kernel.org,google.com,redhat.com,samba.org,openbsd.org,xiaomi.com,vger.kernel.org,gmail.com,manguebit.com,talpey.com,lists.linux.dev,oracle.com,johnericson.me,linux.alibaba.com,akamai.com,protonmail.com,queasysnail.net,haxx.se,broadcom.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RLw4e9atw58x3fr1wmxctduz7j)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -3.01

On 9/19/25 00:34, Xin Long wrote:
> Introduction
> ============
> 
> The QUIC protocol, defined in RFC 9000, is a secure, multiplexed transport
> built on top of UDP. It enables low-latency connection establishment,
> stream-based communication with flow control, and supports connection
> migration across network paths, while ensuring confidentiality, integrity,
> and availability.
> 
[ .. ]>
> - Performance Testing
> 
>    Performance was benchmarked using iperf [8] over a 100G NIC with
>    using various MTUs and packet sizes:
> 
>    - QUIC vs. kTLS:
> 
>      UNIT        size:1024      size:4096      size:16384     size:65536
>      Gbits/sec   QUIC | kTLS    QUIC | kTLS    QUIC | kTLS    QUIC | kTLS
>      ────────────────────────────────────────────────────────────────────
>      mtu:1500    2.27 | 3.26    3.02 | 6.97    3.36 | 9.74    3.48 | 10.8
>      ────────────────────────────────────────────────────────────────────
>      mtu:9000    3.66 | 3.72    5.87 | 8.92    7.03 | 11.2    8.04 | 11.4
> 
>    - QUIC(disable_1rtt_encryption) vs. TCP:
> 
>      UNIT        size:1024      size:4096      size:16384     size:65536
>      Gbits/sec   QUIC | TCP     QUIC | TCP     QUIC | TCP     QUIC | TCP
>      ────────────────────────────────────────────────────────────────────
>      mtu:1500    3.09 | 4.59    4.46 | 14.2    5.07 | 21.3    5.18 | 23.9
>      ────────────────────────────────────────────────────────────────────
>      mtu:9000    4.60 | 4.65    8.41 | 14.0    11.3 | 28.9    13.5 | 39.2
> 
> 
I have been following the QUIC implementation progress for quite some
while, and always found the performance impact rather frustrating.
At the onset it looks as if you would suffer heavily from the additional
complexity the QUIC protocol imposes up you.
But that would make the use of QUIC rather pointless for most use-cases.
So one wonders if this is not rather a problem of an unsuitable test
case. From my understanding QUIC is geared up for handling a 
multi-stream connection workload, so one should use an adequate test to
simulate a multi-stream connection. Did you use the '-P' option for
iperf when running the tests?

And it might also be an idea to add QUIC support to iperf itself,
especially transforming the '-P' option onto QUIC streams looks
promising.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
