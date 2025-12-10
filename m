Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580397080D
	for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 04:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765341189; cv=none; b=aEXP/zBSoOmtbUKizuM8BKMaAVzt3pIrYSKIQETcPCZFIDBGgEVrZeORv4fGza4yGz/Usip/5VFe53bXwIPO8O5L/zoGQw7CBLaDDZ3AUAUFcqvrM2qdX9LPnRiceXiPL5AbbObakWy2RDdsaGId2g+OvMEQ2IfRvhHfQ6X9lv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765341189; c=relaxed/simple;
	bh=csH4AYm5Xl7y9BqWS3SZrKlQbmAUTe1Ai921FDfiBTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NDrW8FLdNNC6ixqMvl67KtTA2h2AVccXJWerhi0przptMykMa27N4dpp/QAkix+xLtJzyqioaKZbfG39O6pgKABupefvp7thXc8NCRw4pnMSFwtV7RpU02foh5WHOKOWC77xHkO6g/xV+aSTpwEg2mvxgQbtFJ7zajVG5CcebKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xmgMSLSv; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xmgMSLSv"
Message-ID: <8a5f7591-14cf-4dcf-86e6-9684a3e9dcae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765341185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jabQ4utqUAlD8GqxNKDd6jXKxgXsiiMOnfUKRCz1PTs=;
	b=xmgMSLSvvdpOYiUwDqpokhmeLyqc6tZ/sSrXCLO2lKSp1pgwEmmyoiChFLeFdrMGLq+TbG
	naNgv2T5pJ4jD30KrcnRnI2+b52YJX8VFSgdqxDxvmYm/n6ceHRWbE0XYCHQ3d9EX4OQbv
	3lfhkWAx1mi0Q/ZR6D2jANeyLrnoW7s=
Date: Wed, 10 Dec 2025 12:32:23 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 00/30] smb: improve search speed of SMB1 maperror
To: sfrench@samba.org, smfrench@gmail.com, linkinjeon@kernel.org,
 linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
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

On 12/8/25 14:20, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Before applying this patchset, the patchset ("smb: improve search speed of SMB2 maperror") must
> be applied first, which introduces `CONFIG_SMB_KUNIT_TESTS` and avoids some conflicts in `fs/smb/client/cifsfs.c`:
> https://chenxiaosong.com/lkml-improve-search-speed-of-smb2-maperror.html (Redirect to the LKML link)
> 
> When searching for the last element, the comparison counts are shown in the table below:
> 
> +--------------------+--------+--------+
> |                    |Before  |After   |
> |                    |Patchset|Patchset|
> +--------------------+--------+--------+
> | ntstatus_to_dos_map|   525  |    9   |
> +--------------------+--------+--------+
> |             nt_errs|   516  |    9   |
> +--------------------+--------+--------+
> |mapping_table_ERRDOS|    39  |    5   |
> +--------------------+--------+--------+
> |mapping_table_ERRSRV|    37  |    5   |
> +--------------------+--------+--------+
> 
> ChenXiaoSong (30):
>    smb/client: fix NT_STATUS_NO_DATA_DETECTED value
>    smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
>    smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
>    smb/server: remove unused nterr.h
>    smb/client: add 4 NT error code definitions
>    smb/client: add parentheses to NT error code definitions containing
>      bitwise OR operator
>    smb/client: introduce DEFINE_CMP_FUNC()
>    smb/client: sort ntstatus_to_dos_map array
>    smb/client: create netmisc_test.c and introduce
>      DEFINE_CHECK_SORT_FUNC()
>    smb/client: introduce KUnit test to check sort result of
>      ntstatus_to_dos_map array
>    smb/client: introduce DEFINE_SEARCH_FUNC()
>    smb/client: use bsearch() to find target in ntstatus_to_dos_map array
>    smb/client: remove useless elements from ntstatus_to_dos_map array
>    smb/client: introduce DEFINE_CHECK_SEARCH_FUNC()
>    smb/client: introduce KUnit test to check search result of
>      ntstatus_to_dos_map array
>    smb/client: sort nt_errs array
>    smb/client: introduce KUnit test to check sort result of nt_errs array
>    smb/client: use bsearch() to find target in nt_errs array
>    smb/client: remove useless elements from nt_errs array
>    smb/client: introduce KUnit test to check search result of nt_errs
>      array
>    smb/client: sort mapping_table_ERRDOS array
>    smb/client: introduce KUnit test to check sort result of
>      mapping_table_ERRDOS array
>    smb/client: use bsearch() to find target in mapping_table_ERRDOS array
>    smb/client: remove useless elements from mapping_table_ERRDOS array
>    smb/client: introduce KUnit test to check search result of
>      mapping_table_ERRDOS array
>    smb/client: sort mapping_table_ERRSRV array
>    smb/client: introduce KUnit test to check sort result of
>      mapping_table_ERRSRV array
>    smb/client: use bsearch() to find target in mapping_table_ERRSRV array
>    smb/client: remove useless elements from mapping_table_ERRSRV array
>    smb/client: introduce KUnit test to check search result of
>      mapping_table_ERRSRV array
> 
>   fs/smb/client/cifsfs.c       |    2 +
>   fs/smb/client/cifsproto.h    |    1 +
>   fs/smb/client/netmisc.c      |  155 ++++--
>   fs/smb/client/netmisc_test.c |  114 ++++
>   fs/smb/client/nterr.c        |   12 +-
>   fs/smb/client/nterr.h        | 1017 +++++++++++++++++-----------------
>   fs/smb/server/nterr.h        |  543 ------------------
>   fs/smb/server/smb2misc.c     |    1 -
>   fs/smb/server/smb_common.h   |    1 -
>   9 files changed, 739 insertions(+), 1107 deletions(-)
>   create mode 100644 fs/smb/client/netmisc_test.c
>   delete mode 100644 fs/smb/server/nterr.h
> 

