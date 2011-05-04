From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: keep BCC in little-endian format (try #2)
Date: Wed, 4 May 2011 09:11:15 +0400
Message-ID: <BANLkTimzhtC9ZPbXS3tpdF380V0M0+YHxw@mail.gmail.com>
References: <1304087165-11427-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304087165-11427-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/29 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> This is the same patch as originally posted, just with some merge
> conflicts fixed up for some patches that went late into 2.6.39.
>
> Currently, the ByteCount is usually converted to host-endian on recei=
ve.
> This is confusing however, as we need to keep two sets of routines fo=
r
> accessing it, and keep track of when to use each routine. Munging
> received packets like this also limits when the signature can be
> calulated.
>
> Simplify the code by keeping the received ByteCount in little-endian
> format. This allows us to eliminate a set of routines for accessing i=
t
> and we can now drop the *_le suffixes from the accessor functions sin=
ce
> that's now implied.
>
> While we're at it, switch all of the places that read the ByteCount
> directly to use the get_bcc inline which should also clean up some
> unaligned accesses.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_debug.c | =A0 =A02 +-
> =A0fs/cifs/cifspdu.h =A0 =A0| =A0 22 +----------------
> =A0fs/cifs/cifsproto.h =A0| =A0 =A01 -
> =A0fs/cifs/cifssmb.c =A0 =A0| =A0 61 +++++++++++++++++++++++++-------=
-----------------
> =A0fs/cifs/connect.c =A0 =A0| =A0 =A04 +-
> =A0fs/cifs/misc.c =A0 =A0 =A0 | =A0 =A04 +-
> =A0fs/cifs/netmisc.c =A0 =A0| =A0 =A07 -----
> =A0fs/cifs/sess.c =A0 =A0 =A0 | =A0 =A02 +-
> =A0fs/cifs/transport.c =A0| =A0 19 +--------------
> =A09 files changed, 40 insertions(+), 82 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 30d01bc..18f4272 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -63,7 +63,7 @@ void cifs_dump_detail(struct smb_hdr *smb)
> =A0 =A0 =A0 =A0cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x M=
id: %d Pid: %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smb->Command, smb->Status.CifsErro=
r,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smb->Flags, smb->Flags2, smb->Mid,=
 smb->Pid);
> - =A0 =A0 =A0 cERROR(1, "smb buf %p len %d", smb, smbCalcSize_LE(smb)=
);
> + =A0 =A0 =A0 cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
> =A0}
>
>
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index b5c8cc5..e53c6b3 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -435,36 +435,18 @@ struct smb_hdr {
> =A0/* given a pointer to an smb_hdr retrieve the pointer to the byte =
area */
> =A0#define pByteArea(smb_var) (BCC(smb_var) + 2)
>
> -/* get the converted ByteCount for a SMB packet and return it */
> -static inline __u16
> -get_bcc(struct smb_hdr *hdr)
> -{
> - =A0 =A0 =A0 __u16 *bc_ptr =3D (__u16 *)BCC(hdr);
> -
> - =A0 =A0 =A0 return get_unaligned(bc_ptr);
> -}
> -
> =A0/* get the unconverted ByteCount for a SMB packet and return it */
> =A0static inline __u16
> -get_bcc_le(struct smb_hdr *hdr)
> +get_bcc(struct smb_hdr *hdr)
> =A0{
> =A0 =A0 =A0 =A0__le16 *bc_ptr =3D (__le16 *)BCC(hdr);
>
> =A0 =A0 =A0 =A0return get_unaligned_le16(bc_ptr);
> =A0}
>
> -/* set the ByteCount for a SMB packet in host-byte order */
> -static inline void
> -put_bcc(__u16 count, struct smb_hdr *hdr)
> -{
> - =A0 =A0 =A0 __u16 *bc_ptr =3D (__u16 *)BCC(hdr);
> -
> - =A0 =A0 =A0 put_unaligned(count, bc_ptr);
> -}
> -
> =A0/* set the ByteCount for a SMB packet in little-endian */
> =A0static inline void
> -put_bcc_le(__u16 count, struct smb_hdr *hdr)
> +put_bcc(__u16 count, struct smb_hdr *hdr)
> =A0{
> =A0 =A0 =A0 =A0__le16 *bc_ptr =3D (__le16 *)BCC(hdr);
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 0e4e057..0cdf375 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -90,7 +90,6 @@ extern void cifs_update_eof(struct cifsInodeInfo *c=
ifsi, loff_t offset,
> =A0extern struct cifsFileInfo *find_writable_file(struct cifsInodeInf=
o *, bool);
> =A0extern struct cifsFileInfo *find_readable_file(struct cifsInodeInf=
o *, bool);
> =A0extern unsigned int smbCalcSize(struct smb_hdr *ptr);
> -extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
> =A0extern int decode_negTokenInit(unsigned char *security_blob, int l=
ength,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct TCP_Server_Info=
 *server);
> =A0extern int cifs_convert_address(struct sockaddr *dst, const char *=
src, int len);
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 2710f00..5ae00d5 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -575,7 +575,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSes=
Info *ses)
>
> =A0 =A0 =A0 =A0if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(server->capabilities & CAP_EXTENDED_S=
ECURITY)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 count =3D pSMBr->ByteCount;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 count =3D get_bcc(&pSMBr->hdr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (count < 16) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto neg_err_exit;
> @@ -729,7 +729,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0smb->hdr.Tid =3D 0xffff;
> =A0 =A0 =A0 =A0smb->hdr.WordCount =3D 1;
> =A0 =A0 =A0 =A0put_unaligned_le16(1, &smb->EchoCount);
> - =A0 =A0 =A0 put_bcc_le(1, &smb->hdr);
> + =A0 =A0 =A0 put_bcc(1, &smb->hdr);
> =A0 =A0 =A0 =A0smb->Data[0] =3D 'a';
> =A0 =A0 =A0 =A0smb->hdr.smb_buf_length +=3D 3;
>
> @@ -1072,7 +1072,7 @@ PsxCreat:
> =A0 =A0 =A0 =A0cFYI(1, "copying inode info");
> =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp *)pSMBr);
>
> - =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < sizeof(OPEN_PSX_RSP))) {
> + =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < sizeof(OPEN_PSX_RSP)) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto psx_create_err;
> =A0 =A0 =A0 =A0}
> @@ -1093,7 +1093,7 @@ PsxCreat:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pRetData->Type =3D cpu_to_le32(-1); /*=
 unknown */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(DBG2, "unknown type");
> =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pSMBr->ByteCount < sizeof(OPEN_PSX_=
RSP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (get_bcc(&pSMBr->hdr) < sizeof(OPEN_=
PSX_RSP)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0+ sizeof(FILE_UNIX_BASIC_INFO)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Open respon=
se data too small");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pRetData->Type =3D cpu=
_to_le32(-1);
> @@ -1859,7 +1859,7 @@ CIFSSMBPosixLock(const int xid, struct cifsTcon=
Info *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 data_count;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < sizeof(st=
ruct cifs_posix_lock))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (get_bcc(&pSMBr->hdr) < sizeo=
f(struct cifs_posix_lock))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto plk_err_exit;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -2486,7 +2486,7 @@ querySymLinkRetry:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB also check enough total bytes re=
turned */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 2))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 2)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool is_unicode;
> @@ -2568,14 +2568,14 @@ CIFSSMBQueryReparseLinkInfo(const int xid, st=
ruct cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0} else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 data_offset =3D le32_to_cpu(pSMB=
r->DataOffset);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 data_count =3D le32_to_cpu(pSMBr=
->DataCount);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((pSMBr->ByteCount < 2) || (data_off=
set > 512)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB also check enough total bytes ret=
urned */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (get_bcc(&pSMBr->hdr) < 2 || data_of=
fset > 512) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB also check enough=
 total bytes returned */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto qreparse_out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (data_count && (data_count < 2048))=
 {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *end_of_smb =3D 2=
 /* sizeof byte count */ +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMBr->=
ByteCount + (char *)&pSMBr->ByteCount;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_bcc=
(&pSMBr->hdr) + (char *)&pSMBr->ByteCount;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct reparse_data *r=
eparse_buf =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0(struct reparse_data *)
> @@ -2833,7 +2833,7 @@ queryAclRetry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode response */
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 2))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 2)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB also check enough total bytes re=
turned */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {
> @@ -2983,7 +2983,7 @@ GetExtAttrRetry:
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode response */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 2))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 2)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB also check enough total bytes re=
turned */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* If rc should we che=
ck for EOPNOSUPP and
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 disable the srvin=
o flag? or in caller? */
> @@ -3059,6 +3059,7 @@ validate_ntransact(char *buf, char **ppparm, ch=
ar **ppdata,
> =A0 =A0 =A0 =A0char *end_of_smb;
> =A0 =A0 =A0 =A0__u32 data_count, data_offset, parm_count, parm_offset=
;
> =A0 =A0 =A0 =A0struct smb_com_ntransact_rsp *pSMBr;
> + =A0 =A0 =A0 u16 bcc;
>
> =A0 =A0 =A0 =A0*pdatalen =3D 0;
> =A0 =A0 =A0 =A0*pparmlen =3D 0;
> @@ -3068,8 +3069,8 @@ validate_ntransact(char *buf, char **ppparm, ch=
ar **ppdata,
>
> =A0 =A0 =A0 =A0pSMBr =3D (struct smb_com_ntransact_rsp *)buf;
>
> - =A0 =A0 =A0 /* ByteCount was converted from little endian in SendRe=
ceive */
> - =A0 =A0 =A0 end_of_smb =3D 2 /* sizeof byte count */ + pSMBr->ByteC=
ount +
> + =A0 =A0 =A0 bcc =3D get_bcc(&pSMBr->hdr);
> + =A0 =A0 =A0 end_of_smb =3D 2 /* sizeof byte count */ + bcc +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(char *)&pSMBr->ByteCo=
unt;
>
> =A0 =A0 =A0 =A0data_offset =3D le32_to_cpu(pSMBr->DataOffset);
> @@ -3095,7 +3096,7 @@ validate_ntransact(char *buf, char **ppparm, ch=
ar **ppdata,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*ppdata, data_count, (=
data_count + *ppdata),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end_of_smb, pSMBr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> - =A0 =A0 =A0 } else if (parm_count + data_count > pSMBr->ByteCount) =
{
> + =A0 =A0 =A0 } else if (parm_count + data_count > bcc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "parm count and data count lar=
ger than SMB");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> =A0 =A0 =A0 =A0}
> @@ -3382,7 +3383,7 @@ QFileInfoRetry:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) /* BB add auto retry on EOPNOT=
SUPP? */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (pSMBr->ByteCount < 40)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (get_bcc(&pSMBr->hdr) < 40)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (pFindData) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 data_offset =3D =
le16_to_cpu(pSMBr->t2.DataOffset);
> @@ -3470,9 +3471,9 @@ QPathInfoRetry:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) /* BB add auto retry on EOPNOT=
SUPP? */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (!legacy && (pSMBr->ByteCount <=
 40))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (!legacy && get_bcc(&pSMBr->hdr=
) < 40)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (legacy && (pSMBr->ByteCount < =
24))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (legacy && get_bcc(&pSMBr->hdr)=
 < 24)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0/* 24 =
or 26 expected but we do not read
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0last field */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (pFindData) {
> @@ -3548,7 +3549,7 @@ UnixQFileInfoRetry:
> =A0 =A0 =A0 =A0} else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < sizeof(FI=
LE_UNIX_BASIC_INFO))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < sizeof=
(FILE_UNIX_BASIC_INFO)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Malformed F=
ILE_UNIX_BASIC_INFO response.\n"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
Unix Extensions can be disabled on mount "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
by specifying the nosfu mount option.");
> @@ -3634,7 +3635,7 @@ UnixQPathInfoRetry:
> =A0 =A0 =A0 =A0} else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < sizeof(FI=
LE_UNIX_BASIC_INFO))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < sizeof=
(FILE_UNIX_BASIC_INFO)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Malformed F=
ILE_UNIX_BASIC_INFO response.\n"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
Unix Extensions can be disabled on mount "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
by specifying the nosfu mount option.");
> @@ -4039,7 +4040,7 @@ GetInodeNumberRetry:
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode response */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 2))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 2)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB also check enough total bytes re=
turned */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* If rc should we che=
ck for EOPNOSUPP and
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0disable the srvino fla=
g? or in caller? */
> @@ -4265,13 +4266,13 @@ getDFSRetry:
> =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp *)pSMBr);
>
> =A0 =A0 =A0 =A0/* BB Also check if enough total bytes returned? */
> - =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 17)) {
> + =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 17) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto GetDFSRefExit;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0cFYI(1, "Decoding GetDFSRefer response BCC: %d =A0Offs=
et %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMBr->=
ByteCount,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_bcc=
(&pSMBr->hdr),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le16_t=
o_cpu(pSMBr->t2.DataOffset));
>
> =A0 =A0 =A0 =A0/* parse returned result into more usable form */
> @@ -4337,12 +4338,12 @@ oldQFSInfoRetry:
> =A0 =A0 =A0 =A0} else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 18))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 18)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 data_offset =3D =
le16_to_cpu(pSMBr->t2.DataOffset);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "qfsinf resp B=
CC: %d =A0Offset %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB=
r->ByteCount, data_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0get_=
bcc(&pSMBr->hdr), data_offset);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0response_data =3D (FIL=
E_SYSTEM_ALLOC_INFO *)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(((cha=
r *) &pSMBr->hdr.Protocol) + data_offset);
> @@ -4416,7 +4417,7 @@ QFSInfoRetry:
> =A0 =A0 =A0 =A0} else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 24))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 24)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 data_offset =3D =
le16_to_cpu(pSMBr->t2.DataOffset);
> @@ -4496,7 +4497,7 @@ QFSAttributeRetry:
> =A0 =A0 =A0 =A0} else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 13)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 13) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB also check if en=
ough bytes returned */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> @@ -4567,7 +4568,7 @@ QFSDeviceRetry:
> =A0 =A0 =A0 =A0} else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < sizeof(FI=
LE_SYSTEM_DEVICE_INFO)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < sizeof=
(FILE_SYSTEM_DEVICE_INFO))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 data_offset =3D =
le16_to_cpu(pSMBr->t2.DataOffset);
> @@ -4636,7 +4637,7 @@ QFSUnixRetry:
> =A0 =A0 =A0 =A0} else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 13)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 13) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 data_offset =3D =
le16_to_cpu(pSMBr->t2.DataOffset);
> @@ -4781,7 +4782,7 @@ QFSPosixRetry:
> =A0 =A0 =A0 =A0} else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp =
*)pSMBr);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 13)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 13) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0=
/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 data_offset =3D =
le16_to_cpu(pSMBr->t2.DataOffset);
> @@ -5510,7 +5511,7 @@ QAllEAsRetry:
> =A0 =A0 =A0 =A0of these trans2 responses */
>
> =A0 =A0 =A0 =A0rc =3D validate_t2((struct smb_t2_rsp *)pSMBr);
> - =A0 =A0 =A0 if (rc || (pSMBr->ByteCount < 4)) {
> + =A0 =A0 =A0 if (rc || get_bcc(&pSMBr->hdr) < 4) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; =A0 =A0 =A0/* bad smb */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto QAllEAsOut;
> =A0 =A0 =A0 =A0}
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 9d05d8f..68bd894 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -316,12 +316,12 @@ static int coalesce_t2(struct smb_hdr *psecond,=
 struct smb_hdr *pTargetSMB)
> =A0 =A0 =A0 =A0put_unaligned_le16(total_in_buf, &pSMBt->t2_rsp.DataCo=
unt);
>
> =A0 =A0 =A0 =A0/* fix up the BCC */
> - =A0 =A0 =A0 byte_count =3D get_bcc_le(pTargetSMB);
> + =A0 =A0 =A0 byte_count =3D get_bcc(pTargetSMB);
> =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
> =A0 =A0 =A0 =A0/* is the result too big for the field? */
> =A0 =A0 =A0 =A0if (byte_count > USHRT_MAX)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EPROTO;
> - =A0 =A0 =A0 put_bcc_le(byte_count, pTargetSMB);
> + =A0 =A0 =A0 put_bcc(byte_count, pTargetSMB);
>
> =A0 =A0 =A0 =A0byte_count =3D pTargetSMB->smb_buf_length;
> =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 0c684ae..a0765e6 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -464,7 +464,7 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned=
 int length)
>
> =A0 =A0 =A0 =A0if (check_smb_hdr(smb, mid))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> - =A0 =A0 =A0 clc_len =3D smbCalcSize_LE(smb);
> + =A0 =A0 =A0 clc_len =3D smbCalcSize(smb);
>
> =A0 =A0 =A0 =A0if (4 + len !=3D length) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Length read does not match =
RFC1001 length %d",
> @@ -521,7 +521,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct=
 TCP_Server_Info *srv)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_com_transa=
ction_change_notify_rsp *)buf;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct file_notify_information *pnotif=
y;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 data_offset =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (get_bcc_le(buf) > sizeof(struct fil=
e_notify_information)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (get_bcc(buf) > sizeof(struct file_n=
otify_information)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0data_offset =3D le32_t=
o_cpu(pSMBr->DataOffset);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pnotify =3D (struct fi=
le_notify_information *)
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index 79f641e..79b71c2 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -919,13 +919,6 @@ smbCalcSize(struct smb_hdr *ptr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02 /* size of the bcc field */ + get_bc=
c(ptr));
> =A0}
>
> -unsigned int
> -smbCalcSize_LE(struct smb_hdr *ptr)
> -{
> - =A0 =A0 =A0 return (sizeof(struct smb_hdr) + (2 * ptr->WordCount) +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 2 /* size of the bcc field */ + get_bcc=
_le(ptr));
> -}
> -
> =A0/* The following are taken from fs/ntfs/util.c */
>
> =A0#define NTFS_TIME_OFFSET ((u64)(369*365 + 89) * 24 * 3600 * 100000=
00)
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index b6ff84a..74344ef 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -861,7 +861,7 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0count =3D iov[1].iov_len + iov[2].iov_len;
> =A0 =A0 =A0 =A0smb_buf->smb_buf_length +=3D count;
>
> - =A0 =A0 =A0 put_bcc_le(count, smb_buf);
> + =A0 =A0 =A0 put_bcc(count, smb_buf);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive2(xid, ses, iov, 3 /* num_iovecs */,=
 &resp_buf_type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_LOG_ERROR);
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 46d8756..44f4f49 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -491,7 +491,7 @@ send_nt_cancel(struct TCP_Server_Info *server, st=
ruct smb_hdr *in_buf,
> =A0 =A0 =A0 =A0in_buf->smb_buf_length =3D sizeof(struct smb_hdr) - 4 =
=A0+ 2;
> =A0 =A0 =A0 =A0in_buf->Command =3D SMB_COM_NT_CANCEL;
> =A0 =A0 =A0 =A0in_buf->WordCount =3D 0;
> - =A0 =A0 =A0 put_bcc_le(0, in_buf);
> + =A0 =A0 =A0 put_bcc(0, in_buf);
>
> =A0 =A0 =A0 =A0mutex_lock(&server->srv_mutex);
> =A0 =A0 =A0 =A0rc =3D cifs_sign_smb(in_buf, server, &mid->sequence_nu=
mber);
> @@ -651,11 +651,6 @@ SendReceive2(const unsigned int xid, struct cifs=
SesInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D map_smb_to_linux_error(midQ->re=
sp_buf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0flags & CIFS_LOG_ERROR);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* convert ByteCount if necessary */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (receive_len >=3D sizeof(struct smb_=
hdr) - 4
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* do not count RFC1001 header =
*/ =A0+
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (2 * midQ->resp_buf->WordCount)=
 + 2 /* bcc */ )
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_bcc(get_bcc_le(midQ=
->resp_buf), midQ->resp_buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((flags & CIFS_NO_RESP) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->resp_buf =3D NUL=
L; =A0/* mark it so buf will
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 not be freed by
> @@ -804,12 +799,6 @@ SendReceive(const unsigned int xid, struct cifsS=
esInfo *ses,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB special case reconnect tid and u=
id here? */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D map_smb_to_linux_error(out_buf,=
 0 /* no log */ );
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* convert ByteCount if necessary */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (receive_len >=3D sizeof(struct smb_=
hdr) - 4
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* do not count RFC1001 header =
*/ =A0+
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (2 * out_buf->WordCount) + 2 /*=
 bcc */ )
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_bcc(get_bcc_le(midQ=
->resp_buf), midQ->resp_buf);
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Bad MID state?");
> @@ -1017,12 +1006,6 @@ SendReceiveBlockingLock(const unsigned int xid=
, struct cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0/* BB special case reconnect tid and uid here? */
> =A0 =A0 =A0 =A0rc =3D map_smb_to_linux_error(out_buf, 0 /* no log */ =
);
>
> - =A0 =A0 =A0 /* convert ByteCount if necessary */
> - =A0 =A0 =A0 if (receive_len >=3D sizeof(struct smb_hdr) - 4
> - =A0 =A0 =A0 =A0 =A0 /* do not count RFC1001 header */ =A0+
> - =A0 =A0 =A0 =A0 =A0 (2 * out_buf->WordCount) + 2 /* bcc */ )
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_bcc(get_bcc_le(out_buf), out_buf);
> -
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> =A0 =A0 =A0 =A0if (rstart && rc =3D=3D -EACCES)
> --
> 1.7.4.4

This patch has checkpatch warnings:
WARNING: line over 80 characters
#152: FILE: fs/cifs/cifssmb.c:1870:
+		if (rc || (get_bcc(&pSMBr->hdr) < sizeof(struct cifs_posix_lock))) {

WARNING: line over 80 characters
#179: FILE: fs/cifs/cifssmb.c:2586:
+				get_bcc(&pSMBr->hdr) + (char *)&pSMBr->ByteCount;

WARNING: suspect code indent for conditional statements (16, 16)
#188: FILE: fs/cifs/cifssmb.c:2844:
+		if (rc || get_bcc(&pSMBr->hdr) < 2)
 		/* BB also check enough total bytes returned */

WARNING: suspect code indent for conditional statements (16, 16)
#197: FILE: fs/cifs/cifssmb.c:2994:
+		if (rc || get_bcc(&pSMBr->hdr) < 2)
 		/* BB also check enough total bytes returned */

WARNING: suspect code indent for conditional statements (16, 16)
#273: FILE: fs/cifs/cifssmb.c:4050:
+		if (rc || get_bcc(&pSMBr->hdr) < 2)
 		/* BB also check enough total bytes returned */

WARNING: line over 80 characters
#331: FILE: fs/cifs/cifssmb.c:4578:
+		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_SYSTEM_DEVICE_INFO))

total: 0 errors, 6 warnings, 373 lines checked

--=20
Best regards,
Pavel Shilovsky.
