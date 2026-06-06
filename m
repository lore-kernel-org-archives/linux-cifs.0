Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931F630C617
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 13:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780753868; cv=none; b=Ztodq2fTPa63uFRvVHrv52Ivm+Y2zuoBqv9eVWE7Jw3dylTW3R+z0G53RtcgpsZtZ40F9zpCFjWyPyjPIy+0ZoP69vQs+LyDd2K8R4ysoJ7rd5mJuH7rN+OJRMpq9JxBGoVw7Y+CUzsza5Z5VI/9ofXb9ow5s0TaXeUtc3doJSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780753868; c=relaxed/simple;
	bh=KHm+2LKUs14eo6qh8mJQ97ix//xkPACeaiQv1eSdwiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+c9tYTSwWyz71EPk5e80zveHCsEUMjwjJiQ+HgcYoPNe6gPrnKqR6IGun66Mf8lVqTX4gMJLQIMd/i3O3/aGlcCoHCCoude+dTPT0ki6NtufjECSH0mCNbctJfM7bKP+rbjRcXbvVATU3EiMl2l38bAI8vfePNOrA+rOlZNVrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=fW4faI8c; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="fW4faI8c"
Message-ID: <a4502395-735d-4c90-a116-754a3e91137b@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780753864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+CZkt1CIqGjM31qEeT1wxXVFoADijGaFoqQmtJ7PuFQ=;
	b=fW4faI8cQseTFJwqYOtBvAmg/S0Vj0/wGSsjlCJk68KgWnXkiLe7JF7zh/tJDEXB4soQJC
	tOJjqac+Nudth31fJGyTye8weQKpDUCsHdmDK6wPRiz/WSpYtdVN6sxmFwKsq0iytJ3KoJ
	9XJuPv4mAGECbLGPO67ksrnNLDixILhlYTABqHfy3JgqoBQ86jkRzaao+P9QogjT8juZ+P
	ZD8BrJf8N7zgbLIKYUQ6ugSTWQgbA/FXX6xFi6ccu9exbHH2L7De0MCt6JOErfBPmx1VAi
	8G77p3vlp0AHJWqL8HbHAvtw95FfxcIonNZIrhLaQpvBL+QBceyox/wvojUN1w==
Date: Sat, 6 Jun 2026 21:50:53 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] smb: move compression definitions into common/fscc.h
To: Namjae Jeon <linkinjeon@kernel.org>, chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-2-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-inU4rYZ=P0SmLUwDdL-x=QtJuBPdSg2DRKZMF-KuLDg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-inU4rYZ=P0SmLUwDdL-x=QtJuBPdSg2DRKZMF-KuLDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Please see MS-FSCC 2.3.67: 
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/77f650a3-e3a2-4a25-baac-4bf9b36bcc46

在 2026/6/6 21:46, Namjae Jeon 写道:
>> -#define COMPRESSION_FORMAT_DEFAULT     0x0001
> Where is COMPRESSION_FORMAT_DEFAULT defined in the specifications? I
> looked through MS-FSCC but couldn't find it...

