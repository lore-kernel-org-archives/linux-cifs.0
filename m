Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C87C2D7397
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 11:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761306995; cv=none; b=ixyPBUyX/QwPny/6ErutJx1ap0bRb/3LUxaXf70RK48TA67G12uQ9w3nTU8C5kSLGvJMqrG/aCmYEmLJzYFITVx/82yemgmyWxUR+ZLbmMF7PpzJ73BVwWnfJiRytaH/RSHW1s4or5gUiAU4PYio9snA4qRfSOcTIkBCdMi4kBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761306995; c=relaxed/simple;
	bh=ACoNH0lSBzy2MY8jvcQwZdqk3X6Ccng4+YpsE4ZHyXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=km1RAx0KIDKN4JVhhMnDoJE+5s88lsMIcDYzNERH3tEOn8SaWwCKxrIyewenpwuWRu2JlycB8ucVgSKwqGfGg233fUEXncLDOUODHqsYdi1NyHUEgq1ycJjtb8jeOMIQdMPuJ3VEJrFaFI8v56CQEIjf+45cRgunbGX5LFDwcbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hdQG/0zR; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdQG/0zR"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-63bf76fc9faso3672445a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 04:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761306992; x=1761911792; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwR+/Jm6EkkRDAJG8MMcyRDD35Th6Z2O6LXMAxsoumw=;
        b=hdQG/0zRWkM3IyPUX9mmuCNhExgnNmfWwTJ2afUyqQ97fVKN1pSvzZa81JUAjXcFyJ
         GLSPc/BP98MNYFmvts36Ya8Ueb192oa4ko6R7j0zAgOiiwp9fWv2tiMAZo/aeGnwvbwU
         WHpQOeaYfBI7reUGhdPowzp1FybKXuURnjF3gu4CCEY+x+6FenXJLXgTwCSw4uRJmO3t
         lbGH6bYJ5w7rbEJkjSDDEqQ46RuLbUPIsV62ZlsX6YqiUi9y5+86cTYnJAkqXl8BUKZU
         E2nzqtcj4E3hdaCRewLEBSjf5k33Ot/zq0qYXD0oJQktIAJdkofQYXBaTyU+sYL7YzDM
         FKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761306992; x=1761911792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uwR+/Jm6EkkRDAJG8MMcyRDD35Th6Z2O6LXMAxsoumw=;
        b=A3BKFYiS3YJVWeKlCbQL46/gSxSq+Uoyb7GdtCCwagaqEnuDyjauKkWjgAUKsqzX+5
         h1+U88W53NfOjtekMqIj1ayQbarQVXCOHcYbdFhT89e8FMjwmDDfN7u8LLAVSPMkAGEM
         COM0Y6uRnYUToouQb/wb9BZuCqk7qyqaHunT3HZHiNpzlsldsGew5jGtDZ6xLC/flGUW
         2d5kZ2IaNkxCrXspKdKEp1priDDoToYnBi4CGAWZFxqqwfXCe5ElZlYa0a+DCjcnfdT6
         pVer+Ixv4+QEgyjwWTs5g70rx8cjO5r0UzYj9gczTRo0IjN+6XF8vay+Z6eNAhwWzS9M
         npbg==
X-Forwarded-Encrypted: i=1; AJvYcCUg9pW7PdW6wSEThqjuSgdCjZQ9vH/4Rdzmlx8d9lYaopXwBB8DP4yd6p/bT9K7gcXnUSRBloFXS0HI@vger.kernel.org
X-Gm-Message-State: AOJu0YyfD3cHSTpIrRvcmOWlob566glUwl/DXE8kpXSd4blmGFfDO9ks
	9TF0v8XCOnfsPTYVstncEbCHodQs3hQ/9Owrxutb/c0t8GlWTjY8EmEtUkNeinKnH1mk97WSSC+
	gGhlrp5jL4AO01dBBhsLL5BxrGX6h2oA=
X-Gm-Gg: ASbGnctYgHgnX/6fA0XAUBPtfNMHhbyioiILXpL3eYkp4kjxfPaTtKwx3XQnADyXG4q
	5a4n2vzqjBnatMH5ZTt4pjeI8sv3VXTN4bO0pHHuH76Tli7T49UGbQYbkIPNnza/ZdfmixaZnon
	lJfMEgN1UGPx9X8XlHaYWlS4r+DiW2jEixv0G886UA+Mmh8rOgJrwB0A/JVLVdwyUNn0qym8uIm
	W1U8IXt4BNIiInP8Q1qCn1AhNTKbDJ1pPgXZZ2ijUuz8kC4AhwtYVdHcws=
X-Google-Smtp-Source: AGHT+IHE3Iz2syFfR43Yq3FpCNrL/nUaYLptXJdz+pAJJLM8FncdsNLhl4uWTcGcFMCzkwd1udQxcEsnrpkBAnTuFMY=
X-Received: by 2002:a05:6402:2813:b0:633:d65a:af0e with SMTP id
 4fb4d7f45d1cf-63c1f6cee4amr27724075a12.28.1761306992262; Fri, 24 Oct 2025
 04:56:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1006942.1760950016@warthog.procyon.org.uk> <vmbhu5djhw2fovzwpa6dptuthwocmjc5oh6vsi4aolodstmqix@4jv64tzfe3qp>
 <1158747.1760969306@warthog.procyon.org.uk> <CAH2r5mvOwmdcP_5kjC+ENgtooi06AuPvwBXrMnZrfy7_poAoFQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvOwmdcP_5kjC+ENgtooi06AuPvwBXrMnZrfy7_poAoFQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 24 Oct 2025 17:26:20 +0530
X-Gm-Features: AS18NWCe-VxGu6za4D792Ov4sUu1JBPpCTFZPjWiH-jlNP-e3S38WPUGM2z3jfM
Message-ID: <CANT5p=oPm1sh_HTWUe0-bF=DVAc5K-Ny7Cib7+Omzhkz5zJ4_w@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix TCP_Server_Info::credits to be signed
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pavel Shilovsky <piastryyy@gmail.com>, ronnie sahlberg <ronniesahlberg@gmail.com>, 
	Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 10:28=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> On Mon, Oct 20, 2025 at 9:08=E2=80=AFAM David Howells <dhowells@redhat.co=
m> wrote:
> >
> > Enzo Matsumiya <ematsumiya@suse.de> wrote:
> >
> > > Both semantically and technically, credits shouldn't go negative.
> > > Shouldn't those other fields/functions become unsigned instead?
> >
> > That's really a question for Steve, but it makes it easier to handle
> > underflow, and I'm guessing that the maximum credits isn't likely to ex=
ceed
> > 2G.
> >
> > David
>
> Interesting question - I do like the idea of keeping signed if it
> makes it easier to check
> for underflows but IIRC that hasn't been a problem in a long time (adding=
 Pavel
> and Ronnie in case they remember) but more important than the signed
> vs. unsigned
> in my opinion is at least keeping the field consistent.
>
> I have seen a few stress related xfstests that often generate
> reconnects, so we may want
> to run with the tracepoint enabled
> (smb3_reconnect_with_invalid_credits) to see if that
> is actually happening (the underflow of credits)
>
> I also was thinking that we should doublecheck that lease break acks
> will never run out credits
> (since that can deadlock servers for more than 30 seconds as they wait
> for timeouts), even if
> "lease break storms" are rare.   Maybe we should allow e.g. lease
> break acks to borrow echo
> credits e.g. as minor improvement?
>
> --
> Thanks,
>
> Steve

I agree with Steve.
I don't mind credits being a signed int. If credits go negative, it's
a clear indication of a bug and jumps out at you more than a large
integer would.

--=20
Regards,
Shyam
