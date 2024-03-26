Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846A8768EA
	for <linux-cifs@vger.kernel.org>; Tue, 26 Mar 2024 14:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711462232; cv=none; b=hbC1gE4b+hGAKgT4Q8rMijzTfo1v8kgHQ8noJibLuDN3wCvbf/XcaEqap3rVFm1ZwOOUmskTlQOgZgGztoSirW1uMAKEPlSRfZV9iEH7rQtB4nEjtDNl+1fHMEVq1/IJz906iUQAYIAmDNb7bJ5HiYUumMaK08Piy0XMDFswAo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711462232; c=relaxed/simple;
	bh=/V4utUfY+NI7EQok+8NaVgtpej2BnL7mNENjrsoEFuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RzO6s/7AeCsaWduS+arE64JOrak+mUq4uXSEuNv3uL4ho/Ir8spL7UexyG1eFieoVkZexnpOvreOI9lvbeawaGmX5UmeRCNB/j8fquUVAkc9fZIFDWh5TtaIzFucYoKTlBxm/TTG6pGlqMNcrvEbx351H3BrSJcU2On8lGoQ8zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sairon.cz; spf=pass smtp.mailfrom=sairon.cz; dkim=pass (2048-bit key) header.d=sairon.cz header.i=@sairon.cz header.b=WWoaw9Dj; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sairon.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sairon.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sairon.cz header.i=@sairon.cz header.b="WWoaw9Dj"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a468004667aso755823966b.2
        for <linux-cifs@vger.kernel.org>; Tue, 26 Mar 2024 07:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sairon.cz; s=google; t=1711462229; x=1712067029; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9TVXeiwO4sVmEGQuqwIQaeQGevE+TRDryz9KAzXCtv8=;
        b=WWoaw9Dj0pqsfhKHIpK9VYvLfzD+GcyzMLssTF0Tyy9lUhEJMfxa3QoxshwRqtHle0
         qrmaDAbqNs73nClJZg8Ko/k0AiiSKovIFmuB+9iP63aUFldpqd9AD0lKRvGbh5RYx4ku
         4ZHrCUv5lrKCNwuk1j69RXo6UHUbfwF1tZeM8clpR406LQKFZl+N1zJyjEZTPpSsh9Gs
         s/YsDlv9XiMJ9mtlgq3nPpuhAGfIAWajPspUTlrMddAgGdmfYN8Tjt3BOIg6Iqsv8RRe
         GtdnIQklCf7QKEOAr85uW4EsIwJYt+Z3hFq6f+8IWi8UzuTIWGmXhFPI6XFXpOtWwjjv
         85Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711462229; x=1712067029;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9TVXeiwO4sVmEGQuqwIQaeQGevE+TRDryz9KAzXCtv8=;
        b=WuDvY3hcP4MXMMvpCWmf4pDLm8G2Mqvd+2PM/TZG3rsd6mbGEKQ1ZQWxrAJrcNt5As
         eGgMoR6oGKdQa+vvaocv+3VYe/mSBnwFiL89/8/4IlVVS2DpMxry38SzrTUIQ+9PcKvB
         Hg+KV9LCquDtqO3ic5xWnrHXAohnqOuZzFFAdOIlHkYPc3DDUHtxmT0ZOJOxhie5EF75
         3y6YRUYsYh00xoXW+pXGcDoQC+YG3usB+olYhrpmc4g7Bvje5tJSW0em9XJtwrgISacp
         K6SVuP311bd7l7LaB7OiPOyYpj42B2+K0Dom7IrsbTj3Fb+parKwVgvuYqUJC2ftm/Xo
         EWRw==
X-Forwarded-Encrypted: i=1; AJvYcCUYlZhBxQD9mWpBErtz9aRTY+DTDZ97NwVaakv04eo/aUKxxIeD3Pp8eVbCoNRgA9AdEYKN0E121DFxq3kDdHDEVVeec6wOWah2OQ==
X-Gm-Message-State: AOJu0YzPiILbm8LbpxzGB8iv0g5ml4n5edBxqYT4R2NqJ5yOjDZZKc+Y
	Ced74gGmeC8fR86m7DdVZHVbH62qRM3I9kY60vpDbklga1kAtNCSYk6MY1eRX/g=
X-Google-Smtp-Source: AGHT+IEBGDMi+UQLRTuJnYdj39QEJRPmu0aLos+IbGG/9YHts5EvHM50BvxlRt9brvSacH5z0Caltg==
X-Received: by 2002:a17:906:2849:b0:a47:4b39:ba1c with SMTP id s9-20020a170906284900b00a474b39ba1cmr912912ejc.39.1711462228374;
        Tue, 26 Mar 2024 07:10:28 -0700 (PDT)
Received: from [192.168.127.42] (ip-89-103-66-201.bb.vodafone.cz. [89.103.66.201])
        by smtp.gmail.com with ESMTPSA id d9-20020a1709063ec900b00a4737dbff13sm4262140ejj.3.2024.03.26.07.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Mar 2024 07:10:27 -0700 (PDT)
Message-ID: <03e1ce67-d524-409c-82b0-10ef455bdb8a@sairon.cz>
Date: Tue, 26 Mar 2024 15:10:26 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] cifs: distribute channels across interfaces based
 on speed
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com,
 bharathsm.hsk@gmail.com, tom@talpey.com, linux-cifs@vger.kernel.org,
 Shyam Prasad N <sprasad@microsoft.com>, Stefan Agner <stefan@agner.ch>
References: <20230310153211.10982-1-sprasad@microsoft.com>
 <20230310153211.10982-8-sprasad@microsoft.com>
 <4b04b2c4-b3ff-48e7-9c24-04b1f124e7fa@sairon.cz>
 <CANT5p=p4+7uiWFBa6KBsqB1z1xW2fQwYD8gbnZviCA8crFqeQw@mail.gmail.com>
 <2abdfcf3-49e7-42fe-a985-4ce3a3562d73@sairon.cz>
 <CANT5p=oFg28z7vTgyHBOMvOeMU=-cgQQdiZOw22j4RHO94C3UA@mail.gmail.com>
 <f395be9305cbe75c3171a84e45db42fe@manguebit.com>
 <3fc78929-2b5e-4961-b5da-6914f2dc45e1@sairon.cz>
 <CANT5p=oX_d-aZMJLhECU47mqsxz+oeaqqZEzjjVv5pq2gxwtVA@mail.gmail.com>
 <669bc66f-74ce-4753-bbff-bfa497c8905c@sairon.cz>
 <CANT5p=oSYbhVsupD5r0uDU3Miq7gnL15RoB-i2cwBmkap9Hj+w@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
In-Reply-To: <CANT5p=oSYbhVsupD5r0uDU3Miq7gnL15RoB-i2cwBmkap9Hj+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13. 03. 24 11:45, Shyam Prasad N wrote:
> Just sent two patches for this.
> One patch is just to change the log level for this log from VFS -> FYI.
> The other one is for the suggestions made by Paulo.
> #1 will fix this anyway. I'm curious to know if #2 alone would fix this problem.
> Also, please ask for the output of the following command while testing this out:
> # cat /proc/fs/cifs/DebugData

One of the users tried testing on the same system with only the second 
patch applied and reports the issue still persists :( He supplied the 
DebugData output only as a screenshot [1], not sure what to look there 
for, but definitely the "Server interfaces" section is missing there 
compared to my setup.

Cheers,
Jan

[1] 
https://github.com/home-assistant/operating-system/issues/3201#issuecomment-2019357433
