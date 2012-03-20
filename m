From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 08/11] CIFS: Separate protocol-specific code from
 demultiplex code
Date: Tue, 20 Mar 2012 06:22:08 -0400
Message-ID: <20120320062208.447dd359@tlielax.poochiereds.net>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-9-git-send-email-piastry@etersoft.ru>
	<20120319154150.03713caf@redhat.com>
	<CAKywueTxicF658ys1yBzC_95qw0v8R+6pxuhZ_zc+aRKyRLFdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTxicF658ys1yBzC_95qw0v8R+6pxuhZ_zc+aRKyRLFdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 20 Mar 2012 11:29:45 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 19 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2012=C2=A0=D0=B3. 23:41 =D0=BF=D0=BE=
=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Jeff Layto=
n <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> > On Fri, 16 Mar 2012 18:09:31 +0300
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifs_debug.c | =C2=A0 =C2=A05 ++-
> >> =C2=A0fs/cifs/cifs_debug.h | =C2=A0 =C2=A02 +-
> >> =C2=A0fs/cifs/cifsglob.h =C2=A0 | =C2=A0 =C2=A02 +-
> >> =C2=A0fs/cifs/cifsproto.h =C2=A0| =C2=A0 =C2=A05 +--
> >> =C2=A0fs/cifs/connect.c =C2=A0 =C2=A0| =C2=A0 78 +++++++++++++++++=
++++++++++-----------------------
> >> =C2=A0fs/cifs/misc.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A07 +++-
> >> =C2=A0fs/cifs/transport.c =C2=A0| =C2=A0 =C2=A04 +-
> >> =C2=A07 files changed, 56 insertions(+), 47 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> >> index 573b899..bcd0db7 100644
> >> --- a/fs/cifs/cifs_debug.c
> >> +++ b/fs/cifs/cifs_debug.c
> >> @@ -58,15 +58,16 @@ cifs_dump_mem(char *label, void *data, int len=
gth)
> >> =C2=A0}
> >>
> >> =C2=A0#ifdef CONFIG_CIFS_DEBUG2
> >> -void cifs_dump_detail(struct smb_hdr *smb)
> >> +void cifs_dump_detail(void *buf)
> >> =C2=A0{
> >> + =C2=A0 =C2=A0 struct smb_hdr *smb =3D (struct smb_hdr *)buf;
> >> +
> >> =C2=A0 =C2=A0 =C2=A0 cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs=
2: 0x%x Mid: %d Pid: %d",
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 smb->Comma=
nd, smb->Status.CifsError,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 smb->Flags=
, smb->Flags2, smb->Mid, smb->Pid);
> >> =C2=A0 =C2=A0 =C2=A0 cERROR(1, "smb buf %p len %d", smb, smbCalcSi=
ze(smb));
> >> =C2=A0}
> >>
> >> -
> >> =C2=A0void cifs_dump_mids(struct TCP_Server_Info *server)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 struct list_head *tmp;
> >> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> >> index 0a234c1..566e0ae 100644
> >> --- a/fs/cifs/cifs_debug.h
> >> +++ b/fs/cifs/cifs_debug.h
> >> @@ -26,7 +26,7 @@
> >> =C2=A0void cifs_dump_mem(char *label, void *data, int length);
> >> =C2=A0#ifdef CONFIG_CIFS_DEBUG2
> >> =C2=A0#define DBG2 2
> >> -void cifs_dump_detail(struct smb_hdr *);
> >> +void cifs_dump_detail(void *);
> >> =C2=A0void cifs_dump_mids(struct TCP_Server_Info *);
> >> =C2=A0#else
> >> =C2=A0#define DBG2 0
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index c3c7d7c..34a897e 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -730,7 +730,7 @@ struct mid_q_entry {
> >> =C2=A0 =C2=A0 =C2=A0 mid_receive_t *receive; /* call receive callb=
ack */
> >> =C2=A0 =C2=A0 =C2=A0 mid_callback_t *callback; /* call completion =
callback */
> >> =C2=A0 =C2=A0 =C2=A0 void *callback_data; =C2=A0 =C2=A0 =C2=A0/* g=
eneral purpose pointer for callback */
> >> - =C2=A0 =C2=A0 struct smb_hdr *resp_buf; =C2=A0 =C2=A0 =C2=A0 /* =
pointer to received SMB header */
> >> + =C2=A0 =C2=A0 void *resp_buf; =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* poi=
nter to received SMB header */
> >> =C2=A0 =C2=A0 =C2=A0 int midState; =C2=A0 /* wish this were enum b=
ut can not pass to wait_event */
> >> =C2=A0 =C2=A0 =C2=A0 __u8 command; =C2=A0 /* smb command code */
> >> =C2=A0 =C2=A0 =C2=A0 bool largeBuf:1; =C2=A0 =C2=A0 =C2=A0 =C2=A0/=
* if valid response, is pointer to large buf */
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index 2d506e3..15c9b59 100644
> >> --- a/fs/cifs/cifsproto.h
> >> +++ b/fs/cifs/cifsproto.h
> >> @@ -91,9 +91,8 @@ extern int SendReceiveBlockingLock(const unsigne=
d int xid,
> >> =C2=A0extern void cifs_add_credits(struct TCP_Server_Info *server,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const unsigned int add);
> >> =C2=A0extern void cifs_set_credits(struct TCP_Server_Info *server,=
 const int val);
> >> -extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int =
length);
> >> -extern bool is_valid_oplock_break(struct smb_hdr *smb,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct TCP_Server_Info *);
> >> +extern int checkSMB(char *buf, unsigned int length);
> >> +extern bool is_valid_oplock_break(char *, struct TCP_Server_Info =
*);
> >> =C2=A0extern bool backup_cred(struct cifs_sb_info *);
> >> =C2=A0extern bool is_size_safe_to_change(struct cifsInodeInfo *, _=
_u64 eof);
> >> =C2=A0extern void cifs_update_eof(struct cifsInodeInfo *cifsi, lof=
f_t offset,
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 4156351..76cffc9 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -183,8 +183,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -EINVAL =3D inval=
id transact2
> >>
> >> =C2=A0 */
> >> -static int check2ndT2(struct smb_hdr *pSMB)
> >> +static int check2ndT2(char *buf)
> >> =C2=A0{
> >> + =C2=A0 =C2=A0 struct smb_hdr *pSMB =3D (struct smb_hdr *)buf;
> >> =C2=A0 =C2=A0 =C2=A0 struct smb_t2_rsp *pSMBt;
> >> =C2=A0 =C2=A0 =C2=A0 int remaining;
> >> =C2=A0 =C2=A0 =C2=A0 __u16 total_data_size, data_in_this_rsp;
> >> @@ -224,10 +225,10 @@ static int check2ndT2(struct smb_hdr *pSMB)
> >> =C2=A0 =C2=A0 =C2=A0 return remaining;
> >> =C2=A0}
> >>
> >> -static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *p=
TargetSMB)
> >> +static int coalesce_t2(char *second_buf, struct smb_hdr *target_h=
dr)
> >> =C2=A0{
> >> - =C2=A0 =C2=A0 struct smb_t2_rsp *pSMBs =3D (struct smb_t2_rsp *)=
psecond;
> >> - =C2=A0 =C2=A0 struct smb_t2_rsp *pSMBt =C2=A0=3D (struct smb_t2_=
rsp *)pTargetSMB;
> >> + =C2=A0 =C2=A0 struct smb_t2_rsp *pSMBs =3D (struct smb_t2_rsp *)=
second_buf;
> >> + =C2=A0 =C2=A0 struct smb_t2_rsp *pSMBt =C2=A0=3D (struct smb_t2_=
rsp *)target_hdr;
> >> =C2=A0 =C2=A0 =C2=A0 char *data_area_of_tgt;
> >> =C2=A0 =C2=A0 =C2=A0 char *data_area_of_src;
> >> =C2=A0 =C2=A0 =C2=A0 int remaining;
> >> @@ -280,23 +281,23 @@ static int coalesce_t2(struct smb_hdr *pseco=
nd, struct smb_hdr *pTargetSMB)
> >> =C2=A0 =C2=A0 =C2=A0 put_unaligned_le16(total_in_tgt, &pSMBt->t2_r=
sp.DataCount);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /* fix up the BCC */
> >> - =C2=A0 =C2=A0 byte_count =3D get_bcc(pTargetSMB);
> >> + =C2=A0 =C2=A0 byte_count =3D get_bcc(target_hdr);
> >> =C2=A0 =C2=A0 =C2=A0 byte_count +=3D total_in_src;
> >> =C2=A0 =C2=A0 =C2=A0 /* is the result too big for the field? */
> >> =C2=A0 =C2=A0 =C2=A0 if (byte_count > USHRT_MAX) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "coalesce=
d BCC too large (%u)", byte_count);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EPROTO;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> - =C2=A0 =C2=A0 put_bcc(byte_count, pTargetSMB);
> >> + =C2=A0 =C2=A0 put_bcc(byte_count, target_hdr);
> >>
> >> - =C2=A0 =C2=A0 byte_count =3D be32_to_cpu(pTargetSMB->smb_buf_len=
gth);
> >> + =C2=A0 =C2=A0 byte_count =3D be32_to_cpu(target_hdr->smb_buf_len=
gth);
> >> =C2=A0 =C2=A0 =C2=A0 byte_count +=3D total_in_src;
> >> =C2=A0 =C2=A0 =C2=A0 /* don't allow buffer to overflow */
> >> =C2=A0 =C2=A0 =C2=A0 if (byte_count > CIFSMaxBufSize + MAX_CIFS_HD=
R_SIZE - 4) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "coalesce=
d BCC exceeds buffer size (%u)", byte_count);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOBUFS;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> - =C2=A0 =C2=A0 pTargetSMB->smb_buf_length =3D cpu_to_be32(byte_co=
unt);
> >> + =C2=A0 =C2=A0 target_hdr->smb_buf_length =3D cpu_to_be32(byte_co=
unt);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /* copy second buffer into end of first buffe=
r */
> >> =C2=A0 =C2=A0 =C2=A0 memcpy(data_area_of_tgt, data_area_of_src, to=
tal_in_src);
> >> @@ -337,6 +338,18 @@ requeue_echo:
> >> =C2=A0 =C2=A0 =C2=A0 queue_delayed_work(system_nrt_wq, &server->ec=
ho, SMB_ECHO_INTERVAL);
> >> =C2=A0}
> >>
> >> +static inline size_t
> >> +header_size(void)
> >> +{
> >> + =C2=A0 =C2=A0 return sizeof(struct smb_hdr);
> >> +}
> >> +
> >
> > I guess that eventually things like this will have a smb2 variant, =
and
> > you'll bundle them all up into a set of "transport ops" or somethin=
g?
>=20
> Now I modify these functions for SMB2 code to this variant:
>=20
> static inline size_t
> header_size(server)
> {
> #ifdef CONFIG_CIFS_SMB2
>         if (server->is_smb2)
>                  return sizeof(struct smb2_hdr);
> #endif
>         return sizeof(struct smb_hdr);
> }
>=20
> But having smth like:
>=20
> struct TCP_Server_Info {
> ...
> struct cifs_transport_ops *t_ops;
> ...
> }
>=20
> and then using server->t_ops->header_size() looks better.
>=20
> I also have an idea to have such ops structures for cifsFileInfo and
> cifsInodeInfo pointers. I think this let us make the code cleaner.
> (Now I use ifdefs and callbacks to share the code between cifs and
> smb2). Thoughts?
>=20

Yes, that would be much cleaner and more efficient too. Just set the
transport ops when the connection is negotiated and then call the
appropriate one in the appropriate situation.

That also makes it easier to deal with protocol changes in the future.
If you need a different operation for 2.0 vs. 2.2 then you can just
create different ops there and call the right one.

If you look at the NFS client code, then you'll see that that's how it
handles the different protocols too -- see struct nfs_rpc_ops. That
model has worked well over the years. We ought to do something similar
here.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
