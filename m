Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04567342CBA
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786686715; cv=pass; b=GdAuZ3/ZEJT/Wi32pGcxlrhMhBrOIwhWLm0Ja8oNDWpnquRDQI95M/O5t6bJI3B7ek5LDZxU+QIBhQxROMpvkO+qxBgqKrLn+j11i22/7NlvGc001PyMt4GtrKXeMPa5mi7KnqA48eezjFZfFifUK14bMd5QC1SKdDScxGZnNB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786686715; c=relaxed/simple;
	bh=m+2wJKeUemdL12mwDzfUHMzEAZu75kPShRvWTeBfMuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QbZxTY2M1d2H2vZ17jFPHOgw8zaoVeTyj2ExtTA+ubAJCeAKqktPq6KoIlRfCVhOrIe+MHqMdjIbTKatasQbZoSMnuuqwPjVY2Wu36cP4yes6SM6VUloLYXkwo8M1BklLVDvJ2pH4AWqoCsKkfrCue7r5HXU8JvhOztyvnNQTc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D+aFcSoS; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+aFcSoS"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8efef6533aaso3675026d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 22:51:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786686713; cv=none;
        d=google.com; s=arc-20260327;
        b=rzZAh7mKBUeqDB80AyL5J/IRN1/i3H2fCVnLfsoC2FTG43hoEsYlIez1jfd3020SVz
         xmLQwWpgc1MV2iJ6irJfZgZppp64Vo709eLPFHi7T5sbvfpwIP9nJqC6UmuxCRsBFdzJ
         93n2zDeMTN4r8OMUZix/zb26LCMBseG/rnjO/tRS23nwfOFtf7R6jTFN7oSlEsJaM006
         xdpUNPSRBYNR19kV2XDFh8yZ3e35Rd6GK4Xgumlbp70Fl2VyBjsXZo4yZJDorN6wuST9
         y9sr2h+mFbtpyAAbUZ5Lk7l2WgYeHLtP3IHVJfdBycBV88opj8k5K07+z9Mu0rSbsRTW
         A/kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yfWJyZWwmjHAmpLpI8ox90wKf1hzlUpGXeGChc3PPEE=;
        fh=mV02bwQO51pgHp+D3X3/G40pNqbIH6IeYWuEFW9gWDo=;
        b=nRJ87iLXgHF/OvqBaF8z5PKSrOokIuzwksaoPiODFAe/mOQyeccOF+SvcDos1QvB/R
         of7uprUBYwh3Vw28DZaI/rpJl4EmwXKCM8bjX+73JY5Omfer77YFYyJFTw5kv2ck+WEB
         J8FMQtkZuGTU5ZkgdpWOzsL3QQVUiJnMqpRaHSxAn1nS/quvOQXT+jaJqDI3Z0sjEs1Q
         jzV/DAUe63E0nD4e2FmDe3xAOptv1DgasSqEy41jQ3xxH/+DqSBEHnQZ2EzMi4uBczdu
         c/XN4ypsLyo1wY5fSGfTVHefgqWdv4lz8OFdG5XX9WAE/DU2qCSihSapFBZKGB0Oxv3R
         /EKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786686713; x=1787291513; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yfWJyZWwmjHAmpLpI8ox90wKf1hzlUpGXeGChc3PPEE=;
        b=D+aFcSoS7I8zWXb24OWdoyVnfbCicO/2QqT83l9CkpvXD580RtFTCcWg54Ewd6wuTe
         VMZFObVTfhS/nsEm8dBjd9hZKIzx7SqJNNRrY6G3jGGcMht6ja1NquTjYI6MHj6wgiA8
         dxiGFpBwZaqfBi4sxUwX5EC4FwHp1lc9ZIq4YfrMmTGiC5XNwhalQ8fCJz24QadepHJG
         RvofSIAywY5tzldZPxS3/G6JdDhfLUzRdtuTpNkIEGM387kvphflCgn15tWBxxFnQ/VC
         /GWEraqEQzOLTgAwjUH10BXVhGaw8eYTQ6owm7JiNaNzrCW+DmE3bM6yeY9EdnPCac6k
         4wXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786686713; x=1787291513;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yfWJyZWwmjHAmpLpI8ox90wKf1hzlUpGXeGChc3PPEE=;
        b=lYiBgv/4aSnBRySt9HqXSE79R/D7Df+BfWPcbZZM8hyZDUy9dx59u55E5GLSn/GlFJ
         63ytqcC9+UfmSJRUvOA2UUo88WvP44ipXwDAhMSRTrjHvWhC7MRGMhe/tI0lEsiYq500
         NT6g9ifAGsQfqYlS8JqKSXhjqjVD2PVTPZ2ndZkHZBiE3hU/ZULFmCThxZHtaGV+cSoC
         jFA+dI8f/pM9RJReYq62M1jwuEIEKj1fYBCjZMfi6bXyKqESDovyXiE42CtcXPvXMAA+
         DWytWkNwCwbt79KIXp3N6+Cy+XW1oChnjF+3jG4vbazIfNke/I0h2cBsjtHW11bO6G/R
         6d5w==
X-Forwarded-Encrypted: i=1; AHgh+Rq8o6ydP6hNtvkHeXa10KdLa7PduuRmUux1BbtbX46muvS2CvVdvLcSbcYVl4nTwCJu5HrUmp/9Lerw@vger.kernel.org
X-Gm-Message-State: AOJu0YxQdA8NN+fb3tezNauajdgysegqgN4cg1SnD0X2yRkoXn1IPQKF
	HaTFX9JYjwh0J/tHwf7y4SfombYop/2XIaoyqv2zZvtHxLlz1E8EDVDA01VJAxA9f6LjS5sjMyU
	PMwgi8c9n4WDQ5z6hQ1LX37YJCmil4+c5udVeV0OUwQ==
X-Gm-Gg: AR+sD13XaBEPfqiIxFqXqt1pgQYhcqG1l/sMpW0IsHLgC9LNcqavmmBbOmsGLfneA54
	/sWxjHYlFoTnqctI9KlnxIqPhcshw7+3zFWKecyJA+M8s5wcLqjGOR0hQD+K9jzWFQt7BSgDC4D
	V5FBf44TRsH5tAZLsQhqP6GnqYTakjTiPH1moa+kXjDAwNXZM58+ZFD/07qumxz3SBOp7sJvn6m
	eK+XCpM7XW/ym5JJNPUOKVp8bj4I9a3Efusa+XjXoz7RX6iYrN3taePA1Mn4uK+1nl2x4i/s/Nh
	8cTcje7PI6N3vkkOXUMre29LvgJpereckGgYGK0hco7TjMGY+eJ4Gl6hwt6nLhdnrHub6KcKfBU
	UhZ3t+nuJR/wsRvXwM0mCvVLTtqsi
X-Received: by 2002:a05:6214:f07:b0:8ef:e3c9:533e with SMTP id
 6a1803df08f44-90a91ca54e8mr35334916d6.9.1786686712760; Thu, 13 Aug 2026
 22:51:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <CAKYAXd-B1mjT-JONqToLMeQKmV_GRdR1Pogi9VugyCADATpO3g@mail.gmail.com> <930abff2-18f6-4a68-ae07-1e3675c90ae3@chenxiaosong.com>
In-Reply-To: <930abff2-18f6-4a68-ae07-1e3675c90ae3@chenxiaosong.com>
From: Blue bird <obnred@gmail.com>
Date: Fri, 14 Aug 2026 14:51:41 +0900
X-Gm-Features: AUfX_mx22IctoOcVXWk9N1v8qNgX-aHDN53X5GBbHUd5XjHiaFqb2m6Dc3w6M8E
Message-ID: <CALT=-84nzBrQx62WgOkdQeDfB6+75O31uPoN2hAiBO=xO=tnWQ@mail.gmail.com>
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Can you check if an attached patch fixes this issue ?

Yes, it fixes it. Thank you for the quick turnaround.

Tested-by: Kyenghwan Hwang <obnred@gmail.com>

Setup: smb3/ksmbd-for-next-next at e7317f3e41 with your patch applied, fs/s=
mb/
built against the 7.2.0-rc7 the branch is based on, freshly booted guest,
CONFIG_KASAN=3Dy, kernel otherwise clean (Tainted: [O]=3DOOT_MODULE only).

  before (branch as-is):   BUG_ON after ~1.6 s, 142 lock requests
  after  (branch + patch): 11241 lock requests over 181 s, no fault,
                           kernel still Tainted: [O] only

I watched locks_sent climb the whole way (9950 -> 11241 in the last 20 s) r=
ather
than plateauing, since a stalled harness reporting zero faults is how I mis=
led
myself earlier in this thread.


> On ksmbd-for-next-next, to reproduce this issue, the following patch
> needs to be reverted first:
> ("ksmbd: implement the command sequence window")
> I am still analyzing why this patch needs to be reverted to reproduce
> the issue.

That one is my fault, not the kernel's -- the revert is not actually needed=
. My
reproducer was violating the SMB2 sequence rules and that patch started
enforcing them.

lockfuzz2.py authenticates with impacket and then hand-builds raw SMB2 PDUs=
, and
kfuzz2.py used to start MessageId at a hardcoded 4096:

self.tid =3D self.c.connectTree(SHARE)
self.mid =3D 4096

Once smb2_check_sequence_number() exists, 4096 is outside the connection's
sequence window, so every raw request is rejected with
STATUS_INVALID_PARAMETER -- starting with the CREATE. No file is opened, no=
 lock
is ever sent, and the harness prints

t=3D5s locks_sent=3D0 faults=3D0

which looks exactly like "fixed" but means "the harness did nothing". Rever=
ting
the patch removes the check, the old MessageIds are accepted again, and the=
 bug
reappears -- so the revert looks like it matters when it is really just
restoring my broken client.

The one-line fix on my side is to continue impacket's sequence instead of
inventing one:

self.tid =3D self.c.connectTree(SHARE)
- self.mid =3D 4096
+ self.mid =3D int(s3._Connection['SequenceWindow'])

With that, the reproducer works on ksmbd-for-next-next with the sequence wi=
ndow
patch in place -- that is how I got the 1.6 s / 142 request figure above, a=
nd
the test of your patch was run the same way, with nothing reverted.

The other thing that silently zeroes locks_sent is the per-IP connection ca=
p;
the harness churns connections from one address and hits
"Maximum IP connections exceeded (32/32)". I set

[global]
max ip connections =3D 0

for testing.

So: a non-zero locks_sent is the thing to check before trusting any negativ=
e
result from this reproducer. Sorry for the detour -- I should have flagged =
it
more loudly when I first hit it.

2026=EB=85=84 8=EC=9B=94 14=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 2:13, C=
henXiaoSong <chenxiaosong@chenxiaosong.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> Hi Namjae and Kyenghwan,
>
> Namjae's patch can fix the BUG_ON issue.
>
> Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> On ksmbd-for-next-next, to reproduce this issue, the following patch
> needs to be reverted first:
> ("ksmbd: implement the command sequence window"):
> https://github.com/smfrench/smb3-kernel/commit/15ab73a0feed2aaadde8e7ac3c=
216f5c0d1d024e
>
> I am still analyzing why this patch needs to be reverted to reproduce
> the issue.
>
> On 8/14/26 12:21, Namjae Jeon wrote:
> > Can you check if an attached patch fixes this issue ?
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
