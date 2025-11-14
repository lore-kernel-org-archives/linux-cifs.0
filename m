Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB392191F84
	for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763132425; cv=none; b=IjMOz3mdOl6oE1befQo9WiZuq37YrK7hHKoxyo0xt6kENpKv9NBRX5+yoPygYj6u9B0OAJaZCQxz/GfoGpoR9rkGYB+nwWZ37V1CFD7JTPtA5oTVcMagELcHGgVqcGfATYWtCBpvo+m18OVonuN3DvUjaSaWuMBp4BgoxyocZ0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763132425; c=relaxed/simple;
	bh=WgwFLkOibfVZyjr6BcdNXbIDJG/Q3jo6lzTRMxCvVfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYt5EMtFg4knPdbx3MmMywODoz4uf4kOdcdSWwhsnr6H32/epdSw3JqAasJ8yOtOXC66MhUoM+2iZguvWRFohEbWI9KIGTiniZD4yLFdQO5i5Oqnsw4DRPcN6+tP7yX6fWr4aMAroLbwbf57zH8ncyWY6F8XNjEA7BWZv3KsQb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pPThWw5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pPThWw5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFBDC4CEF5;
	Fri, 14 Nov 2025 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763132425;
	bh=WgwFLkOibfVZyjr6BcdNXbIDJG/Q3jo6lzTRMxCvVfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pPThWw5Q+vZNQdadaa06WGeFh3XfUTeKjT2HWOOOXg7RkGjiNVb+oDp+Pybk2VkNl
	 JfblSe3bsX1fZNqMVLw2WNNMS2DrsGPIZhjG9ke8cWhKtMCFZhr0UdWS03iL+ceNPs
	 setP2oAElMt7q6N8KRnX2KRwCGRKi5P2Vji8DHPjveFip/03HkpFY3hY4m7nwU1XNg
	 q1V62QVvtgnwQbrsTHIoCA3wb+OO5N032MHw2rYWMkYksBhw51ou6jmgnf7Zage8yB
	 c2+PwB1qAGNCIipiNIDc1GKFWc7ItabpkYzMy42RdKLrBQCm14diZ+BeqavnX48SEx
	 B2wwkyFQk9qXg==
Date: Fri, 14 Nov 2025 10:00:23 -0500
From: Sasha Levin <sashal@kernel.org>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	David Howells <dhowells@redhat.com>,
	Bharath SM <bharathsm.hsk@gmail.com>,
	Steve French <smfrench@gmail.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: Re: Request to backport data corruption fix to stable
Message-ID: <aRdEB6L0_vYwEsNT@laps>
References: <CANT5p=q22P+zXHW2vH-n+W-zRe7ZWNORgh9gvoUOGpV6VMF8Fg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANT5p=q22P+zXHW2vH-n+W-zRe7ZWNORgh9gvoUOGpV6VMF8Fg@mail.gmail.com>

On Fri, Nov 14, 2025 at 04:42:57PM +0530, Shyam Prasad N wrote:
>Hi Greg/Sasha,
>
>Over the last few months, a few users have reported a data corruption
>with Linux SMB kernel client filesystem. This is one such report:
>https://lore.kernel.org/linux-cifs/36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de/
>
>The issue is now well understood. Attached is a fix for this issue.
>I've made sure that the fix is stopping the data corruption and also
>not regressing other write patterns.
>
>The regression seems to have been introduced during a refactoring of
>this code path during the v6.3 and continued to exist till v6.9,
>before the code was refactored again with netfs helper library
>integration in v6.10.
>
>I request you to include this change in all stable trees for
>v6.3..v6.9. I've done my testing on stable-6.6. Please let me know if
>you want this tested on any other kernels.

I'll queue it up for 6.6, thanks!

-- 
Thanks,
Sasha
