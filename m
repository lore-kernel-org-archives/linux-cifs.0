From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] cifs: fix memory leak when password is supplied
 multiple times
Date: Thu, 21 Aug 2014 12:14:46 -0500
Message-ID: <CAH2r5mvE0KJOvWLDRdR80n3JKCcLVgfrt8wN1eZ6mPBFig_E3Q@mail.gmail.com>
References: <002c01cfbd28$41411700$c3c34500$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <002c01cfbd28$41411700$c3c34500$@samsung.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

Of the 7 patch series, only the ntlmv2 security fix has not been
merged (would like additional information/thoughts on this - perhaps
some experiments with windows to see what the time threshold is)

On Thu, Aug 21, 2014 at 5:11 AM, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> Unlikely but possible. When password is supplied multiple times, we have
> to free the previous allocation.
>
> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
> Changelog
>  v2:
>   - fix a possible double free reported by kbuild.
>
>  fs/cifs/connect.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b4b6d10..8a9fded 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1587,6 +1587,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                         tmp_end++;
>                         if (!(tmp_end < end && tmp_end[1] == delim)) {
>                                 /* No it is not. Set the password to NULL */
> +                               kfree(vol->password);
>                                 vol->password = NULL;
>                                 break;
>                         }
> @@ -1624,6 +1625,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                                         options = end;
>                         }
>
> +                       kfree(vol->password);
>                         /* Now build new password string */
>                         temp_len = strlen(value);
>                         vol->password = kzalloc(temp_len+1, GFP_KERNEL);
> --
> 1.7.7
>



-- 
Thanks,

Steve
