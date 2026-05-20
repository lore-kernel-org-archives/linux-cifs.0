Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211193D3CEE
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 10:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271665; cv=none; b=PkGGZSHOIaUnFbheSKE+T6QhyVbBo2Hi5u8sjj0mWu020Lduu7goZpaso0hSzOWcLFB1S5PokgCEtAWAkyAe/9uGh9DjfoXt3+DohY6+KAb23iwP6lcMkZWVufprTsa3WOKQYsX/Z2Ns1lnKUWJoxioF4VUi+7SiK82m1RI5Xno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271665; c=relaxed/simple;
	bh=89KEaH4apBrQ0FOx7VNNCPL6EBVexWeq5KCxbb4pZss=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=on4TZEBC61eFqrI9NlpuF17naIK5zet2BYUW8+rSdTajWqB9peolk8b+pWyG8xKv9FpFGVnr8UbdvhCXrxgYNLXp52EuuER0hFcEs2OuHQ6+u1Y0/k9FaFBPMl7LHpzCFlEQqoZphjOTAN5K29TNXtyyymFgi9ZH8KjfPB+awvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=FefTsrGg; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="FefTsrGg"
Message-ID: <d23c9f3c-4c0b-44d3-ac0e-6f054b955c85@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779271657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kr99atF0tyg1aW3wsOM0VphDsSGDpGtIgiOXMA59cFk=;
	b=FefTsrGgalCLVpMtAVcHY3sox0hzcCWxliL1dkDnrcJSvwM7rvKQ3Mf4GSXPJA/Uz301MZ
	AMkw0JsfLLUDvK4EM91VcASeT8XHGndci68E6l2A/MwgZWOims2+bnSw/ZnEfMnrQoYmFS
	A9RtCCpLuvkOTY3kWExW+zX7iX9JTApVj10ULmaY23Hn/ViG3VCf9Hy+1+dhRJZxc9Psqt
	k8LcGXl7F02dKAh3zH/lj2y12ONLiTrHZcrHM465sDWU/S+KPDmFgE9lLxg51S7hkfjB4r
	SmqPzaTAEFBMmHHeiOf5Zx5P9aHMaURPIz3vIVQXkPElnC01ni7tNQ9yaq8zmw==
Date: Wed, 20 May 2026 18:07:24 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH samba] smbclient: cancel pending notify on SIGINT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: Stefan Metzmacher <metze@samba.org>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
 Samba Technical <samba-technical@lists.samba.org>
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
 <9ecddf93-3599-4e0e-8aa9-93890fd54d96@chenxiaosong.com>
 <83ba770d-1a75-4231-843a-3e51ce3f85e5@samba.org>
 <60328fa3-1370-46a7-9114-0267ef0551ce@chenxiaosong.com>
 <9b73c105-03af-4e71-93b5-a94e13b8c7dd@samba.org>
 <3a43f239-f35c-4d69-9c21-b410f0e38081@chenxiaosong.com>
Content-Language: en-US
In-Reply-To: <3a43f239-f35c-4d69-9c21-b410f0e38081@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

But this patch is helpful for improving smbclient. When we press Ctrl+C, 
it should exit notify instead of terminating smbclient.

On 2026/5/20 18:03, ChenXiaoSong wrote:
> Got it, I will try to use smbtorture to debug, thanks.
> 
> On 2026/5/20 17:32, Stefan Metzmacher wrote:
>> Am 20.05.26 um 11:21 schrieb ChenXiaoSong:
>>> Once the implementation is finished, I will test it with smbtorture. 
>>> But right now I'm still developing it, and some issues require an 
>>> open-source client that supports cancel notify to debug.
>>
>> That open-source client *is* smbtorture
>>
>> torture_smb2_notify_tcp_disconnect is a very simple test for this.
>>
>> metze
>>
