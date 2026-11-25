Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795622977;
	b=MmvAYNuaSh9zwAWCodKNNAlaHB748lT0YIRi/wEDSEn0rN3FjQRz3+D//coIDuP/dG7j
	 a01AGo1g5VzzN15bWjkj3JrRfT3ppxr42cYp7fhT24z8vztBNOMFa5CenMWARmdbVa7fM
	 ITChOTjoOKsN3Q7mT/Wbl2+FoK5I5Q8CTkAXsr9revME3+WTJ8zVV6WuQnHrLEfduDqK+
	 baI10yjOjo+HDnTHqypFOLTIPDmgEcOogE6JoBNg7BEt5+D+SivYJTpWUccMCprJsBZPA
	 +PzFXS1+VpvPZ58DdEL26ViHzdJYlv7r47PEtwwmYviTKKpgJ2Menu1Wfwocdx5Q4jw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622977;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=u8edI8FeQSZp9/9wYopp3WXqEDb0aEYd4PyW+vHqD04=;
	b=mansKO7etXISKamzC5D8QHQT5lNbLaOhpw2oAaL4UhESiRv0vcJPqWseYbFXSrzscVwK
	 RR7gfKJ+McugnMxlEQxqFudAcCc8TPsc3KmLBj/+EVVPY+pqYzWkF4yq+CdOzP39m1xOa
	 zcU4D1X9eY33UjLcc/UvHm50QK4NDvMOqR4xfJUrev7KqAw8vsZAN01PtVRzabywXNA2B
	 LzjBCVD3daTGEEaTicT5bkixaNBEPD4yzi1A4Tgvy1ce9buYGa6+pqtny6lOrZnYjEy4t
	 Ncj84ZMPtVb5iO89etf3n/u35gYwdDkpkyDvyKMZlna7+5B0CLxPPHPQGdAt/fuFJwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RGdvFyZb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.169
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8696606A32D
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 16:09:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8696606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RGdvFyZb
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8b3577deeb0so2716270b3a.3
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 08:09:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795622976; cv=none;
        d=google.com; s=arc-20260327;
        b=crxjztH1St1xXvAfD797doOuE77lwm+tgNpfAxMCY79Qm6uOrftORi1zDkaAn9afUc
         L0tTFayvd1taiRq8taqJnLrcyYTZnPQ0Ebeq9LrGR2kg2Ii1cTmSRHQEBQCdPNgrFQ3o
         KcX9mH54KW9KYHYMWzBWfd5n5bjM+AehHvdlt7y48dXfJWOYndlySlo/ltwfl4hQdhXg
         ZsXmPLDuM4LquvvQ9i9ecNeUoMftPLWLNIKngUqApNjns/c9Tmqz5zeUUNluv/LlP2vo
         uEbrNnYa4oeJKCKMXMFuP7EbZpCko/LUy2chEEoaF/qZV5Dy4EPp7OY7gYJUiO40PRJw
         5RLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u8edI8FeQSZp9/9wYopp3WXqEDb0aEYd4PyW+vHqD04=;
        fh=qzOhVdeSs2exL0rKtGHoZCmAZQfrEh+Trf9urXjE4Zc=;
        b=RyRifrAjXqq1HWiBOkr9Dvwe08SaW2xSP9RVHtOO/ufbDpG45Yn8tAkWTh03lEiR5G
         qFujLFXh90QDsZKZYKeWZ3Y64M/+EIIJyfvxdl+R/NK5aBUga2CdmsECpFMQ5u6Dzvkr
         Wn6i4ljquKAYKNTNcZd7IlOst81RoQlX1fVI08rX9NidBeVw5vmbonNmCX/sEd2YmwTe
         SDpBWLgyJrD1bAP3aA2KVPinT8IavApkTuSLdrSmYlOx1/9xGHb6IVwTqBamvg8U04Nz
         kQ7htixNjm8HZqkSrMNctBfYkScOJkSFe+3bkGfzy2PvsexYyT9k8FIfLw2EynHEeQGY
         uGKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795622976; x=1796227776; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u8edI8FeQSZp9/9wYopp3WXqEDb0aEYd4PyW+vHqD04=;
        b=RGdvFyZbnMzNIxg36iRggwLlKAwT0D2LJK5qIOQEokaFn9B/SqNAhRJJ6ajydAMEdv
         jeeRJ5zHBU6TDPEb4o/EjfOgDDi6q9p/h9+pmtoJ5xyUqPTjEaTrMIvZrC2n1t2Ce8QC
         zH53VNmgHFtJxqLXblMQrg8+ULfuqxKpHjShKn1LCGkU9p1gBycyLMbokKZqHsipyox3
         gaTpRp19sCmfI0tKscIXN8Hk40GiG0v6tKVhHzSbLnuI6cKGWUyhOsPY4e20/JmbKJ7B
         KT6CyEJnlZBM2N491xGlvktrqXeb+9QvIJ3E3p//lkADFkpWcBFer5DAEB6qoJD0ijmu
         Sihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795622976; x=1796227776;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u8edI8FeQSZp9/9wYopp3WXqEDb0aEYd4PyW+vHqD04=;
        b=YpaL/rY2bva863ydWhfXr37wtyOcIOQ8fosUtWquZiM1r6ynS2a3q4zse705jqgRJt
         1U/+jtr8mDgydiO4HzaYB6sx0gLlbtkN9auZpGxK+sjZI2MeYC+5yBpmS0U97NvFbPrx
         pSveIgU+L4/VUa5s6VTeElbYeiXMRk0gBQPHhm8p9wTfL0b9HY4bkKMbawgfx4eRiOtA
         azZWZwjrVFM02bJ5lsTAbTpuOnW4xrPMT8bFHRDfD3+87A6gkJxXsaQd2xmFgSLpengB
         fIKZRlggbsSWCEVsPppVIQW/40IW74gdw/+SpNuBidNf+ApzttDSbMdQJbMAYW7gd53w
         lASA==
X-Forwarded-Encrypted: i=1; AL+hErHU8MNmvBVVC2DCYm0Khoy80UiZ9ESwwbk7cDKo1mQfty1+JfhwUqIM8Da3oVxZkihbjmAZxeEMD8O8@vger.kernel.org
X-Gm-Message-State: APuU4Z/ZFnOkIvMMl0veyHiHJJbkf70yig0hjtt+hGNT3rhYGsrG+RaJ
	qz7NbxL3LlqsPL91Eapk5BchxY21ffQ2Qs8bSlsT13e9pO2HzkcV6IqR+64YOkVqINRfAmFs7KN
	4UVlKllF9DAczcktpYPpZECFVxY8nLA0=
X-Gm-Gg: AZFdTZc5VmHv/17edCAA6Lhy2OKYSMIF8I47vntqOhWs5CJNpYHPH8aHh5vvHeOKrfh
	8wKOhRcGFVABiVt51WFxJRwC06C+chWK+mPEb8XYc6DiW4Si76ic0doYyLQr8Gj/pF+Kq3HXNpL
	ICOrcVVBERyusJtFt1DA8wwypXpLYzYYJ+hKl13yoIwFGU0FrDYLfJIdYQZdck7FV2pUK4R9wps
	v7REiN/JLxDxQ+aUByL0VLmo4eZk7zqNK7WdVXRdtFJOUDwAUKNLtoJYVLqIKaC4Hobnph7hEJG
	iVQgmz7mfguXQGoJdmb9C7mn8I31Chg6p1rRMyzp2ACwdseyEDff7TnS2nPL84fFoWA1XDtI4gZ
	JBoCb1Kk6YxnTHZVNJebeAA5ZmWJ3i1qx5V2RdM78thjle1obpF4LHClEQEN4G2i09n6NHItpmf
	6PAhvzDSQEfI3etHWuBo4OT94Mj4zazOO0Eqv6nq5b4TsFxA12ivSNeyd6hA41hQwRV/sG
X-Received: by 2002:a05:6a00:ad05:b0:8a0:70ff:ab28 with SMTP id
 d2e1a72fcca58-8c87daf37damr15090565b3a.60.1795622976032; Wed, 25 Nov 2026
 08:09:36 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <a0b0796446aa6da7e62134343e27abb459c3e4cf.1795393691.git.lucien.xin@gmail.com>
 <179548327264.3135.6491698928014688203@kernel.org>
In-Reply-To: <179548327264.3135.6491698928014688203@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 Nov 2026 11:09:24 -0500
X-Gm-Features: Aa3M54rOBsjgMkrX6FiWjub5OGP-lBrvCJFM9rh8E12fgXwHp5rULcB25ZvsU6o
Message-ID: <CADvbK_f42EbbC0fgn1a_HkrgAbqgmtGExogvNq6CZa892tz_cQ@mail.gmail.com>
Subject: Re: [PATCH net-next v19 07/15] quic: add connection id management
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
> - [Medium] quic_conn_id_retire() (net/quic/connid.c) handles 'retire the
>   last live consecutive CID' with `if (WARN_ON_ONCE(id_set->use_count <=
=3D=E2=80=A6
>
> --
>
> quic: add connection id management
>
> This patch adds struct quic_conn_id_set to manage source and destination
> connection IDs. It provides helpers to add, retire, find and look up CIDs=
.
> Source CIDs are also inserted into a global RCU hash table, which the RX
> path uses to look up the socket.
>
> > diff --git a/net/quic/connid.c b/net/quic/connid.c
> > new file mode 100644
> > index 0000000000000..1ddf8bc9b7910
> > --- /dev/null
> > +++ b/net/quic/connid.c
> > @@ -0,0 +1,313 @@
>
> [ ... ]
>
> > +/* Retire a connection ID by marking it dead, then remove consecutive =
dead
> > + * entries from the head of the list. The caller must ensure the numbe=
r falls
> > + * within the consecutive range [first_number, last_number].
> > + */
> > +void quic_conn_id_retire(struct quic_conn_id_set *id_set, u32 number)
> > +{
> > +     struct quic_common_conn_id *common, *tmp, *retired =3D NULL;
> > +     struct list_head *list;
> > +
> > +     list =3D &id_set->head;
> > +     list_for_each_entry(common, list, list) {
> > +             if (common->number > number)
> > +                     break;
> > +             if (common->number =3D=3D number) {
> > +                     if (common->dead)
> > +                             return;
> > +                     retired =3D common;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     if (!retired)
> > +             return;
> > +
> > +     if (WARN_ON_ONCE(id_set->use_count <=3D 1))
> > +             return;
>
> [Severity: Medium]
> Can a peer reach this WARN_ON_ONCE() using only its own
> RETIRE_CONNECTION_ID frames?
>
> For the source set, number comes from the peer. The v19 changelog moved
> this guard below the duplicate-retire check so duplicates would not hit
> the WARN, which suggests peer-chosen numbers are expected to get here.
>
> A retired source CID that is not at the head of the list is only marked
> dead. It stays on the list and stays hashed. quic_conn_id_lookup() does
> not check ->dead:
>
>         hlist_nulls_for_each_entry_rcu(s_conn_id, node, &head->head, node=
) {
>                 if (net !=3D sock_net(s_conn_id->sk))
>                         continue;
>                 if (s_conn_id->common.id.len !=3D len ||
>                     memcmp(scid, &s_conn_id->common.id.data, len))
>                         continue;
>
> Later in the series, quic_packet_get_sock() in net/quic/packet.c uses
> this lookup to route the packet to the socket and set cb->seqno. It does
> not check the dead flag either.
>
> Take a source set {0, 1, 2}, all live, use_count =3D 3, with the peer
> using CID 0:
>
>   peer sends RETIRE(1), then RETIRE(2)
>     -> use_count =3D 1, CIDs 1 and 2 are dead but still hashed
>   no replacement CID is issued (count still includes the dead middle
>   entries, so max_count or QUIC_CONN_ID_LIMIT may already be reached)
>   peer sends a packet with DCID =3D CID 1 carrying RETIRE(0)
>     -> quic_conn_id_lookup() still finds CID 1
>     -> quic_conn_id_retire(id_set, 0)
>     -> WARN_ON_ONCE(id_set->use_count <=3D 1)
>
> RFC 9000 Section 19.16 allows RETIRE(0) in that packet, since sequence
> number 0 is not the DCID of the packet carrying the frame.
>
> On panic_on_warn systems this would be a panic the peer can trigger
> remotely. Without panic_on_warn, the retirement is silently dropped.
>
> quic_conn_id_retire() returns void, so the caller cannot tell a refused
> retirement from a successful one. That means it cannot turn this case
> into a PROTOCOL_VIOLATION.
>
> Would it make sense to return an error here instead of warning? Or to
> reject packets addressed to dead source CIDs?
>
> No caller of quic_conn_id_retire() exists in this series yet. Whether
> this fires depends on how the RETIRE_CONNECTION_ID handler in the
> follow-up patchset checks the number before calling it.
>
False.

The WARN_ON_ONCE is a defensive invariant for catching programming errors,
not a peer-reachable path. The RETIRE_CONNECTION_ID handler in the next
patchset validates the sequence number before calling this function and
ensures replacement CIDs are issued before use_count drops too low.

> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1795393690.git.lucien.xin%40gmail.com
