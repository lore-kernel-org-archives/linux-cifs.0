Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2D61C2BD
	for <linux-cifs@vger.kernel.org>; Fri, 27 Dec 2024 18:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735325501; cv=none; b=Gc2c/Vk0Zpe/EzMPAoMrJ3iijWnsA9LR2196Tr9VqKbFVHZQPj66DFDHe8R1JsnwhxjNXMoSJPeUntmhorrFpQdDil/OkhNjbTthzCU6NIev3yLS50ic1me5dckU2zyXv5QZEZJaVJWB5444BOLlAQh9tFC/VdRYofLfAuIYI0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735325501; c=relaxed/simple;
	bh=B9b5tcg26NbdFtTjGf/M4V1CS1MMIEvGjk4WMD2+GHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c5M+yT0y90sO98upIo3FVxFwrOzcx1cttYa03oAzGFCk9KIzN4JxkqBisswl6E8FNLDqZssc/ZB3E+4O/VFzMW9xEJjUIJ9Oqew7mm/FbP7+tenSAIflNL2UNm4P6M0q2ZleTY5+wP+7NT9HKTaZFDwmn5UpT95+FvA1z1bm6R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q40dPJKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q40dPJKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A682C4CED3;
	Fri, 27 Dec 2024 18:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735325500;
	bh=B9b5tcg26NbdFtTjGf/M4V1CS1MMIEvGjk4WMD2+GHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q40dPJKcR8+lOwkgT11qW60rHw30ToowpgT2KfdWxl6LrgTdbxhgjuU7yjop0vQhn
	 eNoWOnA0UhIktIypQoRBwayFa9H66LtK2h4N3eupe3b6nMoR7ZCXZs0pkVOGv4n6do
	 DbQiTkanbbadbYEufn+aeROc4mGW+XqVRgBNiLxqBfYmcr9ZS6JqLulwtJh22uZTwF
	 RBJ2wYOwZnZbcmn8+QaFsr36TpCFvEoguO0BIrLSWWZNSlsSxqzDsAWbMoQx4gsdL3
	 564jMgbA6762AcKlZIjPdns1FFXltj8k13nMAsWS3Q9dN/h7U28uhS7kCumVYxDDHM
	 nMvOwyaG3PaTA==
Received: by pali.im (Postfix)
	id 7A6DF787; Fri, 27 Dec 2024 19:51:30 +0100 (CET)
Date: Fri, 27 Dec 2024 19:51:30 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Tom Talpey <tom@talpey.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: SMB2 DELETE vs UNLINK
Message-ID: <20241227185130.idio6hh7w4pcpqfo@pali>
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <20241225144742.zef64foqrc6752o7@pali>
 <76c28623-b255-4589-8bad-7e576cd1687c@talpey.com>
 <20241227163202.ihp3cxmhe2sehxoh@pali>
 <749690fc-4647-487b-ba21-d208d72f754e@talpey.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <749690fc-4647-487b-ba21-d208d72f754e@talpey.com>
User-Agent: NeoMutt/20180716

On Friday 27 December 2024 11:43:58 Tom Talpey wrote:
> On 12/27/2024 11:32 AM, Pali Rohár wrote:
> > On Friday 27 December 2024 11:21:49 Tom Talpey wrote:
> > > Feel free to raise the issue yourself! Simply email "dochelp@microsoft.com".
> > > Send as much supporting evidence as you have gathered.
> > > 
> > > Tom.
> > 
> > Ok. I can do it. Should I include somebody else into copy?
> 
> Sure, you may include me, tell them I sent you. :)
> 
> Tom.
> 

Just note for others that I have already sent email to dochelp.
