From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] SMB2: Fix share type handling
Date: Fri, 12 May 2017 20:11:38 -0500
Message-ID: <CAH2r5ms30x8Hk8Zc63n3yzd8muwYV+JdVrhwVzGNfpnT7vttYQ@mail.gmail.com>
References: <20170512155932.20120-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        kernel-janitors <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170512155932.20120-1-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git for-next

On Fri, May 12, 2017 at 10:59 AM, Christophe JAILLET
<christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org> wrote:
> In fs/cifs/smb2pdu.h, we have:
> #define SMB2_SHARE_TYPE_DISK    0x01
> #define SMB2_SHARE_TYPE_PIPE    0x02
> #define SMB2_SHARE_TYPE_PRINT   0x03
>
> Knowing that, with the current code, the SMB2_SHARE_TYPE_PRINT case can
> never trigger and printer share would be interpreted as disk share.
>
> So, test the ShareType value for equality instead.
>
> Fixes: faaf946a7d5b ("CIFS: Add tree connect/disconnect capability for SMB2")
> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
> ---
> V2: use a 'switch' instead of some 'if'
>
> The v1 and related comments are quite old. They can be found at:
>    http://marc.info/?t=147976541800001&r=1&w=4
> ---
>  fs/cifs/smb2pdu.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index e0517f499c38..e4afdaae743f 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1240,15 +1240,19 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>                 goto tcon_exit;
>         }
>
> -       if (rsp->ShareType & SMB2_SHARE_TYPE_DISK)
> +       switch (rsp->ShareType) {
> +       case SMB2_SHARE_TYPE_DISK:
>                 cifs_dbg(FYI, "connection to disk share\n");
> -       else if (rsp->ShareType & SMB2_SHARE_TYPE_PIPE) {
> +               break;
> +       case SMB2_SHARE_TYPE_PIPE:
>                 tcon->ipc = true;
>                 cifs_dbg(FYI, "connection to pipe share\n");
> -       } else if (rsp->ShareType & SMB2_SHARE_TYPE_PRINT) {
> -               tcon->print = true;
> +               break;
> +       case SMB2_SHARE_TYPE_PRINT:
> +               tcon->ipc = true;
>                 cifs_dbg(FYI, "connection to printer\n");
> -       } else {
> +               break;
> +       default:
>                 cifs_dbg(VFS, "unknown share type %d\n", rsp->ShareType);
>                 rc = -EOPNOTSUPP;
>                 goto tcon_error_exit;
> --
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
