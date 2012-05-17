From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/5] CIFS: Move protocol specific part from
 cifs_readv_receive to ops struct
Date: Thu, 17 May 2012 12:45:07 -0500
Message-ID: <CADT32eK6__j6F_6Lofir9mhcq-6Q7=b6kDKmDejqca_mMJxFsg@mail.gmail.com>
References: <1337269424-9494-1-git-send-email-piastry@etersoft.ru>
	<1337269424-9494-4-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337269424-9494-4-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 17, 2012 at 10:43 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>=
 wrote:
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h | =A0 =A04 ++++
> =A0fs/cifs/cifssmb.c =A0| =A0 34 +++++++---------------------------
> =A0fs/cifs/smb1ops.c =A0| =A0 19 +++++++++++++++++++
> =A03 files changed, 30 insertions(+), 27 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 94657e2..080dd86 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -167,6 +167,9 @@ struct smb_version_operations {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mid_q_=
entry **);
> =A0 =A0 =A0 =A0int (*check_receive)(struct mid_q_entry *, struct TCP_=
Server_Info *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool);
> + =A0 =A0 =A0 unsigned int (*read_data_offset)(char *);
> + =A0 =A0 =A0 unsigned int (*read_data_length)(char *);
> + =A0 =A0 =A0 int (*map_error)(char *, bool);
> =A0};
>
> =A0struct smb_version_values {
> @@ -177,6 +180,7 @@ struct smb_version_values {
> =A0 =A0 =A0 =A0__u32 =A0 =A0 =A0 =A0 =A0 unlock_lock_type;
> =A0 =A0 =A0 =A0size_t =A0 =A0 =A0 =A0 =A0header_size;
> =A0 =A0 =A0 =A0size_t =A0 =A0 =A0 =A0 =A0max_header_size;
> + =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0read_rsp_size;
> =A0};
>
> =A0#define HEADER_SIZE(server) (server->vals->header_size)
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 77463f7..b1f3751 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1411,27 +1411,6 @@ cifs_readv_discard(struct TCP_Server_Info *ser=
ver, struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> -static inline size_t
> -read_rsp_size(void)
> -{
> - =A0 =A0 =A0 return sizeof(READ_RSP);
> -}
> -
> -static inline unsigned int
> -read_data_offset(char *buf)
> -{
> - =A0 =A0 =A0 READ_RSP *rsp =3D (READ_RSP *)buf;
> - =A0 =A0 =A0 return le16_to_cpu(rsp->DataOffset);
> -}
> -
> -static inline unsigned int
> -read_data_length(char *buf)
> -{
> - =A0 =A0 =A0 READ_RSP *rsp =3D (READ_RSP *)buf;
> - =A0 =A0 =A0 return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0le16_to_cpu(rsp->DataLength);
> -}
> -
> =A0static int
> =A0cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_en=
try *mid)
> =A0{
> @@ -1449,7 +1428,7 @@ cifs_readv_receive(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0 * can if there's not enough data. At this point, we'v=
e read down to
> =A0 =A0 =A0 =A0 * the Mid.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 len =3D min_t(unsigned int, buflen, read_rsp_size()) -
> + =A0 =A0 =A0 len =3D min_t(unsigned int, buflen, server->vals->read_=
rsp_size) -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0HEADER_SIZE(server) + 1;
>
> =A0 =A0 =A0 =A0rdata->iov[0].iov_base =3D buf + HEADER_SIZE(server) -=
 1;
> @@ -1461,7 +1440,7 @@ cifs_readv_receive(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0server->total_read +=3D length;
>
> =A0 =A0 =A0 =A0/* Was the SMB read successful? */
> - =A0 =A0 =A0 rdata->result =3D map_smb_to_linux_error(buf, false);
> + =A0 =A0 =A0 rdata->result =3D server->ops->map_error(buf, false);
> =A0 =A0 =A0 =A0if (rdata->result !=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "%s: server returned error %d"=
, __func__,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata->result);
> @@ -1469,14 +1448,15 @@ cifs_readv_receive(struct TCP_Server_Info *se=
rver, struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* Is there enough to get to the rest of the READ_RSP =
header? */
> - =A0 =A0 =A0 if (server->total_read < read_rsp_size()) {
> + =A0 =A0 =A0 if (server->total_read < server->vals->read_rsp_size) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "%s: server returned short hea=
der. got=3D%u expected=3D%zu",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, server->total=
_read, read_rsp_size());
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, server->total=
_read,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->vals->read_rsp_=
size);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata->result =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return cifs_readv_discard(server, mid)=
;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 data_offset =3D read_data_offset(buf) + 4;
> + =A0 =A0 =A0 data_offset =3D server->ops->read_data_offset(buf) + 4;
> =A0 =A0 =A0 =A0if (data_offset < server->total_read) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * win2k8 sometimes sends an offset of=
 0 when the read
> @@ -1515,7 +1495,7 @@ cifs_readv_receive(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata->iov[0].iov_base, rdata->iov[0].=
iov_len);
>
> =A0 =A0 =A0 =A0/* how much data is in the response? */
> - =A0 =A0 =A0 data_len =3D read_data_length(buf);
> + =A0 =A0 =A0 data_len =3D server->ops->read_data_length(buf);
> =A0 =A0 =A0 =A0if (data_offset + data_len > buflen) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* data_len is corrupt -- discard fram=
e */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata->result =3D -EIO;
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 5dc365f..31a6111 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -67,11 +67,29 @@ cifs_compare_fids(struct cifsFileInfo *ob1, struc=
t cifsFileInfo *ob2)
> =A0 =A0 =A0 =A0return ob1->netfid =3D=3D ob2->netfid;
> =A0}
>
> +static unsigned int
> +cifs_read_data_offset(char *buf)
> +{
> + =A0 =A0 =A0 READ_RSP *rsp =3D (READ_RSP *)buf;
> + =A0 =A0 =A0 return le16_to_cpu(rsp->DataOffset);
> +}
> +
> +static unsigned int
> +cifs_read_data_length(char *buf)
> +{
> + =A0 =A0 =A0 READ_RSP *rsp =3D (READ_RSP *)buf;
> + =A0 =A0 =A0 return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0le16_to_cpu(rsp->DataLength);
> +}
> +
> =A0struct smb_version_operations smb1_operations =3D {
> =A0 =A0 =A0 =A0.send_cancel =3D send_nt_cancel,
> =A0 =A0 =A0 =A0.compare_fids =3D cifs_compare_fids,
> =A0 =A0 =A0 =A0.setup_request =3D cifs_setup_request,
> =A0 =A0 =A0 =A0.check_receive =3D cifs_check_receive,
> + =A0 =A0 =A0 .read_data_offset =3D cifs_read_data_offset,
> + =A0 =A0 =A0 .read_data_length =3D cifs_read_data_length,
> + =A0 =A0 =A0 .map_error =3D map_smb_to_linux_error,
> =A0};
>
> =A0struct smb_version_values smb1_values =3D {
> @@ -82,4 +100,5 @@ struct smb_version_values smb1_values =3D {
> =A0 =A0 =A0 =A0.unlock_lock_type =3D 0,
> =A0 =A0 =A0 =A0.header_size =3D sizeof(struct smb_hdr),
> =A0 =A0 =A0 =A0.max_header_size =3D MAX_CIFS_HDR_SIZE,
> + =A0 =A0 =A0 .read_rsp_size =3D sizeof(READ_RSP),
> =A0};
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Looks correct.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
