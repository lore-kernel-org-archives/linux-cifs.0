Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC582D63FF
	for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 20:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758226887; cv=none; b=hDaQeL5hcEnesLQEe2JsE3LT9j7Q2vLlivs72ybzrGe6zSzbqdSTegKqO8O+sSRjqpsm3NA0JhOf3S6rYziTO/Oucs6eRPJaJtIjwWYfdVGkShHnmWGwMeOU+Y9Vl4PzNHtT3lmJ0zk6R0ueDKJjxnL0ZVhWkBuG7er17TN+/Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758226887; c=relaxed/simple;
	bh=MP8C0iTz4yKygDUs4UJlnUXzMLU5hF2/WQgY9WsPl5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eC7utVaJLJU381uHQ5HXLRC/XywkfEycYyJ9xX/9wdv0gl+z4Uhx5rKeDOQ9ng+1Xut6znwsIVYDIaNQ5JE3gF2TmwWO490Jel8R3jQ++w0/c5yaQ6K3m56Ltgcgne7+YE4G+woGC+VgeXWH4AS0d/6vHfi8qmjDCB2yqCKfQwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RAgzpcBf; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RAgzpcBf"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3d118d8fa91so569099f8f.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 Sep 2025 13:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758226883; x=1758831683; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c+XBJe0nR2DwgmBczZWNw1vj72xY1vky2YUDeduqHWM=;
        b=RAgzpcBf8ynRGa1vWfVmDh95iK7TeRAzoVjL5lkOAoOYdmiLLxjAkQtg9JSkoXYMVE
         vvAqdbpxvGfcSC04eWBn2xsTLEi+fkYb7KhoFQXxOl2MUsIkvF81lwcyVbuTpazacwUs
         aVxvB573j0ZgGMqaJV8o6QLu+OsDJPdA3jr03mWwvYZuMtiMOHNHznb2yk/Ei3jedHdm
         RkpmrLVVEHihKCBZ6dG/5E646mbNoDhDEBe21npgCpG6lbNJyhoYufK3EZyuF1pgutt+
         BdxKUdrNp2T7CqGXFqeHcEvz7aSeLuCt/3IESgwpZaiFCkFlaCrszONBZW80xFLzbrmQ
         edMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758226883; x=1758831683;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c+XBJe0nR2DwgmBczZWNw1vj72xY1vky2YUDeduqHWM=;
        b=XW59TFsNGxQTcppnp3dwAvWPlxGHipkDeiPw93WqjN0IvSiGusE9Mo5ZpkBNw4DaPw
         R/Yxw13QG+aXYco0TbQkiBWGTVHT2e5yDDmVENNe9y4VIb/kd/iQTWeuS+kQUIj23Aqa
         cXe3YqwfZxul6djKVNhdimgrpalAsM9N2Wxq5lFunLRBSlN6AYjNqhg7RmavUGEY8NO9
         DYCy3zyJEews270LVmyOugRhFoNi7/RGSlgfPVXRm1/VICRA+Qv9qpAPhVMTE0/ahxtK
         dzVNnJqkiAcHEK0p05vPFzHgnShxDU+xC3lCMurrU0HQA1WWkmuHpoTyhZp4jTgQLczg
         2JFA==
X-Gm-Message-State: AOJu0YzTfC9dYMM0sP6USdBtRVxVITiY/GbEj4nRgNnlW8UDTaNz7LQB
	LX7tsDzPPEefALOC7n7fmpwAfrNPSEjkkXviHWDCZxuKywVdVQWWJhVk+uOywSB2vSEMq14VIuD
	86S4w
X-Gm-Gg: ASbGncs3QED77DNxCgmhXfZ7l1enk68rr2dAO/KBfy65u5BaUq8FACfe9bG0oNjeg0r
	b6qjlT17+3vwbfHmRmXDNhNCUY9/JJuG1etC+X0hezg+ZkKz+tJcKrNPrg0iHeXMoaQcNuxtErx
	JTuZolbuPkBJcfU8EEGaO+QpvO58Vn97R4keWOzdlapG0OAxkTgYIdTIPy8LvesA6UwRwR2+4V/
	WuGclwRCJA6uQBhsO4lGJ8RtdNCMDdrqY2N5+pvDl0kVaKM011vrxzjmYfHrmcoMj8rtw83Qaaz
	at2mlBS6rhUjDXfyZYHNkrO9BmbCtjWToCWuVakWpWTIO+kFT7YcnPWJrWqhp/XuqGtDAjSP1N4
	qf+XpuOg8um54//c/IJhrhPS9l9NzstOQ6o0RwYi99FpxxEbOLAORMA1Vi90lSVcbB9M+9Ks=
X-Google-Smtp-Source: AGHT+IG6cRMm6NU2n32aKnMZFK1T+KGetx2BVqovjESfqmYqiqmalYE+1SoVaqw0mTuK+mcrWoZFRw==
X-Received: by 2002:a05:6000:1886:b0:3eb:a462:13d8 with SMTP id ffacd0b85a97d-3ede1b733f4mr4297028f8f.17.1758226883351;
        Thu, 18 Sep 2025 13:21:23 -0700 (PDT)
Received: from ?IPV6:2804:14c:658f:8614::1cfe? ([2804:14c:658f:8614::1cfe])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269803184d3sm33259275ad.116.2025.09.18.13.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 13:21:22 -0700 (PDT)
Message-ID: <d06bcf7d-81bb-495c-92e4-582c44df9de8@suse.com>
Date: Thu, 18 Sep 2025 17:19:14 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] smb: client: batch SRV_COPYCHUNK entries to cut
 roundtrips
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-cifs@vger.kernel.org
References: <aMvUdFU-ciu7Rgc6@stanley.mountain>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <aMvUdFU-ciu7Rgc6@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Dan,

Thanks for the report.

On 9/18/25 6:44 AM, Dan Carpenter wrote:
> Hello Henrique Carvalho,
>
> Commit 4e3acdf94c89 ("smb: client: batch SRV_COPYCHUNK entries to cut
> roundtrips") from Sep 16, 2025 (linux-next), leads to the following
> Smatch static checker warning:
>
> 	fs/smb/client/smb2ops.c:1937 smb2_copychunk_range()
> 	error: uninitialized symbol 'ret_data_len'.
>
> --> 1937                 if (ret_data_len != sizeof(struct copychunk_ioctl_rsp)) {
>                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Using unintialized variables doesn't work because runtime checkers like
> UBSan will complain as well as static checkers.

I will update the patch to initialize ret_data_len.

> But the other issue is that this code treats -EINVAL as having a special
> meaning.  -EINVAL is the most common error code.  All the places which
> treat -EINVAL as having a special meaning end up buggy in the end.  Mostly
> they start out buggy, but even the ones which aren't buggy from the start
> end up buggy over time.

-EINVAL is mapped from the SMB2 server returned error
STATUS_INVALID_PARAMETER, so I don't know if there is anything that can
be done here.

After your email, I considered returning -EOPNOTSUPP instead to trigger
kernel-side copy fallback, but returning -EINVAL also seems to have the
practical advantage of having a successful copy, but with fewer network
roundtrips (apparently due to userspace fallback, but I haven't digged
too much into it).

If there's consensus that changing this error mapping would improve the
overall robustness of the code path, I'm open to that approach.

-- 
Henrique
SUSE Labs
