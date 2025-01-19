Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF3CC2ED
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737302499; cv=none; b=Z/9fpt1EuUNFPoOMyDX0MkC5nQx6VbrDRudCyBUPqCYjcQCWMNr+1E9lm21ShL8ghkI7RoZlYqIavqmtt/GSOp+5ZaeXRhC6tcajIFdVaZ+wwe1iaGN/H9MyMSpWD00ciRF9CoK9YDZSX0USrBggmaHbzK//aNqZvgJAvAh51WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737302499; c=relaxed/simple;
	bh=nHS31sVAdNikwhHDpm5HtB35PDDpTphmvulM4mkfK08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ze3YdlslCMgtk+QGtgj1WFsshB3kEHI7LQAtQ9PsuIsa43/ZpoC4uWRX6g4twMe2ndH2DubKURhIJvwkTKrBIht2290EI2kKpjA6UxEOL4hqtFprAuBtckUfpVQnXj6iri4Xu+dzUJCijx5NK3dJ+Mc2AyRoSxINxBdqCDsfVwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SUArz9lt; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUArz9lt"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-304d760f0dfso31821051fa.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 08:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737302495; x=1737907295; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dkOdf8QKm6h+dKmYCM/taf/ty4x6osd8tpvs9ikAuVY=;
        b=SUArz9lt84Tv1CQndmeXy2+5OeaEDS4nK57Navk2OyNlNBg4fIS9cy83O0fXtci4LX
         wqUnjvC0Ua0UjHeOocf8g9uqj46W+nJ6TuTEAxpx38ICJxxHykKhIWeD5iLXDeNVR3l/
         du2qdVeP/eZYvd1drkLwVx59/Bfjm4m9nXh5qOo66WfVqc8567v+4B5kS69DUEOoFa7K
         2ZIHOQsQ2grFmarXIcdgn/vNPTCtUMMyz/ji8jbehyQLAUQyUgKpOtsDDtSjbA639/yG
         flNUSogx0GRjVXBp7RO3mESCsBlQ4uyiHHRfR4XllT0rGZAmmUOlNGmqRp7Rx3JufSm0
         mPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737302495; x=1737907295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dkOdf8QKm6h+dKmYCM/taf/ty4x6osd8tpvs9ikAuVY=;
        b=Jf2wd/x16RG60UCjiILdHwKpqBG+eTiDdOQLpgWQrwvia3Odl34Aj0FLOtR7ngTGY9
         iuB9bSN46XBTGKmsVRgnA+Ge7rKDiBZz/4A4T5S+n8ixI5mzH0GZg3/6eP9BUbjCeQkn
         NqeEk1w0XK9TgVSEKaIlr/AM70IJazhuFs1w1HfK1KHQFh1C+41Zhbh4qrfQwZM0R3x6
         wrs8INwaTMbSc9SJy2SFPeN444KPolt5XjcV7fKQlEXIOgr5UImcsuTBwNVh7BECSj1O
         +ZIe7HeB4EYNY/knOLPe13/2qAp0lOU68FWEtnzSbUPOc1VxSCFjdWmd0EOPW+6dCHcr
         k7vA==
X-Forwarded-Encrypted: i=1; AJvYcCWSLMSFDh1lyGD/tYG8sZ6rymK8AB381j2ribiwCYDSLlzMZZu3bEdtNJykSEjsNNtxs5X5h5m1KF7T@vger.kernel.org
X-Gm-Message-State: AOJu0YwE4ob0Few8FiqYKMpfwhnQlfwDKASCS2MDZp/ktuTfmhvvEw+K
	bWWtsZjDBrzNNEEoZKLK0SaI96FRUbOuNqH7DQTGY1MFhOuH8CuwYR8vZnexwIJTZEppSdiaTaS
	6+xG3MKvH6qiLxqcrnFefG5ARGZQ=
X-Gm-Gg: ASbGnct2VVIev7MSjIf+A8lqq2SNmy8zoL086eTNH7GunhDZPp0YyPiszXFjvEcZtsT
	tn++GCTMmmwD/l5I2Igcy0Lu5jc/B6fuTzyseyzqOjjZ2mUQ6TY89HbNi2SvZ9BDBL6GHnbSWlb
	Yaeb6tN/A=
X-Google-Smtp-Source: AGHT+IGPMVckIyOxBCuBkCtxf5ncys+xhnEulWTqsx+FHAn7vCXKng7qN7V0tYdVEo5nw3668WgIMC5M3eF4bw4c+B8=
X-Received: by 2002:a05:6512:3b07:b0:542:2972:4dee with SMTP id
 2adb3069b0e04-5439c280a4cmr2431042e87.46.1737302495094; Sun, 19 Jan 2025
 08:01:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250118200330.21020-1-devosruben6@gmail.com> <CAH2r5mvMRgiK1jFr3CKJPp1qN2FTBT6NH_M2jRWxjR7p+O5A-w@mail.gmail.com>
 <CAH2r5mvU738RRMBpp9vZPXeG4k9ohJB6OJ6U5BoW5Md+pMMUyw@mail.gmail.com> <13701770.uLZWGnKmhe@localhost.localdomain>
In-Reply-To: <13701770.uLZWGnKmhe@localhost.localdomain>
From: Steve French <smfrench@gmail.com>
Date: Sun, 19 Jan 2025 10:01:21 -0600
X-Gm-Features: AbW1kvZ5ZXc-OyzRqx71sb9jecHVC02nKOmvTBgDcVqlBvoWQ51tQMupOzPcRxI
Message-ID: <CAH2r5mt-dAbEPs2n6wyWVufKj07TLtzkcGZR1QB1h+YOdbMMoA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix order of arguments of tracepoints
To: Ruben Devos <devosruben6@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 19, 2025 at 5:11=E2=80=AFAM Ruben Devos <devosruben6@gmail.com>=
 wrote:
>
> On zondag 19 januari 2025 at 08:16:29  Steve French wrote:
> > Here is a minor patch to add the missing tracepoint (see attached).
> > Let me know if any thoughts, or other obviousb missing tracepoints
> Hi Steve,
>
> Thank you for your review.
> I noticed the missing trace_smb3_query_wsl_ea_compound_enter too but I
> was not sure if it was left out for a reason.
> I'm not aware of other missing tracepoints.
>
> I saw that both your patch and my patch are in your for-next tree now.
> Does this mean everything is OK and there is no need for a v2?

Yes, it is in for-next. I didn't see any obvious problems, but will welcome
any additional testing and review.since a lot of patches to go through for
the upcoming merge window

--=20
Thanks,

Steve
