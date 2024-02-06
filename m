Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AEB77F00
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 05:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707198684; cv=none; b=crxvW2FP39H251Wmaid1/Em5VklDPCAESrsztsPVy7MOWcuux4icddutALwuuoI6PN/pSQApkDErJ3skpF5xiTHSD9oUeQpQjzT2+Jxi+Eks19yE8CAJBnBrxyj73JeBVBLVNmrLI2/GeKOMeBRD2RNFjD63q5V3dR6l8iaL8AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707198684; c=relaxed/simple;
	bh=mm7o7C3MP+OWxRRDYuXJgtH8Zkdbj0EAITPdfVgfJZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TrJlQaGG4+XknHc/2CrTBXMbOgBZkeEOBjt38LHvZh/vgum2aUk25823P2TxHIQ6IcZwF7imNdOWtYJ4bofyZ5iSGCu6eMbAXVtUfXZpE4K7ItWY0wJ7j797hpWis3JHuGMPw8eXp2/pAcPUAdQaaOQZigeGCeKx3vDhPtULbxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WhIy/mOF; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WhIy/mOF"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d094bc2244so34841881fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 05 Feb 2024 21:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707198681; x=1707803481; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7GGwq8F4EiGqNyF9dxEblvHCN6SaQ2Ryq+jKhazm8kc=;
        b=WhIy/mOFoPiYbyK2J6bPji8xgCpCdEO8ZTlMffeF75B4+uDSqS/OnvGNDW+ff1yjVC
         X0cwnZBbrAnVmChAgtrYokas2Y+hYXboG02rUHFv+uHHEvmarm7cqUX2p5QPMQ8/UeRI
         hwkpzRBtoJd/3OoerPO9pgzNttnuJcaerCSbRYcIu6Qp/SZSjA9uGunhzI4FsXrNRcCF
         bO6/FTV3s6CHdLOrWy+HXGTfdufWVus2MpodfMiAFGUCzu04+8a2FnaEHPxS6Pe7Enl8
         HaSotVkT0wH8KfWgyNuEdfXC8l+Q2CyjIoJ+fdb2d+y7cakgU3niO5pspisbLyUr8Hf3
         COfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707198681; x=1707803481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7GGwq8F4EiGqNyF9dxEblvHCN6SaQ2Ryq+jKhazm8kc=;
        b=fbzNbpSAuxQurUlgLNaUzr22t9Z1vDmicZycxS/77OA6/woreDts7RMCgXLPOjRXKG
         7qWhvh+1W2Uk68s30Z0VycI63xREwDg/LiDBfhrIbZ3o3hDHpiKB38t6w9HixjyEsBlB
         599oTg50ft8n9XuiMDdIzSeoNkws1cGuGIobngOy7HisnMjhbOP/dFM3Gsmo3DkxTBCD
         Ude/W24CQxRUPAyhLw+SAAe8qpGQkNDeLpsmzkzZELgvdzeUUu0wa2DVHE+Nz3wjV25n
         PSN+ABINIrOMT1AcqAGBKQJIemBia5AlqNY+oHWvS4sjR7nKM6h4GtvSiVtSloR9NByN
         TMRw==
X-Gm-Message-State: AOJu0YyayhvBHxOvOK77hxde5L44PXmMIQQALlWcXRCgtXhsDGcDbqrT
	pzJg+sI9vANuNuNmGIleMFGl0YX+Xy00LLgh5eFR0hl6/x/hRx0HdaXk7mX3aMeOWLwvT6p8t0T
	f9vB+BNmxKP2ZpkJ7Bk0ySqOKmls=
X-Google-Smtp-Source: AGHT+IEdvYqoBHz5LpX5AFQJ81ducvF1HxvLYLKsI8q+RjmQvB+//mgdpJhwCzXAvSyMUp3eX4OCmxYpOff3frTcfRo=
X-Received: by 2002:a2e:7803:0:b0:2d0:97e1:6c1d with SMTP id
 t3-20020a2e7803000000b002d097e16c1dmr739587ljc.47.1707198680634; Mon, 05 Feb
 2024 21:51:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <84dddfd9-c8d3-4e68-a228-f599649c8e8c@moroto.mountain> <CAH2r5muqs2JFqECJY2R+0AEF4Y_ofdN8Wb55TH8UpfXU7L1ZGQ@mail.gmail.com>
In-Reply-To: <CAH2r5muqs2JFqECJY2R+0AEF4Y_ofdN8Wb55TH8UpfXU7L1ZGQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 6 Feb 2024 11:21:08 +0530
Message-ID: <CANT5p=oug8SsCVL_Mi=hpx9Py--rtumYvLR_k4nqq1oX6ns+CA@mail.gmail.com>
Subject: Re: [bug report] cifs: do not search for channel if server is terminating
To: Steve French <smfrench@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, sprasad@microsoft.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 6, 2024 at 3:25=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> Shyam,
> Let me know if any objections to this fix, similar to what was pointed
> out by Dan.
>
> See attached.
>
>
> On Mon, Feb 5, 2024 at 2:52=E2=80=AFAM Dan Carpenter <dan.carpenter@linar=
o.org> wrote:
> >
> > Hello Shyam Prasad N,
> >
> > This is a semi-automatic email about new static checker warnings.
> >
> >     fs/smb/client/sess.c:88 cifs_ses_get_chan_index()
> >     warn: variable dereferenced before check 'server' (see line 79)
> >
> > fs/smb/client/sess.c
> >     78          /* if the channel is waiting for termination */
> >     79          if (server->terminate)
> >                     ^^^^^^^^^^^^^^^^^
> > The patch adds an unchecked dereference
> >
> >     80                  return CIFS_INVAL_CHAN_INDEX;
> >     81
> >     82          for (i =3D 0; i < ses->chan_count; i++) {
> >     83                  if (ses->chans[i].server =3D=3D server)
> >     84                          return i;
> >     85          }
> >     86
> >     87          /* If we didn't find the channel, it is likely a bug */
> >     88          if (server)
> >                     ^^^^^^
> > But the existing code assumed that server could be NULL
> >
> >     89                  cifs_dbg(VFS, "unable to get chan index for ser=
ver: 0x%llx",
> >     90                           server->conn_id);
> >
> > regards,
> > dan carpenter
> >
>
Hi Dan,
Thanks for running your analysis on the changes.

>
> --
> Thanks,
>
> Steve

Hi Steve,
With the current code, there should ideally be no case where a NULL
server would be passed to this function. But it is always good to
check explicitly.
Changes look good to me.

--=20
Regards,
Shyam
