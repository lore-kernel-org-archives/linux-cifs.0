Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0DE2652A4
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 17:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761931987; cv=none; b=VIc+OuP8mIRyldcuTiMsbbirC0L3Hb4AfEeTGXzU73sbql0uj3uKqW/kB/qfeqn9z3SOV+8h+/JtJHXnBUddHi4s37SxhbKzvYbVSvMYJUjaKGfIiI/6VlVEMGawM1CPH5nEu1tu06vTPFTTiccRHW508pJmRwwE1dWBZaink+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761931987; c=relaxed/simple;
	bh=7sCevWjkyjL3d+vFNxL1lN9dML6nd3bnDu+c33kO9jI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rqDQbIp4gWZBfJiczQfcTiE9xWWHPCkzwlnXkodkeFNkWOMQV3Exb7qGQaZypqtgOLXIpGMVfEyL1zFtQZYvV1JzVig7CB5ZUitAUn+IGprzYTD/c5fBJ9DzETbbNA7788iwQ5kBvei8ZsISt0Xjh7IRO1uPFKdt52hnPttRxQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MqSyc2PO; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MqSyc2PO"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-88021e1abc4so19728926d6.2
        for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 10:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761931983; x=1762536783; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibj1wv0KJmrPfux8dZzfE+rsy2vdBV17eWfAlpZNk+o=;
        b=MqSyc2POelGyHxUBRoWudRxJZcfJiqgkqbdkQTdfgzZE95+YWUXcS2j6LN+wxJzHrD
         S+A7/QIXID68Kb2sEDiLauLKtc0iqIkWgbqdCPJbrvTgtHWDpjbKtxXuvSpCwMRSNMSX
         u+sUkxEbBgV4Hj8XwdnmTH1TqslS7hOT2pUYd9teCtwTjDV1JgajASrUr6rlZAIzS0mT
         nZmngQKhvfAjpE7vCijjybpyJt6JMJZcP7u0I209vSnMLPRzd8s6sw3RuSOMmtHrE0K8
         J1jtr+JNUAWWArTLh5Mx+DWrjyKnEb7yDg4lGYQBuZ+HLqGQCu3DEnm+oGLtzFMBAS5t
         R9oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761931983; x=1762536783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ibj1wv0KJmrPfux8dZzfE+rsy2vdBV17eWfAlpZNk+o=;
        b=VsSXh22sUiEfRpSKoaDWwQilTsMt9B2VrMxDiUhKeQY6Qhmqdyq5rsCbNLDWBqMJG8
         LKtXLZG6dSPcsFcSeQzgohKVvS3GkMVekJ9P3bVfakfxZ+Fe5Zm+a2GucD3WhR4+B0yC
         LKuef6VYvShfLmhrUuRTfUkCLnyDeUhcSqYR9CfukzWo46FYUZ+DAAl0CkXkL5QvqbZR
         fdMeBQUl1s3h9ClmIv+kIWaenb6kABr/EpQxVvkIR4G3OUCSZIibHnn0gJqOgHoYOp1I
         srcO9n5pMoRfNavwQTn1CxcC2t74ECLM+Wev1u648y1mUoQJ/Wa31lGYfSW5pZaeFckC
         bW7A==
X-Forwarded-Encrypted: i=1; AJvYcCUgjvo9Ogzq7w4ikQDVi5mu4bmXhfalkuqPpW7Z/FfmcbAIlStLrkyANBuEA0rhJlRhkCRwQz+cwya0@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy/R+21kEvtVc5bb0IpY8Fjq4m/FW3+86GTr8eko9Ckw1IvtVe
	ycMpgpUS2619IZhfthzXaLaz50BtmKgygiZgQOcgkR23GhA7OmWI9bnA7+1Qc7nJJO5rXgDUnqA
	Ay3Cs+y91fIVgtg7u9NCijiBQvROHQ51Fmfhn
X-Gm-Gg: ASbGnctvUSYR5BGmdGhrT/ClGopBcyOcDXiKkBSCFJc5vMCUSNbprGfuKeHcauPk2FP
	QpLbkkJq1qcOK8dV9NStt771t3UuzWeHwykcmUW1IUyYiSDdyAJ9GrZptn2Jxvl7WHUCRgZ5zED
	gXqDqYf56R/+LkOF550qMnI8Q+S9fja9fQsKeFYkgPGnxgQ5EylC3oD0Hp/YCYYkfN1JxC7uTdA
	/9KSu3/LXawjEJePvp5Wwt7WqafjU42u8EHr70ugWjQUAFDTaF2ogW1FvmLCIFB9wpRNCTUeuug
	0vuC1OHk4K0faPAQJYzJFAyz/bXaziMYw3h/HZaxXF3XeDykUSh5+fz9LaGd2vLnY+3hlK4K1Mw
	5oh2V/Pyf+Yk2LGuYHH7+/RMHY3yG2/4rZFCidXxmdGoIMfOKIREo+6dXXIUdY27hCMGxhKvIFR
	w=
X-Google-Smtp-Source: AGHT+IEFaeQpOBUZ6qeAuDaef87etVuRUyKDAKEMcWbNk01VtIfZMB4VK7zptzTLlanV5zfB7swl3G4E9bFWjH6Z/hE=
X-Received: by 2002:a05:6214:f02:b0:880:2368:2e70 with SMTP id
 6a1803df08f44-8802f43e997mr59400166d6.39.1761931983251; Fri, 31 Oct 2025
 10:33:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030170116.31239-1-bharathsm@microsoft.com>
 <20251030170116.31239-3-bharathsm@microsoft.com> <b3ced9ba1cc2a3d8e451c2e9d7ed460c@manguebit.org>
 <iqf7l4ymr4pebuxkuxdklftctcctvfhilivf6zvtxqgwf5cics@ztoabwasr4md>
 <CANT5p=pnXLDyZMVoKdUqTzPB7dxj2kd1g+2FfzD8LS4+8LyODg@mail.gmail.com> <6juyv7x4jacgyxpfgtmcegyzso2mblw43t2x6pc4g5fnsfyody@ji2zhgqnrgvq>
In-Reply-To: <6juyv7x4jacgyxpfgtmcegyzso2mblw43t2x6pc4g5fnsfyody@ji2zhgqnrgvq>
From: Steve French <smfrench@gmail.com>
Date: Fri, 31 Oct 2025 12:32:51 -0500
X-Gm-Features: AWmQ_bkJeqr4K5pX8QJ5dM2pwmm15f0beLbjFu0BC2ORO9nZqGNjhlkExz2SpWk
Message-ID: <CAH2r5mtZ5D=CJSVbfri0tdBXZSwj+FJ5sUHhFWWZ9BxmzZqNVQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb: client: show directory lease state in /proc/fs/cifs/open_dirs
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Paulo Alcantara <pc@manguebit.org>, 
	Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, sprasad@microsoft.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

dropped that patch from for-next (kept the other two small debug ones,
although those are low priority)

On Fri, Oct 31, 2025 at 7:55=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 10/31, Shyam Prasad N wrote:
> >Hi Enzo,
> >
> >On Fri, Oct 31, 2025 at 3:42=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.=
de> wrote:
> >>
> >> On 10/30, Paulo Alcantara wrote:
> >> >Bharath SM <bharathsm.hsk@gmail.com> writes:
> >> >
> >> >> Expose the SMB directory lease bits in the cached-dir proc
> >> >> output for debugging purposes.
> >> >>
> >> >> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> >> >> ---
> >> >>  fs/smb/client/cached_dir.c |  7 +++++++
> >> >>  fs/smb/client/cached_dir.h |  1 +
> >> >>  fs/smb/client/cifs_debug.c | 23 +++++++++++++++++++----
> >> >>  3 files changed, 27 insertions(+), 4 deletions(-)
> >> >
> >> >Are you increasing cached_fid structure just for debugging purposes?
> >> >That makes no sense.
> >> >
> >> >cached_fid structure has a dentry pointer, so what about accessing le=
ase
> >> >flags as below
> >> >
> >> >        u8 lease_state =3D CIFS_I(d_inode(cfid->dentry))->oplock;
> >>
> >> Also, I don't think we can even get anything different than RH caching
> >> for dirs.
> >I don't think we can make an assumption about what all servers return.
> >I don't mind dumping this extra info about the lease state.
>
> It's not an assumption, it's a fact -- if a server returns anything
> different than RH for a dir lease, the server is broken and we shouldn't
> even trust/cache it.
>
> >> Even on RH -> R lease breaks (IIRC this can happen), we don't handle i=
t
> >> and cfid is gone anyway.
>
> My point is a dir is either cached (RH, cfid->has_lease =3D=3D true) or w=
e
> don't (lease break with 0 or R-cache only, cfid->has_lease =3D=3D false).
>
> So unless we're changing/handling the behaviour for RH -> R downgrades
> (which I really think we shouldn't), creating such level of granularity
> makes no sense and will only cause confusion (imagine seeing W-caching
> for a dir).
>
>
> Cheers,
>
> Enzo



--=20
Thanks,

Steve
