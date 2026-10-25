Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792951082;
	b=RRVNX4j5xLiyDD2YJpQ9F/Jt/9ltzlBYMHIEXysusfPdAOliJQlc7rwxnTtC36B4NB74
	 9ZKQ/KDVIF0jGSd9LzI93NQDR0kOnAVODcmPM7yW9oTmTVxLrUaPGc3UC35g3tu+MVXkT
	 k2tbusQ8tuqEs9JS0lJSFRDQtLjkPNYQqtrBysRnMGRy+OwgKkJQpMyzzz5TB0izEFO42
	 ZwpTv3qYVBulgeC9ulv9aVD9SJWZLgaihfG6Xci6LAMWKhSOOnLOcCXJazvquUP7R+NJ2
	 qFZHq99uNB3w0bEnqhoSrHMmTCYftWOB4D0dnE3DSPN5V7aLQq0ddel7aLQ9mhbSAJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792951082;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:Content-Type:Mime-Version:Subject:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=h/7CMMXb0XP5aeeK6rQQs5bYKdlB/H7i9hQ25pXziZo=;
	b=XdHlUkxi+JLRE/gyYyzEyCuRYDA6ql2+YlP07vT9h6hUtBscOinPbKQoNn533skl6Teg
	 Flak3/LzswEMt8wbIxMN7pGtTKyhKS4foQrxfSBs5e/WWZhz4ehkxXKt47GapU7w346ce
	 Z4DbRLec/EiU0WEtle2dANJrnrPEc/aac1IUSEdssUxtaQPpGogOt9mzNI8kFglc6vMZn
	 /qITcEr9r7xRLcnsmqx3P2pA6ZjlukwWEt4r7CTjCLy4PMTfIY2//yeTvBo+6jlNwmyGl
	 YPrJydoCxby8EMv2BHQK7SIr9JAeOaAa/7nO1JgSYERm/Wi8c3AYtBEhZNVpAn+wiag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=R1UmO7eV;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FFB606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 17:58:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29FFB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=R1UmO7eV
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4322d310e7so337138666b.0
        for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 10:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792951080; x=1793555880; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=h/7CMMXb0XP5aeeK6rQQs5bYKdlB/H7i9hQ25pXziZo=;
        b=R1UmO7eVu7WDISFDPX8D+6yL3wZcIlWn4bBK/7lMVDqS8x+40CHubiJJDlUlNx0w08
         gu4yAMB+K1wh5q22ZN9DPpMEapMPgSUqbnoHqrZ1Dm0dUip0+vhOcsvKkmiMUnjzOzJi
         91upT30T5dkp0ar5oX6gpzYNjqeiBBlhDpS/ezSZLJzZH19Ebym5V9qle/wTW+mpZNxf
         MCZQELS9uH1levcBIUcbNqIdxU1TV+m+hQ/aOusv4T4sWJP4vtX+KDU61vhuQq9aY1gd
         2JFBlh8MnRDnRAazIG3m6uNBJUBENMvx+jKW5WGmKnxz+we+fVLZSj/EYEk+LXHbVo/R
         nG0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792951080; x=1793555880;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:content-type:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h/7CMMXb0XP5aeeK6rQQs5bYKdlB/H7i9hQ25pXziZo=;
        b=cA2K/Zmb35EX7mcv15EuWoQz5x3ut6vKaTfNJ8jF+KRpgnVbYOijkheeReq/MRIreV
         qf8dXX0libzIn64iYG0JrqVbpbeRQlz0o2RpH8OxH9vcIZtVFFdiq17/lUAQ8VKUOaai
         OsOpodtUFkXJZXyuwr7OYQAFiaKAo7s4xnptvuuuo/2+9Sgg0b9H/4VH3bF4NqwzoF8K
         ecaN+DJPWuU7FiNW0dDbqxOJJx5DkzdKi0ym0jYjKcN3Mlr3zyhnvmo5N2oKdex+xAot
         Btg5ef4YRVGoXRXfkfg850uC54Dlg7qDq4FzBHceDgbETix8PMGd14idlTTRSy58QNgZ
         6nwg==
X-Forwarded-Encrypted: i=1; AKwUvBzB+vmz9ynKNGYt8GetGw5yPkZ+n386xPoae4KFQsjPFTUeo/R/FMpjkd4Vl2lsNcUAq+cmSXfqK/b+@vger.kernel.org
X-Gm-Message-State: AFq9FYJilRvMBsfW+FqWEN3/dcJvHs9+TQczZPZGk87sFVqD+uVKs+qW
	8EvyxEEs3JBGXefyPCa9SqJlJ5PVy/yAKcffzvxhxYFmhmYb96Rw+ltV
X-Gm-Gg: AYBFou1JOuo+gacxwJJaB/Tkg0JR2GiBKd4Yg303CtvHMwq2GtxO7Fks5/7d6PZQPGD
	0baTC5syOcwcUZCj6rmMQxpqJYpa39LHi667Z19riK9nQsfYfgyCp2atpXLKA7s+DR3czYiUsWJ
	DNlp3ncMsoQpVoGMEIWgde/0jnBuRPsLz0yvKGjzXDsDy3onudn1lS1D0W5jAKt3ErLnshk6B4T
	2WxSRqlpdq0qc3Kr4l0FXb0oIhz0M+PJRKVZJtrHubNigXGRzVAKO85UR20T82B1kO4DfQ54lrP
	9954IcedeVjkKZ5BC6bpa6MBuATW2lL1679I+jQTU6t0CSY1MCT6zCncPXoVJ+zUTuyM1ajyN75
	O9xpb5/maGBmpqZ5dmLX8Jqu5GftFwXboAcBa9ltjr3NSys3MnmkXWcuKJCZTQ2JXS0gNfKFeJ6
	nxr8PxXQYMnePr4umlrZF04X2VRXVTGKu1wNVi52UbwiMAzoSk5ieSy40yA1UVGQTphHoMzEN/3
	WFqAld+5dY1iw5mPFFgkaokIa0JpgF7elDbUwr57c4PBuuFk8eLtf2Np75agiLtvhW+qyi/532N
	RkHlS2HYbE41yOQD6OYojOQRP0+Qi3xki9/T0uT2tiDLmD2Twi3eBrJ1JN4=
X-Received: by 2002:a17:906:7953:b0:c24:6985:d7a1 with SMTP id a640c23a62f3a-c46bdaf8b32mr614431266b.7.1792951080433;
        Sun, 25 Oct 2026 10:58:00 -0700 (PDT)
Received: from smtpclient.apple (wlan-199066.nbw.tue.nl. [131.155.199.66])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd66fa1asm226620166b.62.2026.10.25.10.57.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Oct 2026 10:58:00 -0700 (PDT)
From: mixalhs <mike.michalo@gmail.com>
X-Google-Original-From: mixalhs <Mike.michalo@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [syzbot] [cifs?] KASAN: slab-use-after-free Read in
 cifs_crypto_secmech_release
In-Reply-To: <e071a5df45f7ccf80a9d899749e09e11@manguebit.org>
Date: Sun, 25 Oct 2026 18:57:49 +0100
Cc: bharathsm@microsoft.com,
 linkinjeon@kernel.org,
 linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 ronniesahlberg@gmail.com,
 samba-technical@lists.samba.org,
 sprasad@microsoft.com,
 syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com,
 tom@talpey.com
Content-Transfer-Encoding: 7bit
Message-Id: <18D91F35-4165-4679-A3A7-0B8F9A9E0F5E@gmail.com>
References: <8bb0534e33a5f5d152d2b1768d1fd7c6@manguebit.org>
 <20261024184605.44432-1-mike.michalo@gmail.com>
 <e071a5df45f7ccf80a9d899749e09e11@manguebit.org>
To: Paulo Alcantara <pc@manguebit.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)

Hi Paulo,

> On 25 Oct 2026, at 18:29, Paulo Alcantara <pc@manguebit.org> wrote:
> 
> Could you please try your reproducer against
> 
>        git://git.manguebit.org/linux.git cifs-next


Done, on cifs-next 9bc48fb48a3, which has Eduard's 77f5fbc2d0af ("smb:
client: hold server info until cifsd exits"). UML x86_64 with KASAN and
PREEMPT, with the same debug msleep(10000) after tcpStatus = CifsExiting
in cifs_put_tcp_session():

 - cifs-next: no KASAN report (the C reproducer once, the Python one
   for 5 rounds).

 - cifs-next with 77f5fbc2d0af reverted: the same slab-use-after-free
   in cifs_crypto_secmech_release() as syzbot, freed by
   clean_demultiplex_info(). So the reproducer still hits the race on
   this tree.

To see both orders of the final put, I added a temporary pr_info() in
cifs_tcp_server_put():

 - with the delay (5 rounds), cifsd drops its reference first in
   clean_demultiplex_info() and cifs_put_tcp_session() frees the server;

 - without the delay (50 rounds), cifs_put_tcp_session() drops its
   reference first and clean_demultiplex_info() frees the server.

No KASAN reports in either case.

Tested-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

Thanks,
Michalis


