Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B1A2222AC
	for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 04:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765340984; cv=none; b=r2NUI155pMTZbDzOKovQ2vrXHUgYg4FUSDEgF3YfFU0t1a2gTPZcoPeUUhEgHOoQNC6ECGI/gJ4Jv5Lkaye/C+rQUpkArAXbsQ7QaX2E5rs8UJdbTJBHqc82jrBgKDJNKGzV0K3dkKzNA2Y1/mHAqetcbS83qiE2GaZQ9LYy3/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765340984; c=relaxed/simple;
	bh=+3oD+13uzi54tQXltKZN4lKugLDxKrj5aQEg5TDiY0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KAMzfU4yiwrT+f036+KbyeRzAY1deiJaZdRUGGfyEaAOcDCzfcbLgd2D21pbt0uNDiX1+spHdoMxLfbc40mu3GpcpRRkHxWSIQTLym3iAoXVVKK7+T/jT+m0q4onPIdticllMnwwZJ71Ts2qPZKcT5xX1Ii/mlkGUI8UkIxC6OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uRqoEoYT; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uRqoEoYT"
Message-ID: <ce09c209-c97e-4dcb-b3a7-b18ba56a86a1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765340967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=13ycvtHZ6gq39kTVHwlVgZbeJV0gcG4wiOcNMZx9uyQ=;
	b=uRqoEoYTU5iqBB+5tG0LoyxlpoGlPynVK6RD0AnMYbRVv3CBNT1JFyAx9nNi42mJmr4Snk
	02UjUZDCd21bBH+p1P/NikDzS8u+/nFHqlvpwT0oheC62WnovvtUD3Q7SzjLYN7O4oJY3D
	WouPB7c2D+r0HIWRJoufUW0moCC9kiI=
Date: Wed, 10 Dec 2025 12:29:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 00/10] smb: improve search speed of SMB2 maperror
To: sfrench@samba.org, smfrench@gmail.com, linkinjeon@kernel.org,
 linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn
References: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Steve and Namjae,

I have tested all patches using KUnit tests, xfstests, and smbtorture, 
and no additional test failures were observed. The detailed test results 
can be found in: https://chenxiaosong.com/en/smb-test-20251210.html

For more detailed information about the patches to be reviewed, please 
see the link: https://chenxiaosong.com/en/smb-patch.html

Thanks,
ChenXiaoSong.

On 12/6/25 23:18, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Before applying this patchset, when searching for the last element of
> smb2_error_map_table array and calling smb2_print_status(),
> 3486 comparisons are needed.
> 
> After applying this patchset, only 10 comparisons are required.
> 
> v1: https://lore.kernel.org/linux-cifs/20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev/
> The three patches from v1 have already been applied to the for-next branch of cifs-2.6.git.
> Please replace the following patches:
> 
>    - [v1 01/10] smb/client: reduce loop count in map_smb2_to_linux_error() by half: https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=commitdiff;h=26866d690bd180e1860548c43e70fdefe50638ff
>      - Replace it with this version(v4) patch #0001: update commit message: array has 1743 elements
> 
>    - [v1 02/10] smb/client: remove unused elements from smb2_error_map_table array: https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=commitdiff;h=905d8999d67dcbe4ce12ef87996e4440e068196d
>      - It is the same as patch #0002 in this version(v4).
> 
>    - [v1 03/10] smb: add two elements to smb2_error_map_table array: https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=commitdiff;h=ba521f56912f6ff5121e54c17c855298f947c9ea
>      - Replace it with this version(v4) patch #0003 #0004.
> 
> v3: https://lore.kernel.org/linux-cifs/20251205132536.2703110-1-chenxiaosong.chenxiaosong@linux.dev/
> v3->v4:
>    - Patch #0008: the KUnit test searches all elements of the smb2_error_map_table array
>    - Create patch #0009
> 
> ChenXiaoSong (10):
>    smb/client: reduce loop count in map_smb2_to_linux_error() by half
>    smb/client: remove unused elements from smb2_error_map_table array
>    smb: rename to STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP
>    smb/client: add two elements to smb2_error_map_table array
>    smb/client: sort smb2_error_map_table array
>    smb/client: use bsearch() to find target status code
>    smb/client: introduce smb2_get_err_map()
>    smb/client: introduce smb2maperror KUnit tests
>    smb/client: update some SMB2 status strings
>    smb/server: rename include guard in smb_common.h
> 
>   fs/smb/Kconfig                    |  17 +++++
>   fs/smb/client/cifsfs.c            |   2 +
>   fs/smb/client/smb2glob.h          |   6 ++
>   fs/smb/client/smb2maperror.c      | 101 +++++++++++++++++-------------
>   fs/smb/client/smb2maperror_test.c |  71 +++++++++++++++++++++
>   fs/smb/client/smb2proto.h         |   4 +-
>   fs/smb/common/smb2status.h        |   5 +-
>   fs/smb/server/smb2pdu.c           |   2 +-
>   fs/smb/server/smb_common.h        |   6 +-
>   9 files changed, 165 insertions(+), 49 deletions(-)
>   create mode 100644 fs/smb/client/smb2maperror_test.c
> 

