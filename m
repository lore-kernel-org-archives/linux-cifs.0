Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BED383980;
	Fri,  7 Aug 2026 03:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786073313; cv=none; b=mRST3UFgnJgCX2uOCDoNJrUMIH66Hyh1sUN+QMVjp4MYR8r0CWWC4KKEwSlbw64GOBn8cRA827GowL1JxIkoZoW1WykmqOOybUskpnww7vRVqZQ9D7iHOWzvnqHK2C1AoCNauMQxMMqhhVForcSGoPOI4ckIJr4f7x5uKCb35I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786073313; c=relaxed/simple;
	bh=XIJvmCW+WNpQZpkamJVoLnIERVMGy1LNuxqJL/xGh00=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=gY0btj6R/Wgbl76FxG4JDrZNVBfPT2f9oG1zVsEv/24VqlpPtsX44ZmvNsngSWqkrEiCIZuGyWdgQyt6dPFZYi0w81CYg/SqBNgX5/nVoH2vYqSN8zhEZfEvQayULoQB66kxFOwMECvazBg3WwcqZPX0T53L+OGH0Z9D9b2IEms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gRmnuFbY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gRmnuFbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258D51F000E9;
	Fri,  7 Aug 2026 03:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786073312;
	bh=GKy8iDH75Pr9rsRk6i17ioXyTfBVMsSb95FoS6b3Zwk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=gRmnuFbYHq3hDp4bh1/h8AtULzqo9u7S3aakq8GcoM28eaGJ/b1xVAToKroFF8yiN
	 7O4eTIsFLkJYiu6zbi6yGirQHYg8yom+jaVmEtYOLuuph59XzRdnIIT6vL55nGboHw
	 xwCh1wOnQOUVECx1rb2vDKo5u3AXmA/+ijuvP/1jowHmkX6062y2ndVGTE39Pp5N/C
	 0FM9zF4I9U0LwZ/ZNBauycwdKLoBLy+ZSNeNyUT8dvW6mwMmLfopCxCXwCo68C8gcw
	 O78+9IDB5/YIDqo2wjfg3y2AMIaCYID9crEFx8ke9ktiDKUCtj5cywYF8LCcujo7Vh
	 +3o5KdZ7I3jKQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56AA2380A95E;
	Fri,  7 Aug 2026 03:27:52 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtjBVPjsp1bGwhPsVd5cK7hyUSJUbKVtTdv8p85Y=RaAg@mail.gmail.com>
References: <CAH2r5mtjBVPjsp1bGwhPsVd5cK7hyUSJUbKVtTdv8p85Y=RaAg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtjBVPjsp1bGwhPsVd5cK7hyUSJUbKVtTdv8p85Y=RaAg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.2-rc6-smb3-server-fixes
X-PR-Tracked-Commit-Id: ab88cb66cb0028cb8038b64c2fa71b0f3e91d5f2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 364465ab19defc0635d06f13f170c8d5c096de7c
Message-Id: <178607327087.1583560.10598378425312770014.pr-tracker-bot@kernel.org>
Date: Fri, 07 Aug 2026 03:27:50 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 6 Aug 2026 21:12:09 -0500:

> git://git.samba.org/ksmbd.git tags/v7.2-rc6-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/364465ab19defc0635d06f13f170c8d5c096de7c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
