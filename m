Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351E619AD8B
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 05:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772082597; cv=none; b=Ut1O31sE4bhD+yVCf/HMUeN+nGSzjcwxlfaPyer5mb7teVVjvGpDyCqL5avTWnQrXRITXuOewC2a+3sC5V1r2Mx0hiJ+OoG2Peteg61OKRRoyMQuQTd+rOnTD93jfWlMq4/ws7Aq1xaewCSWAqZ+ThjmORQqOhSDYuwJQUZyaAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772082597; c=relaxed/simple;
	bh=JSeV06WpX+js8iO//6fj9wiOthkWSK6/OAI9GBVmtTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TfohvHkVqgSRIcCmh9tbTp8UorkctWL7+q7ngJ0WpAiR26vS6q5FGS5U64J0Wf3BrkRxiN2jtBHvi31j+buCXRMNyJJU7ijOV2Z35vP/8itlwyq3Fg7h0C1whfG9qb5lEFMF7QSi1yv0ymSOaIXvpBWtCXreOhdBUJIFVWv1/YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nabn7gJE; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nabn7gJE"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-81df6a302b1so587824b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 21:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772082595; x=1772687395; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Kn75Wv8qiro7iKe75/bRb2w4zFjtpLF7Xhz58wwjTks=;
        b=nabn7gJEd8MSrS/qvr82y7ebtkttWms2XV2PfmflsLc6Wg7VKI8vcCGd3X+CCbjUwe
         5M/p7mClkuIaHLEo0EsQa5qLK/+UGVAti4b1dL1Vh2jnZQ9mRRNkM/fcGkcxBhdJA/TA
         Cfe3KMWbewhxS4dIfbOYP3dDqmg3tuV3Acm6t+OrJatSEwaB9OCSRjFJIFVMT78qNHcz
         L+Hn7l/PRcJaglJgFea0gMsG+/e8O52CzPErQzxp72OKSUuPXT1ovksCOZOquTMh03l8
         Zs+nt/3j08AYiQ2X44bFsqcjcLLgPz8Ve9j2kldyVdkad1XzUMy5q/XBwNEjKiIDufxM
         3QdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772082595; x=1772687395;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kn75Wv8qiro7iKe75/bRb2w4zFjtpLF7Xhz58wwjTks=;
        b=sEoZwgvWLvkyenDaF7VJIGO1ZW0anD91uiMrKeN3v5hKbUpVD9uNidwPNAQBXcVXU+
         vFlaXNlJQXEvH7VAjxxLV0RF9D6uID+gr0SWv/ZKUOIt6rkNoCVFp9Klm5bcw1PuQ2iM
         cDeVuNjnsAufBUrKr5tLE1E/4U1mo9CiLVj6eoGR3X9NaRQjxr3wIfkTYOXJSHp+epoV
         rO6HA7UhhixMjGTmIV1Ga+uSmGVBs8bbiLLDG/hEjK/c5bkzhmUYqys8aG9KC1R/bNlE
         bgaFRz3GvcFLKHPqDeKQayoLrj2UUlUN1pmk/5oKpK8snobzCX4lw3NVS5/4+dvjVaT5
         41jQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0WTuZXsOyHtGyEIjDR02z/gkeUNZ2OE+E3vCEGUegDsIw40dWHgzdUGLNXvRPNQFcHeZxWre/OiYl@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4gme2TFaHFe7zVOoSVT1jsYniu9fq/KcXCy91vW3lyt2An/5c
	b4X9mH9VF+igC1n8kwJhyK+fqYP8plBTVXjnJiCsc/AMafBXStN3B+YW
X-Gm-Gg: ATEYQzyBJP0sZV5eA2btR9qoY1xFAuoOZAoa2/kCVijPv34oBB53fsvpdW6AIh/ytEr
	WXQAzB8+xtjgpcFWSY2Iii0PJvrvRbfTPQeXDSpvRTJQbebD7tpOuxoaq6cePaDomPJNio+GJix
	ypvhzawBHpZMYDMuZeiitsZlOoCYtoxi33EMdRoYlpMh+tfBF03mHb/UFEc+j6UVijEji5ZRiz+
	LEyVu0o6vyh7hBGOw+xv2+BpgQDRcydeyTRzKtRSKDbPyOERLNgEyhOVx9rjUHJeaR/ESxjQNL/
	tk23eyWMrq7D3CBnBpT1Z3pRWq90XfX7UTn402ycxLct6DOa7fRTrXaHBtfs8vNwdoFzLWQwBLu
	xxsCQ7AOSDqtoD0Lh9HpJiT2hb8ImyGoXaT+8RkKSSNSkbXikWBHhqLFOMhxfDigbKoq3f3MnBP
	kFMGXBm/PQhSBm9+q654vmlJjeyK5XhOYhXcvGD0EK53nox+a8nK2DET5eyXYJOUN0PAl+1RTvp
	Z/EDx8Rkyg=
X-Received: by 2002:a05:6a21:7a43:b0:394:40a7:f3b3 with SMTP id adf61e73a8af0-395ad1c21fcmr2961455637.40.1772082595445;
        Wed, 25 Feb 2026 21:09:55 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa84e602sm609089a12.32.2026.02.25.21.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 21:09:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <59d5c1a6-7a7f-464a-aa62-e53daff8870d@roeck-us.net>
Date: Wed, 25 Feb 2026 21:09:53 -0800
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
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <d3d93c04-fdd1-4b96-90f2-293a2d45f647@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 2/25/26 20:12, ChenXiaoSong wrote:
> Hi Guenter,
> 
> Thank you for taking the time to look into this issue.
> 
> I reviewed the relevant code in more detail and did not find any leak.
> 
> Both `ksmbd_put_durable_fd()` and `ksmbd_fd_put()` will eventually call `__ksmbd_remove_fd()` (remove fd from file table).
> 

Sorry for bothering you again. Are you sure ?

ksmbd_put_durable_fd() calls __ksmbd_close_fd() with NULL first parameter.
__ksmbd_close_fd() only calls __ksmbd_remove_fd() if ft (the first parameter)
is not NULL.

ksmbd_fd_put() does call __ksmbd_remove_fd() with first parameter, but ...

> If my understanding is incorrect, please let me know.
> 
> Thanks,
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> 
> 在 2026/2/26 00:49, Guenter Roeck 写道:
>> Running an experimental AI agent on this patch produced the following
>> feedback:
>>
>> This isn't a bug introduced by your patch, but it looks like there is still a
>> resource leak here. If ksmbd_override_fsids() fails, we jump to err_out2.
>> At that point, fp is NULL because it hasn't been assigned dh_info.fp yet,
>> so ksmbd_fd_put(work, fp) will not be called. However, dh_info.fp was

the AI is trying to make the point that ksmbd_fd_put() will not be called
because fp == NULL.

Thanks,
Guenter

>> already inserted into the session file table by ksmbd_reopen_durable_fd(),
>> so it will leak in the session file table until the session is closed.
>> Should fp = dh_info.fp; be moved before the ksmbd_override_fsids() check?
>>
>> PTAL and let me know if it has a point or if it is missing something.
> 

