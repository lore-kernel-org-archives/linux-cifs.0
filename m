Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BF334A797
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 19:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293437; cv=pass; b=O0D8QXY2U2vfDs46Yfcj30zfneEp3GBagCd0h/FYMQeWHiFqhI/xy9RktS1qAkd7D4gTTxMKKpy/Sheqouvexqx89cUvM1nryYEFewkbPI1q3ZNeEQ1thdP61nSruNhEgGt/1y9YhG8lckwImk/Ky4HIs9ZLO5AWG7yLkFzNDT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293437; c=relaxed/simple;
	bh=0MIzScJKL1xXmPrlbYULoUIxKe1BsiEaaVgILh54qWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fo85Lbp/p2sI4ywB72LM/yuTvpfHwproCGKaQ1idNbcepfN9WYFoB6aF/M5rbtsKTkAbmByyJ10yNpX6/og7hVYHCTaAjh64CRHMmdoWKYDO55pGXcowp6Z5mjETp9flDj8UsSkLNyUps61ezXMdngfAS21dOYuu/CSUKdyaDDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kITUZeWd; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kITUZeWd"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-842319576d5so837331b3a.1
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 12:43:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781293436; cv=none;
        d=google.com; s=arc-20240605;
        b=fTDHBcV29bJ/rpXST6lp+g5Z4P+UI0HmbqN3eN4TDo/Y2LhnUWwgUziYWupSf6pTJm
         vCab98uEUowEHBOcFveHdO41UX1q/R7lafIBptnYuA0ZNgEoIkHcQhjjot9tqE4l+cvS
         /LsZDA3q1oq3lpHvXPuASfOe/rh9wP+joFTRnufERqWDxfaqf/jiomT3rMsM6oxcrjQs
         Fmv4dKiA4VRUBDCqq0AGRN7U3/vKThrO2Bq8AlXJ7vozMuCX3Rc0pT+3jWmKB4BISHiZ
         OgmtUJeBo//t0GhTnzF7QYei1TB7U/INVSjPmHa1LGaMhLwqYm0NANVANBye9NXuh4U2
         AKHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0MIzScJKL1xXmPrlbYULoUIxKe1BsiEaaVgILh54qWo=;
        fh=Vl8YQa1XO8PfnLS+8OWkjYQWuY+UHukg+JKXdwX3K1M=;
        b=JuLfF1vB1kdqSy5zw/Q3cGFgY1V/UBRUQLw1lEiTnYTxfVHEYlNRFipJp8xblE+KIg
         einGpkqotjogE7Pj1Dm/ftT/JH72eXGlQuG1f/VAaiJ16W2NhSKDgVLPvwv+yGLCiWHe
         Pg9vAauLHzgfui4Pja2fE9qf0AROeWMxGgthlLCGwBz0fgUG6ZCxqGjzqrUfArRm8iZu
         2JfVXSTLIaApgAKIHOUMdhfCREW9aVVs1PRKtJC1YZYAPysgGE6eVRzy0wxgCfd+gm4+
         X0RPlaL3edpq6GFtxbLhkqbY5GT0nuHvYAmG/PWawKdPW3WeoLc8BbU9IXZ9yH9OhRAY
         wYyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781293436; x=1781898236; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0MIzScJKL1xXmPrlbYULoUIxKe1BsiEaaVgILh54qWo=;
        b=kITUZeWdVpjedNyETPsbAJ7v2e1K3lwI2V/i3EVdYF+qBFTP1R2x8cFsG2pDHn2yw9
         ty1xUsvm012C2+Kd929kkN9WWQzlZTCGui3Ruw15mcRUd53f4beSr2ze0M4TSkbs+o6Q
         9xRnngM4jZVRYzNDaGn8Tpc8c8dot8jvnSiGvpi0VO4/jJJ96ssHxxxtGg1LjxX+XvgO
         xapzdI5i3nrx8QkoK5/7LiWs+W2D2Yn+LI5XBN8L7WcFNDaQ1zJTS2ZKYpd0eHvfijDi
         eCbnZQNn30lzy9pAZZUBmO+o9Erj5RI0ZytfIUBY9MXjV7E3L63965pzpvZDHT/LuSwm
         iXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293436; x=1781898236;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0MIzScJKL1xXmPrlbYULoUIxKe1BsiEaaVgILh54qWo=;
        b=KinAv3VR+2OGeRJk1XGkdp09Xap7bZO8xM6hP0GuPnI/9kuIktuSdYuadszIcO9ZTZ
         1Zq+1yivHHlLr8Mj2CeIo+W7u0VFj0E2nvWG6pbSp7p7owOw00bDRdWrFyqVW5ThQA9Q
         ib1csCikcEncwKnrwco1FTgSghjAW3CKXMTlDvDQuTuuAiGYdDKkbeKuVXLEairyS70t
         UNp86Cbt2gHLhct3VWMGH5Q2qpA9v6EQF0rB0SlvtLxvKQuZRpF0+HU/dEsaylhNSlEd
         LUjnq1uXo8WloLl4NdE1NZOydT8jQRacr+ATl6t6j3iQ1+fwEZxX4aPmec8bzT6bBKOz
         K6nw==
X-Forwarded-Encrypted: i=1; AFNElJ+zVZe6QJw7Dmx1+hicovanYqGOvsm4MQ0kCJ3abJYSW7HRLXEW3LULmuD1g7/+jW0DqsI+W3IV3RGg@vger.kernel.org
X-Gm-Message-State: AOJu0YxSfdwIll+u2B9ke9L6N7wcSOCfU3gt4fIszn82a3FS+YankZaB
	pZu70box1M/ayiq19K7oKu3c1SEGH74RwCzTUUCCcTUasW3xCbOVDRCrRx1tE21TtGWC8xOo6Mk
	WWzUZ7+SIP69Ac29yv1qtHm7bKMGkjdA=
X-Gm-Gg: Acq92OEnVzH3D04yx0uGAnT8oDAK0JQ4LFgMUd8I9UrbnKzpqROwqWgzf6Fke/LCJK4
	DILlMLRICPCa+/fszcxkT8bUSsPbfzhGJncPP8ZdIrlxjfMvBf+rAQV+xgMkOGHvtpsDxhWob1T
	CQlP7732ux7gEm4JTTnMDHR886NmyzL8PWRUdiz8Eu3gxVPGDY3Zl3CxIihuQjrL0fOpCes/PC2
	MwBxFRQcGcp1zd+FotUm4pDp4SEIE7kZYsPZYXBwsiTEy0EZkWlKI0gP4eGFB4LVGTvd8WK5Dfj
	eGqOYteo3lb4We2ZSM4ycYAhogCXxV4oZheyQxOK6xa7ouKCizQ7O3lZv6aItMdNUdieb7EpMzC
	4IxPJQQ==
X-Received: by 2002:a05:6a00:4146:b0:82f:1b1b:e166 with SMTP id
 d2e1a72fcca58-8434d0aeb79mr6315498b3a.33.1781293435882; Fri, 12 Jun 2026
 12:43:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1780855296.git.lucien.xin@gmail.com> <1b5480358209643e574188ccba83bc9ef0a84aee.1780855297.git.lucien.xin@gmail.com>
In-Reply-To: <1b5480358209643e574188ccba83bc9ef0a84aee.1780855297.git.lucien.xin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 12 Jun 2026 15:43:44 -0400
X-Gm-Features: AVVi8CcosIZ2HodYXSoI2GurOTwt4JyXnbbeTIrOgwh_78ZtgEuE0FazxT7w2bQ
Message-ID: <CADvbK_cvO+EGvbzySPQc4DvN7GM-94gFZK+_pXMSkj8b9--DDA@mail.gmail.com>
Subject: Re: [PATCH net-next v13 06/15] quic: add stream management
To: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"

[sashiko-claude]

> +/* Get or create a send or recv stream by ID. Requires sock lock held. */
> +struct quic_stream *quic_stream_get(struct quic_stream_table *streams,
> + s64 stream_id, u32 flags, bool is_serv,
> + bool send)
> +{
> + struct quic_stream *stream;
> +
> + if (!quic_stream_id_valid(stream_id, is_serv, send))
> + return ERR_PTR(-EINVAL);
> +
> + stream = quic_stream_find(streams, stream_id);
> + if (stream)
> + return stream;
> +
> + if (!send && quic_stream_id_local(stream_id, is_serv)) {
> + if (quic_stream_id_closed(streams, stream_id, !send))
> + return ERR_PTR(-ENOSTR);
> + return ERR_PTR(-EINVAL);
> + }
The recv path here rejects stream IDs whose initiator does not match the
caller's role (a server cannot accept a SERVER_BIDI on the recv path
without it being closed/already-open). Should the send path have the
symmetric guard for peer-initiated bidi stream IDs?
Walking through quic_stream_get() with is_serv=true, send=true,
stream_id=4 (CLIENT_BIDI), flags=MSG_QUIC_STREAM_NEW:
- quic_stream_id_valid(4, true, true) only rejects CLIENT_UNI on the
server send path, so CLIENT_BIDI passes.
- The !send && local block is skipped because send is true.
- quic_stream_id_closed() compares 4 < next_bidi_stream_id (initially
SERVER_BIDI = 1) and returns false.
- quic_stream_id_exceeds() can pass when the peer's max_streams_bidi
is non-trivial.
Control then reaches quic_stream_create():
> + stream_id = limits->next_bidi_stream_id;
> + if (quic_stream_id_uni(max_stream_id))
> + stream_id = limits->next_uni_stream_id;
For a non-uni max_stream_id, stream_id is initialised from
streams->send.next_bidi_stream_id (SERVER_BIDI = 1), so the loop creates
a stream with id=1 instead of the requested id=4, increments
streams->send.streams_bidi as if locally initiated, and advances
streams->send.next_bidi_stream_id past 4.


This is a good catch, will add quic_stream_id_local() for send.

Thanks.
