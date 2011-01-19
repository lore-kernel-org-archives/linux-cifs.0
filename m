From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] cifs: use get/put_unaligned functions to access ByteCount
Date: Wed, 19 Jan 2011 09:33:47 -0600
Message-ID: <AANLkTi=XsEtjps=hq897Rt+akT9F-Toe1bpRuT=aMqPO@mail.gmail.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
	<1295382799-7902-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 18, 2011 at 2:33 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> It's possible that when we access the ByteCount that the alignment
> will be off. Most CPUs deal with that transparently, but there's
> usually some performance impact. Some CPUs raise an exception on
> unaligned accesses.
>
> Fix this by accessing the byte count using the get_unaligned and
> put_unaligned inlined functions. While we're at it, fix the types
> of some of the variables that end up getting returns from these
> functions.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifspdu.h =A0 | =A0 47 +++++++++++++++++++++++++++++++++++=
++++++++----
> =A0fs/cifs/cifssmb.c =A0 | =A0 14 +++++---------
> =A0fs/cifs/connect.c =A0 | =A0 10 +++++-----
> =A0fs/cifs/netmisc.c =A0 | =A0 =A04 ++--
> =A0fs/cifs/sess.c =A0 =A0 =A0| =A0 13 ++++++-------
> =A0fs/cifs/transport.c | =A0 =A09 ++++-----
> =A06 files changed, 65 insertions(+), 32 deletions(-)
>
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index ea205b4..b5c8cc5 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -23,6 +23,7 @@
> =A0#define _CIFSPDU_H
>
> =A0#include <net/sock.h>
> +#include <asm/unaligned.h>
> =A0#include "smbfsctl.h"
>
> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> @@ -426,11 +427,49 @@ struct smb_hdr {
> =A0 =A0 =A0 =A0__u16 Mid;
> =A0 =A0 =A0 =A0__u8 WordCount;
> =A0} __attribute__((packed));
> -/* given a pointer to an smb_hdr retrieve the value of byte count */
> -#define BCC(smb_var) (*(__u16 *)((char *)(smb_var) + sizeof(struct s=
mb_hdr) + (2 * (smb_var)->WordCount)))
> -#define BCC_LE(smb_var) (*(__le16 *)((char *)(smb_var) + sizeof(stru=
ct smb_hdr) + (2 * (smb_var)->WordCount)))
> +
> +/* given a pointer to an smb_hdr retrieve a char pointer to the byte=
 count */
> +#define BCC(smb_var) ((unsigned char *)(smb_var) + sizeof(struct smb=
_hdr) + \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(2 * (smb_var)->Word=
Count))
> +
> =A0/* given a pointer to an smb_hdr retrieve the pointer to the byte =
area */
> -#define pByteArea(smb_var) ((unsigned char *)(smb_var) + sizeof(stru=
ct smb_hdr) + (2 * (smb_var)->WordCount) + 2)
> +#define pByteArea(smb_var) (BCC(smb_var) + 2)
> +
> +/* get the converted ByteCount for a SMB packet and return it */
> +static inline __u16
> +get_bcc(struct smb_hdr *hdr)
> +{
> + =A0 =A0 =A0 __u16 *bc_ptr =3D (__u16 *)BCC(hdr);
> +
> + =A0 =A0 =A0 return get_unaligned(bc_ptr);
> +}
> +
> +/* get the unconverted ByteCount for a SMB packet and return it */
> +static inline __u16
> +get_bcc_le(struct smb_hdr *hdr)
> +{
> + =A0 =A0 =A0 __le16 *bc_ptr =3D (__le16 *)BCC(hdr);
> +
> + =A0 =A0 =A0 return get_unaligned_le16(bc_ptr);
> +}
> +
> +/* set the ByteCount for a SMB packet in host-byte order */
> +static inline void
> +put_bcc(__u16 count, struct smb_hdr *hdr)
> +{
> + =A0 =A0 =A0 __u16 *bc_ptr =3D (__u16 *)BCC(hdr);
> +
> + =A0 =A0 =A0 put_unaligned(count, bc_ptr);
> +}
> +
> +/* set the ByteCount for a SMB packet in little-endian */
> +static inline void
> +put_bcc_le(__u16 count, struct smb_hdr *hdr)
> +{
> + =A0 =A0 =A0 __le16 *bc_ptr =3D (__le16 *)BCC(hdr);
> +
> + =A0 =A0 =A0 put_unaligned_le16(count, bc_ptr);
> +}
>
> =A0/*
> =A0* Computer Name Length (since Netbios name was length 16 with last=
 byte 0x20)
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c5b2014..3b3072c 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -333,7 +333,6 @@ static int validate_t2(struct smb_t2_rsp *pSMB)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D -EINVAL;
> =A0 =A0 =A0 =A0int total_size;
> - =A0 =A0 =A0 char *pBCC;
>
> =A0 =A0 =A0 =A0/* check for plausible wct, bcc and t2 data and parm s=
izes */
> =A0 =A0 =A0 =A0/* check for parm and data offset going beyond end of =
smb */
> @@ -346,13 +345,9 @@ static int validate_t2(struct smb_t2_rsp *pSMB)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (total_size < 512) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0total_=
size +=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0le16_to_cpu(pSMB->t2_rsp.DataCount);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BCC =
le converted in SendReceive */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pBCC =3D=
 (pSMB->hdr.WordCount * 2) +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct smb_hdr) +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 (char *)pSMB;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((to=
tal_size <=3D (*(u16 *)pBCC)) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
(total_size <
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFSMaxBufSize+MAX_CIFS_HDR_SIZE)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tot=
al_size <=3D get_bcc(&pSMB->hdr) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 total_size <
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0return 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -362,6 +357,7 @@ static int validate_t2(struct smb_t2_rsp *pSMB)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct smb_t2_rsp) + 16);
> =A0 =A0 =A0 =A0return rc;
> =A0}
> +
> =A0int
> =A0CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
> =A0{
> @@ -5430,7 +5426,7 @@ QAllEAsRetry:
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* make sure list_len doesn't go past end of SMB */
> - =A0 =A0 =A0 end_of_smb =3D (char *)pByteArea(&pSMBr->hdr) + BCC(&pS=
MBr->hdr);
> + =A0 =A0 =A0 end_of_smb =3D (char *)pByteArea(&pSMBr->hdr) + get_bcc=
(&pSMBr->hdr);
> =A0 =A0 =A0 =A0if ((char *)ea_response_data + list_len > end_of_smb) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "EA list appears to go beyond =
SMB");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 32c2f55..9bcdf2b 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -318,9 +318,9 @@ static int coalesce_t2(struct smb_hdr *psecond, s=
truct smb_hdr *pTargetSMB)
> =A0 =A0 =A0 =A0memcpy(data_area_of_target, data_area_of_buf2, total_i=
n_buf2);
> =A0 =A0 =A0 =A0total_in_buf +=3D total_in_buf2;
> =A0 =A0 =A0 =A0pSMBt->t2_rsp.DataCount =3D cpu_to_le16(total_in_buf);
> - =A0 =A0 =A0 byte_count =3D le16_to_cpu(BCC_LE(pTargetSMB));
> + =A0 =A0 =A0 byte_count =3D get_bcc_le(pTargetSMB);
> =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
> - =A0 =A0 =A0 BCC_LE(pTargetSMB) =3D cpu_to_le16(byte_count);
> + =A0 =A0 =A0 put_bcc_le(byte_count, pTargetSMB);
>
> =A0 =A0 =A0 =A0byte_count =3D pTargetSMB->smb_buf_length;
> =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
> @@ -2937,8 +2937,8 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *=
ses,
> =A0 =A0 =A0 =A0TCONX_RSP *pSMBr;
> =A0 =A0 =A0 =A0unsigned char *bcc_ptr;
> =A0 =A0 =A0 =A0int rc =3D 0;
> - =A0 =A0 =A0 int length, bytes_left;
> - =A0 =A0 =A0 __u16 count;
> + =A0 =A0 =A0 int length;
> + =A0 =A0 =A0 __u16 bytes_left, count;
>
> =A0 =A0 =A0 =A0if (ses =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> @@ -3032,7 +3032,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *=
ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tcon->need_reconnect =3D false;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tcon->tid =3D smb_buffer_response->Tid=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr =3D pByteArea(smb_buffer_respo=
nse);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_left =3D BCC(smb_buffer_response)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_left =3D get_bcc(smb_buffer_respo=
nse);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length =3D strnlen(bcc_ptr, bytes_left=
 - 2);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (smb_buffer->Flags2 & SMBFLG2_UNICO=
DE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_unicode =3D true;
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index 6783ce6..8d9189f 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -916,14 +916,14 @@ unsigned int
> =A0smbCalcSize(struct smb_hdr *ptr)
> =A0{
> =A0 =A0 =A0 =A0return (sizeof(struct smb_hdr) + (2 * ptr->WordCount) =
+
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 2 /* size of the bcc field */ + BCC(ptr=
));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 2 /* size of the bcc field */ + get_bcc=
(ptr));
> =A0}
>
> =A0unsigned int
> =A0smbCalcSize_LE(struct smb_hdr *ptr)
> =A0{
> =A0 =A0 =A0 =A0return (sizeof(struct smb_hdr) + (2 * ptr->WordCount) =
+
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 2 /* size of the bcc field */ + le16_to=
_cpu(BCC_LE(ptr)));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 2 /* size of the bcc field */ + get_bcc=
_le(ptr));
> =A0}
>
> =A0/* The following are taken from fs/ntfs/util.c */
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 1cffd82..1adc962 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -277,7 +277,7 @@ static void ascii_ssetup_strings(char **pbcc_area=
, struct cifsSesInfo *ses,
> =A0}
>
> =A0static void
> -decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifsSesInf=
o *ses,
> +decode_unicode_ssetup(char **pbcc_area, __u16 bleft, struct cifsSesI=
nfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *nl=
s_cp)
> =A0{
> =A0 =A0 =A0 =A0int len;
> @@ -323,7 +323,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft=
, struct cifsSesInfo *ses,
> =A0 =A0 =A0 =A0return;
> =A0}
>
> -static int decode_ascii_ssetup(char **pbcc_area, int bleft,
> +static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ci=
fsSesInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const str=
uct nls_table *nls_cp)
> =A0{
> @@ -575,12 +575,11 @@ CIFS_SessSetup(unsigned int xid, struct cifsSes=
Info *ses,
> =A0 =A0 =A0 =A0char *str_area;
> =A0 =A0 =A0 =A0SESSION_SETUP_ANDX *pSMB;
> =A0 =A0 =A0 =A0__u32 capabilities;
> - =A0 =A0 =A0 int count;
> + =A0 =A0 =A0 __u16 count;
> =A0 =A0 =A0 =A0int resp_buf_type;
> =A0 =A0 =A0 =A0struct kvec iov[3];
> =A0 =A0 =A0 =A0enum securityEnum type;
> - =A0 =A0 =A0 __u16 action;
> - =A0 =A0 =A0 int bytes_remaining;
> + =A0 =A0 =A0 __u16 action, bytes_remaining;
> =A0 =A0 =A0 =A0struct key *spnego_key =3D NULL;
> =A0 =A0 =A0 =A0__le32 phase =3D NtLmNegotiate; /* NTLMSSP, if needed,=
 is multistage */
> =A0 =A0 =A0 =A0u16 blob_len;
> @@ -876,7 +875,7 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0count =3D iov[1].iov_len + iov[2].iov_len;
> =A0 =A0 =A0 =A0smb_buf->smb_buf_length +=3D count;
>
> - =A0 =A0 =A0 BCC_LE(smb_buf) =3D cpu_to_le16(count);
> + =A0 =A0 =A0 put_bcc_le(count, smb_buf);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive2(xid, ses, iov, 3 /* num_iovecs */,=
 &resp_buf_type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_LOG_ERROR);
> @@ -910,7 +909,7 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0cFYI(1, "UID =3D %d ", ses->Suid);
> =A0 =A0 =A0 =A0/* response can have either 3 or 4 word count - Samba =
sends 3 */
> =A0 =A0 =A0 =A0/* and lanman response is 3 */
> - =A0 =A0 =A0 bytes_remaining =3D BCC(smb_buf);
> + =A0 =A0 =A0 bytes_remaining =3D get_bcc(smb_buf);
> =A0 =A0 =A0 =A0bcc_ptr =3D pByteArea(smb_buf);
>
> =A0 =A0 =A0 =A0if (smb_buf->WordCount =3D=3D 4) {
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index e2e66f3..fbeaee8 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -484,7 +484,7 @@ send_nt_cancel(struct TCP_Server_Info *server, st=
ruct smb_hdr *in_buf,
> =A0 =A0 =A0 =A0in_buf->smb_buf_length =3D sizeof(struct smb_hdr) - 4 =
=A0+ 2;
> =A0 =A0 =A0 =A0in_buf->Command =3D SMB_COM_NT_CANCEL;
> =A0 =A0 =A0 =A0in_buf->WordCount =3D 0;
> - =A0 =A0 =A0 BCC_LE(in_buf) =3D 0;
> + =A0 =A0 =A0 put_bcc_le(0, in_buf);
>
> =A0 =A0 =A0 =A0mutex_lock(&server->srv_mutex);
> =A0 =A0 =A0 =A0rc =3D cifs_sign_smb(in_buf, server, &mid->sequence_nu=
mber);
> @@ -648,8 +648,7 @@ SendReceive2(const unsigned int xid, struct cifsS=
esInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (receive_len >=3D sizeof(struct smb=
_hdr) - 4
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* do not count RFC1001 header=
 */ =A0+
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(2 * midQ->resp_buf->WordCount=
) + 2 /* bcc */ )
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BCC(midQ->resp_buf) =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le16_to=
_cpu(BCC_LE(midQ->resp_buf));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_bcc(get_bcc_le(midQ=
->resp_buf), midQ->resp_buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((flags & CIFS_NO_RESP) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->resp_buf =3D NUL=
L; =A0/* mark it so buf will
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 not be freed by
> @@ -803,7 +802,7 @@ SendReceive(const unsigned int xid, struct cifsSe=
sInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (receive_len >=3D sizeof(struct smb=
_hdr) - 4
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* do not count RFC1001 header=
 */ =A0+
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(2 * out_buf->WordCount) + 2 /=
* bcc */ )
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BCC(out_buf) =3D le16_t=
o_cpu(BCC_LE(out_buf));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_bcc(get_bcc_le(midQ=
->resp_buf), midQ->resp_buf);
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Bad MID state?");
> @@ -1015,7 +1014,7 @@ SendReceiveBlockingLock(const unsigned int xid,=
 struct cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0if (receive_len >=3D sizeof(struct smb_hdr) - 4
> =A0 =A0 =A0 =A0 =A0 =A0/* do not count RFC1001 header */ =A0+
> =A0 =A0 =A0 =A0 =A0 =A0(2 * out_buf->WordCount) + 2 /* bcc */ )
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 BCC(out_buf) =3D le16_to_cpu(BCC_LE(out=
_buf));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_bcc(get_bcc_le(out_buf), out_buf);
>
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Should get_bcc* and put_bcc* functions be renamed to respective
get_bcc16* and put_bcc16* respectively (or something like that)
in case there is a need to have similar functions for four bytes fields=
?
