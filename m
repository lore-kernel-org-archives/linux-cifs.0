Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AAB1A6803
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 02:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784168906; cv=none; b=JLSqdQsjBMumQ3frUEoh0q/bGXjaUoeZC9Qn7U6YLnwcodwUwfe7R98P6x2VQ72Ol1DXapbg+ks4t1t3Q5q+O44nIioLrV5eBxTNd4Dx8M/+MogKLB+LjB9t6G73SN3gNfCJruu3T0A5/2RTYkf8xE4xP9DfsVp9RfV//avFBBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784168906; c=relaxed/simple;
	bh=Cb0wpb5T0HfYdNhT0siIsagvwjr+BfBMf9V820wCFTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W8LX7ujQM5XcB34Fi5N8adZsRqUFHaOzVxjKJVw2LiwPEvsJrAWG7PX8F06uyZjunooG6RXmnKE3Flw0AzZ5+i1QYljTSh0ZqBT6+uwd05poKtGqpnO1JiOEilUOEzsf4zo5Ev2WMF3q5LhNsVFb2bqO3ASVyAv/98HcrYgSF0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=RH3tQJhB; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="RH3tQJhB"
Message-ID: <e1587c2a-63da-42a0-8393-ff48ab095267@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784168898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GPLY5eAan92muSRnCX2juzZJjKlZF3jh9+RX9EjtAZY=;
	b=RH3tQJhBeotxhnTrEfxKCMgJZqgQKh3CpkuUZu+ZngwsV90Y5sJ8mQwE+q99Bh57VFc17M
	FM+zCvUAd4tnVULCtja/jJknY51rvBKy4P0EOTG2nFhROXqc1BPThKgHtO5TeU1H58+pty
	rVvEkwjFx1JWYso+2jdPBzIktKDsLsj6Kk9ey/c9t0VBEPGBM/kqPW8170n1sV7/rVvNBY
	nt4nQ7AP/vtvMam2PTsEFHc1vR8WHC0np04kqUTBDn/mh37h44kZb9UQtUfhX6WvF7SeFj
	OOWQ903Ro7BrHROS5I8gA2FMl9RwdkCZapByy/xWdm3hjwKk1gTrZTLx0+x+TA==
Date: Thu, 16 Jul 2026 10:27:21 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/3] smb/server: cancel async requests when closing
 connection
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 gael.blivet@gmail.com, andriy.shevchenko@linux.intel.com,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
 <20260716001156.671587-3-chenxiaosong@chenxiaosong.com>
 <CAKYAXd80TEVZB2GYeYCfhhyN99HyD89ZP_9NjON6caoXuMWTDg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd80TEVZB2GYeYCfhhyN99HyD89ZP_9NjON6caoXuMWTDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Ok, list_for_each_entry_safe() would indeed be safer. I will use 
list_for_each_entry_safe() in the next version.

On 7/16/26 10:13, Namjae Jeon wrote:
>> +       list_for_each_entry(work, &conn->async_requests, async_request_entry) {
> smb2_notify_cancel_fn() calls list_del_init() on async_request_entry.
> With list_for_each_entry(), the loop increment then follows the
> self-linked entry again, causing an infinite loop while holding
> request_lock ? So, should we use list_for_each_entry_safe() ?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

