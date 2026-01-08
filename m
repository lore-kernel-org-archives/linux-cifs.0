Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAB427A465
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 15:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767884466; cv=none; b=XMqeud8Dh64Hx64tD8YeZjsatBoh28Gi8+uOQfkVinc1sfGR5GADVcOxoSynAIUYekeDV6wLfwawEb8wHxB52kCxelMBA3AjS3LLzj/cEZUk+Fxaq4RELsbH9KKQJtXbVV3L1Wix5/diF3Hvv1lMQERwjeJrCoOGKPad67eFr6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767884466; c=relaxed/simple;
	bh=x/KSeZmo4BpDEjmSmP/FoMnnJGbAD1EDOlqErMkqNac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lGpqgY+JKmEWliCAglVe+SOLsswPYF7eCZvlQaJBn3wDLyiZ/MDbk0HxqVuSvbdQqJVGzqgQYdXCcNdAsQP8gnPUhadcxT9C4hZMREa4vZxLCWnMS1R0cL1hz1knrjKTEJJno6c/InThXr/YuYmExPjpBZ6c3qFhfyWSFt/qkN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A4ARLJKk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=S7Rzr0kV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A4ARLJKk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="S7Rzr0kV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767884464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HqGiJMM1pVcyveofpqbLm9RhIj56aLTI2bxMd5dfX0k=;
	b=A4ARLJKkWWpwCkoZubZN8CANINQBncDXbid+FOLdMgNkMOW6LBPg0T+FC1q72uwqZrCIsR
	/b3sR4w9F8zNeRGIWSrW4JKHmsKao58EzJvMsC87zpB8hVxyTBTJrdFWjDDC5MQQ6KJzh0
	NVXK+2ZoTLw7JfYXsKGs6O/rcE/6nvI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-TJe7cCh_MoK__so_FWjPRA-1; Thu, 08 Jan 2026 10:00:58 -0500
X-MC-Unique: TJe7cCh_MoK__so_FWjPRA-1
X-Mimecast-MFC-AGG-ID: TJe7cCh_MoK__so_FWjPRA_1767884457
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fcf10280so2212622f8f.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jan 2026 07:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767884457; x=1768489257; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HqGiJMM1pVcyveofpqbLm9RhIj56aLTI2bxMd5dfX0k=;
        b=S7Rzr0kV4Oc5LzZq6MJaoYlJiBa618ndKkT9Hh/WnSDRktJiq4CDzP2wIJWCJCvZeK
         D8F6JAuhTNUqrrPOJwbfi6+8l20KqBfOc7YlLx1dyrOYRqW0t/DjNB6xxOqHHc4QiG7T
         p1d0LjOit+/xG4qd4L0ub/bD/CBAEw8kBgaUPQbVGbEF+hFU2Fz7XFOKVH04iyDW+rZx
         C0O/nfxJnXpRlAPpavSiFWBk8fczKX+tKTqt9/LhsjNC1ayGTH/zVnbnfiWQufoE8f6M
         gzBmydIuxWxDKCfBs3L7chs8LdEohZh4mMrH0wd5C4+36+APGxntdeMIUQbaVHLAqQXZ
         Rqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767884457; x=1768489257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HqGiJMM1pVcyveofpqbLm9RhIj56aLTI2bxMd5dfX0k=;
        b=suDzgXR4Ce/GHklt5mBMFcADGRqsD7LbsatKnauid/cfNn1yzpZNbOv5srOUAx+4zk
         ZhpLlOepa2R7VWFitgUIeIH3gM0OxLLS8JQB6ORdu3IygyAGuycNc/zmpuX3mkwdePPL
         R3gMO612iQONp+RQCOMAmCsbCKLI3uWuFq/GjVrc7NHGLmQRBhUQzx22X8mUygGzgryU
         ichh5K3W0wl57wyoV0K1Zkdq6NqfkrnV18HOrRoanLGmkgzEYG+DTcbtCHkdN7WRfwCg
         vMuUCJmF2FEZQ42CfgsEhlEMcWVtHDoWu7kUm6pvGBEidB3nRU/iw1kIieHuZoZIr7Of
         +Nkg==
X-Forwarded-Encrypted: i=1; AJvYcCVRVACU6OcmX3QHjSbDiIS39p4kfbmG8/caxCI/cgPbbKbGaLQ/dEWyWQwns56J3Ieet2t+yvQSQDG7@vger.kernel.org
X-Gm-Message-State: AOJu0YzNJ9P3a/FggPc5EFdZfNIbeGXorNmCDn+SVLjcL9zgkVnSsyMx
	6LdkvbMZq1lV8+cxQaJpzeU2u3Wbhl9CO+h6bJ7cEaNNMX2KxSamITwxSimM/GGrcUIUQ7euFqy
	wuaC680HLm9SHiV84W+62XY2hetbQJQ+Pda7gzeEz63JdgpoXT53oTUMtiZ6lUoA=
X-Gm-Gg: AY/fxX7BVdIZ2SLu1q6JKO/lEsZEY1TpbVh8CMTP0ByHtE/zQSgitYRwavhVWEHXbp5
	UDE82PTB1n8fsFn0Oi53Yj1fwULHOiWIMe0+Myurz/3yrmCfrIRIbHlHSfCOs1QcOW8oYpBKqzu
	ySRMzXm88HJKwuWLHZM7qCcxHy4lVHjoeHzVy38TB6FuoXn2UKRLrkomty74z+Yz9tpWvIXaivn
	o608RktKdyDPY1xccEeT5ciAm+WNdpotqsQxGdBPuAUgkBjcZ0fotpYdxXoulP0JGkfKVmidhsw
	h4qmLBvncblYTl3/DEF+zyPL4y4RLKj3GdhaJgixjfZng4RzhI2qAifet4QAyitmCA/n22UqJTr
	qUFy+e2cV0VpN9Q==
X-Received: by 2002:a05:6000:603:b0:430:f72e:c998 with SMTP id ffacd0b85a97d-432c379f3d4mr7580412f8f.51.1767884456819;
        Thu, 08 Jan 2026 07:00:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGEFTqZKQeu3SumB0qBMJBfqywsL0m05L0nnqVw7M8JGsK2WTMQCpTmAHt9TI/XwSLSTqMmww==
X-Received: by 2002:a05:6000:603:b0:430:f72e:c998 with SMTP id ffacd0b85a97d-432c379f3d4mr7580153f8f.51.1767884453818;
        Thu, 08 Jan 2026 07:00:53 -0800 (PST)
Received: from [192.168.88.32] ([212.105.149.145])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5fe83bsm17351709f8f.38.2026.01.08.07.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jan 2026 07:00:53 -0800 (PST)
Message-ID: <1f31a9ac-01dd-4bb1-9a5a-ec67b381c5c0@redhat.com>
Date: Thu, 8 Jan 2026 16:00:50 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 05/16] quic: provide quic.h header files for
 kernel and userspace
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1767621882.git.lucien.xin@gmail.com>
 <127ed26fc7689a580c52316a2a82d8f418228b23.1767621882.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <127ed26fc7689a580c52316a2a82d8f418228b23.1767621882.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/5/26 3:04 PM, Xin Long wrote:
> This commit adds quic.h to include/uapi/linux, providing the necessary
> definitions for the QUIC socket API. Exporting this header allows both
> user space applications and kernel subsystems to access QUIC-related
> control messages, socket options, and event/notification interfaces.
> 
> Since kernel_get/setsockopt() is no longer available to kernel consumers,
> a corresponding internal header, include/linux/quic.h, is added. 

Re-adding kernel_get/setsockopt() variants after removal, but just for a
single protocol is a bit ackward. The current series does not have any
user.

Do such helpers save a lot of duplicate code? Otherwise I would instead
expose quic_do_{get,set}sockopt().

/P

