Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BABC146A72;
	Thu,  7 Aug 2025 16:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754582569; cv=none; b=k0nBg6FK+1haKT7T1sN4107DvpvBNMJxB/5qsrNNzFxzxfns615TDEh8YO1VkTSzBvDt9hcU9hRKCJCLbZ1kt5rBWHpFo9YPHD7SNdm9YD8KEob46pObSDmjkM4p3HNsklLhWavENTanZDuDNRlNv7PApFBBiqREDskGzv85Kek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754582569; c=relaxed/simple;
	bh=Mx+69E6o84wwlLdznPlu58kyLM3gy/8avjB71gvqipg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EwcqtVCma+uIF2EdYf+rIBx4M3r3pcf82heAapd1MXCHUk1klnaiUO72HVuKjyjQtO8/VzhnFx/tIi56PeOgm0O/ThQTNZDWewZ5KSNUzravzBALuJLLJivrbvjUiOcHjOMOoZeam2RxC32lZTlLm0UMiEGJXjYKClmh4BUGvMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PEVgIqo0; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PEVgIqo0"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-707453b031fso15217626d6.1;
        Thu, 07 Aug 2025 09:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754582567; x=1755187367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VwQu0/D6m0UDV0CRsFb/BkiCr1jp/Q0C0jJDQue2He4=;
        b=PEVgIqo0SmFD8uSP2Yl8T5FDFS9SqQRk0cGViDlv8Pm4yvYt0l1zrhhuN5xYNc+2jN
         RRCTnF4g7F8oRGaM8sMjKicnt505EpcuhuhDI3iP8ErpcYaQGECAxA4W/4R6omlVsUZx
         MtUQP3ubjA4BZwkDbW7+6mxOLmViPUWLGSM+kiGDf9HI2+0WSH0jR3JR3DTff2NCLmEr
         Yw/vz8kkkPaAu1czM/55hJ+nwf5HpGxrYuvRgjhp7e3FBS6ngOYKVtcyeP+268tST1B+
         aoyaIc/KU8dlTesns0aPpEza70NuzjvhtY29H/DbgBoC/xTEmw6vNpZBa474ferOVr+L
         Tk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754582567; x=1755187367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VwQu0/D6m0UDV0CRsFb/BkiCr1jp/Q0C0jJDQue2He4=;
        b=LRFJrY17EXS9Po3S5R2bnWsCO7STCd5FYuQAi34iJ2dj0MfO1+z4RHpKx6i7dc5wE9
         K2YAI/RXppyDSKjISLkUEJZ8XWS3AhrgVDFqflhflGrKUZW38VUtPC4XZsclvsd6R1xG
         gsqBQSZwpaI8MiwrhSvDI0TSS2nK01uvtTf+A/GtwtAMg7ZBB9X+piuGJhqmkbYBqeun
         4BEpg2VNI0ggCTfSZpejOG4iG9SmL2BLyVA0Yru10gYw4t0goopbuszqxXXfmZJ7u1tz
         AruVoNI8ioOXeEnfu4y3y49E1PYrcdMEnWz4Cldn1eDR4ACcOO//pl/P/3OlRfY6kYVD
         24wQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtj+6JRO4H8nsFmFdXHAqJbsWDI7/67j7+s3XcP0ypSkiBxmpDfQK7zrjaedUxte03wwD9MeiN1WutBdCd@vger.kernel.org, AJvYcCW5tGEp5ylO/Xha8ZOFg0ARKlVPw/BQBQ8Vv0H0ou2P5Q4sDmBneFWdDAojF9da6SgiY66PU3aFB0PV@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1vBIOEy6UuavMJabjeUsiQyOPj1U9Q3XXl8KBVcMUPOPOzKw2
	7nOl6on7nyLD78i4COFy/1wzV6mwc7rGDCdXbbtmb6iCsfsQeiyp6+TR//fuglnCPGYabxYazs5
	t20kmFmxQp7JmCg8cXTWQflGj082A8q8=
X-Gm-Gg: ASbGncu65C3fqfSnzDKvF1wPk8C5dShvg9dY424r1MhQE5qox3NF209lceim9Y+0MVK
	qa6KDMTL4nPm7K7CnDfyvGbByW32bEDfAA1qKG2y6iPSmtaGqkXs8kbcUa/XtxTIRwbkxfFMEvm
	qS3axNCYueQ1t9ZnPMBJcPYecHzVPU3CCovmnEel2KR7ThWICnk1L11Yip5i1a4jWI0/IlraM8M
	zOdTPKdfbRoGff463Cptx9ernbgNL2nwP74TYDW
X-Google-Smtp-Source: AGHT+IF+K0U+t1yOJyyd8NnabYBte1Vl/Rersze3x6tcq6Dn8dX1IwJe4XtuPvkzTFkOyVP3t5iNtMP46HlViETvYIo=
X-Received: by 2002:a05:6214:1bca:b0:707:51a6:184f with SMTP id
 6a1803df08f44-70979667ddfmr96617956d6.48.1754582566397; Thu, 07 Aug 2025
 09:02:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250805064708.332465-1-wangzhaolong@huaweicloud.com>
 <CAH2r5mssz19Qr+fmY62BnHOzwjQmWWU=wHXEVFkyTRGaWn-t0g@mail.gmail.com>
 <c980644d-0be1-4a88-890d-349b44ada024@huaweicloud.com> <a07e0802-da13-4ae4-b932-1560eb33129d@huaweicloud.com>
In-Reply-To: <a07e0802-da13-4ae4-b932-1560eb33129d@huaweicloud.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 7 Aug 2025 11:02:34 -0500
X-Gm-Features: Ac12FXwKUV-u-5TqbsZUSsx8Dcq6IW6izVNh1jlCsw7YTuA85-TRG_qYWhPQqUI
Message-ID: <CAH2r5mtdCb501g=rehRRwcYnGiWOZjmKX16c+Vd1EYOsfeC3Pw@mail.gmail.com>
Subject: Re: [PATCH V2 0/4] Fix mid_q_entry memory leaks in SMB client
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: pshilov@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com, 
	Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

presumably the first three cleanup are ok - but if objections let me know

On Thu, Aug 7, 2025 at 9:43=E2=80=AFAM Wang Zhaolong
<wangzhaolong@huaweicloud.com> wrote:
>
>
> Sorry for the delayed response. I can see exactly what went wrong now.
>
> The issue is that my implementation holds a spinlock (mid_lock) while
> executing the callback, but the callback path can eventually lead to
> crypto_alg_lookup() which tries to acquire a semaphore. This violates
> the kernel's locking rules - we cannot sleep while holding a spinlock.
>
> Perhaps I should consider a more ingenious solution that can safely
> handle these cross-subsystem interactions.
>
> I'll rework the patch to fix this locking issue and send a v3. I'll
> probably need to rethink the whole locking strategy to be more aware
> of what the callbacks actually do and what they might need to sleep for.
>
> Best regards,
> Wang Zhaolong
>
>
> >
> >> The first three patches (cleanup) look fine and have added to
> >> cifs-2.6.git for-next (also added Enzo Acked-by) but the fourth patch
> >> ("smb: client: fix mid_q_entry memleak leak with per-mid locking")
> >> causes xfstest generic/001 to fail with signing enabled.  See
> >> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builde=
rs/5/builds/58/steps/34/logs/stdio
> >> and http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/bu=
ilders/5/builds/59/steps/34/logs/stdio
> >>
> >
> > I am unable to view any information in the link above. Is this informat=
ion
> > only visible to logged-in users?
> >
> >
> >>
> >> [Tue Aug 5 11:03:32 2025] run fstests generic/001 at 2025-08-05 11:03:=
32
> >> [Tue Aug 5 11:03:33 2025] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> [Tue Aug 5 11:03:33 2025] [ BUG: Invalid wait context ]
> >> [Tue Aug 5 11:03:33 2025] 6.16.0 #1 Tainted: G E
> >> [Tue Aug 5 11:03:33 2025] -----------------------------
> >> [Tue Aug 5 11:03:33 2025] cifsd/24912 is trying to lock:
> >> [Tue Aug 5 11:03:33 2025] ffffffffafc14630
> >> (crypto_alg_sem){++++}-{4:4}, at: crypto_alg_lookup+0x40/0x120
> >> [Tue Aug 5 11:03:33 2025] other info that might help us debug this:
> >> [Tue Aug 5 11:03:33 2025] context-{5:5}
> >> [Tue Aug 5 11:03:33 2025] 1 lock held by cifsd/24912:
> >> [Tue Aug 5 11:03:33 2025] #0: ff11000134c25870
> >> (&temp->mid_lock){+.+.}-{3:3}, at: mid_execute_callback+0x19/0x40
> >> [cifs]
> >> [Tue Aug 5 11:03:33 2025] stack backtrace:
> >> [Tue Aug 5 11:03:33 2025] CPU: 1 UID: 0 PID: 24912 Comm: cifsd
> >> Tainted: G E 6.16.0 #1 PREEMPT(voluntary)
> >> [Tue Aug 5 11:03:33 2025] Tainted: [E]=3DUNSIGNED_MODULE
> >> [Tue Aug 5 11:03:33 2025] Hardware name: Red Hat KVM, BIOS
> >> 1.16.3-4.el9 04/01/2014
> >> [Tue Aug 5 11:03:33 2025] Call Trace:
> >> [Tue Aug 5 11:03:33 2025] <TASK>
> >> [Tue Aug 5 11:03:33 2025] dump_stack_lvl+0x79/0xb0
> >> [Tue Aug 5 11:03:33 2025] __lock_acquire+0xace/0x21c0
> >> [Tue Aug 5 11:03:33 2025] ? check_irq_usage+0xa4/0xa80
> >> [Tue Aug 5 11:03:33 2025] lock_acquire+0x143/0x2d0
> >> [Tue Aug 5 11:03:33 2025] ? crypto_alg_lookup+0x40/0x120
> >> [Tue Aug 5 11:03:33 2025] ? check_noncircular+0x71/0x120
> >> [Tue Aug 5 11:03:33 2025] down_read+0x7c/0x2e0
> >> [Tue Aug 5 11:03:33 2025] ? crypto_alg_lookup+0x40/0x120
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_down_read+0x10/0x10
> >> [Tue Aug 5 11:03:33 2025] ? lockdep_unlock+0x51/0xc0
> >> [Tue Aug 5 11:03:33 2025] ? __lock_acquire+0x11ee/0x21c0
> >> [Tue Aug 5 11:03:33 2025] crypto_alg_lookup+0x40/0x120
> >> [Tue Aug 5 11:03:33 2025] crypto_alg_mod_lookup+0x53/0x2b0
> >> [Tue Aug 5 11:03:33 2025] crypto_alloc_tfm_node+0x76/0x130
> >> [Tue Aug 5 11:03:33 2025] cifs_alloc_hash+0x44/0x130 [cifs]
> >> [Tue Aug 5 11:03:33 2025] smb3_calc_signature+0x4f0/0x7b0 [cifs]
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_smb3_calc_signature+0x10/0x10 [cifs]
> >> [Tue Aug 5 11:03:33 2025] ? find_held_lock+0x2b/0x80
> >> [Tue Aug 5 11:03:33 2025] ? tcp_recvmsg+0xc9/0x2d0
> >> [Tue Aug 5 11:03:33 2025] ? rcu_is_watching+0x20/0x50
> >> [Tue Aug 5 11:03:33 2025] ? trace_irq_enable.constprop.0+0xac/0xe0
> >> [Tue Aug 5 11:03:33 2025] ? tcp_recvmsg+0xc9/0x2d0
> >> [Tue Aug 5 11:03:33 2025] ? __local_bh_enable_ip+0x90/0xf0
> >> [Tue Aug 5 11:03:33 2025] ? sock_has_perm+0x97/0x1a0
> >> [Tue Aug 5 11:03:33 2025] smb2_verify_signature+0x178/0x290 [cifs]
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_smb2_verify_signature+0x10/0x10 [cif=
s]
> >> [Tue Aug 5 11:03:33 2025] ? look_up_lock_class+0x5d/0x140
> >> [Tue Aug 5 11:03:33 2025] smb2_check_receive+0x154/0x1c0 [cifs]
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_smb2_check_receive+0x10/0x10 [cifs]
> >> [Tue Aug 5 11:03:33 2025] ? __lock_acquire+0x3f1/0x21c0
> >> [Tue Aug 5 11:03:33 2025] ? __lock_acquire+0x3f1/0x21c0
> >> [Tue Aug 5 11:03:33 2025] smb2_writev_callback+0x1f2/0x870 [cifs]
> >> [Tue Aug 5 11:03:33 2025] ? lock_acquire+0x143/0x2d0
> >> [Tue Aug 5 11:03:33 2025] ? mid_execute_callback+0x19/0x40 [cifs]
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_smb2_writev_callback+0x10/0x10 [cifs=
]
> >> [Tue Aug 5 11:03:33 2025] ? do_raw_spin_lock+0x10c/0x190
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_do_raw_spin_lock+0x10/0x10
> >> [Tue Aug 5 11:03:33 2025] ? _raw_spin_unlock+0x23/0x40
> >> [Tue Aug 5 11:03:33 2025] mid_execute_callback+0x33/0x40 [cifs]
> >> [Tue Aug 5 11:03:33 2025] cifs_demultiplex_thread+0xc95/0x15e0 [cifs]
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_cifs_demultiplex_thread+0x10/0x10 [c=
ifs]
> >> [Tue Aug 5 11:03:33 2025] ? find_held_lock+0x2b/0x80
> >> [Tue Aug 5 11:03:33 2025] ? __kthread_parkme+0x4b/0xd0
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_cifs_demultiplex_thread+0x10/0x10 [c=
ifs]
> >> [Tue Aug 5 11:03:33 2025] kthread+0x216/0x3e0
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_kthread+0x10/0x10
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_kthread+0x10/0x10
> >> [Tue Aug 5 11:03:33 2025] ? lock_release+0xc4/0x270
> >> [Tue Aug 5 11:03:33 2025] ? rcu_is_watching+0x20/0x50
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_kthread+0x10/0x10
> >> [Tue Aug 5 11:03:33 2025] ret_from_fork+0x23a/0x2e0
> >> [Tue Aug 5 11:03:33 2025] ? __pfx_kthread+0x10/0x10
> >> [Tue Aug 5 11:03:33 2025] ret_from_fork_asm+0x1a/0x30
> >> [Tue Aug 5 11:03:33 2025] </TASK>
> >>
> >> (it worked without the patch see e.g.
> >> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builde=
rs/5/builds/60
> >> and http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/bu=
ilders/5/builds/56)
> >>
> >> On Tue, Aug 5, 2025 at 1:54=E2=80=AFAM Wang Zhaolong
> >> <wangzhaolong@huaweicloud.com> wrote:
> >
> >
> > It's quite strange that the lock reported in the stack trace is an inte=
rnal
> > lock of the crypto module, which only protects the internal logic of cr=
ypto.
> > Moreover, I have not yet found a path where the callback for cifs regis=
tration
> > is executed within the scope of this lock.
> >
> > ```c
> > // crypto/api.c
> > static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
> >                          u32 mask)
> > {
> >      const u32 fips =3D CRYPTO_ALG_FIPS_INTERNAL;
> >      struct crypto_alg *alg;
> >      u32 test =3D 0;
> >
> >      if (!((type | mask) & CRYPTO_ALG_TESTED))
> >          test |=3D CRYPTO_ALG_TESTED;
> >
> >      down_read(&crypto_alg_sem);
> >      ...
> >      up_read(&crypto_alg_sem);
> >      return alg;
> > ```
> > More information is needed to confirm this issue. Could you please prov=
ide it?
> >
> > Best regards,
> > Wang Zhaolong
> >
>
>
>
>


--=20
Thanks,

Steve
