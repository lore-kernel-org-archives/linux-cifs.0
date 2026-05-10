Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECFD365A0B;
	Sun, 10 May 2026 11:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778411125; cv=none; b=a4mUrZ9mB+LwUtEoX4v8wb8JXvtvuziJKtgMwzPkzqk7ZyuxYlZdnRZ6vyPAlUhhqPoD+m1fb7KMY55GRAgKj30S6Fxx2N7Iutx89UIz6Dn53u81h8KM6nY50eZF+ygo00pTTEpfsT+LjUIp0wp5GXYH1n7ye/txPfP5X2A8r1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778411125; c=relaxed/simple;
	bh=7a2iV1/sBxU9K04sH1JBSHWzaxM6qao+99Uz3Ft6FNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E3aT8/YXTNeGUsVIT68wcRRqSY2weARiFbeG6Gxad+Vwq55mIVx28d8lxEJPYP6Q8jf8cXkXUktnX/2ea88WKp4ricMzzJOnJ1U4vDOLulICGEqfEffyGPP75LHvQMwU9usq4lHBLUjaf5yXUzS1cG7IL9kBxCDMRmE9eW7Ypqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yqYsQJZr; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yqYsQJZr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=tiLiDH5Rk2B2hLGZ0F0I+C/JK7yurZrcWAQHdfdnzaE=; b=yqYsQJZrIYcrsMt+2twsoS37j9
	DiEB2njuLyYSwvSvMBKbKvMGtXMvgGRsPRbm738mQDiT7EVtPFIQuSDvY1SJyLS3ra7AnkM7RdFxx
	KW6LlaVEehgRRHHmncB256i781DWg6/VhYqWwHd2bI/rnxEUfQ8q46x80yfRjWI4B8Dbtgy8ZoL+x
	gq99Ia172mmD+ddOOyDOZc/VMH+U86rfx4Gl3XFuJGBQ2h+y9eOimGXVIgCApea4IJzgI2fDRsXz9
	E8HKf942IqVh9+IEJqc3PUGWPTa7EsuTf3uG1bVjYRpnThIHkI0XmmbatXG2YPtbQNxBFqnrEHCFK
	AJNVgMrLJKpzf9ZK7Ox57/NMbmf6R+WhSMWFg/ZW8EfpNQxGA1ysOyYCGFwvX/6kRRAMzc/2lbBYP
	I7ehCBj7DLvc7nLumRiS6AlBkwmJide5sr8veHYtJtHlx8zmRWujW1eltuIj7mxX5GPxUqTF5MmUj
	n7gfD2aDMqocrJeivlrXfxEM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wM1yD-00000007jN8-0OSW;
	Sun, 10 May 2026 11:05:13 +0000
Message-ID: <e1ed4bb2-80b9-4e81-aa4a-502fc89077f0@samba.org>
Date: Sun, 10 May 2026 13:05:12 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for stable] smb: client/smbdirect: fix MR registration for
 coalesced SG lists
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Yi Kuo <yi@yikuo.dev>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <stfrench@microsoft.com>
References: <20260508081546.4177429-2-metze@samba.org>
 <20260509122858.2097e82fa847.re-smbdirect-mr-coalesced-sg@kernel.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260509122858.2097e82fa847.re-smbdirect-mr-coalesced-sg@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 09.05.26 um 14:47 schrieb Sasha Levin:
>> [PATCH for stable] smb: client/smbdirect: fix MR registration for coalesced SG lists
> 
> Queued for 7.0.y and 6.18.y, thanks.
> 
> The Fixes commit c7398583340a is also present on 6.12/6.6/6.1, but the
> patch you sent uses the post-rename mr->sgt/.../mr-> field names that
> match 7.0/6.18; on 6.12/6.6 the same code uses smbdirect_mr->... and
> 6.1 has yet another older variant. Could you send adapted backports
> for 6.12.y, 6.6.y and 6.1.y (or let me know if you'd like me to skip
> those branches)?

https://bugzilla.kernel.org/show_bug.cgi?id=221408 talks
about 6.17, so I guess we can skip older branches.

Thanks!
metze

