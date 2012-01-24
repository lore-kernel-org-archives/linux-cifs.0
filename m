From: Steve French <smfrench@gmail.com>
Subject: Re: [patch] cifs: NULL dereference on allocation failure
Date: Tue, 24 Jan 2012 10:37:43 -0600
Message-ID: <CAH2r5msPnEzmOZNr-PBU3y40uJ+9FeZzbUGVxmMnc2bKeRurew@mail.gmail.com>
References: <20120124083922.GA29097@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	kernel-janitors@vger.kernel.org, samba-technical@lists.samba.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20120124083922.GA29097@elgon.mountain>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Merged into cifs-2.6.git

On Tue, Jan 24, 2012 at 2:39 AM, Dan Carpenter <dan.carpenter@oracle.com> w=
rote:
> We should just return directly here, the goto causes a NULL dereference.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 986709a..026d646 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3857,10 +3857,8 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, =
uid_t fsuid)
> =A0 =A0 =A0 =A0struct smb_vol *vol_info;
>
> =A0 =A0 =A0 =A0vol_info =3D kzalloc(sizeof(*vol_info), GFP_KERNEL);
> - =A0 =A0 =A0 if (vol_info =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon =3D ERR_PTR(-ENOMEM);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (vol_info =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-ENOMEM);
>
> =A0 =A0 =A0 =A0vol_info->local_nls =3D cifs_sb->local_nls;
> =A0 =A0 =A0 =A0vol_info->linux_uid =3D fsuid;



--=20
Thanks,

Steve
