Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57723D333A
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 10:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271415; cv=none; b=gUDvUKeKgTlk5LPmG59UGPcNmSCIIW2I/Fi7zt/HahzGPPcZC0Awh/5RmQ5VINKOZu3HobR0uUJzbzZaj93j4Ug0fximIpX9b6Wt5lmq8RIwbryTQTMB2FAteXXcdNUUiRVvQeNq6TG9vv3FLPJnT0EF6UXTDUMBr8EUeDLPBFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271415; c=relaxed/simple;
	bh=lXSV4OAE0hESm8bR6k6RgTxa/csfsY+BIPOoo4Wi30M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g2iajNbMhc4a+mmvIAtV3VJlO+LTqB3XERYdsTWruWpeICkDK9VcsJ5tkoT1W17LFuXcKF9dRluFytTy4VRddEds0qGZ/CXDepQRySO6rJbbrRPY6FREGHzrum4OisCHVsM00Wnx4JkaleteDE1kkElSpng+FVszefH0k1dUAxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=GWpNfZl7; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="GWpNfZl7"
Message-ID: <3a43f239-f35c-4d69-9c21-b410f0e38081@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779271407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QC3myGxz1OY3v56Po6PFF38hLRypHmRHNuwyW6KKfwY=;
	b=GWpNfZl72g0zTSbHAZji9+9IXZs+rxR2lFLu86+pBbyNxlDet2TBwErIye+KanmBEw0dbO
	rv3v3sAX7D7hj49NegwyWZbvDMMpQfsV9YHn+NmqzTSBsskqYalVMsFs8Ct8UA4q2Rd1C3
	rLhUUV3DPgDBLkaJkKznoOzq5ztWhmHlcR2oMeJmU1G0t6lnpJ33OkKEJaOjk1ZYdpdZtE
	phHCNyhPVOPlpasjCA5/Ua4YmrprE/ZnatDu0J9MQIuFyRqxBXBfw++mxeJzB0TH+z0K46
	Iszxaxbm/kN6Yg1hdCXeQKxJby/Je5MiRQH8+3gQxZM6o8KFRd5MznsIf0Ia+w==
Date: Wed, 20 May 2026 18:03:08 +0800
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
Cc: linux-cifs@vger.kernel.org,
 Samba Technical <samba-technical@lists.samba.org>
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
 <9ecddf93-3599-4e0e-8aa9-93890fd54d96@chenxiaosong.com>
 <83ba770d-1a75-4231-843a-3e51ce3f85e5@samba.org>
 <60328fa3-1370-46a7-9114-0267ef0551ce@chenxiaosong.com>
 <9b73c105-03af-4e71-93b5-a94e13b8c7dd@samba.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <9b73c105-03af-4e71-93b5-a94e13b8c7dd@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Got it, I will try to use smbtorture to debug, thanks.

On 2026/5/20 17:32, Stefan Metzmacher wrote:
> Am 20.05.26 um 11:21 schrieb ChenXiaoSong:
>> Once the implementation is finished, I will test it with smbtorture. 
>> But right now I'm still developing it, and some issues require an 
>> open-source client that supports cancel notify to debug.
> 
> That open-source client *is* smbtorture
> 
> torture_smb2_notify_tcp_disconnect is a very simple test for this.
> 
> metze
> 
