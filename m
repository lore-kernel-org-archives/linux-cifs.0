Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BB417C68;
	Sat, 11 Jan 2025 20:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736625654; cv=none; b=MFhXLJG4xRMsnxX21xhbN53KOTtx9giTfDFiGUydyPlT3fqxmyUH/OBQ26Hz5ItI/3WfeXOo98aU6cT5cgZxHy2zrliM7W9Yj05vcOBVnZQuKPODZ9ER11R8S+PW/m3xDdMyGJoGLu7ZD48DygAhR5oHKj1ue9Ge6vYtHzdnCh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736625654; c=relaxed/simple;
	bh=L8B0jdahI0txjnWRSdjMLBibQXX5fiaeHgw9hIMuAd8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=OXHKha2ymcUb5fQiPOCWHdpDt21e0TdS6NrVR0b0TEoxQ58r8bErzV51oECpaeTagZhpzIaCmAHloupp6D0DWYCo+thbxS0K3icZ9QIezumjr/a1w8zlTY3UBME+u5xeOVbXt4NhHrTY6bvjF3PdH0eZrHnr/rlszLmfi7uRJEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bB3UpRKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bB3UpRKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77A7C4CED2;
	Sat, 11 Jan 2025 20:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736625653;
	bh=L8B0jdahI0txjnWRSdjMLBibQXX5fiaeHgw9hIMuAd8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bB3UpRKBKMsN3hbxn6bKM02wxwsNt+5sFEcOlHWzEB7pyw58jVbTZhsNhIYr0eosg
	 ui44CxO1h9pUzDX/Il+z7+EPj2hxdOmQVLe6DkIyyXstuSFFtobtf7GINSgKiZY//k
	 mxvwwo1Q3/ekunWHLU2ySovGsMgWgC/gGVISkVeSbRDkpFliyv1XEIt+q8yFd4dPcX
	 nkK9jsdVXZwK8orL3xzqp53UDwlbpzyWp9xaWM2fSI31qsh2R+J4JsK2tv6iWl3SYe
	 QFmz6HF4166MrT8PLjvAhLNtBnKXfSz9TcG3UuhIzX04bWFejaBlu1Jnw9dAJ+qTKe
	 4hv3LasvJKVtw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34AF9380AA54;
	Sat, 11 Jan 2025 20:01:17 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msBKUWjPu28QaiG0XU=op7b+p2eNfa_uBORhi6vDscMGg@mail.gmail.com>
References: <CAH2r5msBKUWjPu28QaiG0XU=op7b+p2eNfa_uBORhi6vDscMGg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msBKUWjPu28QaiG0XU=op7b+p2eNfa_uBORhi6vDscMGg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc6-SMB3-client-fix
X-PR-Tracked-Commit-Id: 20b1aa912316ffb7fbb5f407f17c330f2a22ddff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 57162361c3c5405e9be836d06fc9db7efd499217
Message-Id: <173662567574.2439897.1708990246408473358.pr-tracker-bot@kernel.org>
Date: Sat, 11 Jan 2025 20:01:15 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 11 Jan 2025 10:08:03 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc6-SMB3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/57162361c3c5405e9be836d06fc9db7efd499217

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
