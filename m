Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C955674E;
	Fri, 30 May 2025 03:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748574640; cv=none; b=Etbk4+fI51XXUDFkWh0Mv9et+N79bXMV/Axmvf1OjCMDgXY/yL0rZK+kmDszu9tlbxY+I++m78YsiQiPW2nd7Erfqnz8Y01DWDExyScb86l9Pp9fA0/xjGnmWkJFYnI4WSyXPBtWRVDKNK0ejRCPZAyjiG0xFMwpoVJTjDLYEiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748574640; c=relaxed/simple;
	bh=hkEfxIGIB290SHPEhT67X7q7C6ARa2KJ9GpjAlN7Qzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h35ELqFgDmTPCE88/0lGXT1J48siqWihN4RcvlhSVF2NsbmsjHSg5KiM0rDKZQXF157M3TOpljCIJsZuIXTUF6v+NW1uj3KQ0wp2AqYC5tybuzhKoCkN5nVHXc6Wbohyh5Cr+I3SkmHd2ZzOCD+xGQkzrDFfBW74DfyQlS1xDso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QwWsMVlK; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QwWsMVlK"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-311da0bef4aso1623459a91.3;
        Thu, 29 May 2025 20:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748574638; x=1749179438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5j8iI/muZH0HoEiVkcaVfwdpuORHAipLl3VJN4bx9JI=;
        b=QwWsMVlKszxBYeieKc/WNdZFUbNNdw43b8tLD0MFwnTJYe/g9bsIfRpA3zHVJQzbxs
         1LFCTJyp3/qkEtYc1n8fNY8QPCy5avfENkATWV36p3kxEETRscVi4mvqGkSfiM6iK2qu
         Z9YfsoBfUUsUUP/R+jZjGOKJobWozLqxuAZmLY/0WoR3Ke8+OpGV6PGK4txKvilf8pHE
         0zvMOOVAzg14xNlDqX6yKuEhu7j0cnFN/evDmllQpRQfuXT1pismVdvCfV8kwYHQaBAI
         3nw2LG3AUY993VM4Hl8iS+Hz3gX4GyVk48d/5D3Vfc6QhjIiJsinQe2ed0a1KRSDRJmb
         93dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748574638; x=1749179438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5j8iI/muZH0HoEiVkcaVfwdpuORHAipLl3VJN4bx9JI=;
        b=a4j0H2XjndNYN+myD6+4DCO8rD6nP6neTQzf/frGnj/dQrSlbW7URM7PwQGKOiekl9
         J6w/ZIsJSFcew55KZZTcqQFUzpO5SZ5NDgI9fdG6RtW0u8d9VzlyRhctBE6KsT5WTJmt
         IJu/CLFH8jVe+/X/k1ou8C0szcwjXVO8VRIr9Q7k0RiZoh4e+FzIIrB9zt7/AbmNLCDv
         SP6fQQ0OI99tFzIDd1UD+/JoPVxUzMT1jDHOGiQ8YYGMNJYkatsIoh/6qD+UxxrNE/Du
         q0UuxL8/a2C5KDe8cjqCeB6mKtAg8DAyYoEal+DY+qIFtSVf/njUrbzo6DNLSE4dHH3C
         84EA==
X-Forwarded-Encrypted: i=1; AJvYcCVLlX+NCp/m8Kmx37RCSEdSTY8hYs+CEr1UlsYkP3FdEutCsB/sLC/mJjHdiYOjrWyL37hZAbKyfccF@vger.kernel.org, AJvYcCVQLI4VN+QBS/U/2/7JWBedYJCBBIN9jRLiIFAoj3lm0VuXuj/aW2gpnnBVc2aOhhsKuWnO6O6RCbI3rR+M@vger.kernel.org
X-Gm-Message-State: AOJu0YzYxjhEJFb7U2aBP+sdWmXiLxcKjC3qjxTqfcc3NQOYzzlTMNGh
	wpqCW6GPpXky6bbJJ9I0vCYE/ulHR6p157GKoocB6FRzf8khdjHR544=
X-Gm-Gg: ASbGnct7a9wiBjUrLeXRPHu54oTZTunL77nulac3T0VILB9SArJHiUaqYzERYIEZM1U
	qLWJ4Ma7TbEqiyymbLibFlQ+arSqZaBTHIHcJWKJS2tTX4VMAPtqMX5ss4jpiNjiGhgf0SovZxx
	6bXNFqvmL/n3BMAlpZne0uSMBfGw1CkUItNxvOsPlnHx0+0P1B9uImDoP2Qy4luWyhVLoq1amMW
	j9GGnUb18DiV7dciCc8ZCdBAU8bOn8LqJiBMjcDNzrHkfhN1n2yrjr9//eGTMkPSdQJ0oB8vXLl
	JbLB+rVZKAAnG/wdVZ6lHspGiqTJ
X-Google-Smtp-Source: AGHT+IEUYGSAJUjnvwTmZqX9UClCzDjgjC8oEcAmFpNi+wlfM1RbN0rR8y+amoSuAwPFD1DetRPx5Q==
X-Received: by 2002:a17:90b:388e:b0:311:cc4e:516b with SMTP id 98e67ed59e1d1-31241e7b726mr2531891a91.32.1748574638384;
        Thu, 29 May 2025 20:10:38 -0700 (PDT)
Received: from fedora.. ([2601:647:6700:3390::c8d1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3124e3d2af8sm244283a91.44.2025.05.29.20.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 20:10:37 -0700 (PDT)
From: Kuniyuki Iwashima <kuni1840@gmail.com>
To: chenxiaosong@chenxiaosong.com
Cc: bharathsm@microsoft.com,
	chenxiaosong@kylinos.cn,
	david.laight.linux@gmail.com,
	ematsumiya@suse.de,
	kuniyu@amazon.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	wangzhaolong1@huawei.com
Subject: Re: [PATCH] smb/client: use sock_create_kern() in generic_ip_connect()
Date: Thu, 29 May 2025 20:10:05 -0700
Message-ID: <20250530031036.3221187-1-kuni1840@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <01BDDAE323133ED0+e7d23f35-c6d8-48a3-8fe6-c23e3a9c64dc@chenxiaosong.com>
References: <01BDDAE323133ED0+e7d23f35-c6d8-48a3-8fe6-c23e3a9c64dc@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks for CCing me, Steve.

From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Date: Wed, 28 May 2025 12:09:01 +0800
> This patch is simply a cleanup that wraps the original code for 
> explicitness, the last argument of __sock_create(..., 1) specifies that 
> the socket is created in kernel space.

Not sure how you came up with this patch, maybe coincidence, but
I'm trying to clean these up at once on the netdev side, so it would
be appreciated if this is kept as is to avoid unnecessary conflicts.

https://lore.kernel.org/netdev/20250523182128.59346-2-kuniyu@amazon.com/


> 
> 在 2025/5/28 11:39, Steve French 写道:
> > Weren't there issues brought up earlier with using sock_create_kern
> > due to network namespaces and refcounts?
> > 
> > On Tue, May 27, 2025 at 10:18 PM <chenxiaosong@chenxiaosong.com> wrote:
> >>
> >> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>
> >> Change __sock_create() to sock_create_kern() for explicitness.
> >>
> >> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >> ---
> >>   fs/smb/client/connect.c | 3 +--
> >>   1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> >> index 6bf04d9a5491..3275f2ff84cb 100644
> >> --- a/fs/smb/client/connect.c
> >> +++ b/fs/smb/client/connect.c
> >> @@ -3350,8 +3350,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
> >>                  struct net *net = cifs_net_ns(server);
> >>                  struct sock *sk;
> >>
> >> -               rc = __sock_create(net, sfamily, SOCK_STREAM,
> >> -                                  IPPROTO_TCP, &server->ssocket, 1);
> >> +               rc = sock_create_kern(net, sfamily, SOCK_STREAM, IPPROTO_TCP, &server->ssocket);
> >>                  if (rc < 0) {
> >>                          cifs_server_dbg(VFS, "Error %d creating socket\n", rc);
> >>                          return rc;
> >> --
> >> 2.34.1
> >>
> >>
> > 
> > 
