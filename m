Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FA931E840
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 06:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782197621; cv=none; b=K45Cgm/pG9FzYE/NbptyQS4OpcsiCC/AeqmPz7X/dUXVPd5yYs2SShsC85vWg/lVULKMrpECZdHdPjaJ77dXZcJYNu4KilSyWeCO0w7KjZx4yhQdZHsSoxQ1t4x9E0MkoudbUC7oDgSVO8yE0V/Ac8zv/ac1F8wWGTymeQY98Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782197621; c=relaxed/simple;
	bh=rU/c29jp+vqqVPzvsunB7fcbj0ATixMC6635eOsT37U=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=mHszMC0GOwRusgmwJAyuPiHGF5MmLpEXbz/UtImYpaJVe3sjpcYYX4xAAwaMvEUtN/VAo7rbZmi8YJZ79QrL62I1HKlLqKmVcIbyh8eSYF7ZE1EWH33SyGcXfrEfzuqJiJkjwB7vBwieLCy1Nwdg9zt8hPQ6t2+Jro0TNYNitDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=RLeC5Bko; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="RLeC5Bko"
Message-ID: <4747ff73-f57c-4c8f-9038-ee00c7561817@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782197614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zi8wAKC5YO/3ER+2AqenuVBwvc1+UPTiGcAf0LmKeuw=;
	b=RLeC5Bko+N0cqE38wyZF0L1WyOtLNxi5xsvE8UCaku/qMTXFM2CQLIhnPMdP6sNtD7k8cl
	8T6VvxxbUAWdDtwxa3Uf1Y+6CLgMr2bnZy1paeBXrCBgtUj1pNHsetqBMgoeOciORWWFE9
	nwWklhXO6j4Xrt1IRPmRo9UEow+EOC+yqHK7Fn7hIwIE3qikDFgQVtz3uGzfF05RJfmOf1
	zCzrRFErwjqhKPV0G+PJ6wnyE9LUoas1HrJCYKcJYdtXcnKRQ7wSPBXUUGek9BdKJ60GKo
	P+8hzBxLsmyQ6b2tBQH7JmYuX7aIQbIGayjDuAD9KOZ29Dj+c9Idg3/1B91TVw==
Date: Tue, 23 Jun 2026 14:53:09 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH] ksmbd: validate num_subauth when copying ACE in
 set_ntacl_dacl
To: Namjae Jeon <linkinjeon@kernel.org>, Haofeng Li <920484857@qq.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, Haofeng Li <13266079573@163.com>,
 Haofeng Li <lihaofeng@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <tencent_160379D932900C07E87A916577DA03F73609@qq.com>
 <CAKYAXd9nesneEmhr8pm_=4CtvyC8q7Ac+H7uhtk5R8QPf_VLbg@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd9nesneEmhr8pm_=4CtvyC8q7Ac+H7uhtk5R8QPf_VLbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

Thanks for your review.

If we use `continue`, the next iteration may get an invalid `aces_size` 
and the previous `ntace`.

```
for (...) {
	if (offsetof(struct smb_ace, access_req) > aces_size)
		break;
	if (nt_ace_size > aces_size)
		break;
	if (ntace->sid.num_subauth == 0 || ntace->sid.num_subauth > 
SID_MAX_SUB_AUTHORITIES)
		continue;
	aces_size -= nt_ace_size;
	ntace = (char *)ntace + nt_ace_size;
}
```

On 6/23/26 13:03, Namjae Jeon wrote:
> Instead of using break, would it be better to use continue? Using
> continue would allow us to skip only the invalid ACE while still
> returning the rest of the valid entries.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

