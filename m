Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9C04071DB
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 13:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780753612; cv=none; b=Ce/+W3IUAXHSgG7sIGw82rXOo5oXhRGe5WIPEPjh+SBn1qi/POzRaIMybBEz7j5m+oSWWbRLPfwRVRjxzIxDoLebEPOiHfRSbtYY3Ck39bKpnrCrySuHyMctlXAf/ZMRXdih2pfG8lxHMybMrsecN2jytQFsnT48Qr0AmH0MtqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780753612; c=relaxed/simple;
	bh=CQHJ2Oa28xMUFD/YQpWCt3Jh2POhOsfxBHaxllYf9EY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=McQsLAWgWEthTlqSJuNNo2aptE6SgI0l2wGS1RQgRSINBzf7X/e7Z9JmearZYc0Jj+DsoA1UODAqti/fP7G9HJwNvQASY/kXcWfMpZzVs1QyeGMI6c3ENqn198cb7dTTeXkHCZl8+7VZjSVew/0jtb21AQyMCptBfKzNK5NT7i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=OGuH2a+C; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="OGuH2a+C"
Message-ID: <ba73ae3b-6c2d-4a11-827e-e110466ad961@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780753606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nrl4uQxJMlfm6O89aN6rQakiFfJXxJfPq0yjesEQeCU=;
	b=OGuH2a+Ci4AlZPUvuglNYNl8z1cchn2fmJTD1n0KrilBFdLM05Jl251LCb6CV7Ls+oGM44
	rj8BZEy0SDegwfJNgWvaQX8UXTbTK33wfSSKE4TMfzW41CtMj88BrTf84ZMXfTwmUTNuAL
	Ws4hxajPcAvoCbDZOe6J40khgUQ5zl6QE9bckj+XtGVOfJgLg/pz3BnBRYSy0RMWuE2Zmq
	NYSzXYDBuLm+f1RwB1cBrx/VjMRN6LeU77yOw/g+LgrXskufX8rH/Ez2Ef/i3V4UJAkiYl
	euOYv6wVIDjhe4ISan+/LhjNppx/MfU4YWKFnYZSX8jUZcJgC63c48QgHAVXuw==
Date: Sat, 6 Jun 2026 21:46:05 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] smb/server: get compression file attribute on open
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-3-chenxiaosong@chenxiaosong.com>
 <CAKYAXd87ALe7fy-ZL9o-c1BkXMNVYDEMz7jigwgfcm9373BkEg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd87ALe7fy-ZL9o-c1BkXMNVYDEMz7jigwgfcm9373BkEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Yes, I will remove it in next version.

在 2026/6/6 21:34, Namjae Jeon 写道:
>> +       if (rc == -ENOIOCTLCMD) {
>> +               *fattr &= ~FILE_ATTRIBUTE_COMPRESSED_LE;
>> +               return;
> Please remove unneeded return here.

