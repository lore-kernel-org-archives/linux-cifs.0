Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E93D1991BE
	for <linux-cifs@vger.kernel.org>; Mon,  9 Dec 2024 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733774070; cv=none; b=NaHbanWJFmIFwkspddszBRCd13bXQPufo3A5aJ+VGw1jGWuW+L+2X0chqu66AQq2fst+gExA4axqx+UH0eKoNevj4g3Z9NjH8AXUo4yi+USpDB8e57ofo4d8x+W2KunRO2Is9rcCycSNYufTDqTLG9HlVf5+7CjQvDBkgcUzJGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733774070; c=relaxed/simple;
	bh=rwNOLfvLozxQI8rDgNv53ZezG4FZNqV4jOQkIGAXAQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5xpmff4FFv2hFUCzCZxq7xtRbZTONSH+yPXBzeuxjk285dOZPylQIEG9fCkm1HcQvedFBZyh2QbWNLePk3xy8VVXC6dGO8igFHXiH9Gk11+a0P45MEssZypUivmVdtzSSdMjG3opH1YpzrU59CqwU2s7EXlM8FZQoSKlE73grQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lND8XTku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lND8XTku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2093C4CED1;
	Mon,  9 Dec 2024 19:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733774070;
	bh=rwNOLfvLozxQI8rDgNv53ZezG4FZNqV4jOQkIGAXAQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lND8XTku/b0TYuHwcrmeXWt9b+EPO59tfg2Xm7HwvlEX3UngEmgAPA22V+ADHG3hd
	 ZwFLJHkHjzBbp9uRc7icLhAgchST8pags1peyQjeKnt+UVlYUsyawHa+occqVUKMJL
	 Pm5tI33SoLKV+jRx+DlvRmdxtjVnJuTg/fF5U6Xzr/WaZojw+RLgtmGiRHj10jhjD3
	 Hs1utuN0ufg8BTRTSkxTNNZeLimvYs1P1gWOA+50vEOGIlBoy5G0TmDLEDd+2MPmuk
	 a6JIrjU/+7fHYucNlIgcI7YxQ0UqheJvoulg3pKt3WrdAFwY5CawGwLCEgdLqqV2hv
	 1mfncw6JuH+Gw==
Received: by pali.im (Postfix)
	id EBAE28A0; Mon,  9 Dec 2024 20:54:20 +0100 (CET)
Date: Mon, 9 Dec 2024 20:54:20 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Ralph Boehme <slow@samba.org>,
	Steven French <Steven.French@microsoft.com>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Special files broken against Samba master
Message-ID: <20241209195420.7mnya3ua2y7nl6tp@pali>
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <20241209183946.yafga2vixfdx5edu@pali>
 <1098e751d1109d8730254ada7648ae4d@manguebit.com>
 <20241209193445.yrcaa7ciqegvs6fz@pali>
 <829df5e75aba7f0857ff688689b52676@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <829df5e75aba7f0857ff688689b52676@manguebit.com>
User-Agent: NeoMutt/20180716

On Monday 09 December 2024 16:42:54 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > On Monday 09 December 2024 16:28:08 Paulo Alcantara wrote:
> >>
> >> Yes.  Have you sent a patch with the proposed solution yet?
> >
> > I have not sent, I was not working on it. I was in impression that you
> > are going to implement the proper solution.
> 
> Yes, but priorities have changed, unfortunately.

Ok. Would you have a time to prepare a patch? I have still feeling that
the smb2_compound_op() code and EAs code is rather complicated for me.
I would like if somebody else could look at it, as I have feeling if I
try to do it, it can end up with something more broken...
