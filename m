Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B79936166D
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 04:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772167372; cv=none; b=uXLi7cp/tmo0Nfl50ibc8akzYpc3wk8I/4XHkIuCtDfEWccgLtk4Tnh5K9JjHewpdmsQoE7PS7ckrWFGm33aJLeHbOEY4UsxD4gnyuvP+74NjI76olth4Ogwz0mkZNn+p2zORud3oHPJlNi+Aq4dY+UndMs+ByCOD2UwvrBATtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772167372; c=relaxed/simple;
	bh=DJiJhdUtbSkGTAbijz0MvNX5qB5ZsgC4GvIYoVL7e9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bVvY8D6t7ZUiUtUuVnTepr2MVR8R/t7Bj7CGyDW64nz7bKujnIzmUDBB0zez1GOIHOgvag4XpqluQYKeZkewqeWmI5Gk+XCFUaF3o62F/dsLmEQzzD63DFI5YJa3Vff+bXLt0h11U5g/wtcwgP6WbExjGXTX2HwDbjcmr7SR/U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mHTaQN0f; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mHTaQN0f"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so520527a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 20:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772167370; x=1772772170; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Ils05Y31fBejIloChLLQzc2Oej0sMCpBDr0L/y0wFNU=;
        b=mHTaQN0fLnQf4lljx8WdE9cjqsKnvegdr+5h2TarV3ODIoL/DRuZzA7ysYDUaR4vku
         CKXrEVXtiY5fKn2hK6Sms+o3RVL9H8vQJH+1b+4wDZ0Mx+41TAC7NaVf4hD8ZflWbVMd
         5r6yyHFb1YwIvQCIC+Ud6TEggodf3OtnuaRnYBd1IwAtjonoNT5Ub5wQ7wssrg6jWKpT
         Bbfp50CgXvOxyAbsJGU+R27YyhT3G5iOmD+E5q9bA/q4eBmxSDXy2zHclmaIlC52nNqm
         QI8e8GDLBfaFH6WtqUE1J9nVL5bFvSzR6Q6+FAdipz17I32teBb1EVp1nURtxyuJsYCq
         TIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772167370; x=1772772170;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ils05Y31fBejIloChLLQzc2Oej0sMCpBDr0L/y0wFNU=;
        b=v6Tk32n7APqQzWBojyV+xNbniPPsdTKA2BpfjuAsKyN+8M6qfzm3SBx53NW00AoFvE
         kQPLFXOM8YzVc6UAFZ7nZwRmMdfOZ98Bor01W1m7vnxQPffVCQWx1Wk+n5A1QSYOVbJ4
         5T0dPhs0YcNYhJSN+vKYWRXGNP8B0+9fLqMGKxuHrnUpKUyscb3aSzYTkPSCu0FnrDWC
         l9jzz1m3NK4IbRNU1AQF581dqdG4AFXolr2FYsFIWqoshLIJfR7WFeN9KxnYTRwGFf/h
         XM2AZRQFjzaS+2a78PJ22jAwl1mIcypu7AWNgz+XiqaqTqOJiEfHhRNRUsvxEvm5ouUT
         f/ng==
X-Forwarded-Encrypted: i=1; AJvYcCWAR2kMVqQ/AnKEDV5+YlD5tfn8BaQ79HCtcLkXhmnnpYDuMjXIuVDFAh42jPYoeSGblO2chs9KTj5i@vger.kernel.org
X-Gm-Message-State: AOJu0YwP09ow7c72oOlx04BcUtuyQzX1E4mb7YoyPpDyYiTeH1//OHVC
	PMTenYcV4uho8iS8galrHiar+VBe61gt3V9uFkhwnjV5A+dPRXXb3Tlk
X-Gm-Gg: ATEYQzwJr/lE4CSt4nhA9IiTU662fE++DiDxfGcNjp/nC8OIKIdXSHOd4yAdRPB/Dje
	HtXTT8VU2X+DQqbcwSr/MYLMCr6mM4DiSQ62Vkf2pE/wR786qez+xHXA+ziPtCTBdfHB1bJlHln
	Xn94+NEtykAIDpb2A+q7iT1eHWVM1yhYkMhf1tV/1aWqXfJLrrEi6ZIynGKdCXk0i+LJ7nkG7Rx
	JeyV+E9HjEseY16ttuGvgJmbRdOcnvMJ/SI3l8VOy7RpILeIxJ0LyJIGDP3vAeOo2PPfNanFC3y
	yyDCgHoSsSRdMofV1naQOzvfOANz94r4IyXc5qO1j7hICRbpHebe8QCsmzCsFVszBOhjcUVYAw5
	rbZdqMvuz31ZM0STF9RWAgUFo/0bVG6DHMmqwiy8Ze3gdqXpfg3dsc666EhZK/OeZZfF6GlC9KN
	/33eQEQoftzktHjFiWHg0gNmstWXu0KzryWP+XXmpqnKtroDEWqFkYHliKomc0oqcgcZv0Cbot
X-Received: by 2002:a17:902:fc50:b0:2a9:450b:104 with SMTP id d9443c01a7336-2ae2e415bb4mr14160465ad.55.1772167370396;
        Thu, 26 Feb 2026 20:42:50 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b148bsm51396945ad.10.2026.02.26.20.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 20:42:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <a99db1ba-2b96-44ba-b4b2-11754f6c6aab@roeck-us.net>
Date: Thu, 26 Feb 2026 20:42:48 -0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] smb/server: fix refcount leak in smb2_open()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
 <97979f06-7dd2-46bd-9bdd-3a9c45fc5b1d@roeck-us.net>
 <d3d93c04-fdd1-4b96-90f2-293a2d45f647@chenxiaosong.com>
 <59d5c1a6-7a7f-464a-aa62-e53daff8870d@roeck-us.net>
 <f3604a74-3caa-4737-bfc0-d93feb988176@chenxiaosong.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAmgrMyQFCSbODQkACgkQyx8mb86fmYGcWRAA
 oRwrk7V8fULqnGGpBIjp7pvR187Yzx+lhMGUHuM5H56TFEqeVwCMLWB2x1YRolYbY4MEFlQg
 VUFcfeW0OknSr1s6wtrtQm0gdkolM8OcCL9ptTHOg1mmXa4YpW8QJiL0AVtbpE9BroeWGl9v
 2TGILPm9mVp+GmMQgkNeCS7Jonq5f5pDUGumAMguWzMFEg+Imt9wr2YA7aGen7KPSqJeQPpj
 onPKhu7O/KJKkuC50ylxizHzmGx+IUSmOZxN950pZUFvVZH9CwhAAl+NYUtcF5ry/uSYG2U7
 DCvpzqOryJRemKN63qt1bjF6cltsXwxjKOw6CvdjJYA3n6xCWLuJ6yk6CAy1Ukh545NhgBAs
 rGGVkl6TUBi0ixL3EF3RWLa9IMDcHN32r7OBhw6vbul8HqyTFZWY2ksTvlTl+qG3zV6AJuzT
 WdXmbcKN+TdhO5XlxVlbZoCm7ViBj1+PvIFQZCnLAhqSd/DJlhaq8fFXx1dCUPgQDcD+wo65
 qulV/NijfU8bzFfEPgYP/3LP+BSAyFs33y/mdP8kbMxSCjnLEhimQMrSSo/To1Gxp5C97fw5
 3m1CaMILGKCmfI1B8iA8zd8ib7t1Rg0qCwcAnvsM36SkrID32GfFbv873bNskJCHAISK3Xkz
 qo7IYZmjk/IJGbsiGzxUhvicwkgKE9r7a1rOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAmgrMyQFCSbODQkACgkQyx8mb86fmYHlgg/9
 H5JeDmB4jsreE9Bn621wZk7NMzxy9STxiVKSh8Mq4pb+IDu1RU2iLyetCY1TiJlcxnE362kj
 njrfAdqyPteHM+LU59NtEbGwrfcXdQoh4XdMuPA5ADetPLma3YiRa3VsVkLwpnR7ilgwQw6u
 dycEaOxQ7LUXCs0JaGVVP25Z2hMkHBwx6BlW6EZLNgzGI2rswSZ7SKcsBd1IRHVf0miwIFYy
 j/UEfAFNW+tbtKPNn3xZTLs3quQN7GdYLh+J0XxITpBZaFOpwEKV+VS36pSLnNl0T5wm0E/y
 scPJ0OVY7ly5Vm1nnoH4licaU5Y1nSkFR/j2douI5P7Cj687WuNMC6CcFd6j72kRfxklOqXw
 zvy+2NEcXyziiLXp84130yxAKXfluax9sZhhrhKT6VrD45S6N3HxJpXQ/RY/EX35neH2/F7B
 RgSloce2+zWfpELyS1qRkCUTt1tlGV2p+y2BPfXzrHn2vxvbhEn1QpQ6t+85FKN8YEhJEygJ
 F0WaMvQMNrk9UAUziVcUkLU52NS9SXqpVg8vgrO0JKx97IXFPcNh0DWsSj/0Y8HO/RDkGXYn
 FDMj7fZSPKyPQPmEHg+W/KzxSSfdgWIHF2QaQ0b2q1wOSec4Rti52ohmNSY+KNIW/zODhugJ
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <f3604a74-3caa-4737-bfc0-d93feb988176@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/26/26 20:07, ChenXiaoSong wrote:
> Hi Guenter,
> 
> Sorry for the late reply. I had some family matters to take care of yesterday.
> 
> Please see the following process:
> 
> ```
> smb2_open
>    smb2_check_durable_oplock
>      opinfo_get(fp) // inc refcount
>    ksmbd_reopen_durable_fd
>      __open_id(&work->sess->file_table, fp,
>        idr_alloc_cyclic(ft->idr, fp, ...)
>        __open_id_set(fp, id, type); // insert into file table
>    ksmbd_override_fsids // fail
>    ksmbd_put_durable_fd
>      __ksmbd_close_fd
>        __ksmbd_remove_fd  // remove dh_info.fp from file table

Yes, but:

void ksmbd_put_durable_fd(struct ksmbd_file *fp)
{
         if (!atomic_dec_and_test(&fp->refcount))
                 return;

         __ksmbd_close_fd(NULL, fp);	// first parameter (ft) is NULL
}

and:

static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
{
...
	if (ft)	// again, ft is NULL, so __ksmbd_remove_fd() is not called.
                 __ksmbd_remove_fd(ft, fp);

>    // dh_info.fp has already been removed from the file table

I don't think so, but maybe I am missing something. I'll let this go.

Thanks, and sorry for the noise.

Guenter

>    ksmbd_fd_put(..., fp) // fp == NULL
> ```
> 
> Thanks,
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> 
> On 2026/2/26 13:09, Guenter Roeck wrote:
>> Hi,
>>
>> On 2/25/26 20:12, ChenXiaoSong wrote:
>>> Hi Guenter,
>>>
>>> Thank you for taking the time to look into this issue.
>>>
>>> I reviewed the relevant code in more detail and did not find any leak.
>>>
>>> Both `ksmbd_put_durable_fd()` and `ksmbd_fd_put()` will eventually call `__ksmbd_remove_fd()` (remove fd from file table).
>>>
>>
>> Sorry for bothering you again. Are you sure ?
>>
>> ksmbd_put_durable_fd() calls __ksmbd_close_fd() with NULL first parameter.
>> __ksmbd_close_fd() only calls __ksmbd_remove_fd() if ft (the first parameter)
>> is not NULL.
>>
>> ksmbd_fd_put() does call __ksmbd_remove_fd() with first parameter, but ...
>>
>>> If my understanding is incorrect, please let me know.
>>>
>>> Thanks,
>>> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
>>>
>>> 在 2026/2/26 00:49, Guenter Roeck 写道:
>>>> Running an experimental AI agent on this patch produced the following
>>>> feedback:
>>>>
>>>> This isn't a bug introduced by your patch, but it looks like there is still a
>>>> resource leak here. If ksmbd_override_fsids() fails, we jump to err_out2.
>>>> At that point, fp is NULL because it hasn't been assigned dh_info.fp yet,
>>>> so ksmbd_fd_put(work, fp) will not be called. However, dh_info.fp was
>>
>> the AI is trying to make the point that ksmbd_fd_put() will not be called
>> because fp == NULL.
>>
>> Thanks,
>> Guenter
>>
>>>> already inserted into the session file table by ksmbd_reopen_durable_fd(),
>>>> so it will leak in the session file table until the session is closed.
>>>> Should fp = dh_info.fp; be moved before the ksmbd_override_fsids() check?
>>>>
>>>> PTAL and let me know if it has a point or if it is missing something.
>>>

