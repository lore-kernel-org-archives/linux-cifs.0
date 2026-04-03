Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB97E347BB5;
	Fri,  3 Apr 2026 04:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189548; cv=none; b=aGoFT1I6x4t2iYhNWr4jrLvVSe6bpeWP1sIvTrU+Iw75YZuag/sVkQtGWVNNlG6VXY0GvPG4GHOKX3AgxyDRNxyELWHeaukBax4fihtq+x6WiwsVrHQFVaDpDJZU0z8BDhCd8zRuGKrUYo+n+F6E7eKaHTG+fI7AbclBZVluqJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189548; c=relaxed/simple;
	bh=s39qDxJ2C8b5RsOeCJPVEXnVFdSEe1kcI4U71Sdl0lM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eYaJml77eG4uqndZKwQrruE4EOjw4wxAXjFfNCB9u3nhw7TPmrswN8X5MKq+ayNGoKXKFHM75vAVRfHo+goJ3sIHGRCWDHx3S0Y95rtahI8AzVIdiARUbcagACwVSHa7gyrQisrh7uXkqxddxZNySAUKuKkvnHP+PDHIB86E7Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ddd5iG+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ddd5iG+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B690AC4CEF7;
	Fri,  3 Apr 2026 04:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775189548;
	bh=s39qDxJ2C8b5RsOeCJPVEXnVFdSEe1kcI4U71Sdl0lM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Ddd5iG+3ssN3O6Up6c60EbKPwYWo09s6MM/QUN4N4/MQRK8por7yCBFnfUipVD+KA
	 tnTHGcGPONQBQ99jVF3UGVE7NO3o4cXtlceZLosZoUxnSnI1uQaSIYijs/ErcfrRy3
	 q+YPa3ZpLc0D6zYehIXuiNCYOXfp88EIJmBslOGIz2eSbM75g8RxJjfgcBiYrSTvz4
	 jvRRlqOqoFD+zGTzaJOVUB43ECowvPp9UWlMuIoPb7OMBagiSlYtcgzOPBPARxRlbl
	 krFAvbNHnImYa70OpSAG/ptC/KMltQj5U2p6i2sVABVX2+k+p+dwglVWjbMGae599k
	 mFh3gIZG131aQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 030663809A09;
	Fri,  3 Apr 2026 04:12:12 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muNKQXCpS0dPuXi0jyA8KeT+UNjc+LYvRJWjuY3Sh34FQ@mail.gmail.com>
References: <CAH2r5muNKQXCpS0dPuXi0jyA8KeT+UNjc+LYvRJWjuY3Sh34FQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muNKQXCpS0dPuXi0jyA8KeT+UNjc+LYvRJWjuY3Sh34FQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.0-rc6-ksmbd-server-fix
X-PR-Tracked-Commit-Id: fda9522ed6afaec45cabc198d8492270c394c7bc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 19abf08d5e66713e7e02a3e160f51647512c1302
Message-Id: <177518953051.733087.2729459406351134240.pr-tracker-bot@kernel.org>
Date: Fri, 03 Apr 2026 04:12:10 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 2 Apr 2026 13:56:27 -0500:

> git://git.samba.org/ksmbd.git tags/v7.0-rc6-ksmbd-server-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/19abf08d5e66713e7e02a3e160f51647512c1302

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
