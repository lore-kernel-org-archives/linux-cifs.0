Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035177D098
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 04:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762575066; cv=none; b=S/OtOATL/nyh/qp6a/Uf1xtl0F+rfxQYh3GwgcqFLr7OS4hDfMyD2n8bp+U+CZM9fdLqqhtf+7xR5MORIx/c6zrDxaHoZ8FdizO1xbVHy5qnUPY3f/Qw054YbR8y2N/SHiGPCXQVshLRgaRFNtVtgPUB5RKdKy9ygKJz1Soy89s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762575066; c=relaxed/simple;
	bh=GLDAIkw0B/Jgj1pC/JQvdBxiQTL/crtcSc+Xnw91Tkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f81ItDlRiqxEzp32bw7V800DYuIELM11oGdAOu4zC7gLcR7ojKVg49lw0aSnYqGH0BUTFRCc9RMOluq6tYJEteF67MXvy7nQcl9wdfpjXCBlv5Gb4XnpLnP2xGWsUau/Tc+okWDHjGsSdp8HFA51wEo44azkM2eMxHMeNfaczQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NwhXct9/; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwhXct9/"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so2104211a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 07 Nov 2025 20:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762575059; x=1763179859; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P++gdfwUiF7yMcQqAmBtJY8SzbdW8C3xUIGjzW3pdRw=;
        b=NwhXct9/LxjU4KyHI3RrGiXNktiaA8FHFpDWBLgwVw4LrPKejsrlMUU3UFNz8AIo10
         YGWl4OQRvnnkn7xuTQqlhPMgznp12/9M1qxle6kYIHFy9b0OJDkSLaEb5GibGijpJ8yF
         G4SYMMOJ3d1oWQC9xmubCSw7kEmQUPj3BbH4OqdM4q+RWvbmYIk5YtZet1kVnMxFl652
         iPkYpar5l3s/hCZxhQw8dWrqJetB9viZYLIIcT0CDcJZip8UGiQuUT+1YesJBdG6Ayp2
         JgqsR+ctmw41VdVQE7EI7tZXk+AakDgDVV1VQ9O6/NDm81PjnvEzWukcdSKVMHRID8lk
         1HNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762575059; x=1763179859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P++gdfwUiF7yMcQqAmBtJY8SzbdW8C3xUIGjzW3pdRw=;
        b=tmZHqppf47xzREuRZfwc+wo0GUgQub0mnYmasBi1RPrns18uBqW3Q17p0dpeEXLHVE
         uki4e3h2LKdwaLquIvz9+V7/ldVQJeeliCEyQv2Zx4zygsJ35dz5tsW5+N3+dsQ+EonA
         MbDfftSyDw/6IrNU/vuQafPoy5zDKHwQOzKkA7efwgZJUQW89o68fuOWmO+sCWQtwOwF
         +keIY2WVOAw7ZqWawPTTOtcTBnRovWvegOLVdJ723Sb4Z6xhYAcRGsnV3Jw5RxMzWf6a
         NjBhXT/bgznrhg3NYFW9qTJXGEdt9NdQvups7og3EGG08QVoXyjdQgI/CBhFVsyjs4Yv
         fsdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+YXRdsQ5SBbXEmJKS9aZhO44b5y+jPPiHg9VD4k8+9b3j2/aRM5doje5W2CTa6NusGeP8MB6oEMGI@vger.kernel.org
X-Gm-Message-State: AOJu0YzvN5ItECRQgmv+uSWWWylOjbU3ohZtg6s3C2v0bxkDUBlrDBO2
	Z9TXWyNJVPwPBgyc8MSjLLTjsOvgEdAXq2JdKV4caRX2eT3Q8Z1wSramR7lnSmYXz5JVVlUt1Bq
	ZllqYvOeDEQC30QBY3ORbhQm4g3CFxsGx12VC
X-Gm-Gg: ASbGncuhjQvfDfzRxFwo8BZ04YOZOLeWxgiwddg/IxPfVz3d5nzEpqHFVue7zL2xT6W
	vh1pZvv813wt9BJoT03q0j6nXs6krss6ZtIKL7wHw5ofTfmD0MngxN9bK3Cu4/4N4cuppijUtDl
	jiwQQ79KlHFSpgNeBY/8NNaxdEuZqHu1OXrvCvkpFz6+iL8HGcO78aFKJwJ1HfqtuF1cGaeULJK
	p2aVGrKa2OTws+N1cFcxgQg1RkRft5ZH+08d3dKmceal3GpVHKNTFG1QsQ=
X-Google-Smtp-Source: AGHT+IFQHN513SKWUZDhIZq5fNSOZPmipMMdZRlwUPhW5CQq9Q9hTaVzkxgS5FQwuag/NF+mudr0LdobGydgL8Ih3QM=
X-Received: by 2002:a17:907:1c19:b0:b70:b7c2:abe9 with SMTP id
 a640c23a62f3a-b72e052d690mr119296066b.38.1762575059104; Fri, 07 Nov 2025
 20:10:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107215953.4190096-1-henrique.carvalho@suse.com> <CAH2r5mt979CqEHa8wTEV3U+qCVnBqB2N7fCYynQqE2=214Cy7A@mail.gmail.com>
In-Reply-To: <CAH2r5mt979CqEHa8wTEV3U+qCVnBqB2N7fCYynQqE2=214Cy7A@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 8 Nov 2025 09:40:47 +0530
X-Gm-Features: AWmQ_bmm87yZ1JC-6qDmmsE-lzJUB0GuY4i814AOCU0G2J-mHK6ANG2W8Yero38
Message-ID: <CANT5p=rqcPr86R4Dz3jXaHY8w2M9JxSqUcHMg1fjegNp8Sza+w@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix cifs_pick_channel when channel needs reconnect
To: Steve French <smfrench@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org, sprasad@microsoft.com, 
	pc@manguebit.org, ronniesahlberg@gmail.com, tom@talpey.com, 
	bharathsm@microsoft.com, ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 8, 2025 at 4:46=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> merged into cifs-2.6.git for-next pending additional review and testing
>
> On Fri, Nov 7, 2025 at 4:03=E2=80=AFPM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > cifs_pick_channel iterates candidate channels using cur. The
> > reconnect-state test mistakenly used a different variable.
> >
> > This checked the wrong slot and would cause us to skip a healthy channe=
l
> > and to dispatch on one that needs reconnect, occasionally failing
> > operations when a channel was down.
> >
> > Fix by replacing for the correct variable.
> >
> > Fixes: fc43a8ac396d ("cifs: cifs_pick_channel should try selecting acti=
ve channels")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> >  fs/smb/client/transport.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> > index 051cd9dbba13..915cedde5d66 100644
> > --- a/fs/smb/client/transport.c
> > +++ b/fs/smb/client/transport.c
> > @@ -830,7 +830,7 @@ struct TCP_Server_Info *cifs_pick_channel(struct ci=
fs_ses *ses)
> >                 if (!server || server->terminate)
> >                         continue;
> >
> > -               if (CIFS_CHAN_NEEDS_RECONNECT(ses, i))
> > +               if (CIFS_CHAN_NEEDS_RECONNECT(ses, cur))
> >                         continue;
> >
> >                 /*
> > --
> > 2.50.1
> >
> >
>
>
> --
> Thanks,
>
> Steve
>

Good spot. I think reordering of patches may have caused this to regress.
Changes look good to me. Please add my RB and CC stable.

--=20
Regards,
Shyam
