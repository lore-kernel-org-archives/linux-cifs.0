From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] Introducing new strict cache mode (try #4)
Date: Mon, 8 Nov 2010 22:25:04 +0300
Message-ID: <AANLkTikJt_R8tb7WfR8g2mvA=r09M6vRm6O=wGvWjenk@mail.gmail.com>
References: <1288945777-9197-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288945777-9197-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/5 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> I add new ones (fsync, mmap) and modified previous patches (read, wri=
te, close) and their descriptions. Here is the complete set of them.
>
> Pavel Shilovsky (6):
> =A0CIFS: Make cifsFileInfo_put work with strict cache mode
> =A0CIFS: Make read call work with strict cache mode
> =A0CIFS: Make write call work with strict cache mode
> =A0CIFS: Make cifs_fsync work with strict cache mode
> =A0CIFS: Make cifs_file_map work with strict cache mode
> =A0CIFS: Add strictcache mount option
>
> =A0fs/cifs/README =A0 =A0 =A0 | =A0 =A05 +++
> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 79 ++++++++++++++++++++++++++++++++=
+++++++++++++----
> =A0fs/cifs/connect.c =A0 =A0| =A0 =A05 +++
> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 54 +++++++++++++++++++++++++-----=
----
> =A05 files changed, 123 insertions(+), 21 deletions(-)
>
> --
> 1.7.2.3
>
>

What's about this set of patches?

--=20
Best regards,
Pavel Shilovsky.
