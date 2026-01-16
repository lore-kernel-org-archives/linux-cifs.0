Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52783A1D02
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 19:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768593369; cv=pass; b=epawLE4izLVkk2vnrQyUCFaX+xgB595Xn+1WXXD8oChWVbHzO7OE09vj7tf/t7w9lii2+7Ftsrvxfz+VEwPKZMLE+CqFWVMqdo4oYy+8KlX/Y5FaYAN060kiuR3uP1GSNk61sTnc6xvDcPJ0zqwWsKPrxvgmlXV3eHtWRJxWOj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768593369; c=relaxed/simple;
	bh=IWmMPimbXDtPvSp9dAjyQtCrQgxzce8BWN+6we3ehRM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q2tY9Ej9zJBcc+Wxo6KN5V85Wpl5XRzpEYVC+XKXfE6GyNpt0+tSoqWKZXPY9TpreEpkF/l2PKrfRuQw4aDpH3j144fJULWZylRIULI+93NkMtwhPCT3qoLT7mXhdUI6H135J7obMZo8Y86NJkgfjfE7f7AU45kT1MrEuKQzJtU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CHvi/iaX; arc=pass smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CHvi/iaX"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34be2be4b7cso1376051a91.3
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 11:56:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768593365; cv=none;
        d=google.com; s=arc-20240605;
        b=fzLHDXUdsYRn66EQpfazxkeHyYMMRPvHHPJ8uTUHhvax0/0qwK+7ooo8GiY/JYm4E4
         aaVmYL7QQAsZ+BCssIXQm/eIk3gQxhWIYowemnJb6b0G/bUdLLYJJOgpqAHHYhzpmYkD
         HmjKRCewcoGn5qOK49f3jBuIFy3gmfDd2rH1ywqAfyueY3O2YjIcws7XX8gIUIHVYUqK
         Y7uZbiWCUwoe3VEQ5J6vh8utBTgFAUBvi7AgegkkCSV+HgShhT+EL+XZoD6vhfu6V/Yi
         uVp0kmFqffRjUvlkWLYNLklaxKsZNpIohqpR2QevtP/wzRhz71yL8UXdXPFKBdPYkU/J
         /cXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v7luFe9q5FyU1n9+ffSge7aXZuT6jKQVxOiNsHnXneU=;
        fh=vGWaKmyKLY59d6B+EG+7Hoo9S/ljnKMqlsF911vzvYg=;
        b=gwIDfK4pTNafiCZPLFF157Vro5XP4rIC2cU5jMRA5gCfj+SgqrW3q/lgXm+EYPrvoC
         fxbHI+PzuVE3OuCXiM33V9nzFUFMDIkgtRn86ItOew/UpivbZQ23EQT5Lz5YsGs6cA1i
         45DT+Lh8gSu4Ku0p8NHVWKQUxi+3KcYjUzlsUkhWNybBugS4ZycsJClt/VbY17i59BGt
         1Om+7OpqPv+0H/vUNOK80rvUq1rePyd/9nCBGBLWuhuTgFz85BSCXgscx8iKPVFrzTnr
         Kjk8RDk7K40Rg/8Uv9FfpTmEKIA+UN+BMOIa8Zkha9MaId4YrxGqHX11uglPezSKELDO
         Txtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768593365; x=1769198165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7luFe9q5FyU1n9+ffSge7aXZuT6jKQVxOiNsHnXneU=;
        b=CHvi/iaXxSTBLKYH0jXZesaAt/lhArn8zHqbsFZYIXLmows2RrebCZhXmn5opwRutL
         DLzyZO7Vg+R4AtuwtUG+phfpF+jaXxkUt7BM3YuK3DyBPe19Kz8/t3kWUmZlquNVorsK
         3CGpnEqggfI15kDtD6/bBwC+u1x5F/inodLrGtbUwsCCywmfOT8aoItaP7l7dWw/pY/C
         ziZxc6hO007a9B1DS5eZ58MNM3hpS71HX8pOyOiEfBaAyd718E0f6BxcsjYx6ZVxeuXC
         MOiq6W7uf3foH9ZGkU9nsZUm6TawTZwbUjZz6Z65WoSEu8gZeTW5PENXNkrplWJTo1mS
         mwqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768593365; x=1769198165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v7luFe9q5FyU1n9+ffSge7aXZuT6jKQVxOiNsHnXneU=;
        b=IMqsYGYiGSWxgCs20So0xPHwfAybGW40hwKc4F0VP94QHBFCv/NB7ugnqbc+p6N6qM
         Ah+quHXYE8MqonKwbZi3i4NLjzFbu7mPYW62ScNNE+ef/OmPw0r/vwRvF/4zMBDellOo
         uG+9EUZJ23inqZqhsOJNeqDxLhooEyjBQs1WUgSZbJiQ8oqMaXzLW/83klGxoLFbTaeO
         agIuUHgIlqwF1PyS22+z9Wetl/OkGUZ4vj3ExEo5L/VDdTs5j5xJqdPe23va2sEeQHcT
         Shz6oSKtbw/7sJekpmCRSNnc5EMQKopElZ6zgJDBpRBptg3FgjwbBz1WvzUqeivT1/xU
         rPIA==
X-Forwarded-Encrypted: i=1; AJvYcCWP5OpKIxdWIIKKM8NNg5YKEuB+3/87nDEwkSm8pgThzUEVuJ8WMcCyyjvLJoktBg3iUzgyCI7XtfXs@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7iOLM/sST9L3nvvGu0S6gFXHSN76TiYU2xWG5Z9bOA/BNeewS
	G2D4Cixyu2zELDHxCKXx9+9zRqnxPWczuEVslGbAstY7Do8O6yyVrrNbsZIAIu6ohs/hROVa5en
	rc3rY4QENSxgUaTy0F/5c9DbJySTYzXo=
X-Gm-Gg: AY/fxX5+MLKoJBTsw+nLGUvgSGUOcH/+9RezVxQk0o97y5fYgfwJf5hPrDeZdZQcsTu
	Ld/5e01eluwyRL4OXty0nITW5TE11MNtrjRQwd4XHp3WbhzydCqxZd7G33qbEfz02zlPfRomUkr
	NT+cJtkFckSpkW3lY2qhZzuyz2ds3tfGTNMgVAUH19PVTK4eYG4hww9eGlce4SuWPnZ6036M7qs
	wMiZa9nIbnfzuEu2fDlEl5x2juazZ7D0PLu3iLg4zzIDyOT9SK7U2VjtRt8Pl0gXTqwfbeASw==
X-Received: by 2002:a17:90b:48c2:b0:340:9ba6:8af4 with SMTP id
 98e67ed59e1d1-35272fb1053mr3036032a91.35.1768593365059; Fri, 16 Jan 2026
 11:56:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1768489876.git.lucien.xin@gmail.com> <89a67cd3c41feb4e0129bcdcdf0bfe178528c735.1768489876.git.lucien.xin@gmail.com>
 <0daa8090-b63f-4d7c-870e-d32dd7f85266@samba.org>
In-Reply-To: <0daa8090-b63f-4d7c-870e-d32dd7f85266@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 16 Jan 2026 14:55:53 -0500
X-Gm-Features: AZwV_Qh58N4F8YGBusGZIfolR_j7I81bm-7lOEb96rjlzEdRB88nU29XlG5Ywms
Message-ID: <CADvbK_fmU=0GeB-32uv=+MOxHA8ZXjQeysqF1=z1f0eBt7pgTg@mail.gmail.com>
Subject: Re: [PATCH net-next v7 16/16] quic: add packet parser base
To: Stefan Metzmacher <metze@samba.org>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Moritz Buhl <mbuhl@openbsd.org>, 
	Tyler Fanelli <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, 
	Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, 
	John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2026 at 11:20=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Am 15.01.26 um 16:11 schrieb Xin Long:
> > This patch usess 'quic_packet' to handle packing of QUIC packets on the
> > receive (RX) path.
> >
> > It introduces mechanisms to parse the ALPN from client Initial packets
> > to determine the correct listener socket. Received packets are then
> > routed and processed accordingly. Similar to the TX path, handling for
> > application and handshake packets is not yet implemented.
> >
> > - quic_packet_parse_alpn()`: Parse the ALPN from a client Initial packe=
t,
> >    then locate the appropriate listener using the ALPN.
> >
> > - quic_packet_rcv(): Locate the appropriate socket to handle the packet
> >    via quic_packet_process().
> >
> > - quic_packet_process()`: Process the received packet.
> >
> > In addition to packet flow, this patch adds support for ICMP-based MTU
> > updates by locating the relevant socket and updating the stored PMTU
> > accordingly.
> >
> > - quic_packet_rcv_err_pmtu(): Find the socket and update the PMTU via
> >    quic_packet_mss_update().
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> > v5:
> >    - In quic_packet_rcv_err(), remove the unnecessary quic_is_listen()
> >      check and move quic_get_mtu_info() out of sock lock (suggested
> >      by Paolo).
> >    - Replace cancel_work_sync() to disable_work_sync() (suggested by
> >      Paolo).
> > v6:
> >    - Fix the loop using skb_dequeue() in quic_packet_backlog_work(), an=
d
> >      kfree_skb() when sk is not found (reported by AI Reviews).
> >    - Remove skb_pull() from quic_packet_rcv(), since it is now handled
> >      in quic_path_rcv().
> >    - Note for AI reviews: add if (dst) check in quic_packet_rcv_err_pmt=
u(),
> >      although quic_packet_route() >=3D 0 already guarantees it is not N=
ULL.
> >    - Note for AI reviews: it is safe to do *plen -=3D QUIC_HLEN in
> >      quic_packet_get_version_and_connid(), since quic_packet_get_sock()
> >      already checks if (skb->len < QUIC_HLEN).
> >    - Note for AI reviews: cb->length - cb->number_len - QUIC_TAG_LEN
> >      cannot underflow, because quic_crypto_header_decrypt() already che=
cks
> >      if (cb->length < QUIC_PN_MAX_LEN + QUIC_SAMPLE_LEN).
> >    - Note for AI reviews: the cast (u16)length in quic_packet_parse_alp=
n()
> >      is safe, as there is a prior check if (length > (u16)len); len is
> >      skb->len, which cannot exceed U16_MAX.
> >    - Note for AI reviews: it's correct to do if (flags &
> >      QUIC_F_MTU_REDUCED_DEFERRED) in quic_release_cb(), since
> >      QUIC_MTU_REDUCED_DEFERRED is the bit used with test_and_set_bit().
> >    - Note for AI reviews: move skb_cb->backlog =3D 1 before adding skb =
to
> >      backlog, although it's safe to write skb_cb after adding to backlo=
g
> >      with sk_lock.slock, as skb dequeue from backlog requires sk_lock.s=
lock.
> > v7:
> >    - Pass udp sk to quic_packet_rcv(), quic_packet_rcv_err() and
> >      quic_sock_lookup().
> >    - Move the call to skb_linearize() and skb_set_owner_sk_safe() to
> >      .quic_path_rcv()/quic_packet_rcv().
> > ---
> >   net/quic/packet.c   | 644 +++++++++++++++++++++++++++++++++++++++++++=
+
> >   net/quic/packet.h   |   9 +
> >   net/quic/protocol.c |   6 +
> >   net/quic/protocol.h |   4 +
> >   net/quic/socket.c   | 134 +++++++++
> >   net/quic/socket.h   |   5 +
> >   6 files changed, 802 insertions(+)
> >
> > diff --git a/net/quic/packet.c b/net/quic/packet.c
> > index 348e760aa197..415eda603355 100644
> > --- a/net/quic/packet.c
> > +++ b/net/quic/packet.c
> > @@ -14,6 +14,650 @@
> >
> >   #define QUIC_HLEN           1
> >
> > +#define QUIC_LONG_HLEN(dcid, scid) \
> > +     (QUIC_HLEN + QUIC_VERSION_LEN + 1 + (dcid)->len + 1 + (scid)->len=
)
> > +
> > +#define QUIC_VERSION_NUM     2
> > +
> > +/* Supported QUIC versions and their compatible versions. Used for Com=
patible Version
> > + * Negotiation in rfc9368#section-2.3.
> > + */
> > +static u32 quic_versions[QUIC_VERSION_NUM][4] =3D {
> > +     /* Version,     Compatible Versions */
> > +     { QUIC_VERSION_V1,      QUIC_VERSION_V2,        QUIC_VERSION_V1, =
       0 },
> > +     { QUIC_VERSION_V2,      QUIC_VERSION_V2,        QUIC_VERSION_V1, =
       0 },
> > +};
> > +
> > +/* Get the compatible version list for a given QUIC version. */
> > +u32 *quic_packet_compatible_versions(u32 version)
> > +{
> > +     u8 i;
> > +
> > +     for (i =3D 0; i < QUIC_VERSION_NUM; i++)
> > +             if (version =3D=3D quic_versions[i][0])
> > +                     return quic_versions[i];
> > +     return NULL;
> > +}
> > +
> > +/* Convert version-specific type to internal standard packet type. */
> > +static u8 quic_packet_version_get_type(u32 version, u8 type)
> > +{
> > +     if (version =3D=3D QUIC_VERSION_V1)
> > +             return type;
> > +
> > +     switch (type) {
> > +     case QUIC_PACKET_INITIAL_V2:
> > +             return QUIC_PACKET_INITIAL;
> > +     case QUIC_PACKET_0RTT_V2:
> > +             return QUIC_PACKET_0RTT;
> > +     case QUIC_PACKET_HANDSHAKE_V2:
> > +             return QUIC_PACKET_HANDSHAKE;
> > +     case QUIC_PACKET_RETRY_V2:
> > +             return QUIC_PACKET_RETRY;
> > +     default:
> > +             return -1;
> > +     }
> > +     return -1;
> > +}
> > +
> > +/* Parse QUIC version and connection IDs (DCID and SCID) from a Long h=
eader packet buffer. */
> > +static int quic_packet_get_version_and_connid(struct quic_conn_id *dci=
d, struct quic_conn_id *scid,
> > +                                           u32 *version, u8 **pp, u32 =
*plen)
> > +{
> > +     u64 len, v;
> > +
> > +     *pp +=3D QUIC_HLEN;
> > +     *plen -=3D QUIC_HLEN;
> > +
> > +     if (!quic_get_int(pp, plen, &v, QUIC_VERSION_LEN))
> > +             return -EINVAL;
> > +     *version =3D v;
> > +
> > +     if (!quic_get_int(pp, plen, &len, 1) ||
> > +         len > *plen || len > QUIC_CONN_ID_MAX_LEN)
> > +             return -EINVAL;
> > +     quic_conn_id_update(dcid, *pp, len);
> > +     *plen -=3D len;
> > +     *pp +=3D len;
> > +
> > +     if (!quic_get_int(pp, plen, &len, 1) ||
> > +         len > *plen || len > QUIC_CONN_ID_MAX_LEN)
> > +             return -EINVAL;
> > +     quic_conn_id_update(scid, *pp, len);
> > +     *plen -=3D len;
> > +     *pp +=3D len;
> > +     return 0;
> > +}
> > +
> > +/* Change the QUIC version for the connection.
> > + *
> > + * Frees existing initial crypto keys and installs new initial keys co=
mpatible with the new
> > + * version.
> > + */
> > +static int quic_packet_version_change(struct sock *sk, struct quic_con=
n_id *dcid, u32 version)
> > +{
> > +     struct quic_crypto *crypto =3D quic_crypto(sk, QUIC_CRYPTO_INITIA=
L);
> > +
> > +     if (quic_crypto_initial_keys_install(crypto, dcid, version, quic_=
is_serv(sk)))
> > +             return -1;
> > +
> > +     quic_packet(sk)->version =3D version;
> > +     return 0;
> > +}
> > +
> > +/* Select the best compatible QUIC version from offered list.
> > + *
> > + * Considers the local preferred version, currently chosen version, an=
d versions offered by
> > + * the peer. Selects the best compatible version based on client/serve=
r role and updates the
> > + * connection version accordingly.
> > + */
> > +int quic_packet_select_version(struct sock *sk, u32 *versions, u8 coun=
t)
> > +{
> > +     struct quic_packet *packet =3D quic_packet(sk);
> > +     struct quic_config *c =3D quic_config(sk);
> > +     u8 i, pref_found =3D 0, ch_found =3D 0;
> > +     u32 preferred, chosen, best =3D 0;
> > +
> > +     preferred =3D c->version ?: QUIC_VERSION_V1;
> > +     chosen =3D packet->version;
> > +
> > +     for (i =3D 0; i < count; i++) {
> > +             if (!quic_packet_compatible_versions(versions[i]))
> > +                     continue;
> > +             if (preferred =3D=3D versions[i])
> > +                     pref_found =3D 1;
> > +             if (chosen =3D=3D versions[i])
> > +                     ch_found =3D 1;
> > +             if (best < versions[i]) /* Track highest offered version.=
 */
> > +                     best =3D versions[i];
> > +     }
> > +
> > +     if (!pref_found && !ch_found && !best)
> > +             return -1;
> > +
> > +     if (quic_is_serv(sk)) { /* Server prefers preferred version if of=
fered, else chosen. */
> > +             if (pref_found)
> > +                     best =3D preferred;
> > +             else if (ch_found)
> > +                     best =3D chosen;
> > +     } else { /* Client prefers chosen version, else preferred. */
> > +             if (ch_found)
> > +                     best =3D chosen;
> > +             else if (pref_found)
> > +                     best =3D preferred;
> > +     }
> > +
> > +     if (packet->version =3D=3D best)
> > +             return 0;
> > +
> > +     /* Change to selected best version. */
> > +     return quic_packet_version_change(sk, &quic_paths(sk)->orig_dcid,=
 best);
> > +}
> > +
> > +/* Extracts a QUIC token from a buffer in the Client Initial packet. *=
/
> > +static int quic_packet_get_token(struct quic_data *token, u8 **pp, u32=
 *plen)
> > +{
> > +     u64 len;
> > +
> > +     if (!quic_get_var(pp, plen, &len) || len > *plen)
> > +             return -EINVAL;
> > +     quic_data(token, *pp, len);
> > +     *plen -=3D len;
> > +     *pp +=3D len;
> > +     return 0;
> > +}
> > +
> > +/* Process PMTU reduction event on a QUIC socket. */
> > +void quic_packet_rcv_err_pmtu(struct sock *sk)
> > +{
> > +     struct quic_path_group *paths =3D quic_paths(sk);
> > +     struct quic_packet *packet =3D quic_packet(sk);
> > +     struct quic_config *c =3D quic_config(sk);
> > +     u32 pathmtu, info, taglen;
> > +     struct dst_entry *dst;
> > +     bool reset_timer;
> > +
> > +     if (!ip_sk_accept_pmtu(sk))
> > +             return;
> > +
> > +     info =3D clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX=
_PMTU);
> > +     /* If PLPMTUD is not enabled, update MSS using the route and ICMP=
 info. */
> > +     if (!c->plpmtud_probe_interval) {
> > +             if (quic_packet_route(sk) < 0)
> > +                     return;
> > +
> > +             dst =3D __sk_dst_get(sk);
> > +             if (dst)
> > +                     dst->ops->update_pmtu(dst, sk, NULL, info, true);
> > +             quic_packet_mss_update(sk, info - packet->hlen);
> > +             return;
> > +     }
> > +     /* PLPMTUD is enabled: adjust to smaller PMTU, subtract headers a=
nd AEAD tag.  Also
> > +      * notify the QUIC path layer for possible state changes and prob=
ing.
> > +      */
> > +     taglen =3D quic_packet_taglen(packet);
> > +     info =3D info - packet->hlen - taglen;
> > +     pathmtu =3D quic_path_pl_toobig(paths, info, &reset_timer);
> > +     if (reset_timer)
> > +             quic_timer_reset(sk, QUIC_TIMER_PMTU, c->plpmtud_probe_in=
terval);
> > +     if (pathmtu)
> > +             quic_packet_mss_update(sk, pathmtu + taglen);
> > +}
> > +
> > +/* Handle ICMP Toobig packet and update QUIC socket path MTU. */
> > +static int quic_packet_rcv_err(struct sock *sk, struct sk_buff *skb)
> > +{
> > +     union quic_addr daddr, saddr;
> > +     u32 info;
> > +
> > +     /* All we can do is lookup the matching QUIC socket by addresses.=
 */
> > +     quic_get_msg_addrs(skb, &saddr, &daddr);
> > +     sk =3D quic_sock_lookup(skb, &daddr, &saddr, sk, NULL);
> > +     if (!sk)
> > +             return -ENOENT;
> > +
> > +     if (quic_get_mtu_info(skb, &info)) {
> > +             sock_put(sk);
> > +             return 0;
> > +     }
> > +
> > +     /* Success: update socket path MTU info. */
> > +     bh_lock_sock(sk);
> > +     quic_paths(sk)->mtu_info =3D info;
> > +     if (sock_owned_by_user(sk)) {
> > +             /* Socket is in use by userspace context.  Defer MTU proc=
essing to later via
> > +              * tasklet.  Ensure the socket is not dropped before defe=
rral.
> > +              */
> > +             if (!test_and_set_bit(QUIC_MTU_REDUCED_DEFERRED, &sk->sk_=
tsq_flags))
> > +                     sock_hold(sk);
> > +             goto out;
> > +     }
> > +     /* Otherwise, process the MTU reduction now. */
> > +     quic_packet_rcv_err_pmtu(sk);
> > +out:
> > +     bh_unlock_sock(sk);
> > +     sock_put(sk);
> > +     return 1;
> > +}
> > +
> > +#define QUIC_PACKET_BACKLOG_MAX              4096
> > +
> > +/* Queue a packet for later processing when sleeping is allowed. */
> > +static int quic_packet_backlog_schedule(struct net *net, struct sk_buf=
f *skb)
> > +{
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     struct quic_net *qn =3D quic_net(net);
> > +
> > +     if (cb->backlog)
> > +             return 0;
> > +
> > +     if (skb_queue_len_lockless(&qn->backlog_list) >=3D QUIC_PACKET_BA=
CKLOG_MAX) {
> > +             QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVDROP);
> > +             kfree_skb(skb);
> > +             return -1;
> > +     }
> > +
> > +     cb->backlog =3D 1;
> > +     skb_queue_tail(&qn->backlog_list, skb);
> > +     queue_work(quic_wq, &qn->work);
> > +     return 1;
> > +}
> > +
> > +#define TLS_MT_CLIENT_HELLO  1
> > +#define TLS_EXT_alpn         16
> > +
> > +/*  TLS Client Hello Msg:
> > + *
> > + *    uint16 ProtocolVersion;
> > + *    opaque Random[32];
> > + *    uint8 CipherSuite[2];
> > + *
> > + *    struct {
> > + *        ExtensionType extension_type;
> > + *        opaque extension_data<0..2^16-1>;
> > + *    } Extension;
> > + *
> > + *    struct {
> > + *        ProtocolVersion legacy_version =3D 0x0303;
> > + *        Random rand;
> > + *        opaque legacy_session_id<0..32>;
> > + *        CipherSuite cipher_suites<2..2^16-2>;
> > + *        opaque legacy_compression_methods<1..2^8-1>;
> > + *        Extension extensions<8..2^16-1>;
> > + *    } ClientHello;
> > + */
> > +
> > +#define TLS_CH_RANDOM_LEN    32
> > +#define TLS_CH_VERSION_LEN   2
> > +
> > +/* Extract ALPN data from a TLS ClientHello message.
> > + *
> > + * Parses the TLS ClientHello handshake message to find the ALPN (Appl=
ication Layer Protocol
> > + * Negotiation) TLS extension. It validates the TLS ClientHello struct=
ure, including version,
> > + * random, session ID, cipher suites, compression methods, and extensi=
ons. Once the ALPN
> > + * extension is found, the ALPN protocols list is extracted and stored=
 in @alpn.
> > + *
> > + * Return: 0 on success or no ALPN found, a negative error code on fai=
led parsing.
> > + */
> > +static int quic_packet_get_alpn(struct quic_data *alpn, u8 *p, u32 len=
)
> > +{
> > +     int err =3D -EINVAL, found =3D 0;
> > +     u64 length, type;
> > +
> > +     /* Verify handshake message type (ClientHello) and its length. */
> > +     if (!quic_get_int(&p, &len, &type, 1) || type !=3D TLS_MT_CLIENT_=
HELLO)
> > +             return err;
> > +     if (!quic_get_int(&p, &len, &length, 3) ||
> > +         length < TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN)
> > +             return err;
> > +     if (len > (u32)length) /* Limit len to handshake message length i=
f larger. */
> > +             len =3D length;
> > +     /* Skip legacy_version (2 bytes) + random (32 bytes). */
> > +     p +=3D TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN;
> > +     len -=3D TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN;
> > +     /* legacy_session_id_len must be zero (QUIC requirement). */
> > +     if (!quic_get_int(&p, &len, &length, 1) || length)
> > +             return err;
> > +
> > +     /* Skip cipher_suites (2 bytes length + variable data). */
> > +     if (!quic_get_int(&p, &len, &length, 2) || length > (u64)len)
> > +             return err;
> > +     len -=3D length;
> > +     p +=3D length;
> > +
> > +     /* Skip legacy_compression_methods (1 byte length + variable data=
). */
> > +     if (!quic_get_int(&p, &len, &length, 1) || length > (u64)len)
> > +             return err;
> > +     len -=3D length;
> > +     p +=3D length;
> > +
> > +     if (!quic_get_int(&p, &len, &length, 2)) /* Read TLS extensions l=
ength (2 bytes). */
> > +             return err;
> > +     if (len > (u32)length) /* Limit len to extensions length if large=
r. */
> > +             len =3D length;
> > +     while (len > 4) { /* Iterate over extensions to find ALPN (type T=
LS_EXT_alpn). */
> > +             if (!quic_get_int(&p, &len, &type, 2))
> > +                     break;
> > +             if (!quic_get_int(&p, &len, &length, 2))
> > +                     break;
> > +             if (len < (u32)length) /* Incomplete TLS extensions. */
> > +                     return 0;
> > +             if (type =3D=3D TLS_EXT_alpn) { /* Found ALPN extension. =
*/
> > +                     len =3D length;
> > +                     found =3D 1;
> > +                     break;
> > +             }
> > +             /* Skip non-ALPN extensions. */
> > +             p +=3D length;
> > +             len -=3D length;
> > +     }
> > +     if (!found) { /* no ALPN extension found: set alpn->len =3D 0 and=
 alpn->data =3D p. */
> > +             quic_data(alpn, p, 0);
> > +             return 0;
> > +     }
> > +
> > +     /* Parse ALPN protocols list length (2 bytes). */
> > +     if (!quic_get_int(&p, &len, &length, 2) || length > (u64)len)
> > +             return err;
> > +     quic_data(alpn, p, length); /* Store ALPN protocols list in alpn-=
>data. */
> > +     len =3D length;
> > +     while (len) { /* Validate ALPN protocols list format. */
> > +             if (!quic_get_int(&p, &len, &length, 1) || length > (u64)=
len) {
> > +                     /* Malformed ALPN entry: set alpn->len =3D 0 and =
alpn->data =3D NULL. */
> > +                     quic_data(alpn, NULL, 0);
> > +                     return err;
> > +             }
> > +             len -=3D length;
> > +             p +=3D length;
> > +     }
> > +     pr_debug("%s: alpn_len: %d\n", __func__, alpn->len);
> > +     return 0;
> > +}
> > +
> > +/* Parse ALPN from a QUIC Initial packet.
> > + *
> > + * This function processes a QUIC Initial packet to extract the ALPN f=
rom the TLS ClientHello
> > + * message inside the QUIC CRYPTO frame. It verifies packet type, vers=
ion compatibility,
> > + * decrypts the packet payload, and locates the CRYPTO frame to parse =
the TLS ClientHello.
> > + * Finally, it calls quic_packet_get_alpn() to extract the ALPN extens=
ion data.
> > + *
> > + * Return: 0 on success or no ALPN found, a negative error code on fai=
led parsing.
> > + */
> > +static int quic_packet_parse_alpn(struct sk_buff *skb, struct quic_dat=
a *alpn)
> > +{
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     struct net *net =3D sock_net(skb->sk);
> > +     u8 *p =3D skb->data, *data, type;
> > +     struct quic_conn_id dcid, scid;
> > +     u32 len =3D skb->len, version;
> > +     struct quic_crypto *crypto;
> > +     struct quic_data token;
> > +     u64 offset, length;
> > +     int err =3D -EINVAL;
> > +
> > +     if (!sysctl_quic_alpn_demux)
> > +             return 0;
>
> Can this be made dynamic, turning it on if someone
> listens on a socket with QUIC_SOCKOPT_ALPN set?
>
> Otherwise I guess it silently doesn't work
> and needs administrator interaction.
>
Makes sense to me.

I will replace this with a static_key when adding QUIC_SOCKOPT_ALPN
socket options in patchset-2:

        if (!static_branch_unlikely(&quic_alpn_demux_key))
                return 0;

static_branch_inc() and static_branch_dec() it in quic_hash() and
quic_unhash() if alpn is set for listening sockets.

Thanks.
