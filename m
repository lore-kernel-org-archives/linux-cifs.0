From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 10/13] cifs: add ability to send an echo request
Date: Tue, 14 Dec 2010 10:15:48 +0300
Message-ID: <AANLkTiko2sy5MBxeuzT2vyhSzY-NiyE4wbynrA0dSCK_@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-11-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-11-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifspdu.h =A0 | =A0 15 +++++++++++++++
> =A0fs/cifs/cifsproto.h | =A0 =A01 +
> =A0fs/cifs/cifssmb.c =A0 | =A0 47 +++++++++++++++++++++++++++++++++++=
++++++++++++
> =A03 files changed, 63 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index de36b09..ea205b4 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -50,6 +50,7 @@
> =A0#define SMB_COM_SETATTR =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x09 /* trivia=
l response */
> =A0#define SMB_COM_LOCKING_ANDX =A0 =A0 =A0 =A0 =A00x24 /* trivial re=
sponse */
> =A0#define SMB_COM_COPY =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x29 /* tr=
ivial rsp, fail filename ignrd*/
> +#define SMB_COM_ECHO =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x2B /* echo=
 request */
> =A0#define SMB_COM_OPEN_ANDX =A0 =A0 =A0 =A0 =A0 =A0 0x2D /* Legacy o=
pen for old servers */
> =A0#define SMB_COM_READ_ANDX =A0 =A0 =A0 =A0 =A0 =A0 0x2E
> =A0#define SMB_COM_WRITE_ANDX =A0 =A0 =A0 =A0 =A0 =A00x2F
> @@ -760,6 +761,20 @@ typedef struct smb_com_tconx_rsp_ext {
> =A0*
> =A0*/
>
> +typedef struct smb_com_echo_req {
> + =A0 =A0 =A0 struct =A0smb_hdr hdr;
> + =A0 =A0 =A0 __le16 =A0EchoCount;
> + =A0 =A0 =A0 __le16 =A0ByteCount;
> + =A0 =A0 =A0 char =A0 =A0Data[1];
> +} __attribute__((packed)) ECHO_REQ;
> +
> +typedef struct smb_com_echo_rsp {
> + =A0 =A0 =A0 struct =A0smb_hdr hdr;
> + =A0 =A0 =A0 __le16 =A0SequenceNumber;
> + =A0 =A0 =A0 __le16 =A0ByteCount;
> + =A0 =A0 =A0 char =A0 =A0Data[1];
> +} __attribute__((packed)) ECHO_RSP;
> +
> =A0typedef struct smb_com_logoff_andx_req {
> =A0 =A0 =A0 =A0struct smb_hdr hdr; =A0 =A0 /* wct =3D 2 */
> =A0 =A0 =A0 =A0__u8 AndXCommand;
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 6131c1b..3cd6474 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -353,6 +353,7 @@ extern int CIFSSMBPosixLock(const int xid, struct=
 cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const __u64 len, struc=
t file_lock *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const __u16 lock_type,=
 const bool waitFlag);
> =A0extern int CIFSSMBTDis(const int xid, struct cifsTconInfo *tcon);
> +extern int CIFSSMBEcho(struct TCP_Server_Info *server);
> =A0extern int CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses);
>
> =A0extern struct cifsSesInfo *sesInfoAlloc(void);
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 9af98f6..fc8145f 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -706,6 +706,53 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo *=
tcon)
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +/*
> + * This is a no-op for now. We're not really interested in the reply=
, but
> + * rather in the fact that the server sent one and that server->lstr=
p
> + * gets updated.
> + *
> + * FIXME: maybe we should consider checking that the reply matches r=
equest?
> + */
> +static void
> +cifs_echo_callback(struct mid_q_entry *mid)
> +{
> + =A0 =A0 =A0 struct TCP_Server_Info *server =3D mid->callback_data;
> +
> + =A0 =A0 =A0 DeleteMidQEntry(mid);
> + =A0 =A0 =A0 atomic_dec(&server->inFlight);
> + =A0 =A0 =A0 wake_up(&server->request_q);
> +}
> +
> +int
> +CIFSSMBEcho(struct TCP_Server_Info *server)
> +{
> + =A0 =A0 =A0 ECHO_REQ *smb;
> + =A0 =A0 =A0 int rc =3D 0;
> +
> + =A0 =A0 =A0 cFYI(1, "In echo request");
> +
> + =A0 =A0 =A0 rc =3D small_smb_init(SMB_COM_ECHO, 0, NULL, (void **)&=
smb);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> +
> + =A0 =A0 =A0 /* set up echo request */
> + =A0 =A0 =A0 smb->hdr.Tid =3D cpu_to_le16(0xffff);
> + =A0 =A0 =A0 smb->hdr.WordCount =3D cpu_to_le16(1);
> + =A0 =A0 =A0 smb->EchoCount =3D cpu_to_le16(1);
> + =A0 =A0 =A0 smb->ByteCount =3D cpu_to_le16(1);
> + =A0 =A0 =A0 smb->Data[0] =3D 'a';
> + =A0 =A0 =A0 smb->hdr.smb_buf_length +=3D 3;
> +
> + =A0 =A0 =A0 rc =3D cifs_call_async(server, (struct smb_hdr *)smb,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_ec=
ho_callback, server);
> + =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Echo request failed: %d", rc);
> +
> + =A0 =A0 =A0 cifs_small_buf_release(smb);
> +
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0int
> =A0CIFSSMBLogoff(const int xid, struct cifsSesInfo *ses)
> =A0{
> --
> 1.7.3.2
>

Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
--=20
Best regards,
Pavel Shilovsky.
