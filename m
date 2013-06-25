From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Handle big endianness in NTLM (ntlmv2) authentication
Date: Tue, 25 Jun 2013 13:08:37 -0500
Message-ID: <CAH2r5mtCSwwsCBujXms1Drt_O=9pqPbNJQq+ckEGx1=1LPPh8Q@mail.gmail.com>
References: <1372175077-12846-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372175077-12846-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Good idea - but we need to fix the endian warning that you introduce
fixing the endian problem

  CHECK   /home/smfrench/cifs-2.6/fs/cifs/cifsencrypt.c
/home/smfrench/cifs-2.6/fs/cifs/cifs_unicode.h:337:23: warning: cast
to restricted __le16
/home/smfrench/cifs-2.6/fs/cifs/cifs_unicode.h:337:21: warning:
incorrect type in assignment (different base types)
/home/smfrench/cifs-2.6/fs/cifs/cifs_unicode.h:337:21:    expected
unsigned short [unsigned] [short] [usertype] <noident>
/home/smfrench/cifs-2.6/fs/cifs/cifs_unicode.h:337:21:    got
restricted __le16 [usertype] <noident>


On Tue, Jun 25, 2013 at 10:44 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> This is RH bug 970891
> Uppercasing of username during calculation of ntlmv2 hash fails
> because UniStrupr function does not handle big endian wchars.
>
> Also fix a comment in the same code to reflect its correct usage.
>
>
> Reported-by: steve <sanpatr1-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  fs/cifs/cifs_unicode.h |    2 +-
>  fs/cifs/cifsencrypt.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
> index 4fb0974..bec1137 100644
> --- a/fs/cifs/cifs_unicode.h
> +++ b/fs/cifs/cifs_unicode.h
> @@ -334,7 +334,7 @@ UniStrupr(register wchar_t *upin)
>
>         up = upin;
>         while (*up) {           /* For all characters */
> -               *up = UniToupper(*up);
> +               *up = cpu_to_le16(UniToupper(le16_to_cpu(*up)));
>                 up++;
>         }
>         return upin;            /* Return input pointer */
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 71436d1..8b34a73 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -439,7 +439,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
>                 return rc;
>         }
>
> -       /* convert ses->user_name to unicode and uppercase */
> +       /* convert ses->user_name to unicode */
>         len = ses->user_name ? strlen(ses->user_name) : 0;
>         user = kmalloc(2 + (len * 2), GFP_KERNEL);
>         if (user == NULL) {
> --
> 1.6.0.2
>



-- 
Thanks,

Steve
