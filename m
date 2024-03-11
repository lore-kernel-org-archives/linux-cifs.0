Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531112BAEF
	for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 10:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710151306; cv=none; b=D1DOqrUl0gwF3oveTK2W2/6/N3vuxiITcQS9+uKthV744lPflpYmTQ2Rgl3S1/4A8H8w8bWOJWnqMHbLcMpOYwOjk8tTGSxOmYNSEPLVu323qVuM9aD01Myy3msR2CSABviBgjQXTlP9mdcshIK7I8H+uiw4F6dwPNR2QVZneIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710151306; c=relaxed/simple;
	bh=r2rXPUw54HfWn58dRAtMhA7HCkbCL/OOk+l+L26Y20Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ILJdb4Y/cm9EouHw4KxlCMMIaTRWtBA4oCnhwPE343lB7O+a9UpgnWS7FqsZnNce7FD8UHr+ckDucEvi1DFkdyfancgtcMsxoC5cM2fWNkdBqHauUt8ZRtpuZMwIAt8jxliKUV7QOazjVhglqeoj/1OlZviX8UV4psBzMUltbaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sairon.cz; spf=pass smtp.mailfrom=sairon.cz; dkim=pass (2048-bit key) header.d=sairon.cz header.i=@sairon.cz header.b=Y2TfAvqX; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sairon.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sairon.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sairon.cz header.i=@sairon.cz header.b="Y2TfAvqX"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5686677bda1so456125a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 03:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sairon.cz; s=google; t=1710151302; x=1710756102; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=whMblkZmCJDpH0V1jyCvCfAL5nO6Wd5z5nC6e/HZy30=;
        b=Y2TfAvqXiZUGMHUfaBQQE58uuPsnbR0C1R8OCUo7DRrdUXP1VQgS/DmLwIB7JFjCrf
         wN85xNNvYKj1ZI27AXWwJ/az8zhTsaGkzNQeDwg+qViPyDj5iAni+cQfXLJ60ing5BnR
         WluoKsDvLiEEQ6/JGyE0ZdvZp7yVZJsYm5DQCyPimjKLu1OkxGtycWTeiXMLyBurylQb
         BaUjzmYe0ZdBqZI2n4V98z3QW1KAV91doyue2U21OGv/WliegnKepr0xr0OnczU2v7YA
         6HHpdr8oA8xPNgBaaRiQrlbsXjwk/bSC1fie95CsmF8Yl+E98q0c7gkg3mxkBfn94krc
         0ZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710151302; x=1710756102;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=whMblkZmCJDpH0V1jyCvCfAL5nO6Wd5z5nC6e/HZy30=;
        b=wvMhGgvn0gJQ4oso8i2UPh2PXhMcNd7xJt0xHsfclUaWwHdm4ssKeX0KCHj6NJxX1r
         QnRoDcoQWYeywXjQ/7sPlXIi66xkDp5THdAImNZNpDJ3621HFbHcH9e9esx0h7bjKyC9
         DKK5y3opquTMTwgYEFEZYD86x3LoAErwEe/v42pNbiv33bOtnFh6nmGxB5ztUrJTVmLx
         LMDeb1ByyFmyf1wSII9p2hNjNuf4BDYBegwtW7rN2Qpqp8V0cAW251+j+YsXoVvsccgJ
         i09tnft8Z4rqB5m9Xq2xSJPVE1NQM8nT4YschuyFqHvpOH92IycyRve90yH2UZi3IfWV
         w+CQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2h8i9cMXbiUTKVjK4b7xt5kbqLqowBQfVICNsNtHbUIykJX68o2D+kIuenvX6iXJwcgnFa5O7Ui7AUYAZ3uw+eR/MJU4QP3rLYw==
X-Gm-Message-State: AOJu0YwWDaeKPovmJp9qUz2xaCyqoWrYG6BSY25ywE3Y35/1CHjlmi7m
	BTPX3ZCas4qxjTLRK7VQJ2sxlmknrnYjAWn6tSOFN/h5ClrGa1wh3Krqnt/jrpw=
X-Google-Smtp-Source: AGHT+IEqE36vku5+NQGvAgHTbo6old44rvG3/1kgsUf98QPdnqQQR5sad9d2WvPS87v/HPoNwgxEEw==
X-Received: by 2002:a17:907:a801:b0:a45:f257:5439 with SMTP id vo1-20020a170907a80100b00a45f2575439mr6511993ejc.3.1710151302501;
        Mon, 11 Mar 2024 03:01:42 -0700 (PDT)
Received: from [192.168.127.42] (ip-89-103-66-201.bb.vodafone.cz. [89.103.66.201])
        by smtp.gmail.com with ESMTPSA id l17-20020a17090612d100b00a3efa4e033asm2691990ejb.151.2024.03.11.03.01.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 03:01:42 -0700 (PDT)
Message-ID: <3fc78929-2b5e-4961-b5da-6914f2dc45e1@sairon.cz>
Date: Mon, 11 Mar 2024 11:01:41 +0100
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
To: Paulo Alcantara <pc@manguebit.com>,
 Shyam Prasad N <nspmangalore@gmail.com>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, tom@talpey.com,
 linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
 Stefan Agner <stefan@agner.ch>
References: <20230310153211.10982-1-sprasad@microsoft.com>
 <20230310153211.10982-8-sprasad@microsoft.com>
 <4b04b2c4-b3ff-48e7-9c24-04b1f124e7fa@sairon.cz>
 <CANT5p=p4+7uiWFBa6KBsqB1z1xW2fQwYD8gbnZviCA8crFqeQw@mail.gmail.com>
 <2abdfcf3-49e7-42fe-a985-4ce3a3562d73@sairon.cz>
 <CANT5p=oFg28z7vTgyHBOMvOeMU=-cgQQdiZOw22j4RHO94C3UA@mail.gmail.com>
 <f395be9305cbe75c3171a84e45db42fe@manguebit.com>
From: =?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
In-Reply-To: <f395be9305cbe75c3171a84e45db42fe@manguebit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Paulo, Shyam,

On 06. 03. 24 16:43, Paulo Alcantara wrote:
> 
> Yes.  I see a couple of issues here:
> 
> (1) cifs_chan_update_iface() seems to be called over reconnect for all
> dialect versions and servers that do not support
> FSCTL_QUERY_NETWORK_INTERFACE_INFO, so @ses->iface_count will be zero in
> some cases and then VFS message will start being flooded on dmesg.
> 
> (2) __cifs_reconnect() is queueing smb2_reconnect_server() even for SMB1
> mounts, so smb2_reconnect() ends up being called and then call
> SMB3_request_interfaces() because SMB2_GLOBAL_CAP_MULTI_CHANNEL is mixed
> with CAP_LARGE_FILES.

thanks for looking into this! Is there anything else you'll need from me 
or to test by the users who are observing the issue, or do you have 
enough information for a fix?

Regards,
Jan
