Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF5534D3BE;
	Mon, 18 May 2026 19:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779132066; cv=none; b=UL9iaa3HqVe0wnicpXAwk8qz7a/NbPnaKpQ5Ea2BEjrBGY2ToLNrEnN1rvpcUfSEoZQaCJnQ2hlz5s6X9wWrKMobazkEwLyMcXLJ8pHLq3MEPrhUnMKaDI3blt1n0icduOqDPZSMYXmHUxFqpZQxcs4tY2Crr6nXjtWgW/EsRec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779132066; c=relaxed/simple;
	bh=+8VzoI/1waG3i9gQBtycULagImKLr8Iiw2iCsWw3wVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWS4I5exXHvOxrN5JUHWNgFxur/lntAWF1dI0edVw2Q79Pe5SsP6rA9jBmEwSE7u67b9Zk+UT7Cli7arrgF1dWosTlsIAMO+fNXCWFGGUS08Wg2wFHNHKU08RXiqgQIoL1lRx+S8kRmspOqEVmY9/WkwaF6OftYV5jC1hjkHmM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iRTv2AfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iRTv2AfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1B9C2BCC9;
	Mon, 18 May 2026 19:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779132066;
	bh=+8VzoI/1waG3i9gQBtycULagImKLr8Iiw2iCsWw3wVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRTv2AfUSST1Wb+EEdgKHaE1C1KyDjaHWCYXMUwKEgjoOPnWbupYDmyGwDQjjp7Ez
	 KnjNU6KbpHbUO/hoVfSe3A4imJj+78K/xhMRnYuPXluGspC6O1hDF4Kdy4qayKTMO3
	 6/uiK0qq2Zxq9piYIO0cVGl7VFggtQd/3mUxRTdVFvKixwzS8xX0zVbGiqPuKC7IZK
	 zK865PD2SyYWSEKvR7INaeiiLO+gDD2FmilNxg4TG4A/stZdIQGTLNYloz4J1ObyM4
	 sJTybcnJZGopm8kYjBlkAlyT3uD910KKWhzmPPGleP9/0QBZjysZ9lTjn9wtAJ57hn
	 9O1i1wTBlTPwg==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Liang Jie <liangjie@lixiang.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: Re: [PATCH 6.12.y 1/2] smb: client: correctly handle ErrorContextData as a flexible array
Date: Mon, 18 May 2026 15:20:52 -0400
Message-ID: <20260518155236.reply-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_D303270C66A4818296B926E3A34112CDDA05@qq.com>
References: <tencent_D303270C66A4818296B926E3A34112CDDA05@qq.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, May 17, 2026, Alva Lan wrote:
> From: Liang Jie <liangjie@lixiang.com>
>
> [ Upstream commit 215b7f9ecb8d7c14d56febdcdd246f3579c32aba ]

Queued for 6.12, thanks.

--
Thanks,
Sasha
