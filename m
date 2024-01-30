Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C567AE5B;
	Tue, 30 Jan 2024 22:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654638; cv=none; b=Ecy64gabtzxOwCAfFWWTK/w26OYWAGCJualp7wS8ajXW4jNytwezNVrRnmJHUUmNBr+ieRQHeVOnURvivc0PGv1qwWtd9AAYj2eL3F89Roy8QU5bdNhvOIQFpUPR91cxFQyOvx7YBVN0WZMgszDdm9aboomnSe+sDMz6wWjPHeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654638; c=relaxed/simple;
	bh=JsQhwuGrZMtViDvxvJKfJkvE2n8Ybw7wD1zinEFujmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDhL7FB0WnzXHzw8YAKLZaSJBX2jGCwWu/aiiQu+TxPmXtP7UafZ8TdzgJXnyNQ6+zCh4PcNzBSHpwCBhxm17xo8tsOKgPuaiSbNwCb1Zy07nEVrUY3dwRzU6CZTka4ylv/JiHKAVFzu8cmQhR93n9OZjxmHHik4Q8efC4jw8oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nWAz4G0f; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nWAz4G0f"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a3604697d63so271540066b.3;
        Tue, 30 Jan 2024 14:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706654635; x=1707259435; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZRDK+Smf4I0g9+6IXWqW+oV9u9CZnWJjpwATTXUI1t0=;
        b=nWAz4G0fQrpG90d5/OVWD5dXs0BdqybVqzfTDT9XXW96u+83pTSUT+UYGWrQOGyJ/t
         Nj80JwOfDQ0cSYbEvjdihgr9tkU1MwxB2p9zXLfYwo2ILWutZSrJlpY7XFQRgvhQGgFK
         S8YwrqfgiyQFNMSWly7ARjJKyMyF3UVqSVhwcifc2mf9WYvDmT1BBFto/MlzWmV8ZepI
         4AvYw70tiDIEu7Pr9L5fjsXPSJkfDUV9VNUE/b522BLsvs9CVxXeQX32HuRg6dDNgojQ
         j5vNqluixuY8wPBeth0NVWEmggZT67dheAHLmc/ddom9bc9tkbmQ+HpB601tZE1xtSHJ
         tOFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706654635; x=1707259435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZRDK+Smf4I0g9+6IXWqW+oV9u9CZnWJjpwATTXUI1t0=;
        b=joyVSav04czjpava3h9jCOOuOK9Daa/MapXLeMQZtoMQPkVG0i584dUZWKRamqejTJ
         heAh5x2YEPHGhWQvq1k0+z5RRbbdDnmyvISM+Mq89U8TLPC0VSuBuVY/bOZ8vk2JUshe
         M5rqt6zuSmmkDNWPPWYNbboQqIE4omC7q+OEm0nwODGIwWe5xGfuun88uFplnepvr9D1
         t7IdjVqJKwJDO1B/loo3Cpwpo0X0wq3NkLXCIZp+rUa48I1PDQdR8TcR/sOzRi056a3Q
         tRNUq1N+fGK1aATmdqh22q1UDEE9vzVka5tkvSZ4rtb2JIYDYyNqWSRFvyYO35nrL7ox
         oNdA==
X-Gm-Message-State: AOJu0YxADbN259HD++j674AYDjkyYYmUYbRZLC5nYr7OEhwGnyJrfn3E
	61XibxLd/7PINAeMGvR4zKp5LIuZ7Q5suaJ1V/jq5YgxhVpBCv3z
X-Google-Smtp-Source: AGHT+IF+RaRMKzBQZlFwM6GHJmfferHLON2cUoM1E2WHuZ6IZDm7V++xNRPxts7v/4Go0Wog5nmWPg==
X-Received: by 2002:a17:906:46d9:b0:a36:63d6:1861 with SMTP id k25-20020a17090646d900b00a3663d61861mr354282ejs.35.1706654635067;
        Tue, 30 Jan 2024 14:43:55 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id vu2-20020a170907a64200b00a35a9745910sm3015892ejc.137.2024.01.30.14.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 14:43:53 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 1C74CBE2DE0; Tue, 30 Jan 2024 23:43:52 +0100 (CET)
Date: Tue, 30 Jan 2024 23:43:52 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Paulo Alcantara <pc@manguebit.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan =?utf-8?B?xIxlcm3DoWs=?= <sairon@sairon.cz>,
	Leonardo Brondani Schenkel <leonardo@schenkel.net>,
	stable@vger.kernel.org, regressions@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	Mathias =?iso-8859-1?Q?Wei=DFbach?= <m.weissbach@info-gate.de>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Message-ID: <Zbl7qIcpekgPmLDP@eldamar.lan>
References: <8ad7c20e-0645-40f3-96e6-75257b4bd31a@schenkel.net>
 <7425b05a-d9a1-4c06-89a2-575504e132c3@sairon.cz>
 <446860c571d0699ed664175262a9e84b@manguebit.com>
 <2024010846-hefty-program-09c0@gregkh>
 <88a9efbd0718039e6214fd23978250d1@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88a9efbd0718039e6214fd23978250d1@manguebit.com>

Hi Paulo, hi Greg,

Note this is about the 5.10.y backports of the cifs issue, were system
calls fail with "Resource temporarily unavailable".

On Mon, Jan 08, 2024 at 12:58:49PM -0300, Paulo Alcantara wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > Why can't we just include eb3e28c1e89b ("smb3: Replace smb2pdu 1-element
> > arrays with flex-arrays") to resolve this?
> 
> Yep, this is the right way to go.
> 
> > I've queued it up now.
> 
> Thanks!

Is the underlying issue by picking the three commits:

3080ea5553cc ("stddef: Introduce DECLARE_FLEX_ARRAY() helper")
eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")

and the last commit in linux-stable-rc for 5.10.y:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7

really fixing the issue?

Since we need to release a new update in Debian, I picked those three
for testing on top of the 5.10.209-1 and while testing explicitly a
cifs mount, I still get:

statfs(".", 0x7ffd809d5a70)             = -1 EAGAIN (Resource temporarily unavailable)

The same happens if I build
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
(knowing that it is not yet ready for review).

I'm slight confused as a280ecca48be ("cifs: fix off-by-one in
SMB2_query_info_init()") says in the commit message:

[...]
	v5.10.y doesn't have

        eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")

	and the commit does
[...]

and in meanwhile though the eb3e28c1e89b was picked (in a backported
version). As 6.1.75-rc2 itself does not show the same problem, might
there be a prerequisite missing in the backports for 5.10.y or a
backport being wrong?

Regards,
Salvatore
