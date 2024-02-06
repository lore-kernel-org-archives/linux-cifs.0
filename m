Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24447F462
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 06:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707199319; cv=none; b=P2663U5uCe3kSTnHLVlOzDGDnIIw9UM7YqLnqV6Fv7NHby8Po2e5Ur5QvL5ouIG7Fk1EHJTmGDm5dPMo9iVEJEc68mwJKhQbzgYn+vMPDkzskb5qvCZbRJN9Ns9qtmTCpZJ7LiicMahZIGdgMbJrloZB0JhdWU51jemIsESXph8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707199319; c=relaxed/simple;
	bh=E6tw3bLfREYVwVtCAw3dMjgLP/l9KdT14rPbhYvWJyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uTRYQ+qTOn6hpvWzGMBLHj9lXB8LcGKsRQQ9HCsfdhO69oTB/0maw7uIVs6qYY7W4YL5aF2gI6kc5KVF12XeVOfsPsrok6FIORZ+GaEz7llWxURta8xdb2j6gaFSCycUOg/NoSS3338cgL48dfQ98yLX0epNvxa1IJ17OM3s+7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JH9+YqfI; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JH9+YqfI"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5114c05806eso763514e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 05 Feb 2024 22:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707199316; x=1707804116; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RKHBM2k/nvL6FtZzryewl1fkQdLAYiPpua6DmKHbXQM=;
        b=JH9+YqfIxB8Eq6JS25zcPmS9r26XgZA7IJG6hSCAmSf6sLRyp4MsYTmE4T9si8LLTE
         2VkaJEcjJC23u+OoPTgM+y4Z3yTjIVEwgSm7f2Jro36/iYoUWjeg/TtwGxuGmJjT0vjN
         qjH4Zw69BEbZ2u7PIsISAwq0A8KPtR1O5uRuK4rKR/iEWbghjzsgwIKFo6hmhmL0MMRc
         H7NTPv/b/wSXIP2qX9XHpcNLxh/9K0KVFealathKtBUQEvfFplXaPTFCaA0sFBFLxKef
         vjP2XyPULNnZIR6FgOf++Z7+d4Lu9U5i7L+S6SPbPgU6jsit/uzWhSW+TVTv2pN8TyVa
         nkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707199316; x=1707804116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RKHBM2k/nvL6FtZzryewl1fkQdLAYiPpua6DmKHbXQM=;
        b=g6NnGwrGjhgPWUry5J1YeNAyfukhk2L27SKnpoFreIkGX4H6HOsa25QAJTiDgVAn9v
         oi6nJ8rwjE+2/Ylk7YM6fUSHkSufquodCMnQr4d8RIdL5aTYldA+LrV/9ehItBGBz+y1
         JgwDJ3KVmW/r0g7v8SsQlS8ZF/CSM03y2g5ZZlSMMmrkkr3syjxa2INFJKOC/rG1NqPu
         0xR/bduiJ89fV9DYZiDZfhIWJKIg8uA9eyw4RVS8Pt7Qf9ysvm+UrYZBVZQL6pmDSIow
         iuihujbTJ7KZDqhi/a/vcqV1b+hd4OYKelV6KwvNYxMOs61Z9v+EByBYlCnRQnyDuRv7
         dEOQ==
X-Gm-Message-State: AOJu0YwqZx9QHGv6+lLy6BIb1aIwyhVEbFxmoVn6GIc0eyKDs6GRCjbI
	+o/5TdC8FyteTymGKBjt5y6qwP2AqUT8Vb1quCmle4xyIyzxJeS78tFWg3BAaal7wiTxD3ImeiE
	pRr+3FGu7nYnMF+S4SFBX6nBOGYc=
X-Google-Smtp-Source: AGHT+IE9hBqcxOcITEADAYmKtHjUw1LKify/O+o2TVUf4Tlb/YjG4+ikTG4tRxeGax43gtVEMNRIlGx7fe3Z2kfNMb0=
X-Received: by 2002:ac2:4a8f:0:b0:511:38e6:6b24 with SMTP id
 l15-20020ac24a8f000000b0051138e66b24mr1276074lfp.3.1707199315587; Mon, 05 Feb
 2024 22:01:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <84dddfd9-c8d3-4e68-a228-f599649c8e8c@moroto.mountain>
 <CAH2r5muqs2JFqECJY2R+0AEF4Y_ofdN8Wb55TH8UpfXU7L1ZGQ@mail.gmail.com> <CANT5p=oug8SsCVL_Mi=hpx9Py--rtumYvLR_k4nqq1oX6ns+CA@mail.gmail.com>
In-Reply-To: <CANT5p=oug8SsCVL_Mi=hpx9Py--rtumYvLR_k4nqq1oX6ns+CA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 6 Feb 2024 00:01:44 -0600
Message-ID: <CAH2r5mvYARQjJPG6fXyGfjqGyUEMRcncpK3CLapft-6QdkyJrA@mail.gmail.com>
Subject: Re: [bug report] cifs: do not search for channel if server is terminating
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, sprasad@microsoft.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 5, 2024 at 11:51=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Tue, Feb 6, 2024 at 3:25=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
> >
> > Shyam,
> > Let me know if any objections to this fix, similar to what was pointed
> > out by Dan.
> >
> > See attached.
> >
> >
> > On Mon, Feb 5, 2024 at 2:52=E2=80=AFAM Dan Carpenter <dan.carpenter@lin=
aro.org> wrote:
> > >
> > > Hello Shyam Prasad N,
> > >
> > > This is a semi-automatic email about new static checker warnings.
> > >
> > >     fs/smb/client/sess.c:88 cifs_ses_get_chan_index()
> > >     warn: variable dereferenced before check 'server' (see line 79)
> > >
> > > fs/smb/client/sess.c
> > >     78          /* if the channel is waiting for termination */
> > >     79          if (server->terminate)
> > >                     ^^^^^^^^^^^^^^^^^
> > > The patch adds an unchecked dereference
> > >
> > >     80                  return CIFS_INVAL_CHAN_INDEX;
> > >     81
> > >     82          for (i =3D 0; i < ses->chan_count; i++) {
> > >     83                  if (ses->chans[i].server =3D=3D server)
> > >     84                          return i;
> > >     85          }
> > >     86
> > >     87          /* If we didn't find the channel, it is likely a bug =
*/
> > >     88          if (server)
> > >                     ^^^^^^
> > > But the existing code assumed that server could be NULL
> > >
> > >     89                  cifs_dbg(VFS, "unable to get chan index for s=
erver: 0x%llx",
> > >     90                           server->conn_id);
> > >
> > > regards,
> > > dan carpenter
> > >
> >
> Hi Dan,
> Thanks for running your analysis on the changes.
>
> >
> > --
> > Thanks,
> >
> > Steve
>
> Hi Steve,
> With the current code, there should ideally be no case where a NULL
> server would be passed to this function. But it is always good to
> check explicitly.
> Changes look good to me.
>
> --
> Regards,
> Shyam

Added the Reviewed-by and added to cifs-2.6.git for-next

--=20
Thanks,

Steve
