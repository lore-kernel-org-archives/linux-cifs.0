Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D803D22ACEB;
	Tue, 23 Sep 2025 09:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758618600; cv=none; b=NnnIgp7BD+98zmXA3xX6xtFyoaQStUb6NpnqIo/SQIRF03ZiKYrlyEtYjtJAUx2aVU/a85toZ8op12c6z0gjp+XcPvrPNmqQv4TB6Wl1TStT4w+ZH1lFM+FFMhmVGl8G+eO0nxdDepSYhRH1DDDQq06HYFY+765V1E9Un4GNpUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758618600; c=relaxed/simple;
	bh=uHDaFrXOlCwFqUHG/Eom9yW5P7wX0f/3/xTs1FiAdRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Quyh+pBX9hmed3bnRIrvcersOJkTZkXUCEBnNKdWaBZ6Rqm+QzoBE2mOZdn+CRFVX/OOnzIuJ9BnfdoSVzF4ORmhq7443XJ69vOlxQQQUbrPxb8Yxt1A1eJGPwmuUdjowDbbTD9XwnRUjbPtySmjJeMBDWfRQoGrJ35oAcDv/mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=by7KkqFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="by7KkqFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDB6C4CEF7;
	Tue, 23 Sep 2025 09:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758618599;
	bh=uHDaFrXOlCwFqUHG/Eom9yW5P7wX0f/3/xTs1FiAdRA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=by7KkqFCXQk5cx0fFHYgUtUb+WoKvTi5q5cemio4xBOwaIrIdqJIZyhKbW0ktEzC+
	 1H/DAjc4v0Fma9KjgQa93Upsrc9MCVOLZSz5WCbrRMHC3o0EcbQVW95wmkQfVx8YU4
	 1bSxnI9IleAe98cnUf2DQJ3GhjuccANobIgVfhAC5YIn8e+kVgpydVj0KODeJpkcG9
	 T8G4U9fdggDyedh3xfR06s7Hi+z3dPOg78Ges8cRXHJFrGhPb1p6YQocmHXC7f1tDH
	 fM9/j9K//TMGZBCkykPlAHs6wK5cF+N+50dKipNNCM3XFq1lkVk6ME3UF8a+RG26nU
	 1EEYnx+8FPE3g==
Date: Tue, 23 Sep 2025 10:09:51 +0100
From: Simon Horman <horms@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
	davem@davemloft.net, kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
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
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v3 06/15] quic: add stream management
Message-ID: <20250923090951.GF836419@horms.kernel.org>
References: <cover.1758234904.git.lucien.xin@gmail.com>
 <5d71a793a5f6e85160748ed30539b98d2629c5ac.1758234904.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d71a793a5f6e85160748ed30539b98d2629c5ac.1758234904.git.lucien.xin@gmail.com>

On Thu, Sep 18, 2025 at 06:34:55PM -0400, Xin Long wrote:

...

> diff --git a/net/quic/stream.c b/net/quic/stream.c

...

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

...

> +	}
> +	return stream;

Hi Xin,

I'm unsure if can happen - actually I doubt it can - but
if the loop above iterates zero times then stream will be used
uninitialised here.

Likewise in quic_stream_recv_create().

Flagged by Smatch

...
