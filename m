Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F1B622
	for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 00:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710117154; cv=none; b=oFuaX1wdrA4KLLz9U2JyjEEepOr1vA4lzXkJKcpetORRy8pru1Ef1QZTJmYdHGBLrHlXRIYQpIARrAyYh8eAV03PUcxE1w55vgr5IJaBppskBz9ORductFoxLb2F2+rKI8ktwqN1dG2SIjmBcnPgQ9ubHm2L7zD4W9CN3H/BGb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710117154; c=relaxed/simple;
	bh=WOwpUEauuVLi+7eahe2WrkCJM4XNYaOaJUNE5Mxq0JM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HurpeBEbNxUyixA2HnMcLDuskxMDP1Wj1HfDAQHPotRfxBCIxyHyS+kggstgrL1iOu7/RtvrqnUEb8jXprd93b2hLzkANznupXjjvwr1NAmNUQ8Bmkzlhb2BFaxVHRiq75KQG7yeXJm4CegFBlwMyZXin2mJ8hCNe5wDNm84PcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dedMIdHm; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dedMIdHm"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-512e39226efso3722784e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 10 Mar 2024 17:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710117150; x=1710721950; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Xzkt4z+GZTkT1z0vZgrtf+//l24+W8StzgGU3OcpII=;
        b=dedMIdHmD3HeDMhnv25/H8gW+WFBizpaAU0RINaK8QcVTYpJDdyPKcUNi7gQ9qYcjP
         aOn5VFUTvIPIOgkpXywgeMZwjNdZImRnbE2klQ95wwzYaXbt7mU74yJ22ARMqUf19NV4
         hBA3jr399BHZRUTsOvlZnfDirIG39JjjkBpFOLvaDwLx8y76UneXANd2YLrWxoy0p4Ut
         A+N6peQ4EnNKvHOFDXx3Fm83vGqqnA8teR//BB8gzNkCXE3gzde8/rDIWpLv3q5qiJLV
         DwXgX0MNWc8KQjIbT2OvjP8S3I3HAoH12eQ5YLFGhJb1RJNl4XhSbkSE+lTyFijOUbXp
         5E7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710117150; x=1710721950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Xzkt4z+GZTkT1z0vZgrtf+//l24+W8StzgGU3OcpII=;
        b=KmhRyRVndFnOq+suBf/hgO2HsN78OyzCY0YVY9cN2nkqXtVcRpN/q21AEAIpjKpGXy
         vALcMYsLnKHSxRO8WrXjztvZfzW71O/5a69hnsU35DQe0VntTYON0gB1N+52NeMGaMiV
         Rp+jzJWuCbnDRUPX7pkUp7vzeJSoYdtsdOmJ8HZbdCzf96K3MDWzVZbor8lvL9hIE82C
         3t2CGgi5qHgqJZKXfpxRy93cQosutDy0DxaAv2lYUWaj+TmPSx7oLBB08WRvQIHb3/aK
         CL9STspYEYPvnMz7cKV8m1iPZ/tTY/WKi+TO2JVIRFpyWi4eHwHONdt4Jughr2RLKlXl
         MHRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtamueRMwU+n0E1xzKTOvq1hjyfxJ/fH+XnqRQm/mZ5QamhBGFcI53C0BDiEYW2038VzThOMYvJxe+osQVtCV+3hVqTrYKkzMNcA==
X-Gm-Message-State: AOJu0Yz7LM7wOfKKARjIzsY0Sgqc9hFuzeS5Y9qakPS1GQMF8QTpbT/D
	QjPANJroqQKWBP3eMnk55A/ow2Jt9nuj3l5U8bgM1SEKxH/0kBzZYS6ke9gGHADwV4/MjDntmo6
	CzNexL8e1uYAHYp8gSzvsAmANWno=
X-Google-Smtp-Source: AGHT+IESIXfvIXH+2hLGYxCFPbtrB5B5SfU4cWd26Uj9TJBo28pTb75tdUZLEC43BwllUQMbl8jC61hDc2HFuh6uyK8=
X-Received: by 2002:a19:640c:0:b0:513:172d:5b46 with SMTP id
 y12-20020a19640c000000b00513172d5b46mr3225847lfb.39.1710117149849; Sun, 10
 Mar 2024 17:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226045010.30908-1-bharathsm@microsoft.com>
 <CAH2r5msYJncggqkeNQRceNhcnQ1_BdYiQw9mw7fLogHfm8AySw@mail.gmail.com>
 <CAGypqWzZoQZW4=EK_bCAORMXmw1+bdA7icptFEQCge05rrB14g@mail.gmail.com>
 <CAGypqWx9JwO5nz-S+Yr8kw3UBsZPk5n0hiwzGa632pm_f1zpWA@mail.gmail.com>
 <CAGypqWx8x=q_srJLp7w1ygn0kgfTD8s_VP3wPyqp6mh3APoO6g@mail.gmail.com> <CANT5p=od_C0TLHN5yURa+baQzj4H1AscX0jDs+weWMH4mSYp0Q@mail.gmail.com>
In-Reply-To: <CANT5p=od_C0TLHN5yURa+baQzj4H1AscX0jDs+weWMH4mSYp0Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 10 Mar 2024 19:32:18 -0500
Message-ID: <CAH2r5mtvkekMB61pbVu8fmnOrAoY5MrHS_5cU=MYQCOdpBniBQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: prevent updating file size from server if we have a
 read/write lease
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, pc@cjr.nz, sfrench@samba.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, bharathsm@microsoft.com, 
	ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 5, 2024 at 3:41=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
>
> On Thu, Feb 29, 2024 at 11:23=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.=
com> wrote:
> >
> > Attached updated patch.
> >
> > On Thu, Feb 29, 2024 at 11:22=E2=80=AFPM Bharath SM <bharathsm.hsk@gmai=
l.com> wrote:
> > >
> > > minor update to resolve conflicts.
> > > And Cc: stable@vger.kernel.org
> > >
> > > On Wed, Feb 28, 2024 at 3:57=E2=80=AFPM Bharath SM <bharathsm.hsk@gma=
il.com> wrote:
> > > >
> > > > Attached updated patch to have this fix only for calls from readdir
> > > > i.e cifs_prime_dcache.
> > > >
> > > > On Mon, Feb 26, 2024 at 10:44=E2=80=AFAM Steve French <smfrench@gma=
il.com> wrote:
> > > > >
> > > > > My only worry is that perhaps we should make it more narrow (ie o=
nly
> > > > > when called from readdir ie cifs_prime_dcache()  rather than also
> > > > > never updating it on query_info calls)
> > > > >
> > > > > On Sun, Feb 25, 2024 at 10:50=E2=80=AFPM Bharath SM <bharathsm.hs=
k@gmail.com> wrote:
> > > > > >
> > > > > > In cases of large directories, the readdir operation may span m=
ultiple
> > > > > > round trips to retrieve contents. This introduces a potential r=
ace
> > > > > > condition in case of concurrent write and readdir operations. I=
f the
> > > > > > readdir operation initiates before a write has been processed b=
y the
> > > > > > server, it may update the file size attribute to an older value=
.
> > > > > > Address this issue by avoiding file size updates from server wh=
en a
> > > > > > read/write lease.
> > > > > >
> > > > > > Scenario:
> > > > > > 1) process1: open dir xyz
> > > > > > 2) process1: readdir instance 1 on xyz
> > > > > > 3) process2: create file.txt for write
> > > > > > 4) process2: write x bytes to file.txt
> > > > > > 5) process2: close file.txt
> > > > > > 6) process2: open file.txt for read
> > > > > > 7) process1: readdir 2 - overwrites file.txt inode size to 0
> > > > > > 8) process2: read contents of file.txt - bug, short read with 0=
 bytes
> > > > > >
> > > > > > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > > > > > ---
> > > > > >  fs/smb/client/file.c | 3 ++-
> > > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> > > > > > index f2db4a1f81ad..e742d0d0e579 100644
> > > > > > --- a/fs/smb/client/file.c
> > > > > > +++ b/fs/smb/client/file.c
> > > > > > @@ -2952,7 +2952,8 @@ bool is_size_safe_to_change(struct cifsIn=
odeInfo *cifsInode, __u64 end_of_file)
> > > > > >         if (!cifsInode)
> > > > > >                 return true;
> > > > > >
> > > > > > -       if (is_inode_writable(cifsInode)) {
> > > > > > +       if (is_inode_writable(cifsInode) ||
> > > > > > +                       ((cifsInode->oplock & CIFS_CACHE_RW_FLG=
) !=3D 0)) {
> > > > > >                 /* This inode is open for write at least once *=
/
> > > > > >                 struct cifs_sb_info *cifs_sb;
> > > > > >
> > > > > > --
> > > > > > 2.34.1
> > > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
>
> Changes look mostly good.
>
> >>  return true;
> >>
> >>- if (is_inode_writable(cifsInode)) {
> >>+ if (is_inode_writable(cifsInode) ||
> >>+ ((cifsInode->oplock & CIFS_CACHE_RW_FLG) !=3D 0 && from_readdir)) {
> >>  /* This inode is open for write at least once */
> >>  struct cifs_sb_info *cifs_sb;
>
> Why not use CIFS_CACHE_READ(cifsInode) || CIFS_CACHE_WRITE(cifsInode)
> instead of just checking the flag?
> That will cover other cache modes where attrs cannot change outside the c=
lient.

I think Bharath's version is safer since if you did CIFS_CACHE_READ
check you would be adding a case where you mounted read-only (and in
that case it looks confusing to allow write size to be updated
locally).   It may also be a little risky to allow this when no you
were not able to get a lease from the server and are mounting in
"singleclient" mode.

--=20
Thanks,

Steve
