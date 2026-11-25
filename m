Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795621939;
	b=XxkMiA8rLUCMZVhhkF/tfdwt4ezwtrsyX79xH4xmRyKpAPRwVeovQt+DdAG/9I3SgPrV
	 Y9wE5QvPWaQwkQE9yl/ZuzqLKR6wvybU02MSz7HF7PJZcgwQ+rP+7cbbRS0f4BKvPKaCV
	 pu7Z3k3ono3h0XNzE2PfZoBvlxJduPUTGD1+tWI8PuEfHS3c+Xu9O2xmwTH3HZxUDYu3l
	 RgQMi+DaJAOdRPBmuAcwJoKMjjgP2blT20XBRdU5+hgIt2/ObaKN3rEq3/zVaw2Sk12JO
	 RFOiwLskOBCjYVXCtwXioM8Fqusn4RPbSig131Dlz3NrqM39UJXa/lfQzYzC17rLzfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621939;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Wl1gc75zEow3srAWy7eV7VFmzyOiVWcKqUcpVHuYC6w=;
	b=fpBT+44WrBGmSZkdxl4ehASe1qDhCvUHXSLosgMzrp9lx6qx1XFyWEkpxU0vY11NPnix
	 aywDliUcp9p+GUtozzWScf7NXz1Mk8B6oIaLL9PYzIKPVTMO3+Q07VEmwxY9wLMH5Nqcq
	 MLLciBakTqFfIjP+xrmpLAJYRBkjD7pm3m+M+mHbfRDK5nGw4hNqHlaqWE2G7+IIvqazE
	 z6/K1GSmFyNfzDXxGeoJSpDZmlN9beiptdd/T6mrpUUbKTcmUXaI1/9OIYtG1AORVT37m
	 Bskc5/NbOtyPvShaQh90y2gJry5ReBkzpmkYHLXVvYMQz/1IXiI39whxDfGZozgnnMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pm0fDUCQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737AD606A32D
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 15:52:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 737AD606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pm0fDUCQ
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8b271e573adso2557817b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 07:52:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795621939; cv=none;
        d=google.com; s=arc-20260327;
        b=Eg5HxHVy4LfCHJoN4krnYPDHNt1sEHZ9XQvWxTgR2BfCcHzTBFz660fMWYZUGhBtrG
         Yri3DrI18BvX6DOVoO5sKxZnUC2CHvfQi98sOyAAIRy0xFvPaJNyFn8kv8JBZEisu8Ni
         3L51b2b09N4X+FOAVPJLW1gimBCRJy9VHAk79agJihkdE3jrLj4bWSAeA5/SIz6GqQg/
         z7HbUDpZDDAMoV+RDuh7Ogw+5JvBuxPeNb6R2afCiMmGMxQ4iGaDtNBJ2ruHaha0ur1y
         Djzk2JZe2WsT0W45s6J+IlCs0F3qxRbI+/9MwxbZeCO+PTgW8FJh5AKmHvVoEoGVyTAY
         zKQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wl1gc75zEow3srAWy7eV7VFmzyOiVWcKqUcpVHuYC6w=;
        fh=72YaiChViQXX+XX7fSwelJ3QGkHNAN+9or57K+AZQSM=;
        b=hcyZAKzdMXxDeBRM5lyX2r+dnV3c7yszzwV841UzwCDMVLPR/LyfY1EbD9ret+Ve9L
         BYINBbXSyFSI95kmOTwfrj8G14l/jOIUL9oPLEMXkTB+9fT/jhrk8zzN3XAaVDwAyPAg
         kHxUMXcTt/7UARc8euO5UZHxMT+4vZrocYwMxMvrakjwvceX6XSsGZHMly6vINgygJYm
         0cFTe3RFiqnUEZ41oJl4iGTil93UsoY5kImlSK/0hi8CH6tc4HGuXKTYnMxDN/ZnAywH
         RgWPTuRFJG9sy1yQaiDQE/mzN2QQ2zyVsAGJoQwq2Pif19D3GoqqoiD7c1EKaP95KbU4
         S/NQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795621939; x=1796226739; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Wl1gc75zEow3srAWy7eV7VFmzyOiVWcKqUcpVHuYC6w=;
        b=pm0fDUCQ7nag0X4lU7E3i9TxndNJtKUDIoO5+NbPuYmF4IR0xA/RNxflW8a9gzz3g6
         BRNP+lsmXSQ//T5DCAB0JLHnurDrjB1Y1Rq/W45mmBq+AIep8o75lE9Bivv6zYb9X+wv
         6gFFYaRk3M6CVzOGT/z+tz4yJSiL6X+VBMydvOqsKZ/i/0sED4o9HK38N26bp0tFJTY5
         jrE2c+oHHOZNtt4EflnTieEv+mkajApgUjRzyhrw1PZDlPi0lxPZ1Re8eKVkBwk5MriD
         TdxPei8Iz5R9DIclcPCM69s655AjS+NYcYzu1bqXuOPhMDBp8Wzz5M7HIb+cr3/nevpv
         AsrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795621939; x=1796226739;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wl1gc75zEow3srAWy7eV7VFmzyOiVWcKqUcpVHuYC6w=;
        b=0DhLhxfsQ1U0Oh4uD23VjsLjtMSlg2nVtZTaTNj6nWGawIRkQ4rk594D2HUzXmOGxC
         Zf/Uej+aaZ+rTI0gAdn/H+/X7gvS+83ttobkuMDmcxNegIx/7WhCOUGROekyKu5ZcriK
         D1pcoBGN52sE8saaEQIiUZX3FZDSdqlHKBZtTv5Gc3I/+E1QsVqhpIHzquIbulMsYmtc
         hxQTV18A1NT5fRWLXkpj/2kSinCWiiIvmctF239UF0KDap+iZgNARRk3aU2qmOwD+IbF
         QAs/vI6GPUDgpKMJDrrWkTBJF/jLtTTaOj5isTtMfN6aCRz5X6Odm7aq2ZrEt+Ag8zzW
         /g0A==
X-Forwarded-Encrypted: i=1; AL+hErGKU5t99193aO7WNy6Mk7dwNizje0VU0LEZQwDwhhq1MqBRIu5FkKS2KzFWvYvD7UpjItnGr4g6naRp@vger.kernel.org
X-Gm-Message-State: APuU4Z9omCgoG/RS/+7Ce6RDrnvWztLzoMq8iCYfeaTaKZBxKYnA/0sj
	M34ijGCbBac3j4/4e+KZNZFBEcHniCzAUm3OI9f5A93oMrDd2k4rUhP+EY6sEgmO9ga9ADideEP
	6I45XnbqdAl4JvyXX72uZv7y8wEyywpw=
X-Gm-Gg: AZFdTZf8CugGzv3FO1l9XhXxiJzSa1iAjMqQ9NTdapVGqVXwKSlBPdGFmKbspsK+Vze
	WA0ZlaZdi9Ct+VsQk69asAHcEY5YKxvpjf0elAWrdcOGEnjxInb2VBzfVHkpJ0dlfMGD+5QbGkx
	CW65ZkGNSu1MbS9E9Qu5BZ9RIU6d3tdDapPYpNi7Bv3cILzkssBQteKIhaAOpgP/SdiBk7/3Gmp
	QvKxKJ134LByVGrXDGyeqlBNCeBxAFLF6rhASkrrzpJkl/+Db+QiiWoi4lfuDQTVlO45uPoybpX
	jGWiQDr5XvgRFzAneip4tyWAiu7mCyZHkZlW4zQDY5JX7r2383iBeePsve7btmKXB+BEWcA0Rn+
	PyiFrNbaQk3/K79hWph6pKyQ9l0NC6pKPnjh3pGF1tYMFE1FI63USUkoecmEzFjSpEpqNOsSKmU
	zZadlFRPyeYijBnxmg2LLe/yMZH5YPVaYFBOJ1Ag59EVKiWvIRZAtZD+7aE/8DeSI9h96K
X-Received: by 2002:a05:6a00:1c84:b0:89d:a947:9d58 with SMTP id
 d2e1a72fcca58-8c87bfa78d6mr15873197b3a.25.1795621938615; Wed, 25 Nov 2026
 07:52:18 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <5c305e22057f748d5c4d4cbc94a1e14271dbc485.1795393691.git.lucien.xin@gmail.com>
 <179548328755.3135.13551034983466058259@kernel.org>
In-Reply-To: <179548328755.3135.13551034983466058259@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 Nov 2026 10:52:07 -0500
X-Gm-Features: Aa3M54pb6nKYJidOZT5TgP5nXd3wLNCTpX3AZEaTxx4hR_vcQqSA7EC-JYn_mcw
Message-ID: <CADvbK_e4PXuzSrvuErCMQ2wPSFrvOW7-JwruzUBbLeENkKOg9w@mail.gmail.com>
Subject: Re: [PATCH net-next v19 15/15] quic: add packet parser base
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com, 
	dreibh@simula.no, jamie.bainbridge@gmail.com, linux-cifs@vger.kernel.org, 
	pc@manguebit.org, linkinjeon@kernel.org, tom@talpey.com, 
	kernel-tls-handshake@lists.linux.dev, cel@kernel.org, jlayton@kernel.org, 
	steved@redhat.com, hare@suse.de, aahringo@redhat.com, dhowells@redhat.com, 
	matttbe@kernel.org, mail@johnericson.me, xiyou.wangcong@gmail.com, 
	alibuda@linux.alibaba.com, jbaron@akamai.com, illiliti@protonmail.com, 
	sd@queasysnail.net, marcelo.leitner@gmail.com, daniel@haxx.se, 
	andrew.gospodarek@broadcom.com, mef@scarletmail.rutgers.edu, paul@jakma.org, 
	kuniyu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 8:21=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] When ALPN demux is enabled, a valid ClientHello with an ALPN
>   extension longer than 128 bytes is silently dropped, so that client=E2=
=80=A6
>
> --
>
> quic: add packet parser base
>
> This patch adds RX packet parsing for QUIC. Sockets are looked up by
> connection ID and address, and Initial packets are decrypted to pull ALPN
> out of the TLS ClientHello so the right listener can be selected. It also
> adds ICMP PMTU handling, deferred packet processing, and the request sock
> and backlog infrastructure for incoming connections.
>
> > diff --git a/net/quic/packet.c b/net/quic/packet.c
> > index b6f76681b6902..919745d954403 100644
> > --- a/net/quic/packet.c
> > +++ b/net/quic/packet.c
>
> [ ... ]
>
> > +     /* Read TLS extensions length (2 bytes). */
> > +     if (!quic_get_int(&p, &len, &length, 2))
> > +             return err;
> > +     if (len > (u32)length) /* Limit len to extensions length if large=
r. */
> > +             len =3D length;
> > +     while (len >=3D 4) { /* Scan extensions for ALPN (TLS_EXT_alpn). =
*/
> > +             if (exts++ >=3D TLS_MAX_EXTENSIONS)
> > +                     return err;
> > +             if (!quic_get_int(&p, &len, &type, 2))
> > +                     break;
> > +             if (!quic_get_int(&p, &len, &length, 2))
> > +                     break;
> > +             /* Incomplete TLS extensions: skip ALPN demux. */
> > +             if (len < (u32)length)
> > +                     return 0;
> > +             if (type =3D=3D TLS_EXT_alpn) { /* Found ALPN extension. =
*/
> > +                     if (length > QUIC_ALPN_MAX_LEN)
> > +                             return err;
>
> [Severity: Medium]
>
> Is returning err the right choice in quic_packet_get_alpn() when the ALPN
> extension is longer than QUIC_ALPN_MAX_LEN (128)?
>
> RFC 7301 defines ProtocolNameList<2..2^16-1>, so a ClientHello that offer=
s
> more than 128 bytes of protocol names is still well formed.
>
> Other cases this parser cannot demux return 0 and keep the current
> listener. Those cases are a missing CRYPTO frame, a non-zero CRYPTO offse=
t
> and incomplete extensions.
>
> The caller, quic_packet_listen_process(), frees the skb on any error:
>
>         err =3D quic_packet_get_alpn(skb, &alpns);
>         if (err) {
>                 kfree_skb(skb);
>                 return err;
>         }
>
> With quic_alpn_demux_key enabled, would this drop the client's first
> Initial packet with no response? No request sock is created and nothing i=
s
> sent back. Each retransmit of the same ClientHello would be dropped the
> same way, so the handshake would time out.
>
> This path also does not increment any MIB drop counter. The decrypt
> failure path above it counts QUIC_MIB_PKT_DECDROP.
>
> Would it be more consistent to return 0 here and skip demux, as the
> function already does for the other cases it cannot demux?
>
False.

We expect to handle it by either discard it or route it to the socket with
right ALPN if there's ALPN find, instead of routing it to the incorrect
socket, besides, ALPN > QUIC_ALPN_MAX_LEN (128) is very uncommon in QUIC.

> > +                     len =3D length;
> > +                     found =3D 1;
> > +                     break;
> > +             }
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1795393690.git.lucien.xin%40gmail.com
