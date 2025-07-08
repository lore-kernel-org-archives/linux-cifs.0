Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8B714A60D
	for <linux-cifs@vger.kernel.org>; Tue,  8 Jul 2025 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992457; cv=none; b=siL22DkHHWG/c3dB7X1fCQ62yVQczRfXigbAgMm0IuOjWI7m7AGIr7Bqw0EU6OEGe5Vrvb8PKnBLdIfxchDAcuFjdrxAH96KdU+nFF4B7HT3yqROp1zaWJdyTy8PeQArIPrIwXIXAmcTr+/YzDQFN3ZdLqjMKwbiSEde031z5Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992457; c=relaxed/simple;
	bh=AcMQwPi0xI4VgQVEoTK3okOT8pwvtcq2xW9s3bG9zGU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=fFGecnFUjXahwZTUhyX1KZGLY7Lrg/Ohz8GIaoqkHVDSM1LggB9fm4czfkEygTZqZkxnShmazztCVXCXp+nFU0FHP/AQxkD064sCU2+MaQ0YZ1Yox9YuduqtOZeYYfoCR5q9du9hA5lpqV4xvdW2+pR46v6lI5OJXz8v4EkKEYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GOhJbsft; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GOhJbsft"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751992454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DH9ly1s2cBDDFT6+fPo/AhzzA7jHgn2/iocEOSrFD04=;
	b=GOhJbsft67VgNk79FsmFOCuom8oy4/xtsdkvO/4KqQ6aJIWfv4BjXE7A3qyaDtz91540eC
	T3EODoS0+N+Fl+1SXd61kXQwPgjXBjuatoSib4VO9ycYGOzQ/7ylzEbj0CELvINo2nl3Zg
	yB1426QuWOk7kKayNANG8Sxcc+eaWGU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-NVnK5HzAMne_6lmwEqxSWA-1; Tue,
 08 Jul 2025 12:34:11 -0400
X-MC-Unique: NVnK5HzAMne_6lmwEqxSWA-1
X-Mimecast-MFC-AGG-ID: NVnK5HzAMne_6lmwEqxSWA_1751992448
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C248F180136B;
	Tue,  8 Jul 2025 16:34:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.81])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1364718002B6;
	Tue,  8 Jul 2025 16:33:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <74b62316e4a265bf2e5c0b3cf7061b4a6fde68b1.1751743914.git.lucien.xin@gmail.com>
References: <74b62316e4a265bf2e5c0b3cf7061b4a6fde68b1.1751743914.git.lucien.xin@gmail.com> <cover.1751743914.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: dhowells@redhat.com, network dev <netdev@vger.kernel.org>,
    davem@davemloft.net, kuba@kernel.org,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
    Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
    Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
    Steve French <smfrench@gmail.com>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
    kernel-tls-handshake@lists.linux.dev,
    Chuck Lever <chuck.lever@oracle.com>,
    Jeff Layton <jlayton@kernel.org>,
    Benjamin Coddington <bcodding@redhat.com>,
    Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
    Alexander Aring <aahringo@redhat.com>,
    Cong Wang <xiyou.wangcong@gmail.com>,
    "D . Wythe" <alibuda@linux.alibaba.com>,
    Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>,
    Sabrina Dubroca <sd@queasysnail.net>,
    Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
    Daniel Stenberg <daniel@haxx.se>,
    Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next 05/15] quic: provide quic.h header files for kernel and userspace
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2641255.1751992436.1@warthog.procyon.org.uk>
Date: Tue, 08 Jul 2025 17:33:56 +0100
Message-ID: <2641256.1751992436@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Xin Long <lucien.xin@gmail.com> wrote:

> +#ifndef __uapi_quic_h__
> +#define __uapi_quic_h__

I think capital letters are preferred for system headers, e.g.:
_UAPI_LINUX_QUIC_H.

> +enum quic_crypto_level {
> +	QUIC_CRYPTO_APP,
> +	QUIC_CRYPTO_INITIAL,
> +	QUIC_CRYPTO_HANDSHAKE,
> +	QUIC_CRYPTO_EARLY,
> +	QUIC_CRYPTO_MAX,
> +};

I would recommend that you assign explicit values to enums in uapi headers to
avoid accidental changes if someone tries inserting in the middle of the list.

> +struct quic_transport_param {
> +	uint8_t		remote;
> +	uint8_t		disable_active_migration;
> +	uint8_t		grease_quic_bit;

I believe use of __u8, __u16, __s32 and similar is preferred to uint8_t,
uint16_t, int32_t, etc. in UAPI headers.

> +enum {
> +	QUIC_TRANSPORT_ERROR_NONE,
> +	QUIC_TRANSPORT_ERROR_INTERNAL,
> +	QUIC_TRANSPORT_ERROR_CONNECTION_REFUSED,

Again, recommend assigning actual values.

David

