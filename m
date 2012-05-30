From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 3/7] CIFS: Move trans2 processing to ops struct
Date: Wed, 30 May 2012 13:17:29 -0400
Message-ID: <20120530131729.2f78486f@corrin.poochiereds.net>
References: <1338308344-29149-1-git-send-email-pshilovsky@samba.org>
	<1338308344-29149-4-git-send-email-pshilovsky@samba.org>
	<20120530113523.6b76177e@corrin.poochiereds.net>
	<CAKywueQzkZRyyhNpkQn8V8YHf9AuK+dM3t_zZRWs1cJo7vP61A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQzkZRyyhNpkQn8V8YHf9AuK+dM3t_zZRWs1cJo7vP61A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 30 May 2012 20:38:15 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> 2012/5/30 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> > On Tue, 29 May 2012 20:19:00 +0400
> > Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >
> >> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsglob.h | =C2=A0 =C2=A03 +
> >> =C2=A0fs/cifs/connect.c =C2=A0| =C2=A0160 +-----------------------=
-------------------------
> >> =C2=A0fs/cifs/smb1ops.c =C2=A0| =C2=A0170 ++++++++++++++++++++++++=
++++++++++++++++++++++++++++
> >> =C2=A03 files changed, 174 insertions(+), 159 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index a660577..3b8828b 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -187,6 +187,9 @@ struct smb_version_operations {
> >> =C2=A0 =C2=A0 =C2=A0 /* verify the message */
> >> =C2=A0 =C2=A0 =C2=A0 int (*check_message)(char *, unsigned int);
> >> =C2=A0 =C2=A0 =C2=A0 bool (*is_oplock_break)(char *, struct TCP_Se=
rver_Info *);
> >> + =C2=A0 =C2=A0 /* process transaction2 response */
> >> + =C2=A0 =C2=A0 bool (*check_trans2)(struct mid_q_entry *, struct =
TCP_Server_Info *,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0char *, int);
> >> =C2=A0};
> >>
> >> =C2=A0struct smb_version_values {
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 9362f90..dc96835 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -394,143 +394,6 @@ cifs_reconnect(struct TCP_Server_Info *serve=
r)
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0}
> >>
> >> -/*
> >> - =C2=A0 =C2=A0 return codes:
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0=
 not a transact2, or all data present
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 >0 =C2=A0 =C2=A0 =C2=A0=
transact2 with that much data missing
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -EINVAL =3D invalid tr=
ansact2
> >> -
> >> - */
> >> -static int check2ndT2(char *buf)
> >> -{
> >> - =C2=A0 =C2=A0 struct smb_hdr *pSMB =3D (struct smb_hdr *)buf;
> >> - =C2=A0 =C2=A0 struct smb_t2_rsp *pSMBt;
> >> - =C2=A0 =C2=A0 int remaining;
> >> - =C2=A0 =C2=A0 __u16 total_data_size, data_in_this_rsp;
> >> -
> >> - =C2=A0 =C2=A0 if (pSMB->Command !=3D SMB_COM_TRANSACTION2)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> -
> >> - =C2=A0 =C2=A0 /* check for plausible wct, bcc and t2 data and pa=
rm sizes */
> >> - =C2=A0 =C2=A0 /* check for parm and data offset going beyond end=
 of smb */
> >> - =C2=A0 =C2=A0 if (pSMB->WordCount !=3D 10) { /* coalesce_t2 depe=
nds on this */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "invalid trans=
act2 word count");
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> >> - =C2=A0 =C2=A0 }
> >> -
> >> - =C2=A0 =C2=A0 pSMBt =3D (struct smb_t2_rsp *)pSMB;
> >> -
> >> - =C2=A0 =C2=A0 total_data_size =3D get_unaligned_le16(&pSMBt->t2_=
rsp.TotalDataCount);
> >> - =C2=A0 =C2=A0 data_in_this_rsp =3D get_unaligned_le16(&pSMBt->t2=
_rsp.DataCount);
> >> -
> >> - =C2=A0 =C2=A0 if (total_data_size =3D=3D data_in_this_rsp)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> - =C2=A0 =C2=A0 else if (total_data_size < data_in_this_rsp) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "total data %d=
 smaller than data in frame %d",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 total_data_size, data_in_this_rsp);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> >> - =C2=A0 =C2=A0 }
> >> -
> >> - =C2=A0 =C2=A0 remaining =3D total_data_size - data_in_this_rsp;
> >> -
> >> - =C2=A0 =C2=A0 cFYI(1, "missing %d bytes from transact2, check ne=
xt response",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 remaining);
> >> - =C2=A0 =C2=A0 if (total_data_size > CIFSMaxBufSize) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "TotalDataSi=
ze %d is over maximum buffer %d",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 total_data_size, CIFSMaxBufSize);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> >> - =C2=A0 =C2=A0 }
> >> - =C2=A0 =C2=A0 return remaining;
> >> -}
> >> -
> >> -static int coalesce_t2(char *second_buf, struct smb_hdr *target_h=
dr)
> >> -{
> >> - =C2=A0 =C2=A0 struct smb_t2_rsp *pSMBs =3D (struct smb_t2_rsp *)=
second_buf;
> >> - =C2=A0 =C2=A0 struct smb_t2_rsp *pSMBt =C2=A0=3D (struct smb_t2_=
rsp *)target_hdr;
> >> - =C2=A0 =C2=A0 char *data_area_of_tgt;
> >> - =C2=A0 =C2=A0 char *data_area_of_src;
> >> - =C2=A0 =C2=A0 int remaining;
> >> - =C2=A0 =C2=A0 unsigned int byte_count, total_in_tgt;
> >> - =C2=A0 =C2=A0 __u16 tgt_total_cnt, src_total_cnt, total_in_src;
> >> -
> >> - =C2=A0 =C2=A0 src_total_cnt =3D get_unaligned_le16(&pSMBs->t2_rs=
p.TotalDataCount);
> >> - =C2=A0 =C2=A0 tgt_total_cnt =3D get_unaligned_le16(&pSMBt->t2_rs=
p.TotalDataCount);
> >> -
> >> - =C2=A0 =C2=A0 if (tgt_total_cnt !=3D src_total_cnt)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "total data co=
unt of primary and secondary t2 differ "
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "source=3D%hu target=3D%hu", src_total_cnt, tgt_total_cnt);
> >> -
> >> - =C2=A0 =C2=A0 total_in_tgt =3D get_unaligned_le16(&pSMBt->t2_rsp=
=2EDataCount);
> >> -
> >> - =C2=A0 =C2=A0 remaining =3D tgt_total_cnt - total_in_tgt;
> >> -
> >> - =C2=A0 =C2=A0 if (remaining < 0) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Server sent t=
oo much data. tgt_total_cnt=3D%hu "
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "total_in_tgt=3D%hu", tgt_total_cnt, total_in_tgt);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EPROTO;
> >> - =C2=A0 =C2=A0 }
> >> -
> >> - =C2=A0 =C2=A0 if (remaining =3D=3D 0) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* nothing to do, igno=
re */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "no more data =
remains");
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> - =C2=A0 =C2=A0 }
> >> -
> >> - =C2=A0 =C2=A0 total_in_src =3D get_unaligned_le16(&pSMBs->t2_rsp=
=2EDataCount);
> >> - =C2=A0 =C2=A0 if (remaining < total_in_src)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "transact2 2nd=
 response contains too much data");
> >> -
> >> - =C2=A0 =C2=A0 /* find end of first SMB data area */
> >> - =C2=A0 =C2=A0 data_area_of_tgt =3D (char *)&pSMBt->hdr.Protocol =
+
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 get_unaligned_le16(&pSMBt->t2_rsp.DataO=
ffset);
> >> -
> >> - =C2=A0 =C2=A0 /* validate target area */
> >> - =C2=A0 =C2=A0 data_area_of_src =3D (char *)&pSMBs->hdr.Protocol =
+
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 get_unaligned_le16(&pSMBs->t2_rsp.DataO=
ffset);
> >> -
> >> - =C2=A0 =C2=A0 data_area_of_tgt +=3D total_in_tgt;
> >> -
> >> - =C2=A0 =C2=A0 total_in_tgt +=3D total_in_src;
> >> - =C2=A0 =C2=A0 /* is the result too big for the field? */
> >> - =C2=A0 =C2=A0 if (total_in_tgt > USHRT_MAX) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "coalesced Dat=
aCount too large (%u)", total_in_tgt);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EPROTO;
> >> - =C2=A0 =C2=A0 }
> >> - =C2=A0 =C2=A0 put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.Da=
taCount);
> >> -
> >> - =C2=A0 =C2=A0 /* fix up the BCC */
> >> - =C2=A0 =C2=A0 byte_count =3D get_bcc(target_hdr);
> >> - =C2=A0 =C2=A0 byte_count +=3D total_in_src;
> >> - =C2=A0 =C2=A0 /* is the result too big for the field? */
> >> - =C2=A0 =C2=A0 if (byte_count > USHRT_MAX) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "coalesced BCC=
 too large (%u)", byte_count);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EPROTO;
> >> - =C2=A0 =C2=A0 }
> >> - =C2=A0 =C2=A0 put_bcc(byte_count, target_hdr);
> >> -
> >> - =C2=A0 =C2=A0 byte_count =3D be32_to_cpu(target_hdr->smb_buf_len=
gth);
> >> - =C2=A0 =C2=A0 byte_count +=3D total_in_src;
> >> - =C2=A0 =C2=A0 /* don't allow buffer to overflow */
> >> - =C2=A0 =C2=A0 if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZ=
E - 4) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "coalesced BCC=
 exceeds buffer size (%u)", byte_count);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOBUFS;
> >> - =C2=A0 =C2=A0 }
> >> - =C2=A0 =C2=A0 target_hdr->smb_buf_length =3D cpu_to_be32(byte_co=
unt);
> >> -
> >> - =C2=A0 =C2=A0 /* copy second buffer into end of first buffer */
> >> - =C2=A0 =C2=A0 memcpy(data_area_of_tgt, data_area_of_src, total_i=
n_src);
> >> -
> >> - =C2=A0 =C2=A0 if (remaining !=3D total_in_src) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* more responses to g=
o */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "waiting for m=
ore secondary responses");
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> >> - =C2=A0 =C2=A0 }
> >> -
> >> - =C2=A0 =C2=A0 /* we are done */
> >> - =C2=A0 =C2=A0 cFYI(1, "found the last secondary response");
> >> - =C2=A0 =C2=A0 return 0;
> >> -}
> >> -
> >> =C2=A0static void
> >> =C2=A0cifs_echo_request(struct work_struct *work)
> >> =C2=A0{
> >> @@ -803,29 +666,8 @@ static void
> >> =C2=A0handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *=
server,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0char *buf, int malformed)
> >> =C2=A0{
> >> - =C2=A0 =C2=A0 if (malformed =3D=3D 0 && check2ndT2(buf) > 0) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mid->multiRsp =3D true=
;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mid->resp_buf) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* merge response - fix up 1st*/
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 malformed =3D coalesce_t2(buf, mid->resp_buf);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (malformed > 0)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> >> -
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* All parts received or packet is malformed. */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 mid->multiEnd =3D true;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return dequeue_mid(mid, malformed);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!server->large_buf=
) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /*FIXME: switch to already allocated largebuf?*/
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cERROR(1, "1st trans2 resp needs bigbuf");
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* Have first buffer */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 mid->resp_buf =3D buf;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 mid->large_buf =3D true;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 server->bigbuf =3D NULL;
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 if (S_OP(server, check_trans2, false, mid, server,=
 buf, malformed))
> >
> > Blech, do you really think this makes the code clearer? I personall=
y
> > find this macro ugly, but I suppose it's a matter of taste...
> >
> > Looks fine otherwise, and I'm not concerned enough about the ugline=
ss
> > to NAK it on those grounds...
> >
> > Reviewed-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
>=20
> Thanks for the review!
>=20
> As for the macro itself. Instead of this:
>=20
> if (S_OP(server, check_trans2, false, mid, server, buf, malformed))
>         return;
>=20
> we will have:
>=20
> if (server->ops->check_trans2 && server->ops->check_trans2(mid,
> server, buf, malformed))
>         return;
>=20
> that looks bigger.
>=20

Sure, it's more verbose, but at least it's clear where each of the
arguments go...

> And for non-void functions:
>=20
> rc =3D server->ops->negotiate? server->ops->negotiate(server, xid, se=
s))
> : -ENOSYS;
>=20
> the macro reduces this place to
>=20
> rc =3D S_OP(server, negotiate, -ENOSYS, xid, ses);
>=20
> that also looks more compact.
>=20
> I am not sure that the name of the macro is ideal - suggestions are w=
elcome!
>=20

The name doesn't much matter to me, but clarity does...

Regardless though, since you're doing the work here I'm inclined to let
you decide on this point. If you find that clearer, then so be it. I
can live with it as long as it ultimately works...

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
