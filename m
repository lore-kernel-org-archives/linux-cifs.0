Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12587423760;
	Mon,  6 Jul 2026 11:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783339131; cv=none; b=ZelnmqmTIvjfOEiopApvznUn/vbPHg8PEYu2HKMSSl4qEZMLw6P4/P1GAO68HMKMRPLLpl7vpLCRieCBGdJiYfGAsslmgtiRygE78L0qtGF42OadzSN0vCfTwrbyhy981WSNYTMjE2GJy54+24HFWLtHAiBQKteN0BpyWxcE40U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783339131; c=relaxed/simple;
	bh=K6eyQi9oDXQ/yMHuZYeR4nEOar1Py4jEyLNCb8LGN60=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=c36chqQNq25v5/z1qlAr9V83wZrKczCM8FONKnVYWpQJ9OVdSjjaQOsOSgJqzd+8cDXHtqklM1Z3js9OtyTCFNLKfOjX3sDFAgwNAKAwKunF53lcj6IgsSCUU5B37tk1ZhEL2qaPiRtX/0eQE68F0+dE6OhIzRqdpaOW/i1tpPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=Si9jqrUm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FRjRfNQR; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="Si9jqrUm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FRjRfNQR"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 36050EC01B2;
	Mon,  6 Jul 2026 07:58:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 06 Jul 2026 07:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1783339128; x=1783425528; bh=sWw9aVTM0PND1LfiagcHcsV7H+BjL0r0900
	kW1jFkNk=; b=Si9jqrUmFrC8bgsywq5dWzAWA0s3z6oo7hdEzYCVaCjuRp9IdIk
	h9+4dt1DZDZr3M/nCZ4V3QTHx7c1G9fQcB3uM/JQsOEftc3EsdBTVgrAFfp3J9NP
	kXtzAt0Kl/gSJy+EIk/bbnP2yalFxzX2vzgb1aXtCfV/UOiV38jB/eXXqxoTYUN2
	YW3xYY2hIAHINUNh9FpxHK+aA5QB40Vb47JK/PEXxNwMIgxCUJJVt/nmMTpNDljr
	BIsxrGfZMmukwJlceEbyG8q2j6BU3+/9jI7yIaDXp2HRrvjhuUkTH52hGIl2OPNn
	OvMYWhLeSMdV/IWiWJmqAhmbRW/9WnQlndw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783339128; x=
	1783425528; bh=sWw9aVTM0PND1LfiagcHcsV7H+BjL0r0900kW1jFkNk=; b=F
	RjRfNQR0xEbGn4EQYzORg0RMXj1ryocN+YUJyrCVP6wjUox12nt6o+IjAGEuPfNh
	vXFPbP0MnpUAopVLCLGlAsvCEjiTe3IqemdpypexENYJi0X6DZq4JAPGJTsKVgFq
	n8fTtfYDlVKCKhVwcKw982eVM1rvCLsfB6SoJZAI2N407pfpKLa5TZmbAgSJ0UEO
	l+ZH4doGQiFBBe2fqK6LrFSurLXI7y7JfiCy3AJyDS7gFgiaBtUTX408SXuuu+GC
	LDbF8XW3SwTWFX44AtOOzL7siO78evnbIcwLxzQNkNR5UwqX7Pk9BkKdPTS50nL4
	FClGrgd9SZlM4YsciG4ew==
X-ME-Sender: <xms:d5hLavvntpFmcC_HgxCpj6UBqiQHFdrsjJCuMmt0v8frNdW6tzaOBg>
    <xme:d5hLah9yUWpuuEue0e2-Sbq2UO2LolaAPfhHXBBSgvgsaRGivwejolp4zlAD6knR4
    828y2pZbo4IXU82c8fEoYrl76aoLi2Lpr88yIV1I9D6-UfRKw>
X-ME-Received: <xmr:d5hLai0u37zIqrKYaPDkUznjsBvRp-dEHOPzUIA1juulYIZtkUYKeJoULgFXpVG-Hler-AF_alD_3GruS98P4tPc5duCVk8>
X-ME-Proxy-Cause: dmFkZTEXBlLkYv0/lHwCdvYg1I2FZTPcp5vgAUOe+Y++b6FsaXMSdjac83H+KQ6Ic0afHa
    2b5rPIKLfSrJW45nJkHAXTQDy79OBd5vorDxchvc8MW3NstWczP+VJ2w6BrMlrhJw3liHN
    sfhB9kP20Lh0kl68lVhtgeoJQnw3nHDARlIDzwFZXrZladBuDDdbvfd2nqP+0C5IT8vNZc
    KeMRmQqfp0gBW7wGj5TMOmq63LqcysgOhL+HXhkWGYyGHe/4qWhqNRiWuXvtPqNjgbqd3f
    LTognwz+pcU0l2YG8a1r2fmAEmzKQRgZNlhgm4z6Gl+0aYaGihhiuEeEEn1GDeHuBUbhKo
    Yu06Aw/CGn7oZUoKuoFjZbMtVgc6hCuDsx1MQp25TgY0XJ8ucHVMV1otqrB2I4kXUpntBd
    wVrg40DPlF2EjhmdgCPWa5F5J24h/cZJUnDm+tka5tqOHhmYX1ufllZgbjMFe39eHTS8Qd
    qJAX1bYu43SC7AjvOumDvG4jK+1H3Bk6N1TGpyQa1k4+zGDJ/Fr9kV3tCOjrEXN/kBwtmm
    wtV/h4BK1EOH5EqKfj0RQ+lWS0b5vXSnguKNkSvxQvciy3RzgHWREettCJ5sU96kxA/P4G
    6iaAAp5rLiRnbYdYri2+CIoU3Rtul+1wcOF4r/4Xs2vPCStsGWkE4ySKobeg
X-ME-Proxy: <xmx:d5hLauBw-4nZor8Ct5CqTKTXd5cMG2yM7fwYqlTlAMRhi1SDO5_UkA>
    <xmx:d5hLameXMUzMz9563eA-HhbUGqZ_mVbq4TFk6hI0Rk0CEJOsEQttMQ>
    <xmx:d5hLaj5CidtlpIwRL5-A_itTRj9MPG575Zh3mqapRJcjrGM1Z3xFXg>
    <xmx:d5hLahVD4Og0bgOtkoI5gpqiuTj-6L00Bm_IzhYsGqbCsW6jD7TOew>
    <xmx:eJhLag3JcN875hPf5tTFPrS--tHGkCEe8gy7781DKA3rAc1jYDXHRsu6>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 07:58:46 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Cc: "Steve French" <sfrench@samba.org>, "Steve French" <smfrench@gmail.com>,
 linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: d_time and d_fsdata
In-reply-to:
 <CAJfpegtCL8S=zjv-pwxrX-9YXL0HLGb8Dsw_XWFF_H4Ui3MTZA@mail.gmail.com>
References: <20260702021105.3406439-1-neilb@ownmail.net>
  <CAJfpegtCL8S=zjv-pwxrX-9YXL0HLGb8Dsw_XWFF_H4Ui3MTZA@mail.gmail.com>
Date: Mon, 06 Jul 2026 21:58:42 +1000
Message-id: <178333912248.27465.12516797587230528370@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Mon, 06 Jul 2026, Miklos Szeredi wrote:
> On Thu, 2 Jul 2026 at 04:11, NeilBrown <neilb@ownmail.net> wrote:
> 
> > 10 years ago cifs *did* use ->d_time but was changed to use ->d_fsdata
> > by Miklos with no justification (a00be0e31f8d).  Miklos: do you have any
> > memory of why that was done?
> 
> Wanted to get rid of d_time, as it is no longer used by VFS, only a
> handful of filesystems.   Still a worthwhile goal, IMO.

I thought it might have been that.  Do you recall why you didn't
complete the job?

There aren't many filesystems that use both ->d_time and ->d_fsdata.
Just nfs and fuse I think, plus cifs and afs which I'm trying to change
and could manage with a DCACHE_PRIVATE bit rather than ->d_fsdata.

fuse could move the d_time field into fuse_dentry at the cost of an
extra dereference.  That would mostly affect fuse_dentry_revalidate as
other places that access d_time also access d_fsdata so it would just be
another cache access.

nfs is more complex.  It uses d_fsdata for 3 different things.
  - the "block opens" flag that I added and could be in d_flags
  - a path name - only for the IS_ROOT() dentry
  - nfs_unlinkdata - only for DCACHE_NFSFS_RENAMED which need to
    be unlinked on last close.  This is only ever present on
    regular files, so we could repurpose d_children, but that is
    a bit icky...  Maybe we don't need a d_time for DCACHE_NFSFS_RENAMED
    dentries - they are quite special.
Also nfs uses the lsb of d_time to indicate something about delegation,
so it only uses 63 bits of d_time (31 on 32bit hosts).

d_flags currently has 4 unused bits.  I want one more for locking
changes.  Allocating 1 for fs-private use (e.g blocking opens) might be
acceptable. 2 might be a hard sell.

We could probably make it work, but I don't want to distract my self
with it just now.

Thanks,
NeilBrown
