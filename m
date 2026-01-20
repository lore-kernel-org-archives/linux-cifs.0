Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7830344A738
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 14:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768919515; cv=none; b=J4ANic6sIaXGZqv1QTqx1qKpytWwSyf9Gm+U3jVKqAA3NPRA6UtFvbv6SPaw8UiYaGJZxTlHkNXp+7xyLhB2NGZMosT46I/B8yZCjx/dCXfZTfSw2XAqoOtPbHIuv63m3qiHSvlSXimJvNJ5pSG+xPTbK1XwO/ZDbBJ3M4ex1e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768919515; c=relaxed/simple;
	bh=f11dCp7P6vtG0fXeypBN/abvJwiZ5XOizrijrXdkHk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jwBmw23hlGjJaOntxsa72jCL67pTpYBRYCBg1njHnR5xzd8R2q5rvtHadmUxtM2BtJq3ydEM5YkPxtN9q47TZaD0YWz/sNqLTA9QybNd+3w4m6mjlbnIDS2tHXBlo0Xq9m+ateuC7ArxtgPO6/58gQioWpsm1bFlCDCLCC6Pb9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U2DHjQK4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GO1k/25d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U2DHjQK4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GO1k/25d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768919512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=trifWfZ7aWYVX11q/l4Y4wctobYfLQu9Hbg9myXq/us=;
	b=U2DHjQK46h7Du+5Zj730S2F2LYYTDpCazSZQTzCtH+RI2fuv2RnvGfm3Lj8YVe809O9/Oc
	JvHJnTRq52YQGdw3+bjvpiV609jDd4o6dJkpVCfjAJ0OgiubIOMFV36j5iv1f57RTgbhOe
	ZywQXD8DaN0RkAxOn8CLmhkczaI25aw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-ykAGFBp6MOSKHBO5bHyt9Q-1; Tue, 20 Jan 2026 09:31:45 -0500
X-MC-Unique: ykAGFBp6MOSKHBO5bHyt9Q-1
X-Mimecast-MFC-AGG-ID: ykAGFBp6MOSKHBO5bHyt9Q_1768919505
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430f4609e80so3722142f8f.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 06:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768919504; x=1769524304; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=trifWfZ7aWYVX11q/l4Y4wctobYfLQu9Hbg9myXq/us=;
        b=GO1k/25d3eznxDK6E1ZdmWPg5rOEEkKziVFyexVrnMbfa1D+Yn9oQJiNfP7fj8y4cY
         hdP6+jdzvtI4ymDOhWE5n+btivwI0y/SAc3/Hs5VsEOGthFphaCLhoId19JZOnJ0UJ3l
         oOulLXH74O6qttO/QkblRIv/4kfBmeaHIOuKtYBTsrwLmHsyI/hOFxr5Gn7OCVmD438Q
         C5yx+Nx4mdEhr/npU2d8dHIp/l8grTzUzZy4LZ9ZIFn7FkFTojBMOUaEsYrCyniO8cN3
         Wpk8HzzQekJDw6fd2KanvfrHmHD74W6CZsiizZobTWin+hOSC48efIccuOIrGBfiJYWC
         1ucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768919504; x=1769524304;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=trifWfZ7aWYVX11q/l4Y4wctobYfLQu9Hbg9myXq/us=;
        b=i/aBbDAAliqi2niVdQzV3BBwPPvAzPQYb0VXFJx97DrdHPdV3R8ZvJZhcwVWOD0/dx
         6AnKIVhfAsLRrRpGjGxORrkLtnMpnjCSODaJ3Zyx7+mIBAFqS6Q9Jy9ybH0kzJKC83Om
         4Vn9Q2QLPEzNKL7Y9zpajJLG1vSbL/fmtcV0SGDMTgbYX3mRJ3AKe/qms0C3X0qvw87k
         Bf6cICzNW09aURVc4AVAaV9NqtA9WrLRzcnO8MihrV78zy7fLJSKUd8kwemqWvwkLnVL
         rW4PtBhACoa4Nz9SX+rC6AsgnmY39fxU698DI6iGMykhgAKw6fVc7BFUz2qfunH5fjGb
         0V9A==
X-Forwarded-Encrypted: i=1; AJvYcCXHG47oXZka1MYPeJje6tbrnWzIkQ6A0XGEeNcfAOpQDKJ3BtLMc920AGJHA8aw1DfifcMcpL4fNRkJ@vger.kernel.org
X-Gm-Message-State: AOJu0YztHW/Amf+UXMCHB37rsq+tLHSRtNSeiw5RKVX8JYcZHFrlGsHu
	UYot41ilDl5PsV/BO5P1P+tT428dxFNt/QoMet8gJTue4LQQzB/Jbxl1srcyFXTcNO0xP7kuHB4
	TWCpyaTqXjkRij2GFzP64Zp22LISAQMaCfhFSv2FHICfK0H8CmmF3o+H5VhNSJY0=
X-Gm-Gg: AZuq6aJD1zHqcVO5DndGwxTib89lB51txfrzudBDqFbzanPAByiIV1eKxgLKiG/A7My
	pK6UxezzfFYebtGKA4sH3Rn4ZdZQUd9vDHOoBCqR12I8/HjePuB6XnAjETtmzoVq1OF5666ttlc
	LGjwE8gQvrHcVF/Da6eJEkC/nFBfjRYvdm2a8H8aecDJ2oWwF7ocjegIOebsTHQUgqVLqBdPsRi
	kz/+a45/zUuyznoI436V1akNgpFFlqGIqokmphTtBT+4axywA0VAR48GIPFA6obPWI3jVg8U1sn
	+cUYlozwv5S4Gz6tlJ+7nduxDwb737DHWsadlwLK6hcdDMSWarhhx/IK3/aN7i5lMZkL59zaFVV
	9IlqKL7U94v1D
X-Received: by 2002:a5d:64c4:0:b0:431:488:b9bc with SMTP id ffacd0b85a97d-4356a026502mr20090551f8f.10.1768919504597;
        Tue, 20 Jan 2026 06:31:44 -0800 (PST)
X-Received: by 2002:a5d:64c4:0:b0:431:488:b9bc with SMTP id ffacd0b85a97d-4356a026502mr20090480f8f.10.1768919504090;
        Tue, 20 Jan 2026 06:31:44 -0800 (PST)
Received: from [192.168.88.32] ([150.228.93.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356999810bsm29866110f8f.40.2026.01.20.06.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 06:31:43 -0800 (PST)
Message-ID: <001178f3-aea1-4886-92e9-1012ea6d6c76@redhat.com>
Date: Tue, 20 Jan 2026 15:31:38 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 15/16] quic: add packet builder base
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
References: <cover.1768489876.git.lucien.xin@gmail.com>
 <e4753dbdd12ca45edef6815830c1bd437bd635bf.1768489876.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <e4753dbdd12ca45edef6815830c1bd437bd635bf.1768489876.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/26 4:11 PM, Xin Long wrote:
> +static struct sk_buff *quic_packet_handshake_create(struct sock *sk)
> +{
> +	struct quic_packet *packet = quic_packet(sk);
> +	struct quic_frame *frame, *next;
> +
> +	/* Free all frames for now, and future patches will implement the actual creation logic. */
> +	list_for_each_entry_safe(frame, next, &packet->frame_list, list) {
> +		list_del(&frame->list);
> +		quic_frame_put(frame);

If you leave this function body empty and do the same for
quic_packet_app_create(), you could additionally strip patch 14 from
this series and avoid leaving several function defined there as unused.

/P

