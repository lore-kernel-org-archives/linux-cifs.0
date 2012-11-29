From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Add handling of blank password option
Date: Thu, 29 Nov 2012 10:56:36 -0600
Message-ID: <CAH2r5mu8UO_tuXSR8kfdD3+EQbJ-3miY9PT4+h6upDHkhzi-PQ@mail.gmail.com>
References: <20121129163116.GP27196@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121129163116.GP27196-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Thu, Nov 29, 2012 at 10:31 AM, Jesper Nilsson
<jesper.nilsson-VrBV9hrLPhE@public.gmane.org> wrote:
> The option to have a blank "pass=" already exists, and with
> a password specified both "pass=%s" and "password=%s" are supported.
> Also, both blank "user=" and "username=" are supported, making
> "password=" the odd man out.
>
> Signed-off-by: Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>
> ---
>  fs/cifs/connect.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 5c670b9..c83f5b65 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -186,6 +186,7 @@ static const match_table_t cifs_mount_option_tokens = {
>         { Opt_user, "user=%s" },
>         { Opt_user, "username=%s" },
>         { Opt_blank_pass, "pass=" },
> +       { Opt_blank_pass, "password=" },
>         { Opt_pass, "pass=%s" },
>         { Opt_pass, "password=%s" },
>         { Opt_blank_ip, "ip=" },
> --
> 1.8.0.rc0.18.gf84667d
>
>
> /^JN - Jesper Nilsson
> --
>                Jesper Nilsson -- jesper.nilsson-VrBV9hrLPhE@public.gmane.org



-- 
Thanks,

Steve
