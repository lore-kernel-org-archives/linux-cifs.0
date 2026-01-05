Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58D8311C24
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 08:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767600630; cv=none; b=J12xbQwrgJb2oX0k5MgF53qBXjmXNwQfRAfwTAqr087GQYNcGg3twkMPb6XHlwZsA/q1ocXvdtodk4D+Tc8YmhHn44W90byeqegISYLJpiXVBjrhSOi/td9nYTu32Lh0dsO/5ng9Dd4eQnDeUTt7Gfs7pEzvfWTjZJFbg3OpFig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767600630; c=relaxed/simple;
	bh=XGrRSOt6IbGuxlgP0JEyMHUWWoxArsv+E152JAwhgpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jh8g3FnC7e1t7IGBJwOh9t6MN87onlO2XHuNLvGUD4GJvDjD4nqu2loqJ2BgIsSwGRIgpq2PBNWM/yB+/2ffXBQnEKD2s2gJ/612APZuhPGIj5zLbdh2UysyG5srylzExxTCYfdxcp04r/yXmbYfJ37RRdpOW0D5Adi9//mm6ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ly3NfTw8; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ly3NfTw8"
Message-ID: <62ee6b1f-480a-4ea4-9d9d-45eca31d53bf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767600624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6+Sg63SBycASrCeChsSrOxSeJws6BQFSLs4aDd1Ivzs=;
	b=Ly3NfTw8HdMl3Y4qtsu/A6ZyrQVV99lMLlMX7nI0J/ytQn7hMrcOPQiXKCxwMiNjCkTm6t
	VqurIuhxhsUZu91SHkPx3iS0nxvf3g3FNhUNrKEb8BM4NpJFhFWrOU8pHhzjCK2jcAR1F7
	XxvGHZl02U45AhrvNwRHxuROM7dSRy0=
Date: Mon, 5 Jan 2026 16:09:37 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v7 5/5] smb/client: introduce KUnit test to check search
 result of smb2_error_map_table
To: David Howells <dhowells@redhat.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251231130918.1168557-6-chenxiaosong.chenxiaosong@linux.dev>
 <20251231130918.1168557-1-chenxiaosong.chenxiaosong@linux.dev>
 <1697003.1767600292@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <1697003.1767600292@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Good point. I will use `const struct status_to_posix_error *` in the 
next revision.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 1/5/26 16:04, David Howells wrote:
> Did you want to copy the entry rather than pointing at it?  And if you did
> want to point at it, use a const pointer?  (It's just a test, so copying it is
> fine).

