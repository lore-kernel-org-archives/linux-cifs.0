Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5478396B79
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 14:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767883215; cv=none; b=cJHEA046D5EtvtLoxDVhEPJdzhd9pgSErrwgY1ihdt+yWDVMvScpVGebE4UJt2otRcwCftprvWhUb/WFQTEV+j5ssZo6yU1FcDXLnSgR0SLWlhJ+trOJqjjqcmajo71C1nFyQY1sZ9XfzHHfCj0yyNAtZvnhycfG/RqNRhovbSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767883215; c=relaxed/simple;
	bh=dPmlogqSF3x91CEJq+G86ZMwTBqFlXyFWdTsnVs3Vl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ny/ly2/xvHhBH2tikT2lbyO/6VL57y4b0hRZvN43ChiviKfdHXwVOmwb3oAjFQVUe5Xqm9esk51jsdKZwQqReHwZrInVvTFVZcBuWhvl2TMqn6HTDCh8OBlDV7DjFeyfeD3ZAPJUgmSR7wx0IMcUCRmP8uyeoX1eCkMk8rgA3hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mb6Bi+gH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aMbbycwW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mb6Bi+gH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aMbbycwW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767883212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=njA+hTMBn/k9kWyQkaykZqwF8RGh2m3Qf7ruOi453Qc=;
	b=Mb6Bi+gHqMWa8YduPeAYv+zEjf9T66RlKLv5kYzKrX9S/aFggprH5mSSbYo+a8la++7PzM
	8bSkWu3LNE/y0xJu3Z6ZmleMErECK+lOB7cxI7POuWwA73xVvKtKL24hEXquFZE7KgWEXT
	ZB4fMs5oK+4TWCxcpdj/4xKGQZI+SJQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-kDSNeTOXM1aH9XrpM2DpXw-1; Thu, 08 Jan 2026 09:40:11 -0500
X-MC-Unique: kDSNeTOXM1aH9XrpM2DpXw-1
X-Mimecast-MFC-AGG-ID: kDSNeTOXM1aH9XrpM2DpXw_1767883211
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-431054c09e3so2044442f8f.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jan 2026 06:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767883210; x=1768488010; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=njA+hTMBn/k9kWyQkaykZqwF8RGh2m3Qf7ruOi453Qc=;
        b=aMbbycwWxvpEuzMTQd/2OzhF4ZuTTLg3jhyyk8lmc2sDo2Eha1H8aVuxuasDwuxVvK
         JuETO7QO1TemGBnIJKiIlqiRek2Al4nZiwyonoQn/kTKTUWG6F8SW6IRG2MsdlFPkxc4
         hoo1BDUqmGXbSpyHE+n4fTinuHsBaLpHcdsw/hbD7rWaGqcxrz5zkUynwT3QziWqa4VC
         Dze5TFBdvUii1lWu1iQSX3ycFHxoGs+Caq4MFQlO+3s5zr2CTZgAsiBOBXwnS/lLYIQT
         N2lByTUCJ2CzN06XIiY8YM9FT9muf6y3V3fOtqAZ6w/0dsvItOhJYG+ljIsmnEI8QBRC
         Vyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767883210; x=1768488010;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njA+hTMBn/k9kWyQkaykZqwF8RGh2m3Qf7ruOi453Qc=;
        b=ghQuQ2AQ2p98UL5ttk4ZGNfETxjx+0iB56p/5TqjcC5G9DEeunLT3qAaJbBG/GXKIT
         +qsici4fgU9YgPdKo4R7zicJw7VpPtpbLMkeIY6yKl9clrbnndjl2ERMxoYsniDF2Dh5
         +jrwU5iw3SJn7N5+erY3Gv1mKhkfEcNqITWmZLYNQ/b5+pjHydZyVIPIxZq9QxzCY/p0
         pxZd/B3vFXBGVqpwrVPu39iv8wY/53RyTYaw3BNu9O0MhcbECTnr+rSCdFlqZ/zBlE0v
         /hmqDXMDJ6qOJDDXjXaMZEyw41IE3joDPusa763JF9IaJ2yuDivZJ6Lgg6IOJlf9Smz6
         OUMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2pv9WR5bk851nCIsfrs8XN3nn8fr81H108WKYdFgnVsb9mCeFKAsydbOVbBkqiT+aGdyLSUQSd7xx@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5pNj3PbqBAY5G3BA7TTfZJmHvT69BzcIsRSF9Rrc2gT177ZQo
	M1v1QQTAIfEQzMX+IAS57IbRV2ACRx7ruxAM+19IUpJvFdUtlicV6BCnMsjUNoRDlDXRKw8JsA0
	PZkTFPqfL+2yijAVmXVgRBF7hcTV/4mAHetfsj1wK/HQVPRcGpB9+DbionkOvKuw=
X-Gm-Gg: AY/fxX4hSYS5dux5NooE8c9vIyEHBA8O4rS1yDaMsnOo8iOkauh2HOOKMkbu1/oBoEx
	K6rjzyvuZgylg7BvNkzIFKAFzqdZnM4oO+TjdmayAogwWjJVIbN0XyvIt3elzTOOlwZfyPG8910
	oKc80My6PC9iOu0vd020J1VRSpvt9lDKrsVP8SbxARbDIySGq38KSctOJK4kmfUVuPNn0gCQwvz
	Jo79KrLS/SXI6DWL08ZhwKZB7YKJRBOmbEHHWj1BjuL1mU2Sj7W5thz9vxfl6xFWAX6WFYqfcbp
	Sx7IlOnc04eRfRyDnkX7Bq8BCLqoR7LI0U5hSfNvY71K8k6Qo0DDOIbEeXwgn6koER5FMjYF1Ci
	i39quU8Nyc5cdig==
X-Received: by 2002:a05:6000:290c:b0:431:864:d48d with SMTP id ffacd0b85a97d-432c36282b8mr9097908f8f.5.1767883205632;
        Thu, 08 Jan 2026 06:40:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFhrvE0E96qmKMPJwgFr/KgrUshlj3gNC/1jVjlfOFsD1VsRwzSKI/T+U4gkSRnW2fyKqjotw==
X-Received: by 2002:a05:6000:290c:b0:431:864:d48d with SMTP id ffacd0b85a97d-432c36282b8mr9097863f8f.5.1767883205167;
        Thu, 08 Jan 2026 06:40:05 -0800 (PST)
Received: from [192.168.88.32] ([212.105.149.145])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ff1e9sm17531056f8f.41.2026.01.08.06.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jan 2026 06:40:04 -0800 (PST)
Message-ID: <0df97c1d-aa75-4472-aad6-33eaa919ce28@redhat.com>
Date: Thu, 8 Jan 2026 15:40:02 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 02/16] net: build socket infrastructure for
 QUIC protocol
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
 <d5e0dce5e52d72ed2e1847fe15060aa62e423510.1767621882.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <d5e0dce5e52d72ed2e1847fe15060aa62e423510.1767621882.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/5/26 3:04 PM, Xin Long wrote:
> +static int quic_net_proc_init(struct net *net)
> +{
> +	quic_net(net)->proc_net = proc_net_mkdir(net, "quic", net->proc_net);
> +	if (!quic_net(net)->proc_net)
> +		return -ENOMEM;
> +
> +	if (!proc_create_net_single("snmp", 0444, quic_net(net)->proc_net,
> +				    quic_snmp_seq_show, NULL))
> +		goto free;
> +	return 0;
> +free:

Minor nits: I think an empty line before the label makes the code more
readable, and I would prefer #if IS_ENABLED() over #ifdef.

Other than that:

Acked-by: Paolo Abeni <pabeni@redhat.com>

