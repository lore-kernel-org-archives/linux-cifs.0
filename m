Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D903559C8
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 09:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770023540; cv=none; b=R0RnLss31QsKsM7CqIm6NxK7uV0V889mdL56Jjpfxym+Og+JNhE+V6UyB5nqiAAHmgTie6SXXeLsa3deJFzVdIHPVw+H0cY9hxvotc4X+1Lh6Xe/1sUS2bCDYe39AXc06T49cBpnweW+jTPS7/27DXkQYVnvxJoDnW31kGFI9S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770023540; c=relaxed/simple;
	bh=8hLiSEjotUQJ2+yfqqIhniS9RkwO5eJSUa/IbROf/mI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eJECalsl8SdBXeinctMq4aWOja15MtVbeZf8UnB8USgpKU9EeZ0chqUnkGWWBw3g8mpgUOx+VVwWwThRE1mLCjt4YNKTUv7xChF/AR1iGe7KBaQF2qSWj4/FZnX4fYyXveiiSzNQN7XxyZ/pVdXpLgJJ9QjP5raH4c4QcuTd5Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v90m45p8; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v90m45p8"
Message-ID: <7662c0de-b654-46c4-b3ca-aab3e4139574@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770023536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YbPlFzeSB5+lX3KeriLs9V+sJhrJ26xdlymnSmqHwmk=;
	b=v90m45p8g1LDubl7oGzaq2cG0Ng5feRn3hRd26y2+mTLf/nchaH7D5Hyf3+RGvSZHFRvNQ
	t6ilUdasB8RHnFN6QNKw6ZktCR3ufPG4ss3oh6ZgNWNJTndQzjdKglKYNsiL8EU6oaL7ir
	tCrDuO+fcryKKB9335GB296Ci+PRH58=
Date: Mon, 2 Feb 2026 17:11:24 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] smb/client: fix memory leak in SendReceive()
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, nspmangalore@gmail.com,
 henrique.carvalho@suse.com, meetakshisetiyaoss@gmail.com,
 ematsumiya@suse.de, pali@kernel.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260202082407.1881618-1-chenxiaosong.chenxiaosong@linux.dev>
 <20260202082407.1881618-2-chenxiaosong.chenxiaosong@linux.dev>
 <CAH2r5mt3nUrW_qvWCCHkiBPCoXg0XdwV07_wS+7Ls3p7AQ81HA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5mt3nUrW_qvWCCHkiBPCoXg0XdwV07_wS+7Ls3p7AQ81HA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Should I send new version rebased on mainline? In that case, some of 
David's patches for the next merge window need further changes.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 2/2/26 4:50 PM, Steve French wrote:
> merged both into cifs-2.6.git for-next but this smb1 patch has
> dependencies on other patches for next merge window so might have been
> better to rebase on mainline so we could send sooner (although that
> would also require changing at least one other patch in for-next).

