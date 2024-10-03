Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88151A7AF7;
	Thu,  3 Oct 2024 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727974403; cv=none; b=gBW5+UOqRECooz2nXJYFiAsM6LzE39gHHWDMIPkpGzY7GNaaP8E2UY4fjKUDa7+CyaH0UmCERyU6fJy6rL46+ak5Lns0u336iuuU/PZoQzAnharwmu/AOVMwkwkvj0s4fdIrs1xd6BuDh8+DeQFQ3xMcHjx6qFIAlXA8Tk8hvbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727974403; c=relaxed/simple;
	bh=75iAkSUWEWuc7I1DkD2M6bt2P6HP7Q7s70B7og0EgUU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Q8EMbt9E0m9+dP71Bm4wU47Cf+WAbphw7rDnVpK678Lq1vIDJkT39Vk9JHHyNrbXrUxz6OEXGj9a7YBQIe6xxpb2CU1DXB6WQfDf9n+auOOJNreiMFxl5taLskPMcBvVw9C6EtlWUWy+XN9KsuD8wKHHt8Q7WE5DEKDvKfJ3G0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z94Kd2N/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z94Kd2N/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864D6C4CEC5;
	Thu,  3 Oct 2024 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727974403;
	bh=75iAkSUWEWuc7I1DkD2M6bt2P6HP7Q7s70B7og0EgUU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Z94Kd2N/RummWB7EN8z/S0DnvZSpb6MPvk/3IuieajsFO6EDcogMP3SVpBdYcVMwq
	 MkNyp2gMj/5wIQ5YEsJ+A3dDn4uXyyT8k7JDE9tD+aQ9hfyzf9/5Cwmyq0vxGRanDJ
	 +ydIHrAjkV7sBL/pwE2iybciKQj5bGhN1WBMQX/+EZ6LvnPukW8hrll7kB5EikBMDA
	 KHASdmxTk9dwhFVjRqWspfiIX1lCm4vsb7QCXnovNM1DzNJrAU0sec4ZQk/cgFuoC1
	 mGkOTmlnIt0lTYyA4s/zAgKpfW40PgHnNU5OjqWOpbVOTFjgtPCPNkArM9I5smfwN4
	 xMsMThi0Aj96A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 340543803263;
	Thu,  3 Oct 2024 16:53:28 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtK7gFUwQfmsBpg2LKPLxkvewsYBAtp7QO2zpX-bJ8SrQ@mail.gmail.com>
References: <CAH2r5mtK7gFUwQfmsBpg2LKPLxkvewsYBAtp7QO2zpX-bJ8SrQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtK7gFUwQfmsBpg2LKPLxkvewsYBAtp7QO2zpX-bJ8SrQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/v6.12-rc1-ksmbd-fixes
X-PR-Tracked-Commit-Id: 9c383396362a4d1db99ed5240f4708d443361ef3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9c02404b52f56b2c8acc8c0ac16d525b1226dfe5
Message-Id: <172797440669.1922078.9682522265652578794.pr-tracker-bot@kernel.org>
Date: Thu, 03 Oct 2024 16:53:26 +0000
To: Steve French <smfrench@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 3 Oct 2024 11:29:01 -0500:

> git://git.samba.org/ksmbd.git tags/v6.12-rc1-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9c02404b52f56b2c8acc8c0ac16d525b1226dfe5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
