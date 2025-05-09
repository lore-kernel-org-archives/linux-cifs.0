Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6469D290DAC
	for <linux-cifs@vger.kernel.org>; Fri,  9 May 2025 11:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789738; cv=none; b=QM79aVny3LL25Hnm++C7sLYjBZ8xlHmuAnDLzDCoDXrA656xk5ecqmvN7MwqZ+2fUOI/BuZ1kx2q0loXN3oSVi1zn0Z/8TVtMMw3925ZKnzW6+8IZa3b5zOwRLOTqhLmxz0C43xB1nj7Rlmz6j8K96Qg/XDgEmEZb6Z8OVh6gLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789738; c=relaxed/simple;
	bh=g7MBGXxifhvBLL7lrU8ulRHh8XHsupypa99zF78V/d0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E6DEztkUNx25L3FG40MousFqgQQEGi8tcB3yScEoGAhAcVoKi/g4KPSUxoFdvS2uBkhgp4ZXXN/hHJk+9eu94AeLi5LyDaN43of4pjVXMHDMekn5kBRMCyEkvGWmKUalHIgxgpt0YO9fbqYera5gt1FdCLG/5w6VKtdzyrL0Nn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c7zvXwsP; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7zvXwsP"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-acb2faa9f55so253051266b.3
        for <linux-cifs@vger.kernel.org>; Fri, 09 May 2025 04:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746789734; x=1747394534; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOL58wx7Ph+KHLqfbnELt0V50Zf6d8eVduFflAaug4g=;
        b=c7zvXwsPfyue0I8NYuT3Dt7JWDs3fkOeOe5UqoE6fHYodutz6ETBeBfD9z9llFFByy
         fe7f/SvAM6uFGpx0FLTE/uo5ghiAN3kjr5mEMHPHV9UafEcXRNliRjsjOJpS3aDyYt+m
         pOBEoByMYNDlOtfM/JoRw7wPLaAkud7cLJKmRCsIP3OpAE6DgO/uuVHWlSUPtv1pOLGr
         Sw7aYgYZNiYwJh3PR88a505XxZ7XdHRfcmD2HWe8EFGESXzfqY7D6rw3CG5B8L4ZLNqa
         XBeYym2SrlHvDbohOMfQTkLwr/mRh7B9jvvvIdvoz0yCimuVWGvTwwE85duQGZ1C67zD
         3Mog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789734; x=1747394534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOL58wx7Ph+KHLqfbnELt0V50Zf6d8eVduFflAaug4g=;
        b=t1dNmTVYWBUrYndpkLrT/cCtAuGJUchNijoK7AgihxTjD+Y4R1nBB4KIjLarImV8hr
         iCc5KUu74pcQI7k04eIK3K/umwL7TEeIAyDNgJKJnUaF69/mKHtuZ5FGQttVmumD0cMK
         izeFng4CLvh5LVddDxoFsfPYqBZQDE+jQVUnYJyA7l29YwusadKtBpRjvIuQ+RSJIIy6
         bNyvS8XajcF9pYG1oxghTm/a36+GyRy0JWKm8UGFqCrcT9SxgCXrXKi3yg+A6U8hiyp+
         ZKiv6M2lzOGH4AmH9dKLbeaFv2BFJsGE9RV1mfItH3mCzB3XfQBI8YwSAs6jmMl5kvYE
         ERmg==
X-Forwarded-Encrypted: i=1; AJvYcCVhHu0UxjqqitRLv5YfTW8fGi3q/4+sHsEuy+PRRQBYmOv+n4JEG3qz0M+XpYRjFDwfj3NGWrsS74D9@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8OVP4afYbyk74rsIKIV7x8hsZBEZEmNHq/6mCIosz8l1Y8ZB/
	PgMd+kukmdCgV3YP3HnPpUzruV6hB8/hN1lOCbFsnxSHb8juXZOSv5oGt8fzFB7WTefXmI7O79Z
	QQ2iRU6ci0CVyPN+NtZScshPUzwA=
X-Gm-Gg: ASbGncs0CFPZ8WpPagdv6jy9jaJkGgYZOnlPcoFXQ9psHI414v+arh9TCxmrFtVz8Wf
	przYwPmIFJSZNmWTJpW5jpMSqIMHeSB+oblqYsxCmP/uDOYOx4bA51/cj0xAWkCU9YTxLWRt7Aw
	OSWtPFSy6vQstNNPrSoi8YD+MiCAGBRV0=
X-Google-Smtp-Source: AGHT+IEHhunVPFf5/3T1/dJXYNmgLoZtUb/sYrILF7CHTSP2skXj4STICZFTtWKFPUSGBbYnhSGS5YDRomtiZBSxKTk=
X-Received: by 2002:a17:907:7d88:b0:ace:d828:9226 with SMTP id
 a640c23a62f3a-ad218e75585mr318408766b.10.1746789734285; Fri, 09 May 2025
 04:22:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428140500.1462107-1-pc@manguebit.com> <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
 <2f76f9b0b3e5ca99fce360d19b0d6218@manguebit.com> <CAGypqWx0xEJRD_7kxNAiyLB5ueSGFda1bkRXECXtUhinVgvV-A@mail.gmail.com>
 <3d7d41c055cd314342ec1f33e6332c32@manguebit.com> <CAGypqWxSgsR9WFB6q4_AbACXeDKGiNrNdbVzGms2d9fc2nfspQ@mail.gmail.com>
 <c9015c6037df3dd50be1b20c0f0ac04d@manguebit.com>
In-Reply-To: <c9015c6037df3dd50be1b20c0f0ac04d@manguebit.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 9 May 2025 16:52:02 +0530
X-Gm-Features: ATxdqUHBWb1tulLxzh9AguFI-cLMp1cVyaIpvIFBqOQ02uR3W9Y_vkEwiDh6cz8
Message-ID: <CANT5p=r2-Sm-9=jPY0YM1mV4J0H5fOG31WSZ+E_4dKqNcNJ_Kg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
To: Paulo Alcantara <pc@manguebit.com>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, Steve French <smfrench@gmail.com>, 
	linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Pierguido Lambri <plambri@redhat.com>, Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 8:35=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Hi Bharath,
>
> Bharath SM <bharathsm.hsk@gmail.com> writes:
>
> > On Mon, May 5, 2025 at 6:42=E2=80=AFPM Paulo Alcantara <pc@manguebit.co=
m> wrote:
> >>
> >> Bharath SM <bharathsm.hsk@gmail.com> writes:
> >>
> >> > If the file has only deferred handles and a handle lease break occur=
s,
> >> > closing all the handles triggers an implicit acknowledgment. After t=
he
> >> > last handle is closed, the server may release the structures
> >> > associated with the file handle. If the acknowledgment is sent after
> >> > closing all the handles, the server may ignore it or it may return a=
n
> >> > invalid file error, as it could have already freed the handle/lease
> >> > key and related structures.
> >>
> >> I couldn't find anything in the specs related to the above.  Could you
> >> please point me out to the correct specs or is this just theorical?
> >
> > Sorry for confusion, this is not from spec. I was trying to say, if we
> > remove the check
> >  "&& !list_empty(&cinode->openFileList" in code then client may get
> > "STATUS_OBJECT_NAME_NOT_FOUND" error when client sends lease break ack =
after
> > closing all file handles. Attached the pcap for ref.
>
> Ah, thanks for the explanation!  Yes, that's indeed a problem.  We
> should be calling _cifsFileInfo_put() right after sending the lease
> break ack, as the old code did.
>
> >> Have you been able to reproduce the above?  If so, please share the
> >> details.
> >
> > Yes, attached the wireshark capture. please take a look.
> > steps:
> > 1) Build cifs.ko by removing  "&& !list_empty(&cinode->openFileList)"
> > in cifs_oplock_break
> > 2) Mount file share with "nosharesock,closetimeo=3D30" at /mnt/test1 an=
d
> > /mnt/test2 ...
> > 3) cd  /mnt/test1; echo "aaa" >> testfile
> > 4) On other shell, cd /mnt/test2; echo "aaa" >> testfile
> >
> >> If the server is returning an invalid file error for a lease break ack
> >> sent by the client that should be a no-op, isn't that a server bug the=
n?
> >
> > Windows Server returns STATUS_OBJECT_NAME_NOT_FOUND error code in such =
cases.
> > But I am not sure if this is a server bug.
>
> That's a legitimate error.  See above.
>
> >> > Additionally, this would result in an extra command being sent to th=
e
> >> > server. This check was added to avoid this case to send lease break
> >> > ack only when openfilelist is not empty.
> >>
> >> I understand.  The problem with attempting to save that extra roundtri=
p
> >> has caused performance problems with our customers accessing their
> >> Windows Server SMB shares.
> >
> > I agree that we need to fix the customer issue on priority, but just
> > pointing out that when
> > we remove the existing check we will end up with this behavior. But if
> > we can reproduce
> > the cx issue or scenario then may be able to find a better fix which
> > can handle both cases.?
> >
> > Please let me know your comments.
>
> Unfortunately I don't have any reproducers for the customer issue.
>
> With these changes I no longer get the STATUS_OBJECT_NAME_NOT_FOUND
> error with your reproducer.  Let me know.
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 851b74f557c1..5facc85b408a 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -3083,11 +3083,10 @@ void cifs_oplock_break(struct work_struct *work)
>         struct cifsInodeInfo *cinode =3D CIFS_I(inode);
>         struct cifs_tcon *tcon;
>         struct TCP_Server_Info *server;
> +       bool purge_cache =3D false;
>         struct tcon_link *tlink;
> +       struct cifs_fid *fid;
>         int rc =3D 0;
> -       bool purge_cache =3D false, oplock_break_cancelled;
> -       __u64 persistent_fid, volatile_fid;
> -       __u16 net_fid;
>
>         wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
>                         TASK_UNINTERRUPTIBLE);
> @@ -3134,32 +3133,21 @@ void cifs_oplock_break(struct work_struct *work)
>          * file handles but cached, then schedule deferred close immediat=
ely.
>          * So, new open will not use cached handle.
>          */
> -
>         if (!CIFS_CACHE_HANDLE(cinode) && !list_empty(&cinode->deferred_c=
loses))
>                 cifs_close_deferred_file(cinode);
>
> -       persistent_fid =3D cfile->fid.persistent_fid;
> -       volatile_fid =3D cfile->fid.volatile_fid;
> -       net_fid =3D cfile->fid.netfid;
> -       oplock_break_cancelled =3D cfile->oplock_break_cancelled;
> -
> -       _cifsFileInfo_put(cfile, false /* do not wait for ourself */, fal=
se);
> -       /*
> -        * MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do no=
t require
> -        * an acknowledgment to be sent when the file has already been cl=
osed.
> -        */
> -       spin_lock(&cinode->open_file_lock);
> -       /* check list empty since can race with kill_sb calling tree disc=
onnect */
> -       if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)=
) {
> -               spin_unlock(&cinode->open_file_lock);
> -               rc =3D server->ops->oplock_response(tcon, persistent_fid,
> -                                                 volatile_fid, net_fid, =
cinode);
> +       fid =3D &cfile->fid;
> +       /* MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) */
> +       if (!cfile->oplock_break_cancelled) {
> +               rc =3D server->ops->oplock_response(tcon, fid->persistent=
_fid,
> +                                                 fid->volatile_fid,
> +                                                 fid->netfid, cinode);
>                 cifs_dbg(FYI, "Oplock release rc =3D %d\n", rc);
> -       } else
> -               spin_unlock(&cinode->open_file_lock);
> +       }
>
>         cifs_put_tlink(tlink);
>  out:
> +       _cifsFileInfo_put(cfile, false /* do not wait for ourself */, fal=
se);
>         cifs_done_oplock_break(cinode);
>  }
>

Hi Paulo,

I think this version of the patch will be more problematic, as it will
open up a time window between the lease break ack and the file close.
Which is why we moved the _cifsFileInfo_put above as it is today.
Specifically, it is still not clear to me what was the exact bug that
your customer hit. And why is your patch fixing that issue? Can you
please elaborate on that?
On RWH to RW lease break, we would force close all deferred handles.
But any active handles (that are still kept open by the user) will
continue to remain open. Which is what this check is about.

--=20
Regards,
Shyam
