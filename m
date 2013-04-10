From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: small variable name cleanup
Date: Wed, 10 Apr 2013 15:56:11 -0500
Message-ID: <CAH2r5mt46HPyd_wRNTdFfr5H=o46qw7PBOPLiRxHepMML4xJfg@mail.gmail.com>
References: <20130410114300.GB21419@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130410114300.GB21419-dZEljifmRObu9KfB+GxooP8+0UxHXcjY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-3.10 branch

On Wed, Apr 10, 2013 at 6:43 AM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> server and ses->server are the same, but it's a little bit ugly that we
> lock &ses->server->srv_mutex and unlock &server->srv_mutex.  It causes
> a false positive in Smatch about inconsistent locking.
>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index edb2220..e3a0f81 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3826,7 +3826,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
>         if (rc) {
>                 cifs_dbg(VFS, "Send error in SessSetup = %d\n", rc);
>         } else {
> -               mutex_lock(&ses->server->srv_mutex);
> +               mutex_lock(&server->srv_mutex);
>                 if (!server->session_estab) {
>                         server->session_key.response = ses->auth_key.response;
>                         server->session_key.len = ses->auth_key.len;



-- 
Thanks,

Steve
