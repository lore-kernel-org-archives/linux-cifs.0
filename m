From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] cifs: consolidate SendReceive response checks
Date: Tue, 12 Apr 2011 13:38:44 +0400
Message-ID: <BANLkTi==qMxzA3sRERA1YihQuwcCqUi6vg@mail.gmail.com>
References: <1301747039-31411-1-git-send-email-jlayton@redhat.com>
	<1301747039-31411-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301747039-31411-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/2 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Further consolidate the SendReceive code by moving the checks run ove=
r
> the packet into a separate function that all the SendReceive variants
> can call.
>
> We can also eliminate the check for a receive_len that's too big or t=
oo
> small. cifs_demultiplex_thread already checks that and disconnects th=
e
> socket if that occurs, while setting the midStatus to MALFORMED. It'l=
l
> never call this code if that's the case.
>
> Finally do a little cleanup. Use "goto out" on errors so that the flo=
w
> of code in the normal case is more evident. Also switch the logErr
> variable in map_smb_to_linux_error to a bool.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A04 +-
> =A0fs/cifs/netmisc.c =A0 | =A0 =A02 +-
> =A0fs/cifs/transport.c | =A0158 ++++++++++++++-----------------------=
--------------
> =A03 files changed, 46 insertions(+), 118 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 76c4dc7f..4af7db8 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -74,6 +74,8 @@ extern int SendReceive(const unsigned int /* xid */=
 , struct cifs_ses *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int * /* bytes returne=
d */ , const int long_op);
> =A0extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_se=
s *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr *in_buf=
, int flags);
> +extern int cifs_check_receive(struct mid_q_entry *mid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct TCP_Server_Info =
*server, bool log_error);
> =A0extern int SendReceive2(const unsigned int /* xid */ , struct cifs=
_ses *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct kvec *, int /* =
nvec to send */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int * /* type of buf r=
eturned */ , const int flags);
> @@ -97,7 +99,7 @@ extern int cifs_convert_address(struct sockaddr *ds=
t, const char *src, int len);
> =A0extern int cifs_set_port(struct sockaddr *addr, const unsigned sho=
rt int port);
> =A0extern int cifs_fill_sockaddr(struct sockaddr *dst, const char *sr=
c, int len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const =
unsigned short int port);
> -extern int map_smb_to_linux_error(struct smb_hdr *smb, int logErr);
> +extern int map_smb_to_linux_error(struct smb_hdr *smb, bool logErr);
> =A0extern void header_assemble(struct smb_hdr *, char /* command */ ,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct c=
ifs_tcon *, int /* length of
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fixed section =
(word count) in two byte units */);
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index 79b71c2..73e47e8 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -836,7 +836,7 @@ ntstatus_to_dos(__u32 ntstatus, __u8 *eclass, __u=
16 *ecode)
> =A0}
>
> =A0int
> -map_smb_to_linux_error(struct smb_hdr *smb, int logErr)
> +map_smb_to_linux_error(struct smb_hdr *smb, bool logErr)
> =A0{
> =A0 =A0 =A0 =A0unsigned int i;
> =A0 =A0 =A0 =A0int rc =3D -EIO; =A0/* if transport error smb error ma=
y not be set */
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 85063de..d9833fc 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -505,13 +505,32 @@ send_nt_cancel(struct TCP_Server_Info *server, =
struct smb_hdr *in_buf,
> =A0}
>
> =A0int
> +cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *=
server,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool log_error)
> +{
> + =A0 =A0 =A0 dump_smb(mid->resp_buf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0min_t(u32, 92, be32_to_cpu(mid->resp=
_buf->smb_buf_length)));
> +
> + =A0 =A0 =A0 /* convert the length into a more usable form */
> + =A0 =A0 =A0 if (server->sec_mode & (SECMODE_SIGN_REQUIRED |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SECMODE=
_SIGN_ENABLED)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* FIXME: add code to kill session */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_verify_signature(mid->resp_buf=
, server,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 mid->sequence_number + 1) !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unexpected S=
MB signature");
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* BB special case reconnect tid and uid here? */
> + =A0 =A0 =A0 return map_smb_to_linux_error(mid->resp_buf, log_error)=
;
> +}
> +
> +int
> =A0SendReceive2(const unsigned int xid, struct cifs_ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *iov, int n_vec, int *pRespBufTyp=
e /* ret */,
> =A0 =A0 =A0 =A0 =A0 =A0 const int flags)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int long_op;
> - =A0 =A0 =A0 unsigned int receive_len;
> =A0 =A0 =A0 =A0struct mid_q_entry *midQ;
> =A0 =A0 =A0 =A0struct smb_hdr *in_buf =3D iov[0].iov_base;
>
> @@ -604,54 +623,24 @@ SendReceive2(const unsigned int xid, struct cif=
s_ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 receive_len =3D be32_to_cpu(midQ->resp_buf->smb_buf_len=
gth);
> -
> - =A0 =A0 =A0 if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Frame too large received. =A0=
Length: %d =A0Xid: %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 receive_len, xid);
> + =A0 =A0 =A0 if (!midQ->resp_buf || midQ->midState !=3D MID_RESPONSE=
_RECEIVED) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Bad MID state?");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* rcvd frame is ok */
> -
> - =A0 =A0 =A0 if (midQ->resp_buf &&
> - =A0 =A0 =A0 =A0 =A0 (midQ->midState =3D=3D MID_RESPONSE_RECEIVED)) =
{
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[0].iov_base =3D (char *)midQ->resp_=
buf;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (midQ->largeBuf)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *pRespBufType =3D CIFS_=
LARGE_BUFFER;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *pRespBufType =3D CIFS_=
SMALL_BUFFER;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[0].iov_len =3D receive_len + 4;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_smb(midQ->resp_buf, 80);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* convert the length into a more usabl=
e form */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((receive_len > 24) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->sec_mode & (SECMO=
DE_SIGN_REQUIRED |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0SECMODE_SIGN_ENABLED))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_sign=
ature(midQ->resp_buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ses->server,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 midQ->sequence_number+1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "Unexpected SMB signature");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB F=
IXME add code to kill session */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB special case reconnect tid and ui=
d here? */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D map_smb_to_linux_error(midQ->res=
p_buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 flags & CIFS_LOG_ERROR);
> + =A0 =A0 =A0 iov[0].iov_base =3D (char *)midQ->resp_buf;
> + =A0 =A0 =A0 iov[0].iov_len =3D be32_to_cpu(midQ->resp_buf->smb_buf_=
length) + 4;
> + =A0 =A0 =A0 if (midQ->largeBuf)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *pRespBufType =3D CIFS_LARGE_BUFFER;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *pRespBufType =3D CIFS_SMALL_BUFFER;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((flags & CIFS_NO_RESP) =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->resp_buf =3D NULL=
; =A0/* mark it so buf will
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0not be freed by
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delete_mid */
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Bad MID state?");
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 rc =3D cifs_check_receive(midQ, ses->server, flags & CI=
=46S_LOG_ERROR);
>
> + =A0 =A0 =A0 /* mark it so buf will not be freed by delete_mid */
> + =A0 =A0 =A0 if ((flags & CIFS_NO_RESP) =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->resp_buf =3D NULL;
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> =A0 =A0 =A0 =A0atomic_dec(&ses->server->inFlight);
> @@ -666,7 +655,6 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0 =A0 =A0 =A0 =A0 =A0int *pbytes_returned, const int long_op)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> - =A0 =A0 =A0 unsigned int receive_len;
> =A0 =A0 =A0 =A0struct mid_q_entry *midQ;
>
> =A0 =A0 =A0 =A0if (ses =3D=3D NULL) {
> @@ -753,47 +741,16 @@ SendReceive(const unsigned int xid, struct cifs=
_ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 receive_len =3D be32_to_cpu(midQ->resp_buf->smb_buf_len=
gth);
> -
> - =A0 =A0 =A0 if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Frame too large received. =A0=
Length: %d =A0Xid: %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 receive_len, xid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 /* rcvd frame is ok */
> -
> - =A0 =A0 =A0 if (midQ->resp_buf && out_buf
> - =A0 =A0 =A0 =A0 =A0 && (midQ->midState =3D=3D MID_RESPONSE_RECEIVED=
)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_buf->smb_buf_length =3D cpu_to_be32=
(receive_len);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy((char *)out_buf + 4,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(char *)midQ->resp_buf +=
 4,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0receive_len);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_smb(out_buf, 92);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* convert the length into a more usabl=
e form */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((receive_len > 24) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->sec_mode & (SECMO=
DE_SIGN_REQUIRED |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0SECMODE_SIGN_ENABLED))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_sign=
ature(out_buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ses->server,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 midQ->sequence_number+1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "Unexpected SMB signature");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB F=
IXME add code to kill session */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *pbytes_returned =3D be32_to_cpu(out_bu=
f->smb_buf_length);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB special case reconnect tid and ui=
d here? */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D map_smb_to_linux_error(out_buf, =
0 /* no log */ );
> - =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 if (!midQ->resp_buf || !out_buf ||
> + =A0 =A0 =A0 =A0 =A0 midQ->midState !=3D MID_RESPONSE_RECEIVED) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Bad MID state?");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 *pbytes_returned =3D be32_to_cpu(midQ->resp_buf->smb_bu=
f_length);
> + =A0 =A0 =A0 memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
> + =A0 =A0 =A0 rc =3D cifs_check_receive(midQ, ses->server, 0);
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> =A0 =A0 =A0 =A0atomic_dec(&ses->server->inFlight);
> @@ -834,7 +791,6 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int rstart =3D 0;
> - =A0 =A0 =A0 unsigned int receive_len;
> =A0 =A0 =A0 =A0struct mid_q_entry *midQ;
> =A0 =A0 =A0 =A0struct cifs_ses *ses;
>
> @@ -953,46 +909,16 @@ SendReceiveBlockingLock(const unsigned int xid,=
 struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0if (rc !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> - =A0 =A0 =A0 receive_len =3D be32_to_cpu(midQ->resp_buf->smb_buf_len=
gth);
> - =A0 =A0 =A0 if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Frame too large received. =A0=
Length: %d =A0Xid: %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 receive_len, xid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0/* rcvd frame is ok */
> -
> - =A0 =A0 =A0 if ((out_buf =3D=3D NULL) || (midQ->midState !=3D MID_R=
ESPONSE_RECEIVED)) {
> + =A0 =A0 =A0 if (out_buf =3D=3D NULL || midQ->midState !=3D MID_RESP=
ONSE_RECEIVED) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Bad MID state?");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 out_buf->smb_buf_length =3D cpu_to_be32(receive_len);
> - =A0 =A0 =A0 memcpy((char *)out_buf + 4,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0(char *)midQ->resp_buf + 4,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0receive_len);
> -
> - =A0 =A0 =A0 dump_smb(out_buf, 92);
> - =A0 =A0 =A0 /* convert the length into a more usable form */
> - =A0 =A0 =A0 if ((receive_len > 24) &&
> - =A0 =A0 =A0 =A0 =A0 (ses->server->sec_mode & (SECMODE_SIGN_REQUIRED=
 |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0SECMODE_SIGN_ENABLED))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_verify_signature(out_buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0ses->server,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0midQ->sequence_number+1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unexpected S=
MB signature");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB FIXME add code to=
 kill session */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 *pbytes_returned =3D be32_to_cpu(out_buf->smb_buf_lengt=
h);
> -
> - =A0 =A0 =A0 /* BB special case reconnect tid and uid here? */
> - =A0 =A0 =A0 rc =3D map_smb_to_linux_error(out_buf, 0 /* no log */ )=
;
> -
> + =A0 =A0 =A0 *pbytes_returned =3D be32_to_cpu(midQ->resp_buf->smb_bu=
f_length);
> + =A0 =A0 =A0 memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
> + =A0 =A0 =A0 rc =3D cifs_check_receive(midQ, ses->server, 0);
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> =A0 =A0 =A0 =A0if (rstart && rc =3D=3D -EACCES)
> --
> 1.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks good.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
