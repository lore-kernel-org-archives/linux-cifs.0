Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B098364D6
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jan 2025 17:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737395550; cv=none; b=tNaO+raDi5oWZy/oEC+BYQCV4KtE0fP7SnI+8ITl6pX3+5YR4SiUp6bwgq3+e9TrII4W7m+jGuv8eTvaDrYEpzDA12HMzbgwrTnIT0sMAbjpFvccMr5GwVAfwk0Z0xzLeD+GRdkMXmhlaYgMgJReNP8Bfj/5LHadjxIpOR8A+xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737395550; c=relaxed/simple;
	bh=nJQKCKVr35wPoNLV0N4tHd8YT1d/+rf8JEYkiP67DFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X1JcoERqNQ34B0iRrn1aAisc0Ok7D5c6EGF7IwXNQ8l1HDjfTbAna422mrdCe1+QSnxjHgI77maq49oWlnRkxOKXnJXhL4G5Q90QCxmbJfP4aQAHVe0qKAM4+INAq+s51qjJkwJ0P7NDR08bv/UiQEGQ9rWdrqHFLusXoPN09Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Shjvgwh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Shjvgwh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817A7C4CEDD;
	Mon, 20 Jan 2025 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737395549;
	bh=nJQKCKVr35wPoNLV0N4tHd8YT1d/+rf8JEYkiP67DFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Shjvgwh6jy5+Wd2fxYm9acQOO1MwgFdpwiKWSBoqOMyHhqLNb3ojmUipwDPOCQHO4
	 6BrbAZGZKApBQenqnDflc8iQPENyspi/nRwIl7hTzKso6/hjQKSGRVURUQZuNnhcNL
	 F3FQjRvYdRUm5CSU51B/biJRyiRmDHLpul8+7IRjX/mQIPPOcVx0pTwEYr8XeHf62+
	 +0Lra4Vdm+69xRBIXHQ8oMhvdZbKre3KMEf6PaX+W/aTWv4+7QGIj/g3ccCULp0Srr
	 qL780sYYCntT+mtpNO6f4qI2BlfamAb/peQPoM+yzZS80RVd6EG1nQel5et3rtwYmA
	 be5Fd8Kl5Xt5A==
Received: by pali.im (Postfix)
	id 53388A28; Mon, 20 Jan 2025 18:52:18 +0100 (CET)
Date: Mon, 20 Jan 2025 18:52:18 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 34/71] cifs: Set default Netbios RFC1001 server name to
 hostname in UNC
Message-ID: <20250120175218.jyq3iifulujggukp@pali>
References: <CAH2r5mtOobiuE1v5Qf0JqEg7VttodHJy-95KFOyYHtVsx=bHfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtOobiuE1v5Qf0JqEg7VttodHJy-95KFOyYHtVsx=bHfA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Sunday 19 January 2025 19:38:23 Steve French wrote:
> >Windows SMB servers (including SMB2+) which are working over RFC1001
> >require that Netbios server name specified in RFC1001 Session Request
> >packet is same as the UNC host name. Netbios server name can be already
> >specified manually via -o servern= option.
> >With this change the RFC1001 server name is set automatically by extracting
> >the hostname from the mount source.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> 
> Pali,
> Is there a good way to simulate this with SMB2.1 or SMB3+ mount to Windows?
> 
> -- 
> Thanks,
> 
> Steve

Sure, it is very easy. Just call standard mount with -o port=139 option.
For example:

mount //hostname/share /mnt/smb -t cifs -o vers=3.1.1,port=139

And you can watch network traffic in wireshark.

Just to note that for SMB 3.1.1 it is currently broken and other patches
in this series are fixing it:
https://lore.kernel.org/linux-cifs/20241222163050.24359-1-pali@kernel.org/t/#u

Your mentioned change "cifs: Set default Netbios RFC1001 server name to
hostname in UNC" is the last one in that patch series.
