Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05A58C1A;
	Mon, 23 Sep 2024 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727115005; cv=none; b=EH6g/wrGu6R7tLOHUqXFXX9TTwTPuVMMVVTYMz4Eyb+9tYHrp2kei81A/2WeMv64rgQ4aJ3rCVxRM9bvxBAW30asFA8saMwJi6nBbNw1EW5b5p+lYng74dSHPHcwJl4nUnzD3jCS7FZjyHR4MktYMFPxjch5edQXBJpm3u8pyE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727115005; c=relaxed/simple;
	bh=HlZ9v4TwyNvCuPETibD+0YCSCRygoktXQ/q5w1Q0TbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cc9euJv0TE1+mq7leVY+9jivXBaptsy5/QVAugJgaFDZ9Bj1m1VSj80q3/4iDhNDk1nnMzmrUOAf7A1AqT1rHWGxqb1q32yBF0eADkweVafLH1WBTQ+Mfe/LZddGuElKwIiNUVID6ZqCgdIbAacIMtjcAqvr1ndNKeFnLb0PxUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjoFlqYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjoFlqYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A542C4CECD;
	Mon, 23 Sep 2024 18:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727115005;
	bh=HlZ9v4TwyNvCuPETibD+0YCSCRygoktXQ/q5w1Q0TbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hjoFlqYT5SpMq6E712iLJye88BRpNpXs3j4FlwoI5LZIF0UPnt+7t0UWkz25z+Qr2
	 LVPrwDDSvX3vUgOQcjbpE3nYgOoTt8nJsX8zVPisD4vq1BcKeqqS4h25oOykr1jJDI
	 A9XtVaV3JIKp4AAFgNmJJDKCv1ThHtpob1C2AWPX5nQRHGK36ORPgSHaPyb29NmAnP
	 UDYCRK1W7pMD3qCaUZWMc5X88Yw3jvHyDxA19y73oBfiwDLXMws5UtHEbwEHcbnmDl
	 Zz05UOCtir5hmx3vd4x/ei0/BoJpwLnJtWp0g9QLxpkALFik2hHBCMCQaSyHmjyS7I
	 MVg9hh5G5r1RQ==
Received: by pali.im (Postfix)
	id 493CF775; Mon, 23 Sep 2024 20:10:00 +0200 (CEST)
Date: Mon, 23 Sep 2024 20:10:00 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <20240923181000.4x5uzjbllvz5kjhw@pali>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <73552a5120ff0a49a5e046a08c6c57f4@manguebit.com>
 <20240917210707.4lt4obty7wlmm42j@pali>
 <7f29cbf81602313df348fe6d36bdb0e2@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7f29cbf81602313df348fe6d36bdb0e2@manguebit.com>
User-Agent: NeoMutt/20180716

On Tuesday 17 September 2024 18:17:08 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > Would you be able to fix the client code to do this?
> 
> Yep.  Will send it to ML soon.

Perfect, let me know when you have a working version, so I can test it.
