Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822264CB2E
	for <linux-cifs@vger.kernel.org>; Tue,  5 Mar 2024 09:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709631675; cv=none; b=LFX9xnQXYtcz5P/Z1sd0DG/0xXpigp3xhIIjEP6m0fzy4g61o5BjAmlT4g7Wkl106U5SwNWEml2fJwJldxP2AQjUTcK+Lzuzxfz0zl4cEZ4sGmn33xaT86SXKfVBopNL6RnaEJIWqiPKC4ZzaanHOoRKiA5/7wLu3IiwN7a0cxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709631675; c=relaxed/simple;
	bh=gRHH3V62QPwKWcGUbzkHAlnzLX7hbDqGgL8k6Aex7vw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=prATQJ26bFYtzsBANPIGwwh9ZVQmXcgq5zRgW1lLLjSK8hWPIevo7iLJn6qV5wILtyoxHi8fCtwexDGFGDMfKDR+gW8mWQUu+UtEDAruYAL1fsqidVgulEUSWkJlJ8z4j7EqMAkagAC9NIt3e1tc7uUObp/KTeW1sJuth1TF+pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eOO69iSm; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eOO69iSm"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-51323dfce59so4751359e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2024 01:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709631672; x=1710236472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71BtM3KkGcWx6g48GMmx8wYUNQH/aSmhgiyjNIINtbw=;
        b=eOO69iSmj676lwcxBiQnI27f7R+OBiybQS4p0gKqnv2VJWiay+Gfz4/sKtDkaPWdZK
         ANcafOCycKuK1N9GJwN4dWlZiSkQipTng4pmWOipLTcx2Vqg0G5EUIyRLw4QvFGkXIqI
         a/wVuZwga7BL8Xhtupe6behqvSdShxyxt4bnfZVTGaPMEJqvmNaaJC4EhkH3wTNxkjX7
         CFw8PQ01daLBeyj1TXAQ6B5OnnZlhBLpOKkDQCfRDS6rIsaTp2p1pvCtxdnS6223gtz/
         xnHoyNuNrujdtYMGurKYo4c09OHRuTAA6lz5tmLTWxz+fOnKVfFeJUHpiGNoq3ieNXk2
         GBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709631672; x=1710236472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=71BtM3KkGcWx6g48GMmx8wYUNQH/aSmhgiyjNIINtbw=;
        b=YOFc3CnHfhJlGwoBgbON0Vn4fFU+EC5EkmCeZs7zczPnoVYCDvMdV8gnJlT5azE30A
         esRVaYwxT9S54OpcIC5kypN5+fFZUog/xAvW7rp9fG+Ri6u+Tfsipsy3vm+oipQvrJQq
         uVJM0JoAUdX88YIegUeJkpYi3JJQmB8y35LQivajWRaGSv63wa/VH7iknuQRF98MK1Av
         cSZ5EARX5KnQpbkQUvDbmkYmNHLxjQRVEznLYeXnpC9n/E1Stdq6XhU9PqbxPJ1O5oXF
         nkPGZIvKO9c3JuEW/x8OMvHXc82omfzwsGkgNC1c34D6NramjNDv5cc2p5dDy/UJvOdh
         8GsA==
X-Forwarded-Encrypted: i=1; AJvYcCXGW0Vm4gyWAQ32mUV7OM+ZKhexkZgXcIKqtaEzSKp+CWEVm9yu8P607wDVxBxY0fcbEJ1bKAjbgOHxVKzs9MMrU0Vb1q5+Yn/FOw==
X-Gm-Message-State: AOJu0YyvNoU3q0Hzc2AlDvWkSWvp3bnGDoqgwWcPYWJTDUPdVtWm4V4j
	nXbeG4Z8XxBOF9qw8GRHmJUDT9OExpasLsYf1LG1fu1gUOeVyxooRAic2TVZUMcTGgrz3tI00zj
	w93COKbQrlf4d9wPXs3JC8vBnkqpmuygR0SY=
X-Google-Smtp-Source: AGHT+IE/YUBuIUu+S7iYbPqivftfIOdYrMNaQZs7tJGbwpfTy/Zq7la0FtyItmiByuEkS5rZQ1inLqTQ2OE4tg9hDU0=
X-Received: by 2002:a05:6512:2c99:b0:513:3fa6:efe3 with SMTP id
 dw25-20020a0565122c9900b005133fa6efe3mr1131120lfb.8.1709631671348; Tue, 05
 Mar 2024 01:41:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226045010.30908-1-bharathsm@microsoft.com>
 <CAH2r5msYJncggqkeNQRceNhcnQ1_BdYiQw9mw7fLogHfm8AySw@mail.gmail.com>
 <CAGypqWzZoQZW4=EK_bCAORMXmw1+bdA7icptFEQCge05rrB14g@mail.gmail.com>
 <CAGypqWx9JwO5nz-S+Yr8kw3UBsZPk5n0hiwzGa632pm_f1zpWA@mail.gmail.com> <CAGypqWx8x=q_srJLp7w1ygn0kgfTD8s_VP3wPyqp6mh3APoO6g@mail.gmail.com>
In-Reply-To: <CAGypqWx8x=q_srJLp7w1ygn0kgfTD8s_VP3wPyqp6mh3APoO6g@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 5 Mar 2024 15:10:59 +0530
Message-ID: <CANT5p=od_C0TLHN5yURa+baQzj4H1AscX0jDs+weWMH4mSYp0Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: prevent updating file size from server if we have a
 read/write lease
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: Steve French <smfrench@gmail.com>, pc@cjr.nz, sfrench@samba.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, bharathsm@microsoft.com, 
	ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024 at 11:23=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
>
> Attached updated patch.
>
> On Thu, Feb 29, 2024 at 11:22=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.=
com> wrote:
> >
> > minor update to resolve conflicts.
> > And Cc: stable@vger.kernel.org
> >
> > On Wed, Feb 28, 2024 at 3:57=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail=
.com> wrote:
> > >
> > > Attached updated patch to have this fix only for calls from readdir
> > > i.e cifs_prime_dcache.
> > >
> > > On Mon, Feb 26, 2024 at 10:44=E2=80=AFAM Steve French <smfrench@gmail=
.com> wrote:
> > > >
> > > > My only worry is that perhaps we should make it more narrow (ie onl=
y
> > > > when called from readdir ie cifs_prime_dcache()  rather than also
> > > > never updating it on query_info calls)
> > > >
> > > > On Sun, Feb 25, 2024 at 10:50=E2=80=AFPM Bharath SM <bharathsm.hsk@=
gmail.com> wrote:
> > > > >
> > > > > In cases of large directories, the readdir operation may span mul=
tiple
> > > > > round trips to retrieve contents. This introduces a potential rac=
e
> > > > > condition in case of concurrent write and readdir operations. If =
the
> > > > > readdir operation initiates before a write has been processed by =
the
> > > > > server, it may update the file size attribute to an older value.
> > > > > Address this issue by avoiding file size updates from server when=
 a
> > > > > read/write lease.
> > > > >
> > > > > Scenario:
> > > > > 1) process1: open dir xyz
> > > > > 2) process1: readdir instance 1 on xyz
> > > > > 3) process2: create file.txt for write
> > > > > 4) process2: write x bytes to file.txt
> > > > > 5) process2: close file.txt
> > > > > 6) process2: open file.txt for read
> > > > > 7) process1: readdir 2 - overwrites file.txt inode size to 0
> > > > > 8) process2: read contents of file.txt - bug, short read with 0 b=
ytes
> > > > >
> > > > > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > > > > ---
> > > > >  fs/smb/client/file.c | 3 ++-
> > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > > > > index f2db4a1f81ad..e742d0d0e579 100644
> > > > > --- a/fs/smb/client/file.c
> > > > > +++ b/fs/smb/client/file.c
> > > > > @@ -2952,7 +2952,8 @@ bool is_size_safe_to_change(struct cifsInod=
eInfo *cifsInode, __u64 end_of_file)
> > > > >         if (!cifsInode)
> > > > >                 return true;
> > > > >
> > > > > -       if (is_inode_writable(cifsInode)) {
> > > > > +       if (is_inode_writable(cifsInode) ||
> > > > > +                       ((cifsInode->oplock & CIFS_CACHE_RW_FLG) =
!=3D 0)) {
> > > > >                 /* This inode is open for write at least once */
> > > > >                 struct cifs_sb_info *cifs_sb;
> > > > >
> > > > > --
> > > > > 2.34.1
> > > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve

Changes look mostly good.

>>  return true;
>>
>>- if (is_inode_writable(cifsInode)) {
>>+ if (is_inode_writable(cifsInode) ||
>>+ ((cifsInode->oplock & CIFS_CACHE_RW_FLG) !=3D 0 && from_readdir)) {
>>  /* This inode is open for write at least once */
>>  struct cifs_sb_info *cifs_sb;

Why not use CIFS_CACHE_READ(cifsInode) || CIFS_CACHE_WRITE(cifsInode)
instead of just checking the flag?
That will cover other cache modes where attrs cannot change outside the cli=
ent.

Once this change is done, you can add my RB.
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

--=20
Regards,
Shyam
