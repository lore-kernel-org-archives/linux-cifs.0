Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D8720F079
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222892; cv=none; b=M3pvZktmuqOVgSMM6YpKI1TeIsAYeITigTGOtG5ZQISNR5B0g97u60KyAwnFBUOyGwGCCJKpLtpe6Rs0rxfbumJUe9PsCaehpbRavBMCso9BlSJLupxDo5uYmpJwKrZY9VnrGyryrzNgku6Lob94NGev0kDGqgGgIwJhf8FLJcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222892; c=relaxed/simple;
	bh=LI+RheTKnwEhgx1ERKxLDSfjw46Jylu6IqVZCg1jlTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ni2xXx9X6qydQmETWpsVvbmRZvY7ArndZGbLCNdWkafJ8NeUZeKu9LKX48KaTrsOeT/ayl5fRj+aryR0OwO8tVySba91eidbmK2ddzFD4VJy/8gLJmIlVZd5sGqG+rm9sifbOgj9/n3iH8kEj+vtOFzqcTNvn9gJ57w0/AyENm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VJpfq8FP; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJpfq8FP"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-30effbfaf4aso24095591fa.3
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 14:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746222889; x=1746827689; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sX4/tDY04TpZeTnLoZE5jyvYRYxLhosyYg3FNKV8rCY=;
        b=VJpfq8FP7nz2G7wRUVS3kwEk+UBJlc6aQyzWitVU3vNjXfRgcDVzEyfBwRyjg0Hyjk
         cAvxtFatw+ODT47YaBDSg7WZpl4gyEJRm+x045X4RmTcoNKTrs1t24dTnxzp5GBG88Lp
         QxVNxuAViHTLfiBNvp7y3jLP/0jel6SNh+bJDw0k41qtmGpZhcsVe7UKwADD7vSeAweZ
         qUV9Hq9ck8FVs5opYUdculgTofHJ3/a/W/B6e1WF18EChNe0ll2yMqQtZySDi5c5sWwY
         Mv+Wm98BajzvqVI8ryqXkwUwBZKmnmwiKWUPUQgEcm/vr4iOAdE9S9SpVjddaNMRPneo
         HRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746222889; x=1746827689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sX4/tDY04TpZeTnLoZE5jyvYRYxLhosyYg3FNKV8rCY=;
        b=OCp8Go7b5KN108KYK1rJkWRWWoTI9JjbS4+X9emFYs/Swfi+Q8yEjoLORVg9Mkst5L
         diVjGZr1/DTwMckCtjKYhN8vCmXbyBb/YF7lks4LNasA91n5NlZ4tfbYjzywlEh5zaFQ
         9kk87XIuOjV3IC96it2TAFeXCH+q28O7ft5jfnBUUPtX1FL9f7A3hWd+m5eTJkIM53Ql
         e/uYsEUnOxghQgtV+bkHAhby3SgQKxQnkRmX5B0ynnOzhWnFN3EYDJsNKpKWMQSfXhKu
         k+C7a52p8m5g6Gzp6ak3XDLQQ1nUVsMHSziCgHnlH9tvVeTMaFdb19IeihGTuzjznxvP
         rJyw==
X-Forwarded-Encrypted: i=1; AJvYcCVrKyroaJcTIhUN7O6WAcNDWTo9tP1OiZPWDbiOoIP08xcJwcCzSBuhh654E3MUmlyP4XzIZ+QURT78@vger.kernel.org
X-Gm-Message-State: AOJu0YxCLXt/Ph9G70XQADfDzJZH8hwkX4354J8bg9fENZYHmpMNTUJS
	fLiTdaefqZNZTSunwbCp+Z0CNfy1X0pBZW4Zyuw2+F9VTntIejht0m8yiVmICMQaUbUk121ouDl
	jPGLrIExz1OQYu6N/35YqoBuxwII=
X-Gm-Gg: ASbGncsxGoNJTlPZJTQNCEPy5ve46X4m56hGb3qkcesay9R6E9ZEeHhEzl8FXAvoFTi
	Q2v/SxDJFe7lytrjBddM5naNgajPdB0pGZ01pK1uj+IwemnaRNU8soer30r6/bfi6LAFQvEmADz
	Nv49cBrn3vYFg9Pr9I6wjaxNgpv3HblYZb+AHQSiu7pb7s6AGjxpcIgwr9
X-Google-Smtp-Source: AGHT+IHbYHlUMwXlJJ6mG/KBv+RkYqBx3SFGszNCEE+3JHqIf/1/BXCTTuCS8VuvwPAJocA4Tay8yl81Hb/1DirzMuk=
X-Received: by 2002:a2e:a58d:0:b0:30d:69cd:ddcf with SMTP id
 38308e7fff4ca-320c165e38dmr13969381fa.0.1746222888497; Fri, 02 May 2025
 14:54:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502180136.192407-1-henrique.carvalho@suse.com>
 <CAH2r5msw0gCUH29up7D5p2eH5LLGtmwu9E5PJagUi3S2trPHrA@mail.gmail.com>
 <fh2ose2otti5opro6jmpoo6dr4uhc2nfdrlgo3e2ikim4y4gqq@7zxtxyyhphah>
 <aBUpD0LzzzPUbRjz@precision> <aBUyL2ypuI2PTvoy@precision>
In-Reply-To: <aBUyL2ypuI2PTvoy@precision>
From: Steve French <smfrench@gmail.com>
Date: Fri, 2 May 2025 16:54:37 -0500
X-Gm-Features: ATxdqUGfy7YNigY71XMDBm4ERyqDDD7mi2FkovdYUu7bLSYRrdK4JMVgnqONtX8
Message-ID: <CAH2r5mvVkuOm47vfYJJoue_yBXanXwRkmm0gZ4dC7haic9fPWQ@mail.gmail.com>
Subject: Re: [PATCH] smb: cached_dir.c: fix race in cfid release
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, paul@darkrain42.org, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patch does work around the hang/crash after generic/241 but a few
other tests failed unexpectedly (could be unrelated bugs) to windows
multichannel

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/12=
/builds/32

On Fri, May 2, 2025 at 4:01=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> On Fri, May 02, 2025 at 05:20:31PM -0300, Henrique Carvalho wrote:
> > On Fri, May 02, 2025 at 04:58:00PM -0300, Enzo Matsumiya wrote:
> > > On 05/02, Steve French wrote:
> > > > I fixed a minor checkpatch warning but also noticed this compile
> > > > warning - is there a missing lock call?
> > > >
> > > > cached_dir.c:429:20: warning: context imbalance in 'cfid_release' -
> > > > unexpected unlock
> > >
> > > The lock is taken (inside kref_put_lock) if count =3D=3D 0 (i.e. when=
 the
> > > release function is called) and must be released from within the
> > > release function (which is done here).
> > >
> > > However, sparse can't recognize this and also there doesn't seem to
> > > exist an annotation to indicate so.
> > >
> > > @Henrique do you think you could rework the patch to something like:
> > >
> > > cfid_release() {
> > >     list_del();
> > >     on_list =3D false;
> > >     num_entries--;
> > > }
> > >
> > > cfid_put() {
> > >     lock();
> > >     if (kref_put(..., cfid_release)) {
> > >             unlock();
> > >             dput();
> > >             SMB2_close();
> > >             free_cached_dir();
> > >             return;
> > >     }
> > >     unlock();
> > > }
> > >
> >
> > @Enzo, good idea. I will rework the patch.
> >
>
> Actually, this change would prevent me from calling cfid_put() with the
> lock held in cases where the kref does *not* reach 0 and the release
> function isn't supposed to run. While it could work, the code won't be
> as elegant.
>
> I=E2=80=99m open to suggestions if there's a way to preserve that behavio=
r
> while satisfying sparse.
>
> In the meantime, I'm reviewing similar discussions on other mailing
> lists to see if there are known solutions.
>
>
> Henrique



--=20
Thanks,

Steve
