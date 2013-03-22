From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: remove support for "NFS syntax"
Date: Fri, 22 Mar 2013 11:11:08 -0400
Message-ID: <CAFB9KM2pjN9CNqn_6sZM+HVBBoNuE1fYUH2NiEy+Mjn74X9Psw@mail.gmail.com>
References: <1363949407-6327-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363949407-6327-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 22, 2013 at 6:50 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
> ...as promised for version 6.0.
>
> Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c | 38 ++++++++++----------------------------
>  1 file changed, 10 insertions(+), 28 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 40b77e9..496a2c8 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1232,36 +1232,18 @@ static int parse_unc(const char *unc_name, struct parsed_mount_info *parsed_info
>                 return EX_USAGE;
>         }
>
> -       /* Set up "host" and "share" pointers based on UNC format. */
> -       /* TODO: Remove support for NFS syntax as of cifs-utils-6.0. */
>         if (strncmp(unc_name, "//", 2) && strncmp(unc_name, "\\\\", 2)) {
> -               /*
> -                * check for nfs syntax (server:/share/prepath)
> -                *
> -                * FIXME: IPv6 addresses?
> -                */
> -               host = unc_name;
> -               share = strchr(host, ':');
> -               if (!share) {
> -                       fprintf(stderr, "mount.cifs: bad UNC (%s)\n", unc_name);
> -                       return EX_USAGE;
> -               }
> -               hostlen = share - host;
> -               share++;
> -               if (*share == '/')
> -                       ++share;
> -               fprintf(stderr, "WARNING: using NFS syntax for mounting CIFS "
> -                       "shares is deprecated and will be removed in cifs-utils"
> -                       "-6.0. Please migrate to UNC syntax.\n");
> -       } else {
> -               host = unc_name + 2;
> -               hostlen = strcspn(host, "/\\");
> -               if (!hostlen) {
> -                       fprintf(stderr, "mount.cifs: bad UNC (%s)\n", unc_name);
> -                       return EX_USAGE;
> -               }
> -               share = host + hostlen + 1;
> +               fprintf(stderr, "mount.cifs: bad UNC (%s)\n", unc_name);
> +               return EX_USAGE;
> +       }
> +
> +       host = unc_name + 2;
> +       hostlen = strcspn(host, "/\\");
> +       if (!hostlen) {
> +               fprintf(stderr, "mount.cifs: bad UNC (%s)\n", unc_name);
> +               return EX_USAGE;
>         }
> +       share = host + hostlen + 1;
>
>         if (hostlen + 1 > sizeof(parsed_info->host)) {
>                 fprintf(stderr, "mount.cifs: host portion of UNC too long\n");
> --
> 1.7.11.7
>

+1.  Looks good to me.

--
Peace and Blessings,
-Scott.
