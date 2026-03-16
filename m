Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341FB326D45
	for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773681821; cv=none; b=cUjXiyW9NkdXiq+qslUoFOj25+0GeRPpC0Cbr09LUBUArscxqrdS/UVad2oHgQPkcSeMcFGbxL5OG/qAyOcEb0BZtos2aU8viOZaTSDHiipWWLbml4jgLFrdrhYS+Aws+G3Y6UdC40Zik66gGvTZJE07Gx1qLydgvowyHx+vgCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773681821; c=relaxed/simple;
	bh=XUMpQ+10FZHfgJfnOFqGeZ08vd90HbRW79j6d9PUQqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTQX/BVrDITkdSYXDW0aX1aTy4+Kzo0zThtcoBTnx6ygOFy2V5LBeeLwlDwB6grqJWnkkNW9D1ZcXksD4xPdCT42UNBF6eMZNVgTPnh9fTO4qBoGCuS1men8IK6YMXUCAQvyeVXnNQP5FzHnrgNqYMxp433oHBeqmVaTVpy8KXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xvlxiznf; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xvlxiznf"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4855dbfc129so23840735e9.0
        for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 10:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773681818; x=1774286618; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8b9XuRtDgXlhvc/ORfCs98sIv3e/g8y530Cpr28kNVA=;
        b=XvlxiznfcMaQbVAYfj3rmk18tyGMrWJAmrQNcUh5RWdwHDQyKFBX6D27lc3J9IKViO
         dWRvrhb3HPZOyN/qPmugTkXMcQlcN88z4hTDNBDylSl+jwfs8txzUmiy4i0uTIKJTyUz
         gu9TDslsh/rSjQobhyliRjXbSgo42pFYeUtCDEZCFQzjHtl998qCkk3BbvW3auxjiV32
         JQUSP8D8xxuzYKLyWNaWgy7JRMdAH3hF1/GrwnLx/DQ5u4m7lkv6NAsbKD4JotTzYmvA
         UYeoG1y8K3Gkbb4s7oGa1cHUE4RoQWozwC6iN3lr0q8s5f7bXTittzLWYzwKL73Sj/tb
         dUTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773681818; x=1774286618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8b9XuRtDgXlhvc/ORfCs98sIv3e/g8y530Cpr28kNVA=;
        b=bxGMyJV9RkXQ8VCTGuXv1zq2ZFcoUlUNHdInAKYVyQdULgiSsFG9QARmcSwfNNbCbE
         B75vM7qNkpmA5snk1tyWYGFAYKzyfJeMtvrhBwr+/n9I3wAoAYpEbkT2Hpd9qIPbYz4O
         9Vl7QH456lYjPwph8WP+Qr1ZqPIjh8E5W9t1Dk1ZosEekM030qg4GK9k/r1OvuAaLBB4
         +7uXnG7k5ZJ+jj5Xjr12TUUc8lxDXAB0qjEVF/UN3VL63kMA9RPZ2lXvSu59tQ5Nwff0
         jjkU4MHCKOMcflrKFzjdgDLUIlk/Pff3qq0pxKx/0Rp84AwtrqcSLqbyfjXzyBFmdXwO
         VIJA==
X-Forwarded-Encrypted: i=1; AJvYcCUHPCuQSBthbrQciCBbktAWrMYLUHTGRwWSE0fn27jJjPhtTBrmFTjoxZgxuUQp07XEZE9LYgH0yPSj@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9cCwZxtrLcfpy/97g0gnsLR8IBKx6PrfNq5ZE8WlEPE156ijP
	NhFW3OtTpido5ScLJoB0Yd5uYCDi/OJml+1gBHZlTYINn/JT7Ua19bNHAIh8mNYSWm3lo6sgROg
	UHhnf
X-Gm-Gg: ATEYQzy4LwTq4hGw1b6Fhss9SbVFTsXedfXIXZ5DxcKPoi10e3GW5auBpUkcJNle7MD
	Yvtp2nyI46U4vzC+74OMk0OkFoeCG/5raqM0a1S6T8zJuyBQzx7JqfIjngPsXyPQo5QZDWkC1Z6
	QVHIREA3uVi3z+vcsqKI66VAQp6IDeTuoXKJqr6G4ytm+cXh4Yj1iBEO3Si43aJhgwFx64y9Vqf
	sizc5N7qTb1qyURGwuL82jYNGEVGVuUaywqhB5qkLlLB4m4uvCyFGThOob+mANFFWlE/1n/6tZO
	3/jXrScEOC5k6Px83MDgs5bhLPC8857g3wtaQ3B1ZuCCaROM1uqkhzSnHEcpRDX/Ht6clRyyH6E
	pcqjz1aK1X4S6C02S12PtiVIb7IUbxT4fYWAoZN3NwJxhHNDf5NdPK02w0aj2VVQd5S9miQsxSP
	XVvx6C+tEpXjJFYq3XLxbPXosH0T5kHDxAYv7PZQ24K1A6uUotOemP2/0=
X-Received: by 2002:a05:600c:4514:b0:483:78c5:d743 with SMTP id 5b1f17b1804b1-48556709e2cmr221416935e9.28.1773681818463;
        Mon, 16 Mar 2026 10:23:38 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab3a0c34sm15142622eec.7.2026.03.16.10.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 10:23:37 -0700 (PDT)
Date: Mon, 16 Mar 2026 14:23:32 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, thorsten.blum@linux.dev, pc@manguebit.org
Subject: Re: stable: [PATCH] smb: client: Don't log plaintext credentials in
 cifs_set_cifscreds
Message-ID: <qy7umjmnkwhtmixp7giob2iqstrwr6crntuyakibcdpqhzo7ty@bgbcu3bntz5d>
References: <eijo3pknvy4gl2xh23by7kjdxpoc27an3dqfmfttremp4xb53o@z2kq34l2onvy>
 <2026031616-flashily-strung-a688@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026031616-flashily-strung-a688@gregkh>

On Mon, Mar 16, 2026 at 04:53:02PM +0100, Greg KH wrote:
> On Mon, Mar 16, 2026 at 12:49:00PM -0300, Henrique Carvalho wrote:
> > Hi,
> > 
> > I believe the following commit may have been missed for the relevant
> > stable branches.
> > 
> > 2f37dc436d4e ("smb: client: Don't log plaintext credentials in cifs_set_cifscreds")
> > 
> > Could you please consider backporting it?
> 
> I see it in the following released stable kernels:
> 	6.12.77
> 	6.18.17
> 	6.19.7
> 	7.0-rc2
> 
> And it is in the 6.1 and 6.6 queues for the next stable release for
> them.
> 
> Do you not see the same?
> 

Thank you! I only looked in 6.6.y, saw no emails from stable and assumed
it had been missed. Apologies.

