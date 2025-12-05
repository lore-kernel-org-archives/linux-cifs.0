Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D0E1448E0
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 00:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764896394; cv=none; b=k0Vcd7TsdTEY7uUNuiuhALB/82f2BOo1hYolZjuSOgDz6ADBVbpBSiPA20WIlbctFIa5OkBTVZToSl5tk5gWcsUmuoMvUGnFXJ+Sr1QtyI/+r1JgtawzS0qoxP+Kctcj9/DoKp31fFU/HWkZrUs6H2RcLF4KUdjJUPAKpN0TAX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764896394; c=relaxed/simple;
	bh=8D/yIeaaApuzWE2+kHnwW9q0n7M+0EiIBWtujpT7ew4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dZUoRzfRJTwzAIATUT9uNH+RpMnZFJTImijFm2ntpy/cBpb3fL1ZRyZCOiuBKNjRcWK71ZtTSKy0dARYkKO8PB/hZ9Q0PQoISTf5jacTi+e3Ly0qgyaSwofelOQ95nnldYn3BIp6TAALM1siHvDgF4TElEd9wje1EhXFpCM08lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lSG4puZx; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lSG4puZx"
Message-ID: <5f7758db-cf88-4335-9a03-72be1f7d6b65@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764896379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c0bBjK3LXo8bt8uCbpW6Bv11jkx7uWUV9472yXujsKQ=;
	b=lSG4puZx5usDc1a3F56XvIHGlFxWP9+pgIfLDpWvucTHzdc/Lp+VZG1wT4WneucXEDIlAv
	qsHoCiot1B3DlKcD514bn11d8wPcARJEbVnJ3yxHfNU2tCbYmVvA9GT+bKOoZD9Taomuav
	+65b0GvB7KSNgm9dkS5cx9U7au7qepM=
Date: Fri, 5 Dec 2025 08:58:52 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 09/10] smb: create common/common.h and common/common.c
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 chenxiaosong@chenxiaosong.com, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251204045818.2590727-10-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_-ctfkz1E_Sqh0bJMarUE8rDrd2o7yKKa_cOFGPaYELg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd_-ctfkz1E_Sqh0bJMarUE8rDrd2o7yKKa_cOFGPaYELg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

OK, I will create new smb2maperror.ko and will send v2 soon.

Thanks for your review and suggestions.

Thanks,
ChenXiaoSong.

On 12/5/25 08:35, Namjae Jeon wrote:
> On Thu, Dec 4, 2025 at 2:00 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> Preparation for moving client/smb2maperror.c to common/.
>>
>> We can put cifs_md4 and smb2maperror into a single smb_common.ko,
>> instead of creating two separate .ko (cifs_md4.ko and smb2maperror.ko).
> Sorry, I prefer not to create new *.ko for only smb2maperror.
>>
>>    - rename md4.h -> common.h, and update include guard
>>    - create common.c, and move module info from cifs_md4.c into common.c
> ksmbd does not use md4 in smb/common, I don't prefer this either.
> I would appreciate it if you could send me the patch set again except these.
>>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

