Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792532114;
	b=2ITVpt54uPBpdI37byeMDhcXS5AWZytDk88Te/cZAzVAMjb4PM/C2mdJ14gU2HwM2afW
	 Fq4QTjZoLzC2yWtmDVS40jw+GGXdB9VRsZkx8vWMhCRp4cua7h3Tku9FY7ZINRoQWnxg9
	 DHn9yJMjkehbGxlhWtQNNkye5PFhm1YmNqb3Mz3ORTZHjfRcebgyUwQZx0ghCMihbVq1A
	 iV3rAkOQycIUzJ0oCRFDoQR1SA4+lzQ67c0pnuoUO3/mg6wWscTCdOCmmphf963XS0K58
	 kd8Hcj/iZKQ4B0tXNFAEe9ZP8A8hGvjaj9F3aZoOsEcEfuwThKj9WzDoZheziOPQ8sQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532114;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kxbmWpHG63bcj8caJCx8dB80g5mvO4e9eYY/N+k9SP8=;
	b=Q1OnqxH9aGa3pcWBfkvQtU/cKhbH+eIVbg9PO1pE7EhuAK5NWX+3G5A6nkJjTwQSfbiw
	 fbM61Yg3iB5wHgpNQ89zdTbVPluynYFRDQ3DaXh9WiZMGqIPkyOafIH5KRDs4JX2iCsiK
	 5+BGmhtO1vVtVtMSEqNP2jpygcBBnJc5u9/iE9//th8tsr6pRILRAbJt3K/8exKzFr45S
	 FJrEIDvgOz0aLBEvKkUhqM6iot3s+GWoBY37jOgx5eEbeL6SYrj6aFPXFX2IE6B7KzkEr
	 b6Uxv9/ScFCAU4TlmvizOvC4IcPKGNKxtwoz9HbB907jpZEtxmChKYoLWEdxyJe7aTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pOUaCAVr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.43
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB96606A31C
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 21:35:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CB96606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pOUaCAVr
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-745497ac8fcso95161137.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 14:35:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792532112; cv=none;
        d=google.com; s=arc-20260327;
        b=rjzFYR6/gXmA7+SKpyaJx64MxrJi/TVButaRcsNmdb9qIFKyiDtQasi+7btdPlAUc/
         qSaCG94VdYgE6bN+EJ6gkLA/IZrauh/l3+4oaLpA5J7DkDOnyT6qHWF297Lm8nPHSQIv
         sk6REN4ITHkmDU0cKqddKU6lOU6qpYLvoUX1cTD9y3y9bIvQ7rajifJ9EJkQ3WVB5Is1
         7xhlMHmLLgTDys1ovAD7rrEi1wYrTe0lM4z2Ekm4AVCPqAPQGClPDGL9/7BryiG6B56l
         IvFoYImVpGR9pDoMuc/ScMYSdACEprc0XRuzrkOtj7YSuE7nVJHhNs5VuzYBFg1FegeO
         Uzzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kxbmWpHG63bcj8caJCx8dB80g5mvO4e9eYY/N+k9SP8=;
        fh=QzLyUJT4DNtAXg/q1ElX4OdApnui2FI9nplRfAloQL8=;
        b=Ex2Z7DukfzN/DPcETmlsu9utPJqNhBDIOGh4YEd/1/EzYAj16LKnbF7zf8xcADjKEU
         gjXHh3UCXCFdarqtk0TuX341+OB3olaversknhKnD67qcoTbdKqLLqlOVN5oud1wfuLW
         RsiS+GckF/kEA9YtGfT6sshhwVIwc6ygBWVdKiI/wyHRC+5L1HEP/EqLG99PYKcwJ6DA
         j7mg7blkcz/Z9LxIv0UteMXlbtcpoie7O7L9zmQLEkxsQcoS6vvnDsLR8wftq25o9iwQ
         E87sTw1FIHXbR81tQFoBy84oBksZhjvz8xy8zXd2jZ/vlNY2Ju7PE5BhbVCugDKhGbDj
         l4Jw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792532112; x=1793136912; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kxbmWpHG63bcj8caJCx8dB80g5mvO4e9eYY/N+k9SP8=;
        b=pOUaCAVrjxYubrKNIq3KlVZ8P8wsutpG2JfiTOZSU2hCnHiDXJSVLwjH8kL9VQ4BeL
         /P3utoyemwNhyAEQefHUSZzbPprW5gbLPp5bBKV/tOE2gUD6UW4NEBx3d26IqfBuMPVq
         qSZ9NQukAA23m9+iyQ6v3FJhrHy1Om56+uSgfyCL7QRjXfjax8YVpiRKK9hKE/4uuSFB
         aocIg51LoZqc+dVUnMAKffzS753u7PCQDvZhOgtpfwB6zvAxtttThOmYaIeqRO7pNVDe
         wpAgAFtGyle7Vw9wGCdP2sruAtSnRapso3ZBiJYPYmzMqOF+Hfzv+/7WkxidRcmaE0T3
         Am4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792532112; x=1793136912;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kxbmWpHG63bcj8caJCx8dB80g5mvO4e9eYY/N+k9SP8=;
        b=rU/Snp/qVg6GpslaX+/0mBvD4PdsYpe/DrvFIsMXWQDQ/6GNOqDs+SeOKdHq1scTP3
         dV1Bb8s0kNHR6m4X1G3bCtxh+8kGtpA7PkJ5JnlJqVG0SbgixoxlFRxSUER7g5AUKoqW
         NgV9Gqvwv4ZQM6SQzBdYQrAOodHg5qb/p0U+PDYeJPAXsZ3nxF961l8MHjaKnk4kwUcc
         bfBswLfJi8Jx7gc8OWo+lXmll02KzruiyZWwMy0OWVkwLL6qB90peAtHeCgRKpOG151v
         GJwFSVj6nNAjYu3NQFIGROSi+TsDszhOsZKqGR0AHnr5T+kM6WI8WErF9u4th+qdjbRy
         LZeA==
X-Forwarded-Encrypted: i=1; AKwUvBxCIhw+zVnvt92fS3iEs4Ls8Db+t3EdYIdV7aaNRyo/N/q+/d069IXJcI4jT/GSCBdenWs29JKUvqq/@vger.kernel.org
X-Gm-Message-State: AFq9FYLsEgKmiu8ZVcoq+SO+/Qybpa1wWVtFXQdPj5MnO8aydxHhUhC5
	luOAJhu2QJ9sfiIiyz6ULuxs6vniAxnQN80YuwaidYDdTs2DCSs2d4ba/R0jkaVaijOD1bO2Q/U
	oOiDy/Y5lvQrHfQK41Ba9MAiVCPxGq1s=
X-Gm-Gg: AYBFou2p+czpFAISizmGDFRjubD8QzbgJ8TRLBHaEUni1Wyc9Y+VET6HOduZO8gpg9J
	Mwjtg+bVMQ9RIfU0XASDOk/KZgDQt/SWgejOQK4KEqYL3p8K4GF/UL9OJYqp1XP2M83G/shjMy2
	grLPUwEd12f/tSVHWY6HaVlMEwqefIMyCYE1tQ04bovj9Vq1zee9bndag9CMhUn5ToR4GAfPFzm
	d4cpf1r1WOeKCv+TGhO22nzzWopDjZH2iL4qlFTjSDqZmA6Rx2Bes+99EArKbMhGUKLOMAy7lKF
	2YTASVMrTxitCk34oZQko/AyS4+wLnjRXyivp+olKPZQ7WV5QrCTVpgs2HSCasxLCPzQFpGuRgt
	Z2FyRVjycYn5iU9ALZCk0fD7KedImdjjhdqtLGdkdxqXUdWLQvDSw3vkv9x1yEIxvWd4ClxXpu4
	mD/EYSuQjbgTz8
X-Received: by 2002:a05:6102:448f:b0:7cc:2cd0:e73c with SMTP id
 ada2fe7eead31-7cc926c4d1cmr146631137.25.1792532112476; Tue, 20 Oct 2026
 14:35:12 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <9e1c586f76943aa9fcd96cecedec805c66fc6e07.1792164438.git.lucien.xin@gmail.com>
 <179244540161.3135.791644548439735124@kernel.org>
In-Reply-To: <179244540161.3135.791644548439735124@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Oct 2026 17:34:59 -0400
X-Gm-Features: AclHuK-cqHur22QaAJB_O1MpvembykENtwhk63DMyFXPnpV5d6Oxh4y7OPcqRQU
Message-ID: <CADvbK_cWtvHg2Mbgwe1+2TZgGDwF9DY5NO8vjim5RLwufW3e5Q@mail.gmail.com>
Subject: Re: [PATCH net-next v17 09/15] quic: add congestion control
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

On Mon, Oct 19, 2026 at 5:30=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 2
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] When quic_cong_on_packet_lost() (net/quic/cong.c:94-99)
>   declares persistent congestion, it sets cong->window =3D=E2=80=A6
> - [Low] The commit message says the implementation "adjusts the
>   congestion window accordingly during packet transmission and=E2=80=A6
> - [Low] quic_cong_rtt_update() (net/quic/cong.c:207-209) throws away the
>   whole RTT sample when the raw send-to-ACK interval (cong->time - time)=
=E2=80=A6
>
> --
>
> quic: add congestion control
>
> This patch adds struct quic_cong and struct quic_cong_ops to the QUIC
> stack. They cover RTT measurement, loss and ECN handling, and pacing.
> New Reno is the only algorithm so far, and quic_init_sock() sets it up
> through quic_cong_init().
>
> > The implementation updates RTT estimates when packets are acknowledged,
> > reacts to loss and ECN signals, and adjusts the congestion window
> > accordingly during packet transmission and acknowledgment processing.
>
> [Severity: Low]
> Is this accurate for the transmit path? quic_cong_on_packet_sent() never
> touches cong->window:
>
>     if (cong->ops->on_packet_sent)
>         cong->ops->on_packet_sent(cong, time, bytes, number);
>     quic_cong_update_pacing_time(cong, bytes);
>
> The New Reno entry in quic_congs[] has no .on_packet_sent, so on transmit
> only cong->pacing_time changes.
>
> The commit message body also doesn't mention pacing. That covers the
> pacing_rate and pacing_time fields, the 2 * window / smoothed_rtt rate in
> quic_cong_pace_update(), and quic_cong_update_pacing_time(). Pacing only
> shows up in the version changelog notes.
>
> Could the commit message describe pacing, and drop the part about
> adjusting the window during transmission?
>
> > diff --git a/net/quic/cong.c b/net/quic/cong.c
> > new file mode 100644
> > index 0000000000000..765f50660f0e4
> > --- /dev/null
> > +++ b/net/quic/cong.c
> > @@ -0,0 +1,287 @@
>
> [ ... ]
>
> > +/* NEW RENO APIs */
> > +static void reno_recovery(struct quic_cong *cong)
> > +{
> > +     cong->recovery_time =3D cong->time;
> > +     cong->ssthresh =3D max(cong->window >> 1U, cong->min_window);
> > +     cong->window =3D cong->ssthresh;
> > +}
>
> [ ... ]
>
> > +/* COMMON APIs */
> > +void quic_cong_on_packet_lost(struct quic_cong *cong, u64 time, u32 by=
tes,
> > +                           s64 number)
> > +{
> > +     if (cong->pc_detected)
> > +             return;
> > +
> > +     if (cong->pc_start_time && time > cong->pc_start_time &&
> > +         quic_cong_check_persistent_congestion(cong, time)) {
> > +             cong->pc_detected =3D 1;
> > +             cong->min_rtt_valid =3D 0;
> > +             cong->window =3D cong->min_window;
> > +             return;
> > +     }
>
> [Severity: Medium]
> Should this branch also reset cong->recovery_time?
>
> The recovery state comes only from quic_cong_in_recovery():
>
>     return time <=3D cong->recovery_time;
>
> The only place that writes recovery_time is reno_recovery(), which sets
> it to cong->time (now).
>
> Take a single loss-detection pass after a link outage:
>
>   P1 lost (pc_start_time is 0, first_rtt_time is set, not in recovery)
>     quic_cong_on_packet_lost()
>       cong->pc_start_time =3D time of P1
>       quic_reno_on_packet_lost()
>         reno_recovery()
>           cong->recovery_time =3D cong->time;    /* now */
>
>   P2 lost, sent more than the persistent congestion duration after P1
>     quic_cong_on_packet_lost()
>       quic_cong_check_persistent_congestion() returns true
>       cong->window =3D cong->min_window;
>
> Every packet still in flight was sent before now, so the ACK for each of
> them returns early here:
>
>     quic_cong_on_packet_acked()
>         if (quic_cong_in_recovery(cong, time))
>             return;
>
> In that case ops->on_packet_acked() is never called. Would the window
> then stay at min_window for at least one more RTT, until a packet sent
> after recovery_time is acked?
>
> RFC 9002 Appendix B.8 sets congestion_recovery_start_time to 0 on
> persistent congestion, so these ACKs grow the window in slow start. The
> state diagram in cong.h shows the same transition:
>
>  *             persistent congestion |   Slow     |
>  *         (O)---------------------->|   Start    |
>
> Here, though, the derived state ends up as Recovery Period, not Slow
> Start.
>
> Nothing in this patch calls the quic_cong_on_packet_* hooks yet. This
> would show up once the outqueue changes start calling them.
>
True.

Good catch.
I will reset congestion_recovery_start_time to 0 on  persistent congestion.

Thanks.
> [ ... ]
>
> > +/* rfc9002#section-5: Estimating the Round-Trip Time */
> > +void quic_cong_rtt_update(struct quic_cong *cong, u64 time, u32 ack_de=
lay)
> > +{
> > +     u32 adjusted_rtt, rttvar_sample;
> > +
> > +     /* Ignore RTT sample if ACK delay is suspiciously large. */
> > +     if (ack_delay > cong->max_ack_delay * 2 ||
> > +         cong->time - time > QUIC_RTT_MAX)
> > +             return;
>
> [Severity: Low]
> Is the 6 second QUIC_RTT_MAX cutoff too tight here?
>
> cong->time - time is the raw interval from send to ACK, so it includes
> the peer's ACK delay. RFC 9000 allows max_ack_delay up to 2^14 ms, which
> matches common.h:
>
>     #define QUIC_MAX_ACK_DELAY  (16384 * 1000)
>
> For example, take a peer max_ack_delay of 8s, an ack_delay of 7s and a
> measured interval of 7.1s. The sample passes the ack_delay check but is
> still thrown away. The same happens on any path whose RTT stays above
> 6s.
>
> The early return comes before anything is updated. smoothed_rtt and
> rttvar stay at their initial 333ms and 166ms, and those feed into pto,
> loss_delay and the pacing rate.
>
> first_rtt_time also stays 0, so this condition in
> quic_cong_on_packet_lost() is never true:
>
>     if (!cong->pc_start_time && cong->first_rtt_time &&
>         time > cong->first_rtt_time)
>         cong->pc_start_time =3D time;
>
> As a result, persistent congestion tracking never starts.
>
> The v14 changelog says the cap prevents latest_rtt overflow. latest_rtt
> is a u32 in microseconds, though, so it doesn't overflow until about
> 4295 seconds.
>
> Could the limit be raised, or could ack_delay be subtracted before the
> check? Nothing in this patch calls quic_cong_rtt_update() yet, so this
> only matters once later patches call it.
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1792164438.git.lucien.xin%40gmail.com
