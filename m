Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E122493632
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 02:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787536884; cv=none; b=ibYrP9hJsoWdayHVBC+YwqXvgqqc7yBeWi/vQi3q6IdinnFpYQM/skLlRpxxHB3I5w7QRotwcwph4ujRc073ZVPusyVBWwIRjZC8cZSP0FUA8+5v1AeV/IctdqdINoSLk6Tf7fXIjQJKwbdE3KPo+k0MBXotC+tr/oLc1urPwUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787536884; c=relaxed/simple;
	bh=2C8QV8nevZ1gyjJdrzwMpwJLYwNmGYTJTyLsIsI/wb4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jOMXwfAQAiXBLJUxEyIzj/U6Lei3ynqUorXCbfL+GIgZrQQuHDPXLrxg+eBDjRq2aKBOtJNp2J00wrnd7Hks0tIn+XYojO/pt9KbnMEUGiUNNMyvxn5k4TN6MNdgQ+wzG6MZgCHhvqS+9R1KbUUCqx5u+Kt7pgnPXVWLKvgnblI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUEHc5C7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUEHc5C7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AC71F00A3E
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 02:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787536882;
	bh=pvS+ARwm7NRbrd5DqnJxkaEmLbyraZL7bBVrQWfwytY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BUEHc5C7Vm/aasiavxQcXqzcPkJltrpOfOYexjFH1AdRpd/AOhgnfTt2JKM6/nkCM
	 LNelcPnwVmt44Mme6Sfo6ROl3ZuBkTlsz15FMrGS9RNBMQzec4MA+XT9oVniE4qaVk
	 Je6A8eSlSTpke4Jb3dZEPkGcN3QNLJUdGtv32sdZn9VrvHi72/Aqk73+NTQSuWhiSz
	 apeQ0dIZ/gYkzqtbVywlr4Ml8YFnzRsZ+v20hU7qYe2v4FRYevKG43IxhYF+swU7hY
	 PMzzBtUg4gqD+TmaQBzfEudD9Y2tQ3tm2HVP8w8Inl8XSy3M+WZwW63rHLTNusnEx1
	 YUmM+9fIi/YkA==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a17211b9ecso7555487a12.2
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 19:01:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpQbHpzsM0v8TEOYvcms1J32eKiT0JgZuhgUkkmK8jdUxAUB0j306fsJdunjdFwei9XpKL3o7VOoX1o@vger.kernel.org
X-Gm-Message-State: AFuF++lJ8mNSiJZig4gsqqzGsACHzBTlF7PASm8MEiCkNsskrpbFohlN
	dOMzgJqJpmOMWFPWyDuYCkyU+ES4BIoK2CUzeX4h79JhIBte5zDBPasd4X6utigECBFHl7qu6SE
	kx1dsOj/qdBEjejbqE7bFAbO53d0h0lI=
X-Received: by 2002:a05:6402:428f:b0:6a1:f95b:8d03 with SMTP id
 4fb4d7f45d1cf-6a42f2768admr27449861a12.14.1787536881531; Sun, 23 Aug 2026
 19:01:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260823151053.935889-1-huiwen.he@linux.dev>
In-Reply-To: <20260823151053.935889-1-huiwen.he@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 24 Aug 2026 11:01:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-2jFdo2G9S_5rV3cZ0Lr84SvNyuOvm36uvXsFgorNokQ@mail.gmail.com>
X-Gm-Features: AcwNN1Vr7UD-b__vN_oHRaWP6tKi5TwAiCw1ATsA0-AIvilGq6Hc6P4vx970I30
Message-ID: <CAKYAXd-2jFdo2G9S_5rV3cZ0Lr84SvNyuOvm36uvXsFgorNokQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] smb/client: fix fallocate range operation issues
To: Huiwen He <huiwen.he@linux.dev>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org, 
	dhowells@redhat.com, chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 12:11=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wr=
ote:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> This series fixes several issues in SMB3 fallocate range operations,
> including insert range, collapse range, zero range, and punch hole.
>
> Changes in v3:
>
> - Update patch 6 to use page-aligned truncate_pagecache_range() instead
>   of invalidate_inode_pages2_range(), avoiding possible -EBUSY failures.
> - Add patch 7 to invalidate FS-Cache for zero range, punch hole, insert
>   range, and collapse range.
>
> Link to v2:
> https://lore.kernel.org/linux-cifs/20260820071526.826926-1-huiwen.he@linu=
x.dev
>
> Thanks,
> Huiwen
>
> Huiwen He (7):
>   smb/client: validate new EOF for insert range
>   smb/client: validate new EOF for zero range
>   smb/client: mark file sparse before emulating insert range
>   smb/client: fix data corruption in emulated insert range
>   smb/client: fix integer truncation in collapse range
>   smb/client: fix stale page cache in insert/collapse range
>   smb/client: invalidate fscache for fallocate range operations
For all patches in this patch-set,
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
