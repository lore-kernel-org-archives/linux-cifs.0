From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH] cifs: Mangle string used for unc in /proc/mounts
Date: Sat, 15 Sep 2012 15:52:46 -0500
Message-ID: <CAH2r5mukGviuTVur_VNzGOL-3mUCRmNZqto-HOkKxssUpwge_g@mail.gmail.com>
References: <1347554937-28369-1-git-send-email-sprabhu@redhat.com>
	<CAH2r5mvnV9xDAF8N5VocRYOy4aUCafNrKe1ykmz--rJQtU33Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvnV9xDAF8N5VocRYOy4aUCafNrKe1ykmz--rJQtU33Bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sat, Sep 15, 2012 at 3:52 PM
Subject: Re: [PATCH] cifs: Mangle string used for unc in /proc/mounts
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton
<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


merged into cifs-2.6.git


On Thu, Sep 13, 2012 at 11:48 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> The string for "unc=" in /proc/mounts needs to be escaped. The current
> behaviour can create problems in cases when mounting a share starting
> with a number.
>
> example:
> >mount -t cifs -o username=test,password=x vm140-31:/17000-test /mnt
> >mount -o remount,password=x /mnt
> mount error: could not resolve address for vm140-31x00-test: Unknown
> error
>
> The sub-string "\170" which is part of the unc for the mount above in
> /proc/mounts is interpreted as character'x' in the case above. Escaping
> the string fixes the problem.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index db8a404..2ac02aa 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -360,7 +360,8 @@ cifs_show_options(struct seq_file *s, struct dentry
> *root)
>         cifs_show_security(s, tcon->ses->server);
>         cifs_show_cache_flavor(s, cifs_sb);
>
> -       seq_printf(s, ",unc=%s", tcon->treeName);
> +       seq_printf(s, ",unc=");
> +       seq_escape(s, tcon->treeName, " \t\n\\");
>
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
>                 seq_printf(s, ",multiuser");
> --
> 1.7.11.4
>



--
Thanks,

Steve



--
Thanks,

Steve
