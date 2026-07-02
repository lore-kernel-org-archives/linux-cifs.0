Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999C444BC91
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 14:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783002182; cv=pass; b=Hvd5xuhq3fktiMECp/D1+tmQHX+Rf7ArMrZfUm1MlX/X0FB2YGNW1tPJcA+r+uc5j8JiJIV57f5Ste1+Q/+bwKVtHUipBOGFdAjJaY3qdXYYkJXV6y+LIxHytJudh4s6GoBLPaeQje0pvZ9bICfKjvRD2LN/486F929UBDp9FCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783002182; c=relaxed/simple;
	bh=rlGJmIRph6L87Y/a4YB9PrGgW1WSQ12bPAK7QlxOnOk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bN4scfyTdUeQFrBqWbQE/zx2ACFLHPwF3RjhvuH1/SI3ncLSfKFJW3HsHBnyQOUDHzge2AGljdYBbFPUZxNAKpt41E4WZ4D80R5RaU3dQWthzw+dkOBFNRK9NpcSrnSr/cRxIHH48z6ybZLE3kBBlilW+RsP7kLG8fiMQWKjlEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aQTEVmPm; arc=pass smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQTEVmPm"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e55b62640so97018885a.0
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 07:23:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783002181; cv=none;
        d=google.com; s=arc-20260327;
        b=SNvFfWP3JogK57jmfGyC+YYjErwJbXp8Og2XOo2knSAvdR+R6y2yALXibOEkm/nxk1
         bTIdVDU2LR/NwlwREdrHWkSOMTyIjUBM5VQuZC3qRkpIUjH/QYWhs0tsczK/qh/oB7jw
         MwwNfddMFAjUnFLo2/E0imshD+kF/by+o9l1/lSHVU8F3OkZKhaXx4Y5MR8L/fbBMBaA
         deSh36fi8/9j3vNqmg2QGw7DE7ie9VeWLCY1U0qabYgak1W6Nn8YMbstJug8C6Ay1pmO
         CWir3CZK+rfhKBrq8I6Myu/tSQGMiY5xzGhBolpy1elWk8wr54x0MDWg3ydJA90Wcygf
         6nfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gbH3YLpoRRRBEQibj7D2qVYcaHe6y8OssH9lEWG5bD8=;
        fh=s2n9lydMA2zhJpTjMdAeEU2vMG6hpxF6IjHgzoIu898=;
        b=kwDTU1KEsXZsRTz9c8415YPhNJAl8ACUmvOesoUiUr2WOp96rrGN2lxquaBgEGLDtu
         50SwUPLzUKTh972sgY+HV8/Hjnfgivhq3+s5fsbSxABkMpwJrGzEZHMT257kMmIAxbWX
         E7vdaEAcbBJrKGBfC8ucfpWDQ4VAOnONmlWdGTNQn8Pjyx/dcbmPDUycrs7hn6zp169Q
         WRdvtCyZvw0kg0RFdcuR0QQeQ0ZOO/Ixte7equ3RaeUTX9qcfqYPC8ctrgRlcD5dirRd
         w4WS+fSECTBJ6aLKrmnNEJSZTFqLk4nxKiOvsDyjnPKqMue6omsXat/wPSMkzV8jwGyi
         G4lA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783002181; x=1783606981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gbH3YLpoRRRBEQibj7D2qVYcaHe6y8OssH9lEWG5bD8=;
        b=aQTEVmPmotywx8fSK+iL5eq5zXuOYB2t5a5ekHuiqEOCiLUVXg4F4/UGvyD75hGvVl
         jHa2WmXYqSpYnbQwLCx91Mh55XKS0O15KpkayNiX9K0bpClBpax39EUr8NFHxXOih4NN
         i65KbWZZy6bvR+7+K2dgc78Zg4o0gv/gFfFg2V0NMYufGHIotts5BuwbquhJbf0zCCoM
         0hKKB71CqO7ihAvWXxKyO/IYKIClHs2/4LsIhvqUxooUzd8NDvaxafqRuZH4qX23TK/y
         BBWXA7ZskUwOG79eLGaKVg8mdNg9cSg35TX7izHzA5PIWtBqpo5dPAH020msIBWjzUMi
         sR4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783002181; x=1783606981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gbH3YLpoRRRBEQibj7D2qVYcaHe6y8OssH9lEWG5bD8=;
        b=kiMuclwaqChe9210mQfnF6ohKRzdRHbfOqJcHW2/G97tlS3S8ofyVeBA20XE6r2sNr
         NLx7zp36XNplrXrDAdh9vRQT5bUMCXog4wcwzwpaqUR1wjw8sa9GZ9Sb2tsAs5jW746R
         hgFO3CMoPfp22Np1/HlljGvAfn43G4hcW2/o7bMH7D006ZkJdoeOyvDEHhttKDblT7mq
         zkTTGGUu3aPBk2kQxovyF0sNGll3JMPOC/F3RgRAZPMf/CnQctIWl9PewHam1rY9qtIt
         cZKffQabxdiOUk/9OE+NsDipw8YyYjLSB/zXkegTx2RqUVQAGsjLimFjM+wIu7XXjeeL
         AFhA==
X-Forwarded-Encrypted: i=1; AFNElJ8AP8QVCUpYmO3bsGOpVMsl8dHMFJwiazuEaD4ZOtktsTtmAOj1Am6AwsIN7opW6iauXIR1I8/i2h4I@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1yz+668t/c23j7aGKOkDkMCUG9X9niH8F8XD2oEjZTavuVoit
	wSrPVoAuEe4rDIzP8oR9hrKWd5WU6MCLYUq97s1RegLU6w6pcPXANva7WHDUx9lJOHHDVpgpKRi
	32tlB7VDqHtGOdggvvJBN7AdFE+LIOpo=
X-Gm-Gg: AfdE7cmamvLdvM3HFcd0kC1sEFrzblZRkKqFkIYpdR2Jfy2I8HQ3R/G/IFXkKjTOuYH
	ebFONDxNwh70U9a4QJ/3/FFHEZB9ZvnsjbyOPltIncs1aA+q39+QpoA3dmwLZFMUwqB9CjBfbWm
	php5S+EbvxeMAgNwNWdCCrsqnQLJKtpNa0uCV7bbHEu9Q0C3Zyx0znFn9jDtlQUaYsrJU85TMX3
	PofnO3M83jnIRJj14arevFK/yoicT48FJvlmn7/CkBvkYJ3Aoibo0tKAxNMfKlNGUtnV21vEcMj
	EvusotZ3VBb12Hbx0vtv8q2oE2fWCfFYaAvVu8IJWF5KzhwgitMuwAUnwC0dXE4e4U18nkA8atk
	HRlmhY6xZKL64KJeH6OptpgJ8zZbyp9MpgU/qQUx4AI8RVkCcUx55EfDOJzzjuX1e4S5+kXP6Gw
	C2++4k2ioQhQA=
X-Received: by 2002:a05:620a:4888:b0:92e:5a5c:6582 with SMTP id
 af79cd13be357-92e785220ebmr803616585a.73.1783002180509; Thu, 02 Jul 2026
 07:23:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <138902.1782980700@warthog.procyon.org.uk> <cfbb3e301d90d034922b945c522813df@manguebit.org>
In-Reply-To: <cfbb3e301d90d034922b945c522813df@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 2 Jul 2026 09:22:49 -0500
X-Gm-Features: AVVi8Ceh8sRx5L0qP6iLeTvZW8yFWM6AmNERvXoYUkt9pPKOdB4YYq5l691TJOY
Message-ID: <CAH2r5msCwtASOc6c3_pxKF3vPqsowbpYWTWPacetzUAeQB2Z6g@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix missing credit release on failure in cifs_issue_read()
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>, 
	Christian Brauner <brauner@kernel.org>, linux-cifs@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending testing

On Thu, Jul 2, 2026 at 7:53=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> David Howells <dhowells@redhat.com> writes:
>
> > Fix missing release of credits in the failure path in cifs_issue_read()
> > lest retrying the subreq just overwrites the credits value.
> >
> > Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
> > Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%4=
0redhat.com
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > cc: Steve French <sfrench@samba.org>
> > cc: Paulo Alcantara <pc@manguebit.org>
> > cc: linux-cifs@vger.kernel.org
> > cc: netfs@lists.linux.dev
> > cc: linux-fsdevel@vger.kernel.org
> > ---
> >  fs/smb/client/file.c |    1 +
> >  1 file changed, 1 insertion(+)
>
> Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>


--=20
Thanks,

Steve
