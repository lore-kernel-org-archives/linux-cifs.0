Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF23338596
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 20:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781297329; cv=pass; b=fLWkQ7Y7fcjxF348Vv5hShQs0+WwKbeDAtgAtXrsOuJxNNSTJ1Fvge63VJJPL+hM1YqQZhWtt2JTKYDMy5MawoX2xRQE/PGbPy5lpiSPf5j813+xFnpXSFKArtTaNwxiL1QtWBLhMExXPx9G7Xy9e6W2tNhUyrZySzaA4buiMY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781297329; c=relaxed/simple;
	bh=/Fphz4AEg7VLjRCOZxlhmLxXkJAlQQIuOqqXUfYvmhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JcHD4fYA5iSreNTo9RAgLgy8It0y1BMTT0+LhG5DQvJSBAQaD7nwWvJObjPsTcJkmbN2L3/lpanVh65GLB8NXAteFsJ2sW9eDR+v6m7nN5wQp/jvhGV95qTjOl2/q2Zglfr4zis74eLWZBZ/Rgk4MuyLbdaz8j5tFp7p8jUDUH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rz4O4uXk; arc=pass smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rz4O4uXk"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-842273a2c4dso1009834b3a.3
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 13:48:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781297327; cv=none;
        d=google.com; s=arc-20240605;
        b=QF7pE9Gyj480knu05++eqxW9tdxvyH1/4/gPXv3ilR5JjAm7Bnd9y8G6Q66x3CBnhb
         qWF8D9EhaKwFzHH8DfZimiklF6O4M+M9oysshFTvWldn5PFrCA6q5EhhTv++FZoQTSk0
         IZRX+X3j468uHjKMcUGdxTj7l/lWEz2W0WLPLC+b8ha3kjql9A4b5pYaBtRvswAEmbQk
         0GVp0WE+CrCl4f7DImgHf5s18v6yWrQbZFeUt1ZytDElN3YtXO6ZOl7/uclrXjTMqVXP
         7KRPfC7VhgXPiG5Hx4FaP4mTn+XbWS1T3QSmzdIJPHuQtYqse0OohRXolhLxtOPnETiX
         SDdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c8b+p6IKKfS6Vat52avOATunY8iF7eAXvlismBPMZXo=;
        fh=hvlMLhEiGDugKAJqp4kGTRl+TqBm3MIlMNQeSu8jny0=;
        b=MXSqhF5yXJ9o4fhW1cudqg53YJ19OyzPi+0E4T5GWRUzH4S9zeAJyMmSsp9IrzWnMf
         8Vwql9kvIUyAvU6bixGs27g3eGNj+nEpxzSVAVueaRvquEOr7H0mEaXoyaT0J8FZ+x82
         VryN710kq0PtKJV6jlLpINw7jTQqADICoTDxmxhqy3STz1FPEz2C088fzsF1Se6CcHGm
         fgDcysh1E/IwjDzJdlgsRUc3sIPLoxnCdwP+pBIUYyz/ZR4iseTzNh5DTKvvG/IYZLz4
         XD9eDJX2H4mufKKK0xngKDw3ybbpPAKNeSVEyrLq2XdfVf00uulsZKeSjaa6ZdQYe3Ri
         bKAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781297327; x=1781902127; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8b+p6IKKfS6Vat52avOATunY8iF7eAXvlismBPMZXo=;
        b=Rz4O4uXkUS4KQ+emsU9w10n54DK1FbhKyEug7x8FUEwq9YX80TyLM3Y1paWUBB5vDE
         YXQcdQShvg5lTU+BR+IzkYTBajUTLyor2RrDATfsaoMSFtgtuGKXAQRyLeLLoZ+tNBPj
         83/oOoUHChVzIA4lFR1zVgS+lDIiLO5TPORPwf5UgXWo7RmfiQcpuZDvmyuREH1R8OJq
         PbAqmxF/L1VR+4TN6k11QYGsZ9yvcNRUbO6v1WJwNze+o2sUsV6imgUVsTeNdKP6zO9H
         l0S5KZqriKwxhL3d6t9yyRJ6v7gFSDjGlkz/IqkwPGyvwB3da4ooD+mApB3tpR2lgdqr
         PWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781297327; x=1781902127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c8b+p6IKKfS6Vat52avOATunY8iF7eAXvlismBPMZXo=;
        b=Hbdl8us/NpzXHHeZ6eJcvtBrZzK1qLtnGOEiePI9qJm+A+E6c9Z8N1QbyQZ5AW7jUy
         sgaP5elZk4nuxLSDYBA7HoWtgfRfgwt344IST/xWRgqwZSFUheGoyjMjFKEXNzFw+fGx
         RKF0+xss4XSYj0oab5gtODPF2ZVYbUcA7CvPQ9f2568F4aRCuDw5/Zpdg9nCeikassSf
         3Ai/lOxcerBZkdZN4sLRL5953Q/tbtnvPTgDE0uKY+rAs7exC5Vob8GWA7xMVM7MwoRU
         FBUDHfqXQo+ghaWel/3QiO4+5ykY5wGRws0xg9u5tk0XqvFN/+aif5hj8es4Xv+MqoPw
         Xfyw==
X-Forwarded-Encrypted: i=1; AFNElJ/evYVZYFGam18Kvhlzbz+UGXMtMKWDpinEtUsnAyKxIOR7PVyl8ZvfnUfYk7C34U1AQKxdm0DYDPjI@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/lmiCIjZG0RMvUTYyze/K4IoEHqgDrcYEB+x/mzaFeLqSxX7z
	Sju2Py+if9tPN1ZkDcvCtD2STvULuIfLD+xW/mQBjlvRZ0WR3tmG67Qn1gsPVPN576moaUSjCMb
	fdCmZ5qRTFHat8WIGNp2jAwZ46D+k5QQ=
X-Gm-Gg: Acq92OGVwOoJ5t6Oxy9uoByfAk13QyW0aROzTZ/jX1F64ZzoGvCMpY6ZN8pNp3QcXGc
	0rsEeBgfrKM4gFrZdOxoFFIe0TqWecVzVon8IRFgJ5pZYjZBdng3sf/vGgipkK1PKRljimrOeT6
	GMlenyWc/LLRONHyBhviG9b2l5EkqZaDZEcGh7/XJJa9MLs1netgE8qNTm6MnC0hQ8wmndISL8x
	49VCBLzmw6a/JHnxjYxnhjNSccxv16iu/sKHQ/qa9KZF3yQuJ9ZYBAgVetl/rNGsIeYWnV/QiBv
	SRzf+Z+62j3Xb/A3TcFBqJGeN4K0RY774uNlW6QkmdWzj1z9qhWi4zNgW4ZYQaoysHzdG/G4Ldz
	AE6jJUQ==
X-Received: by 2002:a05:6a00:2351:b0:841:69e4:f21b with SMTP id
 d2e1a72fcca58-8434ce6b56dmr5081219b3a.39.1781297326992; Fri, 12 Jun 2026
 13:48:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0b03854cabaac243a0cdf42375c66cd033750bd0.1780855297.git.lucien.xin@gmail.com>
 <20260611082008.138377-1-pabeni@redhat.com>
In-Reply-To: <20260611082008.138377-1-pabeni@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 12 Jun 2026 16:48:34 -0400
X-Gm-Features: AVVi8CfE7HTOI2SzE8B2TbKR1nN28BzQl7R5aNYkEsfQb-6dW-l_TEr2rNPdIw4
Message-ID: <CADvbK_eHGSu3Epj-oGudVmjWwas-goF2rFGb-J-vYOvW+L9Npw@mail.gmail.com>
Subject: Re: [PATCH net-next v13 15/15] quic: add packet parser base
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, edumazet@google.com, horms@kernel.org, metze@samba.org, 
	mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com, 
	dreibh@simula.no, linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev, 
	chuck.lever@oracle.com, jlayton@kernel.org, steved@redhat.com, hare@suse.de, 
	aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org, 
	mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com, 
	jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net, 
	marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com, 
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2026 at 4:20=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> From: AI Reviewer <ai@example.com>
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> Full review at: https://netdev-ai.bots.linux.dev/sashiko/
> ---
> quic: add packet parser base
>
> This patch adds the QUIC packet RX parser, including ALPN extraction
> from the Client Initial to demux to the right listener, an ICMP-driven
> PMTU update path, and a per-net backlog/work for deferred parsing.
>
> > diff --git a/net/quic/packet.c b/net/quic/packet.c
> > index ba5204aceda6..430fc06d0012 100644
> > --- a/net/quic/packet.c
> > +++ b/net/quic/packet.c
>
> [ ... ]
>
> > +static int quic_packet_get_alpn(struct quic_data *alpn, u8 *p, u32 len=
)
> > +{
> > +     int err =3D -EINVAL, found =3D 0, exts =3D 0;
> > +     u64 length, type;
> > +
>
> [ ... ]
>
> > +     while (len >=3D 4) { /* Scan extensions for ALPN (TLS_EXT_alpn). =
*/
> > +             if (!quic_get_int(&p, &len, &type, 2))
> > +                     break;
> > +             if (!quic_get_int(&p, &len, &length, 2))
> > +                     break;
> > +             if (len < (u32)length) /* Incomplete TLS extensions. */
> > +                     return 0;
>
> [Medium]
> Should this branch be treated as a parse failure rather than a success?
>

The rest of the TLS extensions could be in the CRYPTO frame of
the next initial packet.

Returning error will cause packets to be dropped in the callers.

> The other length-bound checks in this same function return err (-EINVAL)
> when a declared length exceeds the remaining buffer, but this one returns
> 0 without populating alpn.

The splitted TLS CLIENT_HELLO messages are very rare.
The ones I saw from some QUIC implementations are splitted from these
TLS EXT points. I will improve it when seeing more different split points.

> The callers initialise alpn as
>
>         struct quic_data alpns =3D {};
>
> and quic_listen_sock_lookup() then takes the no-ALPN branch:
>
>     if (!alpns->len) { /* No ALPNs or parse failed */
>         sk_nulls_for_each_rcu(tmp, node, &head->head) {
>             ...
>             if (... && (!alpns->data || !quic_alpn(tmp)->len)) {
>
> Because alpns->data is still NULL, the match collapses to true and any
> listener bound to the address/port will match, including ones that
> registered a specific ALPN list. Can a peer reach an ALPN-restricted
> listener by sending a Client Initial with one extension whose declared
> length is larger than what is left in the ClientHello?
>
> Would returning err here (or always assigning alpn->data before
> returning) match the comment in quic_listen_sock_lookup() that
> distinguishes "TLS parsing succeeded but no ALPN was found" from "parse
> failed"?
>
ALPN demux is a feature trying its best to dispatch the first initial
to the right process. If it goes to the "incorrect" because the peer
doesn't provide proper ALPNs, the userspace handshake will reject it.

It's kind of the peer responsibility if it wants to get processed in the
right process, send with the right ALPNs then.

> > +             if (type =3D=3D TLS_EXT_alpn) { /* Found ALPN extension. =
*/
> > +                     if (length > QUIC_ALPN_MAX_LEN)
> > +                             return err;
> > +                     len =3D length;
> > +                     found =3D 1;
> > +                     break;
> > +             }
> > +             /* Skip non-ALPN extensions. */
> > +             p +=3D length;
> > +             len -=3D length;
> > +             if (exts++ >=3D TLS_MAX_EXTENSIONS)
> > +                     return err;
>
> [Low]
> Is the post-increment intended here? With TLS_MAX_EXTENSIONS =3D=3D 128, =
the
> check (exts++ >=3D 128) first becomes true when exts has already reached
> 129, so 129 extensions are consumed before bail-out even though the
> constant name suggests a cap of 128. Would
>
>         if (++exts > TLS_MAX_EXTENSIONS)
>                 return err;
>
> (or moving the check to the loop top) better reflect the intended limit?
>

will change to ++exts.

> > +     }
>
> [ ... ]
>
> > +static int quic_packet_parse_alpn(struct sk_buff *skb, struct quic_dat=
a *alpn)
>
> [ ... ]
>
> > diff --git a/net/quic/socket.c b/net/quic/socket.c
> > index 8f348d7c678b..19b164baf55d 100644
> > --- a/net/quic/socket.c
> > +++ b/net/quic/socket.c
>
> [ ... ]
>
> > +struct sock *quic_sock_lookup(struct sk_buff *skb, union quic_addr *sa=
,
> > +                           union quic_addr *da, struct sock *usk,
> > +                           struct quic_conn_id *dcid)
> > +{
>
> [ ... ]
>
> > +     rcu_read_lock();
> > +begin:
> > +     sk_nulls_for_each_rcu(tmp, node, &head->head) {
> > +             if (net !=3D sock_net(tmp))
> > +                     continue;
> > +             paths =3D quic_paths(tmp);
> > +             odcid =3D quic_path_orig_dcid(paths);
> > +             if (quic_cmp_sk_addr(tmp, quic_path_saddr(paths, 0), sa) =
&&
> > +                 quic_cmp_sk_addr(tmp, quic_path_daddr(paths, 0), da) =
&&
> > +                 quic_path_usock(paths, 0) =3D=3D usk &&
> > +                 (!dcid || !quic_conn_id_cmp(odcid, dcid))) {
> > +                     sk =3D tmp;
> > +                     break;
> > +             }
> > +     }
>
> [High]
> Is the sk memory itself RCU-protected here? sk_nulls_for_each_rcu()
> dereferences fields of tmp (sock_net(tmp), quic_paths(tmp),
> quic_path_saddr(...), etc.) before any reference is taken. That is only
> safe when the sk allocation is freed via RCU.
>
> quic_init_sock() does not call sock_set_flag(sk, SOCK_RCU_FREE), and
> neither quic_prot nor quicv6_prot sets slab_flags to SLAB_TYPESAFE_BY_RCU=
,
> so sk_destruct() (and quic_sock_destruct()) runs synchronously on the
> last sock_put(). Can a parallel close on tmp free the sock between
> sk_nulls_for_each_rcu() exposing it and the field dereferences above?
>
> The same shape appears in quic_listen_sock_lookup() further down, where
> quic_alpn(tmp)->len is read inside the RCU walk before
> refcount_inc_not_zero().
>

SOCK_RCU_FREE will be set in the patchset-2 via quic_hash().

> > +     if (sk && unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > +             sk =3D NULL;
> > +     rcu_read_unlock();
> > +     return sk;
> > +}
>
> [ ... ]
>
> > +struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_a=
ddr *sa,
> > +                                  union quic_addr *da,
> > +                                  struct quic_data *alpns)
> > +{
>
> [ ... ]
>
> > +     rcu_read_lock();
> > +     if (!alpns->len) { /* No ALPNs or parse failed */
> > +             sk_nulls_for_each_rcu(tmp, node, &head->head) {
>
> [ ... ]
>
> > +                     a =3D quic_path_saddr(quic_paths(tmp), 0);
> > +                     if (net =3D=3D sock_net(tmp) &&
> > +                         quic_cmp_sk_addr(tmp, a, sa) &&
> > +                         quic_path_usock(quic_paths(tmp), 0) =3D=3D sk=
b->sk &&
> > +                         (!alpns->data || !quic_alpn(tmp)->len)) {
>
> [ ... ]
>
> > @@ -48,6 +196,9 @@ static void quic_sock_destruct(struct sock *sk)
> >       for (i =3D 0; i < QUIC_CRYPTO_MAX; i++)
> >               quic_crypto_free(quic_crypto(sk, i));
> >
> > +     /* Deferred ALPN free for RCU readers in quic_listen_sock_lookup(=
). */
> > +     quic_data_free(quic_alpn(sk));
> > +
>
> Without SOCK_RCU_FREE or SLAB_TYPESAFE_BY_RCU on quic_prot/quicv6_prot,
> does moving the alpn free into the destruct callback actually defer it
> past an RCU grace period? quic_sock_destruct() is invoked from
> sk_destruct() on the final sock_put() and is not itself an RCU callback,
> so the comment's "Deferred ALPN free for RCU readers" assumption seems to
> rely on a guarantee that is not configured on this protocol. Should this
> patch also set sock_set_flag(sk, SOCK_RCU_FREE) in quic_init_sock(), or
> alternatively take refcount_inc_not_zero() in the lookup helpers before
> touching any fields of tmp?
>

SOCK_RCU_FREE will be set in the patchset-2 via quic_hash().

> >       quic_sk_destruct(sk);
> >  }
> >
>
> [ ... ]
> --
> This is an AI-generated review.
>
