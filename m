Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCAC19AD5C
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 01:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776820748; cv=none; b=IFT7LQNAfrRFNHd+kjbUtT65Fa4Hjeps7f90p4+wzx2nskOGA/Ts9DmJenJYnXu7PqkzEYntuvwRAxaTuuukEzWLMaY3i5lmnibydQOLjr4Xkpp7H/aurbM2HhS01yWUo9ax0UZ4JJtBxMkSxJuRNdqfFqhMHMGII7KheTmw6ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776820748; c=relaxed/simple;
	bh=/jTKkPxjCUXS6fFAqKbqlFEHQVuCUBX2TYaLqiX0BVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=imFxy4c0Ui44nSwprp3cBCZWVM/t1mPC7Yoe3fVFUON4t4nBCjvp8j0MWXA8t4FtoDWoP+pgY/zZxgEvNTZ0vKTwplJufoM0K+HoolLEucIexo3LLpVFRZyjLCZ3PGrkOAxBM2xRRl/iRQhPoDKONtvH8Y+/weX87irPeTEslR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MglTkZ+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MglTkZ+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20FFC2BCB7
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 01:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776820747;
	bh=/jTKkPxjCUXS6fFAqKbqlFEHQVuCUBX2TYaLqiX0BVE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MglTkZ+SUClyd0ProDQfnM9zWp0zOoabzz+UiOZaKI/Md9f0jfa8ixtphP6Wj+i8v
	 lStO3wG/K7M9K/YnaGCuEXMOEGAqr3UvbQft9Sm/8FYFMRaiIDnvkNvYUn0cwI/sBy
	 glbWt7be8cd8CUG6Pfn0g6LQ/q/X0iPs1ksz9roRfAqppBSIVBbNlFuO61qlIQssLs
	 efgbYY4ztqOXvZ4n828/eWgJmJhIViuu8XaOMNUFSP4qcqUB1CMvBmN/DsQzO3R8oh
	 KVcoHXpnvPFubj0jJ21Xl5SDrjBm2lh2sWQGhyQGrTCtC7j16nHL6UzF5Bp1iUpX3z
	 8Y1TuSnhRzaEw==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-67389cf78b0so8793184a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 18:19:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+0Cb9KzoZSXR9CjzKiktiP3QuKKavpqTW23/dSGIIyj8h8YECGGICSskGbaHQpXpoGAKYG9H/mtxiX@vger.kernel.org
X-Gm-Message-State: AOJu0Yw10GSeoGdb2N4oBKpX1HG6kittRH6mVhnIzbD0XYULBYLK0K7P
	k7pdj/9D148jivPuW0onh03SkZyVKIBiPTonDAdrgW6pRPIN2Gp+wZeQjx6ocRfBcsdqhrTbPlS
	yARVJS+msHztkj79FlUVs+sameMHWvDI=
X-Received: by 2002:a05:6402:4041:10b0:676:9c6d:5c4d with SMTP id
 4fb4d7f45d1cf-6769c6d5ed5mr2213385a12.17.1776820746303; Tue, 21 Apr 2026
 18:19:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421190619.1396589-1-mmakassikis@freebox.fr> <CAH2r5mu+kn7qDq4_y6PFYsgAPwUE9WuAjNU_-4Z8Ot6s9WkCQQ@mail.gmail.com>
In-Reply-To: <CAH2r5mu+kn7qDq4_y6PFYsgAPwUE9WuAjNU_-4Z8Ot6s9WkCQQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 22 Apr 2026 10:18:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8E7gMoKraLs-qzsEZezs6MNDxv2Sj_7mmmMVkFdy56Xg@mail.gmail.com>
X-Gm-Features: AQROBzDf8QuYzgsX6iI8pRKkYNg9sLoLe-Yp-Fv2VzP89ImFxgEBBJOn16US8w8
Message-ID: <CAKYAXd8E7gMoKraLs-qzsEZezs6MNDxv2Sj_7mmmMVkFdy56Xg@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: server: stop sending fake security descriptors
To: Steve French <smfrench@gmail.com>
Cc: Marios Makassikis <mmakassikis@freebox.fr>, linux-cifs@vger.kernel.org, tom@talpey.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 9:34=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> The patch generates a build warning
>
> smb2pdu.c: In function =E2=80=98smb2_get_info_sec=E2=80=99:
> smb2pdu.c:5817:1: warning: label =E2=80=98iov_pin=E2=80=99 defined but no=
t used [-Wunused-label]
>  5817 | iov_pin:
>       | ^~~~~~~
>
> The patch removes the use of that label
> ...
> -               secdesclen =3D sizeof(struct smb_ntsd);
> -               goto iov_pin;
> +               rsp->hdr.Status =3D STATUS_NOT_SUPPORTED;
> +               return -EINVAL;
>         }
Right, I directly fixed it and pushed it again.
Thanks!
>
> On Tue, Apr 21, 2026 at 2:06=E2=80=AFPM Marios Makassikis
> <mmakassikis@freebox.fr> wrote:
> >
> > in smb2_get_info_sec, a dummy security descriptor (SD) is returned if
> > the requested information is not supported.
> >
> > the code is currently wrong, as DACL_PROTECTED is set in the type field=
,
> > but there is no DACL is present.
> >
> > instead of faking a security, report a STATUS_NOT_SUPPORTED error.
> >
> > this seems to fix a "Error 0x80090006: Invalid Signature" on file
> > transfers with Windows 11 clients (25H2, build 26200.8246).
> >
> > capturing traffic shows that the client is sending a GET_INFO/SEC_INFO
> > request, with the additional_info field set to 0x20
> > (ATTRIBUTE_SECURITY_INFORMATION). Returning an empty SD
> > (with only SELF_RELATIVE set) does not fix the error.
> >
> > Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> > ---
> >  fs/smb/server/smb2pdu.c | 16 ++--------------
> >  1 file changed, 2 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > index ee32e61b6d3c..6622efdd55e3 100644
> > --- a/fs/smb/server/smb2pdu.c
> > +++ b/fs/smb/server/smb2pdu.c
> > @@ -5745,20 +5745,8 @@ static int smb2_get_info_sec(struct ksmbd_work *=
work,
> >                 ksmbd_debug(SMB, "Unsupported addition info: 0x%x)\n",
> >                        addition_info);
> >
> > -               pntsd =3D kzalloc(ALIGN(sizeof(struct smb_ntsd), 8),
> > -                               KSMBD_DEFAULT_GFP);
> > -               if (!pntsd)
> > -                       return -ENOMEM;
> > -
> > -               pntsd->revision =3D cpu_to_le16(1);
> > -               pntsd->type =3D cpu_to_le16(SELF_RELATIVE | DACL_PROTEC=
TED);
> > -               pntsd->osidoffset =3D 0;
> > -               pntsd->gsidoffset =3D 0;
> > -               pntsd->sacloffset =3D 0;
> > -               pntsd->dacloffset =3D 0;
> > -
> > -               secdesclen =3D sizeof(struct smb_ntsd);
> > -               goto iov_pin;
> > +               rsp->hdr.Status =3D STATUS_NOT_SUPPORTED;
> > +               return -EINVAL;
> >         }
> >
> >         if (work->next_smb2_rcv_hdr_off) {
> > --
> > 2.51.1
> >
>
>
> --
> Thanks,
>
> Steve
