Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B591DE4E5;
	Fri,  5 Sep 2025 20:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757103427; cv=none; b=KoR1rwbxeul2qfbOubdIE0zhOHQaSW+68GWBtUsy3ZDHgVD3lwkWpbIRPYZAPPpDrMFbx/h70EsnyHas5oflmRDJQJCDLg5g8j3JyFIxnOucqVdT3tvqVLqY2OMAczB+acjbZpP0S7JAYQj2MpJsDpBeiGbyq8Ji/uECXKhmSuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757103427; c=relaxed/simple;
	bh=p7rhcuoaeNgdUbFbIggeCYP5Du7DAdh7UkNKpA7BgQI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=DNP5VvuhOtT67BrxRy5HE50jj/AVv3bU5bfw7cQoxEF1dqyJoEC0+0rskvNgfGPHh1qoTwLOBBkbgf7juHvZWEqwEC0Y+l+bGPw9sIx3xuqENhSchXd43k5omCtnPwLWNUnJ9nKWKvGEveOuyeQJfegsp0jQoBF5ZUG12eK80e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCMmGUSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCMmGUSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736BAC4CEF1;
	Fri,  5 Sep 2025 20:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757103427;
	bh=p7rhcuoaeNgdUbFbIggeCYP5Du7DAdh7UkNKpA7BgQI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QCMmGUSiUS0wSkEHTNj8eqhZtTM+fD3T15gmmO79n86VFsy7tL9erhhN+7hX39jJD
	 fsZSUQFe97WoAcXqTAqeHkzKJOiRpUi0Gzdx1fKVy0i9C4fWvVcuOOqAK1KCJtCgYJ
	 MH4MGKdjWaYeskVY1f2GNBBcBIaDzI3T2WH1v/yGEBMvofqTeyK9YYgwzRf3SS2gVM
	 bxGUX4U/j+7Sx+9MP9Mv+ormLHh5STdeOakkLRGSQxbGRSKV7kPgQfnsFiao/c1QQE
	 BIzh035zqCytum8rCOFl7r4JasSNa2nd37kVLAVsJSmJMmKvU+8RmXWxoG3SwtQivr
	 QJHbgKH2jZCCQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34222383BF69;
	Fri,  5 Sep 2025 20:17:13 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtA224oMgWCMhxo4xH_8GVziw6dUWY7zG+0WaRm6FzV+w@mail.gmail.com>
References: <CAH2r5mtA224oMgWCMhxo4xH_8GVziw6dUWY7zG+0WaRm6FzV+w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtA224oMgWCMhxo4xH_8GVziw6dUWY7zG+0WaRm6FzV+w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-RC4-smb3-client-fixes
X-PR-Tracked-Commit-Id: 70bccd9855dae56942f2b18a08ba137bb54093a0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c2f3b108c09d1a8e2b20ce691df6a59d30351b7d
Message-Id: <175710343169.2676293.9506090944323069774.pr-tracker-bot@kernel.org>
Date: Fri, 05 Sep 2025 20:17:11 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 5 Sep 2025 10:13:36 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-RC4-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c2f3b108c09d1a8e2b20ce691df6a59d30351b7d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
