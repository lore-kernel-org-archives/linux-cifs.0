Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD164908A9
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784998744; cv=pass; b=WzjU8Juib86PfQRIMhgUJyI6hsY1WB2pYOnS4Z5I5OztR5GaVL5/Z96ZNmvBN5O/uUhtBYZNtrEgsXXIk4CwPhIpswlei7H92mJwy/Anr4wlOlSNv21dtMRb6Lb9Z1E48UD1Cou3UXduqLB5xruJTflEh0mVr27TEIjC4P+OS8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784998744; c=relaxed/simple;
	bh=wxsdSNLj9uNq17XeynGeEXG77PuCSE3AxYNOgfygTeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uC5sCexVNYDYS6wH3bAVZ0C7lOw2N5miQ3HoR9TOIRryYr48PnO+sQGL9PDWO/kOcge0h57Bd+OfSathbo6kty21OmEFvE/AsEYXNlXUaEyj+DjdadJNnop5rmnEIL1bY71ndvqDVmUALfWfEYRfJMamCrf0BoVslJ8DyxMPCXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MdYbZGRC; arc=pass smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MdYbZGRC"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e5c92c389so98378885a.3
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 09:59:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784998742; cv=none;
        d=google.com; s=arc-20260327;
        b=nHuYcovwyoICuypl9wpPzREX8+h9HFBoMl3iQtPFoqV6ulaptK0ZXLurF0S2Tc+Wrj
         ghRaXgBdEet0gi7j6T7kAgeqYFudPSFlgRNaSKv8x4u2ocUW442TcAKALw3ZHzQvTx3I
         aGcZvoApliifhqgVSmKrIXYfU8rqKfdLFjbg8PyVaWXKLuKJfmMYQDiHDk6lCEFicc10
         MsFpK4bPSfJXsmzOY3sk4BjlFcdGti7jd9GB+GJzd7c2zwoN5vffk9D6j27VVnBPJmFx
         T9JS/BPji4DjvOdOJD2hwYAlA0COKCEC5I49ZlU8b+vstCcVIb1Vm767kVkUkH9Njq/w
         y5pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hC+CxRQqKmkyBIafqt/yge3L3p2Zduxcv89Phke4qH0=;
        fh=12lw8uTIBkj60pUPF3yB9AiYrXBOuM+42N0+xhPzUWM=;
        b=ZpHoH2SGSoWNTqRDo1jPgyFTdnoL/LwygvHrZ7Q+kKEkxIeA43ZBXL+AOId8ykmdSN
         nDwn7jl792i0QHzkmUiZ5xzqsH8hlZWyA9q+r9RHz5isRfB0HxnYCgU6UbuYPC29arjC
         rhotab121Gb+FfKfz9MG3DgrxzNkCtqMtEmlBrcJOULF8poSCnmJos/omv8QIF0Z6hF/
         RBnlZSG+fRjuVQGghYCIK1vmxc5RV8O7Mn2E2vjSkzu+zTU86azI580o30RlZl9Qp6ps
         9LtE34ni78BOy+Y4hCc2cF1t3R41dRuH74i8LgEpVBbXxEGkWWhglHn8RrSA0kxqTyPP
         NyaQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784998742; x=1785603542; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hC+CxRQqKmkyBIafqt/yge3L3p2Zduxcv89Phke4qH0=;
        b=MdYbZGRCKIexZSiz6K0CCIE4bMQWt1BZlbHW8WvE1bHz0anMRz40YqmEmO2reHcyCS
         7Ni3iMBfwSU7gsATdqsaACShNLC/kuIt7inQ8qc6MhmDx4EiBBpHfxlDz5kSA6eRCQfx
         1XCOPO1eLvu5eaRNGAolSH8mqrcgwTDO4xl9Ct5l/AAtb9zS/PbXiZMFXcwJ95glJnZN
         EcRi4lqMwNri28CwQpNfIW8cmav7QjyvARMP4n5uEGDYe64ILdYp4sYX/zvas5P6oC8R
         0LqdLOEy4au3N3cTBtvJHo+5aZq8BbBRIRPzGog+q+C/ZADWXlUqU3Z5/ZBp4wyxo7nc
         wxbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784998742; x=1785603542;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hC+CxRQqKmkyBIafqt/yge3L3p2Zduxcv89Phke4qH0=;
        b=iAI9E1lyCE1Z8DwmlNBO3VOX1MRTPbHBRONSHB2RpbaKvXC9ox/moA3bhjRymeSvlP
         4MK3Wfih6fb6BVQ0f+27oiamUpeYdNJYJn3G0HE4yGe6f4WA6OV2WIP+bomEgnsc9Xxp
         aGlE3NdcV/dMxZE2bFW/7auN8TOU3a1VoQvn84TKNjIViSJew337jEkg2oBXnW8ZkLsr
         lbM1+rKc5Bo57+csV85/v0lGnzEfyf6qk+N5SrhVPeLh8Qvppgxxe22vZ72DwHQ/o05r
         xiabJ0dnttioMJMMgr6Vc42v/VNWdhrEq18IylorhqfAz31FevMlvENgYR2MqwwZDf1s
         JCXw==
X-Forwarded-Encrypted: i=1; AHgh+Rou1u1IyEskm0OuOkFvb50JchJkbquczgpNq8WkYjRFwbh+rngvp+kkalygo1G0rEcXB8NXwsmiPpLK@vger.kernel.org
X-Gm-Message-State: AOJu0YxTfv7XfohBHiVkLzeejXqKAIZ93HufJbC7a/I1OJP7/7d7t7cO
	5yAHjHo1pSAlyrHPvEjZw9TcbLQL5DpKZEoFCqsaoF3W1DGTfwVUjHBF5oRpuSxL05Zznt/pXMi
	3CUJJFi+Fraa/GUlSUN/owgG9T7JHNmw=
X-Gm-Gg: AR+sD10olR31p9EEhi9u1ecwm4W0loPs78eLOnObOZnlgonzKuxN8qJS5s87B871hfX
	kEdvkXCp9Lu3VdlUWnwrrpHKoYYvCDmr4TOvc3Tyk8pyalCSg26XtyT5FJqh/vIk1WZVRlL83hA
	ENoY5BRkudCY9Edq6kQRv30BeGiRd9LaPrLZHv/r1kMkUC1yEgGB8Vjno5yjw82l7MXjb7lIIzz
	9g0y9gqAha9AZVxxMF8UcSIFduHGq7Gwec77IFSuTQmWUpTkUNe1yJAy3gx/EOIes8DLWClrsHX
	UTXA44zu71FE5zdNHIONxXx1JCdPQmqI4BquF4vNq8JnQ30IFpeNBIXXQpBBm7QAXZ1SRsEdWXq
	76v9Ut/80vvS8Lg2Lm4aBaGMtpqP80HuMj5Ba880tuqnHD8U3JJXSW+foop7wSBqgpUntGVvHoP
	Hu
X-Received: by 2002:a05:620a:45a2:b0:92e:7467:fea0 with SMTP id
 af79cd13be357-932df5ea63dmr234159385a.34.1784998741647; Sat, 25 Jul 2026
 09:59:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
 <20260723184538.3888637-35-ekffu200098@gmail.com> <CAH2r5muT20HXUANLnXQc1dAAvs+N=jFneSsV9gUqS8GE-wWNPQ@mail.gmail.com>
 <CABFDxMH=1M2m8tyyHZHwpJ9OUmMRBCftfq2SiMxTyKUr7a9FNA@mail.gmail.com>
In-Reply-To: <CABFDxMH=1M2m8tyyHZHwpJ9OUmMRBCftfq2SiMxTyKUr7a9FNA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 25 Jul 2026 11:58:50 -0500
X-Gm-Features: AUfX_mznLxsQSQK11_ML4Ufp_HWhKibUgDDaN0QujkG3r0EurREKl3rfXZhFIu4
Message-ID: <CAH2r5msjuXudJCGR2pbduKiV3Vv8g3VWEo1BesPA9NLTt4Qc+w@mail.gmail.com>
Subject: Re: [PATCH 34/36] smb: client: remove conditional return with no effect
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Julia.Lawall@inria.fr, Steve French <sfrench@samba.org>, cocci@inria.fr, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, samba-technical@lists.samba.org, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have now merged it into my tree (cifs-2.6.git for-next)

On Fri, Jul 24, 2026 at 12:12=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.=
com> wrote:
>
> Hello,
>
> On Fri, Jul 24, 2026 at 5:27=E2=80=AFAM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > You can add my Reviewed-by if it is not going through my tree.
> >
> > Which tree do you want this changeset to go through?
>
> I don't have a strong preference. But some patches in this series have
> already been picked up by their subsystem trees, and I'm planning to
> send v2 that fixes several issues and addresses feedback.
>
> So could you take this patch through the cifs tree? Then I will
> happily drop this patch from v2.
>
> > On Thu, Jul 23, 2026 at 2:04=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gma=
il.com> wrote:
> > >
> > > Both branches of the check return the same value, so the check has
> > > no effect. Remove it and return the value directly.
> > >
> > > This is the result of running the Coccinelle script from
> > > scripts/coccinelle/misc/cond_return_no_effect.cocci.
> > >
> > > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > > ---
> > >  fs/smb/client/smb1maperror.c | 6 +-----
> > >  1 file changed, 1 insertion(+), 5 deletions(-)
> > >
> > > diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperro=
r.c
> > > index ab3d09613c91..395299f9121b 100644
> > > --- a/fs/smb/client/smb1maperror.c
> > > +++ b/fs/smb/client/smb1maperror.c
> > > @@ -234,11 +234,7 @@ int __init smb1_init_maperror(void)
> > >         if (rc)
> > >                 return rc;
> > >
> > > -       rc =3D mapping_table_ERRSRV_is_sorted();
> > > -       if (rc)
> > > -               return rc;
> > > -
> > > -       return rc;
> > > +       return mapping_table_ERRSRV_is_sorted();
> > >  }
> > >
> > >  #if IS_ENABLED(CONFIG_SMB1_KUNIT_TESTS)
> > > --
> > > 2.43.0
> > >
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
> Thanks for reviewing.
>
> Best Regards,
> Sang-Heon Jeon



--=20
Thanks,

Steve
