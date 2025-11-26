Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330D33451B0
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 22:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764195546; cv=none; b=ljrgN7ryqNae9Vmc2Ua1Fli22+E9bgIFKuuE2WfVaxVni9TM9xyF3/4o3wvvUx2BY1GJNrr7hsVTjQMS6pJ0Bna9Pf3szgxDM3qRS9rt3MUPLodXizgTXPDAKnI67dOJpnzS1aRkIHuKT7387GGH4OaFft8jFq5PwP941/E7zp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764195546; c=relaxed/simple;
	bh=sIWbRcx7sC05bYi/YIY2zR/NKUvh0KWELOSEGo3Hfzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MBtt4FMQ9O1SVsSxQiuw4eNIBM2gBnCzSeLRzN6VsA0dJBsduMh+GBMRU/dp3gT7/HxQymZ8lC4Tbp1sYfYbyzOYGNE9jQexrP0KQm16uTFw/GZ8CGJXRuhqDpxtAp6w7cD8lvpIPTFPDu8OY0aMY8rb4dm7e+qiuGDvYYuJhhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ceh0248k; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ceh0248k"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-9486248f01bso11662439f.0
        for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 14:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764195542; x=1764800342; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1wowXlow3FMc8/tNrN2yLigPPDUDtx0JGtrYUEW5hUk=;
        b=Ceh0248kyaTc90MipJKQFJgX3pPuS4aCyr7FKFyuiJzy3OQ/nOTtsx4lt5ihaAC9Jf
         wAT2Q6NI1gM6Oe9YzpFy1mCOAbkJ0fQKQerimlqRWQRutwNWAvyCJI6vn+tfrP23Uy+k
         qIutfsaaHsQ8qoU/9dqZE/Y9eSb16YwGVPjVgqEyzZWUHY9ElHelTOxsrCwiO9qlYOpB
         Wp2O43aKUDOL0CaR0d5pgOfUYklhoKpoivCoYqr6bCusqZCPvTaAxRDdumWMNf2YJaHK
         rKIhcr45r7JnISjXQxWENBcHmMnuTI0TxuapbThn+Hc9e4VP7M4F4mFpdqbHIipsHI5O
         sSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764195542; x=1764800342;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1wowXlow3FMc8/tNrN2yLigPPDUDtx0JGtrYUEW5hUk=;
        b=TM7uDn/RqWVx+/M6Gp/3mgK8cSubPW+3T07JH+RApGbfHUQmlS8A2Gr9t7uQADpFTv
         OZfM3vDkfONXTEaA7j1rKcpMUT3aA2GNpHgWDmsZqljJrv9DNSCgvrlvavdURkB/DZnM
         FXO7UWvL3TXltk5q3H47ufA7rg7TAcVsHD4c99KnJpHgGnczufUVCY/6bJZDgmBySB61
         OtLlHRn8W1ACnmPrRsHdSpOFV1rnBP8k37IXiJKKTh0+O5IniLJHbT3PeHAdMbecZkwF
         jo8K5xgsr2BNmuD4DB7T/xQ8opVadeO3GhqZD12kavBdfSa1wKekFQAlqmy9ynZK+hNz
         LFUA==
X-Forwarded-Encrypted: i=1; AJvYcCUKrlICUkTnmFWm9+D5E8jU5f+ht2i3MQApROAvub9ugU+6mC3wE33ZKaAmQVfJEsqZYL2CUsb/INWs@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0/VdQ1KniQECWu1HH6xd8oz7OYsaHNZjjtWOrMqG5pa6EqR/B
	jlT4/mk4bXnDx16Pg2HnZOjyzg+zpn71wm54A9NPUwnXvKrdXohgBlbaKhzZGSKHb0c=
X-Gm-Gg: ASbGncuCZzoBXPrTVsFHKJ/a8W6+dGuxpx4LBOhHfxnWA5Ha436LprIzlzmAJCvrMUi
	QexFKOS+JADAMDaxCwe7Kf0ZDJG+SC3yDzcFrGJC59gQND70h8tnEaQc2aCqWEVUlvI/ebW2u7O
	xytUa/w5y6q3VehCyM/l84v4ihX+HREL1LM8ZY3zxUf6KdAQbVAt6Cd1FpHf6cYumFLtYkJCRNU
	U6Psr3Za4IEBbDuFOnFB8vmsv+vTAwarIc4/zDBpS48bfJTxdCHXQIejsMEhwvA+NFftAOnuIu6
	IwIUwygc14Nhmfc9ah9pkpo971vxb1hN8ioMCHQpuhbT1sllfVaEohuZJcrSyNsMnT/lZR4pbAZ
	BuQvuHyTKFXilkKaZvOTaSkE8u3mx+9Hjnw434xBC9eZdxoqjfdX15bnTqfjnzt+XH+8BQtaqr/
	b0X0EZLWYGtSg7ImCA
X-Google-Smtp-Source: AGHT+IGxkxc8fCZt/xF4NNM9fIWKpLzM300DpmX1FeSS/Z4JaygfyFk1znrns1dtxauVsXPqqT3cZQ==
X-Received: by 2002:a05:6602:26c9:b0:948:81a5:7ac9 with SMTP id ca18e2360f4ac-94948b3d514mr1644646239f.18.1764195542254;
        Wed, 26 Nov 2025 14:19:02 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-94938651ce7sm811919039f.10.2025.11.26.14.19.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 14:19:01 -0800 (PST)
Message-ID: <46280bc6-0db9-4526-aa7d-3e1143c33303@kernel.dk>
Date: Wed, 26 Nov 2025 15:19:00 -0700
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: wire up support for
 sk->sk_prot->uring_cmd() with SOCKET_URING_OP_PASSTHROUGH_FLAG
To: Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn
 <willemb@google.com>, netdev@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251126111931.1788970-1-metze@samba.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251126111931.1788970-1-metze@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/25 4:19 AM, Stefan Metzmacher wrote:
> This will allow network protocols to implement async operations
> instead of using ioctl() syscalls.
> 
> By using the high bit there's more than enough room for generic
> calls to be added, but also more than enough for protocols to
> implement their own specific opcodes.
> 
> The IPPROTO_SMBDIRECT socket layer [1] I'm currently working on,
> will use this in future in order to let Samba use efficient RDMA offload.

Patch looks fine to me, but I think it needs to be submitted with an
actual user of it too. If not, then it's just unused infrastructure...

> [1]
> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/master-ipproto-smbdirect

This looks interesting, however!

-- 
Jens Axboe

