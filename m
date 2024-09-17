Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6501C18800E;
	Tue, 17 Sep 2024 20:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726606796; cv=none; b=rfYm7lOdsU++DM/Vx9RA+pgh2kq02dS7fgv33Ws46t04z+xswUlaaG0sKY1rSXXZlB7xjAEGNkeuTijmxTLeDR2ATwFOFsmc/ZAF9izbJv3oYwF2IFWAeoUiWSX4iagG3E+Oa42D4KNXCljUjI9LCfFVO7YPJSoddUvtAywO7tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726606796; c=relaxed/simple;
	bh=qQpV+2VnoHNpFK0pwZdmvQjx1NEAfMxiykfE3RbcgNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDQbWmJdaG5gydfg8zEx2vNBq6PEtZbSNY9s+fdUTBdzVXYdOFTgH1CZaiFK7fmt02yHvAUQ5YmrgEl/0Nokm2fqKjbe8mde69kF690gAnPjZxM2et6PXpyIXrlzg2x9znx5Yv/UgyWIFgDBWYWNItODUcnRqcv8mglxrB5iRBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pEOp+N+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pEOp+N+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC19C4CEC5;
	Tue, 17 Sep 2024 20:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726606795;
	bh=qQpV+2VnoHNpFK0pwZdmvQjx1NEAfMxiykfE3RbcgNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pEOp+N+LJDWhCUpjDmP7kY+OKAZrsESeKPN6aHVxYhW08cKokq3JFhoMq9Sf+uPRK
	 1Twjymf3SxdbAD9jCe4qN98lZBmitxUTL2z+T3FqA+qJwBt+g4oT/FLmF04KluKV7o
	 uXvbqzhfg2c6FaTRElnnM1/MOcS56AsbsdMEF0Wh1sr0ycC2G/aXE9/H6si/ovmUW1
	 0U33QJDzLXNyFRL5AxQQ87fzVJHL3XgmoFXGCPDS37V5Wd0E4E2dRaPodzSjHS+vwv
	 DXpDsovcqHEYkP/7C/sGJu4EARWx0OzxTph9zXPo3kqjADrNtCaz05RN7lzUNil3/N
	 Pgidb3jMB2DAQ==
Received: by pali.im (Postfix)
	id 4A09B7BA; Tue, 17 Sep 2024 22:59:50 +0200 (CEST)
Date: Tue, 17 Sep 2024 22:59:50 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Jeremy Allison <jra@samba.org>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <20240917205950.dvxvs6tghrffo336@pali>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <20240917200600.6smfxhrppkyjuyku@pali>
 <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
 <20240917202921.ty32zzmhrg33knpy@pali>
 <ZunnGhOogEQU2Hje@jeremy-rocky-laptop.localdomain>
 <20240917203431.w5dejuwfkmabrewz@pali>
 <CAN05THTVav8HOCk6V+5eg-BTESZDBx2BuQOF1c=Vn2dFv_UNxw@mail.gmail.com>
 <ZunqmhGHniR/4a9d@jeremy-rocky-laptop.localdomain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZunqmhGHniR/4a9d@jeremy-rocky-laptop.localdomain>
User-Agent: NeoMutt/20180716

On Tuesday 17 September 2024 13:46:18 Jeremy Allison wrote:
> On Wed, Sep 18, 2024 at 06:44:39AM +1000, ronnie sahlberg wrote:
> > On Wed, 18 Sept 2024 at 06:37, Pali Rohár <pali@kernel.org> wrote:
> > > 
> > > Ok. But then I do not understand why Linux client parses and uses uid
> > > and gids which are sent over the wire. If you are saying that the SIDs
> > > must be the only source of truth then Linux client should rather ignore
> > > uid and gid values?
> > 
> > What I think Jeremy is refering to is that mixing uids and sids in the
> > protocol itself is
> > a protocol design mistake.
> > Because this means that some PDUs in the protocol operate on SIDs but
> > others operate on
> > UID/GIDs and this means there is great risk of mistakes and have the
> > sid<->uid mapping return
> > different results depending on the actual PDU.
> > 
> > Sometimes the sid<->uid mapping happens in the server, at other times
> > the mapping happens in the client
> > and it is very difficult to guarantee that the mapping is consistent
> > across PDUs in the protocol
> > as well as across different clients.
> 
> Thanks Ronnie. You said that much better than I did :-) :-).

Understood, thank you!

So based on this for me it looks like that for client it would be safer
to ignore uid an gid for reparse points and use only SIDs.

I hope that somebody will recheck that client code in wsl_to_fattr() function.
