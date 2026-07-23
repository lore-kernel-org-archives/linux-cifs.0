Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8008B33FE15
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 06:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789902; cv=none; b=i0MfaP5FY2LiNI6hrvrKgdcwc0urxZYVCTwgh9MiAUARMs++LDn3Li8k0nM6nLFG8Q9r3fVvZsw1h09li2KnWOb3l29ssHIY0PMQVxHo0IYxqyq4A4qccFaO61nUc7N7bWfxkdj2Cxtbc13PwkXeKpQTqMAnggIQXfFZC/wLBds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789902; c=relaxed/simple;
	bh=91suFDs/7ipFMc2H2FpcpQv+ljKEIENt3uMacTaZ7mM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bj9m4yk1YCmdsdQ7QZIgkJWYGPHmDVNmwr5eUHPlD1psWqK95LqOwbOfdYyPwCRoBp3F8hpw+7byuJ5Iv3bOV0gv4BzyJzYiDvR+IGLXtN8CDSDzTbTNkBQlsI2Pa8RH054wByUOcUCZbU0IIHEPla43c5f3MJBNmyN52/aipcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Y5Jj8oJT; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Y5Jj8oJT"
Message-ID: <ce461389-2b54-4097-9f7d-409107e08e1d@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784789896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XJkAKkdjNB5TAExBUm2WSGA2oeuQ//QZepstYsocF28=;
	b=Y5Jj8oJT7cG/DKwEFXySTd3dID0GV5ZK7G2QK16E5Fv9CMMz1gHBOAecYwHGApXTIQVkS4
	5PxwwO3d0RWEyotH5QPPw+iq/VKyPNY8nFFNXaBFLCqIQyCQaxDWYkZUoO9lxw8n62FIBy
	+KowFPcMaTTgyDqMUVWFAqZSp+RcFpECjZMFyh9JaxyW4qRGQTdkGjIjVKKhTm6I+h+SAI
	mN7SN82B72Iq3Zw0IrH4D5xDgPQiOjA90kkUlB5HhtAs5tUiiNBrtpzzWiFX9CgUiulprF
	VAyP5hEWVzDKyIOIy/YWEQ1lZ/BW1KW2wOA7QYuTl1ES+zse0prafaLU6dtDDA==
Date: Thu, 23 Jul 2026 14:57:46 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/3] smb/server: stop new async work when closing
 connection
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 gael.blivet@gmail.com, andriy.shevchenko@linux.intel.com,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
 <20260723041131.313321-4-chenxiaosong@chenxiaosong.com>
 <CAKYAXd_X5JSh8YGk5Z8-gx2A=PDcmW74jKK8co=z=9Zxty5xSg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_X5JSh8YGk5Z8-gx2A=PDcmW74jKK8co=z=9Zxty5xSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I agree with your patch. However, could you split the changes in 
smb2_notify into a separate patch? We don't yet know how Gaël will 
update his patch, so keeping those changes separate would make things 
easier to rebase or adjust later.

Does that make sense to you?

On 7/23/26 14:49, Namjae Jeon wrote:
> I would like to apply the attached patch instead of this one, so
> please check it.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

