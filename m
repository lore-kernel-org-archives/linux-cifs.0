Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F60B2AD00
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 14:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786458325; cv=none; b=I6rOQno9JFNrvBxvlHoQLIer6l0+knCJQyCUty9LXQHy57SsU9lyhmRZ021j7B3vfr53hejfHlSxzHfPxB3H0zrDQQEC35tZk0LtYVVlajYF6UPYLq8+KhgjbYyl7v7QlnGnmmgBPNUDyupWwdPRVkIJlROQgDYr09MQZ3uYrU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786458325; c=relaxed/simple;
	bh=vjUgIOzxtLUEqRGd12Zao0T1Qj0iZfGeHnedhIqz3MU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HF7/6aT2f2NmcDuREY4QC6sznZusyrBCaS291x+K6eWafyMsXgSobWSFrBDU2mpv7dPdqJO5RmrNrTHJ7XCIAFkxR4sgamDcKp2dowr7bXNCH/B61jKX8OxjigaM5F2SACEXNhQyqJvYC0YQVFMHBHXbb8Xg5KI1qJ9+6VWOM/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UFRNbaJV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JvqK7W/l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UFRNbaJV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JvqK7W/l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786458323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mk55lgP+KqMZ/4ByZFmMGZVtOJZLa760GMLOIBHMErM=;
	b=UFRNbaJVMlCJoJxLlRTXxb5iX3+j4DSXs93AyJSilRQp2CtDzD8vE2Re/nXlIor3o8Ldpl
	L0z9JpZzlBQwzPX+ghFZ4v/MKAlToAfpdork1TOjBF+TPpjzDk90KmXl+lpvk6iUtErwHR
	9AYqZyCLXQpgvqrJ21RcZUItXgsA5RE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-x-8SXbMnP8CywdnkoTqoQA-1; Tue, 11 Aug 2026 10:25:22 -0400
X-MC-Unique: x-8SXbMnP8CywdnkoTqoQA-1
X-Mimecast-MFC-AGG-ID: x-8SXbMnP8CywdnkoTqoQA_1786458321
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-496b6f97676so29782695e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 07:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786458321; x=1787063121; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mk55lgP+KqMZ/4ByZFmMGZVtOJZLa760GMLOIBHMErM=;
        b=JvqK7W/l/6SUx6l9RmDCSeI9hgU4jVBF6NAa40J3NGhNvIV8hJGPmzey+T39mClvZa
         ihMa40ZjqfmMPwlFanQmjmbbvXxTVbrHNGm3aqMplNHMedR30MY2aIVWr+vIAwe8c/a0
         KuIbKv3MQ+9mSRHHBSeq0sL+QG9ZKJosaycbHPZ3eTEU0LmBSwDy+StUHSz7tyQ7ZSIv
         9JvUUCgh1N0WuoQPc7b1k1tCKZ3ltfOFNOuTgdgof96cvyJLj1gMCEkFn/vp1D1bhJvJ
         JnPwgMCqmj0qKlK1zzexCq9KjY17pNthui6ePf29sKuUhs1H3Wj5pA9zWs/gu2mFDqie
         Esnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786458321; x=1787063121;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mk55lgP+KqMZ/4ByZFmMGZVtOJZLa760GMLOIBHMErM=;
        b=h6not2N9eJxyea3o1h0iaOx3IBqSfkQI0NZojpKlC2Rb4ln6pSj17jR0nProF7ytmn
         +j0F8vLwQDbYY7ORY4SV1KSbvqblbrbrINJI7K8ldEUN/FkASmh+RVj6Ec09avUFhMLY
         /32iLrMTWK4uL5z42OxQK8ilz1Ai0XVlTpPPPR72yDuDob8cgoqN/8p10uYhQW87iNjC
         5Ax2Uof7RhYchp29873CGQOYDf8iqBpcJR0dMhwyg+UHCWJlE/bkdbOgsuLHqZo7vzu3
         Kqfgf4IvcwEVFb1ilo8rFyuYVqRNJbWmB2/bGfnExAO5yyUHSVCp6OQFDKtUoV3OVGue
         96pQ==
X-Gm-Message-State: AOJu0YxD7jN2NDhKxbPOnxuXfQzTQLNpdI4x1iLtmsjRX1GtsDT2mMJG
	LkTmKN+YpQ92+ZQXVbLKqtpWpsb8B1Kf23j42XC4xudE1uJrhIglV52a4RVel+x1UeTaVw5txd+
	nSwZnFJJ/IDmGcqq/e7+BW0tnaSBMDnjn2NBxwh5O02BbQ9/WkuaX0AMUmEbkwjc=
X-Gm-Gg: AR+sD13mBouwX2vgylR4nlXoYBl4gD9j8vf5J6BlZpYVhF/LX4NA9HQc39DAkeCJVXs
	79+fyeY+kOISZWnc82kS5DdC+szkG1hX5PzTVQ6sD2BAnCG70gqYsvB1LYEr+NY9+eVsINwZHlJ
	UzaQ2uhZ1Mw6/a7/uedMAbJi4d0eNsGqvvrlmCrjPS/AVJcs4Qjs7HV2P0wCq2Dsh95z1j6N1FI
	CkIzKtiuXIdACuu+/beQ5msmdj50HIeKCLSMIVbE2gKY860+kW9iHchZbSTXCXGWNtlsXYLoDDB
	MNV4qptqosCfV9crGuEiT9zI66YlNHGjGgiLU42WMqcS0jWd22r0bQ8Dvf5fAZOd2tGPps9Z
X-Received: by 2002:a05:600c:3b26:b0:495:4749:16a7 with SMTP id 5b1f17b1804b1-49978463aa0mr57108175e9.14.1786458320658;
        Tue, 11 Aug 2026 07:25:20 -0700 (PDT)
X-Received: by 2002:a05:600c:3b26:b0:495:4749:16a7 with SMTP id 5b1f17b1804b1-49978463aa0mr57107045e9.14.1786458320084;
        Tue, 11 Aug 2026 07:25:20 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.24])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997889c3adsm37937915e9.2.2026.08.11.07.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 07:25:19 -0700 (PDT)
Message-ID: <72e016b0-d7bd-41f7-b17e-dbcd911c5a80@redhat.com>
Date: Tue, 11 Aug 2026 16:25:16 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] smb/server: fix memory leak in ksmbd_login_user()
To: ZhangGuoDong <zhang.guodong@linux.dev>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org
Cc: linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>, stable@vger.kernel.org
References: <20260731024253.148107-1-zhang.guodong@linux.dev>
 <20260731024253.148107-3-zhang.guodong@linux.dev>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260731024253.148107-3-zhang.guodong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/07/2026 04.42, ZhangGuoDong wrote:
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
> 
> ksmbd_ipc_login_request_ext() returns an independently allocated
> response. ksmbd_alloc_user() copies the supplementary group IDs from
> the response, but ksmbd_login_user() does not release it.
> 
> Free the extended response after ksmbd_alloc_user() has finished with
> it.
> 
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>   fs/smb/server/mgmt/user_config.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
> index cf45841d9d1b..21b1d51d918b 100644
> --- a/fs/smb/server/mgmt/user_config.c
> +++ b/fs/smb/server/mgmt/user_config.c
> @@ -27,6 +27,7 @@ struct ksmbd_user *ksmbd_login_user(const char *account)
>   
>   	user = ksmbd_alloc_user(resp, resp_ext);
>   out:
> +	kvfree(resp_ext);
>   	kvfree(resp);
>   	return user;
>   }

Fixes: a77e0e02af1c2 ("ksmbd: add support for supplementary groups")
Cc: stable@vger.kernel.org
Reviewed-by: Thomas Huth <thuth@redhat.com>

