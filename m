Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9697B325735
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 19:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770320279; cv=pass; b=aZFhGnzhGKmkbSM4k7UF5+r3GyFUpZLi7W0Sjp3oLz3hD32cIxtLEPoaPp7G3PmXOmQHPFCfLJp240pfaKsm8x0/RHfGRmmL8XHjtM8FIKSjFTRkfNEb2YqwLP+Yvc8qLj5sXAn32+OSGEq59qD+53CwNJ1bEhrIk3aZMOOi43s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770320279; c=relaxed/simple;
	bh=sKPzMs6ZiMMSTfcnvFTaywQRGHtQmYcHtLPKvcXf5PU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SwVPuckJiJ4xLI2zmQIWzO9+8HfM3ch95jv3D7vyAbf4TMp79NdAOCGQEONsUiCpxVdRTSSQTWGTWNA+ZBOJq/xAIKqLrIYIzQAos5IevBFI+GGYLR33v+NJTOXZbjPhbd8/RlL52jeg5bSOsQlj8sjQFsuGMWOivNiBAM7EREY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ngjppiUe; arc=pass smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngjppiUe"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a102494058so11841915ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 05 Feb 2026 11:37:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770320279; cv=none;
        d=google.com; s=arc-20240605;
        b=PyLqHxutHPbIsCFYKuV/wrsTlHb+LNsA4GOO0o7v1QtjefkoeY2CFDokXMn8N13k8A
         nNaMs/PKT/ofYsrsPZMewjJ39yCylgKWRpD93+V8rBZSzhykEK8FDCUWmTAunyvv880p
         E2S/nebx9GxYE8z8oXkPYGc2GJYY3I7hx7eTaOkSZCNjq41T0hQ7dUQdL7odNADKnVw7
         TUUdZzKXOs72Vjhpbm8IWNx9paHlbqM/Ef+REKVYKKiEgm7jk2KQoE2n5xAaEbQD3hJS
         m1mbdLJszLmRRsY5ggnaykZ2ijLzKfcgCCV44yhNT6OWV6vZZGR5RmtCi14YRuO8BZXB
         2n8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dfrsfyhAmd8GwoduMxGfN4+1FY51xPnUMNNk+QbL/6k=;
        fh=RYKWuLgxZLrRXKjihYDUGAVP/XqQ2kNx3XJW4nrPxyI=;
        b=crWzIB+V0LgCd6OeM8LkFcl3rCw0i/e0dM2YShXXRY2xj1aocN3hEtrHkJr+m/iuuj
         f8thTgsh6hV1IbVUNLM99W74phZlARB2j4kuMdYqNHB7wSsRo3BRZC9qNxckQuhI4Fl5
         DxeIWLEOgS1Y46RyP5mOAgGr5wAV3+rINfeXzEFJ0bALSRJp6qb4vlCmFRQSOdSlE+2I
         DgSbOT0C6N6m3La4uD+N0rvcUr7KwKwA61KJuMopCIkIkCNNGJf1Gl+Ttvr7v202GRhe
         9JaeKCspdzlr6LkzbYtLpZ/QU5Y9EvHeNPEbkfS2SYx361gO5TDI8Z38fvBcmyQbCG94
         tLWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770320279; x=1770925079; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfrsfyhAmd8GwoduMxGfN4+1FY51xPnUMNNk+QbL/6k=;
        b=ngjppiUetb7dvnAURd4dglInQP2ezE7u4purLgANHge+xgPNHEpfakEPQd6isWduED
         1iTvzoudHvqiOipqvHbjkNgelPvVbuBdaknwdcYMuHhw8LoXa6DdSx8V0eeLv+Ag6XN/
         ujcC8alodbswtPqRDyhNNAgjU+Q3XE2koGmiztXUUnlgnyPSwpt9LXUIep0P5wP2EVex
         PTG/SLn+Ov1+559ww0n6UfLjgahoySTY7gNbhyn3mRqmhcVS4Cn7c1u5JBEBhBZMLYhv
         4uceXj6ksYCRnyceWack/n2CSoutSpGX5onx11Eryr9aj0wIhFBoX9ZFpKIHFLVva1w1
         k7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770320279; x=1770925079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dfrsfyhAmd8GwoduMxGfN4+1FY51xPnUMNNk+QbL/6k=;
        b=sUUdxI5VDzMIjRYbDNeSrKyIDN2TVcOpGUQNmgITdvQR5SZV4sLAVCWhUgN5Egythr
         KnCpCjzn0sz2wiGSClUCeATdCg9ynM9Fy7RZf+GunNxxzvr+oH9y3pCNo0ktO+VbI8lz
         9dqTySNJfyCtV+kILW5mkvFfMsC6DSG1zmKK/jDnaP8q1wbA6Wn4XkVggA/7QjCuBA8t
         NEeKe5Xm4j1SKCZHsJzSQp+g9DmNTnBJzO4+X+u0rlbTbZ+b8eLEP79Gy/3UUutYWIK/
         UPGmwTl0Iev8dKa+Uley5JxplJgFosBfQXrLT9B9kBs9dtFAuy0y5RyMkxUJQZEz2wNO
         PTeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhsK/iVS64Bf5oSJo+rw4AUxzLvZzRGAvQrEGHpCLNwBw0VFFUBiiSeot+i2HLR/f0Z7MgdIa+ir9S@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0z0iRxfRtD93S0VVwNnFwb3sJxCyTVwzVVwIBRqKmo2WBNro/
	rTV5BUEN7m5kaPB95N/A9QxLMIfwLJH3Y/xXvoHep2LJNFAbtQtjlkhYjCc1bvCuQu8TeNh4w8H
	u+wVA7NQiUR6+/lDeTWl1ET731jE3D88=
X-Gm-Gg: AZuq6aI0F6l0J2Th0090MDJbxR+Flkr5t1Mh+wO7b99BWlfw57bptYbCPxanJh6YpwR
	yUqXDXGyRnduxbooGQDJb5RQUMZ15FolFCib6AELFfFMj3w+/wUmUDH94zMdGDmObw1jj2MkukX
	GtdIzhcc++c5THT2L1sieSjqObSsSxXEA51DxMPxWGbEjA7hmijiS4JZPFmp/q2FZ66dOzNTyk0
	zhnSfWzoMB1n8iwAaKuGd7EPNveHBgCae2Ph2PRPZ6AaluD9qx7vSx6zBrQtKGaKo2ekkl7uhm4
	Nwnt/C3ENBSsj+WtjUmjV6zM15Pi
X-Received: by 2002:a17:903:3d0c:b0:2a0:b432:4a6 with SMTP id
 d9443c01a7336-2a951948829mr3889045ad.15.1770320278896; Thu, 05 Feb 2026
 11:37:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b3e81a27cc3e4c03fa8357c2c77b238997e48610.1770042461.git.lucien.xin@gmail.com>
 <20260205115506.2195311-1-horms@kernel.org>
In-Reply-To: <20260205115506.2195311-1-horms@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 5 Feb 2026 14:37:47 -0500
X-Gm-Features: AZwV_QgKmhAvyahpdZdywI3F6DO1BC_0r2LG19n44OMuBxjTNkYftoQ43Qsj1cY
Message-ID: <CADvbK_eTE-eRDpUQ0bLcJOTyveEYusBSqGZTYBYuujuABvm6jw@mail.gmail.com>
Subject: Re: [net-next,v9,05/15] quic: provide quic.h header files for kernel
 and userspace
To: Simon Horman <horms@kernel.org>
Cc: steved@redhat.com, marcelo.leitner@gmail.com, aahringo@redhat.com, 
	alibuda@linux.alibaba.com, jbaron@akamai.com, hare@suse.de, kuba@kernel.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org, daniel@haxx.se, 
	quic@lists.linux.dev, jlayton@kernel.org, tfanelli@redhat.com, 
	dhowells@redhat.com, linkinjeon@kernel.org, hepengtao@xiaomi.com, 
	pc@manguebit.com, kernel-tls-handshake@lists.linux.dev, 
	illiliti@protonmail.com, xiyou.wangcong@gmail.com, 
	andrew.gospodarek@broadcom.com, mail@johnericson.me, edumazet@google.com, 
	pabeni@redhat.com, matttbe@kernel.org, netdev@vger.kernel.org, 
	smfrench@gmail.com, metze@samba.org, mbuhl@openbsd.org, 
	chuck.lever@oracle.com, dreibh@simula.no, davem@davemloft.net, 
	sd@queasysnail.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 6:55=E2=80=AFAM Simon Horman <horms@kernel.org> wrot=
e:
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
>
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-loca=
l.html
> ---
> quic: provide quic.h header files for kernel and userspace
>
> This commit adds quic.h header files in include/uapi/linux and
> include/linux to provide the necessary definitions for the QUIC
> socket API.
>
> > diff --git a/include/uapi/linux/quic.h b/include/uapi/linux/quic.h
> > --- /dev/null
> > +++ b/include/uapi/linux/quic.h
>
> [ ... ]
>
> > +enum quic_msg_flags {
> > +     /* flags for stream_flags */
> > +     MSG_QUIC_STREAM_NEW             =3D MSG_SYN,
> > +     MSG_QUIC_STREAM_FIN             =3D MSG_FIN,
> > +     MSG_QUIC_STREAM_UNI             =3D MSG_CONFIRM,
> > +     MSG_QUIC_STREAM_DONTWAIT        =3D MSG_WAITFORONE,
> > +     MSG_QUIC_STREAM_SNDBLOCK        =3D MSG_ERRQUEUE,
> > +
> > +     /* extented flags for msg_flags */
>
> This isn't a bug, but there's a typo: "extented" should be "extended".
Cool, I actually asked my local AI to find all typos but got nothing.

Thanks.
