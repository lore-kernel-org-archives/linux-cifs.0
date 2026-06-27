Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AA02820A9
	for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782583613; cv=pass; b=EUeYLYAKNEWGmFz98dawueMURrPEuCYK+0qp0bWf95IAlkX6HLCA9t8CGl4pVRbsLraIuF+Hs3cLNWlCPwPF+FsQmKIYOmkj9vRyDxytonEuFNuzLhqjk7D/bjmNNn5CFsdTirWpUt1DMZ8Ywwxlhl64avkstTh+QR65ls7qnWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782583613; c=relaxed/simple;
	bh=EuUznDG9bHPxUMqmWoeyKW2lOMOV5Cr51fwFwVVjzlY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uVVXXcuHdSQFoaVzztOa1HDAAoQe3WdO28UWMwZ2HiqNRne3jtDCcTazXmzoZNbZ2AiHmqPsd7RpOhQ2wWocx4lSX1s8ChK5FGvTCS0+nrkt/bOALdwwjWemIXsJNweklAGwOJNKfOPu/PlSATG+WYNRX7y+iJHRf0BVV23X/a8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CKjOZMAv; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CKjOZMAv"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-929a7eeb0c5so195065285a.0
        for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 11:06:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782583611; cv=none;
        d=google.com; s=arc-20260327;
        b=aASs7muy+v+ZPAiM6iMLXv44AEVjLzdTGkLH7pTCUQnA4f2+GuP4hFYsZN+B4ZIu4C
         Cz6e94DDO36cZXzFlyaC03b6+Fggsr7kopjhW/tacfOZEe6g8Vb9d72aSBJ46WxmLrzY
         L6lgYrsiOJu0BJKVGrKX4owyt0KPeBc0w8RaggG/4uNAt3NWDPn/nd0F8U4sY9Qullx6
         RHTt+/WzX3rdS7ku5z7WKt68hn4ChAAymTJVjD2kADRpH6ho/QPbVZZJpJsXuJIMQXVI
         V3nd8wFnphKLm4O/HiL0FNNjFytGaioT0y3a1cnLwcJDTsdMdRJ/6tFzlJTiWoDvi+zr
         cmNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x8TDgdqdF6+N3k11pZisCeldDUrmaSbJnx3zpnD44mY=;
        fh=iu8FHAQVAVMInlMpoivmzu+1Ec494RicNbo6XtRdOJQ=;
        b=Pm7TlVDdZbbSuGxZ/3awTiIK6MaEnGVvWzOaaluEDJhMqJ6a2ZqCIWgwCoVrIqKUMu
         HEwZaxp/jiyx8h2ngB5gaA/jlOA1bgkCLbNG/BY6tL/k2WfX+ol1k1pOvu3m31fOoXHM
         zIDv5KMscUzoWoBEDsiJWtVIcGAQvkBhMcPoFZHLcf5A+jB6fMf/MMilpQPDTwkn5MtF
         /KBMeYZX5UYY/R4QZ+yqC3TbXUJgaX7n1CrV1TVrYsM5RaPrqu9p5iXoYgQGqeYJDjIu
         PKTCAzJrheQ8czNFFPKA9PI/CQTkr3FSC1VSCEah2aSZXIo8gSyX1ZZK8bqpsPViJtb4
         usng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782583611; x=1783188411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8TDgdqdF6+N3k11pZisCeldDUrmaSbJnx3zpnD44mY=;
        b=CKjOZMAvES6bEOOW3fxQESKJQtdVFB4KJzRIBqC/kdlZmyrs6048K77qB/IIUbZTKO
         UgxUGPgA4S/bzZsLjsvt5td4907k4yHgCrWmQFfRAg7HlOVW2YWcwIT/1lmOsKCB9t0c
         kf6ZO6CIHkBzEFK32PDLemmtfEvHK2jgpMOry9XT0M8T63MI6fM1YwGvk+VboMRMcGg8
         yzqH84xZ6gmVHMHDyOTPbDO3Qziq1OrHK1tBSUkZ/9Na6tKuSAUKx7/e8wmq+C8LnUKK
         JBUoNHBUvo300o6j1P0bQ5WlYnKpvxmjxR5aTsVwIrQQ/Q1WQBK5fpJXDGq6VahNQNYn
         2vBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782583611; x=1783188411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x8TDgdqdF6+N3k11pZisCeldDUrmaSbJnx3zpnD44mY=;
        b=tIqTY4S8MtE+8q7uszyu4x3ovdPGzUAm9AZUjwBAHAByl5UMTx4P+h++yx2cZDnKsF
         PhjG6gzMe9orv/y6TFZMMN60lambVVjBFdbWqSw8gyGFY+XCD8Y3xwUz/sigjmbXohoo
         SvE0QwqyTnwq1jUXOmtMAOJEGtPZEHYTM+gt5UAq5bz8Z1uKmvznoc//7DF5J1pXNQgq
         aH5sQO1Gv8HMP02/BTUq8uBpGBYBoGQYPwWaMDEdcslELmh4LgdjCkCtmATR4zc/EaoG
         TlYI2cLtIR+z+HenDsGSL3SbooJdnwkP8Yc7Lg50pqQgBFcsM5IqITH1IAjNnEFPkoT8
         m4Uw==
X-Forwarded-Encrypted: i=1; AFNElJ+OnBUYdvJ+yldd0tqERjfLFUEut2O/gfXd47+J8ks76Bj0yyHx6+A6rqNjnHIOZ9vylIyxHjQe7iWy@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ+pltWIOcxu5AmDvQEgw3OorSCximQfdgouUkReaf2lTKwtWN
	6CUviSBmqDv0MSOOVF7/yFkoVj/f2pOUoVSSmSTDBQEoiscCROR9Yg2D1Qvg5WrW8/VWrFYRyrT
	2is5CkMxDpKSDz06coswiLdRDTheBHxY=
X-Gm-Gg: AfdE7cl71vK9J0JPgrUbjeebjaTpcIfzwzJcn8jxoBGQNobl1bIbjui6Wz4bH4HPnj9
	ruUGG18LAcPZ8Fxc79p9+5QZDMUjLLTzTwb36GnNky/ez/T2e3ZE52SAQRsqt7fFDQjXiWG6H2C
	HGveAI5ZUqSVJ5WO/NnWOyeBAitJRZddqcSrvSSLlUzsAtFGLVFtJgeMWlAcU/aEhWAqj3eJwTu
	DbPTn7pqXi32G1AuPT8I9/fx/GXjcTxTyK4Dafh/qB8LuW8ql6wkXefcL1oFabn9ZfaJSA3nA99
	7qES/r9E6JiNJFnzGr1FShy86FpSctdySgfPgThy8OatuQ1wV5yHBn39/JQ6c7fxs/3vkb/Iuaw
	7b5cSl7pPjoljoyCbl6fXCsL8ZQZJcUccAODP6anFrxxtoDk6d9fwh5DpeyjZGRB9z8peSIqJ6X
	JJy+teTBbEGgI=
X-Received: by 2002:a05:620a:3726:b0:914:b497:c5f0 with SMTP id
 af79cd13be357-92601f1baaamr2894436085a.26.1782583610996; Sat, 27 Jun 2026
 11:06:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626134719.158270-1-huiwen.he@linux.dev>
In-Reply-To: <20260626134719.158270-1-huiwen.he@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Sat, 27 Jun 2026 13:06:39 -0500
X-Gm-Features: AVVi8Ce5eX6M7etk5d-4cPFV0t-eEPBewAi4OGd_0JrFJb83QBsjHnVuht2PRvM
Message-ID: <CAH2r5mscAwv1BU25XouJpX_5gx2Xatnh=g6BiLnQj0DvVjrxSw@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] smb/client: fix fallocate and allocation accounting
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Everything passes with six of these seven as long as I leave out:

          smb/client: verify allocation after EOF-extending fallocate

and revert the earlier patch:

          smb/client: preserve errors from smb2_set_sparse()

On Fri, Jun 26, 2026 at 8:47=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> Changes in v4:
>
> - Add new patch 1 to refresh i_blocks after successful duplicate-extents.
>   This fixes stale st_blocks after reflink and avoids the generic/370
>   swapon hole-check regression.
>
> The following patches from v2 have already been merged into cifs-2.6.git =
for-next:
>   - smb/client: do not account EOF extension as allocation
>   - smb/client: preserve errors from smb2_set_sparse()
>   - smb/client: name the default fallocate mode
>
> Link to v3:
> https://lore.kernel.org/linux-cifs/20260625160154.104450-1-huiwen.he@linu=
x.dev
>
> Link to v2:
> https://lore.kernel.org/linux-cifs/20260624021550.1548952-1-huiwen.he@lin=
ux.dev
>
> Thanks,
> Huiwen
>
> Huiwen He (7):
>   smb/client: refresh allocation size after duplicate extents
>   smb/client: handle smb2_set_sparse() failure in EOF-extending
>     fallocate
>   smb/client: handle smb2_set_sparse() failure in non-extending
>     fallocate
>   smb/client: handle overlapping allocated ranges in fallocate
>   smb/client: reduce fallocate zero buffer allocation
>   smb/client: emulate small mode 0 fallocate ranges at or past EOF
>   smb/client: verify allocation after EOF-extending fallocate
>
>  fs/smb/client/smb2ops.c   | 169 +++++++++++++++++++++++++++++++++-----
>  fs/smb/client/smb2pdu.c   |  19 +++++
>  fs/smb/client/smb2proto.h |   3 +
>  fs/smb/common/fscc.h      |   5 ++
>  4 files changed, 175 insertions(+), 21 deletions(-)
>
> --
> 2.43.0
>


--=20
Thanks,

Steve
