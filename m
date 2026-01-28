Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D895155757
	for <linux-cifs@vger.kernel.org>; Wed, 28 Jan 2026 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614263; cv=none; b=EJMrhWk8VQlc8RwdISiJpQHSI4CkfFExRk2jo0yWnaASMyqGbQU2zo16XBGk2iqbFm1LwEBy2IPuAghzzyI+Ahthty0Vq+Hc4s2xFS7KETRuQxjSDCRrtDdYE6eNy/BK79zOGXLr/s3SBn9OABz1t1XQPv+1tAt931xf65VOUy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614263; c=relaxed/simple;
	bh=0LF0WzNqpv+gvZlbI7zC8jh7iY56HH6T96ljIpkWEn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Noa/CO15Wj8HcVN8Y+VyYeTe680et+ITwYs5UAQfCX65XyOBbuRqxVqdY9x+71j0SyCOLyAqxWpGtWZGNry0xZW/IwFCtHIg7FT8bUj0i+WvwKpr6qN5d4Mc+DOGdxPDPvYnbcL8XZvqrdxhFVvnyFJawmzPOyLOSHosY9UurO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fPAk2YGj; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fPAk2YGj"
Message-ID: <bcd3d847-c38f-4c88-af07-3da09dad476b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769614254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5GkLaSPEAbkbWV7JSieeuvI5xjPgHd1OVou8qjcKRw=;
	b=fPAk2YGjCobio8anJpK3hHObc7a2PqPLPkb2m22YpaMBaVzkeTo2jzPo20i0YuVFyUA3yn
	86A+ejBezxpbF6VQt8LspEWQdO5cDpqpSidABKBp+3FPlYYjHCXdqJzsGfvlGOImJKGmVp
	CUTUTDboeNDAUGwpX6XTZ71LfSXKnCU=
Date: Wed, 28 Jan 2026 23:29:59 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: xfstests failed test cases
To: Steve French <smfrench@gmail.com>, Shyam Prasad N
 <nspmangalore@gmail.com>, David Howells <dhowells@redhat.com>,
 Henrique Carvalho <henrique.carvalho@suse.com>,
 Bharath S M <bharathsm@microsoft.com>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <CAH2r5mv41nFwJQwszD82MQbtDV75zVy6=tbwqxDTOsw2hwfBpw@mail.gmail.com>
 <CANT5p=qmo_KORMQbnjonapAaGHq=UvWAMzR0jNKBBvx3UUkyjQ@mail.gmail.com>
 <CANT5p=pfQE2A++j6W4sEudrSLH6ct=ho4i=k2ZDEecUAX0cReg@mail.gmail.com>
 <CAH2r5mvakK7=1i-fZTE9hLLYd_Q3o5z557vQZ5QQtdOTkZeSew@mail.gmail.com>
 <CAH2r5mufJgC85ULoVzYSMXDq4=-RUiJ2YgppM434vz1Q4B1d+A@mail.gmail.com>
 <CAH2r5msVifsc-E0TjaYXt2Afh1MiCsJTSwMnsDAdUShRgkJ_4A@mail.gmail.com>
 <CAH2r5mukVmnfK7X3jXWwRnD-_RAMuUgzXpi+HzNjxOat4tobJA@mail.gmail.com>
 <CAH2r5mvW23-eUsjDQ_0oLrmj406Og5sDs-yPgqh6jPwdSEG+Tg@mail.gmail.com>
 <CAH2r5mu909vLwAQcKFQX7cWz421V1QmSiBAKyJeC8gUcGVb0Ew@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5mu909vLwAQcKFQX7cWz421V1QmSiBAKyJeC8gUcGVb0Ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

I have reproduced the failures of these test cases. For detailed 
information, please check the link: 
https://chenxiaosong.com/en/smb-buildbot.html (I will ensure this link 
is always accessible).

Perhaps sending these issues to the mailing list could help resolve them 
more quickly.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 1/25/26 03:45, Steve French wrote:
> I did see a crash in cifs/103
> (http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/ 
> builders/12/builds/38/steps/19/logs/stdio)
> running mchan test run to Windows.  Ideas?

On 1/25/26 12:36, Steve French wrote:
> Any thoughts on the failures with current for-next (to WIndows, fast
> VM, with multichannel) for tests generic/533 and generic/565
> 
> +++ /data/xfstests-dev/results//smb3mcmfs/generic/565.out.bad
> 2026-01-24 22:13:17.098765412 -0600
> @@ -1,4 +1,6 @@
> QA output created by 565
> +mkdir: cannot create directory '/mnt/test/test-565': Input/output error
> +/mnt/scratch/copy: Input/output error cmp: /mnt/test/test-565/file:
> No such file or directory
> md5sums after xdev copy:
> -81615449a98aaaad8dc179b3bec87f38 TEST_DIR/test-565/file
> -81615449a98aaaad8dc179b3bec87f38 SCRATCH_MNT/copy
> +md5sum: /mnt/test/test-565/file: No such file or directory
> 
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/12/builds/46/steps/138/logs/stdio
> 
> and
> 
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/12/builds/46/steps/136/logs/stdio
> 
> and also git/0003
> 
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/12/builds/46/steps/160/logs/stdio
> 
> Does this fail for you as well?

