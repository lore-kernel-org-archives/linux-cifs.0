Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ACA2DF6F4
	for <linux-cifs@vger.kernel.org>; Thu, 28 Aug 2025 09:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373307; cv=none; b=Toi7sH1Li+9/2MiSkf0rOTD8s8rt4V/B/tYHpcLA0Vaz4gMiRbyLuB5UENgj5361fsh7qTPIvdaYvJ2gpNWM+n5W1lKauwsSF1rg3nx47hhTOCL9JTtdThflalfKgXCJU1ixg51YzLxVWTRXhyWltDGsa+fhuj7/levMzZgRi28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373307; c=relaxed/simple;
	bh=pPvO4WKxY+YkTBd7S9kKTHxjOD5kaKz5x8j5IXwLWpQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GdGXb+WBTa1pUsM6p9qK+ELCQwhK2Q9aKSPwMqpfGRQUyo/uePteJ5VbcjGdvtALRW2axazzVMe1btIxi/35u3nPDyN3leMJZKE9dtLKpRm+RXPUb/PTjAU2LStc5nCbf7u59fZgej5f46CWCWRzkES7CDNM1niD6eq5SM6opfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=csjcm2VD; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csjcm2VD"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afe775db944so270549266b.1
        for <linux-cifs@vger.kernel.org>; Thu, 28 Aug 2025 02:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756373304; x=1756978104; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nkYfqc9Gdk4sCjLKh/emI8wQ0YdI4FUPUZ3IZ8vy3Mg=;
        b=csjcm2VDP94kvAnKJy97VASBqa3iX+UFBNXGgVVrGAA2JEAN1TX2JzVNFsSMR2K2sN
         BAFMT4bjn5h5vh7SoxVstS8897QkhXux+PZBJFIFpnvov8WiW6C68PTCPpGYYyPGZ+yI
         Tsr/u+YAcWF3KrgiecGFA5YCFkSkn1KVcT8NfbL4my9Rui/JdhulqThgb70f5JJG6QjD
         rU7r+jo5T5hbQ9g/E8Im0KHBOCVZ1xvan653cCGhJaHiFcYzr/rajU94fTsXGHbAB10E
         C5wTFaLg89PTI49Uct/t2/gjWERPqUE+NrcX46o5EAEJ2m9MgrnoZ88yl85+cEJguRxx
         ci/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756373304; x=1756978104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nkYfqc9Gdk4sCjLKh/emI8wQ0YdI4FUPUZ3IZ8vy3Mg=;
        b=nA806D61xkHc4zqwh7Q99upxOsXQaU+XTx/rul6Ti21KE+q/5hUwRXMMbT1P8z/B/F
         xRJthhdRVE0GQ5jV++P31FJYux/b72h7zlusZDz0MIWFsFOiXBerEqksp3oyJzJbgMhM
         4mJ9ajjHh366kNnrJyiPynutevOY39qK/wXewCVy+LZTn7rxKddvAF3anTh0B3yRankO
         vGKhkAxcVNivTRYY4quNlW/oQakZPEHuh3ce8DkDasdZglLm+13JhqgtjE3vwA8PUMid
         WhuO0Jr4Djd2ULva8wV+ivbtSwZdyjL4H6gQCvqi0YUXJYgNbFfPatFxuyKyh9YylQlR
         b9Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXHgJLybSMX+YOZ9jyriT6/bbqrcnadtHcWCVlmCltd5cR/xgFlkyPsvigd1wnvs6qn0Mku1Fl8PhtF@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf8MCvO+EQqLZqbfhfHuFb0uPnszRK5Q8rywmk/KwSqcmnPmUz
	koNbhhFzbI53mSWQGxtuyJC+l4IxRxlatQYzTCKN0dtsfb3sP8bnXkITAYQm6JFkjkGaydWUq6Q
	rZ4P/ZyoPdCLCVFklCqSP9ZJbuQirj8o=
X-Gm-Gg: ASbGncu4nf08hXsG24U1abjC5iWwCNYW7xSn+uo/1RX6TG4doVfjL2RVUNJdgMFBiWF
	nHqAFhuSsjxi44HlfxB0sfz7os0oGlM8Nvyw7WJTmWz49grpw8z53nADKQcCFoFbPoik6kNigao
	0i+izmC1OBuLaG5D/MV7XMlkqMgcId4WuimPZOdL4td9M7UfXrU4pEKIqQ1mZkxANN1Ww/duz4f
	fwTDTkG
X-Google-Smtp-Source: AGHT+IHNj+6vOB3tGnytEJ+6B1U1Vmom/dThzz9jVTlppLyFMLWmUERV8WjmD6K4F0H3MyvBCBC8y6bdrN8AxiJKkoI=
X-Received: by 2002:a17:906:794f:b0:afe:6de1:1a6c with SMTP id
 a640c23a62f3a-afec348ac8amr493628866b.19.1756373304107; Thu, 28 Aug 2025
 02:28:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muHpZOTU+CHrmG1OnpvXNmfia8CxAs8v_uEPOZrHFr-1w@mail.gmail.com>
 <1f5a4297-8086-4914-af44-1cf76393c8c7@samba.org> <CAFTVevUWWrPgs=Kb6E3WtSiyTmWtoD8QYiONJ1hYkS37ri=NrA@mail.gmail.com>
In-Reply-To: <CAFTVevUWWrPgs=Kb6E3WtSiyTmWtoD8QYiONJ1hYkS37ri=NrA@mail.gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Thu, 28 Aug 2025 14:58:12 +0530
X-Gm-Features: Ac12FXz7HQp2J7Rdu-bR0Q2rs8OIlRR3i-M7Putk6wLVb6ECJ4Bh3LGIxH3i2Ns
Message-ID: <CAFTVevVn8sZr6uyBpA9uF80reRNty2izFCLWU_t-6gyAx-K3gQ@mail.gmail.com>
Subject: Re: smbdirect patches for 6.18
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

A concerning log I saw on the ksmbd server side:

[ 5437.417703] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for
>10000us 4 times, consider switching to WQ_UNBOUND
....
[ 5446.096614] workqueue: handle_ksmbd_work [ksmbd] hogged CPU for
>10000us 7 times, consider switching to WQ_UNBOUND

I am not sure if I will have the time to help debug these issues.

Thanks
Meetakshi

On Thu, Aug 28, 2025 at 2:53=E2=80=AFPM Meetakshi Setiya
<meetakshisetiyaoss@gmail.com> wrote:
>
> Hi Metze, Steve
>
> I ran some xfstests after building Steve's current for-next-next, with
> all 144 smbdirect client and server patches.
> All tests pass save generic/258 (negative timestamps test).
>
> generic/258 0s ... [failed, exit status 1]- output mismatch (see
> /home/met/xfstests/results//smb3/generic/258.out.bad)
>     --- tests/generic/258.out   2025-05-19 08:53:10.883041010 +0000
>     +++ /home/met/xfstests/results//smb3/generic/258.out.bad
> 2025-08-28 08:45:31.148495408 +0000
>     @@ -3,3 +3,6 @@
>      Testing for negative seconds since epoch
>      Remounting to flush cache
>      Testing for negative seconds since epoch
>     +Timestamp wrapped: 1756370731
>     +Timestamp wrapped
>     +(see /home/met/xfstests/results//smb3/generic/258.full for details)
>     ...
>     (Run 'diff -u /home/met/xfstests/tests/generic/258.out
> /home/met/xfstests/results//smb3/generic/258.out.bad'  to see the
> entire diff)
>
> This test fails against ksmbd even without RDMA. It seems like a
> server problem because the same test passes against the Azure SMB
> Server.
>
> I remember reporting this failure to Steve on 13th August too. So, it
> might have been introduced before this week's changes.
>
> Thanks
> Meetakshi
>
> On Thu, Aug 28, 2025 at 12:16=E2=80=AFPM Stefan Metzmacher <metze@samba.o=
rg> wrote:
> >
> > Hi Steve,
> >
> > > I have updated the cifs-2.6.git for-next-next branch with the 144
> > > smbdirect client and server changesets (on top of for-next which is
> > > 6.17-rc2 plus a few cifs.ko patches unrelated to RDMA/smbdirect)
> > >
> > > https://git.samba.org/?p=3Dsfrench/cifs-2.6.git;a=3Dshortlog;h=3Drefs=
/heads/for-next-next
> >
> > Thanks!
> >
> > > Metze,
> > > It also looks like there are at least two "Fixes" that qualify to be
> > > merged earlier.
> > > Do you want me to merge these two into for-next (so we can send it fo=
r
> > > rc4 or rc5?)
> > >
> > > 8170223a650e smb: server: fix IRD/ORD negotiation with the client
> > > 5dd0894d057a smb: client: fix sending the iwrap custom IRD/ORD
> > > negotiation messages
> >
> > Yes, they are intended for 6,17, but I'm waiting to hear from Tom if my=
 explanations are ok for him.
> > I also didn't get a response from the rdma people on the u8 limit.
> >
> > metze
> >
