Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE6B2DCF77
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758816218; cv=none; b=be/eNIUlBZzjOXcoOR44OiDAOon6yDnLnlKdPGUS33VQStJo8M5tAKx9DbW4jbRsRjPeVwXZaWDm1OqUcwJM33QxaYmw8zw9TaSiUbgaROgu7Grwzxee5RXMBg2rrLFAIbC6/Fl4R/XJPYcOYY3a23P7vhEggr7sr7ubpAMfaMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758816218; c=relaxed/simple;
	bh=HnJd+NrxTuygtcASib599tdU6VkNGVSgK79JCOZW6fM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uC/y6iwavLSHEBz3OC7VfoVP9fTyo1UBTVArqjm6ush0ujrgL7c29WkOidImUSVjIP176KfoeJ914KtuOha5b92We6KOU4jKYUKI5RGPahUQ3/3oHvRuZTFoscIjBwaAbKoastJl9lcoYGpP5ORlpCzEMEmvB4WonHgYvxYC7QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jDE+DrA4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jDE+DrA4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758816215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lAAu2rvXua1onNC9vVWcLt9JR4YNW3IhkSLkwQw3+yc=;
	b=jDE+DrA4dNC/B06GwU0Kxy6xzWSH1n9qTb5fFc2wJAhcqvfAfbDcEZHBvfdAv/w3MSa1Fi
	M9unvYCtn2DsMR81xaU1K4PBwz22CL8jZ71JQ717N6XZipIQP6qLh4pGBSHAQdeYNJhnUy
	7fnwiWo2VHMt6bSHUwWBtvE+EpgJz4c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-kl9G-Nr6Mti-QTAi4F5bqw-1; Thu, 25 Sep 2025 12:03:31 -0400
X-MC-Unique: kl9G-Nr6Mti-QTAi4F5bqw-1
X-Mimecast-MFC-AGG-ID: kl9G-Nr6Mti-QTAi4F5bqw_1758816210
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f3c118cbb3so787706f8f.3
        for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 09:03:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758816210; x=1759421010;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lAAu2rvXua1onNC9vVWcLt9JR4YNW3IhkSLkwQw3+yc=;
        b=dhfCBf+ch1eNtB5c+dqwabdo5OcSlyQ8B/Lnsxx/nocz0od4p3tnJeAz0N3+n36Y3w
         3JZo/q8hheB8X+AziTBWN+vdw0oJkpS0fEpmY3ogbcaKGvTsT/1uoofUIgdK9uNYY672
         iMasxv1Oz3hnsJLBOsLHm0lqY2JryxsCOYSauvhWkjDsfv5v2goXPOCBicvS9D6jce77
         z1SrV+kegBHOiEb7Aas332ljZ0htwvKU4/snuE+mEaSiXPvkiJsvrPyP/YJ6z9fjsTDe
         PwajjGIVmVETjlUGdIhcUaIOncfWC80ApXz0+Ms5PUtxV+HQBX8640dA2pCaZhVLITqs
         /jfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHhRZJ2M2dr/F/WpYCUELA21aYh7x18Clrvglt+D/M/vj/FyQgVRk9XJLp2hv7KZdWm22i/upXnOv/@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8iUO7V40w57kkVh0+8P+Dmcwae9aYhrymah3iAbKi9i5QVK/Q
	q0kd/UP7pbdV0qQKD1Brrq9kt/g/jhNQqSgPAjxBr4tWHmSa7a4uw8wZgOlqKes+5C8PeUucJSE
	lEkpHQG/FoBM7B+YY/RywygNOncxoDYVtl28tzCzzqX9L169JOqxHtSvBpfuU/8o=
X-Gm-Gg: ASbGncuoJHcCLIvjQNRaXQR3oq6fqEvBN9VSrk6VIfJK+h86Hn1ybqYHaPkN/HsSgkg
	EmKvKBw9i0BL4GWlUD7GXu9T0ZGN1AjgyNblpByNVSTSje7WR5Cc2TojvTYWwF88yiM4QCFt+wv
	usdWFbpDr5pvL+qDaclxMJeVtWvCFCghjpIN7eL8dwbsFuExhaRMUBuAwWojkvjx3LErmjpn12A
	POWG2StR1Tb5/k1rsWxVt2ssHwt9YmDevXwoDgruoi1CbmIHiebzUiP1rB8hFL3KTXDcPesw1Gn
	h1WHjbM41emGcSZqWoi8f+3b9WcyaBw8/AGRQrccicrEayzGit3JSrL1t3YWze5MCuBK6EtThEd
	cOp836DARjhF6
X-Received: by 2002:a05:6000:1866:b0:3eb:6c82:bb27 with SMTP id ffacd0b85a97d-40e4accc83dmr3283217f8f.61.1758816210043;
        Thu, 25 Sep 2025 09:03:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEolKtk07hzt/nAdhndezZGEyI0DNBNdQSNglyCE4zJD/NsrvHDr7kmZq4QCjzgvNjUhL530Q==
X-Received: by 2002:a05:6000:1866:b0:3eb:6c82:bb27 with SMTP id ffacd0b85a97d-40e4accc83dmr3283173f8f.61.1758816209543;
        Thu, 25 Sep 2025 09:03:29 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9ac55esm91746695e9.6.2025.09.25.09.03.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 09:03:28 -0700 (PDT)
Message-ID: <f89701ce-839e-4032-bb1d-40fb1b67cb70@redhat.com>
Date: Thu, 25 Sep 2025 18:03:26 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 06/15] quic: add stream management
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
 davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Benjamin Coddington <bcodding@redhat.com>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1758234904.git.lucien.xin@gmail.com>
 <5d71a793a5f6e85160748ed30539b98d2629c5ac.1758234904.git.lucien.xin@gmail.com>
 <2ef635de-7282-4ffe-bdfc-eceafa73857e@redhat.com>
 <CADvbK_fE1KHbgtZV4zY1xXo94avimgxBcoakyoAYPOsb-U3rSw@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CADvbK_fE1KHbgtZV4zY1xXo94avimgxBcoakyoAYPOsb-U3rSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/23/25 7:57 PM, Xin Long wrote:
> On Tue, Sep 23, 2025 at 9:39 AM Paolo Abeni <pabeni@redhat.com> wrote:
>> On 9/19/25 12:34 AM, Xin Long wrote:
>>> +/* Create and register new streams for sending. */
>>> +static struct quic_stream *quic_stream_send_create(struct quic_stream_table *streams,
>>> +                                                s64 max_stream_id, u8 is_serv)
>>> +{
>>> +     struct quic_stream *stream;
>>> +     s64 stream_id;
>>> +
>>> +     stream_id = streams->send.next_bidi_stream_id;
>>> +     if (quic_stream_id_uni(max_stream_id))
>>> +             stream_id = streams->send.next_uni_stream_id;
>>> +
>>> +     /* rfc9000#section-2.1: A stream ID that is used out of order results in all streams
>>> +      * of that type with lower-numbered stream IDs also being opened.
>>> +      */
>>> +     while (stream_id <= max_stream_id) {
>>> +             stream = kzalloc(sizeof(*stream), GFP_KERNEL);
>>> +             if (!stream)
>>> +                     return NULL;
>>
>> How many streams and connections ID do you foresee per socket? Could
>> such number grow significantly (possibly under misuse/attack)? If so you
>> you likely use GFP_KERNEL_ACCOUNT here (and in conn_id allocation).
> connections ID: 8 (QUIC_CONN_ID_LIMIT) at most per socket.
> streams: 4096 (QUIC_MAX_STREAMS) at most per socket.

Will such limit fit a (very) busy server? I guess it's more a question
those who already run quic workload at scale...

> I can switch to GFP_KERNEL_ACCOUNT in quic_stream_send_create().
> 
> For quic_stream_recv_create(), it’s typically invoked in atomic context.
> Since there’s no predefined GFP_ATOMIC_ACCOUNT, I assume using
> (GFP_ATOMIC | __GFP_ACCOUNT) should be acceptable.

I see there are already a few other allocations using such flags, and I
could not find any explicit limitation/drawback for it. I hope it's not
just cargo cult programming :-P

/P

