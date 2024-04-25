Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3598014E2F8
	for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714067800; cv=none; b=Saz1dw5pDLCKvya4dy1WpjXigFogJuHTRFPuIhc9FmWikojzEAzzJDXlqlg2oVom+PdtcWjQjC5teUBk46ivX21TCr3gpqSaRRu4M/Fm+76d5JKkHXMsD/Moh/VgT5j+SCwepRbx6HTmpxlBEdN+A7SaDrAd+N2VR2HhdaQdWW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714067800; c=relaxed/simple;
	bh=2AwrGsfBMTtO0SlfhwmgIqm17CoIREtghG2yiMRGQZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HJ71Jl6Qfx43CV0C+Bskogz/bj942zBtKzK8eumbDNoAbwCbhsCjutUZjZZpfpHfZNym7bNeWc3GPW65hlyHBVEoZKFtaOrrOSWCC4gkptNAGv0e3CMBoYJFqmFnELt9n+uSLbVE4ZHVMvh95Ylay/L3DTog2iwsQtzQHXPse3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IO/XGMMU; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IO/XGMMU"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2deecd35088so10218351fa.2
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 10:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714067797; x=1714672597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2AwrGsfBMTtO0SlfhwmgIqm17CoIREtghG2yiMRGQZU=;
        b=IO/XGMMU8iHRdZ476wQPtvM2tV47l9Vt7eLFkmt5Vq1ZFfXNJHxZ/m+0SI0sAm4LDY
         vN5UmjvgdxhWcLYyytx4EagTAc7vOkfw3coJQx0J1USrPZ+2hx1S5lf/t3nOmktmaBRB
         vAWhFAGoRfbNZISDvSoPvsYi4W5YnGuqlQTZNmkJdN2BQUnP5WuJB8M2IZnSa+D9KXss
         SPa9+Qe+8xMm+SD2AgDNjAKhsvKJl3G/m0siWVVwKPctP1fls/SfbkJCs4cR8vHPBpLr
         KvS5hs16b5OEsVCgbzMQMAyDdYQyNjnxaz4B+GWzgprEbaJV0JoZr9mRtqWyc+92o9TD
         8iyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714067797; x=1714672597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2AwrGsfBMTtO0SlfhwmgIqm17CoIREtghG2yiMRGQZU=;
        b=ZSezdWNrzCFLFS8t5LVOnKbdNzQMyiHR+2fnIfA3IkMQkGEYD8/RMXMI6c/0Su/h78
         XtOlzHBKwSwsB2Psq6H2XDxU1+NBPZU4a4/jiFGF2PZZLPvLcMZdu7pp0PQccr5kt50A
         yX+LyOn+UawycODXEryyV+UDsGJtlaHO6HuCEtsKgDfWoWoFSAd7iwgWQLrqeC7nkdOD
         5F1eQe5oo8Q1iPHltxhvOe0OySo8KeBVJRqnfqX9/usG3ldajeZKH0hqqS2mf2dtyoxS
         LBIGcAwxNL778dl0plR2vW+aolP/bArdmYQbSsk/T9voXIKVpi4ln3CKkXDdtlj5t3r4
         N70w==
X-Gm-Message-State: AOJu0Yw1+HxhQtcKr+PvlD6+BtWSI/nKE7gD2Ylq2FSgOED2XFBBD/b9
	TPa5rCmdgOZFqLVnckb2lounj4y9mc/ErOc4m0cyJOtbH++pCjRRnYM73ueBtXrBhr02fo4OjmC
	zbtABMKNIumeRIvtdN5A5dRIAls6dYg==
X-Google-Smtp-Source: AGHT+IGyRghFw7Tq583VWDphaEXykBL85VL6DH2VHBb/th76Q0jslS381xIbqFYUgwwY33wu7RXrFwXRMTchqw0Ayec=
X-Received: by 2002:a2e:2c0c:0:b0:2db:175d:a253 with SMTP id
 s12-20020a2e2c0c000000b002db175da253mr53108ljs.47.1714067797001; Thu, 25 Apr
 2024 10:56:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtJuttkzHDQB=-U3o=bBnv5U9r2w+JG-mXg1TPBT1wFog@mail.gmail.com>
 <CANT5p=qE_6xA7qML6f5i+0i7ZpD43QcT6vKsWqm+wdpc8VyoRQ@mail.gmail.com> <CAH2r5msVPRhSEAte28KZpZa_6S7thwUS4L7gDEK_-1hiwESDhQ@mail.gmail.com>
In-Reply-To: <CAH2r5msVPRhSEAte28KZpZa_6S7thwUS4L7gDEK_-1hiwESDhQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 25 Apr 2024 23:26:25 +0530
Message-ID: <CANT5p=pOnx0c_H-E-kOpWxaWJGWGftsr16RrrE5_Q2_zezvy5Q@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix potential deadlock in cifs_sync_mid_result
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 11:23=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Minor update to patch (shrink slightly by using a goto)
>
>
> On Thu, Apr 25, 2024 at 12:44=E2=80=AFPM Shyam Prasad N <nspmangalore@gma=
il.com> wrote:
> >
> > On Wed, Apr 24, 2024 at 9:16=E2=80=AFAM Steve French <smfrench@gmail.co=
m> wrote:
> > >
> > > Coverity spotted that the cifs_sync_mid_result function could deadloc=
k
> > > since cifs_server_dbg graps the srv_lock while we are still holding
> > > the mid_lock
> > >
> > > "Thread deadlock (ORDER_REVERSAL) lock_order: Calling spin_lock acqui=
res
> > > lock TCP_Server_Info.srv_lock while holding lock TCP_Server_Info.mid_=
lock"
> > >
> > > Addresses-Coverity: 1590401 ("Thread deadlock (ORDER_REVERSAL)")
> > >
> > > See attached patch
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> > Looks good to me.
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Thanks,
>
> Steve

This one looks even better. Thanks.

--=20
Regards,
Shyam
