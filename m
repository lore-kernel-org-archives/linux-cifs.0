From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] cifs: set MAY_SIGN when sec=krb5
Date: Wed, 30 Jan 2013 22:53:23 -0600
Message-ID: <CAH2r5muToSW5VW3KkazpakQdPBb3ptC0a75FK1+KswzVAvCCkw@mail.gmail.com>
References: <1351071946-21458-1-git-send-email-martijn.de.gouw@prodrive.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351071946-21458-1-git-send-email-martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 24, 2012 at 4:45 AM, Martijn de Gouw
<martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org> wrote:
> Setting this secFlg allows usage of dfs where some servers require
> signing and others don't.
>
> Signed-off-by: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
> ---
> :100644 100644 b39bb4a... 4da9dd3... M  fs/cifs/connect.c
>  fs/cifs/connect.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b39bb4a..4da9dd3 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -994,7 +994,7 @@ static int cifs_parse_security_flavors(char *value,
>
>         switch (match_token(value, cifs_secflavor_tokens, args)) {
>         case Opt_sec_krb5:
> -               vol->secFlg |= CIFSSEC_MAY_KRB5;
> +               vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_SIGN;
>                 break;
>         case Opt_sec_krb5i:
>                 vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MUST_SIGN;

Wouldn't this same problem occur if ntlm or ntlmv2 were authenticated
and a dfs referral sent us to a server which required signing - if
that is the case then it is not just Opt_sec_krb5 which needs to OR in
CIFSSEC_MAY_SIGN but also Opt_sec_ntlmssp and Opt_ntlm (also why do we
call this Opt_ntlm instead of Opt_sec_ntlm like the other 10?) and
Opt_sec_ntlmv2?


-- 
Thanks,

Steve
