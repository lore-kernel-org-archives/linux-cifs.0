Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E21537418D
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 04:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772079199; cv=none; b=fjn/dXUa1KjVZIvNh+MMOjazBQzvewZ437lq9Y8IGkHwXVpJ+i3Ww1fd6A06HERSfuNhXL61jpw+46UlP0OUlULGyB74VGQfDjrgH3jqMoqXZkcqbFcIUTyZ3DroD3RMC8d18a8r6hR13srYBy/xNyEDDzO1cwu73K8y9B9OSII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772079199; c=relaxed/simple;
	bh=1abH9GhnnASck1FJhC6wez6/T+6ZDWbQC94Ahpu/Cz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fr7euHuFWgIkvV4zD1tg3PU0/SDMrFWfs2pu38DTSfjrPoeSz8VM7GgUg9TXuYGbWyst9ZfcjF/Noexk6QsovOxoMkUuKEM0RBp5Ad/+JFExoYeB4ggY2eaDjQF2e0ZhHDhrFIG7i6MvuKg7Pr1uVTeW+wS6iwWD7+aOYaSGdcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=AoefAnRa; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="AoefAnRa"
Message-ID: <d3d93c04-fdd1-4b96-90f2-293a2d45f647@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1772079192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=puEqlOuyrpMKqYWdE5m03lOX3vqZGeN6IY3gAcntvFw=;
	b=AoefAnRaGaKZbHDP5jYMUr7J7nBnoLUPZ9gjssUAnWeeD+wH+pr4+/LUomo3ev2IYGKR4I
	aEtwGyYviPyiD7qL7p4rLqLinTg1xNXtahDACkufLBzTdLw7YjpFyCOitM6cWKcShMGZCa
	viUJXn1nOQDlgPSwxTY1ZSYm4PF3IRl6xQNW1aEBo857AjaFLjS+ilxh0Z4i+KlE9K7n8/
	MpcyHBh+IXMP2eU0Cb5+B7AUPY+hQw6TlJEeMR29vr1xfl05eavWj2BTYjyJ3hEyEeaf+M
	C0HNolsF1e+cXUBNbCp5fEp245lXKxCm/huD8SJ3RkqgkkHeM0juPnuN5+MF2w==
Date: Thu, 26 Feb 2026 12:12:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] smb/server: fix refcount leak in smb2_open()
To: Guenter Roeck <linux@roeck-us.net>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
 <97979f06-7dd2-46bd-9bdd-3a9c45fc5b1d@roeck-us.net>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <97979f06-7dd2-46bd-9bdd-3a9c45fc5b1d@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Guenter,

Thank you for taking the time to look into this issue.

I reviewed the relevant code in more detail and did not find any leak.

Both `ksmbd_put_durable_fd()` and `ksmbd_fd_put()` will eventually call 
`__ksmbd_remove_fd()` (remove fd from file table).

If my understanding is incorrect, please let me know.

Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>

在 2026/2/26 00:49, Guenter Roeck 写道:
> Running an experimental AI agent on this patch produced the following
> feedback:
> 
> This isn't a bug introduced by your patch, but it looks like there is still a
> resource leak here. If ksmbd_override_fsids() fails, we jump to err_out2.
> At that point, fp is NULL because it hasn't been assigned dh_info.fp yet,
> so ksmbd_fd_put(work, fp) will not be called. However, dh_info.fp was
> already inserted into the session file table by ksmbd_reopen_durable_fd(),
> so it will leak in the session file table until the session is closed.
> Should fp = dh_info.fp; be moved before the ksmbd_override_fsids() check?
> 
> PTAL and let me know if it has a point or if it is missing something.

