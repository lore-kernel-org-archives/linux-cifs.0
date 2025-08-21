Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE61E343206
	for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783836; cv=none; b=bdMWyvSxpXrSRNzUYAd60VAchxAGCpOBCSZavQtE3oDwIfzUo7AK3+dCavVjs5+UJb9ZL8xUg/NyT+XFfZQ3e46RwwWY7Ij4pLB1MUaUbziwvO863fqjkgOWDi94KzsGE0HclgSzAufNFYEqoQrIsJqXXLvLwU+5qoEzaoMVs8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783836; c=relaxed/simple;
	bh=BGibils0ixKTkveWPcD3R9qfmRHuchZdAypt/Z4Xoac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KbOODTCq5LbABypgl0uCA10qp0zJsMO0fECtEhFTwFvY4kN4oQYXSEiksbYKgugkdHNtZEL8oQ/Z8VwlW0MTi1LhiL3/EtWr3BLvI06Whiad5R8Zk2oZYKeHNEiLlLXOGz7bsC+TgRL+jB4/UI4FNvpHdodO7MFihDKlb6c9hwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILE1z2hQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILE1z2hQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755783833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NEnox1MXYpI6nlTWn+1oQsX5BYXD1Viik97oVd+ziwk=;
	b=ILE1z2hQglBTXCUwe/yA5FZ+z0sw++N9HqSQAxj6TwqjLYICP/z5UQ+5qM8wrnPVmM3tvN
	ciieOUYWs4I7h9v6zb5ApsxtLcQfYZ5tEWEvXwCwV/1nU4kj2k9xcM4YjGvYe3LmK7d/iM
	08YjzTuS34p1nkw+UZY5OVfrLLWKJw8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-IyWbetTRO1mnRNom8eNJhA-1; Thu, 21 Aug 2025 09:43:52 -0400
X-MC-Unique: IyWbetTRO1mnRNom8eNJhA-1
X-Mimecast-MFC-AGG-ID: IyWbetTRO1mnRNom8eNJhA_1755783831
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05d31cso5297195e9.1
        for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 06:43:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755783831; x=1756388631;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NEnox1MXYpI6nlTWn+1oQsX5BYXD1Viik97oVd+ziwk=;
        b=uE/iG48eyzbFRGIL9aLF9kO54HBePMLBLuk5KnIyrWV9cYV9jRaZ8ezl32jLS+Cl3Y
         vQaqjBe5dKz4aiqJJ0QORGlEGc3f4vW7mZ0AfYKnS3vVkoVFsGRH6jp3M8M/5VKNtUXK
         zTrWNR8iit2Caf+E4DFXYaCa45aq/4r5d+6NjafWmPlRTaZOhX3Jm7a0SozHCPVMXWq3
         iZPDgQy4XSJyy99lwRARz0cR0bKQn9r8c/c/yK1ZcsCb1sb5raO+WppMu9A9G6LUzvGq
         ZxCqtEneEtZZaeSJbnav1abyt/6bkimViQ//0admyRcRx9HEBfVl1zZ3S7y3QXNQ+rlF
         BsVg==
X-Forwarded-Encrypted: i=1; AJvYcCUIt8kTZ1YAh88g0kTZJ7mY10Jts8MOAcd4eFAMJR/oCy+YWzTIOM6VJNv9KkautRu4EuoiGZzLtCMN@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3V20F5myy+MJlYCkgkno59gBy8wA+C/TEtBp5mgd45wCBPl7z
	x94/y/4ZlXPhjUlizGayBBDC6yiCEIxCeYe4ixVwaLE0gQULbSZ9o1V3vg5O1wTo8XoaoWkMkAr
	JVLFb2YtjKUgahVW0JlESXCyDFpfzKqydwBmeIazb+L2lsZsX1EaAfHRJJ0GWUNE=
X-Gm-Gg: ASbGnctv/QuwXWHoA/YiokahheYaWIbfd1ZBBpYTaTI4En1C7NvcI4eFD8uyiNEqpfW
	T+Jj5quHXcRmOgokkpxpjNb2kX++thmyXl4z/ACQ3nmksCRR5CwGxQFQPNGYNcJtYCfojGO4rJC
	TtQswTNhfey56wEUqAOx03Zg9ZvvW4HL91jmkHiafnHb1z5Fngp9qh3B702tmeWHFYriXcqwpZD
	ZVZV7XdM4jLBzvt28FfiTEbTmfSYIJuBt+MoAB1kUpOZZqlnvh/+4Wvf+yCJXBM56cFEO3NztqF
	S9cvwp1tfOZz25g0tkWttnhFOPkA6QTtD7UU+35sX7NvGpf2g1ACz0P6KysprRtU/eCyfF4R368
	xYhbVTfAaiPE=
X-Received: by 2002:a05:600c:1f1a:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-45b4d7dbb07mr19594165e9.13.1755783831008;
        Thu, 21 Aug 2025 06:43:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZRt0wLkKXdgUciFt7chGmSCzwh+L3c2yXfl6KumtYihELiZUeyXIBw0a4KRluTs9is/eX7g==
X-Received: by 2002:a05:600c:1f1a:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-45b4d7dbb07mr19593805e9.13.1755783830507;
        Thu, 21 Aug 2025 06:43:50 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c4568499ecsm3634615f8f.43.2025.08.21.06.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 06:43:50 -0700 (PDT)
Message-ID: <a79bfa8b-657f-4358-99f3-2774eb65d49f@redhat.com>
Date: Thu, 21 Aug 2025 15:43:47 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 06/15] quic: add stream management
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Benjamin Coddington <bcodding@redhat.com>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1755525878.git.lucien.xin@gmail.com>
 <a2cd3192c7f301a7370c223d23c9deefecda8a22.1755525878.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <a2cd3192c7f301a7370c223d23c9deefecda8a22.1755525878.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/18/25 4:04 PM, Xin Long wrote:
> +/* Check if a stream ID is valid for sending. */
> +static bool quic_stream_id_send(s64 stream_id, bool is_serv)
> +{
> +	u8 type = (stream_id & QUIC_STREAM_TYPE_MASK);
> +
> +	if (is_serv) {
> +		if (type == QUIC_STREAM_TYPE_CLIENT_UNI)
> +			return false;
> +	} else if (type == QUIC_STREAM_TYPE_SERVER_UNI) {
> +		return false;
> +	}
> +	return true;
> +}
> +
> +/* Check if a stream ID is valid for receiving. */
> +static bool quic_stream_id_recv(s64 stream_id, bool is_serv)
> +{
> +	u8 type = (stream_id & QUIC_STREAM_TYPE_MASK);
> +
> +	if (is_serv) {
> +		if (type == QUIC_STREAM_TYPE_SERVER_UNI)
> +			return false;
> +	} else if (type == QUIC_STREAM_TYPE_CLIENT_UNI) {
> +		return false;
> +	}
> +	return true;
> +}

The above two functions could be implemented using a common helper
saving some code duplication.

> +/* Create and register new streams for sending. */
> +static struct quic_stream *quic_stream_send_create(struct quic_stream_table *streams,
> +						   s64 max_stream_id, u8 is_serv)
> +{
> +	struct quic_stream *stream;
> +	s64 stream_id;
> +
> +	stream_id = streams->send.next_bidi_stream_id;
> +	if (quic_stream_id_uni(max_stream_id))
> +		stream_id = streams->send.next_uni_stream_id;
> +
> +	/* rfc9000#section-2.1: A stream ID that is used out of order results in all streams
> +	 * of that type with lower-numbered stream IDs also being opened.
> +	 */
> +	while (stream_id <= max_stream_id) {

Is wrap around thererically possible?
Who provided `max_stream_id`, the user-space? or a remote pear? what if
max_stream_id - stream_id is say 1M ?

[...]
> +/* Check if a receive stream ID is already closed. */
> +static bool quic_stream_id_recv_closed(struct quic_stream_table *streams, s64 stream_id)
> +{
> +	if (quic_stream_id_uni(stream_id)) {
> +		if (stream_id < streams->recv.next_uni_stream_id)
> +			return true;
> +	} else {
> +		if (stream_id < streams->recv.next_bidi_stream_id)
> +			return true;
> +	}
> +	return false;
> +}

I guess the above answer my previous questions, but I think that memory
accounting for stream allocation is still deserverd.

> +
> +/* Check if a receive stream ID exceeds would exceed local's limits. */
> +static bool quic_stream_id_recv_exceeds(struct quic_stream_table *streams, s64 stream_id)
> +{
> +	if (quic_stream_id_uni(stream_id)) {
> +		if (stream_id > streams->recv.max_uni_stream_id)
> +			return true;
> +	} else {
> +		if (stream_id > streams->recv.max_bidi_stream_id)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +/* Check if a send stream ID would exceed peer's limits. */
> +bool quic_stream_id_send_exceeds(struct quic_stream_table *streams, s64 stream_id)
> +{
> +	u64 nstreams;
> +
> +	if (quic_stream_id_uni(stream_id)) {
> +		if (stream_id > streams->send.max_uni_stream_id)
> +			return true;
> +	} else {
> +		if (stream_id > streams->send.max_bidi_stream_id)
> +			return true;
> +	}
> +
> +	if (quic_stream_id_uni(stream_id)) {
> +		stream_id -= streams->send.next_uni_stream_id;
> +		nstreams = quic_stream_id_to_streams(stream_id);
> +		if (nstreams + streams->send.streams_uni > streams->send.max_streams_uni)
> +			return true;
> +	} else {
> +		stream_id -= streams->send.next_bidi_stream_id;
> +		nstreams = quic_stream_id_to_streams(stream_id);
> +		if (nstreams + streams->send.streams_bidi > streams->send.max_streams_bidi)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +/* Get or create a send stream by ID. */
> +struct quic_stream *quic_stream_send_get(struct quic_stream_table *streams, s64 stream_id,
> +					 u32 flags, bool is_serv)
> +{
> +	struct quic_stream *stream;
> +
> +	if (!quic_stream_id_send(stream_id, is_serv))
> +		return ERR_PTR(-EINVAL);
> +
> +	stream = quic_stream_find(streams, stream_id);
> +	if (stream) {
> +		if ((flags & MSG_STREAM_NEW) &&
> +		    stream->send.state != QUIC_STREAM_SEND_STATE_READY)
> +			return ERR_PTR(-EINVAL);
> +		return stream;
> +	}
> +
> +	if (quic_stream_id_send_closed(streams, stream_id))
> +		return ERR_PTR(-ENOSTR);
> +
> +	if (!(flags & MSG_STREAM_NEW))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (quic_stream_id_send_exceeds(streams, stream_id))
> +		return ERR_PTR(-EAGAIN);
> +
> +	stream = quic_stream_send_create(streams, stream_id, is_serv);
> +	if (!stream)
> +		return ERR_PTR(-ENOSTR);
> +	streams->send.active_stream_id = stream_id;
> +	return stream;

There is no locking at all in lookup/add/remove. Lacking the caller of
such functions is hard to say if that is safe. You should add some info
about that in the commit message (or lock here ;)

/P

