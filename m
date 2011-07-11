From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: drop spinlock before calling cifs_put_tlink
Date: Mon, 11 Jul 2011 11:40:12 -0500
Message-ID: <CAH2r5mug1iYZSGybKjg3H+kUVK6PA3XXt05-6kf+dLYH0yETBQ@mail.gmail.com>
References: <1310393794-12407-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310393794-12407-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

ok - merged.

Am testing now.  If anyone else has test data on current cifs-2.6.git
I could send pull request faster.

On Mon, Jul 11, 2011 at 9:16 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> ...as that function can sleep.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ceab134..dd695c5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2241,8 +2241,8 @@ cifs_match_super(struct super_block *sb, void *=
data)
>
> =A0 =A0 =A0 =A0rc =3D compare_mount_options(sb, mnt_data);
> =A0out:
> - =A0 =A0 =A0 cifs_put_tlink(tlink);
> =A0 =A0 =A0 =A0spin_unlock(&cifs_tcp_ses_lock);
> + =A0 =A0 =A0 cifs_put_tlink(tlink);
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> --
> 1.7.6
>
>



--=20
Thanks,

Steve
