From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix oops while mounting with prefixpath
Date: Mon, 25 Jul 2011 17:02:46 -0500
Message-ID: <CAH2r5mvfCWMFC7_zvF++XGfpNeF2BBRckeZw_p=Jfjr76rugcg@mail.gmail.com>
References: <1311602350-10857-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nick Piggin <npiggin-l3A5Bk7waGM@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311602350-10857-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged. Also note patch 34286d6662308d82aed891852d04c7c3a2649b16
introduced the deref before null check.

34286d66

On Mon, Jul 25, 2011 at 8:59 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> commit fec11dd9a0109fe52fd631e5c510778d6cbff6cc caused
> a regression when we have already mounted //server/share/a
> and want to mount //server/share/a/b.
>
> The problem is that lookup_one_len calls __lookup_hash
> with nd pointer as NULL. Then __lookup_hash calls
> do_revalidate in the case when dentry exists and we end
> up with NULL pointer deference in cifs_d_revalidate:
>
> if (nd->flags & LOOKUP_RCU)
> =A0 =A0 =A0 =A0return -ECHILD;
>
> Fix this by checking nd for NULL.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/dir.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index fa8c21d..d8d26f3 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -641,7 +641,7 @@ lookup_out:
> =A0static int
> =A0cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
> =A0{
> - =A0 =A0 =A0 if (nd->flags & LOOKUP_RCU)
> + =A0 =A0 =A0 if (nd && (nd->flags & LOOKUP_RCU))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ECHILD;
>
> =A0 =A0 =A0 =A0if (direntry->d_inode) {
> --
> 1.7.1
>
>



--=20
Thanks,

Steve
