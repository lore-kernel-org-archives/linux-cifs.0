Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794072507;
	b=LA7iHNd2VRVSkL3JL8MGp1VcKleDF/AfZbxpC6IDju2XL39LjaUcfC7rHyfEUd2A5oY3
	 o5Cor5g07Lhj1sLoawB0GNG7UVp5+Rrkz2fa/uWnU18y7W/DK+Zvn/utYXRUDlrWJSWDz
	 RhHDSwpyl6GmUAT6gut1dH/avc9912yR/qN82zo/Z/xPkacde/oBDLkTguRPi8cvnTNhz
	 aVpQzCuDONwd97xCpbBKFYyMXbBe9+t6ZfxlwMv0epxy/DVIUEJuJKNSAbgsWxK3C/kGe
	 9lr9i78FC9kPppmy5KQgxUUnWuj67RmFmuQsdYfWTJ3ij0K3WWQ4AjsofcKcni/QxHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794072507;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=B8SpMPqfiIbW20oj+XFAQKIXp79lb7bE5abKySGf/k0=;
	b=nso/1hRhM7Wg3We7wbLRfCcF9NwHJwJjGnKHwwR2a1Mmo/FqJcy6i/xMHNdoWAHSgZpx
	 aBo4qOl9GdGATCU2s4FuAIDk+41qbwWoD9Wy6Diy9ZchkYulgHIEJvxX9AYB8AXGZBiud
	 UzCSN2EgI5KamOA1RN1rI141QryGNAccT/fsZhMCCrY94zBRqwijvlyP0aSfiATTwB05d
	 k9cJPr1/2/NlxZsqoBtmjoPn6yw254YjlekFNujeOJksRkvssE4hg5mQx5sYgPdJgVeiV
	 8HXjD+7/hR2AhnoqgRGiyiXnHv7AgdIYnB58GD8G3Bcs3nave2NyAyib2IFtNVRX3Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=hnJMgZSt;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEB6606A326;
	Sat,  7 Nov 2026 17:28:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCEB6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=hnJMgZSt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=B8SpMPqfiIbW20oj+XFAQKIXp79lb7bE5abKySGf/k0=; b=hnJMgZSteGFoUsiLh0NiilnATh
	vkeKP3Y6I4jYxyvL7a/8tZEMZN8bjHMhx0tlnRqbsq3c8TBeVtrQm96H6uQRVz9pOV25VQnfttHrJ
	kr+WuPpzNIAwZISOAacl9Q07uw/Rp8K6auDjg/E3VMtaxVpTu9yZVFykX4toI2IxW5803qB7iWcMZ
	TvEUx6peZ6KWoRa/zx8iI2+2thVBBNddYG7o/JfbVqKcPU8RB2fJ4j+nEoFuLIJ3GFbnf+CXFDJ6S
	e/w8phwi9tlAUuYzjkV07Lv/KxpjXadl3Knu4pzZCVPeANTxXZm+CGAv39F8QOmy+yx5yJ3pQ8uKt
	c/BjoKWQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPkDF-000000017qr-3o1e;
	Sat, 07 Nov 2026 14:28:23 -0300
Message-ID: <7e2543c16b6b75edb8c55b138175dcd8@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: hold server ref while queueing
 reconnect work
In-Reply-To: <20261103091558.2342761-1-joseph.qi@linux.alibaba.com>
References: <20261103091558.2342761-1-joseph.qi@linux.alibaba.com>
Date: Sat, 07 Nov 2026 14:28:22 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Joseph Qi <joseph.qi@linux.alibaba.com> writes:

> When query_server_interfaces() returns -EOPNOTSUPP on a secondary
> channel, smb2_reconnect() calls smb3_update_ses_channels() which for a
> channel runs cifs_chan_skip_or_disable().  That clears the channel's
> slot in the session and calls cifs_put_tcp_session(), which can drop
> the last reference of the channel and tear it down.
>
> smb2_reconnect() then falls through to skip_add_channels and queues
> reconnect work on that server, using a server that may already be
> freed.  The send path obtained the channel from cifs_pick_channel(),
> which does not take a reference, so the session's channel reference is
> the only one.
>
> Take our own reference on the channel before calling
> smb3_update_ses_channels() and drop it after the reconnect work has
> been queued, so the channel cannot be freed while it is still used.
>
> Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Please check sashiko comments

        https://sashiko.dev/#/patchset/20261103091558.2342761-1-joseph.qi%40linux.alibaba.com
