Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B893A2641E7
	for <linux-cifs@vger.kernel.org>; Mon, 24 Mar 2025 17:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742836071; cv=none; b=iPwIzG8uPalJjJPVSUvj4c0GIFrKwUG5BEpfZeN3+7LCnBYS5rMLo6bHjdk7+TeLTtsYIi5c1tSBkgldMkmAPgtDo4PkQklylrRIavTW+QavpVdDgA2uBJSXX+afoOcvP34YqI2tqEwZjtFJqAt/W6vbkeb83jIkFKOKCB+jZac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742836071; c=relaxed/simple;
	bh=5HVZF9YcFi76Tb7wZaiR3glYy+4xdYAZslYeDqEsVVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sktyPPUPMdhPPyeCBRz/HaU0JAReWiGWrkjjwi04h48COyYDcQmxK/28/gDlQPINO9fO2evX57iCZMrPoxu4qFrtMUL/t46uZ9Ss1irZE4f394TzPGHuoRDeXeNbu4fBpGAeTg1ElHFQO6LWJjfc3EEEREoyTmdvYq6lMKqfNEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqMCYYrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqMCYYrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13107C4CEDD;
	Mon, 24 Mar 2025 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742836071;
	bh=5HVZF9YcFi76Tb7wZaiR3glYy+4xdYAZslYeDqEsVVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jqMCYYrV/vpHLKmYOr7w4o5VAKuRVhNe6KtHVtxY6/FgbbI+Whk5TUjPDWvATZ8yx
	 vBoUXoqoh59HaPklF822osSStIt9EjuAxvILzKbzbZkNmWEJzYpyKs4xcgMpISkSV1
	 rSdAyzeTWqse8D5E9y9HeSue98M48iCV7XkqbR/1ikT7V4DQBbprgB/c0sVhPKJ0yL
	 Cuv/hhr9qQ0PLC14y1UBKwtCBER+z1Osg973wzL/tPJml4MXWVblqiUpMGFDFPsfaa
	 i62f3rAdiRd+qdTwQRCORg8d2YJaUAhCF3Y6EyUP82MjA/ojilW83HagvrT4xsrYE6
	 wMq/sdsIibsQA==
Received: by pali.im (Postfix)
	id 20EEB71F; Mon, 24 Mar 2025 18:07:36 +0100 (CET)
Date: Mon, 24 Mar 2025 18:07:36 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
Message-ID: <20250324170736.zcqqv3rv7ycjr4da@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
 <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250213184155.sqdkac7spzm437ei@pali>
 <CAH2r5ms5TMGrnFzb7o=cZ6h4savN2g1ru=wBfJyBHfjEDVuyEA@mail.gmail.com>
 <20250323103647.rsex63eilfdziqaj@pali>
 <02d5d5dccd2fa592baa2d16020d049cd@manguebit.com>
 <20250324082310.fbvnxo6cmuwv2clx@pali>
 <CAH2r5mvaM1y3xEL+yiFDMHRVZg2j48hwVaQa+BL8f+23Y7VwrQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvaM1y3xEL+yiFDMHRVZg2j48hwVaQa+BL8f+23Y7VwrQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Monday 24 March 2025 10:33:06 Steve French wrote:
> On Mon, Mar 24, 2025 at 3:23 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Sunday 23 March 2025 21:36:56 Paulo Alcantara wrote:
> > > Pali Rohár <pali@kernel.org> writes:
> > >
> > > > Hello, I would like to ask, how you handled this regression? Have you
> > > > taken this my fix to address it? Or is it going to be addresses in other
> > > > way?
> > >
> > > It's already fixed in cifs-utils-7.2 by commit 8b4b6e459d2a
> > > ("getcifsacl: fix return code check for getting full ACL").
> >
> > Ok, and into kernel is not going to be addressed that regression for
> > older cifs-utils?
> 
> I thought we had decided that it was risky to intentionally return the
> wrong return code to
> userspace, to workaround an app bug (especially since it is easier to update
> cifs-utils than update the kernel, and also since cifs-utils update to
> 7.3 is strongly
> encouraged for users due to multiple security issues fixed)
> 
> -- 
> Thanks,
> 
> Steve

Ok, fine. I just wanted to be sure that we have not forgot for something.
