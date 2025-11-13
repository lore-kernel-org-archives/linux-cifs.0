Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6D93246F7
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763069220; cv=none; b=AvfzNFIZRfXoikO3fSjBPduKcWIu/ZG5318QG1YGPOFvxbZ387gIcoIkUgOvQ7CjCVAG+yaQTKJPyngNQPPVXa7IRc9X2gZ3KvYSwmwVYtFT/DwBpLDWYLw51PhsGCmlPI1tpJLDZKI/Jh5CREkI+7jh4PWl5VrwF9+mtFp+rdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763069220; c=relaxed/simple;
	bh=C563LsVa6/8e3VjqblDi8r6nB8mnn0chwKQh+7Cmjsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c/mwUKy3azcAiLxP4RRB8tL26FmpB9zWvrn69shJAKvkjtCDo+8T0gtS5dzb46VutfJgeDtkPT0HU1IrX6SzXY/XWikHjJsLujGOStB+QSaVWcv+UuueHjSmCYEecVvCAIXWCc+PXFCRYPjlBiy6X1xjuFaK4kpquxPqFp1lmXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFuWuqUX; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFuWuqUX"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29558061c68so16572355ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 13:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763069218; x=1763674018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MvLS0Li6ncU43W6RO/80uOScztDNeTiGNxSyThA+RiM=;
        b=BFuWuqUXt3377e/PkAs84KRQt8wYLbBYhCBhJf2SaQPrBazoxI3tm19dvrV7u+KAGO
         a+wh+fwqmq8g8qV691u54La0nXEm5lOI6t2t2ptj3uOxqVVYw0IXfIaFXhHDI7TgRwN+
         ce184KVIc48vFoasurHvh67gf2jF/XdcqevhDGYnfDumOMMYM7QWfLPPE6U62pLFqoTf
         uXork8mLQ8U06Tskh1qtfetBXSoSyue0w44FNd8ocPXWPRUTLENvjyAJilOrnjU/++4l
         mQqbNtaRluNkcIERJ2xi7yG6LYRgkZAdtWSZUuOMQLpKCjId1bVwnHrXOWlqPREhEt46
         VEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763069218; x=1763674018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MvLS0Li6ncU43W6RO/80uOScztDNeTiGNxSyThA+RiM=;
        b=GogU7VqhhHCKtVgSgF2HzEHQvPKMPkyciWHIikIiAk8kctEk7oi36VfD9dB51ysMhJ
         oJhPccLrMN0FOna07jkTM4bqXkOoEDTeOnVL8gchzeKXMn9YB+ROGI/WX2iKAfCZWiog
         4KyiEzsFIndaqLdPTRE5EUnlCK7ahegRpGDzTGTm2EE9tBI03aLCog3s7mYY7a6MGcOd
         +Es6QyxAJLL1edw1ciKW9aar000uht0qWbBI+6MRPUVn1jo1bTbRLv6e4PDWNVcYnLaA
         bUhgtgIfwTUFF5Tf7JyEa0n1nDi8rJm69M066M1HZEc4z15r4prSC0CKvNMoE2EC0q+i
         PePg==
X-Forwarded-Encrypted: i=1; AJvYcCV2V2kaKWLuoZaVFrjDOexSFf+PEgUyoQbVhSCd+nyKb/8tr6ToqBJKdItQhci393M3oCA/esDw4mdW@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv/6HL8hK8phGCXPLzxhw5TrjqtwXL5XeUMVOaWb9XKeEklhLe
	Yejb4CXjBHWfp2Pqe8bfOUyRj5Vd7UA230MJwbOd/tESL1heD1A7Urlf7sevWPORE2mzUTJLqYk
	WBldFij9mIpEPUcBjGg4R7ltKvPKRfko=
X-Gm-Gg: ASbGncsgNHV6FjbIyPoffoA+aQYK8z9akOMIe/DKeo1sKH/EQXCfnJ4Yh3aYjQ0BRwQ
	mgwZcFC9f5IuNe+bD5kuenjH1p+Aw5DG8K11SJPeS2egWqruAwEYUG3v8RuBCfJUtUbdNO7Abxr
	MI/Hms0jb4jQdZOjd2UXz/FbRsor6FKqYaqI1InkImAdb0Mx3lKMKLYQgDfUkI4qzgTgFhlAMTs
	5YIhNXBeOz7lDcFUuGqhfhFZ/ofNPdYDKS9uwFYITOoGvUDm+5dl+ctz1wY
X-Google-Smtp-Source: AGHT+IEKm9CXDc+kQUPCeykRAkQ1s2Mjxo36u4sHWF3ypb14wEXU8u3tNG0XYM1pygnHZYipY1MFv/VWv8KCRbHyAwY=
X-Received: by 2002:a17:902:f550:b0:297:cf96:45bd with SMTP id
 d9443c01a7336-2986a6bf949mr4415475ad.19.1763069218001; Thu, 13 Nov 2025
 13:26:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <56e8d1efe9c7d5db33b0c425bc4c1276a251923d.1761748557.git.lucien.xin@gmail.com>
 <989d3df8-52cf-41db-bb4c-44950a34ce89@redhat.com> <CADvbK_eGPuueR7XL80eagkrAeJraKBMiTVrhiFb_wnTD+N7qVw@mail.gmail.com>
In-Reply-To: <CADvbK_eGPuueR7XL80eagkrAeJraKBMiTVrhiFb_wnTD+N7qVw@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 13 Nov 2025 16:26:46 -0500
X-Gm-Features: AWmQ_bkpD1XOS0u_fsUfGq1AJ3_cHnv3PQH7YYYwXkikJNe2ApTEEtQau8hdGQk
Message-ID: <CADvbK_eEHLbMQ3+OTWdg6_4a_bKFOkO-ZL0y661Vovo9uEFB1g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 14/15] quic: add frame encoder and decoder base
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
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

On Thu, Nov 6, 2025 at 12:22=E2=80=AFPM Xin Long <lucien.xin@gmail.com> wro=
te:
>
> On Tue, Nov 4, 2025 at 7:47=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wr=
ote:
> >
> > On 10/29/25 3:35 PM, Xin Long wrote:
> > > +static void quic_frame_free(struct quic_frame *frame)
> > > +{
> > > +     struct quic_frame_frag *frag, *next;
> > > +
> > > +     if (!frame->type && frame->skb) { /* RX path frame with skb. */
> >
> > Are RX path frame with !skb expected/possible? such frames will be
> > 'misinterpreted' as TX ones, specifically will do `kfree(frame->data)`
> > which in turn could be a bad thing.
> >
> Yes, when generating and delivering an event to userspace, it
> keeps the frame content into frame->data, instead of frame->skb.
>
> There's no need check !frame->type for RX path,  and I will change it to:
>
>         if (frame->skb) { /* For stream/crypto/dgram frames on RX. */
>                 kfree_skb(frame->skb);
>                 goto out;
>         }
>
> if skb is set, it will go kfree_skb(frame->skb), instead of kfree(frame->=
data).
> Because if frame->skb is set, it only needs to do kfree_skb(frame->skb).
>
Just realized that frame->skb shares a union with frame->flist, which is
used only on TX. So instead of removing the check !frame->type, I will
put a comment here:

        /* Handle RX stream/crypto/dgram frames. Use !frame->type to detect=
 RX,
         * since frame->skb shares a union with frame->flist, used only on =
TX.
         */
        if (!frame->type && frame->skb) {

Thanks.
