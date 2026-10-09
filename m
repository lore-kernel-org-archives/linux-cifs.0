Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045AF31A045
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 01:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791509308; cv=pass; b=WFWofSt6dXzQFBo2VAorsP8I64UvQAVglIJxQDRDAne9JtcPytf2QKuJ7oof4grzSiOCyi4I2bemIYadrLhF1u/g1fHlcMM7cVXmjpfgQTH4/8/ras0JciJ0FTNMq5aX46aGxAVWX5vXizPnpcULf/uidUkK171VWZA3LjrkvpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791509308; c=relaxed/simple;
	bh=XMa0oWP8WwisJDM0Y3bLC1+ONt4wpusAT8/XsdyqfBw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WISqQbpIDepr8GsYpoEU6K7fTqcsbF+xWrC4FiEgVlPcTZm0O5Bwo8MkNWr4mR5iOsz0Ygpk7M0CB+71sJ8WK19mRVekvPs/MX1Y8vugBGRUvXaBIv9gCMuY0wJfgj8HzcB9WtJ+EvZhMpRoomIXvtwuqNOJ/JJen8sim8YdvqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ILvudVEa; arc=pass smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILvudVEa"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-868b3248b2cso2924663b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 18:28:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791509306; cv=none;
        d=google.com; s=arc-20260327;
        b=EqqRIAxLTiCG+dkVz+gg3ZkjxupbO/4l37P54k9xLRoVuB8QEUIKFGPjKUrVxaoU3o
         4+4z6ylajY7J7epZ7lzRMDaED3RW/X+e1xxGkIiXL8bjuKIgSFRYUmIwyd+PORYomx2R
         TAUgP4oUHt2+UJeN3wgBy1efy040nK52OKJLxLzXimpV/Ne+1PE1YrhAxXsnLpaBZbKO
         ocMzcP1E1gaew2sIwjVnLL6UizRvAQJJtD6ooqpeGOCWZKjIa8vrqGVqcJXiNgFvQ03B
         u0CWOoEA4x2zMlHN55n71a8UkOCrpsBdJ1s9NA8zjuVw63l1a1ySDWmMX7Aa1UZFNIZs
         3jIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VJ5H5G50ATCR6DhtkjxgOK/BdPUHl43Tg816ttjnhnM=;
        fh=94x5h4HaVWXaMwUhLhY5NRHfWEVasU8B92k+UvLwJgA=;
        b=lecDptdFpAqROcymvISgVHG4AteO4F1pzbYuXFdr7hzYT2iMZP3B0vGLogIjE4wPvt
         khw2oy/WW+Uj6VAxdV2t4h5IYdEfVd/99X4SrCof/HFIzJmFCyS/sP+GEBePi9O+rg4a
         rvZO46hXycV0iKoUuQgR2SPmptFtpvIvK2PdW9gZAVya9JMTWoG4fUYyvtRy8Vx4RsaQ
         vEQ+Nh4BUXpP/4zpo5CcyG79ejs2V1wD1MDR8LU7ZjPDzdVgFbDovzimS07man7OETS8
         RgsU4PA4wbJ7OAwTdwZNSn+pxbOFVxUeTaOzkCvCKW/S7fOAaABy8VKAJo4Bdeeyak7/
         iDHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791509306; x=1792114106; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VJ5H5G50ATCR6DhtkjxgOK/BdPUHl43Tg816ttjnhnM=;
        b=ILvudVEagFJt2UimDwF6ADSBBtKIPhqKkfN2+NjdooADC4SJpUCzJRVYASK1PYRb36
         /X7/q/fS/mQPsCul59eY4oz1rC+7BnNv5e6ApDSXV14J4Dcxv1n5yFFc8/TdpGUVbCvy
         Vwti4TcfSTQ5/k3WEpYhZFXQTSGZaxChw2Qs7Vii+w3wEn+i4AMuZTwOkpzqb8zd1NF4
         S0OVWXP2O2wrC7aA3fDbs4WRMTyp5EYOCLSLPIvANtNUPqVNVdvZ/8+3NjEaC4zT25hh
         HUuDIHANp1XnoW8B30liW5BUzrui7KSkENODzc1pSSb3kpjHVtYO3s+r+Svul5uWwCEj
         HkPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791509306; x=1792114106;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VJ5H5G50ATCR6DhtkjxgOK/BdPUHl43Tg816ttjnhnM=;
        b=2nsozxQuP6zGIOFee0GWE1TYxXLPc1xWr4ladAeIHa+tEcVj2DBQE2NzTAPC8YbtnT
         xGpe+Cv7Rx6x4HJCIQMRgubj4lGb/QEYbSO3ny9apJ+UGq1iBwWkYcm/SQZOXRD/U37O
         kSYNZwzp3AykyGmIS2n/VrBsBE+DNptRquVh0lMznCt6OhGUiUlGJ/ouWmVkaRC/RM1u
         +zmLa+oghcPlDgs9GkMoNC4fUkXKtQ9Eq+7NISJrsn1Abg6jXvhIRNQ/Zo2EgmU4uzK3
         OsmPwlw8V+NjLeLWD1tdCZUmgdJghjrwY+ZudL7zTo+yOhNN1xR9R8k2UikPbWDJE54T
         vW2w==
X-Forwarded-Encrypted: i=1; AKwUvBzQpUxYTeLTtOaUmQA+qGgdDvSQHT0CbJtCCxgVOD2y2Ux0R91oGzaAQe3opFvCU4TtSrJ5EKquKofT@vger.kernel.org
X-Gm-Message-State: AFuF++mipmevDDnn552Bg+xBN/2H6BKZ81D0TzhZqsr9xj+1cSLmlX03
	DkxDehrArfHxwZrzrCf8bYPeA/6amJbPfZ/atrnLAVDx696gtFJsbb1YhZMpAlJ85tcRfgKkrQ8
	cHDJ1357+NHGMkvjTXSEvxXCbfkNpeb+sNENdCzU=
X-Gm-Gg: AYBFou3RknyXjH7DXpo3deVP524FdJ0o3YSj27zJ9BHzmTDWRZajPAs+kkZXrjKCHj+
	Ml5SJBj+RcdYrMZBFyOsaMhges2UBMhG9cg4080X4s/TTeQ1PZUv1dCXtX6Bi15g8pjeHfFd8vB
	zkgKHAT4gmsMBm4kn/w3FoWeYLtu481RwODiQZMfzBhNQAl5ViwX+/HTGUSxSLQ+XwYhfBxKNHJ
	KQ7e10k85X/nu3+0AoAGdNlycHd2WrW/Ct33f4lvRxF2c4JqfEz53b2K8Wpc5eJ43lTz+5aw/jw
	PomNfV9hSBGrruEvMKfmgz+F6qMJPAOSjTlX5fk/VmzaBn6kwWNmySiiP8hsENkm2OgH3qZ2IW0
	wH+lTd7EXmHko8vynqAed9fLt8DEkh4FRnOo3vpAZt2YLhBgOyBm2
X-Received: by 2002:a05:6a20:430d:b0:3de:51e1:e7c1 with SMTP id
 adf61e73a8af0-3e16baa4b77mr279638637.3.1791509306166; Thu, 08 Oct 2026
 18:28:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a691d4ce8c646dd1d70f1c0f88f081ec30bd03a1.1791227050.git.lucien.xin@gmail.com>
 <179133510837.434549.10953579867468905208@kernel.org>
In-Reply-To: <179133510837.434549.10953579867468905208@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 8 Oct 2026 21:28:14 -0400
X-Gm-Features: AclHuK-pXNUD0zZS35-RypI6zyh8BcFEPS1X53_XEgrT9cE9IlUL4Q1fx7i2pds
Message-ID: <CADvbK_e+wdmcEgY9coo_MY8v1WFPbZ1hP50vKXu7FCSHDTxR4g@mail.gmail.com>
Subject: Re: [PATCH net-next v16 06/15] quic: add stream management
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org, 
	metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com, 
	dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev, 
	chuck.lever@oracle.com, jlayton@kernel.org, steved@redhat.com, hare@suse.de, 
	aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org, 
	mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com, 
	jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net, 
	marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com, 
	mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 6, 2026 at 9:05=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wrot=
e:
>
> Thank you for your contribution! Sashiko AI review found 4 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 2 =C2=B7 Low: 2
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] quic_stream_init() (net/quic/stream.c) allocates the per-
>   socket 64-entry hlist_head table (512 bytes on 64-bit) with=E2=80=A6
> - [Medium] The per-socket stream table has a fixed 64 buckets and a
>   predictable, unkeyed hash, (stream_id >> 1) & 63 in quic_stream_head().
> - [Low] The uAPI header (include/uapi/linux/quic.h) puts send and receive
>   stream states in one anonymous enum, so the receive states start at 6=
=E2=80=A6
> - [Low] The comment above
>   bidi_blocked/uni_blocked/bidi_pending/uni_pending in struct=E2=80=A6
>
> --
>
> quic: add stream management
>
> This patch adds struct quic_stream_table, a per-socket hash table of
> struct quic_stream objects. It also adds helpers to get, create and put
> send and receive streams. It includes logic to check stream ID limits and
> to decide when MAX_STREAMS frames should be sent to the peer.
>
> > diff --git a/net/quic/stream.c b/net/quic/stream.c
> > new file mode 100644
> > index 0000000000000..c0bfaab0be8e2
> > --- /dev/null
> > +++ b/net/quic/stream.c
>
> [ ... ]
>
> > +#define QUIC_STREAM_HT_SIZE  64
> > +
> > +static struct hlist_head *quic_stream_head(struct quic_stream_table *s=
treams,
> > +                                        s64 stream_id)
> > +{
> > +     /* Skip the SERVER initiator bit, which is constant per endpoint.=
 */
> > +     return &streams->head[(stream_id >> 1) & (QUIC_STREAM_HT_SIZE - 1=
)];
> > +}
> > +
> > +struct quic_stream *quic_stream_find(struct quic_stream_table *streams=
,
> > +                                  s64 stream_id)
> > +{
> > +     struct hlist_head *head =3D quic_stream_head(streams, stream_id);
> > +     struct quic_stream *stream;
> > +
> > +     hlist_for_each_entry(stream, head, node) {
> > +             if (stream->id =3D=3D stream_id)
> > +                     break;
> > +     }
> > +     return stream;
> > +}
>
> [Severity: Medium]
> Can a remote peer put all of its live streams on a single chain here?
>
> The hash in quic_stream_head() is fixed and has no key. Bit 0 of
> (stream_id >> 1) is the uni bit, so bidi IDs land only in even buckets an=
d
> uni IDs only in odd ones. That gives each stream type 32 buckets, and
> every 32nd stream of a type maps to the same bucket.
>
> The peer decides which of its streams stay open. It could open streams up
> to the advertised limit and then finish or reset every stream except the
> ones that hash to one bucket. It then gets new credit through:
>
> quic_stream_put()
>     streams->recv.bidi_pending =3D 1;
> quic_stream_max_streams_update()
>     streams->recv.max_bidi_stream_id =3D max;
>
> If the peer repeats this, every live peer stream ends up on one hlist
> chain. That is up to recv.max_streams_*, which is 100 by default and up t=
o
> QUIC_MAX_STREAMS.
>
> Once the RX path lands, quic_stream_get() will call quic_stream_find() fo=
r
> each received STREAM, RESET_STREAM, STOP_SENDING and MAX_STREAM_DATA
> frame. Each lookup would then walk the whole chain under the socket lock
> in softirq. A single datagram can carry many small STREAM frames.
>
> Would a keyed hash (for example, seeded per socket), or a larger or
> resizable table, be worth considering? This lookup does not have an RX
> caller in this series yet.
>
True.

Passing net and using net_hash_mix(net) as seed should work.

> [ ... ]
>
> > +/* Create and register new streams for sending or receiving. */
> > +static struct quic_stream *quic_stream_create(struct quic_stream_table=
 *streams,
> > +                                           s64 max_stream_id, bool sen=
d,
> > +                                           bool is_serv, gfp_t gfp)
> > +{
>
> [ ... ]
>
> > +     while (stream_id <=3D max_stream_id) {
> > +             stream =3D kzalloc_obj(*stream, gfp);
> > +             if (!stream)
> > +                     goto free;
> > +
> > +             stream->id =3D stream_id;
>
> [ ... ]
>
> > +             stream->recv.window =3D stream->recv.max_bytes;
> > +             hlist_add_head(&stream->node, &head);
> > +             stream_id +=3D QUIC_STREAM_ID_STEP;
> > +     }
>
> [Severity: Low]
> Should recv.state be initialized to QUIC_STREAM_RECV_STATE_RECV here?
>
> The uapi header puts the send and receive states in one enum:
>
> include/uapi/linux/quic.h:
> enum {
>         QUIC_STREAM_SEND_STATE_READY,
>         ...
>         QUIC_STREAM_SEND_STATE_RESET_RECVD,
>
>         QUIC_STREAM_RECV_STATE_RECV,
>         ...
> };
>
> That makes QUIC_STREAM_RECV_STATE_RECV equal to 6. The stream comes from
> kzalloc_obj() and recv.state is never set. Every new stream therefore
> starts with recv.state =3D=3D 0, which is QUIC_STREAM_SEND_STATE_READY an=
d not
> a receive state.
>
> The only reader in this patch is quic_stream_put():
>
>         if (stream->recv.state < QUIC_STREAM_RECV_STATE_RECVD)
>                 return;
>
> This works only because 0 is less than QUIC_STREAM_RECV_STATE_RECVD. Any
> equality check against QUIC_STREAM_RECV_STATE_RECV would see an invalid
> receive state. So would code that reports the state to userspace through
> the state field of struct quic_stream_update.
>
> [ ... ]
>
> > +int quic_stream_init(struct quic_stream_table *streams)
> > +{
> > +     struct hlist_head *head;
> > +     int i;
> > +
> > +     head =3D kmalloc_objs(*head, QUIC_STREAM_HT_SIZE);
>
> [Severity: Medium]
> Should this allocation be charged to the memcg?
>
> When no gfp argument is given, kmalloc_objs() defaults to GFP_KERNEL. The
> 64-entry table (512 bytes on 64-bit) is therefore not accounted.
>
> Other per-socket memory in this patch is accounted.
> quic_stream_create() adds __GFP_ACCOUNT for the stream objects, and the
> sock itself comes from a SLAB_ACCOUNT proto slab.
>
> quic_init_sock() calls this for every socket(2). An unprivileged process
> in a memory-limited cgroup therefore gets 512 bytes of unaccounted slab
> for each QUIC socket it creates.
>
> Would kmalloc_objs(*head, QUIC_STREAM_HT_SIZE, GFP_KERNEL_ACCOUNT) be mor=
e
> consistent here?
True.

It's good to have it.

Thanks.
>
> [ ... ]
>
> > diff --git a/net/quic/stream.h b/net/quic/stream.h
> > new file mode 100644
> > index 0000000000000..cb6b35929ba51
> > --- /dev/null
> > +++ b/net/quic/stream.h
>
> [ ... ]
>
> > +     /* STREAMS_BLOCKED_BIDI/UNI sent and awaiting ACK for send limits=
 and
> > +      * MAX_STREAMS_BIDI/UNI sent and awaiting ACK for recv limits;
> > +      * MAX_STREAMS_BIDI/UNI needs to be set for send limits.
> > +      */
> > +     u8 bidi_blocked;
> > +     u8 uni_blocked;
> > +     u8 bidi_pending;
> > +     u8 uni_pending;
>
> [Severity: Low]
> This isn't a bug, but does the last line of this comment name the right
> limits?
>
> In this patch, bidi_pending and uni_pending are only used on the recv
> limits. quic_stream_put() sets streams->recv.uni_pending and
> streams->recv.bidi_pending. quic_stream_max_streams_update() reads and
> clears only streams->recv.*_pending when deciding whether to send
> MAX_STREAMS_UNI/BIDI.
>
> Should it say "for recv limits" instead?
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1791227050.git.lucien.xin%40gmail.com
