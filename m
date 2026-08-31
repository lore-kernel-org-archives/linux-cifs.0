Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C74133B6F8
	for <linux-cifs@vger.kernel.org>; Mon, 31 Aug 2026 10:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788172694; cv=none; b=mw5P7qXQV7e2vbUwoa+xWANR92BTblVtp4umxEhAvD0GWzKiIYteekOgXR+Dz2IlQ33FBRyzx/5NBFuvEEdPWGtd2iguskySOi9prqwf7PPzr4oMuIB3DnZLDQ/RZjP6Uk0JQmHJi6BiwzJTKKYNv2SEBgApW75bFIvLALhZyGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788172694; c=relaxed/simple;
	bh=vQy4xbSA3XJEmAKtO2L0l4HYxsca7+w4X9EglAe26J0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tgLoy0cNXkMkL48Uknof9JfLQHau5uZsz5jNphzweMZcdoZi5XVoK5+B/TAbRRYlFugKF6xr/PKNRonVj6IdiaBStc1vcLd50ZFE/m9fTo36d/+ucMUUHl0grZU0pzzEfNdnWg4lZK2uENRS0jkGDgjOaFDiu11XqvHXJPB1uRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ms3cQT+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ms3cQT+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196D21F00A3F
	for <linux-cifs@vger.kernel.org>; Mon, 31 Aug 2026 10:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788172693;
	bh=Zhz4xDEOf4LsvTmmwIdC3GdkF3FmixQ6AY9sdraEaV0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ms3cQT+e1OyZ9PYC257sGo8WSn7MZR5c8L8Onkl7l1WMt2bUXHIMA1OuJO26JsVly
	 yrElriXcRxcCCyzeExJihIyKRew+anO9lLs/qhKyDXm6OCRcKPIyodS/uO13VWt1BZ
	 ju/cMmlKUpESm2ZkwM4uOGtU6Mc5vVKVWj54vE8lprqJj1JUXNoBZnnzdovqik1WQ0
	 +yjrbzhm6JG5wOaisG2MPJVgIp/Cor5N5K0d+aSCnGCPCIaDALw6rEW/mhYtTe3TPS
	 jrLiTeRZNLBdiQMnPr8YhjDQmeuVFW/CFEsJRbbjQAG04G4RvFiKmMH/3dYAUu1iAB
	 DdE+mdGopBjGg==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a601ba6870so4948849a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 31 Aug 2026 03:38:13 -0700 (PDT)
X-Gm-Message-State: AFuF++kETo50tEa8Ybx+l8qWQGd7EfJn7inlCtxFXq1Q4V48d06g9M+k
	JTPYPYZa0paGnmVaCOE2tAKxyCA/kVYopaW7/tBk97FCi08X1H0pfOx173bGaUEC6BA2Om2h+Pf
	klfCfNsbLvWOF2RTnuZnAJFXaqCKrdqU=
X-Received: by 2002:a05:6402:5414:b0:6a6:32f6:b with SMTP id
 4fb4d7f45d1cf-6a632f6019amr7535714a12.17.1788172691700; Mon, 31 Aug 2026
 03:38:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260829113917.26882-1-suruurism@gmail.com> <CAKYAXd-PDvGyUc7834fVGAvDGnqaOxcrJE6XXMF22eLS5=dzLw@mail.gmail.com>
 <CAFkjbpD7BrK3xtG6m7d3QAuLN4xO-VG5UPF81obBGjREgVy0pg@mail.gmail.com>
In-Reply-To: <CAFkjbpD7BrK3xtG6m7d3QAuLN4xO-VG5UPF81obBGjREgVy0pg@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 31 Aug 2026 19:37:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-RVbV4iWcnZoJ4ePE_mDHCSsDCNV8Ovi68c39pd8rAEw@mail.gmail.com>
X-Gm-Features: AcwNN1U_hN_rcmqVukdlDKDw6-vass8yxQCdHN0RWMsrpaI_cJYoNLGFJFgwxlM
Message-ID: <CAKYAXd-RVbV4iWcnZoJ4ePE_mDHCSsDCNV8Ovi68c39pd8rAEw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix use-after-free in oplock break notification
To: Suruur <suruurism@gmail.com>
Cc: linux-cifs@vger.kernel.org, senozhatsky@chromium.org, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 30, 2026 at 1:01=E2=80=AFAM Suruur <suruurism@gmail.com> wrote:
>
> Hi Namjae,
>
> On Sat, Aug 29, 2026, Namjae Jeon wrote:
> > > +
> > > +static inline struct ksmbd_inode *ksmbd_inode_ref(struct ksmbd_inode=
 *ci)
> > > +{
> > > +       atomic_inc(&ci->m_count);
> > Using m_count to pin o_ci breaks delete-on-close. The last file close
> > will no longer drop m_count to zero, so __ksmbd_inode_close() can skip
> > unlinking a delete-pending file.
>
> You're right, thank you. Holding the extra m_count reference until the
> oplock_info is RCU-freed delays the drop to zero that
> __ksmbd_inode_close() keys the delete-on-close unlink on, so a
> delete-pending file opened with an oplock would never be unlinked.
>
> v3 drops the inode reference entirely. The notification path does not
> need one: every caller of oplock_break() already holds a live
> ksmbd_file (or an explicit ksmbd_inode_lookup_lock() reference in the
> parent lease break paths) on the inode that owns the break target's
> oplock list, so ci is pinned for the duration of the call. The
> caller's inode is threaded through oplock_break() into
> smb2_oplock_break_noti(), which takes ci->m_lock to select and pin the
> connection without ever dereferencing opinfo->o_fp.
>
> opinfo->conn is updated under ci->m_lock by both session_fd_check()
> (clear on disconnect) and ksmbd_reopen_durable_fd() (reassign
> reconnect), so holding the read lock also prevents the oplock's
> connection reference from being dropped while the notification
> it - the same shape as the lease fix in commit 3a98de41b0a4d.
>
> Please see the v3 patch attached.
Applied it to #ksmbd-for-next.
Thanks!
