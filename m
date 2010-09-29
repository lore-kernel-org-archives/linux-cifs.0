From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: prevent infinite recursion in cifs_reconnect_tcon
Date: Wed, 29 Sep 2010 15:10:31 -0500
Message-ID: <AANLkTiktB+3DxaK-GwG9NZb=Z8rZPwEmCbd_d7pskxGM@mail.gmail.com>
References: <1285788428-4864-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hramrach-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285788428-4864-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 29, 2010 at 2:27 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> cifs_reconnect_tcon is called from smb_init. After a successful
> reconnect, cifs_reconnect_tcon will call reset_cifs_unix_caps. That
> function will, in turn call CIFSSMBQFSUnixInfo and CIFSSMBSetFSUnixIn=
fo.
> Those functions also call smb_init.
>
> It's possible for the session and tcon reconnect to succeed, and then
> for another cifs_reconnect to occur before CIFSSMBQFSUnixInfo or
> CIFSSMBSetFSUnixInfo to be called. That'll cause those functions to c=
all
> smb_init and cifs_reconnect_tcon again, ad infinitum...
>
> Break the infinite recursion by having those functions use a new
> smb_init variant that doesn't attempt to perform a reconnect.
>
> Reported-and-Tested-by: Michal Suchanek <hramrach-aRb0bU7PRFPrBKCeMvbIDA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifssmb.c | =A0 49 +++++++++++++++++++++++++++++++++------=
----------
> =A01 files changed, 33 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 13c854e..54bd83a 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -232,7 +232,7 @@ static int
> =A0small_smb_init(int smb_command, int wct, struct cifsTconInfo *tcon=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void **request_buf)
> =A0{
> - =A0 =A0 =A0 int rc =3D 0;
> + =A0 =A0 =A0 int rc;
>
> =A0 =A0 =A0 =A0rc =3D cifs_reconnect_tcon(tcon, smb_command);
> =A0 =A0 =A0 =A0if (rc)
> @@ -250,7 +250,7 @@ small_smb_init(int smb_command, int wct, struct c=
ifsTconInfo *tcon,
> =A0 =A0 =A0 =A0if (tcon !=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_smbs_sent);
>
> - =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 return 0;
> =A0}
>
> =A0int
> @@ -281,16 +281,9 @@ small_smb_init_no_tc(const int smb_command, cons=
t int wct,
>
> =A0/* If the return code is zero, this function must fill in request_=
buf pointer */
> =A0static int
> -smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
> - =A0 =A0 =A0 =A0void **request_buf /* returned */ ,
> - =A0 =A0 =A0 =A0void **response_buf /* returned */ )
> +__smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void **request_buf, voi=
d **response_buf)
> =A0{
> - =A0 =A0 =A0 int rc =3D 0;
> -
> - =A0 =A0 =A0 rc =3D cifs_reconnect_tcon(tcon, smb_command);
> - =A0 =A0 =A0 if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> -
> =A0 =A0 =A0 =A0*request_buf =3D cifs_buf_get();
> =A0 =A0 =A0 =A0if (*request_buf =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB should we add a retry in here if=
 not a writepage? */
> @@ -309,7 +302,31 @@ smb_init(int smb_command, int wct, struct cifsTc=
onInfo *tcon,
> =A0 =A0 =A0 =A0if (tcon !=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_smbs_sent);
>
> - =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/* If the return code is zero, this function must fill in request_bu=
f pointer */
> +static int
> +smb_init(int smb_command, int wct, struct cifsTconInfo *tcon,
> + =A0 =A0 =A0 =A0void **request_buf, void **response_buf)
> +{
> + =A0 =A0 =A0 int rc;
> +
> + =A0 =A0 =A0 rc =3D cifs_reconnect_tcon(tcon, smb_command);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> + =A0 =A0 =A0 return __smb_init(smb_command, wct, tcon, request_buf, =
response_buf);
> +}
> +
> +static int
> +smb_init_no_reconnect(int smb_command, int wct, struct cifsTconInfo =
*tcon,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void **request_buf, voi=
d **response_buf)
> +{
> + =A0 =A0 =A0 if (tcon->ses->need_reconnect || tcon->need_reconnect)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EHOSTDOWN;
> +
> + =A0 =A0 =A0 return __smb_init(smb_command, wct, tcon, request_buf, =
response_buf);
> =A0}
>
> =A0static int validate_t2(struct smb_t2_rsp *pSMB)
> @@ -4536,8 +4553,8 @@ CIFSSMBQFSUnixInfo(const int xid, struct cifsTc=
onInfo *tcon)
>
> =A0 =A0 =A0 =A0cFYI(1, "In QFSUnixInfo");
> =A0QFSUnixRetry:
> - =A0 =A0 =A0 rc =3D smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void *=
*) &pSMB,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void **) &pSMBr);
> + =A0 =A0 =A0 rc =3D smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, =
tcon,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
(void **) &pSMB, (void **) &pSMBr);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> @@ -4606,8 +4623,8 @@ CIFSSMBSetFSUnixInfo(const int xid, struct cifs=
TconInfo *tcon, __u64 cap)
> =A0 =A0 =A0 =A0cFYI(1, "In SETFSUnixInfo");
> =A0SETFSUnixRetry:
> =A0 =A0 =A0 =A0/* BB switch to small buf init to save memory */
> - =A0 =A0 =A0 rc =3D smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void *=
*) &pSMB,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void **) &pSMBr);
> + =A0 =A0 =A0 rc =3D smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, =
tcon,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 (void **) &pSMB, (void **) &pSMBr);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Jeff, is same code change is needed in non-unix versions of these funct=
ions
such as CIFSSMBQFSInfo?
