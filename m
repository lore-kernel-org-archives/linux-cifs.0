Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351AF1D6193
	for <linux-cifs@vger.kernel.org>; Sun, 18 Jan 2026 09:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768728044; cv=none; b=PRl0uYWwGpJiY8MsvB4tAeMNEvtN0miqNC2vuIc9Dln63vozPliTPwMKF0PCyut5grTlqgt4wlwUpK+eEfcE5FQo8D4KlgkHkYAJv6TROfS1iF9ZqGnYQrjan2nu4o2C1Xf0TQUzQ8znwh6py70gu6+H5SV7ZELuHzZ8jJPGdJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768728044; c=relaxed/simple;
	bh=HkHM6XZeP6YwhjUcxo5AK9688Oc/LEY25XayGIU8mvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g7cFmhDedX58CVoR9x+r+g0G/Kb7suPkNGJp5etgJ9ImP7vxS3bwOB+/JnfHHlP29la0vr8Up31P1n1ujQxr+8PD00hBU/HC2tKcO2YEpI+M2PNziMqqHQxPRseg0xGC2V4cHwZb7NCl+nzefa+mzLovwd1mn74mu/tgTLbF+mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vvXw5kWr; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vvXw5kWr"
Message-ID: <c78f52c3-da95-442e-a860-636738616061@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768728041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kzbhh6WP2ww1CPTldgxHBaP9Wj1tLUI3rjKrLN7Hsfc=;
	b=vvXw5kWr3yQaCc+s5fnfly4Vl0EVWp8WpGSz4S6yVmH02xJkLyQsEes0JYqpIWpRDAq5u7
	gWH80s3mzunab9v+aRw3YgdnqVboFwv5L1vs1ecPwEWxCJmmeeOkS1PuzNwAQHMv4PnU0q
	twN8HV2hUKxPfmLnKE90mhenfFD8gI0=
Date: Sun, 18 Jan 2026 17:19:50 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v9 1/1] smb/client: introduce KUnit test to check search
 result of smb2_error_map_table
To: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 Ye Bin <yebin10@huawei.com>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Cc: linux-cifs@vger.kernel.org
References: <20260118091313.1988168-1-chenxiaosong.chenxiaosong@linux.dev>
 <20260118091313.1988168-2-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260118091313.1988168-2-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

When `CONFIG_EXT4_FS=m`, the `mballoc-test.c` KUnit tests in the ext4 
module cannot be executed. I have reported the ext4 issue to my friend 
Ye Bin <yebin10@huawei.com>, and he will modify ext4 to handle this case 
in a similar way to how we did for SMB.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 1/18/26 17:13, chenxiaosong.chenxiaosong@linux.dev wrote:
> --- a/fs/smb/client/smb2maperror.c
> +++ b/fs/smb/client/smb2maperror.c
> @@ -114,3 +114,11 @@ int __init smb2_init_maperror(void)
>   
>   	return 0;
>   }
> +
> +#define SMB_CLIENT_KUNIT_AVAILABLE \
> +	((IS_MODULE(CONFIG_CIFS) && IS_ENABLED(CONFIG_KUNIT)) || \
> +	 (IS_BUILTIN(CONFIG_CIFS) && IS_BUILTIN(CONFIG_KUNIT)))
> +
> +#if SMB_CLIENT_KUNIT_AVAILABLE && IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
> +#include "smb2maperror_test.c"
> +#endif /* CONFIG_SMB_KUNIT_TESTS */

