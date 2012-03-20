From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH] fixes issue mounting of DFS ROOT mount when redirecting
 from one domain controller to the next
Date: Tue, 20 Mar 2012 17:29:11 -0400
Message-ID: <20120320172911.0523d94f@tlielax.poochiereds.net>
References: <7B8A1CD01838314387266CEE4CEB05600A137972A0@EX-002.mail.navisite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Thomas Hadig <thomas.hadig-O4KOoiensp/QT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7B8A1CD01838314387266CEE4CEB05600A137972A0-flUYDV2ZbChssxH0ZAyVedUmYfiRyxip@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 20 Mar 2012 15:35:44 -0400
Thomas Hadig <thomas.hadig-O4KOoiensp/QT0dZR+AlfA@public.gmane.org> wrote:

> This patch fixes an issue when cifs_mount receives a STATUS_BAD_NETWORK_NAME error during cifs_get_tcon but is able to continue after an DFS ROOT referral. In this case, the return code variable is not reset prior to trying to mount from the system referred to. Thus, is_path_accessible is not executed and the final DFS referral is not performed causing a mount error.
> 
> Use case:
> In DNS,  example.com  resolves to the secondary AD server   ad2.example.com
> Our primary domain controller is ad1.example.com and has a DFS redirection set up from \\ad1\share\Users to \\files\share\Users.
> Mounting \\example.com\share\Users fails.
> 

Thanks. This should also get:

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Thomas Hadig <thomas at intapp.com>
> Reviewed-by:  Jeff Layton <jlayton at redhat.com>
> 

Typically we don't replace '@' with " at " here.

> diff -Naur a/fs/cifs/connect.c b/fs/cifs/connect.c
> --- a/fs/cifs/connect.c 2012-02-29 16:32:49.000000000 -0800
> +++ b/fs/cifs/connect.c 2012-03-20 12:09:35.195182223 -0700
> @@ -3220,7 +3220,7 @@
>  int
>  cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
>  {
> -       int rc = 0;
> +       int rc;

Looks like this probably won't apply cleanly. The tabs have been
replaced with spaces here. Some mailers tend to mangle emails this way.
What you may want to do is pull down the git tree and use
git-format-patch and git-send-email to send this.

Alternately, if you don't want to bother, let me know and I'll go ahead
and send out a patch for it.

>         int xid;
>         struct cifs_ses *pSesInfo;
>         struct cifs_tcon *tcon;
> @@ -3252,6 +3252,7 @@
>         srvTcp = NULL;
>         full_path = NULL;
>         tlink = NULL;
> +        rc = 0;
>  
>         xid = GetXid();
> 
> 
> Thanks
> Thomas
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
