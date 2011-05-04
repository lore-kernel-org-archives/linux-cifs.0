From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: keep BCC in little-endian format (try #2)
Date: Wed, 4 May 2011 07:11:11 -0400
Message-ID: <20110504071111.57b82f36@tlielax.poochiereds.net>
References: <1304087165-11427-1-git-send-email-jlayton@redhat.com>
	<BANLkTimzhtC9ZPbXS3tpdF380V0M0+YHxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimzhtC9ZPbXS3tpdF380V0M0+YHxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 4 May 2011 09:11:15 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/4/29 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > This is the same patch as originally posted, just with some merge
> > conflicts fixed up for some patches that went late into 2.6.39.
> >
> > Currently, the ByteCount is usually converted to host-endian on rec=
eive.
> > This is confusing however, as we need to keep two sets of routines =
for
> > accessing it, and keep track of when to use each routine. Munging
> > received packets like this also limits when the signature can be
> > calulated.
> >
> > Simplify the code by keeping the received ByteCount in little-endia=
n
> > format. This allows us to eliminate a set of routines for accessing=
 it
> > and we can now drop the *_le suffixes from the accessor functions s=
ince
> > that's now implied.
> >
> > While we're at it, switch all of the places that read the ByteCount
> > directly to use the get_bcc inline which should also clean up some
> > unaligned accesses.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/cifs_debug.c | =C2=A0 =C2=A02 +-
> > =C2=A0fs/cifs/cifspdu.h =C2=A0 =C2=A0| =C2=A0 22 +----------------
> > =C2=A0fs/cifs/cifsproto.h =C2=A0| =C2=A0 =C2=A01 -
> > =C2=A0fs/cifs/cifssmb.c =C2=A0 =C2=A0| =C2=A0 61 ++++++++++++++++++=
+++++++------------------------
> > =C2=A0fs/cifs/connect.c =C2=A0 =C2=A0| =C2=A0 =C2=A04 +-
> > =C2=A0fs/cifs/misc.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A04 +-
> > =C2=A0fs/cifs/netmisc.c =C2=A0 =C2=A0| =C2=A0 =C2=A07 -----
> > =C2=A0fs/cifs/sess.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A02 +-
> > =C2=A0fs/cifs/transport.c =C2=A0| =C2=A0 19 +--------------
> > =C2=A09 files changed, 40 insertions(+), 82 deletions(-)
> >
> > diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> > index 30d01bc..18f4272 100644
> > --- a/fs/cifs/cifs_debug.c
> > +++ b/fs/cifs/cifs_debug.c
> > @@ -63,7 +63,7 @@ void cifs_dump_detail(struct smb_hdr *smb)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x=
 Flgs2: 0x%x Mid: %d Pid: %d",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0smb->=
Command, smb->Status.CifsError,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0smb->=
=46lags, smb->Flags2, smb->Mid, smb->Pid);
> > - =C2=A0 =C2=A0 =C2=A0 cERROR(1, "smb buf %p len %d", smb, smbCalcS=
ize_LE(smb));
> > + =C2=A0 =C2=A0 =C2=A0 cERROR(1, "smb buf %p len %d", smb, smbCalcS=
ize(smb));
> > =C2=A0}
> >
> >
> > diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> > index b5c8cc5..e53c6b3 100644
> > --- a/fs/cifs/cifspdu.h
> > +++ b/fs/cifs/cifspdu.h
> > @@ -435,36 +435,18 @@ struct smb_hdr {
> > =C2=A0/* given a pointer to an smb_hdr retrieve the pointer to the =
byte area */
> > =C2=A0#define pByteArea(smb_var) (BCC(smb_var) + 2)
> >
> > -/* get the converted ByteCount for a SMB packet and return it */
> > -static inline __u16
> > -get_bcc(struct smb_hdr *hdr)
> > -{
> > - =C2=A0 =C2=A0 =C2=A0 __u16 *bc_ptr =3D (__u16 *)BCC(hdr);
> > -
> > - =C2=A0 =C2=A0 =C2=A0 return get_unaligned(bc_ptr);
> > -}
> > -
> > =C2=A0/* get the unconverted ByteCount for a SMB packet and return =
it */
> > =C2=A0static inline __u16
> > -get_bcc_le(struct smb_hdr *hdr)
> > +get_bcc(struct smb_hdr *hdr)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 *bc_ptr =3D (__le16 *)BCC(hdr);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return get_unaligned_le16(bc_ptr);
> > =C2=A0}
> >
> > -/* set the ByteCount for a SMB packet in host-byte order */
> > -static inline void
> > -put_bcc(__u16 count, struct smb_hdr *hdr)
> > -{
> > - =C2=A0 =C2=A0 =C2=A0 __u16 *bc_ptr =3D (__u16 *)BCC(hdr);
> > -
> > - =C2=A0 =C2=A0 =C2=A0 put_unaligned(count, bc_ptr);
> > -}
> > -
> > =C2=A0/* set the ByteCount for a SMB packet in little-endian */
> > =C2=A0static inline void
> > -put_bcc_le(__u16 count, struct smb_hdr *hdr)
> > +put_bcc(__u16 count, struct smb_hdr *hdr)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 *bc_ptr =3D (__le16 *)BCC(hdr);
> >
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index 0e4e057..0cdf375 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -90,7 +90,6 @@ extern void cifs_update_eof(struct cifsInodeInfo =
*cifsi, loff_t offset,
> > =C2=A0extern struct cifsFileInfo *find_writable_file(struct cifsIno=
deInfo *, bool);
> > =C2=A0extern struct cifsFileInfo *find_readable_file(struct cifsIno=
deInfo *, bool);
> > =C2=A0extern unsigned int smbCalcSize(struct smb_hdr *ptr);
> > -extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
> > =C2=A0extern int decode_negTokenInit(unsigned char *security_blob, =
int length,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0struct TCP_Server_Info *server);
> > =C2=A0extern int cifs_convert_address(struct sockaddr *dst, const c=
har *src, int len);
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 2710f00..5ae00d5 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -575,7 +575,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsS=
esInfo *ses)
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC=
) &&
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(server->cap=
abilities & CAP_EXTENDED_SECURITY)) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 count =3D pSMBr-=
>ByteCount;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 count =3D get_bc=
c(&pSMBr->hdr);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (count < =
16) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0goto neg_err_exit;
> > @@ -729,7 +729,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0smb->hdr.Tid =3D 0xffff;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0smb->hdr.WordCount =3D 1;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0put_unaligned_le16(1, &smb->EchoCount);
> > - =C2=A0 =C2=A0 =C2=A0 put_bcc_le(1, &smb->hdr);
> > + =C2=A0 =C2=A0 =C2=A0 put_bcc(1, &smb->hdr);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0smb->Data[0] =3D 'a';
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0smb->hdr.smb_buf_length +=3D 3;
> >
> > @@ -1072,7 +1072,7 @@ PsxCreat:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "copying inode info");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D validate_t2((struct smb_t2_rsp *)=
pSMBr);
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr->ByteCount < sizeof(OPEN_PS=
X_RSP))) {
> > + =C2=A0 =C2=A0 =C2=A0 if (rc || get_bcc(&pSMBr->hdr) < sizeof(OPEN=
_PSX_RSP)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -EIO;=
 =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto psx_cre=
ate_err;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > @@ -1093,7 +1093,7 @@ PsxCreat:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pRetData->Ty=
pe =3D cpu_to_le32(-1); /* unknown */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(DBG2, "=
unknown type");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (pSMBr->ByteC=
ount < sizeof(OPEN_PSX_RSP)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (get_bcc(&pSM=
Br->hdr) < sizeof(OPEN_PSX_RSP)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+=
 sizeof(FILE_UNIX_BASIC_INFO)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cERROR(1, "Open response data too small");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0pRetData->Type =3D cpu_to_le32(-1);
> > @@ -1859,7 +1859,7 @@ CIFSSMBPosixLock(const int xid, struct cifsTc=
onInfo *tcon,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u16 data_c=
ount;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < sizeof(struct cifs_posix_lock))) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (get_b=
cc(&pSMBr->hdr) < sizeof(struct cifs_posix_lock))) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0goto plk_err_exit;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > @@ -2486,7 +2486,7 @@ querySymLinkRetry:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* BB also c=
heck enough total bytes returned */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < 2))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < 2)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0bool is_unicode;
> > @@ -2568,14 +2568,14 @@ CIFSSMBQueryReparseLinkInfo(const int xid, =
struct cifsTconInfo *tcon,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else { =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* decode response */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 data_o=
ffset =3D le32_to_cpu(pSMBr->DataOffset);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 data_c=
ount =3D le32_to_cpu(pSMBr->DataCount);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((pSMBr->Byte=
Count < 2) || (data_offset > 512)) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* BB also check=
 enough total bytes returned */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (get_bcc(&pSM=
Br->hdr) < 2 || data_offset > 512) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* BB also check enough total bytes returned */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0goto qreparse_out;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (data_cou=
nt && (data_count < 2048)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0char *end_of_smb =3D 2 /* sizeof byte count */ +
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pSMBr->ByteCount + (char *)&pSMB=
r->ByteCount;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 get_bcc(&pSMBr->hdr) + (char *)&=
pSMBr->ByteCount;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0struct reparse_data *reparse_buf =3D
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0(struct reparse_data *)
> > @@ -2833,7 +2833,7 @@ queryAclRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* decode re=
sponse */
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < 2))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < 2)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* BB also c=
heck enough total bytes returned */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> > @@ -2983,7 +2983,7 @@ GetExtAttrRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* decode re=
sponse */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < 2))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < 2)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* BB also c=
heck enough total bytes returned */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* If rc should we check for EOPNOSUPP and
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 disable the srvino flag? or in caller? */
> > @@ -3059,6 +3059,7 @@ validate_ntransact(char *buf, char **ppparm, =
char **ppdata,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *end_of_smb;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 data_count, data_offset, parm_coun=
t, parm_offset;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct smb_com_ntransact_rsp *pSMBr;
> > + =C2=A0 =C2=A0 =C2=A0 u16 bcc;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0*pdatalen =3D 0;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0*pparmlen =3D 0;
> > @@ -3068,8 +3069,8 @@ validate_ntransact(char *buf, char **ppparm, =
char **ppdata,
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0pSMBr =3D (struct smb_com_ntransact_rsp =
*)buf;
> >
> > - =C2=A0 =C2=A0 =C2=A0 /* ByteCount was converted from little endia=
n in SendReceive */
> > - =C2=A0 =C2=A0 =C2=A0 end_of_smb =3D 2 /* sizeof byte count */ + p=
SMBr->ByteCount +
> > + =C2=A0 =C2=A0 =C2=A0 bcc =3D get_bcc(&pSMBr->hdr);
> > + =C2=A0 =C2=A0 =C2=A0 end_of_smb =3D 2 /* sizeof byte count */ + b=
cc +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(char *)&pSMBr->ByteCount;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0data_offset =3D le32_to_cpu(pSMBr->DataO=
ffset);
> > @@ -3095,7 +3096,7 @@ validate_ntransact(char *buf, char **ppparm, =
char **ppdata,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0*ppdata, data_count, (data_count + *ppdata),
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0end_of_smb, pSMBr);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINV=
AL;
> > - =C2=A0 =C2=A0 =C2=A0 } else if (parm_count + data_count > pSMBr->=
ByteCount) {
> > + =C2=A0 =C2=A0 =C2=A0 } else if (parm_count + data_count > bcc) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "par=
m count and data count larger than SMB");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINV=
AL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > @@ -3382,7 +3383,7 @@ QFileInfoRetry:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc) /* B=
B add auto retry on EOPNOTSUPP? */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (pSMBr->=
ByteCount < 40)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (get_bcc=
(&pSMBr->hdr) < 40)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (pFi=
ndData) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataOffset);
> > @@ -3470,9 +3471,9 @@ QPathInfoRetry:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc) /* B=
B add auto retry on EOPNOTSUPP? */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (!legacy=
 && (pSMBr->ByteCount < 40))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (!legacy=
 && get_bcc(&pSMBr->hdr) < 40)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (legacy =
&& (pSMBr->ByteCount < 24))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (legacy =
&& get_bcc(&pSMBr->hdr) < 24)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0/* 24 or 26 expected but we do not rea=
d
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0l=
ast field */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else if (pFi=
ndData) {
> > @@ -3548,7 +3549,7 @@ UnixQFileInfoRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else { =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* decode response */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < sizeof(FILE_UNIX_BASIC_INFO))) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response.\n"
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Unix Extensions can =
be disabled on mount "
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "by specifying the no=
sfu mount option.");
> > @@ -3634,7 +3635,7 @@ UnixQPathInfoRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else { =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* decode response */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < sizeof(FILE_UNIX_BASIC_INFO))) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response.\n"
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Unix Extensions can =
be disabled on mount "
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "by specifying the no=
sfu mount option.");
> > @@ -4039,7 +4040,7 @@ GetInodeNumberRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* decode re=
sponse */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < 2))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < 2)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* BB also c=
heck enough total bytes returned */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* If rc should we check for EOPNOSUPP and
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0disable the srvino flag? or in caller? */
> > @@ -4265,13 +4266,13 @@ getDFSRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D validate_t2((struct smb_t2_rsp *)=
pSMBr);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* BB Also check if enough total bytes r=
eturned? */
> > - =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr->ByteCount < 17)) {
> > + =C2=A0 =C2=A0 =C2=A0 if (rc || get_bcc(&pSMBr->hdr) < 17) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -EIO;=
 =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto GetDFSR=
efExit;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "Decoding GetDFSRefer response B=
CC: %d =C2=A0Offset %d",
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pSMBr->ByteCount,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 get_bcc(&pSMBr->hdr),
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0le16_to_cpu(pSMBr->t2.DataOff=
set));
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* parse returned result into more usabl=
e form */
> > @@ -4337,12 +4338,12 @@ oldQFSInfoRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else { =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* decode response */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < 18))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < 18)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataOffset);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cFYI(1, "qfsinf resp BCC: %d =C2=A0Offset %d",
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pSMBr->ByteCount, data_off=
set);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0get_bcc(&pSMBr->hdr), data=
_offset);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0response_data =3D (FILE_SYSTEM_ALLOC_INFO *)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(((char *) &pSMBr->hdr.Protoc=
ol) + data_offset);
> > @@ -4416,7 +4417,7 @@ QFSInfoRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else { =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* decode response */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < 24))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < 24)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataOffset);
> > @@ -4496,7 +4497,7 @@ QFSAttributeRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else { =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* decode response */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < 13)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < 13) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0/* BB also check if enough bytes returned */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > @@ -4567,7 +4568,7 @@ QFSDeviceRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else { =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* decode response */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < sizeof(FILE_SYSTEM_DEVICE_INFO)))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < sizeof(FILE_SYSTEM_DEVICE_INFO))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataOffset);
> > @@ -4636,7 +4637,7 @@ QFSUnixRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else { =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* decode response */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < 13)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < 13) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataOffset);
> > @@ -4781,7 +4782,7 @@ QFSPosixRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else { =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0/* decode response */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D valid=
ate_t2((struct smb_t2_rsp *)pSMBr);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr=
->ByteCount < 13)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc || get_bc=
c(&pSMBr->hdr) < 13) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0rc =3D -EIO; =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0__u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataOffset);
> > @@ -5510,7 +5511,7 @@ QAllEAsRetry:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0of these trans2 responses */
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D validate_t2((struct smb_t2_rsp *)=
pSMBr);
> > - =C2=A0 =C2=A0 =C2=A0 if (rc || (pSMBr->ByteCount < 4)) {
> > + =C2=A0 =C2=A0 =C2=A0 if (rc || get_bcc(&pSMBr->hdr) < 4) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -EIO;=
 =C2=A0 =C2=A0 =C2=A0/* bad smb */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto QAllEAs=
Out;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 9d05d8f..68bd894 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -316,12 +316,12 @@ static int coalesce_t2(struct smb_hdr *psecon=
d, struct smb_hdr *pTargetSMB)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0put_unaligned_le16(total_in_buf, &pSMBt-=
>t2_rsp.DataCount);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* fix up the BCC */
> > - =C2=A0 =C2=A0 =C2=A0 byte_count =3D get_bcc_le(pTargetSMB);
> > + =C2=A0 =C2=A0 =C2=A0 byte_count =3D get_bcc(pTargetSMB);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0byte_count +=3D total_in_buf2;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* is the result too big for the field? =
*/
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (byte_count > USHRT_MAX)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EPRO=
TO;
> > - =C2=A0 =C2=A0 =C2=A0 put_bcc_le(byte_count, pTargetSMB);
> > + =C2=A0 =C2=A0 =C2=A0 put_bcc(byte_count, pTargetSMB);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0byte_count =3D pTargetSMB->smb_buf_lengt=
h;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0byte_count +=3D total_in_buf2;
> > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> > index 0c684ae..a0765e6 100644
> > --- a/fs/cifs/misc.c
> > +++ b/fs/cifs/misc.c
> > @@ -464,7 +464,7 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsign=
ed int length)
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (check_smb_hdr(smb, mid))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;
> > - =C2=A0 =C2=A0 =C2=A0 clc_len =3D smbCalcSize_LE(smb);
> > + =C2=A0 =C2=A0 =C2=A0 clc_len =3D smbCalcSize(smb);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (4 + len !=3D length) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cERROR(1, "L=
ength read does not match RFC1001 length %d",
> > @@ -521,7 +521,7 @@ is_valid_oplock_break(struct smb_hdr *buf, stru=
ct TCP_Server_Info *srv)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(struct smb_com_transaction_change_notify_rsp *)buf;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct file_=
notify_information *pnotify;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 data_o=
ffset =3D 0;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (get_bcc_le(b=
uf) > sizeof(struct file_notify_information)) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (get_bcc(buf)=
 > sizeof(struct file_notify_information)) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0data_offset =3D le32_to_cpu(pSMBr->DataOffset);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0pnotify =3D (struct file_notify_information *)
> > diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> > index 79f641e..79b71c2 100644
> > --- a/fs/cifs/netmisc.c
> > +++ b/fs/cifs/netmisc.c
> > @@ -919,13 +919,6 @@ smbCalcSize(struct smb_hdr *ptr)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02 /* size of=
 the bcc field */ + get_bcc(ptr));
> > =C2=A0}
> >
> > -unsigned int
> > -smbCalcSize_LE(struct smb_hdr *ptr)
> > -{
> > - =C2=A0 =C2=A0 =C2=A0 return (sizeof(struct smb_hdr) + (2 * ptr->W=
ordCount) +
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 2 /* size of the=
 bcc field */ + get_bcc_le(ptr));
> > -}
> > -
> > =C2=A0/* The following are taken from fs/ntfs/util.c */
> >
> > =C2=A0#define NTFS_TIME_OFFSET ((u64)(369*365 + 89) * 24 * 3600 * 1=
0000000)
> > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > index b6ff84a..74344ef 100644
> > --- a/fs/cifs/sess.c
> > +++ b/fs/cifs/sess.c
> > @@ -861,7 +861,7 @@ ssetup_ntlmssp_authenticate:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0count =3D iov[1].iov_len + iov[2].iov_le=
n;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0smb_buf->smb_buf_length +=3D count;
> >
> > - =C2=A0 =C2=A0 =C2=A0 put_bcc_le(count, smb_buf);
> > + =C2=A0 =C2=A0 =C2=A0 put_bcc(count, smb_buf);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D SendReceive2(xid, ses, iov, 3 /* =
num_iovecs */, &resp_buf_type,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0CIFS_LOG_ERROR);
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 46d8756..44f4f49 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -491,7 +491,7 @@ send_nt_cancel(struct TCP_Server_Info *server, =
struct smb_hdr *in_buf,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0in_buf->smb_buf_length =3D sizeof(struct=
 smb_hdr) - 4 =C2=A0+ 2;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0in_buf->Command =3D SMB_COM_NT_CANCEL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0in_buf->WordCount =3D 0;
> > - =C2=A0 =C2=A0 =C2=A0 put_bcc_le(0, in_buf);
> > + =C2=A0 =C2=A0 =C2=A0 put_bcc(0, in_buf);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&server->srv_mutex);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D cifs_sign_smb(in_buf, server, &mi=
d->sequence_number);
> > @@ -651,11 +651,6 @@ SendReceive2(const unsigned int xid, struct ci=
fsSesInfo *ses,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D map_s=
mb_to_linux_error(midQ->resp_buf,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0flags & CIFS_LOG_ERROR);
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* convert ByteC=
ount if necessary */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (receive_len =
>=3D sizeof(struct smb_hdr) - 4
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*=
 do not count RFC1001 header */ =C2=A0+
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (2=
 * midQ->resp_buf->WordCount) + 2 /* bcc */ )
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 put_bcc(get_bcc_le(midQ->resp_buf), midQ->resp_buf);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((flags &=
 CIFS_NO_RESP) =3D=3D 0)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0midQ->resp_buf =3D NULL; =C2=A0/* mark it so buf will
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 not be freed by
> > @@ -804,12 +799,6 @@ SendReceive(const unsigned int xid, struct cif=
sSesInfo *ses,
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* BB specia=
l case reconnect tid and uid here? */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D map_s=
mb_to_linux_error(out_buf, 0 /* no log */ );
> > -
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* convert ByteC=
ount if necessary */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (receive_len =
>=3D sizeof(struct smb_hdr) - 4
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*=
 do not count RFC1001 header */ =C2=A0+
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (2=
 * out_buf->WordCount) + 2 /* bcc */ )
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 put_bcc(get_bcc_le(midQ->resp_buf), midQ->resp_buf);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -EIO;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cERROR(1, "B=
ad MID state?");
> > @@ -1017,12 +1006,6 @@ SendReceiveBlockingLock(const unsigned int x=
id, struct cifsTconInfo *tcon,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* BB special case reconnect tid and uid=
 here? */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D map_smb_to_linux_error(out_buf, 0=
 /* no log */ );
> >
> > - =C2=A0 =C2=A0 =C2=A0 /* convert ByteCount if necessary */
> > - =C2=A0 =C2=A0 =C2=A0 if (receive_len >=3D sizeof(struct smb_hdr) =
- 4
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* do not count RFC1001 header=
 */ =C2=A0+
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (2 * out_buf->WordCount) + 2 /=
* bcc */ )
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 put_bcc(get_bcc_=
le(out_buf), out_buf);
> > -
> > =C2=A0out:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0delete_mid(midQ);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rstart && rc =3D=3D -EACCES)
> > --
> > 1.7.4.4
>=20
> This patch has checkpatch warnings:
> WARNING: line over 80 characters
> #152: FILE: fs/cifs/cifssmb.c:1870:
> +		if (rc || (get_bcc(&pSMBr->hdr) < sizeof(struct cifs_posix_lock)))=
 {
>=20
> WARNING: line over 80 characters
> #179: FILE: fs/cifs/cifssmb.c:2586:
> +				get_bcc(&pSMBr->hdr) + (char *)&pSMBr->ByteCount;
>=20
> WARNING: suspect code indent for conditional statements (16, 16)
> #188: FILE: fs/cifs/cifssmb.c:2844:
> +		if (rc || get_bcc(&pSMBr->hdr) < 2)
>  		/* BB also check enough total bytes returned */
>=20
> WARNING: suspect code indent for conditional statements (16, 16)
> #197: FILE: fs/cifs/cifssmb.c:2994:
> +		if (rc || get_bcc(&pSMBr->hdr) < 2)
>  		/* BB also check enough total bytes returned */
>=20
> WARNING: suspect code indent for conditional statements (16, 16)
> #273: FILE: fs/cifs/cifssmb.c:4050:
> +		if (rc || get_bcc(&pSMBr->hdr) < 2)
>  		/* BB also check enough total bytes returned */
>=20
> WARNING: line over 80 characters
> #331: FILE: fs/cifs/cifssmb.c:4578:
> +		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_SYSTEM_DEVICE_INFO))
>=20
> total: 0 errors, 6 warnings, 373 lines checked
>=20

Bleh -- ok. Many of those problems preexist these changes but it's
probably worth fixing them. I'll respin the patch.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
