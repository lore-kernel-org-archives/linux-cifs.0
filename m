From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 07/11] CIFS: Separate protocol-specific code from
 transport routines
Date: Mon, 27 Feb 2012 18:03:01 -0600
Message-ID: <CAH2r5msSathjY4NfnQs-Jd1HhbHLRGRF3c+D=TkoAHrDp0PH+Q@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-8-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329895984-9251-8-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks reasonable to me.

On Wed, Feb 22, 2012 at 1:33 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> that lets us use this functions for SMB2.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifs_debug.h | =A0 =A02 +-
> =A0fs/cifs/cifsglob.h =A0 | =A0 =A06 ++
> =A0fs/cifs/cifsproto.h =A0| =A0 =A02 +-
> =A0fs/cifs/cifssmb.c =A0 =A0| =A0 21 +++---
> =A0fs/cifs/misc.c =A0 =A0 =A0 | =A0 =A05 +-
> =A0fs/cifs/transport.c =A0| =A0171 +++++++++++++++++++++++++++++-----=
----------------
> =A06 files changed, 119 insertions(+), 88 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> index 8942b28..0a234c1 100644
> --- a/fs/cifs/cifs_debug.h
> +++ b/fs/cifs/cifs_debug.h
> @@ -32,7 +32,7 @@ void cifs_dump_mids(struct TCP_Server_Info *);
> =A0#define DBG2 0
> =A0#endif
> =A0extern int traceSMB; =A0 =A0 =A0 =A0 =A0 /* flag which enables the=
 function below */
> -void dump_smb(struct smb_hdr *, int);
> +void dump_smb(void *, int);
> =A0#define CIFS_INFO =A0 =A0 =A00x01
> =A0#define CIFS_RC =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x02
> =A0#define CIFS_TIMER =A0 =A0 0x04
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 4b13be5..e56baca 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -224,6 +224,12 @@ struct cifs_mnt_data {
> =A0 =A0 =A0 =A0int flags;
> =A0};
>
> +static inline unsigned int
> +get_rfc1002_length(void *buf)
> +{
> + =A0 =A0 =A0 return be32_to_cpu(*((__be32 *)buf));
> +}
> +
> =A0struct TCP_Server_Info {
> =A0 =A0 =A0 =A0struct list_head tcp_ses_list;
> =A0 =A0 =A0 =A0struct list_head smb_ses_list;
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 75163a6..6ba8d1c 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -77,7 +77,7 @@ extern int SendReceive(const unsigned int /* xid */=
 , struct cifs_ses *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr * /* ou=
t */ ,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int * /* bytes returne=
d */ , const int long_op);
> =A0extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_se=
s *ses,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *in_buf,=
 int flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *in_buf, i=
nt flags);
> =A0extern int cifs_check_receive(struct mid_q_entry *mid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct TCP_Server_Info=
 *server, bool log_error);
> =A0extern int SendReceive2(const unsigned int /* xid */ , struct cifs=
_ses *,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 985dcce..5ba869f 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -693,7 +693,7 @@ CIFSSMBTDis(const int xid, struct cifs_tcon *tcon=
)
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> - =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, smb_buffer, 0);
> + =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (char *)smb_buf=
fer, 0);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Tree disconnect failed %d", r=
c);
>
> @@ -790,7 +790,7 @@ CIFSSMBLogoff(const int xid, struct cifs_ses *ses=
)
> =A0 =A0 =A0 =A0pSMB->hdr.Uid =3D ses->Suid;
>
> =A0 =A0 =A0 =A0pSMB->AndXCommand =3D 0xFF;
> - =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, ses, (struct smb_hdr *) pS=
MB, 0);
> + =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, ses, (char *) pSMB, 0);
> =A0session_already_dead:
> =A0 =A0 =A0 =A0mutex_unlock(&ses->session_mutex);
>
> @@ -2420,8 +2420,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tc=
on,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSM=
B, &bytes_returned);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release(pSMB);
> =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses,=
 (struct smb_hdr *)pSMB,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 timeout);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses,=
 (char *)pSMB, timeout);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* SMB buffer freed by function above =
*/
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_locks);
> @@ -2588,7 +2587,7 @@ CIFSSMBClose(const int xid, struct cifs_tcon *t=
con, int smb_file_id)
> =A0 =A0 =A0 =A0pSMB->FileID =3D (__u16) smb_file_id;
> =A0 =A0 =A0 =A0pSMB->LastWriteTime =3D 0xFFFFFFFF;
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D 0;
> - =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr=
 *) pSMB, 0);
> + =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, =
0);
> =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_closes);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc !=3D -EINTR) {
> @@ -2617,7 +2616,7 @@ CIFSSMBFlush(const int xid, struct cifs_tcon *t=
con, int smb_file_id)
>
> =A0 =A0 =A0 =A0pSMB->FileID =3D (__u16) smb_file_id;
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D 0;
> - =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr=
 *) pSMB, 0);
> + =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, =
0);
> =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_flushes);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Send error in Flush =3D %d"=
, rc);
> @@ -4625,7 +4624,7 @@ CIFSFindClose(const int xid, struct cifs_tcon *=
tcon,
>
> =A0 =A0 =A0 =A0pSMB->FileID =3D searchHandle;
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D 0;
> - =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr=
 *) pSMB, 0);
> + =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, =
0);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Send error in FindClose =3D=
 %d", rc);
>
> @@ -5646,7 +5645,7 @@ CIFSSMBSetFileSize(const int xid, struct cifs_t=
con *tcon, __u64 size,
> =A0 =A0 =A0 =A0pSMB->Reserved4 =3D 0;
> =A0 =A0 =A0 =A0inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> - =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr=
 *) pSMB, 0);
> + =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, =
0);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Send error in SetFileInfo (Se=
tFileSize) =3D %d", rc);
> =A0 =A0 =A0 =A0}
> @@ -5715,7 +5714,7 @@ CIFSSMBSetFileInfo(const int xid, struct cifs_t=
con *tcon,
> =A0 =A0 =A0 =A0inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
> - =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr=
 *) pSMB, 0);
> + =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, =
0);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Send error in Set Time (SetFi=
leInfo) =3D %d", rc);
>
> @@ -5774,7 +5773,7 @@ CIFSSMBSetFileDisposition(const int xid, struct=
 cifs_tcon *tcon,
> =A0 =A0 =A0 =A0inc_rfc1001_len(pSMB, byte_count);
> =A0 =A0 =A0 =A0pSMB->ByteCount =3D cpu_to_le16(byte_count);
> =A0 =A0 =A0 =A0*data_offset =3D delete_file ? 1 : 0;
> - =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr=
 *) pSMB, 0);
> + =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, =
0);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Send error in SetFileDisposit=
ion =3D %d", rc);
>
> @@ -6006,7 +6005,7 @@ CIFSSMBUnixSetFileInfo(const int xid, struct ci=
fs_tcon *tcon,
>
> =A0 =A0 =A0 =A0cifs_fill_unix_set_info(data_offset, args);
>
> - =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr=
 *) pSMB, 0);
> + =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, =
0);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Send error in Set Time (SetFi=
leInfo) =3D %d", rc);
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index e14dc8f..8e7516f 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -604,16 +604,15 @@ is_valid_oplock_break(struct smb_hdr *buf, stru=
ct TCP_Server_Info *srv)
> =A0}
>
> =A0void
> -dump_smb(struct smb_hdr *smb_buf, int smb_buf_length)
> +dump_smb(void *buf, int smb_buf_length)
> =A0{
> =A0 =A0 =A0 =A0int i, j;
> =A0 =A0 =A0 =A0char debug_line[17];
> - =A0 =A0 =A0 unsigned char *buffer;
> + =A0 =A0 =A0 unsigned char *buffer =3D buf;
>
> =A0 =A0 =A0 =A0if (traceSMB =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> - =A0 =A0 =A0 buffer =3D (unsigned char *) smb_buf;
> =A0 =A0 =A0 =A0for (i =3D 0, j =3D 0; i < smb_buf_length; i++, j++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (i % 8 =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* have reached the be=
ginning of line */
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 91f009d..0d2707e 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -126,11 +126,11 @@ smb_sendv(struct TCP_Server_Info *server, struc=
t kvec *iov, int n_vec)
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int i =3D 0;
> =A0 =A0 =A0 =A0struct msghdr smb_msg;
> - =A0 =A0 =A0 struct smb_hdr *smb_buffer =3D iov[0].iov_base;
> + =A0 =A0 =A0 __be32 *buf_len =3D (__be32 *)(iov[0].iov_base);
> =A0 =A0 =A0 =A0unsigned int len =3D iov[0].iov_len;
> =A0 =A0 =A0 =A0unsigned int total_len;
> =A0 =A0 =A0 =A0int first_vec =3D 0;
> - =A0 =A0 =A0 unsigned int smb_buf_length =3D be32_to_cpu(smb_buffer-=
>smb_buf_length);
> + =A0 =A0 =A0 unsigned int smb_buf_length =3D get_rfc1002_length(iov[=
0].iov_base);
> =A0 =A0 =A0 =A0struct socket *ssocket =3D server->ssocket;
>
> =A0 =A0 =A0 =A0if (ssocket =3D=3D NULL)
> @@ -150,7 +150,7 @@ smb_sendv(struct TCP_Server_Info *server, struct =
kvec *iov, int n_vec)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0total_len +=3D iov[i].iov_len;
>
> =A0 =A0 =A0 =A0cFYI(1, "Sending smb: =A0total_len %d", total_len);
> - =A0 =A0 =A0 dump_smb(smb_buffer, len);
> + =A0 =A0 =A0 dump_smb(iov[0].iov_base, len);
>
> =A0 =A0 =A0 =A0i =3D 0;
> =A0 =A0 =A0 =A0while (total_len) {
> @@ -158,24 +158,24 @@ smb_sendv(struct TCP_Server_Info *server, struc=
t kvec *iov, int n_vec)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
n_vec - first_vec, total_len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((rc =3D=3D -ENOSPC) || (rc =3D=3D =
-EAGAIN)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if blocking send we =
try 3 times, since each can block
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for 5 seconds. F=
or nonblocking =A0we have to try more
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0but wait increas=
ing amounts of time allowing time for
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0socket to clear.=
 =A0The overall time we wait in either
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case to send on =
the socket is about 15 seconds.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Similarly we wai=
t for 15 seconds for
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0a response from =
the server in SendReceive[2]
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for the server t=
o send a response back for
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0most types of re=
quests (except SMB Write
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0past end of file=
 which can be slow, and
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0blocking lock op=
erations). NFS waits slightly longer
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0than CIFS, but t=
his can make it take longer for
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nonresponsive se=
rvers to be detected and 15 seconds
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is more than eno=
ugh time for modern networks to
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0send a packet. =A0=
In most cases if we fail to send
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0after the retrie=
s we will kill the socket and
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reconnect which =
may clear the network problem.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If blocking send w=
e try 3 times, since each can block
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* for 5 seconds. For=
 nonblocking =A0we have to try more
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* but wait increasin=
g amounts of time allowing time for
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* socket to clear. =A0=
The overall time we wait in either
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* case to send on th=
e socket is about 15 seconds.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Similarly we wait =
for 15 seconds for a response from
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the server in Send=
Receive[2] for the server to send
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* a response back fo=
r most types of requests (except
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* SMB Write past end=
 of file which can be slow, and
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* blocking lock oper=
ations). NFS waits slightly longer
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* than CIFS, but thi=
s can make it take longer for
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* nonresponsive serv=
ers to be detected and 15 seconds
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* is more than enoug=
h time for modern networks to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* send a packet. =A0=
In most cases if we fail to send
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* after the retries =
we will kill the socket and
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* reconnect which ma=
y clear the network problem.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((i >=3D 14) || (!s=
erver->noblocksnd && (i > 2))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "sends on sock %p stuck for 15 seconds",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
ssocket);
> @@ -235,9 +235,8 @@ smb_sendv(struct TCP_Server_Info *server, struct =
kvec *iov, int n_vec)
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D 0;
>
> - =A0 =A0 =A0 /* Don't want to modify the buffer as a
> - =A0 =A0 =A0 =A0 =A0side effect of this call. */
> - =A0 =A0 =A0 smb_buffer->smb_buf_length =3D cpu_to_be32(smb_buf_leng=
th);
> + =A0 =A0 =A0 /* Don't want to modify the buffer as a side effect of =
this call. */
> + =A0 =A0 =A0 *buf_len =3D cpu_to_be32(smb_buf_length);
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -331,6 +330,33 @@ wait_for_response(struct TCP_Server_Info *server=
, struct mid_q_entry *midQ)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +static int
> +cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec=
 *iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nvec, s=
truct mid_q_entry **ret_mid)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct smb_hdr *hdr =3D (struct smb_hdr *)iov[0].iov_ba=
se;
> + =A0 =A0 =A0 struct mid_q_entry *mid;
> +
> + =A0 =A0 =A0 /* enable signing if server requires it */
> + =A0 =A0 =A0 if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE=
_SIGN_ENABLED))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hdr->Flags2 |=3D SMBFLG2_SECURITY_SIGNA=
TURE;
> +
> + =A0 =A0 =A0 mid =3D AllocMidQEntry(hdr, server);
> + =A0 =A0 =A0 if (mid =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 /* put it on the pending_mid_q */
> + =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> + =A0 =A0 =A0 list_add_tail(&mid->qhead, &server->pending_mid_q);
> + =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> +
> + =A0 =A0 =A0 rc =3D cifs_sign_smb2(iov, nvec, server, &mid->sequence=
_number);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 delete_mid(mid);
> + =A0 =A0 =A0 *ret_mid =3D mid;
> + =A0 =A0 =A0 return rc;
> +}
>
> =A0/*
> =A0* Send a SMB request and set the callback function in the mid to h=
andle
> @@ -343,34 +369,18 @@ cifs_call_async(struct TCP_Server_Info *server,=
 struct kvec *iov,
> =A0{
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0struct mid_q_entry *mid;
> - =A0 =A0 =A0 struct smb_hdr *hdr =3D (struct smb_hdr *)iov[0].iov_ba=
se;
>
> =A0 =A0 =A0 =A0rc =3D wait_for_free_request(server, optype);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> - =A0 =A0 =A0 /* enable signing if server requires it */
> - =A0 =A0 =A0 if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE=
_SIGN_ENABLED))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 hdr->Flags2 |=3D SMBFLG2_SECURITY_SIGNA=
TURE;
> -
> =A0 =A0 =A0 =A0mutex_lock(&server->srv_mutex);
> - =A0 =A0 =A0 mid =3D AllocMidQEntry(hdr, server);
> - =A0 =A0 =A0 if (mid =3D=3D NULL) {
> + =A0 =A0 =A0 rc =3D cifs_setup_async_request(server, iov, nvec, &mid=
);
> + =A0 =A0 =A0 if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0add_credits(server, 1, optype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&server->request_q);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 /* put it on the pending_mid_q */
> - =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> - =A0 =A0 =A0 list_add_tail(&mid->qhead, &server->pending_mid_q);
> - =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> -
> - =A0 =A0 =A0 rc =3D cifs_sign_smb2(iov, nvec, server, &mid->sequence=
_number);
> - =A0 =A0 =A0 if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0mid->receive =3D receive;
> @@ -406,14 +416,14 @@ out_err:
> =A0*/
> =A0int
> =A0SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *in_buf, int flags)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *in_buf, int flags)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0struct kvec iov[1];
> =A0 =A0 =A0 =A0int resp_buf_type;
>
> - =A0 =A0 =A0 iov[0].iov_base =3D (char *)in_buf;
> - =A0 =A0 =A0 iov[0].iov_len =3D be32_to_cpu(in_buf->smb_buf_length) =
+ 4;
> + =A0 =A0 =A0 iov[0].iov_base =3D in_buf;
> + =A0 =A0 =A0 iov[0].iov_len =3D get_rfc1002_length(in_buf) + 4;
> =A0 =A0 =A0 =A0flags |=3D CIFS_NO_RESP;
> =A0 =A0 =A0 =A0rc =3D SendReceive2(xid, ses, iov, 1, &resp_buf_type, =
flags);
> =A0 =A0 =A0 =A0cFYI(DBG2, "SendRcvNoRsp flags %d rc %d", flags, rc);
> @@ -496,7 +506,7 @@ int
> =A0cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info=
 *server,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool log_error)
> =A0{
> - =A0 =A0 =A0 unsigned int len =3D be32_to_cpu(mid->resp_buf->smb_buf=
_length) + 4;
> + =A0 =A0 =A0 unsigned int len =3D get_rfc1002_length(mid->resp_buf) =
+ 4;
>
> =A0 =A0 =A0 =A0dump_smb(mid->resp_buf, min_t(u32, 92, len));
>
> @@ -516,6 +526,24 @@ cifs_check_receive(struct mid_q_entry *mid, stru=
ct TCP_Server_Info *server,
> =A0 =A0 =A0 =A0return map_smb_to_linux_error(mid->resp_buf, log_error=
);
> =A0}
>
> +static int
> +cifs_setup_request(struct cifs_ses *ses, struct kvec *iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nvec, struct mid_q_=
entry **ret_mid)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct smb_hdr *hdr =3D (struct smb_hdr *)iov[0].iov_ba=
se;
> + =A0 =A0 =A0 struct mid_q_entry *mid;
> +
> + =A0 =A0 =A0 rc =3D allocate_mid(ses, hdr, &mid);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 rc =3D cifs_sign_smb2(iov, nvec, ses->server, &mid->seq=
uence_number);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 delete_mid(mid);
> + =A0 =A0 =A0 *ret_mid =3D mid;
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0int
> =A0SendReceive2(const unsigned int xid, struct cifs_ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *iov, int n_vec, int *pRespBufTyp=
e /* ret */,
> @@ -525,7 +553,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0int long_op;
> =A0 =A0 =A0 =A0int optype;
> =A0 =A0 =A0 =A0struct mid_q_entry *midQ;
> - =A0 =A0 =A0 struct smb_hdr *in_buf =3D iov[0].iov_base;
> + =A0 =A0 =A0 char *buf =3D iov[0].iov_base;
>
> =A0 =A0 =A0 =A0long_op =3D flags & CIFS_TIMEOUT_MASK;
> =A0 =A0 =A0 =A0optype =3D flags & CIFS_REQ_MASK;
> @@ -533,47 +561,45 @@ SendReceive2(const unsigned int xid, struct cif=
s_ses *ses,
> =A0 =A0 =A0 =A0*pRespBufType =3D CIFS_NO_BUFFER; =A0/* no response bu=
f yet */
>
> =A0 =A0 =A0 =A0if ((ses =3D=3D NULL) || (ses->server =3D=3D NULL)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(in_buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Null session");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (ses->server->tcpStatus =3D=3D CifsExiting) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(in_buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOENT;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* Ensure that we do not send more than 50 overlapping =
requests
> - =A0 =A0 =A0 =A0 =A0to the same server. We may make this configurabl=
e later or
> - =A0 =A0 =A0 =A0 =A0use ses->maxReq */
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Ensure that we do not send more than 50 overlappin=
g requests
> + =A0 =A0 =A0 =A0* to the same server. We may make this configurable =
later or
> + =A0 =A0 =A0 =A0* use ses->maxReq.
> + =A0 =A0 =A0 =A0*/
>
> =A0 =A0 =A0 =A0rc =3D wait_for_free_request(ses->server, optype);
> =A0 =A0 =A0 =A0if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(in_buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* make sure that we sign in the same order that we sen=
d on this socket
> - =A0 =A0 =A0 =A0 =A0and avoid races inside tcp sendmsg code that cou=
ld cause corruption
> - =A0 =A0 =A0 =A0 =A0of smb data */
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Make sure that we sign in the same order that we s=
end on this socket
> + =A0 =A0 =A0 =A0* and avoid races inside tcp sendmsg code that could=
 cause corruption
> + =A0 =A0 =A0 =A0* of smb data.
> + =A0 =A0 =A0 =A0*/
>
> =A0 =A0 =A0 =A0mutex_lock(&ses->server->srv_mutex);
>
> - =A0 =A0 =A0 rc =3D allocate_mid(ses, in_buf, &midQ);
> + =A0 =A0 =A0 rc =3D cifs_setup_request(ses, iov, n_vec, &midQ);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(in_buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Update # of requests on wire to ser=
ver */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0add_credits(ses->server, 1, optype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 rc =3D cifs_sign_smb2(iov, n_vec, ses->server, &midQ->s=
equence_number);
> - =A0 =A0 =A0 if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&ses->server->srv_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(in_buf);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0midQ->midState =3D MID_REQUEST_SUBMITTED;
> =A0 =A0 =A0 =A0cifs_in_send_inc(ses->server);
> @@ -584,23 +610,23 @@ SendReceive2(const unsigned int xid, struct cif=
s_ses *ses,
> =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
>
> =A0 =A0 =A0 =A0if (rc < 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(in_buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (long_op =3D=3D CIFS_ASYNC_OP) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(in_buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0rc =3D wait_for_response(ses->server, midQ);
> =A0 =A0 =A0 =A0if (rc !=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 send_nt_cancel(ses->server, in_buf, mid=
Q);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 send_nt_cancel(ses->server, (struct smb=
_hdr *)buf, midQ);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (midQ->midState =3D=3D MID_REQUEST_=
SUBMITTED) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->callback =3D Del=
eteMidQEntry;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(=
in_buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(=
buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0add_credits(ses->serve=
r, 1, optype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->=
request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> @@ -608,7 +634,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 cifs_small_buf_release(in_buf);
> + =A0 =A0 =A0 cifs_small_buf_release(buf);
>
> =A0 =A0 =A0 =A0rc =3D cifs_sync_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0) {
> @@ -623,8 +649,9 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 iov[0].iov_base =3D (char *)midQ->resp_buf;
> - =A0 =A0 =A0 iov[0].iov_len =3D be32_to_cpu(midQ->resp_buf->smb_buf_=
length) + 4;
> + =A0 =A0 =A0 buf =3D (char *)midQ->resp_buf;
> + =A0 =A0 =A0 iov[0].iov_base =3D buf;
> + =A0 =A0 =A0 iov[0].iov_len =3D get_rfc1002_length(buf) + 4;
> =A0 =A0 =A0 =A0if (midQ->largeBuf)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*pRespBufType =3D CIFS_LARGE_BUFFER;
> =A0 =A0 =A0 =A0else
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
