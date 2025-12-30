Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C772264BB
	for <linux-cifs@vger.kernel.org>; Tue, 30 Dec 2025 17:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767114542; cv=none; b=j2dnFeE5z4xPuK3ZHiT1TcIQi+vLa1UC7qaldFliY5T/458dfK1ZCvu/Tm9FNm+zkPCtN8P1Hfa27mfolMnaP90A0ZJfG5Z6rvKdi0LQjfumsLrmpAbuS7v7Uy07aGlrJEc6g3SaLTw1EXPNkZWwjJ20NMKM4F65dPoVx4xD2Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767114542; c=relaxed/simple;
	bh=mwWzj8iC31kQNOvOKpKrmkQ+WgRNgHYpUkvKlBb7RnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJp4NjRXzVk1wkIBSabeGwJY/dnvViccN/LQl9JUK7fBdO9u4d14Dx12U2s4qFHd2xKCbQKu2IiYZ6omJNeNmKH2sJzwqn9aWJceOCqZdkdN/EORbYrHKU8FJDnWwe73ZnS3vIgplzLtCDrjyDn+i0RNcmcRuHx11ajswrJSZSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCtgSosI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCtgSosI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A8BC4CEFB;
	Tue, 30 Dec 2025 17:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767114539;
	bh=mwWzj8iC31kQNOvOKpKrmkQ+WgRNgHYpUkvKlBb7RnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NCtgSosIkxi6s7sN9oh48abJk7o7IzIfdInTJKTh5VsTonm9OPhYeKoDUdRCSakR2
	 4EJyK3/yG1CcQPbDkrwa7bdDDdze9DvZ5qH9D4muKpylluCTeySibQC0JqNzpFoEb2
	 RtY9k89PVgrJxnAp21HnrskEs5+fN21+5FJITcf8ToTom8FUgu0CAtqKtOKV5V1/QZ
	 AwNqR9J1zws9lWPz6rYkGRID7m4rPOUa/NQoqqYjCiWMFhudDFtBqMqzop6T/AjTHQ
	 iueg3QZKycvrORHujLfrL/TFpGBxn8WIcVvukDiRYAVEISxfu34G8Yf/+wSK+O2YC/
	 EvqFJbC9mSIFw==
Received: by pali.im (Postfix)
	id 7FF28983; Tue, 30 Dec 2025 18:08:50 +0100 (CET)
Date: Tue, 30 Dec 2025 18:08:50 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: WSLv1 vs. v2 symlink format
Message-ID: <20251230170850.n55g42iuvd5ny4gb@pali>
References: <CAH2r5mt=iRzzb=z6_T6-_FgiFkkDUR0U__gf-YN=F8Xe0jxQbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mt=iRzzb=z6_T6-_FgiFkkDUR0U__gf-YN=F8Xe0jxQbw@mail.gmail.com>
User-Agent: NeoMutt/20180716

Uff, that is a hard question. Recent Windows versions support both v1
and v2 layout formats. My personal guess is that the only-v1 would be in
some Windows versions which do not have WSL2 (layout v2 and WSL2 sounds
similar that they could be connected, but that is only my guess). But it
would be needed to verify it by installing different Windows versions.
Maybe WSL engineers in Microsoft would be able to quickly respond?
Or maybe somebody else on this linux-cifs list would know?

On Tuesday 30 December 2025 10:59:10 Steve French wrote:
> Do you know which versions of Windows only support the older WSLv1 format?
> 
> https://lore.kernel.org/linux-cifs/20250712161418.17696-2-pali@kernel.org/
> 
> -- 
> Thanks,
> 
> Steve
