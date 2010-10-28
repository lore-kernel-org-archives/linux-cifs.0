From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove "legacy" parm from CIFSSMBQPathInfo
Date: Thu, 28 Oct 2010 10:42:57 -0500
Message-ID: <AANLkTikpemR3PVzXSimbu-b1zn4QwQj+0VAEM9xwgYqt@mail.gmail.com>
References: <4CC921E7.9020403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC921E7.9020403-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

What is the code flow then on Windows9x, OS/2 or in the EOPNOSUPP
case?  Seems strange that we don't retry with legacy or in the case
where the dialect (or previous call) shows that we don't support the
infolevel.

On Thu, Oct 28, 2010 at 2:10 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> =
wrote:
> as all the callers are setting it to 0 anyway.
>
> I stumbled upon this code when I was looking at the strange hardlink
> behavior reported in the mailing list. But it seems this patch was
> originally posted by Jeff Layton on Feb:
> =A0http://lists.samba.org/archive/linux-cifs-client/2010-February/005=
557.html
>
> I didn't see any discussions, ACK/NACK on this patch.
>
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A01 -
> =A0fs/cifs/cifssmb.c =A0 | =A0 22 +++-------------------
> =A0fs/cifs/connect.c =A0 | =A0 =A02 +-
> =A0fs/cifs/inode.c =A0 =A0 | =A0 =A01 -
> =A04 files changed, 4 insertions(+), 22 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index edb6d90..fa7e8d1 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -167,7 +167,6 @@ extern int CIFSSMBQFileInfo(const int xid, struct=
 cifsTconInfo *tcon,
> =A0extern int CIFSSMBQPathInfo(const int xid, struct cifsTconInfo *tc=
on,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const unsigned char *s=
earchName,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FILE_ALL_INFO *findDat=
a,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int legacy /* whether t=
o use old info level */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table=
 *nls_codepage, int remap);
> =A0extern int SMBQueryInformation(const int xid, struct cifsTconInfo =
*tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const unsigned char *s=
earchName,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index e98f1f3..392c01b 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3356,7 +3356,6 @@ int
> =A0CIFSSMBQPathInfo(const int xid, struct cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned char *searchName,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FILE_ALL_INFO *pFindData,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int legacy /* old style infolevel */=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nls_codepage,=
 int remap)
> =A0{
> =A0/* level 263 SMB_QUERY_FILE_ALL_INFO */
> @@ -3406,10 +3405,7 @@ QPathInfoRetry:
> =A0 =A0 =A0 =A0byte_count =3D params + 1 /* pad */ ;
> =A0 =A0 =A0 =A0pSMB->TotalParameterCount =3D cpu_to_le16(params);
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D pSMB->TotalParameterCount;
> - =A0 =A0 =A0 if (legacy)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->InformationLevel =3D cpu_to_le16(=
SMB_INFO_STANDARD);
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->InformationLevel =3D cpu_to_le16(=
SMB_QUERY_FILE_ALL_INFO);
> + =A0 =A0 =A0 pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_FILE_A=
LL_INFO);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> =A0 =A0 =A0 =A0pSMB->hdr.smb_buf_length +=3D byte_count;
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> @@ -3423,26 +3419,14 @@ QPathInfoRetry:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) /* BB add auto retry on EOPNOT=
SUPP? */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (!legacy && (pSMBr->ByteCount <=
 40))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (pSMBr->ByteCount < 40)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (legacy && (pSMBr->ByteCount < =
24))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO; =A0/* 24 o=
r 26 expected but we do not read
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 last field */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (pFindData) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int size;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 data_offset =3D =
le16_to_cpu(pSMBr->t2.DataOffset);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* On legacy responses =
we do not read the last field,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EAsize, fortunately sin=
ce it varies by subdialect and
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 also note it differs on=
 Set vs. Get, ie two bytes or 4
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes depending but we =
don't care here */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (legacy)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size =3D=
 sizeof(FILE_INFO_STANDARD);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size =3D=
 sizeof(FILE_ALL_INFO);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy((char *) pFindD=
ata,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *) =
&pSMBr->hdr.Protocol +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0data_off=
set, size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0data_off=
set, sizeof(FILE_ALL_INFO));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> =A0 =A0 =A0 =A0}
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 469c3dd..b44bfd5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2629,7 +2629,7 @@ is_path_accessible(int xid, struct cifsTconInfo=
 *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>
> =A0 =A0 =A0 =A0rc =3D CIFSSMBQPathInfo(xid, tcon, full_path, pfile_in=
fo,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 /* not le=
gacy */, cifs_sb->local_nls,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->lo=
cal_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->m=
nt_cifs_flags &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_M=
OUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0kfree(pfile_info);
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 39869c3..2448ad1 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -615,7 +615,6 @@ int cifs_get_inode_info(struct inode **pinode,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* could do find first instead but thi=
s returns more info */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBQPathInfo(xid, pTcon, fu=
ll_path, pfindData,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 /* not le=
gacy */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->l=
ocal_nls, cifs_sb->mnt_cifs_flags &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_M=
OUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB optimize code so we do not make =
the above call
>



--=20
Thanks,

Steve
