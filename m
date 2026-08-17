Received: from mta1.migadu.com (out-216.mta1.migadu.com [95.215.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01AC3B0AC3
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 06:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786949850; cv=none; b=oD9cj3aDPuRHIXbnpuzOnqz8IMqg5vQLwft2eY0gbxWqpJ8cgE5myR8O49nnDGTzAHSFA0B6JFkCAx+wt8v1WddJiiHNQUGsXRNOf7rMGNcs2vxKp5a44fQjwDC4Fs9wW+b+u3yYjs7U5wP0E9v0gMyGg12F22/ngl8XExxHfS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786949850; c=relaxed/simple;
	bh=LK7RKGnAzv19r27+Kf11yJLc+T/qWqLONAO2FvuGMzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W9x6PdYg9OT5LmERzNvLp3ImdQRMuo7OT6XTKm5JdnboxYUTXC8akvPzDRG8ezzsd4UF+vjY4CtMqQQHlzTWy0MArdKhzbmUghc/K8nYI0zX3oiZ4eI7Mx6zyadLvy1jsjQ9QrutVx5yhTi1B/lEJcl8n7vr7Q5Ttajtw6k7QMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PiZR7YT7; arc=none smtp.client-ip=95.215.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PiZR7YT7"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LK7RKGnAzv19r27+Kf11yJLc+T/qWqLONAO2FvuGMzs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786949846; v=1; x=1787554646;
 b=PiZR7YT7cSagzFoLY41Sm4BBmiV0JxOQdBe54XvGt+lTQc1rS8Psgw+uKFURXeWblH5Naely
 zgRRKn1VAfoGw1LHnk+ktySOCrgNwcJBgBBk8BU4HH4ukhpOJ6K76zKSjtfa3RkMkxNdb+i+ZxB
 ewNgWSLrHQUmt65Wbe16TpJY=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.3.165] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 112c9aa3c9f409b1;
	Mon, 17 Aug 2026 06:57:26 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <782ba8b3-336b-459f-8a39-808c1fde9f06@linux.dev>
Date: Mon, 17 Aug 2026 14:57:21 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb/client: remove redundant NULL check before kfree()
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn,
 linux-cifs@vger.kernel.org, lkp@intel.com
References: <20260816153922.484091-1-huiwen.he@linux.dev>
 <CAKYAXd_N3i0jvBn0Nw3-K+U1yS528-ynh0PVETrGuLDnGsZV_g@mail.gmail.com>
Content-Language: en-US
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAKYAXd_N3i0jvBn0Nw3-K+U1yS528-ynh0PVETrGuLDnGsZV_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Namjae,

I copied the Fixes, Reported-by, and Closes tags from the kernel test
robot report when sending the patch.

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   3eb40771c00a8488fa6ed2cc1fe203477908bf38
> commit: 5693347de107a26f68d1f43b25ff2e348c7229a9 smb/client: use writable handle for FS_IOC_SETFLAGS compression
> date:   9 weeks ago
> config: powerpc-randconfig-r053-20260812 (https://download.01.org/0day-ci/archive/20260816/202608160402.0ffQDoCg-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 12df34b8469b8095359de8c249cb1b2753fadeea)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Fixes: 5693347de107 ("smb/client: use writable handle for FS_IOC_SETFLAGS compression")
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202608160402.0ffQDoCg-lkp@intel.com/
> 
> cocci warnings: (new ones prefixed by >>)
>>> fs/smb/client/ioctl.c:135:2-7: WARNING: NULL check before some freeing functions is not needed.

But chenxiaosong suggested that the Fixes tag may not be necessary 
because this is only a Coccinelle cleanup with no functional change. I
am not sure which convention is preferred here, so please feel free to
drop the Fixes tag when applying the patch.

Thanks,
Huiwen


在 2026/8/17 14:42, Namjae Jeon 写道:
> On Mon, Aug 17, 2026 at 12:40 AM Huiwen He <huiwen.he@linux.dev> wrote:
>>
>> From: Huiwen He <hehuiwen@kylinos.cn>
>>
>> kfree() accepts NULL pointers, so checking tmp_cfile before freeing it
>> is unnecessary and triggers a Coccinelle warning.
>>
>> Remove the redundant check. This does not change runtime behavior.
>>
>> Fixes: 5693347de107 ("smb/client: use writable handle for FS_IOC_SETFLAGS compression")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202608160402.0ffQDoCg-lkp@intel.com/
>> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Applied it to #for-next.
> Thanks!

