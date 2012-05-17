From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] CIFS: Move header_size/max_header_size to ops structure
Date: Thu, 17 May 2012 12:44:39 -0500
Message-ID: <CADT32eK8txBTctccMNw-uy9r9kprdcXBt0LTrSKevTPtRrgmEA@mail.gmail.com>
References: <1337269424-9494-1-git-send-email-piastry@etersoft.ru>
	<1337269424-9494-3-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337269424-9494-3-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 17, 2012 at 10:43 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>=
 wrote:
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h | =A0 17 +++++------------
> =A0fs/cifs/cifssmb.c =A0| =A0 =A07 ++++---
> =A0fs/cifs/connect.c =A0| =A0 17 +++++++++--------
> =A0fs/cifs/smb1ops.c =A0| =A0 =A02 ++
> =A04 files changed, 20 insertions(+), 23 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index ff06211..94657e2 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -175,8 +175,13 @@ struct smb_version_values {
> =A0 =A0 =A0 =A0__u32 =A0 =A0 =A0 =A0 =A0 exclusive_lock_type;
> =A0 =A0 =A0 =A0__u32 =A0 =A0 =A0 =A0 =A0 shared_lock_type;
> =A0 =A0 =A0 =A0__u32 =A0 =A0 =A0 =A0 =A0 unlock_lock_type;
> + =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0header_size;
> + =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0max_header_size;
> =A0};
>
> +#define HEADER_SIZE(server) (server->vals->header_size)
> +#define MAX_HEADER_SIZE(server) (server->vals->max_header_size)
> +
> =A0struct smb_vol {
> =A0 =A0 =A0 =A0char *username;
> =A0 =A0 =A0 =A0char *password;
> @@ -372,18 +377,6 @@ has_credits(struct TCP_Server_Info *server, int =
*credits)
> =A0 =A0 =A0 =A0return num > 0;
> =A0}
>
> -static inline size_t
> -header_size(void)
> -{
> - =A0 =A0 =A0 return sizeof(struct smb_hdr);
> -}
> -
> -static inline size_t
> -max_header_size(void)
> -{
> - =A0 =A0 =A0 return MAX_CIFS_HDR_SIZE;
> -}
> -
> =A0/*
> =A0* Macros to allow the TCP_Server_Info->net field and related code =
to drop out
> =A0* when CONFIG_NET_NS isn't set.
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 3563c93..77463f7 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1400,7 +1400,7 @@ cifs_readv_discard(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length =3D cifs_read_from_socket(serve=
r, server->bigbuf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0min_t(=
unsigned int, remaining,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFSMaxBufSize + max_header_size()));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 CIFSMaxBufSize + MAX_HEADER_SIZE(server)));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (length < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return length;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->total_read +=3D length;
> @@ -1449,9 +1449,10 @@ cifs_readv_receive(struct TCP_Server_Info *ser=
ver, struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0 * can if there's not enough data. At this point, we'v=
e read down to
> =A0 =A0 =A0 =A0 * the Mid.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 len =3D min_t(unsigned int, buflen, read_rsp_size()) - =
header_size() + 1;
> + =A0 =A0 =A0 len =3D min_t(unsigned int, buflen, read_rsp_size()) -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 HEADER_SIZE(server) + 1;
>
> - =A0 =A0 =A0 rdata->iov[0].iov_base =3D buf + header_size() - 1;
> + =A0 =A0 =A0 rdata->iov[0].iov_base =3D buf + HEADER_SIZE(server) - =
1;
> =A0 =A0 =A0 =A0rdata->iov[0].iov_len =3D len;
>
> =A0 =A0 =A0 =A0length =3D cifs_readv_from_socket(server, rdata->iov, =
1, len);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 5ac20fc..65ec6ef 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -568,7 +568,7 @@ allocate_buffers(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0} else if (server->large_buf) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we are reusing a dirty large buf, c=
lear its start */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(server->bigbuf, 0, header_size()=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(server->bigbuf, 0, HEADER_SIZE(s=
erver));
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (!server->smallbuf) {
> @@ -582,7 +582,7 @@ allocate_buffers(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* beginning of smb buffer is cleared =
in our buf_get */
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* if existing small buf clear beginni=
ng */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(server->smallbuf, 0, header_size=
());
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(server->smallbuf, 0, HEADER_SIZE=
(server));
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0return true;
> @@ -953,7 +953,7 @@ standard_receive3(struct TCP_Server_Info *server,=
 struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0unsigned int pdu_length =3D get_rfc1002_length(buf);
>
> =A0 =A0 =A0 =A0/* make sure this will fit in a large buffer */
> - =A0 =A0 =A0 if (pdu_length > CIFSMaxBufSize + max_header_size() - 4=
) {
> + =A0 =A0 =A0 if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(serve=
r) - 4) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "SMB response too long (%u b=
ytes)",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdu_length);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_reconnect(server);
> @@ -969,8 +969,8 @@ standard_receive3(struct TCP_Server_Info *server,=
 struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* now read the rest */
> - =A0 =A0 =A0 length =3D cifs_read_from_socket(server, buf + header_s=
ize() - 1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0pdu_length - header_size() + 1 + 4);
> + =A0 =A0 =A0 length =3D cifs_read_from_socket(server, buf + HEADER_S=
IZE(server) - 1,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdu_len=
gth - HEADER_SIZE(server) + 1 + 4);
> =A0 =A0 =A0 =A0if (length < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return length;
> =A0 =A0 =A0 =A0server->total_read +=3D length;
> @@ -1044,7 +1044,7 @@ cifs_demultiplex_thread(void *p)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* make sure we have enough to get to =
the MID */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pdu_length < header_size() - 1 - 4)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pdu_length < HEADER_SIZE(server) - =
1 - 4) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "SMB respons=
e too short (%u bytes)",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdu_le=
ngth);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_reconnect(server)=
;
> @@ -1054,7 +1054,7 @@ cifs_demultiplex_thread(void *p)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* read down to the MID */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length =3D cifs_read_from_socket(serve=
r, buf + 4,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0header_size() - 1 - 4);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0HEADER_SIZE(server) - 1 - 4);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (length < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->total_read +=3D length;
> @@ -1079,7 +1079,8 @@ cifs_demultiplex_thread(void *p)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (!is_valid_oplock_break(buf,=
 server)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "No task to =
wake, unknown frame received! "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
NumMids %d", atomic_read(&midCount));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Received=
 Data is: ", buf, header_size());
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Received=
 Data is: ", buf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 HEADER_SIZE(server));
> =A0#ifdef CONFIG_CIFS_DEBUG2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_dump_detail(buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_dump_mids(server)=
;
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 3b7cf89..5dc365f 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -80,4 +80,6 @@ struct smb_version_values smb1_values =3D {
> =A0 =A0 =A0 =A0.exclusive_lock_type =3D 0,
> =A0 =A0 =A0 =A0.shared_lock_type =3D LOCKING_ANDX_SHARED_LOCK,
> =A0 =A0 =A0 =A0.unlock_lock_type =3D 0,
> + =A0 =A0 =A0 .header_size =3D sizeof(struct smb_hdr),
> + =A0 =A0 =A0 .max_header_size =3D MAX_CIFS_HDR_SIZE,
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
