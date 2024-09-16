Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC261C28E
	for <linux-cifs@vger.kernel.org>; Mon, 16 Sep 2024 16:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726504289; cv=none; b=DoB3WVSb7KmGwadlKCy985wD5hjYaatDkv+xo+ZqeimfkLHvp+m0dRopyIf6UNd6MXXoeHSVqMsC5L3eP00pSqmpBSiG0ClgAd98GXpHJzLFtsJ0uZ1Yb+6WT1ld75BnIGVYFWUMLJ75dG0JYyyy42NlTfpL632ixi1SQCKvtBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726504289; c=relaxed/simple;
	bh=gMaQow/G1znvthnGCdYcV9FLifjzzymwBsP24zkB+rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hpYdI3tRWbkvDKRC9VXQS0Bdv/2CVQqS+5P0flllj02WWG1G6GpvrZKbOGmsCclIh+RZSlVGKklPeHkIEfVNNVGqFWaqOmsZsB15yMfQJi/qzTEFdgNj0GggrK+q+eqUflrUBH+4r1rRJ8HvLJVZaqJPY+Iv6CfHXBPy+d09kuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LAnKsc+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LAnKsc+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E903C4CEC4;
	Mon, 16 Sep 2024 16:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726504289;
	bh=gMaQow/G1znvthnGCdYcV9FLifjzzymwBsP24zkB+rQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LAnKsc+N/dL9bcv025x/zbn9KH+Gjo/pzojvuwreZ/ER65MjRftVrm2QubjNFRYAY
	 StLmCJ+Zw4JOGxY9UZ8/WBIj/5KbHeb6juKM6jUn7rb6BFHlolNDdD0lLfSOiHG3iv
	 RYJkV8Alq59iuWYgm9ZmJGD2dLlANzJbSDc/YdUsUDEyX2jPLgYu53U5DINNUO09PY
	 /QbZF/bkfoaslUzlIjAEzqSOf6GER9hJqU8smQ36krHhtbBR8/ShqncDkmfMNGbTqU
	 6Lqeoor/lsQBndMZ6TcJ/vyIlJfRU+PC1ylowuiy/ltDfRi2LSlyCBic5wJCmiohcl
	 6WnkiYcoCxTSQ==
Received: by pali.im (Postfix)
	id DE0FA68B; Mon, 16 Sep 2024 18:31:23 +0200 (CEST)
Date: Mon, 16 Sep 2024 18:31:23 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Volker Lendecke <Volker.Lendecke@sernet.de>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 6/7] cifs: Fix creating of SFU fifo and socket special
 files
Message-ID: <20240916163123.lj3pm4dhqfcv4ivi@pali>
References: <20240912120548.15877-1-pali@kernel.org>
 <20240912120548.15877-7-pali@kernel.org>
 <20240913200721.7egunkwp76qo5yy7@pali>
 <CAH2r5mvEa8mUrK7mEKFiimkb1asTWA0p7ADz4937yoxM916RAw@mail.gmail.com>
 <20240913224248.k5tn2le3gau2prmo@pali>
 <CAH2r5mtgV=NkZVChDY-apdqkvM9KFkraRGy_jDCpLmFU6PFMAA@mail.gmail.com>
 <20240914081742.wlldjjlogrmk533i@pali>
 <20240915174126.ilxwoxlsfakgnl7d@pali>
 <Zugp5RiYKqFUW_bk@sernet.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zugp5RiYKqFUW_bk@sernet.de>
User-Agent: NeoMutt/20180716

Hello Volker,

On Monday 16 September 2024 14:51:49 Volker Lendecke wrote:
> Hello Pali,
> 
> Am Sun, Sep 15, 2024 at 07:41:26PM +0200 schrieb Pali Rohár:
> > Now I have figured out that even the latest Windows Server 2022 version
> > provides interoperability of FIFOs in SFU format with Windows NFS 4.1
> > Server. So if you configure on Windows Server 2022 one share which is
> > exported over SMB and also NFS at the same time, and over SMB you create
> > SFU-style fifo, then Windows NFS4.1 server recognize it and properly
> > reports nfs4type as NFS4FIFO for NFSv4.1 client.
> 
> it might work in this direction. However, in my tests if you create a
> fifo over NFS you end up with a NFS-style reparse point, which is much
> less prone to misinterpretation.

Yes, that is truth. New NFS server versions by default create reparse
points with NFS tags for special files. I just pointed out that even new
NFS server can recognize old SFU-style of special files, which is useful
to know in some situation (e.g. for mix of old and cifs clients together
with nfs clients).

> So my suggestion would be to use the
> way that Microsoft properly documented in
> 
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/ff4df658-7f27-476a-8025-4074c0121eec
> 
> for anything that is newly created on all servers that can do reparse
> points. For servers that don't support reparse points, WSL might be an
> alternative. For me it would be highly confusing to add yet another
> representation of unix special files from new code.
> 
> Reading existing special files -- sure, where strictly required for
> compat reasons. Creating them? No. Too many options make the test
> matrix explode.
> 
> Volker

Important is that all my changes and whole discussion is about the
non-default cifs mount option '-o sfu' which disables creating reparse
points and uses only SFU-style of special files. So this is not a new
code but special compatibility case used in scenarios where reparse
points are either not supported or cifs client want to use normal files
for storing fifos/sockets/... in SFU-style.

I fully agree with you that in the default conditions new reparse points
should be used and created. And this behavior is not changed or affected
by these my patches.

But in this compatibility mode, which has to be manually activated by
user at cifs mount time by -o sfu option, we should follow what SFU is.

Note that when this -o sfu option is not specified then these special
system files are not recognized (or created) at all.
