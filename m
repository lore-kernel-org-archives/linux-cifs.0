Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFD731ED81
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 09:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268976; cv=none; b=F9hj92ZsLe6EkLAWvAS5qG+F79A1nnIww1pRJVAMD0N7cvPctKT9Z5bYL4AlWcmMuBkHydtkhARpi6syt5xgK1s6R5xmAf760mGIVC9t90MaTIsFMlHXfyt/fF66G3vUbm2WyW15EAWqcmQErgpVqecUVcKFEVd/UKaYHz3V528=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268976; c=relaxed/simple;
	bh=onoJVnPUwuPOXYvQi0jC3EcJdQTj3tMpnHEoO+0u/pE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SFszbDj5+aMwo8mV3e3Nn5Jkv/OBUag8vNEGqqcgxG6n8Kw3q3QsZxUY9pHIWTH2hPMk6YHOEisdyKXhNOnUnRxc0i8KnYKfI6cqQwP9rbIpq2PtFch/8SC7uTAE2zh1j31hPzigu4DC/uIweoiU+ffGRnQ4IR8Bi1a23Ue86ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=GotDxwOC; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="GotDxwOC"
Message-ID: <60328fa3-1370-46a7-9114-0267ef0551ce@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779268970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c+ANBRLfRcPbi7GPs5mjvDNFvk740Ab+yYxrE5q1hEI=;
	b=GotDxwOCVieOICzvEPUpUwGsEkdsQVZbRx14rlFE6blurzaR7+eL0NA4uwUdUl4svnG60o
	qvG4rKNzteKgvqkGuCC/XUwqL9UM3fSunB8SbursvHMvRADAkhrxGeNyDlZqlUo9/0+QCz
	IOzaqJaO3JYORHnf9hCyhDPShmhXBqeLXkHwDV6+QiKT/lW+mU5/OHjn/y0obi/lvqQ2UL
	v8tjjg6rnSimKFvxVncce8RyInl83+sHxGX3t/RumGTL71SCsw83wYzvev+F0LtV20ov4w
	Q0QqClwV/aGKLjlfYLi4Oum209GViJ6K7/DzP5RHBU+zTwsNT4Oz36SjMd607g==
Date: Wed, 20 May 2026 17:21:54 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH samba] smbclient: cancel pending notify on SIGINT
To: Stefan Metzmacher <metze@samba.org>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
 <9ecddf93-3599-4e0e-8aa9-93890fd54d96@chenxiaosong.com>
 <83ba770d-1a75-4231-843a-3e51ce3f85e5@samba.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <83ba770d-1a75-4231-843a-3e51ce3f85e5@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Once the implementation is finished, I will test it with smbtorture. But 
right now I'm still developing it, and some issues require an 
open-source client that supports cancel notify to debug.

On 5/20/26 17:12, Stefan Metzmacher wrote:
> Have you tried to run the smb2.notify test of smbtorture?

-- 
ChenXiaoSong <chenxiaosong@kylinos.cn>
Chinese Homepage: chenxiaosong.com
English Homepage: chenxiaosong.com/en

