Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE04335C7;
	Sun, 13 Oct 2024 04:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728793175; cv=none; b=CiUz1i6z1oh9xaM8u1gVZXljg3kbOBZQ+wB2sNpVQF7yzjcdxcTJj5qP/JUkJ8C+5KKbd7lEZFSU6/StqkX+ofLJR1/LjsoL6He9pLytqBje/xuqBVWiZAfH+NkhLNcEdiz9TDFWB7Mlo+kZQl3m0XXsDu+wjocsg0B9DHt22UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728793175; c=relaxed/simple;
	bh=lJ/pdzzaJd7nzI/dQFhdCrhA3QULXioVeUL2d85v8S4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=B4bS1gdFDJLEWxFOzID2lMaXbsQxeHpar+vJBmpNQjp2LHSS5pvyua3d+QqgVyqaMnjX822OI/+hROry5j88fd3n4lYQ0FQWXD4VaRwKjjcDISZ1zlqgz5V/t8fmnY7qbHeEDJN6hRertDrfWHRCEcbGb39tHl4fq6mvpXVXfY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FYRYGzkg; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FYRYGzkg"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539e4b7409fso1094238e87.0;
        Sat, 12 Oct 2024 21:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728793172; x=1729397972; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4qX6guBUxX0eDbVHHu2pg2WZSE/f8L/1AN8b8sMbkM=;
        b=FYRYGzkgRM81orAGsURgL6y+9btsu9RdKHucikHku5NM4JBySSKayoSUKaXexiLlsd
         OczcH9UfquhqYDlmHEObj/9/zznWfPhzlZKfG7UTx8pcOHbBqU3L51X5HyeyTS3DNugZ
         +qDTzCRCkiAFgDgbWNcdMZiCaWwWa+V5FKRlE1Yygh3y8tp13a/7hS4zg5HG10w62vPW
         ARjBe1XR+82vz7NlWUSPCq3L/2rRAFAYzrEHx/E1f36zWP18QQVm9uCElDZhlXzxeCnd
         KxbBLQSUwsWOAUo0pN7uxeY6ryi9izEu4HO3Q/GIsMCOo7vLamOwS/KGGIZmRDcpBsrG
         b1KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728793172; x=1729397972;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4qX6guBUxX0eDbVHHu2pg2WZSE/f8L/1AN8b8sMbkM=;
        b=UbBgPw7HDPY8M/phRDf6fgIZsshX6P/viNoWNiFHMdulO8a934hxa4kYL+q17P8mlM
         BwaJifBh1xIYR+9JV2Jf0vXmi6f8yW4Aohg+ro5M00H02qJMd3WFse/yrCQoUrRot8Cr
         J1FIjWKW70UM2OvN8VXlVNfYn6AW7BcHoN1tmomXpSZNO20K6KN/zS/EYS69ovKj44iO
         zRU4Np7HkQL6OHD2xV3sFFojByvSraIPz8V6TtxEsxW4LCM4UYCM7t+YOqX1/KbimK+R
         KfhpRGyALh014oEf2watguhV1Haj0IDpk1e6dQR+7f3RyV8w7+3wTMN26b9EJSvXObZQ
         syIA==
X-Forwarded-Encrypted: i=1; AJvYcCUqvdqkJ5vFZjem9vuXy/Qf5Lm4HH0yXujq3OfDw4nYA49ko9sLka7I7psyDknaoyftGv1qw7B36dVf9VI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5n43AxUICJq88QsqK/O501WlLqxnZCspAPjY4tVKsaYsQGbA+
	GGx8ahg2Pt85WyA9vWzJGahj2fH27efRJXGprI6uy5G7SAJtzB6QddFteDGLNyoAyLS8BeA//lf
	DzQd6CRU6/EycaqMJpkr8GFfBqcl63Mx/
X-Google-Smtp-Source: AGHT+IHdgEXzzETpJc938v7XDUrgtfz7RKqP+vYOIdVL7NoJQNihz6bvoyv9AzuVyVuLucieza4KV6lA/HAxrhUvRmU=
X-Received: by 2002:a05:6512:3d87:b0:539:eec0:20de with SMTP id
 2adb3069b0e04-539eec02255mr258674e87.10.1728793171609; Sat, 12 Oct 2024
 21:19:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006100046.30772-1-pali@kernel.org> <20241012085252.560-1-pali@kernel.org>
 <CAH2r5mtGqqM35Cy5k9NN=X05rTZPk-adhb7LgoV8PGNVL9P6FQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtGqqM35Cy5k9NN=X05rTZPk-adhb7LgoV8PGNVL9P6FQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 12 Oct 2024 23:19:20 -0500
Message-ID: <CAH2r5msVd0+E-Uwjnx9E6KctfNKEpQvUtyeN0_MkSH1tcS+hWg@mail.gmail.com>
Subject: Fwd: [PATCH v2 0/7] Allow to choose symlink and socket type
To: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

after doing more experiments with native windows symlinks (and how
difficult it is to get permission to set them over the wire to
Windows), was wondering if we should allow fall back strategy if
creating windows style symlinks fails with STATUS_PRIVILEGE_NOT_HELD
then we should try NFS reparse point symlink.  Any opinions?

On Sat, Oct 12, 2024 at 3:53=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> This patch series improves choosing reparse format when creating new
> special files.
>
> Changes since v1:
> * Instead of new -o reparse=3D mount option is now a new -o symlink=3D mo=
unt
>   option for choosing symlink type during creation, and new option
>   -o nonativesocket for choosing socket type
>
> Pali Roh=C3=A1r (7):
>   cifs: Add mount option -o symlink=3D for choosing symlink create type
>   cifs: Add mount option -o reparse=3Dnone
>   cifs: Add support for creating native Windows sockets
>   cifs: Add support for creating NFS-style symlinks
>   cifs: Improve guard for excluding $LXDEV xattr
>   cifs: Add support for creating WSL-style symlinks
>   cifs: Validate content of WSL reparse point buffers
>
>  fs/smb/client/cifsfs.c     |   4 +
>  fs/smb/client/cifsglob.h   |  36 +++++++
>  fs/smb/client/connect.c    |   4 +
>  fs/smb/client/fs_context.c |  82 +++++++++++++++
>  fs/smb/client/fs_context.h |  19 ++++
>  fs/smb/client/link.c       |  60 ++++++++---
>  fs/smb/client/reparse.c    | 201 +++++++++++++++++++++++++++++++------
>  fs/smb/client/reparse.h    |   2 +
>  8 files changed, 364 insertions(+), 44 deletions(-)
>
> --
> 2.20.1
>
>


--=20
Thanks,

Steve


--=20
Thanks,

Steve
