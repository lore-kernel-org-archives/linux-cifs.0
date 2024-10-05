Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7AE15AF6;
	Sat,  5 Oct 2024 14:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728137231; cv=none; b=cCf34yngvf2mshiXVsbRckUxQBUPW+xhkmSHSfsX5cn0FG1EiBRxXw5rFzZNYGehu7q1IZ+YCt+MpTLTp5TdIcIrk3hv8nZ9EC8EdTaPgCfq97AhP/XMZiFu1QylmrTpFuE/1jEdL2EoUbAG9Dq/dHWqs1Deqo5fDeCTHXJjiAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728137231; c=relaxed/simple;
	bh=l/2N8v3eS5wD5kJi5SunXdcLRDxia6GJ4kYqOWJil80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qECke+3dSG/0pVwa/nLOOsanZlViN6EdChXA0aP8fb+pYeqDxCbrWbc6nztodR3UaV+n7WeqteAqSzapzhaVEIooEjk/Lu4MKdGBUONkbHSQOHekMqKISrkf28zrQFjR9mv1WmNOAIUZYJAZJLsLT9VBVcglI21wBrnh3Xr95No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K+CIu7wP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K+CIu7wP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933BBC4CEC2;
	Sat,  5 Oct 2024 14:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728137230;
	bh=l/2N8v3eS5wD5kJi5SunXdcLRDxia6GJ4kYqOWJil80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K+CIu7wPAfZQXI5pdFrt0Heqsejfyx5k51sCbTmyMyubRTiGGtcMMe3zSOTU1HeQd
	 xnLrxYPKa3DkzPLEppauil6H0JUetW7upEgddVvrQN+Bst/qajOu6300QB9T2s47Nt
	 yFCy+8478QDh/ylM7EQSQobD410w88BIHIZH6gUo2TQ8pJ3T+bblqScYXISntFUnRX
	 gk0xbt7ssKbALT+nkiKjx/Yv6UepD26rApPF5c5NmvmMeV+NlFqRDs8x7hZPU2BnoK
	 s8JoRx8JB9g5LI2QCbd5DZ7eudrwfLrPGIn+/zrdinL5mEnLJT6VJmcFJQ8wIxBSrb
	 XKguIcVmfrBVQ==
Received: by pali.im (Postfix)
	id D87F2648; Sat,  5 Oct 2024 16:07:04 +0200 (CEST)
Date: Sat, 5 Oct 2024 16:07:04 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] cifs: Improve support for native SMB symlinks
Message-ID: <20241005140704.eo5bpfexfspxsdrb@pali>
References: <20240929185053.10554-1-pali@kernel.org>
 <CAH2r5muq4S+w-W-J+YMuJ9RzPJsbmf6zKuGPN0H8DohXe--1uA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muq4S+w-W-J+YMuJ9RzPJsbmf6zKuGPN0H8DohXe--1uA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Sunday 29 September 2024 17:03:31 Steve French wrote:
> For patch 5 it could be ok - but wanted more opinions on that ...
> since wouldn't want it to break POSIX - e.g. what would happen with
> this patch if a Linux server changed the target of a symlink from a
> file to directory (or the other way around) - is there any risk of
> breaking POSIX symlink semantics in a pure Linux->Linux case with this
> patch?

I reworked the "cifs: Fix parsing native symlinks directory/file type"
patch to not change anything when server announce POSIX extension.
So V2 version of that patch would be active only for non-POSIX SMB
servers, like Windows SMB.

I hope that this would address all possible problems (not sure if there
are any) with Linux client <-> POSIX SMB server scenarios.
