Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBDD298991
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749745342; cv=none; b=DHzGfzJ4da2yNZTQ6ESc7h1KQuSXZE/SZkSF0zVFCsgDitIaPz7Tt7qVyEL3HZDj2dzkEUDkXKQ2eatFul0ESg+SnuSkya4v7E1Q2++8lET7KegRRL7iO608ccmuwfvzIsPjjHo4vD43sNX+gf2ir8bwT6Ep9It66mxbRTLvODw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749745342; c=relaxed/simple;
	bh=l9uCHsxvCAmDHDSzqd5IzhQuVwDCJXpa7qjYD3EXutY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oUT3dv0uc84k4xWB78dOz23o8hE7ndiJVSclawAE6oh2DskuHEU/IDMQLR6+ByNDr3PtS964ap1b2zugTcKX4ZAD/Mqbsll+7oZntmXCXXjd4v8H9X1gub65WtbaEuUyXaG9CTikZlJmb4wf/OXDQK0PPSp2VCPzHK10xwNqJnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLk6eTiV; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLk6eTiV"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-54b09cb06b0so1226312e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 09:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749745337; x=1750350137; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nT1byXFKTbL3YnlZ03XO9d4vTBW9MbKTx1RMTGQ6pAA=;
        b=nLk6eTiViWRzggifjFPNKyktxcSIcE/pUk1SiEhKYO/mqwVNXUi7RonoKbP/JNHZQr
         dughgY5BuaFr2kbP856YY7tv8VZ7Ddl1n2w3RQhsU0zfXUAtJt/qNY+8abjYa1iqb7pv
         /UVvbOHl/BkoKjpuJ+LtugApQeQ5k6WH2aT6qMkaHZGwpmmHYC6UoOf2qGDgL4jcj/th
         52LduFIXBw3SsBWoQwOdVAlE3LHDj5BkSa5p6eFD5OU5+AXN7DYmqb8TE95RJBkw/kMD
         PR/9A2eP0NWVo70zignaFU/msGjRKa8jJdAcJ0DoPTY2Ovj9bUUznII2096jQR9z/EaM
         zpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749745337; x=1750350137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nT1byXFKTbL3YnlZ03XO9d4vTBW9MbKTx1RMTGQ6pAA=;
        b=eDnEWvdyNpAClq1jC3U3q+1hywcfXmzvYDS21SiYqyDdi5Lwjkg+rnUIPKDfT19HWZ
         iH+0/u84RjI4LjvsVa+MZkUG3C1osyTsHgheOf9EZpT3RhI+jVQ26iWizHzDktjAYH27
         QBdLeFvmMGZFUT7Jc0pwrtU7LxXEeTiuNk/WbNnvEM8HTLPDb4/FKZqGYxY8KeF55DPm
         xSlvnQHGQB55DD6yRvno9tHGwgNs9hjo3vQPfzbVZA/32+uIjD9jCLvegTJS4Mrea7R/
         WJQWnnAIik3TJfgA5TdSv9/CneNC8Pb4B9/xqqeeW7IFvdTAOMyT826LAFmHUB7EKrQO
         6Rvw==
X-Gm-Message-State: AOJu0Yx3VUOMHF/CCkrUuUQT/uHZ9u2hWt7gLaFRcro1BdjXVo5deGRM
	0gYcN192Es9IKHxrd1ElfYUy4JW+StWYW5rN5mSatcO+ECguScTGuuDXYlNdlTiDk3jdAgGRPlp
	VLn4HM6wnDpZansw5Gjtui13zUXW9QHtXDg==
X-Gm-Gg: ASbGncu7UQsrSTJvu0/dP/FyspvFH9krsdAmRUMKcYMZx58Kfe5PVFFPDhcwz3e+yv9
	fedxIJy1JK27hxYdJ960Fyi32PJC7PQF1XEMu+fnOYYS3NQT73xiJ+ussIfDgz7HYpGRpiHCVcq
	1cabJaU2Vmzh/FAjDkyub0OaKqtd0tHD18OkV0f3V7jQr1kgDcBALzs3hTMbb1ywDuRmch8VI3n
	NDs
X-Google-Smtp-Source: AGHT+IFO1Vu000QcOgTG7+mUF3MYs41Dx8B3rojauJd5MkcrIPVjLHyERZyDFAJnoFZfF4/YoZchjfpSUHIqifEdDc4=
X-Received: by 2002:ac2:4545:0:b0:553:24bb:daa1 with SMTP id
 2adb3069b0e04-553af033661mr47265e87.11.1749745337147; Thu, 12 Jun 2025
 09:22:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612154504.246390-1-pc@manguebit.org>
In-Reply-To: <20250612154504.246390-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Jun 2025 11:22:05 -0500
X-Gm-Features: AX0GCFvWkQ4IUN56h-x84QAtp53m9H9_C0dyuRsQstrpzUE53AJUJGaS_44zSDE
Message-ID: <CAH2r5mvh7VC_fVp0QQ2ACJohuEvWriJp+zc8HSW6Z6GQTeH2-w@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix perf regression with deferred closes
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Jay Shin <jaeshin@redhat.com>, Pierguido Lambri <plambri@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending testing and any
additional review

On Thu, Jun 12, 2025 at 10:45=E2=80=AFAM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> Customer reported that one of their applications started failing to
> open files with STATUS_INSUFFICIENT_RESOURCES due to NetApp server
> hitting the maximum number of opens to same file that it would allow
> for a single client connection.
>
> It turned out the client was failing to reuse open handles with
> deferred closes because matching ->f_flags directly without masking
> off O_CREAT|O_EXCL|O_TRUNC bits first broke the comparision and then
> client ended up with thousands of deferred closes to same file.  Those
> bits are already satisfied on the original open, so no need to check
> them against existing open handles.
>
> Reproducer:
>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
>  #include <fcntl.h>
>  #include <pthread.h>
>
>  #define NR_THREADS      4
>  #define NR_ITERATIONS   2500
>  #define TEST_FILE       "/mnt/1/test/dir/foo"
>
>  static char buf[64];
>
>  static void *worker(void *arg)
>  {
>          int i, j;
>          int fd;
>
>          for (i =3D 0; i < NR_ITERATIONS; i++) {
>                  fd =3D open(TEST_FILE, O_WRONLY|O_CREAT|O_APPEND, 0666);
>                  for (j =3D 0; j < 16; j++)
>                          write(fd, buf, sizeof(buf));
>                  close(fd);
>          }
>  }
>
>  int main(int argc, char *argv[])
>  {
>          pthread_t t[NR_THREADS];
>          int fd;
>          int i;
>
>          fd =3D open(TEST_FILE, O_WRONLY|O_CREAT|O_TRUNC, 0666);
>          close(fd);
>          memset(buf, 'a', sizeof(buf));
>          for (i =3D 0; i < NR_THREADS; i++)
>                  pthread_create(&t[i], NULL, worker, NULL);
>          for (i =3D 0; i < NR_THREADS; i++)
>                  pthread_join(t[i], NULL);
>          return 0;
>  }
>
> Before patch:
>
> $ mount.cifs //srv/share /mnt/1 -o ...
> $ mkdir -p /mnt/1/test/dir
> $ gcc repro.c && ./a.out
> ...
> number of opens: 1391
>
> After patch:
>
> $ mount.cifs //srv/share /mnt/1 -o ...
> $ mkdir -p /mnt/1/test/dir
> $ gcc repro.c && ./a.out
> ...
> number of opens: 1
>
> Cc: linux-cifs@vger.kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Cc: Jay Shin <jaeshin@redhat.com>
> Cc: Pierguido Lambri <plambri@redhat.com>
> Fixes: b8ea3b1ff544 ("smb: enable reuse of deferred file handles for writ=
e operations")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> ---
>  fs/smb/client/file.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index d2df10b8e6fd..9835672267d2 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -999,15 +999,18 @@ int cifs_open(struct inode *inode, struct file *fil=
e)
>                 rc =3D cifs_get_readable_path(tcon, full_path, &cfile);
>         }
>         if (rc =3D=3D 0) {
> -               if (file->f_flags =3D=3D cfile->f_flags) {
> +               unsigned int oflags =3D file->f_flags & ~(O_CREAT|O_EXCL|=
O_TRUNC);
> +               unsigned int cflags =3D cfile->f_flags & ~(O_CREAT|O_EXCL=
|O_TRUNC);
> +
> +               if (cifs_convert_flags(oflags, 0) =3D=3D cifs_convert_fla=
gs(cflags, 0) &&
> +                   (oflags & (O_SYNC|O_DIRECT)) =3D=3D (cflags & (O_SYNC=
|O_DIRECT))) {
>                         file->private_data =3D cfile;
>                         spin_lock(&CIFS_I(inode)->deferred_lock);
>                         cifs_del_deferred_close(cfile);
>                         spin_unlock(&CIFS_I(inode)->deferred_lock);
>                         goto use_cache;
> -               } else {
> -                       _cifsFileInfo_put(cfile, true, false);
>                 }
> +               _cifsFileInfo_put(cfile, true, false);
>         } else {
>                 /* hard link on the defeered close file */
>                 rc =3D cifs_get_hardlink_path(tcon, inode, file);
> --
> 2.49.0
>


--=20
Thanks,

Steve
