Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD96E46A5F0
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 18:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785869606; cv=none; b=bsCE1RpXZ4cE9CqFaNtePUGhJJleTQno5FemAF5ldIL4iT/XYOHArF0335+rGzZrK3OTDLErDIIUzmdloxZ3SfPs5+5WEIIV8QDO9diTtbwwpKaU4yq0ylGK1vMHSfQHOGVY+dZZ+uXoqrtsy5GUqgfB8Di9GTtmNf2MIyuj8k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785869606; c=relaxed/simple;
	bh=fc2sN22rZbmQ1I+1i2EVpq/5u1W09w71cYLSXu0GROI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X1Qq0G6oFQ4l/v/Q8tbLU32tvfD3uL422G10jMvcR8aMz51O8jDRauMLj/KyF4YFdlqQMHzPadoNKV/kblt3LfRlJXPPze5ykw7hNz3x4hvpHsUIkvPHBV3CyhgGP7HfYHYULB5GHuxyf6sqQ95GCBJnaw+xdgPxtZXJL76/ef4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=plGX+9R7; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="plGX+9R7"
Message-ID: <36cdfc79-e586-48d1-a821-a1c86760cf19@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785869599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HB61pefKeSTuzvhwQNx5BIChBB6QNl917QDh1UhL+ko=;
	b=plGX+9R7RlPK+lBGwA2bfS+H9tAFyvpPaPtIPJdi77k9Y1rJtKGpyd2ogsCJ4CywpMFzWp
	mA6DH/P8SVIfhf/nyn7sS91p43nuX2dmG54KSVg2wLlWi+m8JdcvvPK9uuxcMPU9Wymx8e
	cF6Pv9vbCtxmRHvu9ItdL8bMaIL4hE07ZqlcYMVVemWJIRfAimT3RSH7v+10s30FT+Kiys
	stOCCzq1AglJg6Oz3hQSLa5j+w7TbTHw+xZAZdIzKCr0We/D90UqHZTxRcqZofQlDBB7gU
	B/47m+AvPwm9bAwPA6NQ9ehlSHvwnQG0Wm7fKOwLttCs117iCzAlmTvR+SdwJA==
Date: Wed, 5 Aug 2026 02:53:13 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/3] smb/client: fix nlink of an overwritten open file
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 slow@samba.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com>
 <20260804123301.285434-4-chenxiaosong@chenxiaosong.com>
 <CAH2r5mu0rQKQDHgcF7jTBUk6zHitWinP5pzNUQ6+MxqP7j6w=g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAH2r5mu0rQKQDHgcF7jTBUk6zHitWinP5pzNUQ6+MxqP7j6w=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Samba has a bug, please check the email: 
https://lore.kernel.org/linux-cifs/0f6a5c9c-2c65-480e-aa44-facdf11fecc0@samba.org/

在 2026/8/5 1:08, Steve French 写道:
> generic/035 passes to Samba with posix mount option without the patch.
> Any idea why this patch was needed for ksmbd but not for Samba

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

