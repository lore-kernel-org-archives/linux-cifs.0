From: Sedat Dilek <sedat.dilek-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix comment as d_alloc_root() is replaced by d_make_root()
Date: Fri, 11 May 2012 15:33:51 +0200
Message-ID: <CA+icZUXa3LRrRrj74MzpFSrzcKw6TZxb2L18dorfyNR1j0qnSA@mail.gmail.com>
References: <1335615233-17746-1-git-send-email-sedat.dilek@gmail.com>
Reply-To: sedat.dilek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sedat Dilek <sedat.dilek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335615233-17746-1-git-send-email-sedat.dilek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Apr 28, 2012 at 2:13 PM, Sedat Dilek <sedat.dilek-gM/Ye1E23myhRSP0FMvGiw@public.gmane.org=
m> wrote:
> For more details see <file: Documentation/filesystems/porting>.
>
> Signed-off-by: Sedat Dilek <sedat.dilek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =C2=A0fs/cifs/cifsfs.c | =C2=A0 =C2=A02 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index d342128..62843d9 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -125,7 +125,7 @@ cifs_read_super(struct super_block *sb)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_no_ro=
ot;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> - =C2=A0 =C2=A0 =C2=A0 /* do that *after* d_alloc_root() - we want NU=
LL ->d_op for root here */
> + =C2=A0 =C2=A0 =C2=A0 /* do that *after* d_make_root() - we want NUL=
L ->d_op for root here */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cifs_sb_master_tcon(cifs_sb)->nocase)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_d_op =3D=
 &cifs_ci_dentry_ops;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> --
> 1.7.9.5
>

Ping!? (This patch is for 3.4-final.)

- Sedat -
