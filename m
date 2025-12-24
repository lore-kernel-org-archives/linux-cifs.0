Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD313451C8
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766588965; cv=none; b=FXW5geaaeRmS+PmWNODiza905V0WIIS1yjSRRK0ZezKTUyvSVohKf0AoeSVJKHJNr2bdBww7owo/aOZeHTK1YfF4mo+3g4X+yrNZ6nSOFWtpVU8OuJKieGCuaKFgQBj64y9GWrjWDdcAVTaV/WNwDlF6+P/24sdRx0weOwt0QJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766588965; c=relaxed/simple;
	bh=8sSa0/78MLhyDNPZ/3M8SQttcxlcJawZC8bghsaFZ4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IJqD26Xgkvwsy2sRNJQxI7ReWHka9z1eaF+3OUREUAtomqaRK51seyD35kfudCnofzyY6qs2wPuaEh1muK/ARq2weaAntbc5v0w1Gl96t+yTxLWqgDE9tLTpkFU4VRWai2rQ4ACmzr5B3scOv/XA2c80eIOiWrPvULolni7Aw9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WIhkxFEo; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WIhkxFEo"
Message-ID: <1b7feec5-aaa3-4bbd-ac7e-76aa871f779f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766588961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IbaUw0+a3kTD6XoWSUkOJsF40Z6JTYURWRh81UkExc4=;
	b=WIhkxFEo4PgUpv94MckPwcw7UVaiJ71pHeeWLsLM2hHwjPVQ0hnoGCIoHXL6yzsZm4YmVz
	67f2XAvE597QN9hRzqeUu4QysM4sk9VlCroV3YBq92rbAwDiKAXqp1LT1WghH/4V9hJCPW
	2ajn7Yv655cLV+vQ5MtCtcFXbbsiywg=
Date: Wed, 24 Dec 2025 23:08:56 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 5/5] smb/client: introduce KUnit test to check search
 result of smb2_error_map_table
To: David Howells <dhowells@redhat.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251224023145.608165-6-chenxiaosong.chenxiaosong@linux.dev>
 <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
 <1168035.1766564530@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <1168035.1766564530@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Yes, it's not a kunit test in loadable module form.

Just like `fs/ext4/mballoc.c` includes `fs/ext4/mballoc-test.c`.
`smb2maperror.c` also includes `smb2maperror_test.c`, allowing KUnit
tests to access any functions and variables in `smb2maperror.c`.

Thanks,
ChenXiaoSong.

On 12/24/25 4:22 PM, David Howells wrote:
>> +
>> +#if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
>> +#include "smb2maperror_test.c"
>> +#endif /* CONFIG_SMB_KUNIT_TESTS */
> This feels weird, but I think I can see what you're doing.  I guess it's not a
> kunit test in loadable module form?

