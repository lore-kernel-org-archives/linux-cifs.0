Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3703ACA4F
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 12:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768912322; cv=none; b=d7Y7tIJ1rLml0Qi1ydJoWHgw+iUoiKW0oaUUPg/GRLwuesUWo1w/CxBD/PO3eeZq4N1NNHlG3MzFDZm52TObnIT24v2dhz+oy0eEPvde1+RpthUwUq2huEsKE6EngsKuyG2sKPqnKtKNPSuD+XFAOmE0DRrOt0O5XnCDmwStUYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768912322; c=relaxed/simple;
	bh=ybwnOstUjbTzU+WNVQkpG7oSIktyn6VBM0meydYghk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q2k2QhFe9k7Rq/7SLRlysJ7urT7rg+ETdaVs4DLIxCzNXHtlLAWdgM2NXxV/n3d87sEK5+ur4lbXj5hzo04FxNs5yJ+R1yDHGOZCThX5uGjXa0ckD+Z0ox1I2eLb9w06dxq7y5l+MfVu/X3x1bEdCcAWZ8kAsQmvuSPVrGcJUuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hacCEu4s; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kjTJZQhI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hacCEu4s";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kjTJZQhI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768912320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVch8b9/GI7xCZGgBVtwu4LokFmMKHsdozmzzKNxN0A=;
	b=hacCEu4sgWKALO50RQxlihNkrz3A1Yl71t5wddA0AZqTvkoss1NWEU6XR9hKtrhN+qzFNJ
	WIk1+sO0vpYa4m6pepin2b+VBJ3pc3p7CPzTe20JcxU4lcIyxNOPqacN8EXTRxHe/hmN76
	maESj7DGlF7D+uXOfd3u60lrxI+O6Wk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-kps05jteNGKlUJFNUxtPGw-1; Tue, 20 Jan 2026 07:31:58 -0500
X-MC-Unique: kps05jteNGKlUJFNUxtPGw-1
X-Mimecast-MFC-AGG-ID: kps05jteNGKlUJFNUxtPGw_1768912318
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47ed980309aso29409215e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 04:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768912317; x=1769517117; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VVch8b9/GI7xCZGgBVtwu4LokFmMKHsdozmzzKNxN0A=;
        b=kjTJZQhIJcq5Xm3R5qWYSnGn0BkP5gqBu59wG78uUyrppPUuZZpIviXH5yuREVMH0/
         kwFkHUhocE4I307LnEuwYaBvvgL2zTuYbUBA3XQp5xcv8WbsXOgO1jXg81+7lcRcl5Fu
         7DRWc5qzkBqQySCaI1NrTZ1G8fl9YRjbxlU2EzcvTUFBXqJZ/r4w9UjhGJZp8iGETQfB
         pH97SzNPJQ1GiGJE5TxJzdA0tVxwSPV1HGZsSFIQDYEXQBYNdW0+M9B8FG4fSEHbDueJ
         71eItYEyazS8I3nVG+IAUkN7F/KqZc57+RIBXPXgbued2H8SOLizzYq6rRUPKlaMUkyx
         A+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768912317; x=1769517117;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VVch8b9/GI7xCZGgBVtwu4LokFmMKHsdozmzzKNxN0A=;
        b=b+exfYFsK/DF/mALUlU/nY7i3acmOHbynRbvbtD3uYTKf/UsQzuMmL5J8amulQb2wX
         ygXqEklR4efNmsYg410M72pgBaRvP53/5oyHxT83Phm5SJre9/ItrCfj99rl77vkalfO
         WUODRoJSeOOkX90yS2lHaTLZqYWxTVwZJNMnjtAdm2BW5C5HzoXcFhPffJvDDkK4tPqC
         CVvIpSPI6sgzi9I0Msug5YFja/nUE1WijzeXOH9c3aQpHniCFlgIKj4duBP4bDHh2eg+
         FKTjIq329qQv2HV67wkcyzRBHmomvfQerAHUVbuRhuCbKObil9QwaQqKiJg8Aaq/eFwB
         Wf3g==
X-Forwarded-Encrypted: i=1; AJvYcCWyoTvNOUeBPiqUddRJm9g3U0wT/TJIG56e/xs9tVYcXshb75GZ/lr7xC1cHsqsx6Fh4lteBnmoZX9o@vger.kernel.org
X-Gm-Message-State: AOJu0Yw15MMrF1kPMYTU1Hc5i5m3jx9+lpKz537NrP9nig96ccaeJ3Ur
	HO5WkVSxSPTCLRb6S6d18f6Dp4DV0xYutM9wT4Ul79YLx3/Yp08JLHtq1G0vWPXBWs0LMtaZ1Zc
	ShMjERLEDAqXY9Pr3zgL4k60/W+0cIIlC4EkPo/IMtGCMcZewG5XaE0qfiwlvLys=
X-Gm-Gg: AY/fxX6j/C8oqX0L6JyNM1LmjfWhyJxFHcll39tdx1zhbqN/exSBfDX5IzWbMOlPz4N
	LBPqLcRZIgU0jFjAHg7ezH9+uNMQrCw4/4QMeZBNChqDp2+WRcETCnlU0S9WWihElvMj1CAXx1I
	pzQrvPNkFyy2h894Ed6pSNYY4NeiyV+WxKX8JFhbaUhSbSB9TccE5F/SeDnZmTLZ02xXlUV00/0
	kxDtifAp9rR59d8y7x+g4I5u//cl8uHjlQU5ulLrv7r9La7KikkXz+b5YuYeaPoXAaP9XYgSgMq
	NsSj+x3+Y5FrPhb3RNpp1adUCCIMgrdR4jGcHqKFyBvbI4b7TAEhSrCKQ+IUseYCklGgC6FGg9Z
	3RlB/f6cB3B7T
X-Received: by 2002:a05:600d:2388:b0:47e:e7de:7c41 with SMTP id 5b1f17b1804b1-47f44d4ca19mr138285055e9.16.1768912317559;
        Tue, 20 Jan 2026 04:31:57 -0800 (PST)
X-Received: by 2002:a05:600d:2388:b0:47e:e7de:7c41 with SMTP id 5b1f17b1804b1-47f44d4ca19mr138284545e9.16.1768912317054;
        Tue, 20 Jan 2026 04:31:57 -0800 (PST)
Received: from [192.168.88.32] ([150.228.93.113])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4289b7aasm306886765e9.2.2026.01.20.04.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 04:31:56 -0800 (PST)
Message-ID: <6c6d5644-3354-46ba-bbc9-e76789648abf@redhat.com>
Date: Tue, 20 Jan 2026 13:31:51 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 06/16] quic: add stream management
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
 <e3f770ef8d9aba101e1f5dc2f2f72bb0d2a30b94.1768489876.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <e3f770ef8d9aba101e1f5dc2f2f72bb0d2a30b94.1768489876.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/26 4:11 PM, Xin Long wrote:
> +struct quic_stream {
> +	struct hlist_node node;
> +	s64 id;				/* Stream ID as defined in RFC 9000 Section 2.1 */
> +	struct {
> +		/* Sending-side stream level flow control */
> +		u64 last_max_bytes;	/* Maximum send offset advertised by peer at last update */
> +		u64 max_bytes;		/* Current maximum offset we are allowed to send to */
> +		u64 bytes;		/* Bytes already sent to peer */
> +
> +		u32 errcode;		/* Application error code to send in RESET_STREAM */
> +		u32 frags;		/* Number of sent STREAM frames not yet acknowledged */
> +		u8 state;		/* Send stream state, per rfc9000#section-3.1 */
> +
> +		u8 data_blocked:1;	/* True if flow control blocks sending more data */
> +		u8 done:1;		/* True if application indicated end of stream (FIN sent) */

Minor nit: AFAICS with the current struct layout the bitfield above does
not save any space, compared to plain u8 and will lead to worse code.

> +	} send;
> +	struct {
> +		/* Receiving-side stream level flow control */
> +		u64 max_bytes;		/* Maximum offset peer is allowed to send to */
> +		u64 window;		/* Remaining receive window before advertise a new limit */
> +		u64 bytes;		/* Bytes consumed by application from the stream */
> +
> +		u64 highest;		/* Highest received offset */
> +		u64 offset;		/* Offset up to which data is in buffer or consumed */
> +		u64 finalsz;		/* Final size of the stream if FIN received */
> +
> +		u32 frags;		/* Number of received STREAM frames pending reassembly */
> +		u8 state;		/* Receive stream state, per rfc9000#section-3.2 */
> +
> +		u8 stop_sent:1;		/* True if STOP_SENDING has been sent */
> +		u8 done:1;		/* True if FIN received and final size validated */

... same here...

> +	} recv;
> +};
> +
> +struct quic_stream_limits {
> +	/* Stream limit parameters defined in rfc9000#section-18.2 */
> +	u64 max_stream_data_bidi_remote;	/* initial_max_stream_data_bidi_remote */
> +	u64 max_stream_data_bidi_local;		/* initial_max_stream_data_bidi_local */
> +	u64 max_stream_data_uni;		/* initial_max_stream_data_uni */
> +	u64 max_streams_bidi;			/* initial_max_streams_bidi */
> +	u64 max_streams_uni;			/* initial_max_streams_uni */
> +
> +	s64 next_bidi_stream_id;	/* Next bidi stream ID to open or accept */
> +	s64 next_uni_stream_id;		/* Next uni stream ID to open or accept */
> +	s64 max_bidi_stream_id;		/* Highest allowed bidi stream ID */
> +	s64 max_uni_stream_id;		/* Highest allowed uni stream ID */
> +	s64 active_stream_id;		/* Most recently opened stream ID */
> +
> +	u8 bidi_blocked:1;	/* STREAMS_BLOCKED_BIDI sent, awaiting ACK */
> +	u8 uni_blocked:1;	/* STREAMS_BLOCKED_UNI sent, awaiting ACK */
> +	u8 bidi_pending:1;	/* MAX_STREAMS_BIDI needs to be sent */
> +	u8 uni_pending:1;	/* MAX_STREAMS_UNI needs to be sent */

... and here.

Other than that LGTM. With the bitfield replaced with plain u8 feel free
to add my

Acked-by: Paolo Abeni <pabeni@redhat.com>

