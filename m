Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A7217648
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 04:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762576140; cv=none; b=j8detX8HqLsw5j1htx3Sh/k1/D39hupwvG1XJ2H0viItF+pkbnrn00EXvFqSknSDvAO+C5KObiWNJn8acqQNhefgZJjwTTfdJZDJO8pHd2cPxmJwOwr57OpxGo1mJOVud+MmV6s+Sfb3NWu8OaH9GfDHSOZkgj02x2+GgzApygQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762576140; c=relaxed/simple;
	bh=4t66ZklcM0GbPz3oTmZf4siPUHS7sG5MIqEId4RBHqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rhnVZzNHvVT3aF9/WBPKpFFeuZMKN7DGw2VXeFwLaC9XhPK/T2UABXfv2Zi8HZ8ACDYb8482AWUJqVSiGvGD4TKsyy341leCm8u2jWhm8iwxyr6dcCfYd5QZo3/8ba5AJaST6egsb9pduyB04EroKAsbUY6C9HYGt0S19PaO1NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N0N6dF7v; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N0N6dF7v"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b728a43e410so309068766b.1
        for <linux-cifs@vger.kernel.org>; Fri, 07 Nov 2025 20:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762576137; x=1763180937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KO4XlPxpyr6A6CDUplPXQkHQJ9QmhDHMaWGNSWYd/48=;
        b=N0N6dF7vdL++8H3DDfC6CLGQmAxEpUHVqn1aayFfpctZWBAIfmws3akYi/IHdfRwhB
         T5oPSYWSlNCuAM8w0ZJlB5SosRGGSLn/8uMJyA276eaIS7jiHlcuHtHnnM/tFIyAhX8L
         ixZlw5uJlUSng3L2y1UQg4S+4hX5+46UlAMpqNbt12fwe6+Ah2JrstK0sp7H3E23hN/+
         IdLuSBzcjjB8+HZ7psmzohGa8eNOd/wijgSY1gfrBRh4vnjTcRRUC2hgK6uK6luiSm2o
         fLJtGBvQ8CUD8VsInZULj8/UEuUVjQUX+miKQTfkj2Nf9/NOUVnngjvpcLr3wWhqVrvG
         mlFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762576137; x=1763180937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KO4XlPxpyr6A6CDUplPXQkHQJ9QmhDHMaWGNSWYd/48=;
        b=MBColxCOAvpODguq1mYewZabVHITqDsavGnsi+sI5Ok62lQi0dVHq8oorJEPlYUzqb
         AJhVs/+AFbWffIN19gzUMLVM/q4CaChCMJEdZQxNliU5KzJEDUbKgyUwqpelf4GnaTZV
         2TVfWpPbVkQBb/mpkUVho6HbdQK/DPhj18tnaB/5M529T/veGfFVnGV/qqaAKyRyAy+A
         ngHeo0NNBpCoNapR00v+Hyl91OHnoO8MskTw4tZL69R+nq3NkolU0q1mhFw70BnB35+w
         fuxK3r6Wlsr9ly5jXuJ2wBFFaK0jvXQ64Xx9y9HBJfkWDicTbm+eBCmceBaIeu/NuruN
         pWDg==
X-Forwarded-Encrypted: i=1; AJvYcCUk77C9MC6GVHJrn78+Xgb9YLrFjZckC7h9QskyW/HZjZnED/7VCc0qQMTWVe7BzurTzjzIfz62Hu86@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt5Kp5M9xmgNyz/F+RLrJ9FXmTh6Kpl5GKef5tADbTzxteZ/l+
	TmcaqEu99L0KmbDpjQtuZZjHTU4b2B3cjsDj4n8Benm98qh2x3eizua1YecZONSUKg0bZSYEMIm
	U1SAYBnU0JtK5Ypq1Xc8YiSyNENPhDlg=
X-Gm-Gg: ASbGnctFqaHINaBYz/8tGHQLQCIiKMO4wDmr0rhb1K6++MwawkSj9Fvp1MHbJoQsxGm
	fJxkpvywmQunneii88cA9Dz2X/Y6C+FXPiEajnWxzJtRiPxV4OuJBORPl1VAfE9c44ITXX9o4T3
	U1reIMVjnGHXAVky+DzewVdm24Uf5lFu8U7AQ5EYw0O+eY1weTup0Ip7XujM5TpPsSXHVmlZ3jX
	3jdhzqnmMA0hlZqzeygRPYLCcDcGpneihVafhFhBPr/sUTgOqCak0faMMp1KVLpZ8y8kQ==
X-Google-Smtp-Source: AGHT+IGrMxHCCDZvCnZIYxC8OlI5J6aNsXhuWL7dXVFTt9tofuSFasRc4eGE7nHVxUSZrLRJk0lUZkNzkkPL/JdP2IM=
X-Received: by 2002:a17:907:9706:b0:b40:5752:16b7 with SMTP id
 a640c23a62f3a-b72e05e83c3mr158113866b.51.1762576137173; Fri, 07 Nov 2025
 20:28:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <690da014.a70a0220.22f260.0026.GAE@google.com> <tencent_5D8667DBC6ECD2FF464349ADEEFD2EE84C06@qq.com>
 <f25e47415998a9d9360ac87eca7292a2@manguebit.org> <CAH2r5mvRrFmZFtNaQuRFHy2mVM1AG1AnsNwZMOoT=w8LZaLX4Q@mail.gmail.com>
In-Reply-To: <CAH2r5mvRrFmZFtNaQuRFHy2mVM1AG1AnsNwZMOoT=w8LZaLX4Q@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 8 Nov 2025 09:58:46 +0530
X-Gm-Features: AWmQ_blo19sY8oI4byZVSAxpSm_eal3zwPqIUf3DK2UfzTSBtaRF2CJoGUN1P1A
Message-ID: <CANT5p=pC2JShLzXPJG5imWTJBRfXheZeqBhMSpXuOw3rBkRxEw@mail.gmail.com>
Subject: Re: [PATCH] cifs: client: fix memory leak in smb3_fs_context_parse_param
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Edward Adam Davis <eadavis@qq.com>, 
	syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com, 
	linux-cifs@vger.kernel.org, sprasad@microsoft.com, 
	syzkaller-bugs@googlegroups.com, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, sfrench@samba.org, bharathsm@microsoft.com, 
	tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 8, 2025 at 4:52=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> merged into cifs-2.6.git for-next pending additional testing.
>
> Also added Cc:stable tag
>
> On Fri, Nov 7, 2025 at 8:52=E2=80=AFAM Paulo Alcantara via samba-technica=
l
> <samba-technical@lists.samba.org> wrote:
> >
> > Edward Adam Davis <eadavis@qq.com> writes:
> >
> > > The user calls fsconfig twice, but when the program exits, free() onl=
y
> > > frees ctx->source for the second fsconfig, not the first.
> > > Regarding fc->source, there is no code in the fs context related to i=
ts
> > > memory reclamation.
> > >
> > > To fix this memory leak, release the source memory corresponding to c=
tx
> > > or fc before each parsing.
> > >
> > > syzbot reported:
> > > BUG: memory leak
> > > unreferenced object 0xffff888128afa360 (size 96):
> > >   backtrace (crc 79c9c7ba):
> > >     kstrdup+0x3c/0x80 mm/util.c:84
> > >     smb3_fs_context_parse_param+0x229b/0x36c0 fs/smb/client/fs_contex=
t.c:1444
> > >
> > > BUG: memory leak
> > > unreferenced object 0xffff888112c7d900 (size 96):
> > >   backtrace (crc 79c9c7ba):
> > >     smb3_fs_context_fullpath+0x70/0x1b0 fs/smb/client/fs_context.c:62=
9
> > >     smb3_fs_context_parse_param+0x2266/0x36c0 fs/smb/client/fs_contex=
t.c:1438
> > >
> > > Reported-by: syzbot+72afd4c236e6bc3f4bac@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3D72afd4c236e6bc3f4ba=
c
> > > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > > ---
> > >  fs/smb/client/fs_context.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> >
> > Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> >
>
>
> --
> Thanks,
>
> Steve
>

Looks good to me.
Steve, this is one of the mount options that is missing in the man page.
Also, I don't understand this option. Why is it needed? Don't we
specify the source in the mount command as devname anyway?

--=20
Regards,
Shyam
