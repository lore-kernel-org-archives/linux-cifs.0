Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3AA205E02
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 12:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769689999; cv=none; b=QdJ+GkunEGTA4LVC/6dyDc9Y6KpMN8EjnvXjHPSu/HAfAKygZLJWwGMe5TB9T58l5mBMHWjw9EisB3q5FwROm+b/BAfjACcdor386RUVxdFSlC7GlLwWUvFxm1yYHZ54+AwKpE+bzHNb4JMDn66i8NiMGPWopRL21CTXf8YKlVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769689999; c=relaxed/simple;
	bh=40wMWG7SyPMSzabUx/Wcz8EBhiLCqDenQlqMLv7YPuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MriY5H4IxHqn/sD4Ev+YjPYlOl/BFNx6FnTPNjFptRxoTGXUDpDj2SieOaHy0o4W8IlwQGIPtpR5CLTCcjmcGtHSus3SlOwidoNRvHo6XmsZtf74KPe8Av42hv7gUNsm12n2s4N4P5PLub/v/i+akJ0Jub2OAkST578iaUOpPas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JRc05ImU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mk9aURxJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JRc05ImU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mk9aURxJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769689997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mRy+y1wqapOxzHZCLfyA/JeLGF66Z2ABQ1elBTYnVS4=;
	b=JRc05ImU/vL7Pjtmmk7Kr2D9muuhAEyVDQtzt4+kPIndEj0xufFgIq8L/gCVrFVHciDxBQ
	9nBC036TOivqMXPwSLiiTId9W+QR0603gUYxn8fF2qqLYiXDwttaONCvJE9+G7dM1YsBVe
	fAFsyREbeeKR5PpvIvd+vVbjsPzqAuQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-ZJ-ogZjGO72X9cJwfv5b6g-1; Thu, 29 Jan 2026 07:33:16 -0500
X-MC-Unique: ZJ-ogZjGO72X9cJwfv5b6g-1
X-Mimecast-MFC-AGG-ID: ZJ-ogZjGO72X9cJwfv5b6g_1769689995
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4325b81081aso1712880f8f.3
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 04:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769689995; x=1770294795; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mRy+y1wqapOxzHZCLfyA/JeLGF66Z2ABQ1elBTYnVS4=;
        b=mk9aURxJGV5Dq4HkjScpt28cZRFybtpaKsqvMq86MJGFicSZRH7U2kHlKCkhNFYYY4
         TypZ+qGfVPLUC0BgfhQWUGmeTWzGHMM8/VZIWOKVqGCP2PWWIksfNXGBCVXh0fztblYe
         jHi0+rWjU4yOv3YW7r5etnAxQAZCpDt5VoQALw5XBkkf9wmTDchKHvl6awpZgijVA0rx
         8aKx4MxlaO1Nju0G/lHYYloQhaH+UJY658JHbUgCI50FcIJkAyoRDcDv0wjLRQwZC1io
         isHZFBRRbLZqDS6GJ1rYYtEO3mFoCGklfO54RfMMkDpf5PPBrRHt4VUHTkbGphHFtY2P
         sW7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769689995; x=1770294795;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mRy+y1wqapOxzHZCLfyA/JeLGF66Z2ABQ1elBTYnVS4=;
        b=B6kO+mRnme8OGRR3uL7gPJnX1vxq50ZqIXE59qymLatmro5SbRS6MfIdm5aPwcGfFD
         qsd+qthqmbXMXOpmee+1TXgo3AaBU84JqFFFhHoEXKhA7wGc495v/kp0aZy318tPFman
         4RNUnO/suatQC2ez+DveDvc+kKA1Jkwnnd7wkKhskTG5MLB6HwxTRNYKES2ehXl6wcDu
         Jl1aU1RLOpyWuXxrFvSy6H/Zs3sMaP/L9pnkD1VXgDy4nZTp9w/HpJKXdTk17h5wnpHv
         kkdEn7bXR77ihGoVvoMbR49LYbwmotn5mT3o4JQWDtGmAbSg6aIGKN9xl2adHpLXKjkF
         M6Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXlP8EA25ObCyRlw5VwvbPj8dL9BYLTacYRGAA49h370aMmUbo9Pm4sMXmR9cWalBYQOBfyldxPBA7V@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpl+LiS3KQ0oLHguIHvAXX5t7WAsVNsHo16VlKKK7lOJ+Ud36T
	aZvNlm7CiKIyD5AK5wNAE/70VnxYZ3DHceVYEIPNeZXLIeUzktx4GFnUtk1Rkeun3VJ4pKAs1eb
	cwl9NZaet+UQRXXRfAUt3K6yXaHnR3UkHVHQ8xpiycUJziAIWZcRd3gyoimgt9xY=
X-Gm-Gg: AZuq6aLrbNz6nCQTYM+dBzvTbv0Xt3numkEz1B205rdDkVX/Cg3Xjh9a5xveH+9KOv0
	RfjoeHy2+6JCS7oPVTfWkkPZsajePX9GbQSy3akQiNQAs5N7z4Z5Zyml5Rh3S2mUq81vp+KI/Mv
	cs1UpotTnafimtRLhXrHXfwOcZOxFPme04hbV+PSMkgrfMF5tZ3bFQ6taE4UTsEqVPycT1mBTxb
	uwmdbZwYzBJqipQfNCT900N2Hju7w/a3QPsuyRA25vqbtLXwJ2UBCcIdz5aTL6V0TR6fMfBNmmS
	D99S32YsanMIzxez2MB09Q+rTMFSwWrjIEwreMmlopAOx370OZiGb3pS/InJHIgDwRa9YLK91Q1
	Ht37yVUzPquDG
X-Received: by 2002:a05:6000:22c9:b0:435:9882:234e with SMTP id ffacd0b85a97d-435dd1d8e62mr10552718f8f.59.1769689994903;
        Thu, 29 Jan 2026 04:33:14 -0800 (PST)
X-Received: by 2002:a05:6000:22c9:b0:435:9882:234e with SMTP id ffacd0b85a97d-435dd1d8e62mr10552677f8f.59.1769689994350;
        Thu, 29 Jan 2026 04:33:14 -0800 (PST)
Received: from [192.168.88.32] ([212.105.153.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e132356dsm15075716f8f.33.2026.01.29.04.33.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jan 2026 04:33:13 -0800 (PST)
Message-ID: <9621f01f-5c89-4d13-9997-b4066b7e9d16@redhat.com>
Date: Thu, 29 Jan 2026 13:33:11 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 07/15] quic: add connection id management
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
References: <cover.1769439073.git.lucien.xin@gmail.com>
 <ad730679ce27da0886104546a3d327b5fb653340.1769439073.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <ad730679ce27da0886104546a3d327b5fb653340.1769439073.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/26/26 3:51 PM, Xin Long wrote:
> This patch introduces 'struct quic_conn_id_set' for managing Connection
> IDs (CIDs), which are represented by 'struct quic_source_conn_id'
> and 'struct quic_dest_conn_id'.
> 
> It provides helpers to add and remove CIDs from the set, and handles
> insertion of source CIDs into the global connection ID hash table
> when necessary.
> 
> - quic_conn_id_add(): Add a new Connection ID to the set, and inserts
>   it to conn_id hash table if it is a source conn_id.
> 
> - quic_conn_id_remove(): Remove connection IDs the set with sequence
>   numbers less than or equal to a number.
> 
> It also adds utilities to look up CIDs by value or sequence number,
> search the global hash table for incoming packets, and check for
> stateless reset tokens among destination CIDs. These functions are
> essential for RX path connection lookup and stateless reset processing.
> 
> - quic_conn_id_find(): Find a Connection ID in the set by seq number.
> 
> - quic_conn_id_lookup(): Lookup a Connection ID from global hash table
>   using the ID value, typically used for socket lookup on the RX path.
> 
> - quic_conn_id_token_exists(): Check if a stateless reset token exists
>   in any dest Connection ID (used during stateless reset processing).
> 
> Note source/dest conn_id set is per socket, the operations on it are
> always pretected by the sock lock.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Paolo Abeni <pabeni@redhat.com>

