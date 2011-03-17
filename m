From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re:
Date: Thu, 17 Mar 2011 11:22:40 -0500
Message-ID: <AANLkTimGfZ4txdo13h558y=EXwYs28jDKWyziPw=ksCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Ignore this version of the patch.  Had a typo in  [PATCH] consistently
use smb_buf_length as be32 for cifs (try 2).

On Thu, Mar 17, 2011 at 10:53 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> =A0 =A0[CIFS] consistently use smb_buf_length as be32 for cifs (try 2=
)
>
> =A0 =A0 =A0 =A0There is one big endian field in the cifs protocol, th=
e RFC1001
> =A0 =A0 =A0 =A0length, which cifs code (unlike in the smb2 code) had =
been handling as
> =A0 =A0 =A0 =A0u32 until the last possible moment, when it was conver=
ted to be32 (its
> =A0 =A0 =A0 =A0native form) before sending on the wire. =A0 To remove=
 the last sparse
> =A0 =A0 =A0 =A0endian warning, and to make this consistent with the s=
mb2
> =A0 =A0 =A0 =A0implementation =A0(which always treats the fields in t=
heir
> =A0 =A0 =A0 =A0native size and endianness), convert all uses of smb_b=
uf_length to
> =A0 =A0 =A0 =A0be32.
>
> =A0 =A0 =A0 =A0This version incorporates Christoph's comment about
> =A0 =A0 =A0 =A0using be32_add_cpu
>
> =A0 =A0CC: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> =A0 =A0Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 5e71531..5bb4b09 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -59,7 +59,7 @@ static int cifs_calculate_signature(const struct
> smb_hdr *cifs_pdu,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->session_key.response, server->=
session_key.len);
>
> =A0 =A0 =A0 =A0crypto_shash_update(&server->secmech.sdescmd5->shash,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_pdu->Protocol, cifs_pdu->smb_buf_l=
ength);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_pdu->Protocol, be32_to_cpu(cifs_pd=
u->smb_buf_length));
>
> =A0 =A0 =A0 =A0rc =3D crypto_shash_final(&server->secmech.sdescmd5->s=
hash, signature);
>
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index b5c8cc5..eac95e2 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -397,9 +397,9 @@
> =A0#define GETU32(var) =A0(*((__u32 *)var)) /* BB check for endian is=
sues */
>
> =A0struct smb_hdr {
> - =A0 =A0 =A0 __u32 smb_buf_length; =A0 /* big endian on wire *//* BB=
 length is only two
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 or three bytes - with one or two byte t=
ype preceding it that are
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero - we could mask the type byte off =
just in case BB */
> + =A0 =A0 =A0 __be32 smb_buf_length; =A0/* BB length is only two (rar=
ely three) bytes,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 with one or two byte "type" preceding i=
t that will be
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero - we could mask the type byte off =
*/
> =A0 =A0 =A0 =A0__u8 Protocol[4];
> =A0 =A0 =A0 =A0__u8 Command;
> =A0 =A0 =A0 =A0union {
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 3c72e66..cc3e04f 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -357,6 +357,13 @@ vt2_err:
> =A0 =A0 =A0 =A0return -EINVAL;
> =A0}
>
> +static void inc_rfc1001_len(void *pSMB, int count)
> +{
> + =A0 =A0 =A0 struct smb_hdr *psmb =3D (struct smb_hdr *)pSMB;
> +
> + =A0 =A0 =A0 be32_add_cpu(&pSMB->hdr.smb_buf_length, count);
> +}
> +
> =A0int
> =A0CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
> =A0{
> @@ -409,7 +416,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_se=
s *ses)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count +=3D strlen(protocols[i].name) +=
 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* null at end of source and target bu=
ffers anyway */
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, ses, (struct smb_hdr *) pSMB,
> @@ -730,7 +737,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0put_unaligned_le16(1, &smb->EchoCount);
> =A0 =A0 =A0 =A0put_bcc_le(1, &smb->hdr);
> =A0 =A0 =A0 =A0smb->Data[0] =3D 'a';
> - =A0 =A0 =A0 smb->hdr.smb_buf_length +=3D 3;
> + =A0 =A0 =A0 inc_rfc1001_len(smb, 3);
>
> =A0 =A0 =A0 =A0rc =3D cifs_call_async(server, (struct smb_hdr *)smb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_e=
cho_callback, server);
> @@ -848,7 +855,7 @@ PsxDelete:
> =A0 =A0 =A0 =A0pSMB->TotalParameterCount =3D pSMB->ParameterCount;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_POSIX_UNLIN=
K);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -894,7 +901,7 @@ DelFileRetry:
> =A0 =A0 =A0 =A0pSMB->SearchAttributes =3D
> =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR=
_SYSTEM);
> =A0 =A0 =A0 =A0pSMB->BufferFormat =3D 0x04;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D name_len + 1;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, name_len + 1);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -938,7 +945,7 @@ RmDirRetry:
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0pSMB->BufferFormat =3D 0x04;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D name_len + 1;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, name_len + 1);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -981,7 +988,7 @@ MkDirRetry:
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0pSMB->BufferFormat =3D 0x04;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D name_len + 1;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, name_len + 1);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -1059,7 +1066,7 @@ PsxCreat:
> =A0 =A0 =A0 =A0pSMB->TotalParameterCount =3D pSMB->ParameterCount;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_POSIX_OPEN)=
;
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -1224,7 +1231,7 @@ OldOpenRetry:
> =A0 =A0 =A0 =A0pSMB->Sattr =3D cpu_to_le16(ATTR_HIDDEN | ATTR_SYSTEM =
| ATTR_DIRECTORY);
> =A0 =A0 =A0 =A0pSMB->OpenFunction =3D cpu_to_le16(convert_disposition=
(openDisposition));
> =A0 =A0 =A0 =A0count +=3D name_len;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, count);
>
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
> =A0 =A0 =A0 =A0/* long_op set to 1 to allow for oplock break timeouts=
 */
> @@ -1337,7 +1344,7 @@ openRetry:
> =A0 =A0 =A0 =A0 =A0 =A0SECURITY_CONTEXT_TRACKING | SECURITY_EFFECTIVE=
_ONLY;
>
> =A0 =A0 =A0 =A0count +=3D name_len;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, count);
>
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
> =A0 =A0 =A0 =A0/* long_op set to 1 to allow for oplock break timeouts=
 */
> @@ -1422,7 +1429,7 @@ CIFSSMBRead(const int xid, struct cifs_tcon
> *tcon, const int netfid,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0iov[0].iov_base =3D (char *)pSMB;
> - =A0 =A0 =A0 iov[0].iov_len =3D pSMB->hdr.smb_buf_length + 4;
> + =A0 =A0 =A0 iov[0].iov_len =3D be32_to_cpu(pSMB->hdr.smb_buf_length=
) + 4;
> =A0 =A0 =A0 =A0rc =3D SendReceive2(xid, tcon->ses, iov, 1 /* num iove=
cs */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &resp_buf_type, CIFS_=
LOG_ERROR);
> =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
> @@ -1556,7 +1563,7 @@ CIFSSMBWrite(const int xid, struct cifs_tcon *t=
con,
>
> =A0 =A0 =A0 =A0pSMB->DataLengthLow =3D cpu_to_le16(bytes_sent & 0xFFF=
=46);
> =A0 =A0 =A0 =A0pSMB->DataLengthHigh =3D cpu_to_le16(bytes_sent >> 16)=
;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
>
> =A0 =A0 =A0 =A0if (wct =3D=3D 14)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_c=
ount);
> @@ -1640,11 +1647,12 @@ CIFSSMBWrite2(const int xid, struct cifs_tcon=
 *tcon,
>
> =A0 =A0 =A0 =A0pSMB->DataLengthLow =3D cpu_to_le16(count & 0xFFFF);
> =A0 =A0 =A0 =A0pSMB->DataLengthHigh =3D cpu_to_le16(count >> 16);
> - =A0 =A0 =A0 smb_hdr_len =3D pSMB->hdr.smb_buf_length + 1; /* hdr + =
1 byte pad */
> + =A0 =A0 =A0 /* header + 1 byte pad */
> + =A0 =A0 =A0 smb_hdr_len =3D be32_to_cpu(pSMB->hdr.smb_buf_length) +=
 1;
> =A0 =A0 =A0 =A0if (wct =3D=3D 14)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D count+1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 inc_rfc1001_len(pSMB, count + 1);
> =A0 =A0 =A0 =A0else /* wct =3D=3D 12 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D count+5; =
/* smb data starts later */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 inc_rfc1001_len(pSMB, count + 5); /* sm=
b data starts later */
> =A0 =A0 =A0 =A0if (wct =3D=3D 14)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count =
+ 1);
> =A0 =A0 =A0 =A0else /* wct =3D=3D 12 */ /* bigger pad, smaller smb hd=
r, keep offset ok */ {
> @@ -1744,7 +1752,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tc=
on,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* oplock break */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count =3D 0;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
>
> =A0 =A0 =A0 =A0if (waitFlag) {
> @@ -1835,14 +1843,14 @@ CIFSSMBPosixLock(const int xid, struct cifs_t=
con *tcon,
> =A0 =A0 =A0 =A0pSMB->Fid =3D smb_file_id;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_SET_POSIX_L=
OCK);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0if (waitFlag) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D SendReceiveBlockingLock(xid, tc=
on, (struct smb_hdr *) pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSM=
Br, &bytes_returned);
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov[0].iov_base =3D (char *)pSMB;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[0].iov_len =3D pSMB->hdr.smb_buf_le=
ngth + 4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[0].iov_len =3D be32_to_cpu(pSMB->hd=
r.smb_buf_length) + 4;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D SendReceive2(xid, tcon->ses, io=
v, 1 /* num iovecs */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&resp_=
buf_type, timeout);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB =3D NULL; /* request buf already =
freed by SendReceive2. Do
> @@ -2008,7 +2016,7 @@ renameRetry:
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0count =3D 1 /* 1st signature byte */ =A0+ name_len + n=
ame_len2;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -2088,7 +2096,7 @@ int CIFSSMBRenameOpenFile(const int xid, struct
> cifs_tcon *pTcon,
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(SMB_SET_FILE_RENAME_INFORM=
ATION);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, pTcon->ses, (struct smb_hdr *)=
 pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -2155,7 +2163,7 @@ copyRetry:
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0count =3D 1 /* 1st signature byte */ =A0+ name_len + n=
ame_len2;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -2245,7 +2253,7 @@ createSymLinkRetry:
> =A0 =A0 =A0 =A0pSMB->DataOffset =3D cpu_to_le16(offset);
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_SET_FILE_UN=
IX_LINK);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -2331,7 +2339,7 @@ createHardLinkRetry:
> =A0 =A0 =A0 =A0pSMB->DataOffset =3D cpu_to_le16(offset);
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_SET_FILE_UN=
IX_HLINK);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -2402,7 +2410,7 @@ winCreateHardLinkRetry:
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0count =3D 1 /* string type byte */ =A0+ name_len + nam=
e_len2;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -2473,7 +2481,7 @@ querySymLinkRetry:
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D pSMB->TotalParameterCount;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_FILE_=
UNIX_LINK);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -2820,7 +2828,7 @@ queryAclRetry:
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D pSMB->TotalParameterCount;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_POSIX=
_ACL);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -2914,7 +2922,7 @@ setAclRetry:
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D cpu_to_le16(params);
> =A0 =A0 =A0 =A0pSMB->TotalParameterCount =3D pSMB->ParameterCount;
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -2972,7 +2980,7 @@ GetExtAttrRetry:
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_ATTR_=
=46LAGS);
> =A0 =A0 =A0 =A0pSMB->Pad =3D 0;
> =A0 =A0 =A0 =A0pSMB->Fid =3D netfid;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->t2.ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -3130,9 +3138,9 @@ CIFSSMBGetCIFSACL(const int xid, struct
> cifs_tcon *tcon, __u16 fid,
> =A0 =A0 =A0 =A0pSMB->AclFlags =3D cpu_to_le32(CIFS_ACL_OWNER | CIFS_A=
CL_GROUP |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 CIFS_ACL_DACL);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(11); /* 3 bytes pad + =
8 bytes parm */
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D 11;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, 11);
> =A0 =A0 =A0 =A0iov[0].iov_base =3D (char *)pSMB;
> - =A0 =A0 =A0 iov[0].iov_len =3D pSMB->hdr.smb_buf_length + 4;
> + =A0 =A0 =A0 iov[0].iov_len =3D be32_to_cpu(pSMB->hdr.smb_buf_length=
) + 4;
>
> =A0 =A0 =A0 =A0rc =3D SendReceive2(xid, tcon->ses, iov, 1 /* num iove=
c */, &buf_type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0);
> @@ -3241,10 +3249,9 @@ setCifsAclRetry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy((char *) &pSMBr->hdr.Protocol +=
 data_offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(char *) pntsd,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0acllen);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D (byte_cou=
nt + data_count);
> -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count + data=
_count);
> =A0 =A0 =A0 =A0} else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_coun=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retur=
ned, 0);
> @@ -3295,7 +3302,7 @@ QInfRetry:
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0pSMB->BufferFormat =3D 0x04;
> =A0 =A0 =A0 =A0name_len++; /* account for buffer type byte */
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D (__u16) name_len;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, (__u16)name_len);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(name_len);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -3370,7 +3377,7 @@ QFileInfoRetry:
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_FILE_=
ALL_INFO);
> =A0 =A0 =A0 =A0pSMB->Pad =3D 0;
> =A0 =A0 =A0 =A0pSMB->Fid =3D netfid;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -3457,7 +3464,7 @@ QPathInfoRetry:
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16=
(SMB_QUERY_FILE_ALL_INFO);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -3538,7 +3545,7 @@ UnixQFileInfoRetry:
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_FILE_=
UNIX_BASIC);
> =A0 =A0 =A0 =A0pSMB->Pad =3D 0;
> =A0 =A0 =A0 =A0pSMB->Fid =3D netfid;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -3623,7 +3630,7 @@ UnixQPathInfoRetry:
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D pSMB->TotalParameterCount;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_FILE_=
UNIX_BASIC);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -3737,7 +3744,7 @@ findFirstRetry:
>
> =A0 =A0 =A0 =A0/* BB what should we set StorageType to? Does it matte=
r? BB */
> =A0 =A0 =A0 =A0pSMB->SearchStorageType =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -3866,7 +3873,7 @@ int CIFSFindNext(const int xid, struct cifs_tco=
n *tcon,
> =A0 =A0 =A0 =A0byte_count =3D params + 1 /* pad */ ;
> =A0 =A0 =A0 =A0pSMB->TotalParameterCount =3D cpu_to_le16(params);
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D pSMB->TotalParameterCount;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -4028,7 +4035,7 @@ GetInodeNumberRetry:
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D pSMB->TotalParameterCount;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_FILE_=
INTERNAL_INFO);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -4252,7 +4259,7 @@ getDFSRetry:
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D cpu_to_le16(params);
> =A0 =A0 =A0 =A0pSMB->TotalParameterCount =3D pSMB->ParameterCount;
> =A0 =A0 =A0 =A0pSMB->MaxReferralLevel =3D cpu_to_le16(3);
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, ses, (struct smb_hdr *) pSMB,
> @@ -4326,7 +4333,7 @@ oldQFSInfoRetry:
> =A0 =A0 =A0 =A0pSMB->Reserved3 =3D 0;
> =A0 =A0 =A0 =A0pSMB->SubCommand =3D cpu_to_le16(TRANS2_QUERY_FS_INFOR=
MATION);
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_INFO_ALLOCA=
TION);
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -4405,7 +4412,7 @@ QFSInfoRetry:
> =A0 =A0 =A0 =A0pSMB->Reserved3 =3D 0;
> =A0 =A0 =A0 =A0pSMB->SubCommand =3D cpu_to_le16(TRANS2_QUERY_FS_INFOR=
MATION);
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_FS_SI=
ZE_INFO);
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -4485,7 +4492,7 @@ QFSAttributeRetry:
> =A0 =A0 =A0 =A0pSMB->Reserved3 =3D 0;
> =A0 =A0 =A0 =A0pSMB->SubCommand =3D cpu_to_le16(TRANS2_QUERY_FS_INFOR=
MATION);
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_FS_AT=
TRIBUTE_INFO);
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -4556,7 +4563,7 @@ QFSDeviceRetry:
> =A0 =A0 =A0 =A0pSMB->Reserved3 =3D 0;
> =A0 =A0 =A0 =A0pSMB->SubCommand =3D cpu_to_le16(TRANS2_QUERY_FS_INFOR=
MATION);
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_FS_DE=
VICE_INFO);
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -4625,7 +4632,7 @@ QFSUnixRetry:
> =A0 =A0 =A0 =A0pSMB->Reserved3 =3D 0;
> =A0 =A0 =A0 =A0pSMB->SubCommand =3D cpu_to_le16(TRANS2_QUERY_FS_INFOR=
MATION);
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_CIFS_=
UNIX_INFO);
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -4708,7 +4715,7 @@ SETFSUnixRetry:
> =A0 =A0 =A0 =A0pSMB->ClientUnixMinor =3D cpu_to_le16(CIFS_UNIX_MINOR_=
VERSION);
> =A0 =A0 =A0 =A0pSMB->ClientUnixCap =3D cpu_to_le64(cap);
>
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -4770,7 +4777,7 @@ QFSPosixRetry:
> =A0 =A0 =A0 =A0pSMB->Reserved3 =3D 0;
> =A0 =A0 =A0 =A0pSMB->SubCommand =3D cpu_to_le16(TRANS2_QUERY_FS_INFOR=
MATION);
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_QUERY_POSIX=
_FS_INFO);
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -4896,7 +4903,7 @@ SetEOFRetry:
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D cpu_to_le16(params);
> =A0 =A0 =A0 =A0pSMB->TotalParameterCount =3D pSMB->ParameterCount;
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0parm_data->FileSize =3D cpu_to_le64(size);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -4975,7 +4982,7 @@ CIFSSMBSetFileSize(const int xid, struct
> cifs_tcon *tcon, __u64 size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to=
_le16(SMB_SET_FILE_END_OF_FILE_INFO);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hd=
r *) pSMB, 0);
> =A0 =A0 =A0 =A0if (rc) {
> @@ -5043,7 +5050,7 @@ CIFSSMBSetFileInfo(const int xid, struct cifs_t=
con *tcon,
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16=
(SMB_SET_FILE_BASIC_INFO);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
> =A0 =A0 =A0 =A0rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hd=
r *) pSMB, 0);
> @@ -5102,7 +5109,7 @@ CIFSSMBSetFileDisposition(const int xid, struct
> cifs_tcon *tcon,
> =A0 =A0 =A0 =A0pSMB->Fid =3D fid;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_SET_FILE_DI=
SPOSITION_INFO);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0*data_offset =3D delete_file ? 1 : 0;
> =A0 =A0 =A0 =A0rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hd=
r *) pSMB, 0);
> @@ -5175,7 +5182,7 @@ SetTimesRetry:
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16=
(SMB_SET_FILE_BASIC_INFO);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -5227,7 +5234,7 @@ SetAttrLgcyRetry:
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0pSMB->attr =3D cpu_to_le16(dos_attrs);
> =A0 =A0 =A0 =A0pSMB->BufferFormat =3D 0x04;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D name_len + 1;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, name_len + 1);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> @@ -5332,7 +5339,7 @@ CIFSSMBUnixSetFileInfo(const int xid, struct
> cifs_tcon *tcon,
> =A0 =A0 =A0 =A0pSMB->Fid =3D fid;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_SET_FILE_UN=
IX_BASIC);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0cifs_fill_unix_set_info(data_offset, args);
> @@ -5408,7 +5415,7 @@ setPermsRetry:
> =A0 =A0 =A0 =A0pSMB->TotalDataCount =3D pSMB->DataCount;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_SET_FILE_UN=
IX_BASIC);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
>
> =A0 =A0 =A0 =A0cifs_fill_unix_set_info(data_offset, args);
>
> @@ -5493,7 +5500,7 @@ QAllEAsRetry:
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D pSMB->TotalParameterCount;
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(SMB_INFO_QUERY_=
ALL_EAS);
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> @@ -5706,7 +5713,7 @@ SetEARetry:
> =A0 =A0 =A0 =A0pSMB->ParameterCount =3D cpu_to_le16(params);
> =A0 =A0 =A0 =A0pSMB->TotalParameterCount =3D pSMB->ParameterCount;
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> + =A0 =A0 =A0 inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index c19f00a..19d7898 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -320,12 +320,12 @@ static int coalesce_t2(struct smb_hdr *psecond,
> struct smb_hdr *pTargetSMB)
> =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
> =A0 =A0 =A0 =A0put_bcc_le(byte_count, pTargetSMB);
>
> - =A0 =A0 =A0 byte_count =3D pTargetSMB->smb_buf_length;
> + =A0 =A0 =A0 byte_count =3D be32_to_cpu(pTargetSMB->smb_buf_length);
> =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
>
> =A0 =A0 =A0 =A0/* BB also add check that we are not beyond maximum bu=
ffer size */
>
> - =A0 =A0 =A0 pTargetSMB->smb_buf_length =3D byte_count;
> + =A0 =A0 =A0 pTargetSMB->smb_buf_length =3D cpu_to_be32(byte_count);
>
> =A0 =A0 =A0 =A0if (remaining =3D=3D total_in_buf2) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "found the last secondary resp=
onse");
> @@ -490,8 +490,7 @@ incomplete_rcv:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Note that FC 1001 length is big end=
ian on the wire,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0but we convert it here so it is always=
 manipulated
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0as host byte order */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdu_length =3D be32_to_cpu((__force __b=
e32)smb_buffer->smb_buf_length);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_buffer->smb_buf_length =3D pdu_leng=
th;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdu_length =3D be32_to_cpu(smb_buffer->=
smb_buf_length);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "rfc1002 length 0x%x", pdu_len=
gth+4);
>
> @@ -2299,7 +2298,7 @@ ip_rfc1001_connect(struct TCP_Server_Info *serv=
er)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smb_buf =3D (struct smb_hdr *)ses_init=
_buf;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* sizeof RFC1002_SESSION_REQUEST with=
 no scope */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_buf->smb_buf_length =3D 0x81000044;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_buf->smb_buf_length =3D cpu_to_be32=
(0x81000044);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D smb_send(server, smb_buf, 0x44)=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(ses_init_buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> @@ -3097,7 +3096,8 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses=
,
> =A0 =A0 =A0 =A0bcc_ptr +=3D strlen("?????");
> =A0 =A0 =A0 =A0bcc_ptr +=3D 1;
> =A0 =A0 =A0 =A0count =3D bcc_ptr - &pSMB->Password[0];
> - =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D count;
> + =A0 =A0 =A0 pSMB->hdr.smb_buf_length =3D cpu_to_be32(be32_to_cpu(
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 pSMB->hdr.smb_buf_length) + count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(count);
>
> =A0 =A0 =A0 =A0rc =3D SendReceive(xid, ses, smb_buffer, smb_buffer_re=
sponse, &length,
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 1640a6e..6863acf 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -304,12 +304,10 @@ header_assemble(struct smb_hdr *buffer, char
> smb_command /* command */ ,
>
> =A0 =A0 =A0 =A0memset(temp, 0, 256); /* bigger than MAX_CIFS_HDR_SIZE=
 */
>
> - =A0 =A0 =A0 buffer->smb_buf_length =3D
> + =A0 =A0 =A0 buffer->smb_buf_length =3D cpu_to_be32(
> =A0 =A0 =A0 =A0 =A0 =A0(2 * word_count) + sizeof(struct smb_hdr) -
> =A0 =A0 =A0 =A0 =A0 =A04 /* =A0RFC 1001 length field does not count *=
/ =A0+
> - =A0 =A0 =A0 =A0 =A0 2 /* for bcc field itself */ ;
> - =A0 =A0 =A0 /* Note that this is the only network field that has to=
 be converted
> - =A0 =A0 =A0 =A0 =A0to big endian and it is done just before we send=
 it */
> + =A0 =A0 =A0 =A0 =A0 2 /* for bcc field itself */) ;
>
> =A0 =A0 =A0 =A0buffer->Protocol[0] =3D 0xFF;
> =A0 =A0 =A0 =A0buffer->Protocol[1] =3D 'S';
> @@ -424,7 +422,7 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
> =A0int
> =A0checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
> =A0{
> - =A0 =A0 =A0 __u32 len =3D smb->smb_buf_length;
> + =A0 =A0 =A0 __u32 len =3D be32_to_cpu(smb->smb_buf_length);
> =A0 =A0 =A0 =A0__u32 clc_len; =A0/* calculated length */
> =A0 =A0 =A0 =A0cFYI(0, "checkSMB Length: 0x%x, smb_buf_length: 0x%x",=
 length, len);
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index e982890..6b140e1 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -634,7 +634,7 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0and rest of bcc area. This allows us to avoid
> =A0 =A0 =A0 =A0a large buffer 17K allocation */
> =A0 =A0 =A0 =A0iov[0].iov_base =3D (char *)pSMB;
> - =A0 =A0 =A0 iov[0].iov_len =3D smb_buf->smb_buf_length + 4;
> + =A0 =A0 =A0 iov[0].iov_len =3D be32_to_cpu(smb_buf->smb_buf_length)=
 + 4;
>
> =A0 =A0 =A0 =A0/* setting this here allows the code at the end of the=
 function
> =A0 =A0 =A0 =A0 =A0 to free the request buffer if there's an error */
> @@ -872,7 +872,8 @@ ssetup_ntlmssp_authenticate:
> =A0 =A0 =A0 =A0iov[2].iov_len =3D (long) bcc_ptr - (long) str_area;
>
> =A0 =A0 =A0 =A0count =3D iov[1].iov_len + iov[2].iov_len;
> - =A0 =A0 =A0 smb_buf->smb_buf_length +=3D count;
> + =A0 =A0 =A0 smb_buf->smb_buf_length =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_be32(be32_to_cpu(smb_buf->smb_bu=
f_length) + count);
>
> =A0 =A0 =A0 =A0put_bcc_le(count, smb_buf);
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 1a2930d..fd43ac6 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -129,7 +129,7 @@ smb_sendv(struct TCP_Server_Info *server, struct
> kvec *iov, int n_vec)
> =A0 =A0 =A0 =A0unsigned int len =3D iov[0].iov_len;
> =A0 =A0 =A0 =A0unsigned int total_len;
> =A0 =A0 =A0 =A0int first_vec =3D 0;
> - =A0 =A0 =A0 unsigned int smb_buf_length =3D smb_buffer->smb_buf_len=
gth;
> + =A0 =A0 =A0 unsigned int smb_buf_length =3D be32_to_cpu(smb_buffer-=
>smb_buf_length);
> =A0 =A0 =A0 =A0struct socket *ssocket =3D server->ssocket;
>
> =A0 =A0 =A0 =A0if (ssocket =3D=3D NULL)
> @@ -144,17 +144,10 @@ smb_sendv(struct TCP_Server_Info *server, struc=
t
> kvec *iov, int n_vec)
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smb_msg.msg_flags =3D MSG_NOSIGNAL;
>
> - =A0 =A0 =A0 /* smb header is converted in header_assemble. bcc and =
rest of SMB word
> - =A0 =A0 =A0 =A0 =A0area, and byte area if necessary, is converted t=
o littleendian in
> - =A0 =A0 =A0 =A0 =A0cifssmb.c and RFC1001 len is converted to bigend=
ian in smb_send
> - =A0 =A0 =A0 =A0 =A0Flags2 is converted in SendReceive */
> -
> -
> =A0 =A0 =A0 =A0total_len =3D 0;
> =A0 =A0 =A0 =A0for (i =3D 0; i < n_vec; i++)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0total_len +=3D iov[i].iov_len;
>
> - =A0 =A0 =A0 smb_buffer->smb_buf_length =3D cpu_to_be32(smb_buffer->=
smb_buf_length);
> =A0 =A0 =A0 =A0cFYI(1, "Sending smb: =A0total_len %d", total_len);
> =A0 =A0 =A0 =A0dump_smb(smb_buffer, len);
>
> @@ -243,7 +236,7 @@ smb_sendv(struct TCP_Server_Info *server, struct
> kvec *iov, int n_vec)
>
> =A0 =A0 =A0 =A0/* Don't want to modify the buffer as a
> =A0 =A0 =A0 =A0 =A0 side effect of this call. */
> - =A0 =A0 =A0 smb_buffer->smb_buf_length =3D smb_buf_length;
> + =A0 =A0 =A0 smb_buffer->smb_buf_length =3D cpu_to_be32(smb_buf_leng=
th);
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -402,7 +395,7 @@ cifs_call_async(struct TCP_Server_Info *server,
> struct smb_hdr *in_buf,
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0atomic_inc(&server->inSend);
> =A0#endif
> - =A0 =A0 =A0 rc =3D smb_send(server, in_buf, in_buf->smb_buf_length)=
;
> + =A0 =A0 =A0 rc =3D smb_send(server, in_buf, be32_to_cpu(in_buf->smb=
_buf_length));
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0atomic_dec(&server->inSend);
> =A0 =A0 =A0 =A0mid->when_sent =3D jiffies;
> @@ -437,7 +430,7 @@ SendReceiveNoRsp(const unsigned int xid, struct
> cifs_ses *ses,
> =A0 =A0 =A0 =A0int resp_buf_type;
>
> =A0 =A0 =A0 =A0iov[0].iov_base =3D (char *)in_buf;
> - =A0 =A0 =A0 iov[0].iov_len =3D in_buf->smb_buf_length + 4;
> + =A0 =A0 =A0 iov[0].iov_len =3D be32_to_cpu(in_buf->smb_buf_length) =
+ 4;
> =A0 =A0 =A0 =A0flags |=3D CIFS_NO_RESP;
> =A0 =A0 =A0 =A0rc =3D SendReceive2(xid, ses, iov, 1, &resp_buf_type, =
flags);
> =A0 =A0 =A0 =A0cFYI(DBG2, "SendRcvNoRsp flags %d rc %d", flags, rc);
> @@ -503,7 +496,7 @@ send_nt_cancel(struct TCP_Server_Info *server,
> struct smb_hdr *in_buf,
> =A0 =A0 =A0 =A0int rc =3D 0;
>
> =A0 =A0 =A0 =A0/* -4 for RFC1001 length and +2 for BCC field */
> - =A0 =A0 =A0 in_buf->smb_buf_length =3D sizeof(struct smb_hdr) - 4 =A0=
+ 2;
> + =A0 =A0 =A0 in_buf->smb_buf_length =3D cpu_to_be32(sizeof(struct sm=
b_hdr) - 4 =A0+ 2);
> =A0 =A0 =A0 =A0in_buf->Command =3D SMB_COM_NT_CANCEL;
> =A0 =A0 =A0 =A0in_buf->WordCount =3D 0;
> =A0 =A0 =A0 =A0put_bcc_le(0, in_buf);
> @@ -514,7 +507,7 @@ send_nt_cancel(struct TCP_Server_Info *server,
> struct smb_hdr *in_buf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 rc =3D smb_send(server, in_buf, in_buf->smb_buf_length)=
;
> + =A0 =A0 =A0 rc =3D smb_send(server, in_buf, be32_to_cpu(in_buf->smb=
_buf_length));
> =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
>
> =A0 =A0 =A0 =A0cFYI(1, "issued NT_CANCEL for mid %u, rc =3D %d",
> @@ -627,7 +620,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 receive_len =3D midQ->resp_buf->smb_buf_length;
> + =A0 =A0 =A0 receive_len =3D be32_to_cpu(midQ->resp_buf->smb_buf_len=
gth);
>
> =A0 =A0 =A0 =A0if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Frame too large received. =A0=
Length: %d =A0Xid: %d",
> @@ -713,9 +706,10 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 to the same server. We may make this configurable=
 later or
> =A0 =A0 =A0 =A0 =A0 use ses->maxReq */
>
> - =A0 =A0 =A0 if (in_buf->smb_buf_length > CIFSMaxBufSize + MAX_CIFS_=
HDR_SIZE - 4) {
> + =A0 =A0 =A0 if (be32_to_cpu(in_buf->smb_buf_length) > CIFSMaxBufSiz=
e +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MAX_CIFS_HDR_SIZE - 4) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Illegal length, greater tha=
n maximum frame, %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in_buf->smb_buf_=
length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0be32_to_cpu(in_b=
uf->smb_buf_length));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> =A0 =A0 =A0 =A0}
>
> @@ -748,7 +742,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0atomic_inc(&ses->server->inSend);
> =A0#endif
> - =A0 =A0 =A0 rc =3D smb_send(ses->server, in_buf, in_buf->smb_buf_le=
ngth);
> + =A0 =A0 =A0 rc =3D smb_send(ses->server, in_buf, be32_to_cpu(in_buf=
->smb_buf_length));
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0atomic_dec(&ses->server->inSend);
> =A0 =A0 =A0 =A0midQ->when_sent =3D jiffies;
> @@ -783,7 +777,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 receive_len =3D midQ->resp_buf->smb_buf_length;
> + =A0 =A0 =A0 receive_len =3D be32_to_cpu(midQ->resp_buf->smb_buf_len=
gth);
>
> =A0 =A0 =A0 =A0if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Frame too large received. =A0=
Length: %d =A0Xid: %d",
> @@ -796,7 +790,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
>
> =A0 =A0 =A0 =A0if (midQ->resp_buf && out_buf
> =A0 =A0 =A0 =A0 =A0 =A0&& (midQ->midState =3D=3D MID_RESPONSE_RECEIVE=
D)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_buf->smb_buf_length =3D receive_len=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_buf->smb_buf_length =3D cpu_to_be32=
(receive_len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy((char *)out_buf + 4,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)midQ->resp_buf + =
4,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 receive_len);
> @@ -815,7 +809,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *pbytes_returned =3D out_buf->smb_buf_l=
ength;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *pbytes_returned =3D be32_to_cpu(out_bu=
f->smb_buf_length);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB special case reconnect tid and u=
id here? */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D map_smb_to_linux_error(out_buf,=
 0 /* no log */ );
> @@ -892,9 +886,10 @@ SendReceiveBlockingLock(const unsigned int xid,
> struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 to the same server. We may make this configurable=
 later or
> =A0 =A0 =A0 =A0 =A0 use ses->maxReq */
>
> - =A0 =A0 =A0 if (in_buf->smb_buf_length > CIFSMaxBufSize + MAX_CIFS_=
HDR_SIZE - 4) {
> + =A0 =A0 =A0 if (be32_to_cpu(in_buf->smb_buf_length) > CIFSMaxBufSiz=
e +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MAX_CIFS_HDR_SIZE - 4) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Illegal length, greater tha=
n maximum frame, %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in_buf->smb_buf_=
length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0be32_to_cpu(in_b=
uf->smb_buf_length));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> =A0 =A0 =A0 =A0}
>
> @@ -925,7 +920,7 @@ SendReceiveBlockingLock(const unsigned int xid,
> struct cifs_tcon *tcon,
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0atomic_inc(&ses->server->inSend);
> =A0#endif
> - =A0 =A0 =A0 rc =3D smb_send(ses->server, in_buf, in_buf->smb_buf_le=
ngth);
> + =A0 =A0 =A0 rc =3D smb_send(ses->server, in_buf, be32_to_cpu(in_buf=
->smb_buf_length));
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0atomic_dec(&ses->server->inSend);
> =A0 =A0 =A0 =A0midQ->when_sent =3D jiffies;
> @@ -992,7 +987,7 @@ SendReceiveBlockingLock(const unsigned int xid,
> struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0if (rc !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> - =A0 =A0 =A0 receive_len =3D midQ->resp_buf->smb_buf_length;
> + =A0 =A0 =A0 receive_len =3D be32_to_cpu(midQ->resp_buf->smb_buf_len=
gth);
> =A0 =A0 =A0 =A0if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Frame too large received. =A0=
Length: %d =A0Xid: %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0receive_len, xid);
> @@ -1008,7 +1003,7 @@ SendReceiveBlockingLock(const unsigned int xid,
> struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 out_buf->smb_buf_length =3D receive_len;
> + =A0 =A0 =A0 out_buf->smb_buf_length =3D cpu_to_be32(receive_len);
> =A0 =A0 =A0 =A0memcpy((char *)out_buf + 4,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)midQ->resp_buf + 4,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 receive_len);
> @@ -1027,7 +1022,7 @@ SendReceiveBlockingLock(const unsigned int xid,
> struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 *pbytes_returned =3D out_buf->smb_buf_length;
> + =A0 =A0 =A0 *pbytes_returned =3D be32_to_cpu(out_buf->smb_buf_lengt=
h);
>
> =A0 =A0 =A0 =A0/* BB special case reconnect tid and uid here? */
> =A0 =A0 =A0 =A0rc =3D map_smb_to_linux_error(out_buf, 0 /* no log */ =
);
>
> --
> Thanks,
>
> Steve
>



--=20
Thanks,

Steve
