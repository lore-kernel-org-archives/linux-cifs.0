Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7161529415
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 19:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737314245; cv=none; b=foIDK56vp90CX7oOggEiC9fOptkaY93CAcBL4bQbIeZUT9Lspxt1wS9ajDPAYcERX5HbtDv0O1ujCeVdglsYCka2pWWHURmxv0ymEa8LSRZbZzbnQxW2lK2QnHNnwlXrs8mpmoW78YNwKd68ZUlMP8FXetN4TIXiKjqgB0XPTxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737314245; c=relaxed/simple;
	bh=LV/i2DR7fu8l1fe8SSgjG0sA+e0eRCIhOt2Osw/oEB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jak6s5LO339W1kWgHTVDfG85CtiBxhogK9f/IAm0aasYSHNP9/9t27qYYK5uMW5UZ+svVIelKEqkaU9t/wIlXFhdHOpxWsef0OVcCKe1bnDS5r41Q1JIZzvgRkS7t83QvRWW5tESO2gNRqVx+Et1AluES8FTz5baFnDnkF1zDnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4EsW0Zm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4EsW0Zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6ABC4CED6;
	Sun, 19 Jan 2025 19:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737314244;
	bh=LV/i2DR7fu8l1fe8SSgjG0sA+e0eRCIhOt2Osw/oEB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q4EsW0Zmrg3juYl8TrQUFJSblUD93Wos6SIEFJpEzSOhRx0TLL39LMJcxZfM7Pd9M
	 bQa2jX4SP56P9H+jUD9SStbSM2q2XZ2cjGWJF1bHSnndgzzLBJFneHhMuIkd9gIVpN
	 +FTnwTiH+8fOhMiFGJhUSLFgW5DXytURCWYXiaV/wzrhK9Hs/a+xyqc05NFbnjRvx4
	 zc8skXjiaJidQJGm+E+rNtlBSyQoY4esFq9pONbRVQNtwJ6tKcyGFfzcduSN7F2HYx
	 2XGIye0CevieZrGvoS9bO9/lO7sbjL5Ro3fCwFtH+PsA74iQ9KYjuwF4goX9Qa1I6e
	 qc02M4omj1sKA==
Received: by pali.im (Postfix)
	id 98B3868D; Sun, 19 Jan 2025 20:17:13 +0100 (CET)
Date: Sun, 19 Jan 2025 20:17:13 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 28/71] cifs: Allow to disable or force initialization of
 NetBIOS session
Message-ID: <20250119191713.yrjcswmc4spbply3@pali>
References: <CAH2r5msxj7Bwn1uB4di=EChVjU=DxULmJT+QsU+xwcxDGiyHQA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msxj7Bwn1uB4di=EChVjU=DxULmJT+QsU+xwcxDGiyHQA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Sunday 19 January 2025 13:04:05 Steve French wrote:
> "This allows Linux SMB client to connect to older SMB1 server listening on
> non-standard port"
> 
> Pali,
> Are there examples you have seen of a case where SMB1 server was
> listening on something other than port 139?
> 
> -- 
> Thanks,
> 
> Steve

Yes and I think that have mentioned it in one of the commit messages.
Anyway, I will try to explain it a bit more.

When running qemu (or other hypervisor) with SMB server in virtual
machine and qemu is with userspace networking, then qemu outside of the
VM would have to map privileged port 139 to some non-privileged port
(above 1024). It is because non-privileged process (like qemu when
running by normal user) cannot listen on privileged port. So for host
machine or other virtual machine, that SMB server in that VM would not
be accessible on port 139, but on any other chosen in qemu settings (or
command line argument).

For testing environment this is really needed as it would allow to run
more SMB servers on one network interface at the same time for example
in virtual machines.

And if you are asking for the real production example, if I remember
correctly I saw backup service which used custom ports 140 and 446 for
SMB1 (it was standard port plus one).
