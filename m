Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784CB33438F
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 01:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791510286; cv=pass; b=CUJ3qnlP+KSO6mJ1bQG4oo2qsDT6UaebYJ0aKhCIxnApsuqn/v3R2/KX5alAAJpfqOh9o6Zq9x3Pyt+hPa1CDyxBrUbo9NkuSS3qztAn1yM3CW9Nas3BZBsQ0RmKaie3q83SnJXMsRxD/A2G+5aNhMnnBpAP8BxhpoCDlmH4MPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791510286; c=relaxed/simple;
	bh=ifO55Y1woCrSdawvKXwuZCI6hB5bLQyKtt689Hg6oug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mV8F2wQMV+51DNdF7/7wQyhidRWdMYnBXtJniIcEHhEkrFe5omSOQew+XaGNVLBDnMemuthTz02K802RvY5A0e7Fpf5Jb7IA2hxg3youwbkYX1Gk0ACb59UZ6e9tamTKgStBjZD24/LYYSk/pF1NI8Eo0zzzgbhEbLZaubriHzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qJzw9EPn; arc=pass smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qJzw9EPn"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8819033dbadso2517590b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 18:44:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791510284; cv=none;
        d=google.com; s=arc-20260327;
        b=qi14abiQ4/jgbx0UTVVBr6DY099hVIlyRk5JGRRUJYgRIvM95dppmjMs5YBzjad+RX
         hhU2cPjcuZRh/qdP0vzLlkl/cLTuzq9FFM3GpCxJVP4ofOBX3thqamy1PA0prFuC7RA8
         MGDsmVlNjVstukBGC76ALPejp7mKngrfEtCke786wPFseOb743zbzSzMFWwq2685qBL2
         HlAzAuVLpvLE+j5O9WBvsFNoGMlItmiPxPkgxggKHOB1jMiiW2Atb8UqApf2rcjGGw78
         zjqdvLbKEI2R4uc9nGFSY/a9qNBIQUER7TJAPMP0QY7k3M/gfgGzwMcDPw8Pto61xUC6
         iBiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZlGj4iJYIsBwKh9YN7bwtWSK6UPi/wdJW0+jMmmEn7w=;
        fh=8w+qZ3bMjz4v3uoYx+2u9wwsqg8lNthYy6/k3+owoMo=;
        b=T7owF5x4nKmUK1zzaYec0Hur48d9c5QYlyFfhtQ+RWDKCe9gkNwcOrmj/ZXcH+zZa4
         zyeNE6S5MngxmfjUi+NO9Y5TVqB5QUv6UnP4Owi43DcoFhR18yluLxV5LLTJVfoDbrDM
         Veg3WBdOgZX6uX//FyofknkhjietfORV4aTaPH1gP9Rc3bNc+sH+a6CYpQcW6kmwmkbg
         +HBRqElc4Hw0JoOMK288Bwuyg4itL9ipaImAiOgVRrFjUyH9NoZGZooqokuGQDXXVg51
         rLeeT4d0Fqi3IRjM+7vfkojCzCQXVT0WPenlPNJQjyZx4GTmgnFnpFW3DEZSTlCW2vpD
         cmFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791510284; x=1792115084; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZlGj4iJYIsBwKh9YN7bwtWSK6UPi/wdJW0+jMmmEn7w=;
        b=qJzw9EPnqzvAGmJRfDLqu4FyALA2+uXThNcTh2ZJaY7OYICxCixLCERYEF4yReYTCT
         jYQABdS9XEnqbpDPT5a3K/MfC+lBerGl72/VGllVkZ+eLcTQMmZgtrvKhSTXjg8jj0nA
         IRUg68Fw8YIwI97gAxpKH1NZUfeAIhEpp729tmUevtHPJXoCS6uxS/yOwMXJam/b9YVL
         vZ1eIEs0zSUapJP8if+6lttuMCyA5+4nZ/aZ9wSYoLJkO9IZScw/M1NUqOwFtJvICrBe
         3BQ5fHf88Y4B9UXD7g3Sm9WhVvIZ78as3HiiItd37h82jAE/sI4oVSvgveb4OjqZRd7X
         fWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791510284; x=1792115084;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZlGj4iJYIsBwKh9YN7bwtWSK6UPi/wdJW0+jMmmEn7w=;
        b=PuEBqwo1yvh8/p4RnP2qd/gALJviujOtYt0g+YdP7yqAV8c7ujHNVMvcXTYFd3pMdY
         MaSqDfRs3HaFxqMxCGvMaDsKH/2WvWLhtSKZeeOvaXZK+SEWmwOHHdpbqYjUh7fHNVsb
         IdlktEJwGs+/fosNHO8w3SpFrGGzK//UjXMFOYlnoMTCG/HwP2DH4lp2sYjFUKPDTIZb
         uFyxcYTg32LB+dxlyRtK770/0HCeyCd6Hy2wSUH0cOSYIX+yuwmSvvTmN/UI9+QLoBLu
         uyV/y+7bXoPi66kK/uVR7WFJv5mWdQ3QrV8PjLWv83fWKbT+2+CM/VdtEmaAcRDV4oQw
         3cIQ==
X-Forwarded-Encrypted: i=1; AKwUvBzQb0CeXWtAgThvZNCntjrYjtxWJ62bjRLzakegak5Vc4ICY+q1Nkm9JTCKA43hIXtL1QlyUNWw5TeX@vger.kernel.org
X-Gm-Message-State: AFq9FYIIgHugVbRCuKei+MriwELp/IGWt0cakvvrkgMmorRN4ubbDxnd
	z4tHEI6LngPhbOx7flLGen5+twQcyJkYMEJVH8lCMF9f+JXHFrzASKD4+39eeFTRMArGRsj6K0Y
	+8f5alzsCG3iJ3WwhEaZd1JREK/GXIhU=
X-Gm-Gg: AYBFou33xBZnYA4MvBRe7KSHVqGcYP7VNsp3vd/11wZzk2XeX4jjga3XqK0IHv8JARb
	Rl8NOW/ydth+yrte1IzRIzB7fKVJmgLyvzsBlIxqQ9dYbFKmdp1U6UmNQLkJueVSJ4mzt7Eg6q3
	/6TD4BqGL7uCjeFPPY+7WsFrI9S+2ILeaO7MdlV+L/UyJj/7TKovSU3hIXDHCd+AW5D7ZYgRNWq
	3zSFFYJGSTSyM/pb502W0FOEk+ydgXRD/qSSM4q+C2PiOcq4JKRFvUvNvguiYzaSVOq+A9D2AcV
	DT9TePon2bUqicN/LqZFbSeHwouD5tRURcjp1uvbXmy6auSQhk/GGJ+4DT48934X3YtbUHOP8Xa
	eAk2L1XUnWefRVnu00Hmh942SSJwCZNeXqfNidG/4ZK/lgYH/TbXRhKnIbG8dMpK/
X-Received: by 2002:a05:6a00:f8a:b0:880:740c:927c with SMTP id
 d2e1a72fcca58-897c41e8cf0mr271786b3a.8.1791510283786; Thu, 08 Oct 2026
 18:44:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e7412c320cae4da8e01f4f4809f92e570a999593.1791227050.git.lucien.xin@gmail.com>
 <179133512119.434549.18318076229328796602@kernel.org>
In-Reply-To: <179133512119.434549.18318076229328796602@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 8 Oct 2026 21:44:30 -0400
X-Gm-Features: AclHuK-lPgRdTjidUztJ96WcL1mJloJjp4wGF3s35F5afM1dBKT-4-2J0gwHe18
Message-ID: <CADvbK_dAWQs-duCEhK8wuZ9CHto1Ykmpyh9X_8rR1kS503EaDg@mail.gmail.com>
Subject: Re: [PATCH net-next v16 11/15] quic: add crypto key derivation and installation
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
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] quic_crypto_keys_derive_and_install() (net/quic/crypto.c) sets
>   `crypto->rx_fails[phase] =3D 0` every time it installs RX keys.
> - [Low] Two comments in net/quic/crypto.c do not match the code.
>
> --
>
> quic: add crypto key derivation and installation
>
> This patch adds the quic_crypto component. It derives and installs QUIC
> packet protection keys for the Initial, Handshake, 0-RTT and 1-RTT
> levels. Its helpers cover initial key installation, transform allocation,
> traffic secret installation, key updates, and secret derivation for
> stateless reset tokens and session resumption, and a new
> quic_sock_destruct() frees the crypto state.
>
> > diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> > new file mode 100644
> > index 0000000000000..4bb6acea5112a
> > --- /dev/null
> > +++ b/net/quic/crypto.c
> > @@ -0,0 +1,587 @@
>
> [ ... ]
>
> > +/* Derive and install reception (RX) or transmission (TX) packet prote=
ction
> > + * keys for the current key phase.  This installs AEAD protection key,=
 IV, and
> > + * optionally header protection key.
> > + */
>
> [Severity: Low]
> This isn't a bug, but this comment says the keys are installed "for the
> current key phase". The function takes an explicit phase argument, and
> quic_crypto_key_update() calls it with !phase, which is the next phase.
>
> That is also the case where header protection key derivation is skipped:
>
>         if (crypto->key_phase =3D=3D phase)
>                 hp =3D quic_data(&hp_k, hp_key, keylen);
>
> There is a similar mismatch in quic_crypto_set_cipher(). The comments say=
:
>
>         /* Allocate AEAD and HP transform for each RX key phase. */
>         ...
>         /* Allocate AEAD and HP transform for each TX key phase. */
>
> But only one HP skcipher is allocated per direction (rx_hp_tfm and
> tx_hp_tfm), and both phases share it. Only the AEAD tfms are per phase.
>
> Could these comments be updated to match the code?
>
> > +static int quic_crypto_keys_derive_and_install(struct quic_crypto *cry=
pto,
> > +                                            bool rx, u8 phase)
> > +{
>
> [ ... ]
>
> > +     if (rx) {
> > +             crypto->rx_fails[phase] =3D 0;
>
> [Severity: Medium]
> Can resetting rx_fails[phase] here let the connection go past the AEAD
> integrity limit?
>
> RFC 9001 section 6.6 says endpoints must count packets that fail
> authentication across all keys used in the connection. Once that total
> goes over the integrity limit, the endpoint has to close the connection
> with AEAD_LIMIT_REACHED.
>
> Here the counter is split by key phase, and every RX key installation
> zeroes it, including each key update:
>
> quic_crypto_key_update()
>     quic_crypto_keys_derive_and_install(crypto, true, !phase)
>         crypto->rx_fails[phase] =3D 0;
>
> crypto.h also describes rxlimit as "Max failures decrypted per key".
>
> Later in the series, "quic: add crypto packet encryption and decryption"
> checks the limit in quic_crypto_decrypt() like this:
>
>         if (++crypto->rx_fails[cb->key_phase] >=3D crypto->cipher->rxlimi=
t)
>                 err =3D -EKEYEXPIRED;
>
> The later patches do not change how the counter works.
>
> An off-path attacker who knows the connection ID could send forged
> short-header packets until one phase counter is just below rxlimit. The
> next legitimate key update would then reset that counter to zero.
>
> With AES-CCM the limit is 2^21.5. A busy connection also has to update
> its keys about every 2^21.5 sent packets, so the attacker's total
> forgery budget grows with each key update. Splitting the count by phase
> also allows about twice rxlimit per key epoch.
>
> Should rx_fails be one connection-wide counter that key installation does
> not reset?
>
True.

Will make rx_fails per connection instead of per key.

Thanks.

> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1791227050.git.lucien.xin%40gmail.com
