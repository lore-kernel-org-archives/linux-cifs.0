Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFD9478E53
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127861; cv=none; b=XawFJnO7dd6sTO5FoUr66LSawV29NzRujz6TMKMqg0Pp1z61ah8jK80rBKY4lud/tzggcDOivabmuX23LVYxe9tSO8maxfSUT4yJkuW21pSY8r/fLMlJ24PjWDW5bb/N9a1Z/k6+jKq9rLK+xq19UPjaUl2+YvoSk1QhH9DY1Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127861; c=relaxed/simple;
	bh=ZfZMEnNXhLwGuzbK+eLafIuBnryIekAym5P4E7pxOUo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tXnUwp0YsT0qXl1GEm3i2c+5xIUxFMzzVdFrykrf87x9k8Ej4BmD+tOQjWsjQTvo3eGDL58JrYwGGqw3RoOWIAzW0bboiyCMH5w6lHotrdRUc8MTdIWGAv7IVCa2oQ3MH99O7JrFNpBqRxlDd8UwFYWSrf9jBPnia4YVqa45DB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=WyYdXEGW; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="WyYdXEGW"
Message-ID: <665142dc-bf1d-44da-99c2-08cf0209b39b@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784127849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=50Ddf+rFuhMrsJiKOLDZHyIfLvRD2QdBOD0XezMcPlk=;
	b=WyYdXEGWMNF3R82drT715ucUc9BVy7E0BYWv6KgCMUTwipMe+Tq67B92t0E2i9yeKpTM2f
	x2cllGY+5LD4cdJUKEOMfuE8mVUbzltobVNGU2vrBZE/124WuV+tNCiUdAHOlZc4CYjfia
	qhMDbT5q0EHUefY5I02GCfMR3guAXvpjTDJS8jl0bBui+oSyO5Lrs8ujosufYwOVzRJqZP
	ISWAJrqinR+knGBGtIZiB891bUv79SyhmO1mE5iT/DRRMx6k2OXo0pcrMyiyM6EVXzWsMg
	Z2qlF49zwjt1LjXZYKdx5KQ2+/3QKioEWXuhq4FinM5Cu3AY0xmutRk3aY/T2g==
Date: Wed, 15 Jul 2026 23:04:19 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] smb/server: fix signing when a response uses more
 than one iov
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 metze@samba.org, linux-cifs@vger.kernel.org
References: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
 <20260715135513.667260-2-chenxiaosong@chenxiaosong.com>
 <aleYRhKFI_cdGkC2@ashevche-desk.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <aleYRhKFI_cdGkC2@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Got it, thanks.

Andy, could you update your patch "ksmbd: defer CHANGE_NOTIFY completion 
instead of STATUS_NOT_IMPLEMENTED" so that my remaining notify feature 
patches can be rebased on top of it?

https://github.com/chenxiaosonggithub/linux/commits/ksmbd-change-notify/

在 2026/7/15 22:25, Andy Shevchenko 写道:
> 	for (int i = 1; i <= work->iov_idx; i++) {
> 
> (or even unsigned int). This style is preferred as long as iterator is local
> to the loop.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

