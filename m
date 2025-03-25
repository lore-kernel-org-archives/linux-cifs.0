Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECD5AD51
	for <linux-cifs@vger.kernel.org>; Tue, 25 Mar 2025 08:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742892160; cv=none; b=W+uqm3yIkIrk6OvGZKWgmI3S86w3MJeoWfm9ocrvhsn9V3qxekfo4YEuq1cTDUwQrOXlaiekLcdPydSyNRy9QNQs+2LBQcEFi/y+9O6HTV1KQkPYsU29IarJnPys2JRp4nc7rSyUxkDYIf8wriGJ+cDLq72tvdVXrF/T7t3A6C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742892160; c=relaxed/simple;
	bh=WqUQ3rv6+sCu1j5lOlf51eMliL+tp440WyRxN17EN8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=irbC0fgTses+KFHgYe6DU6Ea2BAs9mlT9OBSe0Gs3wxAsoxX9CuKfmdxoPV8S0MT2+YHLHq0CeYXYQOziHGr6qvqEbw0dhZ4hVPaMg6k0LhZ7giWEnbmMHSfkCzgKzeXGyBGiQBvKmNbeysS1oCPRcER07DH5C/sqN2evTcfnuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afpuBVyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afpuBVyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CEEC4CEE4;
	Tue, 25 Mar 2025 08:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742892160;
	bh=WqUQ3rv6+sCu1j5lOlf51eMliL+tp440WyRxN17EN8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=afpuBVyhQeXxPdMxeM/pYASSi5cH+ynrVU6CofC6ILkt07+apDmWiC08YOURZ7d/U
	 Q7AbfSBDMi7tKkx4ePspQmfxKu5a82VHlZw2P8qyoXBnECrRGsTwshZOkwWjzPO7Oj
	 pMCQE3Stf0IcwLZD8vujQCtYr8sc8UtoXCepfNfy3zECV4mpT77jV6jVJxiP4b5E8h
	 1o1zL3iiMv+r7l7gKxIlIAZzG1Z8P68Az79f4UhnC9YEj49lvYyoHv/EtQmCkj0uBD
	 3cHPyGWOXIXX3SQkkISUHycPZLhQ6HT7DrJV7d90XvBoIa7cTfsFFu8jhbfpXXaem+
	 d4wGZq3pGFTYQ==
Received: by pali.im (Postfix)
	id D152C83D; Tue, 25 Mar 2025 09:42:24 +0100 (CET)
Date: Tue, 25 Mar 2025 09:42:24 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: Improve SMB2+ stat() to work also for paths in
 DELETE_PENDING state
Message-ID: <20250325084224.fc7yoo4zsupojkco@pali>
References: <CAH2r5msmKZA9-dX4G_uXujMuNLHxWUz1yprWRSabu-Bcdp7EOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msmKZA9-dX4G_uXujMuNLHxWUz1yprWRSabu-Bcdp7EOQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

Hello, this change is not reverse of what POSIX requires.

Delete pending state is special thing in Windows and is just a temporary
state, which may be reverted.

In POSIX, the real unlink is the final state and once unlink finish, the
directory entry is not in the parent directory anymore, and such
directory can be removed.

But on the other hand, if the file in the directory is in delete pending
state, then the directory cannot be removed. Directory can be removed
once all files are not in delete pending state anymore and are really
removed.

Any file in delete pending state is visible over SMB protocol to any
application, not just to application which opened it.

Silly rename is not an option here, because file can be put into delete
pending state by windows server itself -- which does not do any silly
rename strategy.

And for example msvcrt.dll stat() function on Windows is doing same
thing. Stat is querying also files in delete pending state.

On Monday 24 March 2025 22:53:35 Steve French wrote:
> In thinking about this patch, isn't it doing the reverse of what POSIX requires?
> 
> When querying a file in delete pending state, shouldn't be invisible
> in the namespace on the client.  Wouldn't your patch do the opposite?
> ie Doesn't it allow stat to return information about a file which
> should be invisible to everyone except the app who has it open (and if
> possible we could make this easier via a "silly rename" strategy as
> some other protocols do)?
> 
> Thoughts?
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
