From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] CIFS: Move protocol specific part from SendReceive2
 to ops struct
Date: Thu, 17 May 2012 12:44:12 -0500
Message-ID: <CADT32e+jRB1csnn01-Athxn1nbE2-=LoqkuXE28msJy5cs35Xw@mail.gmail.com>
References: <1337269424-9494-1-git-send-email-piastry@etersoft.ru>
	<1337269424-9494-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337269424-9494-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 17, 2012 at 10:43 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>=
 wrote:
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h =A0| =A0 =A05 +++++
> =A0fs/cifs/cifsproto.h | =A0 =A02 ++
> =A0fs/cifs/smb1ops.c =A0 | =A0 =A03 +++
> =A0fs/cifs/transport.c | =A0 =A07 ++++---
> =A04 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index b6e97f8..ff06211 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -157,11 +157,16 @@ enum smb_version {
> =A0struct mid_q_entry;
> =A0struct TCP_Server_Info;
> =A0struct cifsFileInfo;
> +struct cifs_ses;
>
> =A0struct smb_version_operations {
> =A0 =A0 =A0 =A0int (*send_cancel)(struct TCP_Server_Info *, void *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mid_q_entr=
y *);
> =A0 =A0 =A0 =A0bool (*compare_fids)(struct cifsFileInfo *, struct cif=
sFileInfo *);
> + =A0 =A0 =A0 int (*setup_request)(struct cifs_ses *, struct kvec *, =
unsigned int,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct mid_q=
_entry **);
> + =A0 =A0 =A0 int (*check_receive)(struct mid_q_entry *, struct TCP_S=
erver_Info *,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool);
> =A0};
>
> =A0struct smb_version_values {
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 0a3fa96..57af642 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -78,6 +78,8 @@ extern int SendReceive(const unsigned int /* xid */=
 , struct cifs_ses *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int * /* bytes returne=
d */ , const int long_op);
> =A0extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_se=
s *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *in_buf, =
int flags);
> +extern int cifs_setup_request(struct cifs_ses *, struct kvec *, unsi=
gned int,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mid_=
q_entry **);
> =A0extern int cifs_check_receive(struct mid_q_entry *mid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct TCP_Server_Info=
 *server, bool log_error);
> =A0extern int SendReceive2(const unsigned int /* xid */ , struct cifs=
_ses *,
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index ce27f86..3b7cf89 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -21,6 +21,7 @@
> =A0#include "cifsproto.h"
> =A0#include "cifs_debug.h"
> =A0#include "cifspdu.h"
> +#include "cifsproto.h"
>
> =A0/*
> =A0* An NT cancel request header looks just like the original request=
 except:
> @@ -69,6 +70,8 @@ cifs_compare_fids(struct cifsFileInfo *ob1, struct =
cifsFileInfo *ob2)
> =A0struct smb_version_operations smb1_operations =3D {
> =A0 =A0 =A0 =A0.send_cancel =3D send_nt_cancel,
> =A0 =A0 =A0 =A0.compare_fids =3D cifs_compare_fids,
> + =A0 =A0 =A0 .setup_request =3D cifs_setup_request,
> + =A0 =A0 =A0 .check_receive =3D cifs_check_receive,
> =A0};
>
> =A0struct smb_version_values smb1_values =3D {
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 269a5a7..87bd998 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -514,7 +514,7 @@ cifs_check_receive(struct mid_q_entry *mid, struc=
t TCP_Server_Info *server,
> =A0 =A0 =A0 =A0return map_smb_to_linux_error(mid->resp_buf, log_error=
);
> =A0}
>
> -static int
> +int
> =A0cifs_setup_request(struct cifs_ses *ses, struct kvec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nvec, struct mid_q_e=
ntry **ret_mid)
> =A0{
> @@ -577,7 +577,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
>
> =A0 =A0 =A0 =A0mutex_lock(&ses->server->srv_mutex);
>
> - =A0 =A0 =A0 rc =3D cifs_setup_request(ses, iov, n_vec, &midQ);
> + =A0 =A0 =A0 rc =3D ses->server->ops->setup_request(ses, iov, n_vec,=
 &midQ);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release(buf);
> @@ -640,7 +640,8 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*pRespBufType =3D CIFS_SMALL_BUFFER;
>
> - =A0 =A0 =A0 rc =3D cifs_check_receive(midQ, ses->server, flags & CI=
=46S_LOG_ERROR);
> + =A0 =A0 =A0 rc =3D ses->server->ops->check_receive(midQ, ses->serve=
r,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0flags & CIFS_LOG_ERROR);
>
> =A0 =A0 =A0 =A0/* mark it so buf will not be freed by delete_mid */
> =A0 =A0 =A0 =A0if ((flags & CIFS_NO_RESP) =3D=3D 0)
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
