Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D63F4248DC
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 07:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785827791; cv=none; b=RcNqj9fXolXlXsw2QaCwfymHwrBvyHKCtEdAaujIOy4JH11l4A6uQ1gtxUSzCTbNeKoW+60MCcCeFtSGRTeuP8EhYnhQ3ke2zyHDPlHs4JfdPY88hsnTMpbb/3SmVLU10zdsqqduW2WUvQB/iwBCWZmZB/0YT9uM2UHSg9dqEs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785827791; c=relaxed/simple;
	bh=5pHYNPlqb13fyoqyGP9d8LjyGk9oCSjLqicsdpxRqC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vBKmpz1DHGWfUscI3S2aNc183SfPcK6mNxJxvGcD/JrPzSSMG1rsBLA1uxbbxxitZ1DStGVED8ZPTnzzrVwddmH/DY1XCpjnsWfPU7s+l22HgkdI67u9Ulgjp3cGHQVaNMbNkxCoSw15d+dnTOwrH25D8gQBYgOqEhycZbtJ0Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Ls9yrDx1; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Ls9yrDx1"
Message-ID: <c0102f11-e49e-49e0-a7af-0c1dec642096@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785827785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3sECbQhrc49ZYKE5BpwdT9Cf3QB2zBQRhm2HJ2E4Miw=;
	b=Ls9yrDx1TzbOuDad3NY/dCJy/lxrFeUG/bFiu6tr48lbG1y/0ZnC7b7tws7J3r8tq7aRGb
	Y1W659uxg4JraIo/inMY2ofI8Wx+jnRNRdsXVkdQcIdKwDS4RZxOJ0lesCzUpVU/THuJqS
	lCfac5YPc+Vf4DMsfh1rvgEoSnRitEAC2tYzq31MIiIVbv33CxsxU7SsqsqQwk9ygQ2q/E
	y5XCjgZUEWzamg+op/nBTHfzvfEN4/wLbYDMJBSwigtH1ng11b56nmXAAXWZRfbLVoTlFH
	uDEuSSf6MhDhLsIiinIKmrR79Spuxc/HDXWKYN+FGndOgUrmdgEvfzCxWX+9gg==
Date: Tue, 4 Aug 2026 15:15:22 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: check destination is open when renaming
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
References: <20260611085847.653284-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd8ah8Jxi55WaoOONUDJEtRpkwTYvmNnL9e+4=FPD2fnHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

Currently, both the client and server support only 
`FileRenameInformation` (level 10) and do not implement 
`FileRenameInformationEx` (level 65).

Level 10 does not support `FILE_RENAME_POSIX_SEMANTICS`.

- MS-FSCC 2.4.42 FileRenameInformation: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/1d2673a8-8fb9-4868-920a-775ccaa30cf8
- MS-FSCC 2.4.43 FileRenameInformationEx: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/4217551b-d2c0-42cb-9dc1-69a716cf6d0c
- MS-FSA 2.1.5.15.12 FileRenameInformation: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/87f86c9b-6c2a-4803-84b7-131a74a434fa

On 6/13/26 11:52, Namjae Jeon wrote:
> This check is also applied when SMB3 POSIX extensions are negotiated.
> POSIX rename semantics allow replacing an open destination while
> existing file descriptors continue to reference the unlinked inode.
> The check should therefore at least be skipped when
> work->tcon->posix_extensions is set.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

