From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] setcifsacl: fix infinite loop in getnumcaces
Date: Tue, 29 Jan 2013 07:55:14 -0600
Message-ID: <CADT32eKvsFwUWCdWzTGwVdiSYekN59tEHuBdbkh18JHq9UmAOQ@mail.gmail.com>
References: <1359461849-9164-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359461849-9164-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 29, 2013 at 6:17 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Jian pointed out that this loop can cycle infinitely when the string
> contains a ','.
>
> Also, fix typo in manpage that shows a trailing ',' in one example.
>
> Reported-by: Jian Li <jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  setcifsacl.1.in | 2 +-
>  setcifsacl.c    | 4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/setcifsacl.1.in b/setcifsacl.1.in
> index 5ede36a..d53a6ec 100644
> --- a/setcifsacl.1.in
> +++ b/setcifsacl.1.in
> @@ -94,7 +94,7 @@ Set an ACL
>  .br
>  setcifsacl -S "ACL:CIFSTESTDOM\\Administrator:0x0/0x0/FULL,
>  .br
> -ACL:CIFSTESTDOM\\user2:0x0/0x0/FULL," <file_name>
> +ACL:CIFSTESTDOM\\user2:0x0/0x0/FULL" <file_name>
>  .PP
>  .SH "NOTES"
>  .PP
> diff --git a/setcifsacl.c b/setcifsacl.c
> index 211c1af..7f92b91 100644
> --- a/setcifsacl.c
> +++ b/setcifsacl.c
> @@ -642,8 +642,10 @@ get_numcaces(const char *aces)
>         const char *current;
>
>         current = aces;
> -       while((current = strchr(current, ',')))
> +       while((current = strchr(current, ','))) {
> +               ++current;
>                 ++num;
> +       }
>
>         return num;
>  }
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Jeff, Jian, is there a test case where error can be reproduced?
I tried something like this and not run into the problem.

# getcifsacl /mnt/smb_a/file2
REVISION:0x1
CONTROL:0x8004
OWNER:S-1-5-32-544
GROUP:S-1-5-21-2442293536-40736039-234543059-513
ACL:S-1-5-32-544:ALLOWED/0x0/FULL
ACL:S-1-5-18:ALLOWED/0x0/FULL

# setcifsacl -D
"ACL:S-1-5-32-544:ALLOWED/0x0/FULL,ACL:S-1-5-18:ALLOWED/0x0/FULL"
/mnt/smb_a/file2

# getcifsacl /mnt/smb_a/file2REVISION:0x1
CONTROL:0x8004
OWNER:S-1-5-32-544
GROUP:S-1-5-21-2442293536-40736039-234543059-513

# setcifsacl -a
"ACL:S-1-5-32-544:ALLOWED/0x0/FULL,ACL:S-1-5-18:ALLOWED/0x0/FULL"
/mnt/smb_a/file2

# getcifsacl /mnt/smb_a/file2REVISION:0x1
CONTROL:0x8004
OWNER:S-1-5-32-544
GROUP:S-1-5-21-2442293536-40736039-234543059-513
ACL:S-1-5-32-544:ALLOWED/0x0/FULL
ACL:S-1-5-18:ALLOWED/0x0/FULL

# setcifsacl -D
"ACL:S-1-5-32-544:ALLOWED/0x0/FULL,ACL:S-1-5-18:ALLOWED/0x0/FULL,"
/mnt/smb_a/file2
parse_cmdline_aces: Error 22 parsing ACEs

Regards,

Shirish
