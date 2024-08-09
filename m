Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD3CA64;
	Fri,  9 Aug 2024 15:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723218160; cv=none; b=OBjVfwW9BUqPh6kKfRFUbtM8NoMuTkqHOUb/8I/yzds63owgGUcmjXgucjPEAb5Kx4f4ideedLeB9yRVFFI4Qaa8l4CIECgFeTNxLduDd3l+RuCa4ED/KXwyLxqPOC1/S0g/cP40nZ7STWwuAQ29Q0eSqUnP5cedWrrOscmLr2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723218160; c=relaxed/simple;
	bh=47MegqXO0E7Vr6IBuWT0dp3jago2unJ5qdItWmHiSQk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZrGdwADp/rs7jOVq8HoE2Q2SRiRadRKvHlUwVtlbYTi+S9linj3ju3kxpUoFBcGkqiwi4TGdT+UjhQ8PFWRqdiqsdi4ICqFXX5OAFNTzSzXHmfsRxmiBSYiksSqTMkP8ulrYsSMMogLBHWx+62/1I46a4zbtMxNk7ywXl3y6dj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YB+pWfKT; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YB+pWfKT"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f040733086so23019991fa.1;
        Fri, 09 Aug 2024 08:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723218157; x=1723822957; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSX5z71Ic2mcCJIyuQl3/ERa/3iXO0QhvWRXQN2FvGY=;
        b=YB+pWfKTaVrjQ+XtC+pi0u0/cebgp73E5yYN39GSMZKM2pea4O2glSrmQl2ulhVpSW
         UWzLdHMJNRFnDHWMCXGKi47xtxH1KhrqfajIdvT7EeBJ5DJ1Wi0481DcDCtM+YEAoqbT
         PXlbY4JEz9vCGmE67DYpT4c7tLKm5VAzzNbcXXL1wbakUAoZgUtzUXldY4EFz86i4uHj
         6JvPaqWX4WrEDSKPtjGepe+1EdJiCUVup3zQ1evY39pi57gdVAeXoYdHryH0tdBV644v
         ezPqUhoJ1NpDc7yLHys/bKrlHDAgmEFqdlEepn293wIFtgCzr4Ob5FNHZuFeWHka8JWm
         9sTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723218157; x=1723822957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSX5z71Ic2mcCJIyuQl3/ERa/3iXO0QhvWRXQN2FvGY=;
        b=NERCFQ9qegSK2QOJjtIYw+95jxyQkM9YJzAkQGZr12uf8GL+XKyjWVm2tqnxuMzy/q
         28+npuRQpKYNv670laobE8/gNVJRAtvssPNlSLkCbd5ulZJ4Xm6okF5ypPJRYS56g23n
         O4dI2uoJgKdhcN/MrpGQv2aC67VMo6Pm0rGvD1WycSG1GgftszT06qlVvparG5PPig1v
         KZZ+q2PcHiDcNSciSospAiXS//EzwJgjMH85fK4QNaMMr/cFSctxHIXjb0XIhsZDTDhc
         0pEQ9aENgq1MVKfdKM6+ewBb31tWKkH2JJkkmFowub85G83StxEInlcy3ANvZl3eHYER
         JcrA==
X-Forwarded-Encrypted: i=1; AJvYcCXvJI2m8H2r5k2LaYUT3OIdfTC52HQwlzPEOHpVm+bayXMpuYjh2c8htx0In7uPq/2ncoSVZLRMIR99IIEtRxJdGokl9bLQ394nL9HcshPsSic8+Mmyg60GBVUlpLBzzIw/KRlkNnRt4HGDxiD30tbF1EjjIImTVKY8aGQup3vfupd46gvWk74v3Q==
X-Gm-Message-State: AOJu0YxL19m3urmsbGexQd1fNS1SV2aUc7ifyX36T+h8sOxbwCfgTeBN
	SP4wSqTnPxATz4UKpNNR6GvGcP4r8C+NdT+lXAqXcoMkWyxBqUOwowHdMC3gpfDv7+G6Hr+cxZB
	eE0cb/5goSh6QSwQ+jnmsT0hZxBw=
X-Google-Smtp-Source: AGHT+IFf3tUCbIQMHNGwguaQ9im7C6T8tOEzS58zEtUlzxRikiSdKkWG25I/i2K77g4pYlFNNJcS+X4cmA9+McJ8CNw=
X-Received: by 2002:a05:6512:3d8a:b0:52e:f2a9:b21a with SMTP id
 2adb3069b0e04-530ee97a165mr1351764e87.19.1723218156526; Fri, 09 Aug 2024
 08:42:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240808122331.342473-1-suhui@nfschina.com> <893f2ebb-2979-4e34-bdab-a7cbb0c7e7b8@stanley.mountain>
 <a08c6b03-6d23-4711-a891-14b0250b90be@stanley.mountain>
In-Reply-To: <a08c6b03-6d23-4711-a891-14b0250b90be@stanley.mountain>
From: Steve French <smfrench@gmail.com>
Date: Fri, 9 Aug 2024 10:42:25 -0500
Message-ID: <CAH2r5msS8_Jc0hRXqY==OGiaoJKyjqkh7HT0esSKcEvsxht46Q@mail.gmail.com>
Subject: Re: [PATCH] smb/client: avoid possible NULL dereference in cifs_free_subrequest()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Su Hui <suhui@nfschina.com>, David Howells <dhowells@redhat.com>, sfrench@samba.org, 
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, nathan@kernel.org, 
	ndesaulniers@google.com, morbo@google.com, justinstitt@google.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 10:11=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> On Fri, Aug 09, 2024 at 06:00:26PM +0300, Dan Carpenter wrote:
> > On Thu, Aug 08, 2024 at 08:23:32PM +0800, Su Hui wrote:
> > > Clang static checker (scan-build) warning:
> > >     cifsglob.h:line 890, column 3
> > >     Access to field 'ops' results in a dereference of a null pointer.
> > >
> > > Commit 519be989717c ("cifs: Add a tracepoint to track credits involve=
d in
> > > R/W requests") adds a check for 'rdata->server', and let clang throw =
this
> > > warning about NULL dereference.
> > >
> > > When 'rdata->credits.value !=3D 0 && rdata->server =3D=3D NULL' happe=
ns,
> > > add_credits_and_wake_if() will call rdata->server->ops->add_credits()=
.
> > > This will cause NULL dereference problem. Add a check for 'rdata->ser=
ver'
> > > to avoid NULL dereference.
> > >
> > > Signed-off-by: Su Hui <suhui@nfschina.com>
> >
> > Needs a Fixes tag.
> >
> > Also when you add a Fixes tag, then get_maintainer will add the David H=
owells
> > automatically.  I've added him manually.
> >
>
> Actually, David should have been CC'd but the fixes tag wouldn't have poi=
nted
> to his patch.
>
> This is an inconsistent NULL checking warning.  It's not clear to me if t=
he NULL
> checks should be removed or more added.  If David were trying to fix a NU=
LL
> pointer dereference and accidentally left one unchecked dereference out t=
hen the
> Fixes tag would point to his patch.  Since David was doing something unre=
lated

Looks like (if this is even possible for server to to be null) then I
will need to change
the fixes to commit 69c3c023af25. I will update the tag in the current
patch in for-next

Author: David Howells <dhowells@redhat.com>
Date:   Fri Oct 6 18:16:15 2023 +0100

    cifs: Implement netfslib hooks

    Provide implementation of the netfslib hooks that will be used by netfs=
lib
    to ask cifs to set up and perform operations.
--=20
Thanks,

Steve
