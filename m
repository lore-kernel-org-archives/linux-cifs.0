Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFE034D3BE;
	Mon, 18 May 2026 19:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132072; cv=none; b=X94YOrpHncZE+KyIwvjMwtZF4BrQS0MLhFJLRIsm5laHXP+0x94mL+rHhtjRpW1nvyPyaWoDREXfLgo8NJjhlxQQKPlxJ2ovdZ4eKiKmRF22TYQwuAi4vsbJ+Q9Z5bvs+xU5xCOv/FnX9YKFPrmSpbChF+MAeXrJD+ifG6hYuBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132072; c=relaxed/simple;
	bh=V9wpXf9lGdy4NRGyEFku7+n1mr3+d383rsdgPcXQe50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4xHLVfcZvkiP6maC1GMreawzvwhaqsYSf/C9Yd7ju4LnTDdDCCUW5a4F3G8AYXQp7LvsSTgAx0dVlhH80qxpFAyrLMZwUQuCmutYEYG4mAILaWxAm9om2Xq6yjmG9knUHiSzjeUy7fbBhkCSFT/wjeWPXkYLxx4bfhxYVYKf6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sqDRwOAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sqDRwOAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEFCC2BCF6;
	Mon, 18 May 2026 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779132071;
	bh=V9wpXf9lGdy4NRGyEFku7+n1mr3+d383rsdgPcXQe50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqDRwOAUIT/JapCcsGI0WlCLTdeYaroD38bF9oWnhcNt2U0OzVHdmgHCJzfhW7nFO
	 eF6l0GyoPvhEuEaQyyksHiIyf4E9AIs/5AoESFY04WbRIkVbhGnHeZTT61z+U6M8iz
	 Rvvfh9PNeGP09fse2ppLtUlTboNPqfde+QVrJspMWBWWuRy37pJJb4dtjqb6beF+Uu
	 WDyXRFapwcQkmMAkmYjPBBOkKovrO7kw/LobyjARUWkwNDYKkj/0l4eDgO8KdwiCRZ
	 TbH160sU04lJL4BNEi8dR1fe1yJbDBnXZTeQO4D2Sv54d8aevX1H/N1y0mhwFmeFp5
	 s4uKBiY6lEfKg==
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
Subject: Re: [PATCH 6.6.y 2/2] smb: client: fix OOB reads parsing symlink error response
Date: Mon, 18 May 2026 15:20:56 -0400
Message-ID: <20260518155236.reply-0007@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_7A69076B1A3E822455AD85719260081AEE09@qq.com>
References: <tencent_7A69076B1A3E822455AD85719260081AEE09@qq.com>
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

Queued for 6.6 along with the 1/2 prerequisite (215b7f9ecb8d), thanks.

--
Thanks,
Sasha
