Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BFD331A41
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 20:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840063; cv=pass; b=mWNKvl+AMEi5VvpHpMpLEoLfZ4CtGfQBou9OSGvdskSVV35gA4obo8KJ+ofSKNeoeMvyNyLpPZ7YW73/Sn+XhkrcUC30kjnFpkfIZ0TzF/kcJuMrCeqIqOMgkHLiSdFN/dqM0k0843K6VfxWY8Emtoyiyjc598eQW4sseIJUEWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840063; c=relaxed/simple;
	bh=80vRoB4fzgwK+g4kHzhkoFXh4perI8ZUdSbuBhq87v8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G86qTs8q+p+QOsJedbgIuXE9QzeaHAomOt8jOOGuM8DMv4lw5ubIAIEcFPUMFovDoCSGCpbgnoSyEWH9OUtusxMcVB4nMG3nqv0STCAM7ITpfjSMy5XLLS6h7QAnxmmaTECq9H7VgBFNW8d2XNn/u1kQF1ij4exDptdRo1Ql5ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hfX5QgaN; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hfX5QgaN"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-902e4af2d9dso10619756d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 13:54:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784840061; cv=none;
        d=google.com; s=arc-20260327;
        b=DaMoX3Bn7U/5s24vUFPjP99QGw9UE7SEQ/FuhdkBjMGZBxUKiGlUScBTd5122diyWP
         vaNOtTHuqj2YxSBPzK68tQ2/bv+lsyxjvbV6B9cvYrax6hwRf9Cf9bZgYRA7cC2mr+wM
         tF3+0W7iAVZ0RQ8bygHmvnF3cXtwYqyYUQ1XvRnJ/iAqrBu2MLNpHAX82dTPsKNZM2iD
         zvMzQn2ge1OMhTxdPl3qZqfDzY+6NbZMYnZyt0xU8/C540E0mkDbtmTmf25lElhrnNeX
         cglAkL33zm2uRitTM+GTymhVAy4HLjEJBIkxOc9k2nqCtodoj5jnaTQ6Nhe7PEF/MrBy
         CqoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v1XxKkxydP+gmPUoFLYvGTbtdjO5YMG4JDZhVlcmQ+E=;
        fh=GhYM31r8v/Kd1f9dNSikvF/W0v7ZgaF8uU/5+bjH6vc=;
        b=rmw3+CKLqqmm7y/X1gyr+zvu65DIOqWATFK+N3iBVKcY+uiLNl0iS6fa9RF7TNE00G
         St4TJqL5Zw/ECRqCq2xLTbYja/Fxj4NKnnxF+QeRuKZJxfJRc9URWTbTusZS0cvyeBkj
         GZxpvRKKjSXnpiPcoJoEgrlxhGpCmPhV/yCGkj7rDRmJPc8O6r7yR6JNnflHRAWu/q8d
         mAcoeCe8qIH/P8b51S/8Ba6iNvcbvvH+vaGha2fdbY7BFTn0dhHNH8SUMPU3zD7PVyhC
         PLTxwoUEJZMZOVbHhdHCx3hJ319pmjmISZkIWXd/+W/yiqJGqnsK+2OglIGsb3HNc9p9
         UktA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784840061; x=1785444861; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v1XxKkxydP+gmPUoFLYvGTbtdjO5YMG4JDZhVlcmQ+E=;
        b=hfX5QgaNRP5gj0Dn8m2Ghb5gZ3BQc7tnsAqaGKTpgrT3CrN3HDEUo3ovvs6lB2KatI
         TKa8dq9rUeOT/K2EkHHtDkJHMlgTmu2KPuJxlGpmm2OgpwfI9n6DHd8YjvKaVXV2hXyo
         NVmXFQ7MID9m3dop0OU90u/LE6rlbaU+drQ5SUOAOFuec5DzXS24CniDC9B6eIL8mFmE
         7JoX6I151+FJOpVE4pqjCiQYt4XkOQTV03jYCR29n/hWdvpA4EljfpPPYh5yth2FMGp0
         673RWNNFNezyWL+Gp7+3gBqbNMBPcpjVlkhvmawubc5ho1/1CxPd/p2hzgXbl/sJcNmR
         hoxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784840061; x=1785444861;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v1XxKkxydP+gmPUoFLYvGTbtdjO5YMG4JDZhVlcmQ+E=;
        b=IeuV7ZG9JR2t/iJPL6a2Nk5efFpX7RniRoMiML76K+49TQpcfkEKVvJNIK+8AH1QLr
         3uh6xPYc3SfZLmtcO1FIKMgXkXSYGkdvGNBXqDtBzdY18BPvlmbPEGaQZOQuF0cNzWeI
         YEXFroxJCnn5AC1DV0uTcNzL4fmt5+vaJY0sykhQo6SQ6twcHIaVJk+2AiS0RAyS8jN0
         F9Gd4JH7LSq0hvc7Vuf4N+gTt3ivE4Fh9xV+KQwz3uLh3DyJ27ZH1cN0bj5or4/GwD5n
         +kKx+goPNvKQNaxvJ5Qjsfn4F9S6Eeq9RGv7ClY+6dIKu+Zzm8uW9W0qtFkt7CaghXdf
         VCNA==
X-Forwarded-Encrypted: i=1; AHgh+Rq6+iOLp9+jxNW7ui+K0InS9OROUJh1v9WJpfFau9neX/ZmtHQaJCmCrNyEIyUUO4F2C3g95NU5OavH@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy0b6oTiPbKmcm0cJpZaMmxmTfRkFElpXljkYCZVVOHdlOCEaN
	+w5dWklmpWJSv8+g0YPSIpkQByQpeOeRQjYc4E/Vy0dbs17jk1iTLEd2PSIOC9CU6SwUfy8D3sw
	c+D3l/FGV/qnUK9oHLElNfM8KXsLOMSo=
X-Gm-Gg: AR+sD11OK1W+GZAbST4EITSbK8Cp+Yjv6CjV0ssGffDMxJeQFAyuzb0Y5ZxbcV5aAOc
	EWa5NSQ1fb/xijHG2jnrgqOokKH20iwekWf42AawfSRBQLPQrsTrKkHsmvg1iik6UCLLap1JKmL
	IdJZwcM8vps9TQqasjDAfwH2BbLd1HHttQOgp40RWB/9FFfw4qJtXm6xtbdoK0J7eQslcAYdovI
	EVIZaFqd86OVVb3iiuAhkmgXba4ZqauBBpNM67el6p5SxfmIl7ZlLFN/5KQ1Zqs8vx/9+2YKl9i
	BwUjQ5yOV/zpSqrevSPo+qcDNFoKTrdlqvGqvDsUENWVONzyIFZJdje0wS3tAljT+dW0tPQoTw2
	c2WE6gVqXyKW+PqfjWtUSU+xJP/UOqtYTpxzLi3Ws2OAKgSpqvQGMzq0ZlpiBWL+Qcm0Es8RGK/
	zj
X-Received: by 2002:a05:6214:2427:b0:907:be64:6b76 with SMTP id
 6a1803df08f44-907cd03ec7fmr45943556d6.12.1784840061161; Thu, 23 Jul 2026
 13:54:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu0Qi4c8NprbnviCv5whzqGuzriVT6qShQ91=Kx4=T3Zg@mail.gmail.com>
 <CAHk-=wivHxCcsL=MRRjgVptm1KD=gf7qYnCRfnCWj3YnFUU1_Q@mail.gmail.com>
In-Reply-To: <CAHk-=wivHxCcsL=MRRjgVptm1KD=gf7qYnCRfnCWj3YnFUU1_Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Jul 2026 15:54:08 -0500
X-Gm-Features: AUfX_mwvdITxUQT9BxcbWY4QtbKjQIBCXWzOCmTPJsFAKSFhOgfmkXvN2QXWYss
Message-ID: <CAH2r5muPcE35EKy_+crKHJ_hJoFGf+XKfO=-5-zvstFawxZSMw@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry about the cut-n-paste error (leaving out the diffstat) - attached bel=
ow:

 MAINTAINERS               |  4 ++--
 fs/smb/client/cifsfs.c    |  1 +
 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/file.c      | 69
+++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/smb/client/inode.c     |  6 ++++++
 fs/smb/client/misc.c      | 72
+++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/smb/client/readdir.c   |  9 ++++++--
 fs/smb/client/smb2file.c  | 21 +++++++++++++++++++
 fs/smb/client/smb2inode.c | 23 +++++++++++++++++---
 9 files changed, 185 insertions(+), 21 deletions(-)

On Thu, Jul 23, 2026 at 3:52=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, 23 Jul 2026 at 13:44, Steve French <smfrench@gmail.com> wrote:
> >
> >   git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc4-smb3-client-fi=
xes
>
> This pull request was missing a diffstat. I've pulled it, but I really
> want to see that draft of what I'm pulling before I do...
>
>           Linus



--=20
Thanks,

Steve
