Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7E530C15F;
	Mon, 18 May 2026 19:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132077; cv=none; b=OIfQkM4BTjBhpLV0DBX0DQCD+x0xA+8rZCXczeM8kK5q27+9bw6VdvN0BkWqhl5cyhmUZN0foIBFuMM2pNh37rl+8Df6G51nzIhKoJX3I1p5JWbSPRIQnY21RiPMyWD8KE7nPSNqRUmZ4JyCdNciwMVglhRoMWh3pkSAu7woW+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132077; c=relaxed/simple;
	bh=i3oY8PG4KwQGHN5L10dwyj0933i5Hb/FM18LjFX52oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUwcAR+7w7Xa0oF0rAE1KP1O/1IrfKJzCaV2aDFrz9RMzNzKYGx2mcRI/Rg0O7bgg9KJUmWXTa322QX1tG/R/J2EVq6Q2ouzRTkdBA413KkAzU5ROFyQSTI97tKBAUl8Oi55CdFh3af3K0W6bIA3FIzXDFQUbwC7RiPhrpvzjwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6JB55L4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6JB55L4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D3AC2BCC6;
	Mon, 18 May 2026 19:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779132073;
	bh=i3oY8PG4KwQGHN5L10dwyj0933i5Hb/FM18LjFX52oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6JB55L4lb1c8HyqobqdegPFsiAPmMOJphfPY59LRUnhHgg5rDg0AS7xmXTPgfC/b
	 VLc/9ydg3HfwtpDJmSwlB/S/wLLKPDYFIfBiw9HK3WOtf2837a/vUG6zOfZ4CV47eO
	 aizAaabVl5VECvTGA0d+Nwjm5pKIjs+bxtVQiPNrjyipuzrCBVQCjRrFTPjUNZaLOz
	 z6iWGwp/4i2uxRuXj3h4WW6LATVPRlfSyc/FvXFvYmagsQMAUiW8ysM4YPK0c2d/7z
	 enDUz5gEwj49KQ8/AZ/D2fBaM1zs02slmUvqD4cb4JQtcIdbJ2LM7+bB78FrZKKY49
	 kYXVjf9BeihfQ==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	stable <stable@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: Re: [PATCH 6.1.y 2/2] smb: client: fix OOB reads parsing symlink error response
Date: Mon, 18 May 2026 15:20:57 -0400
Message-ID: <20260518155236.reply-0008@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_B0DF3A0F070846B6219D96AE66E1C34FB205@qq.com>
References: <tencent_B0DF3A0F070846B6219D96AE66E1C34FB205@qq.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, May 17, 2026, Alva Lan wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> [ Upstream commit 3df690bba28edec865cf7190be10708ad0ddd67e ]

Queued for 6.1 along with the 1/2 prerequisite (215b7f9ecb8d), thanks.

--
Thanks,
Sasha
