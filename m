From: Steve French <smfrench@gmail.com>
Subject: =?windows-1252?Q?Re=3A_=5BPATCH=5D_cifssmb=3A_=5BFIX=5D_warning=3A_=91pdata=92_may_?=
	=?windows-1252?Q?be_used_uninitialized?=
Date: Sun, 13 Mar 2011 13:35:08 -0500
Message-ID: <AANLkTiko9Y6z79XwkxN7dEAyikQbO=Azdiu0hhK+uiJc@mail.gmail.com>
References: <1300033426-22404-1-git-send-email-richard.genoud@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	kernel-janitors@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
To: Richard Genoud <richard.genoud@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1300033426-22404-1-git-send-email-richard.genoud@gmail.com>
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

This does look a problem with the compiler.  Which compiler version?

As you noted, pdata is either initialized or we return rc!=3D0 and don't us=
e it.

On Sun, Mar 13, 2011 at 11:23 AM, Richard Genoud
<richard.genoud@gmail.com> wrote:
> This suppress the warning, as far as there's no way pdata is
> uninitialized, because validate_ntransact() will initialize pdata or
> return rc !=3D 0. In this case (goto qsec_out), pdata won't be used.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
> =A0fs/cifs/cifssmb.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 904aa47..efa3f8e 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3138,7 +3138,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInf=
o *tcon, __u16 fid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 parm_len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 acl_len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_com_ntransact_rsp *pSMBr;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *pdata;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *pdata =3D NULL;
>
> =A0/* validate_nttransact */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_ntransact(iov[0].iov_base,=
 (char **)&parm,
> --
> 1.7.1
>
>



--=20
Thanks,

Steve
