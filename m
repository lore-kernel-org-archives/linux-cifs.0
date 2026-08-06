Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3FB4AD693;
	Thu,  6 Aug 2026 23:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786059451; cv=none; b=JChH8QdmBlFOKswaNk/MIFEzp62nCw9KiNl+xOjTHQUra/O+WpmhJePft4Put6Ckdk+MTrFNoI77NT/Lk0/S/9ELzIj/mD7qwaINw/Rgaz2ph7w4Ar+vV7iv3EED5fNNvfQ3h9xnwqF63elXjLAvYdqub80me3iOLv3/efY2v0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786059451; c=relaxed/simple;
	bh=CYslPxuYh1KufQRhAJTRrCZMID6Fb218ZenPhhEhmIM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WZRE+krLGskFexawl/EtNQTzopB5CWR2uHkPN+ploCmA6Jo559j2PvKanBTS3qoQvkBTfbFIg9jwR6c1mCayGxh0v3Zs+m65f+RcZ9VFEMk/ksVFvuQx/cjpwvMakK3q7lFbPHqvsNpmMq9N2wfO3mDFTSJ1qOyZSEVkTOopSXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fI6G/04a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fI6G/04a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454071F000E9;
	Thu,  6 Aug 2026 23:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786059450;
	bh=SzW4hHqVKTPtkON2tBcmXXM9IO21StKM6sZkVUihH1Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=fI6G/04akMYIQj5c+Riv6ZULQvVLL4j8iBkFIbgqhM1+ixE3ydqkAse4PolOsP057
	 0QRdMkzpaRsnUhJkhCewciXJIUJU+bvY415uT2wUsfz30DLadGfBLH+Gyc28nhOXy/
	 n+gL/sZr899J8zdJrbPa2gMKU0qe0An98wpHUIg+F/kiYX3oxwgEsxJxYflBk6ALL2
	 zoP02EAEW+pg4npxsc/2eD5VRX/u7mtAuGWvnd5hWthPjrsesydADmIINaxsHKovLa
	 OLv5dNKBRjZkLA5P42E23cMHKmMHUZIjHIxLa1soSOmWcw9aF0sfFa1vHDKEfXPNyA
	 H7DsUn3cBQEGg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93C0A380A950;
	Thu,  6 Aug 2026 23:36:50 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtVcOC7XuoAUQkzV2tGpv5wBN7DOqxz0SD+nEbEPBLFbw@mail.gmail.com>
References: <CAH2r5mtVcOC7XuoAUQkzV2tGpv5wBN7DOqxz0SD+nEbEPBLFbw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtVcOC7XuoAUQkzV2tGpv5wBN7DOqxz0SD+nEbEPBLFbw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc6-smb3-client-fixes
X-PR-Tracked-Commit-Id: 26fa4d17c023dbe5427a92d3a7bd9ae1d1e58bc5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c0a27675eaf08255017b3cabc28c99c0cd71f468
Message-Id: <178605940922.1526107.9804511637645834694.pr-tracker-bot@kernel.org>
Date: Thu, 06 Aug 2026 23:36:49 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 6 Aug 2026 17:23:14 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc6-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c0a27675eaf08255017b3cabc28c99c0cd71f468

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
