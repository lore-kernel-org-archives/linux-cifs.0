Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DF07B3E5
	for <linux-cifs@vger.kernel.org>; Tue, 12 Mar 2024 14:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710253213; cv=none; b=RgMYM5fvR27F5D/EGv6RE9Jvbl/KTXe8wb1DXhfPfCcGqmV7u6Rpd6awr6SG3RXQfO4sq4eoYxP1f/HHG8NpK0cPwqJpJgjd3znNPbAhasCSjVPcALNvdF9o8zMHraIavkELiMC5VY4SUH1CNS9ZtsMBc/vte3Qjdyrl62fm444=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710253213; c=relaxed/simple;
	bh=I2vdJb4jFZNxoa2aPiUR3za1YQTO5Jo5LJLqC/M6gIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LHn1Y9/oi9SE/W5ZAifFBAo8VHafqmPF8I3CYEAyrcf9sVFaK1hs97Y+JFKZCAd6x6xXcOworq/N+fB4kTmNITWR5ADmbL5G5AcV59mlV8u1zpwL87TGlEZ4da0hj5228yxzDBk34hZvv0V0pLybW/2R4Csg/4iIWs58IZ2/frg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sairon.cz; spf=pass smtp.mailfrom=sairon.cz; dkim=pass (2048-bit key) header.d=sairon.cz header.i=@sairon.cz header.b=Drim+oxd; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sairon.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sairon.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sairon.cz header.i=@sairon.cz header.b="Drim+oxd"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-51320ca689aso4784966e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 12 Mar 2024 07:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sairon.cz; s=google; t=1710253208; x=1710858008; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8RrBJ5AiOd0sW548cotSYts6j9AY6kUjiAe676AhN5U=;
        b=Drim+oxd7cCD7TW17e0z4hz1XvZwchT++74wHpQMqQ10tZRbZjga0s9qGNXNHpmniu
         vEM6BnvQfNEiK1R3azKtm01WyGqbWc/Y5SqKDv1OlTKGqY32gHMjf/+D+igRuSkaq09x
         CHPwhBJzv2SYwd1mSNwqvmjoxv0A71bEvppoZZbRe37lOwM8aF1HcLl1r/0Qc49WB+bH
         srskitY724LWTzvc2EB/reqqM7R0z06P32GMwFoJmZ042I/nq3dhl7SSMDP4R84QKhX9
         zulEqQnsZFudkLZKQdAve99sklOvlTKMoVEcNlt1r7G+HXu/BPJvaUaVAlgQgxFcp0Q4
         Sx0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710253208; x=1710858008;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8RrBJ5AiOd0sW548cotSYts6j9AY6kUjiAe676AhN5U=;
        b=BLQFMBtyTstQtfj/dDPCKs4V7Xhww9TLrVCGG84NMuKvlf23nSQlZ465cZqxnz/Lzz
         YEPRQ4SXAhtb92tmL9uOiY/4MTEhRwOhqa1LWUxvtA+9mmT72sCm7+hOCZliSYjHpSK4
         snTj44UpK/YNA0ikcqUqYF+7MQgpmPewf8Gv1qV4KYOts8Xtc79Rss5xm3o8mIElPlWT
         rlUi88j7iuHIzjPYr6IvMbqmDlwSD0upHc2ZaqUQDuWyGzAf/fPMT+cXCS7y9Zb5qtUA
         TDGewSsdbZUEVeFQFgNmsAkDx5FbEtdKZT1abEYsPqfasVlcEi9A5MLfCDnsZ3/Y3nat
         L1Sg==
X-Forwarded-Encrypted: i=1; AJvYcCVeYtCXmlr+4jbUm24HM3RBbjXokfAo+9B29sNaCy4TyUshpTdyWHxSScwWqrKl4qzUXBr6YWf5MtXvIRO02tlbtmPijhxtV6ZYBw==
X-Gm-Message-State: AOJu0YyDOdvUyEgIzxTm0SMawY5tJpUlpzmAHyF52HG0IlyNYHSEEWhq
	JQmR/mbJucdqsZQi9YfQgILjifWxI6ai3QbGnM795Bgd3TnFpms1ui/75+U8ieY=
X-Google-Smtp-Source: AGHT+IHCQtUaRBe884mF1sOcL2zBM1VZ4Cc6lNvyYpCpQvcggWtY+S29Co9vleRMMgcdjGJkVbInmg==
X-Received: by 2002:a19:e04e:0:b0:513:45b6:18b2 with SMTP id g14-20020a19e04e000000b0051345b618b2mr6282312lfj.44.1710253208447;
        Tue, 12 Mar 2024 07:20:08 -0700 (PDT)
Received: from [192.168.127.42] (ip-89-103-66-201.bb.vodafone.cz. [89.103.66.201])
        by smtp.gmail.com with ESMTPSA id h19-20020a170906591300b00a449756f727sm3954126ejq.147.2024.03.12.07.20.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Mar 2024 07:20:07 -0700 (PDT)
Message-ID: <669bc66f-74ce-4753-bbff-bfa497c8905c@sairon.cz>
Date: Tue, 12 Mar 2024 15:20:07 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] cifs: distribute channels across interfaces based
 on speed
Content-Language: en-US
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
From: =?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
In-Reply-To: <CANT5p=oX_d-aZMJLhECU47mqsxz+oeaqqZEzjjVv5pq2gxwtVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11. 03. 24 12:14, Shyam Prasad N wrote:
> Let me submit a patch to check the exact dialect before calling these
> functions to make sure we only do it for SMB3+.
> 

FWIW, most of the reports (except the first one with macOS) are users 
running their SMB server on QNAP NAS's (more details are in the GH 
ticket I linked earlier).

Please CC me in the e-mail with the patch as well, I can create a build 
with that patch applied to 6.6.y and ask if someone could try if it 
resolves the issue in their environment.

Cheers,
Jan
