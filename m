From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] update mount warning about change to ntlmv2, to
 indicate later release
Date: Wed, 4 Jan 2012 06:45:35 -0500
Message-ID: <20120104064535.6fcfdddd@tlielax.poochiereds.net>
References: <CAH2r5mvEqP08-bvdmRsSuvggvXebkxJAZ_JTxSQDZOBgCs-WyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvEqP08-bvdmRsSuvggvXebkxJAZ_JTxSQDZOBgCs-WyQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 3 Jan 2012 23:13:26 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> commit f4be1ef955b828cdb95b7052633edde86a400a52
> Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date:   Tue Jan 3 23:08:24 2012 -0600
> 
>     [CIFS] default ntlmv2 for cifs mount delayed to 3.3
> 
>     Turned out the ntlmv2 (default security authentication)
>     upgrade was harder to test than expected, and we ran
>     out of time to test against Apple and a few other servers
>     that we wanted to.  Delay upgrade of default security
>     from ntlm to ntlmv2 (on mount) to 3.3.  Still works
>     fine to specify it explicitly via "sec=ntlmv2" so this
>     should be fine.
> 
>     Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 27c4f25..f3670cf 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2122,7 +2122,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server,
> struct smb_vol *volume_info)
>                 warned_on_ntlm = true;
>                 cERROR(1, "default security mechanism requested.  The default "
>                         "security mechanism will be upgraded from ntlm to "
> -                       "ntlmv2 in kernel release 3.2");
> +                       "ntlmv2 in kernel release 3.3");
>         }
>         ses->overrideSecFlg = volume_info->secFlg;
> 
> 
> 

Fair enough.

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
