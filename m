Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13D127F736
	for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 14:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758552216; cv=none; b=EpVr505ZdPc9p2AvJHYEpiUNPV/0XmwcREg2jDWOWZHnt8QFXIfHnKFuMCOkPQjmJoS/x0Y/HIyORXctFEMQK/9yax2X+J/z7EHgvHAJm2+Fyt3K/svrbhKadh2hV/XBGDTSUohsE4sDvXcpnS4lCAE1HJzwdh1aTgQ3w6ShWRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758552216; c=relaxed/simple;
	bh=+nr7BwNeXXEabqJuUJ4Znex193FXbxHrLOOQ7ddOBBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kXs5ME0KyxNuA0dVLCPkAQnBn+6cPYuC+bGZNZDAW+OFC9Oj19UfDlw6Q2lGVy7E2gahjaPZFcBw1mTlXKX97qVWES+0VNh9Ojnks0gibQP1pMw5WgtXzRnApC5712sfE2Ipfzfv5DKKpeMGGbqUoEFGVQB5OK5b2V3DddG665U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GP+ttq9V; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GP+ttq9V"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45dd513f4ecso33072265e9.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 07:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758552213; x=1759157013; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=69/QOJ2Y48NhDwYXM0mdWy8yyNCu9BEWxX9HIURiSOo=;
        b=GP+ttq9VqPVJvoDSCapWXV30/uNKjKCyJx0uasIJMbGyeZaf6q3bAFdlN0kTPooyhu
         mJhutkcAA4knAXlS0kJGSBwLj6lqR6NNOJ4JfD5EEtsBdnN0C2bu0sBdh7YsCdK/OKiX
         ZlTgf3Iy9AC99rvgAjDjPXBa/CqgyuDtk+cpFWiPrmOt7lTI5yDLZi4jPlj9IaUWleJv
         MiTkYBwpdn3waE9ziddc+9yEcr1eTyAQKwd1mfiBtYCu1Db+fueWXsxVxXX+hcjcTYBC
         4toA+cRmfiKJvRon0sqMyEyrkiIRmCld6232PDVjaezxxCi5UuZKVjl7uV5kxAuPW/PF
         nykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758552213; x=1759157013;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=69/QOJ2Y48NhDwYXM0mdWy8yyNCu9BEWxX9HIURiSOo=;
        b=urhMNP80jtDn8zftiKbh2+DrhLEfsF9dmn3ZsfMp93+BE3nh0vgiZDesIp5h/FM44O
         1UjcDyL6yVEVxFYRUf7f4ZLgDSZt0QXgcW0G5noFMhAryQwAfHn1PYmWZenzJhkNVlqZ
         4QpeaC2GDiLHNau4B5bt/lKwE711LiNCqA1dQCps+6nwlyo8ZOK/50uCbVxsaUN7DOHE
         VhGFhQPs/HoVDLa+KIcHGGimzjRjAbsNYVEgSyIBEK8SAFTBCv/me/2fUY3M/jSr7w3G
         7T7UAAP6ygqAxcwkznmzCfULKj5+HNeH8qYbvG+mWinFXr+IA3J4VzkCT7/cwavCeJxS
         d1KA==
X-Forwarded-Encrypted: i=1; AJvYcCWDQi8KDV596pULjzXZuNaaMmoeKF1sbAClm2Y+ls9WyDu+CtJHBZblcAMCeS2yFAJoV7HZz3T9pvuQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwU4fEt3fnDSG8vBOdbULVFTMiUqO8KeuoshNLkiH7yJ3j7lY4u
	uRdnekggej5ZRZ5EG7r3TQRMQiVS02YRQM24cJ+5dg6OejWclrhvY/Ygax3Gpkk2kik=
X-Gm-Gg: ASbGncsHP3qBy6Y9ANbYCv1wOQ/Vs5Uqx5MPLkXuinvR9dRx1SuJ0JA/MJL5yuFcgSg
	9gvC65FlqjOINmCjFSRJ81N8dCQ802NYxkxIvMzrz1td6Wa+R5EYVCet0HQV7pGWBKq9lZ0bVSH
	KvVnCetTzVTADgHHQHc5duWWa/2zG2e+GneqaEoVTEU/X5KiqGMzL0K5y0MFcS1s9pR0fzJ/pGm
	WP2pmlbaCnD0JI9mRZcn8Liw9B6X95cKV+vDoBjABHAtp74L4inpfbE8KkF5b4d1up4Ek8K+ars
	yk1oZSaO61flCXi8LSA6iHZUABhnrxL84ax0waeU4qWd/ql3cTwtidK87ETddS3N60tMuuT5efa
	0jF3y5LFwWACNBb7f6ytNstjMdUuA5VDVLaHGZKNPqV5HVz0qtbHNMGloqKko2yKaBf839YQ=
X-Google-Smtp-Source: AGHT+IExXUNKRCMA4QKU/OEH4DlhUgNPwHI+yErgzi3NlV2OxxP1jX78IKGVbB7ztYO+b2kgWihAhw==
X-Received: by 2002:a5d:5846:0:b0:3eb:c276:a359 with SMTP id ffacd0b85a97d-3ee7c552a1emr9200707f8f.9.1758552212963;
        Mon, 22 Sep 2025 07:43:32 -0700 (PDT)
Received: from ?IPV6:2804:18:10d:538:67e6:b01b:caa9:3531? ([2804:18:10d:538:67e6:b01b:caa9:3531])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77cfbb7c3bbsm12958965b3a.7.2025.09.22.07.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 07:43:32 -0700 (PDT)
Message-ID: <da3e2b5a-a5da-4526-9884-8789990ebf95@suse.com>
Date: Mon, 22 Sep 2025 11:41:22 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] cifs: client: force multichannel=off when
 max_channels=1
To: rajasimandalos@gmail.com, linux-cifs@vger.kernel.org
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
References: <20250922082417.816331-1-rajasimandalos@gmail.com>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <20250922082417.816331-1-rajasimandalos@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Rajasi,

On 9/22/25 5:24 AM, rajasimandalos@gmail.com wrote:
> From: Rajasi Mandal <rajasimandal@microsoft.com>
> 
> Previously, specifying both multichannel and max_channels=1 as mount
> options would leave multichannel enabled, even though it is not
> meaningful when only one channel is allowed. This led to confusion and
> inconsistent behavior, as the client would advertise multichannel
> capability but never establish secondary channels.
> 
> Fix this by forcing multichannel to false whenever max_channels=1,
> ensuring the mount configuration is consistent and matches user intent.
> This prevents the client from advertising or attempting multichannel
> support when it is not possible.
> 
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 072383899e81..43552b44f613 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1820,6 +1820,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>  		goto cifs_parse_mount_err;
>  	}
>  
> +	/*
> +	 * Multichannel is not meaningful if max_channels is 1.
> +	 * Force multichannel to false to ensure consistent configuration.
> +	 */
> +	if (ctx->multichannel && ctx->max_channels == 1)
> +		ctx->multichannel = false;
> +
>  	return 0;
>  
>   cifs_parse_mount_err:

Do we even need ->multichannel flag at all? Maybe we could replace
->multichannel for a function that checks for max_channels > 1?

-- 
Henrique
SUSE Labs
