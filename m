Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795796335;
	b=w9way9UzbikUBgRvScX1GH08Em9P3llPke0aUD1WLQoZgeRaLdgP68AqjO/ZUFB30AWD
	 2X6thlkImRQX0yDwsIT8LAwNS/rmmvx3gCcgzLH5wPtm0nlTlE7AuTJS9MARlc3Aw+jgT
	 yBz1fu6WlI7MLhKmfOK1WFYdGY290U80ARCo2vPPMojnryUOh65104JHnhW0t4xYMy+zB
	 emQ5W4EFF98SY7yrlPQi23v2E+ZMgB2v5QFngNvYACwMwp3RpY68ba+lns5N/vBt4N6do
	 z/dB8ACaUA/U7uUr+qSo/EB6G59gMv1brzk4e708s+8R1TL2MZQs7RqkaV0ffuzx7YQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795796335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
	b=YgMFbdTCqiWsUvzscmXG+RU0vklnjeUZtQDys2eOiNFLse3dDKDCcIRq5UPohsuRiICb
	 8tJ5le+WZGiRSObUXyXVl3DctmDWurLKLW5vPi/D5tyUc/DfmyHMCQfGF+ckt1LtA4g5Q
	 6mz1GVzk5T9dHqRPYX0RVN3oBCBNsr72vCqpw44079UJNC6uqIy0FLCgvgAR39OeV8T8q
	 elvZ3JVMWEoTErb/x1S9iVuizK4kFWnq48Zt2WT0ZLOheuUsb1PQKq2BPEG735wCMbgnj
	 kaJQa3937eOFvIwMO6o3s0Uq851HfiYFB+ohz6zEERKcWz1SxK/dWA9527JooKvqdPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="naloy12/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08941606A324
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 16:18:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08941606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=naloy12/
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b8a52db5f9so10101804a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 08:18:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795796333; cv=none;
        d=google.com; s=arc-20260327;
        b=hDDtPcqpQBU7gxMelTDxbSPCdvelAz6FktFmnkYsmo2hqFgqPA5L6ZwfbYlqgLiQaa
         kzzIgK1x6+ujCFUPYOvB+vWHj+u6AvcisiT6/V9kZnT2OJ8nIjHeKv+FuCgAXgPhIFzS
         +pvBbpVxENxNcE1ThVtn3Q0mvlLfqte10FoxEVh+frM+8JkAurrUx4kC6W6QSiM2isbe
         RNm2+GwZdtevNIHpX2+GqILbt9FH7uKAQ76MbVNAzqpyT2ekKpSgQ9WX4DMqynxBdBy8
         hVJR0S081AEkvGZSnTD4P9Deh79GjkKLJX5RWKPvhiNlhbU6+gqwP2pynCHNazm7Q041
         Bt5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        fh=Z69LtB3z179akMT+EoAIvFDdtEKNsncf/J8hbWuhu7w=;
        b=TvOwpprH1PHoxrUzmDaeo8vslTv129+qD3MZRVmO+5HtVQ4hcT/9RKGV8EqD0joG7P
         EAGMT4+Lolrk5UQvRVLj6IRCWHBrTL1H8yQB/8OoEsZvkOVLBBd/OkjXj2Lbgal7Sf7o
         1elkAqAHK9Gsfk1mY7N0UP9AcZmNIGjXoh4oVlCk8O4jjfZhA5GLrUsJ7I7CGwSpEL4S
         dEnpMdSotTw+gw1We4eMNQf2NTJlJ1miqtIHjQpoQEWbdbuCkO9b145ss+L1iGoLdlHh
         mDZ/y7UXUS24Iu44jnCpA9RphzlY2+vKHavoQHbUez2SPDMxPWEFvoRQ098cJlYy/T/9
         HBsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795796333; x=1796401133; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        b=naloy12//Z/JEicfOBVG7/emu8n6hsVyuTwhG/APX5YJILPJ+Ejhpn8jBE4NDP7/lK
         g0UksYAE6Bdao6mTsS9kfqJqJTBy4iSLcQUfz2p6ydY9idCCIBNNnumqk9ahTewMQrhJ
         T08f33nweDrOyw3pKSkr1Qkrkked0vr7ZHwRDHta+TN6WG0oGzqsuhDrEOx72fBh5WU0
         oYgUXVXd1tU/mzTeQ0mzsTJviZuAX74N/jPwzeSjBiwxnyK0h0TealYMchARBmDUZIOX
         ViMp+AC7Q+jtL9fE4jDvp/Jor7sArB0DX5YSBPvQ3+fL8nmRlQu5cAOGwV0tlnPOhQ6L
         rUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795796333; x=1796401133;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WcqK/TokdPrpJ1SyssRoGlfCD57QN3XIIcFf/99tphc=;
        b=gsvD+cNop39g52Xb5fl9qyin0jFILc3Gf8yrlhSze5yf+29ZLP0i1RuWA6xf1X6jaf
         F9jryvgNWyyKY1kjX58WxIZlNdsq5Pd4H1jFTrUu6lumFA+JEeH7Vxa4h7/sszKIihct
         Yk3tMUFdMxZelbD3R2Av6MrH6ZtYPntkRkcu9518HR1fYWdwtroeEcJ1zTcGy2es1q1o
         oAKPteN82W/+CFh4GjfBwP2/sV0xt+72YmXPgP1Uza2biKuTgheSGi1wHqDAYnxVJZCm
         9yGKV3RE5YfUJnFCMysTmICI6LCqjs1bUtrTTzITmUN+P0utn9dbDaCi/P4985HmP1pG
         xG8Q==
X-Forwarded-Encrypted: i=1; AL+hErEProRPmMgC5SDXZog1WKrKin+oiPD34bUgCY29QH7xwwmZLx3N3f17SZoIy4biDAscm5ZgrJeaE4e4@vger.kernel.org
X-Gm-Message-State: APuU4Z9NwVfuU34KbMXw0F/alcsIgfLc52tFaL6tu5AlsTIRjvBq7B/K
	BZ83Jvrtw6HCHpzijvJcIQ7QfbaJBoPhjC5T1x1HvTM+MageMaVHPmuq9kPRSxTkjlVoT54ucjl
	MFcDgmqAljwSTJM0VCg8R1+6pSboXNDk=
X-Gm-Gg: AZFdTZebVRcSAQZX3u6Md3nHDzZKGj7MpUwV7jcjgVPeOqDY7cxT/tiEhZfJ4Yyiwb1
	DkZH3bVV8PRf3XD4M20n4EOt88Acv3yJ5BY7AkNrBIlc1mwbe2FKjgB6zDeRjm3FX9wLA+m3RO5
	AYB8iETWXlfLA6cBLhYoOhnxsv48NRqjO6qkFJMaJpQ2F0ZHvrFUcbCgJDE6x6zbUXUFmHHMAhg
	S46wuMfo/oHotOKC1vjqLqZl6OrtWkWz9LOduCdDPXE1rrO3Oo54zifDODp8qAawmDRiKw2P8lg
	+CyVw09Ph0YuvENt/lFvkLvbB5aTmQWfZ9Oi6KgDnHVM7NCRa/TrnowC1jUai8MbzObRRub5IeP
	0v1ZWv1dDUqRQZbzcy3lZJoUw7UNjP0C4+/MaSsoCDVQhYbKZ+y0J0IwV9us6WHRv7d690w==
X-Received: by 2002:a05:6402:e05:b0:6af:80c4:8981 with SMTP id
 4fb4d7f45d1cf-6ba37e890fcmr19985269a12.26.1795796332918; Fri, 27 Nov 2026
 08:18:52 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com> <20261119153222.65195-1-lauri.gates@gmail.com>
 <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
In-Reply-To: <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 17:18:39 +0100
X-Gm-Features: Aa3M54qCjcbbYjv0mzgNqjSQ7Sw_WVEr_GJN4PX5Bm9lrA0JqzVoRsl7zVlER60
Message-ID: <CAOQ4uxhE38TnXseMOyWY1OvidBWew2hAYAV+rYeTPaqRYZb45g@mail.gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
To: Christian Brauner <brauner@kernel.org>
Cc: Lauri Gates <lauri.gates@gmail.com>, koraynilay <koray.fra@gmail.com>, 
	Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 1:44=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Nov 19, 2026 at 05:32:22PM +0200, Lauri Gates wrote:
> > One constraint for that case: the flag has to stay out of
> > FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
> > FS_XFLAGS_MASK is reported as supported on every filesystem, so a
> > plain flag there would read as "supported, not shared" on btrfs.
>
> Right.
>
> > Christian, with this mask on the way, would you take a plain flag
> > (say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
> > that filesystems advertise through fsx_xflags_mask? If so, I'll build
> > the RFC on top of koraynilay's series instead of using the inverted
> > FS_XFLAG_NOSHARED.
>
> Yes, a plain flag is fine. It's simply the stx_attributes_mask model.
> Filesystems that have support raise the flag in the mask and everyone
> else just doesn't. I see that Amir's busy discussing some details in v2
> so maybe base the RFC on that series, I guess.

FWIW, I think the v2 posted API is a solid candidate wrt the UAPI -
The AT_FILEATTR_ opt-in and the struct extension leave very little
open questions - the remaining discussion over v2 and obviously needed v3
is around implementation and the fine details of the contract, but for a si=
mple
readonly flag like FS_XFLAG_MAYSHARE, it is very clear how it behaves.

Thanks,
Amir.
