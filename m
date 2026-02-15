Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C261A261388
	for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 13:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771161422; cv=none; b=kW5mQs+kwYlANK8niNchzE9z+y2dkmfLv2v2VeitlC/9/A8mGiz3tcqec/XP0fn3n443F/H3Pi2KTMz2RyfBBJci1CE+kF8iXtwtfAwevjd/nNJl8ncOxtO6Q8m6gmt3awANyE9i6ZOa81N8uTR/nLX5hr04vWkPFqol74SkCsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771161422; c=relaxed/simple;
	bh=dksG4AeTi6QW3UGj1OfkkVNSEzKfN0dA9fknl/SH4Jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iyLq3fl2liPrLRLJSb4cqKe1tOpUFl3dM6RGxRsz1CAO+e/KICNVYoEUP5iVfnG/gP2jhohEtmAlnk165dOzNJhNcpPNnDyAG2zChn4U3wREQgYb5yb+QLylRj0qs+2wYKsFli3QMHB5hxXQ1egxhfAQMN7R2I97BP9hLnx/M3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LL3LqaAc; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LL3LqaAc"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-824a8039d9fso505073b3a.0
        for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 05:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771161421; x=1771766221; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/jIh+XsNCP2XkdcyluzmcsPZelK7RJZObIR+wr1+nVw=;
        b=LL3LqaAcVQzn0rODaGgY3iagZgzmPFCmkEcdRosxd+xJI9bZHbH20j0xOMTuIUr2L/
         wQic6E/hmFF4YE/8dbDixU2w0P2WCovJFTvYIsJsHPsnjhsYiOXQ8uHPtof0aSAepPRP
         OAbzXAZjV8MglZmwCAQV0do8ExR2qDLOqd/ikEGtcZig41uIDm0uKUMR8b5AQdn7x0bk
         kdW+/i74G9otvfA2VLWbdSBVzUyRAEbEZR9bDhn78eVr3MqncnZ14/zEcZE4ag6Bo+3p
         cflCAaWMhKJGI4XU4tGVimCcV9oadvB0/QYke65cg6rhAsdUQQZeMosQz2ObMDN97YbY
         Jmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771161421; x=1771766221;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/jIh+XsNCP2XkdcyluzmcsPZelK7RJZObIR+wr1+nVw=;
        b=MmXn+n9tFxIdM8+Wcn4y7ds4lB1PYALMu3kx0MLUXbZRh7bFXgcWr/1ReuaTLJuHhv
         EfwF4iU5pOf8FUWYiz3ZonNMIDYA74i5rkK+IlIDQMTfZm/l6k3Tb6QlKlFJjTx927zU
         8Dx8hxJT/zZFGRdxypKbELIbanQZpUDEThVN5Z+Mmz/pi7QMZJMyQs4dDS7JwBlw6o9G
         bsLDOXHY0UAMOWgCbH1Z0jUKVqLB32k6SoMgkbRr8ozxtu5DeX+HSyqoryMhnvZccQgf
         Va2E7s58RlgbTrfmAYhcne8td9JNq4d+SaBHzRcfXVA4Ot0oppt+FEB7u3WDYXLnrlgG
         WR1w==
X-Gm-Message-State: AOJu0YxfgjhxBL01O9Bxg9AZLjgz2BSJ/xYrFFj60UEyY5MNsrhjCrFQ
	XvidePNwU51wonD1d8ik5JywYWNFzQjdGGvtjGj5oNoVI0VAXPhxWeYSOEZTuQ==
X-Gm-Gg: AZuq6aIQHFwPNXu8NG+ldYUShszY9gqKrlLg3Rn6IMhyaqUrscFwX1w8pHAeChXMscu
	d2gcsxw3NX2t+YI2ZGbcAdyUQRc1AYZqEii66cXWq+zS9Znyg7rjVBQslPJQDnpQUnHhC8i3ryc
	3498V88Pwi25oVWeeMhIMCilmuMW49Lw74trHt5LFXmJFOPE/BF/p1RFC5vg6pjrokqSlAgfA4O
	55+s46zrmxUtR+boDVIR277G5tO9VTKOY0sVs+mRhrA53hiK/DtbFxhokj3VZ2LE/XiT6dRsZpK
	syVmE7DJ1uuL+xv5GjraIQxozF1A3F5Wfg2/qcTLocc1c3Wds4FbFuO/oVA47Gl7N/mNzmsbstq
	4DJgY2rC2p0e18Ph5i76dpHhHu5Oeb6MvoGB516kjF8VQDw8EXqUb9IzDZKpPoXtx9FvUdfu8uJ
	UKfAkwXiAhrFshOReBPSE4jlnn3CP1tOJZsQ==
X-Received: by 2002:a17:902:ce03:b0:2a0:ccee:b356 with SMTP id d9443c01a7336-2ab4cf118b0mr61790955ad.1.1771161421035;
        Sun, 15 Feb 2026 05:17:01 -0800 (PST)
Received: from [10.7.19.128] ([49.36.181.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a71f1efsm43662415ad.32.2026.02.15.05.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Feb 2026 05:17:00 -0800 (PST)
Message-ID: <b36e2732-0678-48c4-a50e-58512b4d9f6c@gmail.com>
Date: Sun, 15 Feb 2026 18:46:56 +0530
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: client: terminate session upon failed client
 required signing
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org
References: <20260205010012.2011764-1-aadityakansal390@gmail.com>
Content-Language: en-US
From: Aaditya Kansal <aadityakansal390@gmail.com>
In-Reply-To: <20260205010012.2011764-1-aadityakansal390@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/5/26 06:30, Aaditya Kansal wrote:
> Currently, when smb signature verification fails, the behaviour is to log
> the failure without any action to terminate the session.
>
> Call cifs_reconnect() when client required signature verification fails.
> Otherwise, log the error without reconnecting.
>
> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
> ---
> Changes in v2:
> - reconnect only triggered when client required signature verification fails
> ---
>  fs/smb/client/cifstransport.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
> index 28d1cee90625..6c1fbf0bef6d 100644
> --- a/fs/smb/client/cifstransport.c
> +++ b/fs/smb/client/cifstransport.c
> @@ -169,12 +169,18 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>  
>  		iov[0].iov_base = mid->resp_buf;
>  		iov[0].iov_len = len;
> -		/* FIXME: add code to kill session */
> +
>  		rc = cifs_verify_signature(&rqst, server,
>  					   mid->sequence_number);
> -		if (rc)
> +		if (rc) {
>  			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
>  				 rc);
> +
> +			if (!(server->sec_mode & SECMODE_SIGN_REQUIRED)) {
> +				cifs_reconnect(server, true);
> +				return rc;
> +			}
> +		}
>  	}
>  
>  	/* BB special case reconnect tid and uid here? */
Hi, I am writing this as a ping for this patch. Thanks

-- 
-AK


