Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A8B261593
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767883520; cv=none; b=ED58xK+igZNw6j+GZJoSf3atY8OUFAIObnNc/6Q7MSHXFIpTXhOZxlbrcPoApnr3Ou+NoWchCQBRHkBGknyo6cJs2cB+v7B8soalIYE5vMS8vnrK5dhbKq4o+6y5JEUJN4YK73jQ3288p8m3lE3hCTYdc6M9HvEAouQYD7hWVOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767883520; c=relaxed/simple;
	bh=uJ44nbEpEWeaDIiIyh51DR/9MMAn1kfodhd8t3+Mi/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aE5IZ8UjZN6xhI1yKQpCn+5wC1909tnhzgSaWbVZg8bzr9zelpV94+Py0hHwOFGT58cGEazn5QkIMpLrNt3mnn+duYiSwceHYcHievED1HmK/jC+0hJMyEvwtgfgSy/bjbhlBlk9DniBpqNpFKnGDFYEBfHKmXuseSy6rqCBj5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SnOgZdm8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fg9IFGyh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SnOgZdm8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fg9IFGyh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767883515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9G9GBVaRvkt+4+qD39+mpxztmdx+7UqfLQ8rq+gGpU8=;
	b=SnOgZdm8rp1d+dKEcZeN4Z6bkvAX6xnXAilELdKkPfRBvrNPYe6KxNYJrB5sQ/VdBjnhpJ
	pD4SEOzkrmQ9y08ykJ9uG6aj5jupQ+6/ELT6viuW7jwFnyLlv6XEtpNiEGgrqd8hxtIapc
	4NDBcCfGXuIZow1tXz2ksXVUk5rxWOE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-wBrx5VeHM1SLDWrPIA-t2Q-1; Thu, 08 Jan 2026 09:45:11 -0500
X-MC-Unique: wBrx5VeHM1SLDWrPIA-t2Q-1
X-Mimecast-MFC-AGG-ID: wBrx5VeHM1SLDWrPIA-t2Q_1767883510
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fd96b440so1662695f8f.1
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jan 2026 06:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767883510; x=1768488310; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9G9GBVaRvkt+4+qD39+mpxztmdx+7UqfLQ8rq+gGpU8=;
        b=Fg9IFGyhcEWWbzlAEeMn0TfafBMJAL28eE0EdAZojNP2cHGLBZNIS9mV3bc/K7H1rS
         kEgcspoge5LSn1zATbAMl6xH0zLosQEuJXAxXfO4Csh4ZrQqrandhqcuP8bTjv5NqRhX
         tywEF1E0HTTfQuK/CR8XgCPEu6JW+PyaxkZilOyL/agPN/YgmjPXmUBRnNwozNG5Pzhy
         L83HYAF5wG3IcyxYUYPEJj2a++0Ekrbo97BdtbiOHKi3HPJB3Ib505iMHuHNYdnGt2xo
         Jh22CtanocOuTryuZNb1S9F6ZbL1sqFHORU8HGaLduSqGLTdtHnSKPPDulCUGJoJguPt
         hItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767883510; x=1768488310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9G9GBVaRvkt+4+qD39+mpxztmdx+7UqfLQ8rq+gGpU8=;
        b=G/fUdegV5jgIVrLvtxy8tWcASOWc/ZsAvGZbybARKpCh5L6AkOZatTyDRQ9+GtXOrJ
         9sU3BzodybiTLDd/DmibRXa0pGsWqH/rYcUoOnBi1H0GaFg+0qsdTAwjIlAEMqeiBFj0
         34wN/IOpQEnvjh9BZHozdF+3CPBGfV9MIIM1HTR6QLyw9A9YprmlnzPeCPy9lla4DAHD
         0nSiQtld6QeYSIraIkNQviyY6TRb6SP4UCA86ezt19hUwNFk1Xsq9Qjq54frDkeJZWWz
         nUxmyAYw33P9Xp0zEntZJ7rMgbf14nYVU02vvAuFXqjPTxIsK2UNq0mxDy7+bUQqD6Cv
         OsUg==
X-Forwarded-Encrypted: i=1; AJvYcCXQfX+E709fJH7/77aqktxl0Ux0hxxb5QYY50AYMhuxMRtKajyJyklX/M8ZGItdmiHEETiKYaMttwuk@vger.kernel.org
X-Gm-Message-State: AOJu0YxFxWCxbHFH37O+ykTdFGFJXbngR5HaiernCXBQUkPcmgoQCnps
	L5520+73qQLBYrfI9hAMgKNptcXDx8Ro+DAt0mabwOdo5GWeCq+MpfXA1SBcEsejj0IEqITamaW
	zI/pvee/0GsheVvRZ35N4NwQkBQcBWbu3RdsYEavovWwVWyumDXDG10Les1RiEwU=
X-Gm-Gg: AY/fxX4yXxTLYs9Zk7WiQ9U4KoI9Xy8DPiR/ie2QcozfE4C7+ENh2cZQMM3qSPdm0vG
	uEC7TYcOPB8hLHk7iZsSCpJTbJZFV8Pamtu6LCx/HS24Pqb8G6j/YUQUx25zy4LcPwyyig0f/P6
	KKVQ0oBtyqy7CwB2iSgG7OGOqWFlqghyjO9UwydZQER7bwW/g4pyQJaDQuZ/QW2QUnvDmIiXrKf
	+S0z1Qrmt2biymr72Gp8gOMLgd79J6e8X4NWq96WYgSdaZxE535AVcEFa8+2p345c+MpfDM0V0f
	YSjTROo+/IIKWSt3RJP7LuIDaRVTj5G8lrffwCDIPT3zvHFrJudiETzAgyFynzvL+yjZfQczhJQ
	T2F+3qrZ69WuuLg==
X-Received: by 2002:a5d:5888:0:b0:431:8da:11aa with SMTP id ffacd0b85a97d-432c377906amr7149436f8f.59.1767883509873;
        Thu, 08 Jan 2026 06:45:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjZ12e96jv36O/fc3w7pA93fJkC/TKQaB49Tqq9W4f9f+lI2Mq1ArAa/xwJPV++ZigefYVIw==
X-Received: by 2002:a5d:5888:0:b0:431:8da:11aa with SMTP id ffacd0b85a97d-432c377906amr7149411f8f.59.1767883509440;
        Thu, 08 Jan 2026 06:45:09 -0800 (PST)
Received: from [192.168.88.32] ([212.105.149.145])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5edd51sm16708196f8f.29.2026.01.08.06.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jan 2026 06:45:08 -0800 (PST)
Message-ID: <6c8a1f56-16ed-482f-a9a8-ac840a7aebd3@redhat.com>
Date: Thu, 8 Jan 2026 15:45:06 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 03/16] quic: provide common utilities and data
 structures
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
 <f891d87f585b028c2994b4f57712504e6c39b1b5.1767621882.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <f891d87f585b028c2994b4f57712504e6c39b1b5.1767621882.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/5/26 3:04 PM, Xin Long wrote:
> +/* Check whether 'd2' is equal to any element inside the list 'd1'.
> + *
> + * 'd1' is assumed to be a sequence of length-prefixed elements. Each element
> + * is compared to 'd2' using 'quic_data_cmp()'.
> + *
> + * Returns 1 if a match is found, 0 otherwise.
> + */
> +int quic_data_has(struct quic_data *d1, struct quic_data *d2)
> +{
> +	struct quic_data d;
> +	u64 length;
> +	u32 len;
> +	u8 *p;
> +
> +	for (p = d1->data, len = d1->len; len; len -= length, p += length) {
> +		quic_get_int(&p, &len, &length, 1);
> +		quic_data(&d, p, length);
> +		if (!quic_data_cmp(&d, d2))
> +			return 1;

AI review found something likely relevant here:

"""
Can this cause an integer underflow?  When 'length' (read from the data)
is greater than the remaining 'len', the subtraction 'len -= length' will
wrap the u32 to a very large value, causing out-of-bounds memory access.

Compare with quic_data_to_string() which validates: 'len < length'.

The same issue exists in quic_data_match() below.
"""

/P

