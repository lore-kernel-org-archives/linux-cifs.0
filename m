Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3033ED2FF
	for <linux-cifs@vger.kernel.org>; Sat,  5 Jul 2025 01:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751680676; cv=none; b=r4bj3M2oHZyXeNH+IPxEv06UZKlfjUtR99umAk4MPpQt2nzvFSB2YHizg+gFkldQydlwoTucXioomZ0CiL7Coh0xpzg+kSjrFcoJ4ORmNjpwnnk583Iz8/SyrkK4BDtr1ZBHXIpMbNQ+uSfT8vuLYMrZt74yHgT3LzrnWWCxaCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751680676; c=relaxed/simple;
	bh=8RDmwmoG4p0Pr3ImSMFui3FC+/Gkqf/QN1uW3QF3i/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N+kJ/scJO97gr6I3/qhNEunYtzpaDkxz56M9usjcBfEFUaHPXE7r2+sw+CtvwKyF3qlJuB3tgwhWIzLfjumka62Yje1czpDmEbrQbgYmddR1M25JjLXn2xc6QtNkKKVtF2a88HlSLOcw5OPbmbHqQOXMlXBNH3/dSNm6T4Akrnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bYttn274pzYQtGV
	for <linux-cifs@vger.kernel.org>; Sat,  5 Jul 2025 09:57:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 295BB1A1679
	for <linux-cifs@vger.kernel.org>; Sat,  5 Jul 2025 09:57:52 +0800 (CST)
Received: from [10.174.178.209] (unknown [10.174.178.209])
	by APP3 (Coremail) with SMTP id _Ch0CgCHNSOchmhon3K_Ag--.15251S3;
	Sat, 05 Jul 2025 09:57:50 +0800 (CST)
Message-ID: <8b784a13-87b0-4131-9ff9-7a8993538749@huaweicloud.com>
Date: Sat, 5 Jul 2025 09:57:48 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] smb: client: fix UAF in async decryption
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, henrique.carvalho@suse.com
References: <20240926174616.229666-1-ematsumiya@suse.de>
 <20240926174616.229666-2-ematsumiya@suse.de>
 <da3525d3-5b99-4d90-820c-c5cef3d68613@huaweicloud.com>
 <tq4kn3v4yfkglc2fivh2nhe2vjdt254uyquoog2tgjo5qlwze5@umefb3bo5iy3>
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
In-Reply-To: <tq4kn3v4yfkglc2fivh2nhe2vjdt254uyquoog2tgjo5qlwze5@umefb3bo5iy3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgCHNSOchmhon3K_Ag--.15251S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCF13try8urW8ZrWfCFyUWrg_yoW5urWkpF
	WFkrW2qa1kJF129FyxX3yfWw1F93s3JF43Kr4kGw1F9wn8Wrn7WrW2kFyYqFyUCFnrJ3Z8
	Xws2yr15u3WUAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

Hi Enzo,

Thank you for your detailed response. I appreciate your explanation, but I
believe there may be a misunderstanding about how the crypto API's mask
parameter works.


> Even though cifs called crypto_wait_req() with crypto_req_done()
> callback, we never allocated AEAD TFM with CRYPTO_ALG_ASYNC, so this has
> been always effectivelly a synchronous op.
> 
> To fix this correctly, it'd need to be done on the HW crypto driver
> itself -- not in crypto API, not in cifs.
> 
> If you want to circumvent this particular issue on cifs side, you'd need
> to implement the whole mechanism to hold the unencrypted request until
> your callback is called, while taking into consideration reconnects,
> which can get quite tricky for writes especially (this is not fun,
> believe me, I tried).

I've examined the kernel crypto API implementation in crypto/api.c,
specifically the `__crypto_alg_lookup()` function:

~~~c
// crypto/api.c
static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
					      u32 mask)
{
	struct crypto_alg *q, *alg = NULL;
	int best = -2;

	list_for_each_entry(q, &crypto_alg_list, cra_list) {
		int exact, fuzzy;

		if (crypto_is_moribund(q))
			continue;

		if ((q->cra_flags ^ type) & mask)
			continue;

		exact = !strcmp(q->cra_driver_name, name);
		fuzzy = !strcmp(q->cra_name, name);
		if (!exact && !(fuzzy && q->cra_priority > best))
			continue;

		if (unlikely(!crypto_mod_get(q)))
			continue;

		best = q->cra_priority;
		if (alg)
			crypto_mod_put(alg);
		alg = q;

		if (exact)
			break;
	}

	return alg;
}
~~~
If the mask is 0, it does not distinguish between synchronous
and asynchronous. It only looks up the encryption module based
on the encryption algorithm name.

https://docs.kernel.org/crypto/architecture.html#cipher-allocation-type-and-masks

The kernel crypto architecture documentation states:

> When the caller provides a mask and type specification, the
> caller limits the search the kernel crypto API can perform for
>  a suitable cipher implementation

The documentation does not state that if mask=0, the returned cipher
is always synchronous. Instead, the documentation implies:

- API supports both synchronous and asynchronous operations
- The mask flag is used to limit the search, not to guarantee a
   specific type of return

Many hardware crypto drivers:

- Register with high priority for performance
- May implement asynchronous operations for efficiency
- Get selected by the priority-based mechanism even with mask=0

The original code's use of crypto_wait_req() was defensive programming - it
handled both sync and async cases correctly.


> Restoring the crypto_wait_req/callback code should fix the particular
> crash you get, but the calling thread would still block, completely
> invalidating any async benefit that you might be otherwise expecting.
While I understand your concern about "losing async benefits," the primary
goal should be kernel stability. The current patch introduces a use-after-free
vulnerability when async implementations are selected.

I suggest we restore the async handling as a short-term fix.This ensures
correctness regardless of the underlying implementation, while maintaining
the fix (separate TFM allocation for offloaded operations).

Best regards,
Wang Zhaolong


