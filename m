Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578A1327A02
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 13:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758634755; cv=none; b=ZHvarsVqwrqAxfe1TCDWH6gUGcxc7SXtfSv5qKDbH//ZtlORCYe2/YD6wZxO3cnLGDZExvpEBTxM3q+QKM48EgQFieAMN0lMMNjtGOVoBzMkZAS3aF5rwmzB1IztZBjzKt+W5j+hsK+l/zreq/8Nn/KBI7hfGJ9kL/TUUkL/7oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758634755; c=relaxed/simple;
	bh=HE+DzSG/06drWnNkU0X2CeXDBVHUeLbRW6PSZ9GVmh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K55XsIXwmNM9pJQShGY8n/bAypiMSFM3wvvX2cbrywBn44ZC/qGtPJgUJt3RaP4TzX0qTMy/treBFuPZs37DXLKaHDwVvlqVfUDl1ArKQ53vDzcODz2wqop+7lv8EsBrIPkt1ii3xA6t4k4hT9DzwuKsxUjXECQWJ/kKnFJSzsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ize43+mZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ize43+mZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758634751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YUFfenxYIM+PGGS2NHWViejB6uf1Wuvcw12DaW18/Eg=;
	b=Ize43+mZeloLi2bVezfKr+8Vx+OY9KRtRvPhtJG8kY7AyllUIpp/i96dScZuNgnuKv/Z3Y
	/sVcLSn4s+fXgWvKL7VWf2tddl0OavsCSiXZE9VocOx/nMOtEYpzxzEg7OPMJW0cRU9XFE
	ds7SknXM/2RX1nEXTQzYU9UpDHgskok=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-lIOiGT7IMFii0eSHR_kJ1A-1; Tue, 23 Sep 2025 09:39:10 -0400
X-MC-Unique: lIOiGT7IMFii0eSHR_kJ1A-1
X-Mimecast-MFC-AGG-ID: lIOiGT7IMFii0eSHR_kJ1A_1758634749
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ece14b9231so2739759f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 06:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758634749; x=1759239549;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YUFfenxYIM+PGGS2NHWViejB6uf1Wuvcw12DaW18/Eg=;
        b=gMQbgd3VEHNIKanZAJiFkBDhrAo8Vtv8B4fyvlxc/xMphP7IgKttxG2//EFVh9FJr1
         Mzp3Z9KzPhEQpoFdkJkzLFDPcwvmLIq5WyMu6X7Lew6FeZsonmKo11+7t1YVGI072Q2a
         17hMw/ktgIKx5A5nEOkgHDj79Ht92Xf80yathgf60zRItiQemP47rjoC98abxqU6O941
         RnVQ3sQBTFA+T7arisub81jH4RMq1+fP0a5qGcXrcVo6W7rxLoyMT6sY8znzBaksP87/
         pGoMNmCaCvLBs+5R/peHXZHCCSXpFxFP+GQ91UKfhyw4kcH+rbzsO2jzmrj/S2JWv9vF
         mw8w==
X-Forwarded-Encrypted: i=1; AJvYcCXcUEbLM4QmEqir1lzMuVJhXn5Qi43CoepuGyHv225ooHSvfwWItMHEB11ol2gs2znL0x9yt7iBtOXc@vger.kernel.org
X-Gm-Message-State: AOJu0YySnhe7AGQK3abuYH0kU3Or+0TFjwCES7ZKbokuldvc6FdNvLvy
	rE1I+ptZ1cXnNKVyPw9zakBfK+DiFKPlqWkzXlcd9kEpo4UMArjG4Cb4JKa3s7/kHCFQQ/p6RvP
	sllRBr87wD37Hw0D7fA8QOI5gpVu3J8S4PemDmJRxmkdf1uvVocfwtj7YX/PrxZE=
X-Gm-Gg: ASbGncu21CTzD1LMpEgAAVlFhk3eOB30grzkYbgnAb/Uz0SXS4A7YwA2OjAzF7LTuWs
	s27UnapQ+w1Ld22zhxBnNu2fEemJA6dQ76dVD90Z1Q3osbFD1c3lKDbhfA5jLAGdXUSDaxDbOnn
	UrTEkzScozQfRZTdrFBlf3O+QSU9rlyzYvyl+Ss9qFmicbiG//XG/9MHuEsamVxKjwZ0ia3sKk6
	tQfazx8SqDjxg1o9QxETvRCzVxfr/mFBaSl0yipk4f9PKjk1M0TQqYpUBrK7F/2Dwr6JChRPOdd
	tmjM/nHgK7eAfB7Mp4bv8IZTygR+wwc4f+S5xpTKmtAmQB1r1Mt/JZbZJPyevCCTfrLUpOGHKQ3
	Wbrn3SETXEapO
X-Received: by 2002:a05:6000:268a:b0:3ec:75c0:9cf5 with SMTP id ffacd0b85a97d-405ca95a7e4mr1847651f8f.47.1758634748346;
        Tue, 23 Sep 2025 06:39:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLty5Sh2dVepbf39FSNvfF6DWjptmBDkYQRwbxXNzmvlAzSia+6WsgmnolLHWJbaOETPc1MA==
X-Received: by 2002:a05:6000:268a:b0:3ec:75c0:9cf5 with SMTP id ffacd0b85a97d-405ca95a7e4mr1847607f8f.47.1758634747659;
        Tue, 23 Sep 2025 06:39:07 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0740841dsm24102086f8f.23.2025.09.23.06.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 06:39:07 -0700 (PDT)
Message-ID: <2ef635de-7282-4ffe-bdfc-eceafa73857e@redhat.com>
Date: Tue, 23 Sep 2025 15:39:04 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 06/15] quic: add stream management
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
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
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1758234904.git.lucien.xin@gmail.com>
 <5d71a793a5f6e85160748ed30539b98d2629c5ac.1758234904.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <5d71a793a5f6e85160748ed30539b98d2629c5ac.1758234904.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/25 12:34 AM, Xin Long wrote:
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
> +		stream = kzalloc(sizeof(*stream), GFP_KERNEL);
> +		if (!stream)
> +			return NULL;

How many streams and connections ID do you foresee per socket? Could
such number grow significantly (possibly under misuse/attack)? If so you
you likely use GFP_KERNEL_ACCOUNT here (and in conn_id allocation).

/P

> +
> +		stream->id = stream_id;
> +		if (quic_stream_id_uni(stream_id)) {
> +			stream->send.max_bytes = streams->send.max_stream_data_uni;
> +
> +			if (streams->send.next_uni_stream_id < stream_id + QUIC_STREAM_ID_STEP)
> +				streams->send.next_uni_stream_id = stream_id + QUIC_STREAM_ID_STEP;
> +			streams->send.streams_uni++;
> +
> +			quic_stream_add(streams, stream);
> +			stream_id += QUIC_STREAM_ID_STEP;
> +			continue;
> +		}
> +
> +		if (streams->send.next_bidi_stream_id < stream_id + QUIC_STREAM_ID_STEP)
> +			streams->send.next_bidi_stream_id = stream_id + QUIC_STREAM_ID_STEP;
> +		streams->send.streams_bidi++;
> +
> +		if (quic_stream_id_local(stream_id, is_serv)) {
> +			stream->send.max_bytes = streams->send.max_stream_data_bidi_remote;
> +			stream->recv.max_bytes = streams->recv.max_stream_data_bidi_local;
> +		} else {
> +			stream->send.max_bytes = streams->send.max_stream_data_bidi_local;
> +			stream->recv.max_bytes = streams->recv.max_stream_data_bidi_remote;
> +		}
> +		stream->recv.window = stream->recv.max_bytes;
> +
> +		quic_stream_add(streams, stream);
> +		stream_id += QUIC_STREAM_ID_STEP;
> +	}
> +	return stream;
> +}
> +
> +/* Create and register new streams for receiving. */
> +static struct quic_stream *quic_stream_recv_create(struct quic_stream_table *streams,
> +						   s64 max_stream_id, u8 is_serv)
> +{
> +	struct quic_stream *stream;
> +	s64 stream_id;
> +
> +	stream_id = streams->recv.next_bidi_stream_id;
> +	if (quic_stream_id_uni(max_stream_id))
> +		stream_id = streams->recv.next_uni_stream_id;
> +
> +	/* rfc9000#section-2.1: A stream ID that is used out of order results in all streams
> +	 * of that type with lower-numbered stream IDs also being opened.
> +	 */
> +	while (stream_id <= max_stream_id) {
> +		stream = kzalloc(sizeof(*stream), GFP_ATOMIC);
> +		if (!stream)
> +			return NULL;
> +
> +		stream->id = stream_id;
> +		if (quic_stream_id_uni(stream_id)) {
> +			stream->recv.window = streams->recv.max_stream_data_uni;
> +			stream->recv.max_bytes = stream->recv.window;
> +
> +			if (streams->recv.next_uni_stream_id < stream_id + QUIC_STREAM_ID_STEP)
> +				streams->recv.next_uni_stream_id = stream_id + QUIC_STREAM_ID_STEP;
> +			streams->recv.streams_uni++;
> +
> +			quic_stream_add(streams, stream);
> +			stream_id += QUIC_STREAM_ID_STEP;
> +			continue;
> +		}
> +
> +		if (streams->recv.next_bidi_stream_id < stream_id + QUIC_STREAM_ID_STEP)
> +			streams->recv.next_bidi_stream_id = stream_id + QUIC_STREAM_ID_STEP;
> +		streams->recv.streams_bidi++;
> +
> +		if (quic_stream_id_local(stream_id, is_serv)) {
> +			stream->send.max_bytes = streams->send.max_stream_data_bidi_remote;
> +			stream->recv.max_bytes = streams->recv.max_stream_data_bidi_local;
> +		} else {
> +			stream->send.max_bytes = streams->send.max_stream_data_bidi_local;
> +			stream->recv.max_bytes = streams->recv.max_stream_data_bidi_remote;
> +		}
> +		stream->recv.window = stream->recv.max_bytes;
> +
> +		quic_stream_add(streams, stream);
> +		stream_id += QUIC_STREAM_ID_STEP;
> +	}
> +	return stream;
> +}
> +
> +/* Check if a send or receive stream ID is already closed. */
> +static bool quic_stream_id_closed(struct quic_stream_table *streams, s64 stream_id, bool send)
> +{
> +	if (quic_stream_id_uni(stream_id)) {
> +		if (send)
> +			return stream_id < streams->send.next_uni_stream_id;
> +		return stream_id < streams->recv.next_uni_stream_id;
> +	}
> +	if (send)
> +		return stream_id < streams->send.next_bidi_stream_id;
> +	return stream_id < streams->recv.next_bidi_stream_id;
> +}
> +
> +/* Check if a stream ID would exceed local (recv) or peer (send) limits. */
> +bool quic_stream_id_exceeds(struct quic_stream_table *streams, s64 stream_id, bool send)
> +{
> +	u64 nstreams;
> +
> +	if (!send) {
> +		if (quic_stream_id_uni(stream_id))
> +			return stream_id > streams->recv.max_uni_stream_id;
> +		return stream_id > streams->recv.max_bidi_stream_id;
> +	}
> +
> +	if (quic_stream_id_uni(stream_id)) {
> +		if (stream_id > streams->send.max_uni_stream_id)
> +			return true;
> +		stream_id -= streams->send.next_uni_stream_id;
> +		nstreams = quic_stream_id_to_streams(stream_id);
> +		return nstreams + streams->send.streams_uni > streams->send.max_streams_uni;
> +	}
> +
> +	if (stream_id > streams->send.max_bidi_stream_id)
> +		return true;
> +	stream_id -= streams->send.next_bidi_stream_id;
> +	nstreams = quic_stream_id_to_streams(stream_id);
> +	return nstreams + streams->send.streams_bidi > streams->send.max_streams_bidi;
> +}
> +
> +/* Get or create a send stream by ID. */
> +struct quic_stream *quic_stream_send_get(struct quic_stream_table *streams, s64 stream_id,
> +					 u32 flags, bool is_serv)
> +{
> +	struct quic_stream *stream;
> +
> +	if (!quic_stream_id_valid(stream_id, is_serv, true))
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
> +	if (quic_stream_id_closed(streams, stream_id, true))
> +		return ERR_PTR(-ENOSTR);
> +
> +	if (!(flags & MSG_STREAM_NEW))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (quic_stream_id_exceeds(streams, stream_id, true))
> +		return ERR_PTR(-EAGAIN);
> +
> +	stream = quic_stream_send_create(streams, stream_id, is_serv);
> +	if (!stream)
> +		return ERR_PTR(-ENOSTR);
> +	streams->send.active_stream_id = stream_id;
> +	return stream;
> +}
> +
> +/* Get or create a receive stream by ID. */
> +struct quic_stream *quic_stream_recv_get(struct quic_stream_table *streams, s64 stream_id,
> +					 bool is_serv)
> +{
> +	struct quic_stream *stream;
> +
> +	if (!quic_stream_id_valid(stream_id, is_serv, false))
> +		return ERR_PTR(-EINVAL);
> +
> +	stream = quic_stream_find(streams, stream_id);
> +	if (stream)
> +		return stream;
> +
> +	if (quic_stream_id_local(stream_id, is_serv)) {
> +		if (quic_stream_id_closed(streams, stream_id, true))
> +			return ERR_PTR(-ENOSTR);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	if (quic_stream_id_closed(streams, stream_id, false))
> +		return ERR_PTR(-ENOSTR);
> +
> +	if (quic_stream_id_exceeds(streams, stream_id, false))
> +		return ERR_PTR(-EAGAIN);
> +
> +	stream = quic_stream_recv_create(streams, stream_id, is_serv);
> +	if (!stream)
> +		return ERR_PTR(-ENOSTR);
> +	if (quic_stream_id_valid(stream_id, is_serv, true))
> +		streams->send.active_stream_id = stream_id;
> +	return stream;
> +}
> +
> +/* Release or clean up a send stream. This function updates stream counters and state when
> + * a send stream has either successfully sent all data or has been reset.
> + */
> +void quic_stream_send_put(struct quic_stream_table *streams, struct quic_stream *stream,
> +			  bool is_serv)
> +{
> +	if (quic_stream_id_uni(stream->id)) {
> +		/* For unidirectional streams, decrement uni count and delete immediately. */
> +		streams->send.streams_uni--;
> +		quic_stream_delete(stream);
> +		return;
> +	}
> +
> +	/* For bidi streams, only proceed if receive side is in a final state. */
> +	if (stream->recv.state != QUIC_STREAM_RECV_STATE_RECVD &&
> +	    stream->recv.state != QUIC_STREAM_RECV_STATE_READ &&
> +	    stream->recv.state != QUIC_STREAM_RECV_STATE_RESET_RECVD)
> +		return;
> +
> +	if (quic_stream_id_local(stream->id, is_serv)) {
> +		/* Local-initiated stream: mark send done and decrement send.bidi count. */
> +		if (!stream->send.done) {
> +			stream->send.done = 1;
> +			streams->send.streams_bidi--;
> +		}
> +		goto out;
> +	}
> +	/* Remote-initiated stream: mark recv done and decrement recv bidi count. */
> +	if (!stream->recv.done) {
> +		stream->recv.done = 1;
> +		streams->recv.streams_bidi--;
> +		streams->recv.bidi_pending = 1;
> +	}
> +out:
> +	/* Delete stream if fully read or reset. */
> +	if (stream->recv.state != QUIC_STREAM_RECV_STATE_RECVD)
> +		quic_stream_delete(stream);
> +}
> +
> +/* Release or clean up a receive stream. This function updates stream counters and state when
> + * the receive side has either consumed all data or has been reset.
> + */
> +void quic_stream_recv_put(struct quic_stream_table *streams, struct quic_stream *stream,
> +			  bool is_serv)
> +{
> +	if (quic_stream_id_uni(stream->id)) {
> +		/* For uni streams, decrement uni count and mark done. */
> +		if (!stream->recv.done) {
> +			stream->recv.done = 1;
> +			streams->recv.streams_uni--;
> +			streams->recv.uni_pending = 1;
> +		}
> +		goto out;
> +	}
> +
> +	/* For bidi streams, only proceed if send side is in a final state. */
> +	if (stream->send.state != QUIC_STREAM_SEND_STATE_RECVD &&
> +	    stream->send.state != QUIC_STREAM_SEND_STATE_RESET_RECVD)
> +		return;
> +
> +	if (quic_stream_id_local(stream->id, is_serv)) {
> +		/* Local-initiated stream: mark send done and decrement send.bidi count. */
> +		if (!stream->send.done) {
> +			stream->send.done = 1;
> +			streams->send.streams_bidi--;
> +		}
> +		goto out;
> +	}
> +	/* Remote-initiated stream: mark recv done and decrement recv bidi count. */
> +	if (!stream->recv.done) {
> +		stream->recv.done = 1;
> +		streams->recv.streams_bidi--;
> +		streams->recv.bidi_pending = 1;
> +	}
> +out:
> +	/* Delete stream if fully read or reset. */
> +	if (stream->recv.state != QUIC_STREAM_RECV_STATE_RECVD)
> +		quic_stream_delete(stream);
> +}
> +
> +/* Updates the maximum allowed incoming stream IDs if any streams were recently closed.
> + * Recalculates the max_uni and max_bidi stream ID limits based on the number of open
> + * streams and whether any were marked for deletion.
> + *
> + * Returns true if either max_uni or max_bidi was updated, indicating that a
> + * MAX_STREAMS_UNI or MAX_STREAMS_BIDI frame should be sent to the peer.
> + */
> +bool quic_stream_max_streams_update(struct quic_stream_table *streams, s64 *max_uni, s64 *max_bidi)
> +{
> +	if (streams->recv.uni_pending) {
> +		streams->recv.max_uni_stream_id =
> +			streams->recv.next_uni_stream_id - QUIC_STREAM_ID_STEP +
> +			((streams->recv.max_streams_uni - streams->recv.streams_uni) <<
> +			 QUIC_STREAM_TYPE_BITS);
> +		*max_uni = quic_stream_id_to_streams(streams->recv.max_uni_stream_id);
> +		streams->recv.uni_pending = 0;
> +	}
> +	if (streams->recv.bidi_pending) {
> +		streams->recv.max_bidi_stream_id =
> +			streams->recv.next_bidi_stream_id - QUIC_STREAM_ID_STEP +
> +			((streams->recv.max_streams_bidi - streams->recv.streams_bidi) <<
> +			 QUIC_STREAM_TYPE_BITS);
> +		*max_bidi = quic_stream_id_to_streams(streams->recv.max_bidi_stream_id);
> +		streams->recv.bidi_pending = 0;
> +	}
> +
> +	return *max_uni || *max_bidi;
> +}
> +
> +#define QUIC_STREAM_HT_SIZE	64
> +
> +int quic_stream_init(struct quic_stream_table *streams)
> +{
> +	struct quic_shash_table *ht = &streams->ht;
> +	int i, size = QUIC_STREAM_HT_SIZE;
> +	struct quic_shash_head *head;
> +
> +	head = kmalloc_array(size, sizeof(*head), GFP_KERNEL);
> +	if (!head)
> +		return -ENOMEM;
> +	for (i = 0; i < size; i++)
> +		INIT_HLIST_HEAD(&head[i].head);
> +	ht->size = size;
> +	ht->hash = head;
> +	return 0;
> +}
> +
> +void quic_stream_free(struct quic_stream_table *streams)
> +{
> +	struct quic_shash_table *ht = &streams->ht;
> +	struct quic_shash_head *head;
> +	struct quic_stream *stream;
> +	struct hlist_node *tmp;
> +	int i;
> +
> +	for (i = 0; i < ht->size; i++) {
> +		head = &ht->hash[i];
> +		hlist_for_each_entry_safe(stream, tmp, &head->head, node)
> +			quic_stream_delete(stream);
> +	}
> +	kfree(ht->hash);
> +}
> +
> +/* Populate transport parameters from stream hash table. */
> +void quic_stream_get_param(struct quic_stream_table *streams, struct quic_transport_param *p,
> +			   bool is_serv)
> +{
> +	if (p->remote) {
> +		p->max_stream_data_bidi_remote = streams->send.max_stream_data_bidi_remote;
> +		p->max_stream_data_bidi_local = streams->send.max_stream_data_bidi_local;
> +		p->max_stream_data_uni = streams->send.max_stream_data_uni;
> +		p->max_streams_bidi = streams->send.max_streams_bidi;
> +		p->max_streams_uni = streams->send.max_streams_uni;
> +		return;
> +	}
> +
> +	p->max_stream_data_bidi_remote = streams->recv.max_stream_data_bidi_remote;
> +	p->max_stream_data_bidi_local = streams->recv.max_stream_data_bidi_local;
> +	p->max_stream_data_uni = streams->recv.max_stream_data_uni;
> +	p->max_streams_bidi = streams->recv.max_streams_bidi;
> +	p->max_streams_uni = streams->recv.max_streams_uni;
> +}
> +
> +/* Configure stream hashtable from transport parameters. */
> +void quic_stream_set_param(struct quic_stream_table *streams, struct quic_transport_param *p,
> +			   bool is_serv)
> +{
> +	u8 type;
> +
> +	if (p->remote) {
> +		streams->send.max_stream_data_bidi_local = p->max_stream_data_bidi_local;
> +		streams->send.max_stream_data_bidi_remote = p->max_stream_data_bidi_remote;
> +		streams->send.max_stream_data_uni = p->max_stream_data_uni;
> +		streams->send.max_streams_bidi = p->max_streams_bidi;
> +		streams->send.max_streams_uni = p->max_streams_uni;
> +		streams->send.active_stream_id = -1;
> +
> +		if (is_serv) {
> +			type = QUIC_STREAM_TYPE_SERVER_BIDI;
> +			streams->send.max_bidi_stream_id =
> +				quic_stream_streams_to_id(p->max_streams_bidi, type);
> +			streams->send.next_bidi_stream_id = type;
> +
> +			type = QUIC_STREAM_TYPE_SERVER_UNI;
> +			streams->send.max_uni_stream_id =
> +				quic_stream_streams_to_id(p->max_streams_uni, type);
> +			streams->send.next_uni_stream_id = type;
> +			return;
> +		}
> +
> +		type = QUIC_STREAM_TYPE_CLIENT_BIDI;
> +		streams->send.max_bidi_stream_id =
> +			quic_stream_streams_to_id(p->max_streams_bidi, type);
> +		streams->send.next_bidi_stream_id = type;
> +
> +		type = QUIC_STREAM_TYPE_CLIENT_UNI;
> +		streams->send.max_uni_stream_id =
> +			quic_stream_streams_to_id(p->max_streams_uni, type);
> +		streams->send.next_uni_stream_id = type;
> +		return;
> +	}
> +
> +	streams->recv.max_stream_data_bidi_local = p->max_stream_data_bidi_local;
> +	streams->recv.max_stream_data_bidi_remote = p->max_stream_data_bidi_remote;
> +	streams->recv.max_stream_data_uni = p->max_stream_data_uni;
> +	streams->recv.max_streams_bidi = p->max_streams_bidi;
> +	streams->recv.max_streams_uni = p->max_streams_uni;
> +
> +	if (is_serv) {
> +		type = QUIC_STREAM_TYPE_CLIENT_BIDI;
> +		streams->recv.max_bidi_stream_id =
> +			quic_stream_streams_to_id(p->max_streams_bidi, type);
> +		streams->recv.next_bidi_stream_id = type;
> +
> +		type = QUIC_STREAM_TYPE_CLIENT_UNI;
> +		streams->recv.max_uni_stream_id =
> +			quic_stream_streams_to_id(p->max_streams_uni, type);
> +		streams->recv.next_uni_stream_id = type;
> +		return;
> +	}
> +
> +	type = QUIC_STREAM_TYPE_SERVER_BIDI;
> +	streams->recv.max_bidi_stream_id =
> +		quic_stream_streams_to_id(p->max_streams_bidi, type);
> +	streams->recv.next_bidi_stream_id = type;
> +
> +	type = QUIC_STREAM_TYPE_SERVER_UNI;
> +	streams->recv.max_uni_stream_id =
> +		quic_stream_streams_to_id(p->max_streams_uni, type);
> +	streams->recv.next_uni_stream_id = type;
> +}
> diff --git a/net/quic/stream.h b/net/quic/stream.h
> new file mode 100644
> index 000000000000..c53d9358605c
> --- /dev/null
> +++ b/net/quic/stream.h
> @@ -0,0 +1,136 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* QUIC kernel implementation
> + * (C) Copyright Red Hat Corp. 2023
> + *
> + * This file is part of the QUIC kernel implementation
> + *
> + * Written or modified by:
> + *    Xin Long <lucien.xin@gmail.com>
> + */
> +
> +#define QUIC_DEF_STREAMS	100
> +#define QUIC_MAX_STREAMS	4096ULL
> +
> +/*
> + * rfc9000#section-2.1:
> + *
> + *   The least significant bit (0x01) of the stream ID identifies the initiator of the stream.
> + *   Client-initiated streams have even-numbered stream IDs (with the bit set to 0), and
> + *   server-initiated streams have odd-numbered stream IDs (with the bit set to 1).
> + *
> + *   The second least significant bit (0x02) of the stream ID distinguishes between bidirectional
> + *   streams (with the bit set to 0) and unidirectional streams (with the bit set to 1).
> + */
> +#define QUIC_STREAM_TYPE_BITS	2
> +#define QUIC_STREAM_ID_STEP	BIT(QUIC_STREAM_TYPE_BITS)
> +
> +#define QUIC_STREAM_TYPE_CLIENT_BIDI	0x00
> +#define QUIC_STREAM_TYPE_SERVER_BIDI	0x01
> +#define QUIC_STREAM_TYPE_CLIENT_UNI	0x02
> +#define QUIC_STREAM_TYPE_SERVER_UNI	0x03
> +
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
> +	} recv;
> +};
> +
> +struct quic_stream_table {
> +	struct quic_shash_table ht;	/* Hash table storing all active streams */
> +
> +	struct {
> +		/* Parameters received from peer, defined in rfc9000#section-18.2 */
> +		u64 max_stream_data_bidi_remote;	/* initial_max_stream_data_bidi_remote */
> +		u64 max_stream_data_bidi_local;		/* initial_max_stream_data_bidi_local */
> +		u64 max_stream_data_uni;		/* initial_max_stream_data_uni */
> +		u64 max_streams_bidi;			/* initial_max_streams_bidi */
> +		u64 max_streams_uni;			/* initial_max_streams_uni */
> +
> +		s64 next_bidi_stream_id;	/* Next bidi stream ID to be opened */
> +		s64 next_uni_stream_id;		/* Next uni stream ID to be opened */
> +		s64 max_bidi_stream_id;		/* Highest allowed bidi stream ID */
> +		s64 max_uni_stream_id;		/* Highest allowed uni stream ID */
> +		s64 active_stream_id;		/* Most recently opened stream ID */
> +
> +		u8 bidi_blocked:1;	/* True if STREAMS_BLOCKED_BIDI was sent and not ACKed */
> +		u8 uni_blocked:1;	/* True if STREAMS_BLOCKED_UNI was sent and not ACKed */
> +		u16 streams_bidi;	/* Number of currently active bidi streams */
> +		u16 streams_uni;	/* Number of currently active uni streams */
> +	} send;
> +	struct {
> +		 /* Our advertised limits to the peer, per rfc9000#section-18.2 */
> +		u64 max_stream_data_bidi_remote;	/* initial_max_stream_data_bidi_remote */
> +		u64 max_stream_data_bidi_local;		/* initial_max_stream_data_bidi_local */
> +		u64 max_stream_data_uni;		/* initial_max_stream_data_uni */
> +		u64 max_streams_bidi;			/* initial_max_streams_bidi */
> +		u64 max_streams_uni;			/* initial_max_streams_uni */
> +
> +		s64 next_bidi_stream_id;	/* Next expected bidi stream ID from peer */
> +		s64 next_uni_stream_id;		/* Next expected uni stream ID from peer */
> +		s64 max_bidi_stream_id;		/* Current allowed bidi stream ID range */
> +		s64 max_uni_stream_id;		/* Current allowed uni stream ID range */
> +
> +		u8 bidi_pending:1;	/* True if MAX_STREAMS_BIDI needs to be sent */
> +		u8 uni_pending:1;	/* True if MAX_STREAMS_UNI needs to be sent */
> +		u16 streams_bidi;	/* Number of currently open bidi streams */
> +		u16 streams_uni;	/* Number of currently open uni streams */
> +	} recv;
> +};
> +
> +static inline u64 quic_stream_id_to_streams(s64 stream_id)
> +{
> +	return (u64)(stream_id >> QUIC_STREAM_TYPE_BITS) + 1;
> +}
> +
> +static inline s64 quic_stream_streams_to_id(u64 streams, u8 type)
> +{
> +	return (s64)((streams - 1) << QUIC_STREAM_TYPE_BITS) | type;
> +}
> +
> +struct quic_stream *quic_stream_send_get(struct quic_stream_table *streams, s64 stream_id,
> +					 u32 flags, bool is_serv);
> +struct quic_stream *quic_stream_recv_get(struct quic_stream_table *streams, s64 stream_id,
> +					 bool is_serv);
> +void quic_stream_send_put(struct quic_stream_table *streams, struct quic_stream *stream,
> +			  bool is_serv);
> +void quic_stream_recv_put(struct quic_stream_table *streams, struct quic_stream *stream,
> +			  bool is_serv);
> +
> +bool quic_stream_max_streams_update(struct quic_stream_table *streams, s64 *max_uni, s64 *max_bidi);
> +bool quic_stream_id_exceeds(struct quic_stream_table *streams, s64 stream_id, bool send);
> +struct quic_stream *quic_stream_find(struct quic_stream_table *streams, s64 stream_id);
> +
> +void quic_stream_get_param(struct quic_stream_table *streams, struct quic_transport_param *p,
> +			   bool is_serv);
> +void quic_stream_set_param(struct quic_stream_table *streams, struct quic_transport_param *p,
> +			   bool is_serv);
> +void quic_stream_free(struct quic_stream_table *streams);
> +int quic_stream_init(struct quic_stream_table *streams);

