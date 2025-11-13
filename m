Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFB7296BB7
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 01:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762998388; cv=none; b=RGTGO9RknSZIDtP9VptBisu9uixxDKIrHpaGnHUKdxN0bFHtZvcbqx/hQWLg7mLsrtBWtBt06hbeVO6oIRYAqH69N72gXNBNq1UXEeMW9Gz19hfNzz3CjfFoOd+1i2YZ3R8U+blvnQkHAXTljTHuN75hyBiO/3mRN7yfb2+hcqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762998388; c=relaxed/simple;
	bh=UobmHQ+i1qGEF8C/zTJsB2ABG1daqbuFPHpfOfzkP9M=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=kJn/52T3Qnq++1vmxL7ze9CjAHlfQlxMr/FlYxmeB85f/PgOWtHepnZsWn5GVHn4puqJRp+12f5J8ux/vZQMgUSfIffK7mcyTUt857t2DRL1Y2rToWYnyfkgvwvH29gY75zmZ6V8ciEj+JqScpjgUgvRNS3Hv7/TtMf+GakAPxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b=AxDy0t6N; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b="AxDy0t6N"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b994baabfcfso182817a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 17:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chenxiaosong-com.20230601.gappssmtp.com; s=20230601; t=1762998385; x=1763603185; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d2VhFVfZP0yG3njrNawDEH+d1ecXNNX+BfE+gXR0ZA8=;
        b=AxDy0t6NOCT1OU/vXnCNZ2OhkWkIz6wC/k/LXQDGHbk+Ge+Y3mr1gcDHCBNijmVkHo
         Jp6hTvS0SlQ6hqwEhlDWHABjQWO1XbbD8TD3ThdpIrqw2Lh8qSkat2FeIAGS7a4RS7lZ
         BYwZBagRINnHXhEf1D9IZ7158n+4Xgcf5lji/AUSYfFzldcM6hP3hPLIeRFP+/9AoHzz
         0ena8OEM905YgF66TKZYemL7TXTdMe9HH1M2WiZ1xezjXgqexaDzj6zMc2yS/Y/Ezc5Y
         PoDkxtsUJxuoYuDe545O/JVJv5GZ2y4qPCK3oUho9gudTVSug7bF1fLtQUbsXlS6Cdw/
         CjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998385; x=1763603185;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d2VhFVfZP0yG3njrNawDEH+d1ecXNNX+BfE+gXR0ZA8=;
        b=O49NsV4NXhSbBEGQ/yANfsMfFoFYwfD9xn/E7X2uptRi66IYIuIVzgXgIxqaAV2n0P
         otv1sj7TkboXYDOE/z/zjN7aaj/DoowjsXkt2HIjxmFgkSfFADjQ4p1ZhZlRiq7sx1cK
         187Yz5yTtXzjtYRa2QzqOVzHA+vTXnWK7kHGLARBOf+kzm7VmP87BPBkbwCiQv2EbuVQ
         AXOxLToIOt57FHYxMC9MH0eGVzb/+gJ2xqyjUAW8SD6Gwt6S4paPHBy3f8DJ/yeg7fCS
         MRUxsuAqhg0rFqIcnjBxezQaMTdpTL6DnnvTf67GEBtdLuliTHvLbHBcDaWTapJ5NaOm
         WBOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUPvZFDpWWjUT409vWPqrRrig7vaBLRSzTksM06zthCGF9u6Svy6ZJg4fejqlFGM1Ya1MIDVlzSXqS@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4Dqx/qCqfhb0nYGRDv7tl9Fe1HS7CTG1I+TUaE4MeGV1SvS99
	VUJ5RCDGrf5JXU5TcznDlfJN/RIupaDIg6+fzh76NFx/tFFeOai5iMwG2Avd2hcCPmuL
X-Gm-Gg: ASbGncuB3OchHJKc+KDQcuCf2iZEir+9ks7U4A4vgfdwtPsJZw1g59z6n430H1R+mHG
	Uux1tA8RBcoLVF1VqqZSkHB2wQHt6mxiuH9xynbAXTv5GLJviH0hfHzfng0I3/SmTprTJL3iVhB
	esYzl+LsMJkqW/RQmCaREoSZiXFQZo3x8D05jccW22oKj6FJbk8N+kMgZYyPwUTR0wW/PApDnjI
	GVvF4el+3b1/S6RJI63psMwuSPdLaQNVBIIYbHLSaRRtLfpInB7GEyT26Lc40nO0gzziDfCoY8i
	Tjh7s7FUJVwWVoSuOtCqUlBNbQdXbz+rVAQE2aW51Bw7Cad2ay5YP8C14xN0TYvlBo3c3e7hIjl
	isM6f/aveWU84cEqzHMCnZ9lFxCHronen1DPrH19judzLbCgLKUJckxXmcO/8xhVsX5v9fWaVJA
	Xtsh6OZLfoxp3iUyCR0NSx5pAI8+RFUQ==
X-Google-Smtp-Source: AGHT+IHbymVR8GjScDftVTUuU4zA27Nl0y0MLi1qfG+GLQ7TTdKzfbxLqfu7VKUHAbpg/EzQzWRjMA==
X-Received: by 2002:a17:903:2ac3:b0:298:33c9:eda1 with SMTP id d9443c01a7336-2984edddbbamr60750745ad.43.1762998384819;
        Wed, 12 Nov 2025 17:46:24 -0800 (PST)
Received: from [192.168.3.223] ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c245f8asm5156085ad.37.2025.11.12.17.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Nov 2025 17:46:24 -0800 (PST)
Message-ID: <fd9d8a05-32e8-4f83-8e40-a6497dde1ed5@chenxiaosong.com>
Date: Thu, 13 Nov 2025 09:46:12 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH v5 06/14] smb/server: remove create_durable_reconn_req
To: Namjae Jeon <linkinjeon@kernel.org>, chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251102073059.3681026-7-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd8o3CKcaArMzEifR+oaX2G_g3XuEjFkBtPhyO99pKQO+g@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd8o3CKcaArMzEifR+oaX2G_g3XuEjFkBtPhyO99pKQO+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Okay, I'll make the changes.

Once you've applied some of the patches from this version, I'll 
immediately send the next version.

Thanks,
ChenXiaoSong.

On 11/13/25 9:19 AM, Namjae Jeon wrote:
> On Sun, Nov 2, 2025 at 4:32 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> The fields in struct create_durable_reconn_req and struct create_durable
>> are exactly the same.
>>
>> The documentation references are:
>>
>>    - SMB2_CREATE_DURABLE_HANDLE_REQUEST   in MS-SMB2 2.2.13.2.3
>>    - SMB2_CREATE_DURABLE_HANDLE_RECONNECT in MS-SMB2 2.2.13.2.4
>>    - SMB2_FILEID in MS-SMB2 2.2.14.1
>>
>> We can give these two structs a uniform name: create_durable.
> Please use typedef to define multiple aliases for a single struct.
> typedef struct {
>    ...
> } create_durable, create_durable_reconn_req;
> 
> Thanks.

