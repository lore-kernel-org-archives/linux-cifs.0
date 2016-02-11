From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix potential overflow in cifs_compose_mount_options
Date: Wed, 10 Feb 2016 18:14:21 -0600
Message-ID: <CAH2r5ms7VdmYcwfT-D1xxYAA-ECkqX3oZnn=0DkwONH=VWRb3w@mail.gmail.com>
References: <1454344498-16835-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org,
	yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org
To: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454344498-16835-1-git-send-email-wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 1, 2016 at 10:34 AM, Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> In worst case, "ip=" + sb_mountdata + ipv6 can be copied into mountdata.
> Therefore, for safe, it is better to add more size when allocating memory.
>
> Signed-off-by: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifs_dfs_ref.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index 7dc886c..e956cba 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -175,7 +175,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
>          * string to the length of the original string to allow for worst case.
>          */
>         md_len = strlen(sb_mountdata) + INET6_ADDRSTRLEN;
> -       mountdata = kzalloc(md_len + 1, GFP_KERNEL);
> +       mountdata = kzalloc(md_len + sizeof("ip=") + 1, GFP_KERNEL);
>         if (mountdata == NULL) {
>                 rc = -ENOMEM;
>                 goto compose_mount_options_err;

Not likely to be reproducible in practice (since ip= is already in the
sb_mountdata) but in case mount.cifs was missing and ip= was missing from
the original mount string, might as well add it.

Merged into cifs-2.6.git


-- 
Thanks,

Steve
