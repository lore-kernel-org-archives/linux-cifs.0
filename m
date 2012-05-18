From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix comment as d_alloc_root() is replaced by d_make_root()
Date: Thu, 17 May 2012 22:32:24 -0500
Message-ID: <CAH2r5mvc1vzKwrqC9aS6-1SRRwSpBTszmwGBHcUFqvGhCd9pBg@mail.gmail.com>
References: <1335615233-17746-1-git-send-email-sedat.dilek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Sedat Dilek <sedat.dilek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Sedat Dilek <sedat.dilek-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335615233-17746-1-git-send-email-sedat.dilek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into for-next branch (for linux-next) of cifs-2.6.git

On Sat, Apr 28, 2012 at 7:13 AM, Sedat Dilek <sedat.dilek-gM/Ye1E23myhRSP0FMvGiw@public.gmane.org=
m> wrote:
> For more details see <file: Documentation/filesystems/porting>.
>
> Signed-off-by: Sedat Dilek <sedat.dilek-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 =A02 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index d342128..62843d9 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -125,7 +125,7 @@ cifs_read_super(struct super_block *sb)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_no_root;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* do that *after* d_alloc_root() - we want NULL ->d_op=
 for root here */
> + =A0 =A0 =A0 /* do that *after* d_make_root() - we want NULL ->d_op =
for root here */
> =A0 =A0 =A0 =A0if (cifs_sb_master_tcon(cifs_sb)->nocase)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_d_op =3D &cifs_ci_dentry_ops;
> =A0 =A0 =A0 =A0else
> --
> 1.7.9.5
>



--=20
Thanks,

Steve
