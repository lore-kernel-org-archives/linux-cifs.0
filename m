Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BAA3C1088
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 02:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896775; cv=none; b=Ovas7P/xheiAjfzTiS7KrH8xDNu1OQtOtoWG8VcCoz1a2HINxzGow7rdjDUe1h52OBMrLVqtGF40D2VQo+yOBvbXrszrtM9Nv1Ixa7G+3ZQHdcihmqBJpQyFoEUP3QS+Fn2Cf4DB8JXBxnmZD2vIbeUB11wr1Zj1Z6ySFsaM6a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896775; c=relaxed/simple;
	bh=v1Cynh3kijK4BXb0NXeTv8l5winuPK9zGNMXaHqx104=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rlua89nSfplVgCiEK2hKeIuaoPbFoeI7JUX8gGvh0VFdUSJ2KLhGZSiJxyWJ9mkz21dcegc6FPOIcATSVGSzIs33Ls3poFz1FckTsXoBe4WeAbtGedpZcYZOlmJmD3Vm1oJf/GIbCfsTMm0V1wlDpIYnnCtXuzQ1IJHKqQniH8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=GGOqRFWD; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="GGOqRFWD"
Message-ID: <0d0743a2-76f0-4931-a346-6a7ac9a8284c@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785896767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mYC3PFm8NJ2tBHLS4aG6oitodTPegmYmurXZr8BE6lU=;
	b=GGOqRFWDt+ImU+151UuGqgGw4DDzwv5uG6BJUJp6lU7bXAN6vkhKGc7ewa5zmoiIL93aoD
	ozxuOimU7ZDpomAT3tQjnxrEGw0U1OZPGv6iCXwiA4p3Yk7DfMGEAlEpy40rbxKx4ackWD
	7MYQK2XZKJtJcUzyAMOAYi5SPhqjznY0cjBUl++arZBOFeDyi9lTyqkLixd32x73aQ+MT5
	RzXxU1fZ6cW9QZnkjEoqSyoPVGe5MuuxjdvC+HlouQzQaKn6t2+pYWPZRlX0FD5k6KzO9M
	JnqouXMz6e2IjPmgKgC015KZ+UjCZfyRtVKXl5I54MTC8pU6ENVN9hByXoPTNg==
Date: Wed, 5 Aug 2026 10:25:03 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/3] smb/server: deny overwriting targets with
 non-POSIX opens
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 slow@samba.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com>
 <20260804123301.285434-3-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-A2hup+WnYZj+AaVTzgZ9hHQgg8zKswtw=-VqStE6VFw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-A2hup+WnYZj+AaVTzgZ9hHQgg8zKswtw=-VqStE6VFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Got it, I will add it to my todo list, and submit a separate patch to 
fix this pre-existing issue.

On 8/5/26 10:17, Namjae Jeon wrote:
> This appears to be an existing limitation rather than a regression
> introduced by this patch

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

