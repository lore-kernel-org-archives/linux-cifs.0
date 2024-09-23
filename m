Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832B71A01BC;
	Mon, 23 Sep 2024 19:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727120205; cv=none; b=LOp8NJW+sNhWcEUY2Pbka2OU8dR+XFVFG0qNCKcZPE9m4+rPrPPqUIrt03txAo/zzovX54Ymh3SgrtxfMqu64bGK+q2QfLfEsB3H1H0cRNuzVGQiX97FEVr75KVoYg+qqlWwtWLw3zyas6l4dV1SU5GshKgk0pIsjeJfiI5eP74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727120205; c=relaxed/simple;
	bh=bmBv1vObL8RI83ZhIdKmWULk4c6V2BAm7FsDQiuAEVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uuaIb9Q6v9+vi61zIZG9oLpYA4SolySKPOOJ9ZGAgi6nQg/dDDay4cAJ71Il8I+UVvV/0PwPSEkuDHn15w2dZwTO2WQBuROQ2C+igjPRrzhV2GZm0ItJrZnq3XrinMmjZL9EssL1gHLKnP0IIrXTbPOwbt/OSSRh/4yX5c8WjtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e/nlwspq; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/nlwspq"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6dddca05a60so50645227b3.0;
        Mon, 23 Sep 2024 12:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727120202; x=1727725002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCIetOQWA8mbVkxhV2ImPQ/8Xy4Tc3hHpfKz+JTFGXA=;
        b=e/nlwspqZ0t2PNjOTJIVk5itnJKcbn8mHus/awhQseAmKU7N3hnXryJkgUAKOEhk+A
         ywGgkUOmZeZ01G8tTk3cYuDhTAfxJTktE6M7yt7++qql/2N0cQAy/SyzJgmUkrs8e8VE
         Q07L2DRXwIDicueybkmF96Pwil6TXaTOTjldKy36qJhANAoPahjbsmjZ00tmWBWxRneX
         GpUTK/UYZTl0bm30Q/NcOzzgwxW5C7BWYjVannopfKM3yncgnoR6sMbMSnPVK/fymBWQ
         6WLHfQXMnzLOxOdn9SN9yNzsGuSn3qGknhb0v/RKI29dGIsugwkog/jpJPaotK9rbX5o
         dpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727120202; x=1727725002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SCIetOQWA8mbVkxhV2ImPQ/8Xy4Tc3hHpfKz+JTFGXA=;
        b=snh9ajTDS8kaqdf2CV9Rdz3gfnnn+GlcHO+Hxk6EbusBo138pHSjMo5432Lg8eypVv
         saKqqV3juoEPvo2pO3FC6/pykqdfFyvcOx5xTqPE+WZ9IRpJui3JPu80RXHlixwE4YEL
         VrGGEMh6Q3zoB2G7XFA9Xmmu+HKuwePjkfcDyjBavXUVX5/McF+Jl8zlWhWoCjBwYxKi
         cT3eUvyqwVZy0vBLZ8FgLuRruJI+IGK7VaS6AoeA0mpw0VRNfOHuadFfZ5+022Hw4oeh
         gAUEeU1yDJxcJA2kY9d9UawYdx8JSWi80x9ZJSziYmMlrke9QaDwAjupAPe7xRXPz6kn
         uPAw==
X-Forwarded-Encrypted: i=1; AJvYcCVx7n0hrJEXX6+Fd4W1EiBIw1Y0oAtvQ4r1P4E5/cAzlt+uMIn3AwXSrwXwe9b2AeCYql+LR+25K7Ggz5Kx@vger.kernel.org, AJvYcCWCBVJjlOq9JFTbFqHa3+EoQ686nPo5ZwFJ3GcwZNUiM4tS0bolkmPSdAX0UkC7esKb5lDbdV4q64ja@vger.kernel.org, AJvYcCWyctHGJJetPG3ElI08C58uN3f2lX4NcJvfE7GCNMFM4kb5HF5ZQvt3h5HR4d26W/apX/frPs2l@vger.kernel.org
X-Gm-Message-State: AOJu0YzWxZ9uDPVg2YPeJGvgNvlpg3vCowYNJ0Totn0i+pZBr/J26f/j
	eOUQMjD+9E9Vq5J8UD55un4dv//L/MHLkZ4Zv9phUzxukVzNip5sLAIlcOFtnfVAImNW+dZbJm7
	xvBuArv4pg9v4rNblgs7Vq7HBJng=
X-Google-Smtp-Source: AGHT+IG3wnQLnjt9RPE6DrvarHQo+N74IMHJjYo2aNgXunkCZeItx/hYB0d1rM4qFbIP6RIGbhWxroMQroDieS/1oF4=
X-Received: by 2002:a05:690c:2508:b0:652:e900:550a with SMTP id
 00721157ae682-6e20886da73mr5993527b3.19.1727120202432; Mon, 23 Sep 2024
 12:36:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <DFC1DAC5-5C6C-4DC2-807A-DAF12E4B7882@gmail.com> <20240923075527.3B9A.409509F4@e16-tech.com>
In-Reply-To: <20240923075527.3B9A.409509F4@e16-tech.com>
From: james young <pronoiac@gmail.com>
Date: Mon, 23 Sep 2024 12:36:30 -0700
Message-ID: <CABaPp_iqgUw3TffQHrVYUoVoh03Rx0UjvrNw0ALStF8FxufFrg@mail.gmail.com>
Subject: Re: [REGRESSION] Corruption on cifs / smb write on ARM, kernels 6.3-6.9
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: pronoiac+kernel@gmail.com, stable@vger.kernel.org, 
	regressions@lists.linux.dev, linux-cifs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org, 
	Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey there -

On Sun, Sep 22, 2024 at 4:55=E2=80=AFPM Wang Yugui <wangyugui@e16-tech.com>=
 wrote:
>
> Hi,
>
> > I was benchmarking some compressors, piping to and from a network share=
 on a NAS, and some consistently wrote corrupted data.

> > Important commits:
> > It looked like both the breakage and the fix came in during rc1 release=
s.
> >
> > Breakage, v6.3-rc1:
> > I manually bisected commits in fs/smb* and fs/cifs.
> >
> > 3d78fe73fa12 cifs: Build the RDMA SGE list directly from an iterator
> > > lzop and pigz worked. last working. test in progress: pbzip2

This is a first for me: lzop was fine, but pbzip2 still had issues,
roughly a clock hour into compression. (When lzop has issues, it's
usually within a minute or two.)


> > 607aea3cc2a8 cifs: Remove unused code
> > > lzop didn't work. first broken
> >
> >
> > Fix, v6.10-rc1:
> > I manually bisected commits in fs/smb.
> >
> > 69c3c023af25 cifs: Implement netfslib hooks
> > > lzop didn't work. last broken one
> >
> > 3ee1a1fc3981 cifs: Cut over to using netfslib
> > > lzop, pigz, pbzip2, all worked. first fixed one

> I checked 607aea3cc2a8, it just removed some code in #if 0 ... #endif.
> so this regression is not introduced in 607aea3cc2a8,  but the reproduce
> frequency is changed here.

I agree. The pbzip2 results above, regarding the break bisection I
landed on: they mark when it became more of an issue, but not when it
started.

I could re-run tests and dig into possible false negatives. It'll be
slower going, though.


> Another issue in 6.6.y maybe related
> https://lore.kernel.org/linux-fsdevel/9e8f8872-f51b-4a09-a92c-49218748dd6=
2@meta.com/T/

In comparison: I'm relieved that my issue is something that can be
tested within hours, on one device.


> Do this regression still happen after the following patches are applied?
>
> a60cc288a1a2 :Luis Chamberlain: test_xarray: add tests for advanced multi=
-index use
> a08c7193e4f1 :Sidhartha Kumar: mm/filemap: remove hugetlb special casing =
in filemap.c
> 6212eb4d7a63 :Hongbo Li: mm/filemap: avoid type conversion
>
> de60fd8ddeda :Kairui Song: mm/filemap: return early if failed to allocate=
 memory for split
> b2ebcf9d3d5a :Kairui Song: mm/filemap: clean up hugetlb exclusion code
> a4864671ca0b :Kairui Song: lib/xarray: introduce a new helper xas_get_ord=
er
> 6758c1128ceb :Kairui Song: mm/filemap: optimize filemap folio adding

No luck: I cherry-picked those commits into 6.6.52, and upon testing
lzop, the file didn't match the stream, and decompression failed.

Thank you for investigating, and giving me something to try!

-James
