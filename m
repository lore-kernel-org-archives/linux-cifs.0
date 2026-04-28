Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D573FBED1
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 12:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777378643; cv=none; b=UGHgDccFWHt8qiRjzG3naIZb4foXtzc+RM4brEJXyeuD8wRDl77KqsezG/7q4xhwDONVGi3KgAnLAfEz01qH0V1i30ufMXJtDweGf1CWdWOA6laovTlhv8FyEzTpiKAGYbRKL5nseO1rqBOATEO+KYSoxVFcny/hpWotdwfBMGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777378643; c=relaxed/simple;
	bh=XEnlX8gB6ZWE/bT/js/AgXMoq504G3c6wuFFFXXNrog=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tXSh3jUPYODAQbEZzSba2JYzDD2s6wcYkVC/CfLikLmEt1Xx053Vlt6iVDgkE6GJ7vWj6xXh1Cu6dqQge+AD57jqaDbFufES3nX94QfFKJBR9AiqXfQUa7vE4TTXVE3VywpaKmYgnw8i710VrRuWjngGqZVjSCBZkaGt1LxbAtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zx9nQII7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zx9nQII7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B194CC2BCB7
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 12:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777378641;
	bh=XEnlX8gB6ZWE/bT/js/AgXMoq504G3c6wuFFFXXNrog=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Zx9nQII7l3e8fCrHI9BSM3QzEJLKhr38x8p44brJyzMDxxap6WzNkWMy6JXhK3/eo
	 MhNy1L9tmqNN66+43xNPWAfpfJeLoxbGopufQg68hTr7fhDTNTANx1C5umJteenDbP
	 CBc9HjKmbMuIzripwfHWZpxJmZc3ZdfpCR4eSi/bdyWueKEDt9b+PWjXUSObYk092F
	 TGuNYDb+SPpaQSdoQA8NBwZKFMHQlg8HeVkCS4K6ELDlaNM71nrpsAgt0ayvQkIevP
	 /4FXeV9OcOLj76MKZb+hiP1dX+KOt+1rXBq6qSBIhMSbGp9Akj7Gjej+tTARzor6yv
	 7eGyOWzYe90/w==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-671d60ef9c6so15679039a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 05:17:21 -0700 (PDT)
X-Gm-Message-State: AOJu0YwkTpKHIUiCyku0WoSTXpqVp3hoV1ALLV5uZGvXYqKg1clzAW3T
	pVhmdQAMd0TsknEjv05ANy294ZDFC6ehoE8/0V7pt1/07pqM00NX+Rhzs6FAApLJ6o+Jnwe0Enj
	Ni99eHZym7spuKukwyuPzIwBx882Veok=
X-Received: by 2002:a05:6402:34ca:b0:671:a228:a403 with SMTP id
 4fb4d7f45d1cf-679bb095ffemr1388730a12.17.1777378640242; Tue, 28 Apr 2026
 05:17:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422105010.2600337-2-mmakassikis@freebox.fr>
 <CAKYAXd_FRpqjTcxbBsLcZATT9GmGmVF-g8JkF_9dwretGA0rpA@mail.gmail.com> <CAF6XXKXD-dKoQV2AP+7WYc6CKJWqsC0MYYqJyncoD20YXdx0vA@mail.gmail.com>
In-Reply-To: <CAF6XXKXD-dKoQV2AP+7WYc6CKJWqsC0MYYqJyncoD20YXdx0vA@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 28 Apr 2026 21:17:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8s64Aq5f_jNnmKC6E552egGYptVaGisq33s-zbz2=1ag@mail.gmail.com>
X-Gm-Features: AVHnY4KBQuzrpHJy-sxN5WZCuriPNISvM_jKZXMcQXV8o7nVu-P9eRxy76X1dsQ
Message-ID: <CAKYAXd8s64Aq5f_jNnmKC6E552egGYptVaGisq33s-zbz2=1ag@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: server: zero buffer before filling file entry
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 28, 2026 at 5:05=E2=80=AFPM Marios Makassikis
<mmakassikis@freebox.fr> wrote:
>
> On Thu, Apr 23, 2026 at 2:29=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.or=
g> wrote:
> >
> > On Wed, Apr 22, 2026 at 7:50=E2=80=AFPM Marios Makassikis
> > <mmakassikis@freebox.fr> wrote:
> > >
> > > this ensures there is no stale data in padding area between entries
> > > when processing SMB2_QUERY_DIRECTORY request.
> > >
> > > Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> > > ---
> > >  fs/smb/server/smb2pdu.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > > index 07782f7205dc..b55bef96d94b 100644
> > > --- a/fs/smb/server/smb2pdu.c
> > > +++ b/fs/smb/server/smb2pdu.c
> > > @@ -3962,6 +3962,7 @@ static int smb2_populate_readdir_entry(struct k=
smbd_conn *conn, int info_level,
> > >                 rc =3D -ENOSPC;
> > >                 goto free_conv_name;
> > >         }
> > > +       memset(d_info->wptr, 0, next_entry_offset);
> > The response buffer is allocated with kvzalloc(). Could it be a
> > duplicate initialization?
> > Thanks!
>
> Hello,
>
> I sent this patch because I was seeing parts of filenames in the padding =
area,
> while investigating a different issue.
>
> the call flow is:
>   smb2_query_dir()
>     iterate_dir()
>       __query_dir()
>         reserve_populate_dentry()
>     process_query_dir_entries()
>         smb2_populate_readdir_entry()
>
> reserve_populate_dentry() uses rsp->Buffer as a scratchbuffer to store
> the filename. Then, this information is picked up in process_query_dir_en=
tries()
> when calling dentry_name().
>
> You can reproduce the issue by listing a directory with a few dozen files=
.
> Wireshark does not include the padding in the decoded fields, so you
> have to look
> at the hex dump.
>
> I have no idea if clients may error if the padding area contains garbage,
> but I'd rather not find out the hard way.
I have never seen a client have issues because of this. Since the
filename in smb2 query directory response has a filename length,
clients will not read garbage data. Furthermore, the garbage data
found in alignment gaps is unencoded filenames, so it is not important
data that must not be exposed externally.
Please let me know if some client malfunctions due to this.
>
> --
> Marios
