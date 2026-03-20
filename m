Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECC3317176;
	Fri, 20 Mar 2026 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774023955; cv=none; b=UOZJviNNNNfvpcAL52UhDqQowkTBPZoXDqKJEn5k9cn3PmvnOEEt05fP16kv1s/otf0CXlGRjIHRf784AO3c9eG3AWE44Am/GLI0HOu3pT17pVzJKip+VKzR0sEfimdViF+yu7JTff8xMMRVEtOpj++ZLny7C3Sot3iCDgU/4NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774023955; c=relaxed/simple;
	bh=i8tbRolrcuOuncR7LpFde7SJJ6xzqaBQyNcicXnOd9o=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mi8Lje1W0NMRIWjMf85XNqjwNTqjypJgYRgFYNR6FDdirQo46Tc7oTC0jkPv4Yaqr5mTWPEo89NB7RKBop3bH6NR/ejO6ZKgghfX2U51y8A/g5K6fdoe41wgmKUiiHWKp2ZvdWT2IZAquy3gzbpBLhk3HGoNqSZnO8GMfZ54q2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNGyWWzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNGyWWzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA07C4CEF7;
	Fri, 20 Mar 2026 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774023955;
	bh=i8tbRolrcuOuncR7LpFde7SJJ6xzqaBQyNcicXnOd9o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ZNGyWWzM4OE3oUk3c0pw4+OtpvBAmexJlq7jemgeaPbgQyNmrQWKR3xecxfkmCggR
	 MhcLtOr6aKhiANVoBFcxyeNuZ46L4eDNd1U8Fg03OfN++rGEYFoNWC25FxW4JY7EUH
	 LmjtbgVB03In3QggfT10KUgSpEjVWCugbjfq3WNDcUICs8uby35ob7cr2O1jWkBisZ
	 Ll2eDY+aIJn+L9bDGCXH6T1JOkt/GZ6sCuo5tflzJ5JQRqnqDrG+4lb7bYoMGooU48
	 i5HfPUgBrl30kLLBAdjOtugWJEA22q42PzBdoGvoveHh67cXLYN9ZPMrIZ1GqaKVSb
	 gdJJeu28Anu+A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D4AF380820D;
	Fri, 20 Mar 2026 16:25:46 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt6RqqfE1sS=AEROe1O8DuLRhDs+HZ2vP=nymR7CvkTMQ@mail.gmail.com>
References: <CAH2r5mt6RqqfE1sS=AEROe1O8DuLRhDs+HZ2vP=nymR7CvkTMQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt6RqqfE1sS=AEROe1O8DuLRhDs+HZ2vP=nymR7CvkTMQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v7.0-rc4-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: b425e4d0eb321a1116ddbf39636333181675d8f4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f268964788a90966f8d18fa00adb94d4ae2ea812
Message-Id: <177402394515.2556506.1769317126783412054.pr-tracker-bot@kernel.org>
Date: Fri, 20 Mar 2026 16:25:45 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 19 Mar 2026 23:58:31 -0500:

> git://git.samba.org/ksmbd.git tags/v7.0-rc4-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f268964788a90966f8d18fa00adb94d4ae2ea812

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
