From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 3/7] CIFS: Move trans2 processing to ops struct
Date: Wed, 30 May 2012 20:38:15 +0400
Message-ID: <CAKywueQzkZRyyhNpkQn8V8YHf9AuK+dM3t_zZRWs1cJo7vP61A@mail.gmail.com>
References: <1338308344-29149-1-git-send-email-pshilovsky@samba.org>
	<1338308344-29149-4-git-send-email-pshilovsky@samba.org>
	<20120530113523.6b76177e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120530113523.6b76177e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/30 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Tue, 29 May 2012 20:19:00 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h | =A0 =A03 +
>> =A0fs/cifs/connect.c =A0| =A0160 +----------------------------------=
--------------
>> =A0fs/cifs/smb1ops.c =A0| =A0170 +++++++++++++++++++++++++++++++++++=
+++++++++++++++++
>> =A03 files changed, 174 insertions(+), 159 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index a660577..3b8828b 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -187,6 +187,9 @@ struct smb_version_operations {
>> =A0 =A0 =A0 /* verify the message */
>> =A0 =A0 =A0 int (*check_message)(char *, unsigned int);
>> =A0 =A0 =A0 bool (*is_oplock_break)(char *, struct TCP_Server_Info *=
);
>> + =A0 =A0 /* process transaction2 response */
>> + =A0 =A0 bool (*check_trans2)(struct mid_q_entry *, struct TCP_Serv=
er_Info *,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *, int);
>> =A0};
>>
>> =A0struct smb_version_values {
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 9362f90..dc96835 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -394,143 +394,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -/*
>> - =A0 =A0 return codes:
>> - =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 not a transact2, or all data=
 present
>> - =A0 =A0 =A0 =A0 =A0 =A0 >0 =A0 =A0 =A0transact2 with that much dat=
a missing
>> - =A0 =A0 =A0 =A0 =A0 =A0 -EINVAL =3D invalid transact2
>> -
>> - */
>> -static int check2ndT2(char *buf)
>> -{
>> - =A0 =A0 struct smb_hdr *pSMB =3D (struct smb_hdr *)buf;
>> - =A0 =A0 struct smb_t2_rsp *pSMBt;
>> - =A0 =A0 int remaining;
>> - =A0 =A0 __u16 total_data_size, data_in_this_rsp;
>> -
>> - =A0 =A0 if (pSMB->Command !=3D SMB_COM_TRANSACTION2)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> -
>> - =A0 =A0 /* check for plausible wct, bcc and t2 data and parm sizes=
 */
>> - =A0 =A0 /* check for parm and data offset going beyond end of smb =
*/
>> - =A0 =A0 if (pSMB->WordCount !=3D 10) { /* coalesce_t2 depends on t=
his */
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "invalid transact2 word count");
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 pSMBt =3D (struct smb_t2_rsp *)pSMB;
>> -
>> - =A0 =A0 total_data_size =3D get_unaligned_le16(&pSMBt->t2_rsp.Tota=
lDataCount);
>> - =A0 =A0 data_in_this_rsp =3D get_unaligned_le16(&pSMBt->t2_rsp.Dat=
aCount);
>> -
>> - =A0 =A0 if (total_data_size =3D=3D data_in_this_rsp)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> - =A0 =A0 else if (total_data_size < data_in_this_rsp) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "total data %d smaller than data i=
n frame %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_data_size, data_in_t=
his_rsp);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 remaining =3D total_data_size - data_in_this_rsp;
>> -
>> - =A0 =A0 cFYI(1, "missing %d bytes from transact2, check next respo=
nse",
>> - =A0 =A0 =A0 =A0 =A0 =A0 remaining);
>> - =A0 =A0 if (total_data_size > CIFSMaxBufSize) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "TotalDataSize %d is over maximu=
m buffer %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_data_size, CIFSMaxBu=
fSize);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> - =A0 =A0 }
>> - =A0 =A0 return remaining;
>> -}
>> -
>> -static int coalesce_t2(char *second_buf, struct smb_hdr *target_hdr=
)
>> -{
>> - =A0 =A0 struct smb_t2_rsp *pSMBs =3D (struct smb_t2_rsp *)second_b=
uf;
>> - =A0 =A0 struct smb_t2_rsp *pSMBt =A0=3D (struct smb_t2_rsp *)targe=
t_hdr;
>> - =A0 =A0 char *data_area_of_tgt;
>> - =A0 =A0 char *data_area_of_src;
>> - =A0 =A0 int remaining;
>> - =A0 =A0 unsigned int byte_count, total_in_tgt;
>> - =A0 =A0 __u16 tgt_total_cnt, src_total_cnt, total_in_src;
>> -
>> - =A0 =A0 src_total_cnt =3D get_unaligned_le16(&pSMBs->t2_rsp.TotalD=
ataCount);
>> - =A0 =A0 tgt_total_cnt =3D get_unaligned_le16(&pSMBt->t2_rsp.TotalD=
ataCount);
>> -
>> - =A0 =A0 if (tgt_total_cnt !=3D src_total_cnt)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "total data count of primary and s=
econdary t2 differ "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "source=3D%hu target=3D%hu=
", src_total_cnt, tgt_total_cnt);
>> -
>> - =A0 =A0 total_in_tgt =3D get_unaligned_le16(&pSMBt->t2_rsp.DataCou=
nt);
>> -
>> - =A0 =A0 remaining =3D tgt_total_cnt - total_in_tgt;
>> -
>> - =A0 =A0 if (remaining < 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Server sent too much data. tgt_to=
tal_cnt=3D%hu "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "total_in_tgt=3D%hu", tgt_=
total_cnt, total_in_tgt);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EPROTO;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 if (remaining =3D=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* nothing to do, ignore */
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "no more data remains");
>> - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 total_in_src =3D get_unaligned_le16(&pSMBs->t2_rsp.DataCou=
nt);
>> - =A0 =A0 if (remaining < total_in_src)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "transact2 2nd response contains t=
oo much data");
>> -
>> - =A0 =A0 /* find end of first SMB data area */
>> - =A0 =A0 data_area_of_tgt =3D (char *)&pSMBt->hdr.Protocol +
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_unalig=
ned_le16(&pSMBt->t2_rsp.DataOffset);
>> -
>> - =A0 =A0 /* validate target area */
>> - =A0 =A0 data_area_of_src =3D (char *)&pSMBs->hdr.Protocol +
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_unalig=
ned_le16(&pSMBs->t2_rsp.DataOffset);
>> -
>> - =A0 =A0 data_area_of_tgt +=3D total_in_tgt;
>> -
>> - =A0 =A0 total_in_tgt +=3D total_in_src;
>> - =A0 =A0 /* is the result too big for the field? */
>> - =A0 =A0 if (total_in_tgt > USHRT_MAX) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "coalesced DataCount too large (%u=
)", total_in_tgt);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EPROTO;
>> - =A0 =A0 }
>> - =A0 =A0 put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.DataCount)=
;
>> -
>> - =A0 =A0 /* fix up the BCC */
>> - =A0 =A0 byte_count =3D get_bcc(target_hdr);
>> - =A0 =A0 byte_count +=3D total_in_src;
>> - =A0 =A0 /* is the result too big for the field? */
>> - =A0 =A0 if (byte_count > USHRT_MAX) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "coalesced BCC too large (%u)", by=
te_count);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -EPROTO;
>> - =A0 =A0 }
>> - =A0 =A0 put_bcc(byte_count, target_hdr);
>> -
>> - =A0 =A0 byte_count =3D be32_to_cpu(target_hdr->smb_buf_length);
>> - =A0 =A0 byte_count +=3D total_in_src;
>> - =A0 =A0 /* don't allow buffer to overflow */
>> - =A0 =A0 if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "coalesced BCC exceeds buffer size=
 (%u)", byte_count);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOBUFS;
>> - =A0 =A0 }
>> - =A0 =A0 target_hdr->smb_buf_length =3D cpu_to_be32(byte_count);
>> -
>> - =A0 =A0 /* copy second buffer into end of first buffer */
>> - =A0 =A0 memcpy(data_area_of_tgt, data_area_of_src, total_in_src);
>> -
>> - =A0 =A0 if (remaining !=3D total_in_src) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* more responses to go */
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "waiting for more secondary respon=
ses");
>> - =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 /* we are done */
>> - =A0 =A0 cFYI(1, "found the last secondary response");
>> - =A0 =A0 return 0;
>> -}
>> -
>> =A0static void
>> =A0cifs_echo_request(struct work_struct *work)
>> =A0{
>> @@ -803,29 +666,8 @@ static void
>> =A0handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve=
r,
>> =A0 =A0 =A0 =A0 =A0char *buf, int malformed)
>> =A0{
>> - =A0 =A0 if (malformed =3D=3D 0 && check2ndT2(buf) > 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 mid->multiRsp =3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (mid->resp_buf) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* merge response - fix up=
 1st*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 malformed =3D coalesce_t2(=
buf, mid->resp_buf);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (malformed > 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* All parts received or p=
acket is malformed. */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->multiEnd =3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return dequeue_mid(mid, ma=
lformed);
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (!server->large_buf) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*FIXME: switch to already=
 allocated largebuf?*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "1st trans2 resp=
 needs bigbuf");
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Have first buffer */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->resp_buf =3D buf;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->large_buf =3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->bigbuf =3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 if (S_OP(server, check_trans2, false, mid, server, buf, ma=
lformed))
>
> Blech, do you really think this makes the code clearer? I personally
> find this macro ugly, but I suppose it's a matter of taste...
>
> Looks fine otherwise, and I'm not concerned enough about the ugliness
> to NAK it on those grounds...
>
> Reviewed-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>

Thanks for the review!

As for the macro itself. Instead of this:

if (S_OP(server, check_trans2, false, mid, server, buf, malformed))
        return;

we will have:

if (server->ops->check_trans2 && server->ops->check_trans2(mid,
server, buf, malformed))
        return;

that looks bigger.

And for non-void functions:

rc =3D server->ops->negotiate? server->ops->negotiate(server, xid, ses)=
)
: -ENOSYS;

the macro reduces this place to

rc =3D S_OP(server, negotiate, -ENOSYS, xid, ses);

that also looks more compact.

I am not sure that the name of the macro is ideal - suggestions are wel=
come!

--=20
Best regards,
Pavel Shilovsky.
