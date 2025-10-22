Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA4B246BB0
	for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 06:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761112938; cv=none; b=nxMIKPgRJSyQkN+L0YmSNyGpKL3SpypfT6I/sLSPN2RARu0B5zZgz250EMOzjy4vYaLGqgYbfPLLf5EYGMBU2e7JXuCS+3+71t/z81bhryn3r4lAJ3D1Zqapzi/DobZYT83XUheFw48hzlwCfkA7uHbxC5628mwOpRE2kIqIQds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761112938; c=relaxed/simple;
	bh=l6MO0BJTfgJDmNRJ2K6Lf4PkNVLCQ1cTMHmCI7yT0Es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mEr8w/MugmtQBp4veaxM7KDSC8dFK1sTDx3Tpgji/to+dX/Ex5NHFX+GFGZJghB1Kno+fO/Fjm4Lk5FvM0TMxt9a+eiIGbRFUkbjzH+RlW29rTIlEVt8Lz8V6nSbhBnv3WNCYuds6Sq7WSUX7QCyY3u3ELIkCfSygcQCWeHidZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vDNe0z/J; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vDNe0z/J"
Message-ID: <54e95e16-1e46-4e6b-87aa-a685ef3075e4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761112935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzDGVcKweDncMNqL1iDjoY2+3MKreIN7O3zHk5EZ6IE=;
	b=vDNe0z/JSLO/hD2fzw7IUyWi5J37QIUR+l2uUv3ma8+V95UnPpG2dNs+Rd+1ikETvWA2bB
	/YQMRrpNrco4b0r9H2V+dPWPoyo7fcyvNWHLcJdH8/7OuaZvSou43oHLZugGUDdq0IQCEL
	SKm+vXFUY/GaFYGuN9PaubVrljVD8bQ=
Date: Wed, 22 Oct 2025 14:01:24 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 12/22] smb: move some duplicate definitions to
 common/cifspdu.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org,
 smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org,
 tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-2-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd8j6LjAvzBvKh9N3nvtqacLwLQ24sHKHu2Wh3vT1NtBYg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd8j6LjAvzBvKh9N3nvtqacLwLQ24sHKHu2Wh3vT1NtBYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae and Steve,

Would it be more appropriate to move these to common/cifsglob.h?

On 10/20/25 1:22 PM, Namjae Jeon wrote:
>>   #define CIFS_PROT   0
>>   #define POSIX_PROT  (CIFS_PROT+1)
>> -#define BAD_PROT 0xFFFF
> Moving just this one doesn't look good.
> Thanks.

-- 
Thanks,
ChenXiaoSong.

