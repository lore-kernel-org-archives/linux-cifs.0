Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07242F8BF5
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 02:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763000832; cv=none; b=TsC4/iFb3sxHgFPMDD9YlxY/o1CsbcDQImH3ZIy23w4qrVmap4KWofG3/SkpjiTH3eabTJGASd1q4VJNJs/wjlgyaMSiR6uveSylMU9y9E9kvKi97tbdUI0pSpblRCGc98BK7RiI8ANq9q3OiEy13ulikQXNVHFlmgducgt/Yo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763000832; c=relaxed/simple;
	bh=6xdVQlMATcTTZKwxaLThy8BA1nkPY8YAST+SPi+vITc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLSLhyhyeYAHA1ffAGcwjdAe3A0YW694ypc8K4IoQWbifOe3jKoIFqjQMWk+YCSNUNS0YVeuZi8BGdbL/P22/AL1tq5KMKwNJKHHjzXXQSMaorj3qMiA6z79VNrKcYXprbxF22r9yAKEv8/BjjjVc8+K2OvM1pteHKId4HgoO74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b=WEE/wCUs; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b="WEE/wCUs"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-794e300e20dso997919b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 18:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chenxiaosong-com.20230601.gappssmtp.com; s=20230601; t=1763000830; x=1763605630; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jf/F/fNYoShIn8vd4fwO07k1j66rpPF7kQ4OChB2ivM=;
        b=WEE/wCUsBvvZkLLgkbnPFGf3cqwuZZ31vD2PBWiWbO7ychbFrQwXPxwUGgAx17S1e8
         Yf/C4N/j5DBDZHBs0q7Luh+j2zqJihwJpxxr7Wc3CfAPQQ5nTQRrOve3/az0moW601fn
         TcZpp/P53UsxyQfwv8vaAhOoC4i3t0dy/bzVk1chteE/wZYtY2XMuO8QSUgHpE0RMhSe
         FM5Bb5GvyL+bXChNSIMktrUL7Q57bwIPRwRZh2gipXJ7hT9v8ARHHZ+oCD/00wYR8cpP
         YXl7SzGw2EXlcjPUqOuWbp2hTIwxfF5awGH/M2mxAVfb16+l2T6WNy7tmEO++VrA+YVc
         Vk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763000830; x=1763605630;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jf/F/fNYoShIn8vd4fwO07k1j66rpPF7kQ4OChB2ivM=;
        b=utDcgft/vgtyIEYxYVLhZUoMscJ6lNstR7y7J6AH7Pn6QpKdq8Uvd3IuZ9F0AK5zws
         kqGsPAhKBUAqWlsWr0j7/dcPnrXuaF2tUGkZveN72nLzbfzkCjv1n5LPOTZqpkwhfw/Q
         xX3Z3yk5Hb/+1JVQQTg93e7/aby2TNFzO0yCFkiNPkebrxJSh2Ya434J+9y6qAqiMpps
         EWnfRipxLgUZiUhUqKV6tICASsCfEzchoVy7ssSLaj/hsMJdwLAThREn3Z9wFTxvgoBR
         JP3jeTyeBlA6qX0A/f20t/GtWSPj+H2GgwkhRgeY1+Hx1qYjgpRWsQ9EzwSu5wvxMF92
         uu+A==
X-Forwarded-Encrypted: i=1; AJvYcCW+ukFA3qsMKCaoIG3iALAhk88TarfdYibu04mexKu5Sj92PkhktumCZZmuMyIKhAG1wm9fissxIx1O@vger.kernel.org
X-Gm-Message-State: AOJu0YygberAro1XMK5xtXBG4HFUHJhkEhOp3uW+C3jKp+Z7W3zjhXM5
	oImUgEQ5w1kBzNZGwX+tRer/oPUqMuN44CiBEF8+Que4jGvXlTkRBpLMY33+wrxofJ0l
X-Gm-Gg: ASbGnctDdO7eVpYd9lARYPKrpCrgWfk4ZnyLiHgzFYplwj4cIBWkcEgP1HMQNYfrdNS
	DwQ6fWADoCt1+QPmhn2/SKiN1AWF/+rsykn+K8CBVKAF+xBmbXJX70e4cZGkbUjenxBMq+HfDKY
	PxcUUkzQ5ih29LJ9xRBb9pgGVGjhb0ikBx0mmnVfrLzGw5sYI1Zikhcp3XN+k89XxFsPmQW+dL9
	JYRmL1rbTuBhJfk2cScfdfNyKE4X16ukvwODRMiyev0J6uMKBZ3lCVy4WgtK5p3ZIMKynlVnQa5
	i06Pcf45gUYpogr1+mUSucpeXAbjZJ1Ie6quWO/l4chs6nalmTp5Gfnp9HWRefeetzLMhxZttVJ
	Cx4DQJ8QPc3a6W90UmZnwHGU+cDZNWTdjP5V6f+eeXBeKTuUZrohqvZ6qs1ppwtw8XqQ3Fw6lji
	YAYjBb81UG2mMFTsJ4RKz6ZE+6YPnkAw==
X-Google-Smtp-Source: AGHT+IER4+TDctqnE2sQobAK+QCd98kGQkHJSgna3I4yn2VMzIgKov4QjnbIvtN4bm0KnEchSzFESw==
X-Received: by 2002:a17:902:f707:b0:294:fc77:f041 with SMTP id d9443c01a7336-2985a520871mr18729795ad.25.1763000829793;
        Wed, 12 Nov 2025 18:27:09 -0800 (PST)
Received: from [192.168.3.223] ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2346acsm5852885ad.14.2025.11.12.18.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Nov 2025 18:27:08 -0800 (PST)
Message-ID: <e690301a-d0ee-466a-82f5-70634859be1f@chenxiaosong.com>
Date: Thu, 13 Nov 2025 10:26:59 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/14] smb/server: remove create_durable_reconn_req
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
 smfrench@gmail.com, linkinjeon@samba.org, christophe.jaillet@wanadoo.fr,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251102073059.3681026-7-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd8o3CKcaArMzEifR+oaX2G_g3XuEjFkBtPhyO99pKQO+g@mail.gmail.com>
 <fd9d8a05-32e8-4f83-8e40-a6497dde1ed5@chenxiaosong.com>
 <CAKYAXd-niyc2df5BvZYBzo-fOX3WcTjhgtxh5aQyHrVwL4ONsQ@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-niyc2df5BvZYBzo-fOX3WcTjhgtxh5aQyHrVwL4ONsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Namjae,

Please do not apply patch 0007 yet.

The struct smb_hdr seems to be used only by SMB1, while SMB2 and SMB3 
use smb2_hdr.

Should we move smb_hdr to a new common/smb1pdu.h?

Thanks,
ChenXiaoSong.

On 11/13/25 10:12 AM, Namjae Jeon wrote:
> On Thu, Nov 13, 2025 at 10:46 AM ChenXiaoSong
> <chenxiaosong@chenxiaosong.com> wrote:
>>
>> Okay, I'll make the changes.
>>
>> Once you've applied some of the patches from this version, I'll
>> immediately send the next version.
> I have applied all patches except 0006, 0012 patches to #ksmbd-for-next-next.
> Thanks!
>>
>> Thanks,
>> ChenXiaoSong.
>>
>> On 11/13/25 9:19 AM, Namjae Jeon wrote:
>>> On Sun, Nov 2, 2025 at 4:32 PM <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>>>
>>>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>>>
>>>> The fields in struct create_durable_reconn_req and struct create_durable
>>>> are exactly the same.
>>>>
>>>> The documentation references are:
>>>>
>>>>     - SMB2_CREATE_DURABLE_HANDLE_REQUEST   in MS-SMB2 2.2.13.2.3
>>>>     - SMB2_CREATE_DURABLE_HANDLE_RECONNECT in MS-SMB2 2.2.13.2.4
>>>>     - SMB2_FILEID in MS-SMB2 2.2.14.1
>>>>
>>>> We can give these two structs a uniform name: create_durable.
>>> Please use typedef to define multiple aliases for a single struct.
>>> typedef struct {
>>>     ...
>>> } create_durable, create_durable_reconn_req;
>>>
>>> Thanks.
>>

