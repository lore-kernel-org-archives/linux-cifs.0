Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793119491;
	b=mjObAL7DyQS8BLwxC5dihi1AcENeM8GJqjwMleI8N/LgsfkG0D7hzV/BBSZ9HINrNhnR
	 R57Io+AM+PIAZtuNfoPrH2U5oKmU69sLHWLeRPCSwhEpESL5+Xp3LhVSBJiXhFvMiYFk2
	 uPtRN8gTetXbkQCj4k8GqaKRODI88jhmk/gOlMwrwgmTs7gTYs2HhS4Df1NRvmHSlg3VA
	 qvM+F+ogvBY2yKwBbU0LwRWsZauyqf0yPzbG1ntTrXkDlrPuIesw/ZPa3HZxk9KMrjmC1
	 QO8Ikmn/mc23uJhCWI2MyEfwPjzBeeteYCpKsbAgPULNZH8bqURtGwuOOmgmEABukcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793119491;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=APByWEuQdjiShyAVBuUMe89tCnf7dn8I2QMcJ1nqFV8=;
	b=IPLA52DLAqA2I6+9kYfxPlsg3qaR87D2+Dq7ARdCiwn70NdAutbCicegTrpkg8oRwndo
	 m8SvTfi48hmUEU4Iiw4U1Mx+wQrV1cs8Ee85wF7bcGNPHVGKiF8tDcy9eyKbRMtLzTPo9
	 FzKUD6lmXn3y8XnGwgKbKf4EwMPv3CLFgiTq7P2SKepiaUP6HrrgEghCfMj2Pafs2jF7D
	 2x/kEDC0ytqEPOQbL4laLEy2d3hHY9c+/8aBk5ExbPIm0q68ORYvBlQfeAbLc7K49tm/+
	 hIa0nknNbaCPTdYK6MXNMzD6bwu7ROmQ4V+yQpECQE2xzyeS8ewv1kT2rNSik6kQnOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1gBO3Cd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E52606A31B;
	Tue, 27 Oct 2026 16:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1gBO3Cd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A0E1F01828;
	Tue, 27 Oct 2026 16:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793119491;
	bh=APByWEuQdjiShyAVBuUMe89tCnf7dn8I2QMcJ1nqFV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m1gBO3CdpDJ0eonf0iSYyD/N7DLYSFVCmn3dSRhxU/sXfpW6ov2UijLFf8+u/S2Op
	 EGMcQrRvF591BWo/DADGvPG5FxK33+EpY3Q5uQMLJ1L4CFe4V+fzmQVftgyEL61jhC
	 INOSi6nLLTwN9I/0N/tokYdZ6pm7+gWhGKNpoit4=
Date: Tue, 27 Oct 2026 17:44:50 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Cc: stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Backport request: ksmbd and smbdirect fixes merged in 7.4-rc
Message-ID: <2026102733-sinner-baguette-1d07@gregkh>
References: <CANTrAmxiBn6GT+N5qivdf=xtGg6yFksK5qN_PhpoNdxXDSpikA@mail.gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANTrAmxiBn6GT+N5qivdf=xtGg6yFksK5qN_PhpoNdxXDSpikA@mail.gmail.com>

On Tue, Oct 27, 2026 at 11:07:48PM +0700, 이성현 wrote:
> ```
> Hi,
> 
> Please consider the following fixes, all merged into mainline during
> the 7.4 merge window, for the stable trees listed. None of them
> carried a Cc: stable tag.

Why no tag?  What happened to prevent that?

thanks,

greg k-h
