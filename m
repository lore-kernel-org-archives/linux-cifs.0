Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB5C1362
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 01:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707183018; cv=none; b=rqsiwPyyfMi2ri27ylu4L+6e13J4qMFHTZI21EMADOEBqkpGpTRdACfx/0/GjqenoYcTxjG8/xxP8JT4YVbgHrmqoM3tnIKbyx8ytmQiyJjo3nDcsGrxrEPuFApn5YvjCYOxY4HkOTx54Ub+qeRSu4MXeQRFqgVQiQjIa1ETCrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707183018; c=relaxed/simple;
	bh=LV1nJSIE7inOorSUxhRvlq9rNNC6PYyPzmO3eZeZuBU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IoOAKxkVnCB1KUfSm386YhSGknmFTLkt9htuLHEYneC8rsKn9UOWSOf4y+StsLrDRHeG83R1zAPYvGU5wChdzr6Fa+QK4Eye38wSZIvFLtQb1ie/EAhQTvtzBy6Jev0kF0Wrkg/dIPsMBRJwwxp3cYeNoc9gp7MUTBRgU+sVpxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=imMdqxLn; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="imMdqxLn"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-511344235c6so6216000e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 Feb 2024 17:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707183014; x=1707787814; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kj6QIOl3txlGTL0P0aaXLKd398YoR7+gfn5zUzo2gPM=;
        b=imMdqxLnJ6jOIlAeAwTVStDF9U4m/I8WFVEYIbW5FwaKL676udAufH5WZ5nXkm02PC
         FeWQOkOTWWAA2SemQA1eBjSEtui6juH587/WQJ90dM6XfMqTMa1eEilP3+df9dlxnJzE
         ONI/aBSZxe1uz/eI4m6qYRQeawBYqrtmSaFyPwGf8ok1Ikwc+3q9Ajz5jAbabYzZPOoQ
         wRB157gOcUEqmjm9o/Jo3Nae6VEwhduEIyhvW1Qq/V5aGZU+2zo9dkyWqhDX+cl4toSE
         xYFdZg6z82mzJ3E36yvaq8a6Q+oRR90mLJYPWJWqRIhDRL2wdRQH+WBh6NfhfCuqYuoL
         Ujww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707183014; x=1707787814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kj6QIOl3txlGTL0P0aaXLKd398YoR7+gfn5zUzo2gPM=;
        b=EI68iaoI2KQbniIt0tKkT29Q3qDibE2Dw6lQxWYl7TLq2HfgT24W1kmK0vXxvZHfbx
         7Nd0R43lBSI2g0VsjELr+VA+TgcmnecyOiWYCbsyFJEPLk/e/n1Bcifm9WCX1aADBXnF
         CkI1sPKFdr9Es4l+aRJVAmFIbv3gaoxwmbPrPmSGTxYijHEL6P7eMCdsmSKfOE9ocvk3
         8MmRoomT0h9z1KFsRdJ4b1sdHjk4C5f4lzlHcFCxNSCyvcF02qD/+HGMLDF60A9LxEBl
         CNf1Mx1ogW0Oz4GzkX6N6M1qo4YRrCH6TcQ7JD3pAY2oY5ibTPzJle8rJMeD4Mmb4p5y
         xCOw==
X-Gm-Message-State: AOJu0YzlPZNsqJKhTYVjkWmviMYfLgo3pblt7/jW4UCx3jfgMmVgpXrw
	b2dcQwPx6D3A7rfwY0+4RsHX480vIeZyZNmDXclMCn13cC9hnWAOR0Ak0XObibcOoVELLMkA+n3
	vPbwlBzGPFKdFZGez6iNQ8dBJyMs=
X-Google-Smtp-Source: AGHT+IG8F35tdUR//H/ch9xQ/Kinly4CvYconiIpYE8kDLQXQuIQNe4wyUsstcX7gl1gZw27B/H86hNDryovnHFscGg=
X-Received: by 2002:a05:6512:5c3:b0:511:5a3a:aa0a with SMTP id
 o3-20020a05651205c300b005115a3aaa0amr591318lfo.20.1707183014210; Mon, 05 Feb
 2024 17:30:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3003956.1707125148@warthog.procyon.org.uk> <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
 <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de> <3004197.1707125484@warthog.procyon.org.uk>
 <262547e6-72e1-436f-8683-86f7a861f219@rd10.de>
In-Reply-To: <262547e6-72e1-436f-8683-86f7a861f219@rd10.de>
From: Steve French <smfrench@gmail.com>
Date: Mon, 5 Feb 2024 19:30:02 -0600
Message-ID: <CAH2r5mt3we_rcKrkyweaVcH53QVYE8jaV9NCvaEvOrt16bwr1w@mail.gmail.com>
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
To: "R. Diez" <rdiez-2006@rd10.de>
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I can reproduce this now with a simple smb1 cp - but only with the small ws=
ize
ie mount option: wsize=3D16850.  As mentioned earlier the problem is
that we see a 16K write, then the next write is at the wrong offset
(leaving a hole)

(it worked for SMB1 with default wsize)

so focus is on these two functions in the call stack:

[19085.611988]  cifs_async_writev+0x90/0x380 [cifs]
[19085.612083]  cifs_writepages_region+0xadc/0xbb0 [cifs]

On Mon, Feb 5, 2024 at 3:37=E2=80=AFAM R. Diez <rdiez-2006@rd10.de> wrote:
>
>
> >> Unlikely as you didn't take them for the last merge window, let alone =
6.2.
> >
> > That said, you did take my iteratorisation patches in 6.3 - but that sh=
ouldn't
> > affect 6.2 unless someone backported them.
>
> Please note that 6.2 is not affected, the breakage occurred afterwards. S=
ee the bug report here for more information:
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634
>
> Regards,
>    rdiez
>


--=20
Thanks,

Steve
