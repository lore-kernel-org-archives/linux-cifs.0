Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C639019E99E;
	Thu,  6 Mar 2025 19:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741289195; cv=none; b=H0uyGiWa7IJh/ou6WnG9Mv32SD9BI+FdOk0ZVu4A06sslTJ/rGMrtP6xU7zSJwfaqXgECQWmdWbldhb6S7WsrJAkjtrtCdDvN2CbjNw9H119jtGek1BnrFiNdwgtgy4qSer8pXD7lRsOMIQLT8WOZV/PlgMaOBwMUkCwBVlpvfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741289195; c=relaxed/simple;
	bh=0Dxq6QbGxSCtnrFFJSB2KhO5eltt3CCtLFaJtaquymo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TuMY7+rUVrmtAGidS8Rt0VF0xfUs5RBPHkfOfsJbByBwM0j2z35RWaMWbLzS0d8HU37WvkOSdgjX01TUVhsjj6+UMc8HHoEhWi5sUyon60zgDWWJeIkvQyYMCBV25pasfXKSbu9Ba5kPt0xlZhS8OgftBibD/XzKFxawD14fYvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gm4oOCur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gm4oOCur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14C3C4CEE0;
	Thu,  6 Mar 2025 19:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741289195;
	bh=0Dxq6QbGxSCtnrFFJSB2KhO5eltt3CCtLFaJtaquymo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Gm4oOCurgDdMXXcrgOBv1Glkfq2R2UCeafrcNs4+/u+LeOhn8GyBMm66mpjXtcqLS
	 usaZsPqMOYCOC8XJY/CyjhdZfpJAyvBrIvxkBaDqtj+fqsIz3lP6YDfpuM2BWLrhWn
	 mNqZgvEeIpEBW15KfJHjIVppZRsAaOUl1g4ZY3JSDiKF1+Lq9KhQ5kevkUU9DG0rHF
	 hdf5QFXVzadHM3tNBwZfD8FfEkm+jETwhbK3VxKZhtoDBJWLrX4svNLIoDjU7JK9gi
	 KD2HyMX3u+G1UdsanQ3Got5pp5cgroU3bfJC926bKLjprOuuvboZH3DfxosBwFKu0x
	 QeQ/rZLbNgk9g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33F30380CEE6;
	Thu,  6 Mar 2025 19:27:10 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt0FL5HNGQX_csHO3Q3sJ3Obn6phdtGxxM29XXSX9UeJw@mail.gmail.com>
References: <CAH2r5mt0FL5HNGQX_csHO3Q3sJ3Obn6phdtGxxM29XXSX9UeJw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt0FL5HNGQX_csHO3Q3sJ3Obn6phdtGxxM29XXSX9UeJw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.14-rc5-smb3-fixes
X-PR-Tracked-Commit-Id: aa2a739a75ab6f24ef72fb3fdb9192c081eacf06
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1238f0af13495e14e1f40d011b9b7b414bf387fe
Message-Id: <174128922880.1751313.17571531385098779680.pr-tracker-bot@kernel.org>
Date: Thu, 06 Mar 2025 19:27:08 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 6 Mar 2025 12:31:47 -0600:

> git://git.samba.org/ksmbd.git tags/v6.14-rc5-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1238f0af13495e14e1f40d011b9b7b414bf387fe

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
