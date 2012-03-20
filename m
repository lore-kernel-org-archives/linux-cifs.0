From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 08/11] CIFS: Separate protocol-specific code from
 demultiplex code
Date: Tue, 20 Mar 2012 11:29:45 +0400
Message-ID: <CAKywueTxicF658ys1yBzC_95qw0v8R+6pxuhZ_zc+aRKyRLFdw@mail.gmail.com>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-9-git-send-email-piastry@etersoft.ru>
	<20120319154150.03713caf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120319154150.03713caf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

19 =CD=C1=D2=D4=C1 2012=9A=C7. 23:41 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Fri, 16 Mar 2012 18:09:31 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =9Afs/cifs/cifs_debug.c | =9A =9A5 ++-
>> =9Afs/cifs/cifs_debug.h | =9A =9A2 +-
>> =9Afs/cifs/cifsglob.h =9A | =9A =9A2 +-
>> =9Afs/cifs/cifsproto.h =9A| =9A =9A5 +--
>> =9Afs/cifs/connect.c =9A =9A| =9A 78 +++++++++++++++++++++++++++----=
-------------------
>> =9Afs/cifs/misc.c =9A =9A =9A | =9A =9A7 +++-
>> =9Afs/cifs/transport.c =9A| =9A =9A4 +-
>> =9A7 files changed, 56 insertions(+), 47 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
>> index 573b899..bcd0db7 100644
>> --- a/fs/cifs/cifs_debug.c
>> +++ b/fs/cifs/cifs_debug.c
>> @@ -58,15 +58,16 @@ cifs_dump_mem(char *label, void *data, int lengt=
h)
>> =9A}
>>
>> =9A#ifdef CONFIG_CIFS_DEBUG2
>> -void cifs_dump_detail(struct smb_hdr *smb)
>> +void cifs_dump_detail(void *buf)
>> =9A{
>> + =9A =9A struct smb_hdr *smb =3D (struct smb_hdr *)buf;
>> +
>> =9A =9A =9A cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid=
: %d Pid: %d",
>> =9A =9A =9A =9A =9A =9A =9A =9A smb->Command, smb->Status.CifsError,
>> =9A =9A =9A =9A =9A =9A =9A =9A smb->Flags, smb->Flags2, smb->Mid, s=
mb->Pid);
>> =9A =9A =9A cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
>> =9A}
>>
>> -
>> =9Avoid cifs_dump_mids(struct TCP_Server_Info *server)
>> =9A{
>> =9A =9A =9A struct list_head *tmp;
>> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
>> index 0a234c1..566e0ae 100644
>> --- a/fs/cifs/cifs_debug.h
>> +++ b/fs/cifs/cifs_debug.h
>> @@ -26,7 +26,7 @@
>> =9Avoid cifs_dump_mem(char *label, void *data, int length);
>> =9A#ifdef CONFIG_CIFS_DEBUG2
>> =9A#define DBG2 2
>> -void cifs_dump_detail(struct smb_hdr *);
>> +void cifs_dump_detail(void *);
>> =9Avoid cifs_dump_mids(struct TCP_Server_Info *);
>> =9A#else
>> =9A#define DBG2 0
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index c3c7d7c..34a897e 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -730,7 +730,7 @@ struct mid_q_entry {
>> =9A =9A =9A mid_receive_t *receive; /* call receive callback */
>> =9A =9A =9A mid_callback_t *callback; /* call completion callback */
>> =9A =9A =9A void *callback_data; =9A =9A =9A/* general purpose point=
er for callback */
>> - =9A =9A struct smb_hdr *resp_buf; =9A =9A =9A /* pointer to receiv=
ed SMB header */
>> + =9A =9A void *resp_buf; =9A =9A =9A =9A /* pointer to received SMB=
 header */
>> =9A =9A =9A int midState; =9A /* wish this were enum but can not pas=
s to wait_event */
>> =9A =9A =9A __u8 command; =9A /* smb command code */
>> =9A =9A =9A bool largeBuf:1; =9A =9A =9A =9A/* if valid response, is=
 pointer to large buf */
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 2d506e3..15c9b59 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -91,9 +91,8 @@ extern int SendReceiveBlockingLock(const unsigned =
int xid,
>> =9Aextern void cifs_add_credits(struct TCP_Server_Info *server,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9Aconst unsigne=
d int add);
>> =9Aextern void cifs_set_credits(struct TCP_Server_Info *server, cons=
t int val);
>> -extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int le=
ngth);
>> -extern bool is_valid_oplock_break(struct smb_hdr *smb,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A struct=
 TCP_Server_Info *);
>> +extern int checkSMB(char *buf, unsigned int length);
>> +extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *)=
;
>> =9Aextern bool backup_cred(struct cifs_sb_info *);
>> =9Aextern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 =
eof);
>> =9Aextern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t o=
ffset,
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 4156351..76cffc9 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -183,8 +183,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
>> =9A =9A =9A =9A =9A =9A =9A -EINVAL =3D invalid transact2
>>
>> =9A */
>> -static int check2ndT2(struct smb_hdr *pSMB)
>> +static int check2ndT2(char *buf)
>> =9A{
>> + =9A =9A struct smb_hdr *pSMB =3D (struct smb_hdr *)buf;
>> =9A =9A =9A struct smb_t2_rsp *pSMBt;
>> =9A =9A =9A int remaining;
>> =9A =9A =9A __u16 total_data_size, data_in_this_rsp;
>> @@ -224,10 +225,10 @@ static int check2ndT2(struct smb_hdr *pSMB)
>> =9A =9A =9A return remaining;
>> =9A}
>>
>> -static int coalesce_t2(struct smb_hdr *psecond, struct smb_hdr *pTa=
rgetSMB)
>> +static int coalesce_t2(char *second_buf, struct smb_hdr *target_hdr=
)
>> =9A{
>> - =9A =9A struct smb_t2_rsp *pSMBs =3D (struct smb_t2_rsp *)psecond;
>> - =9A =9A struct smb_t2_rsp *pSMBt =9A=3D (struct smb_t2_rsp *)pTarg=
etSMB;
>> + =9A =9A struct smb_t2_rsp *pSMBs =3D (struct smb_t2_rsp *)second_b=
uf;
>> + =9A =9A struct smb_t2_rsp *pSMBt =9A=3D (struct smb_t2_rsp *)targe=
t_hdr;
>> =9A =9A =9A char *data_area_of_tgt;
>> =9A =9A =9A char *data_area_of_src;
>> =9A =9A =9A int remaining;
>> @@ -280,23 +281,23 @@ static int coalesce_t2(struct smb_hdr *psecond=
, struct smb_hdr *pTargetSMB)
>> =9A =9A =9A put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.DataCoun=
t);
>>
>> =9A =9A =9A /* fix up the BCC */
>> - =9A =9A byte_count =3D get_bcc(pTargetSMB);
>> + =9A =9A byte_count =3D get_bcc(target_hdr);
>> =9A =9A =9A byte_count +=3D total_in_src;
>> =9A =9A =9A /* is the result too big for the field? */
>> =9A =9A =9A if (byte_count > USHRT_MAX) {
>> =9A =9A =9A =9A =9A =9A =9A cFYI(1, "coalesced BCC too large (%u)", =
byte_count);
>> =9A =9A =9A =9A =9A =9A =9A return -EPROTO;
>> =9A =9A =9A }
>> - =9A =9A put_bcc(byte_count, pTargetSMB);
>> + =9A =9A put_bcc(byte_count, target_hdr);
>>
>> - =9A =9A byte_count =3D be32_to_cpu(pTargetSMB->smb_buf_length);
>> + =9A =9A byte_count =3D be32_to_cpu(target_hdr->smb_buf_length);
>> =9A =9A =9A byte_count +=3D total_in_src;
>> =9A =9A =9A /* don't allow buffer to overflow */
>> =9A =9A =9A if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4)=
 {
>> =9A =9A =9A =9A =9A =9A =9A cFYI(1, "coalesced BCC exceeds buffer si=
ze (%u)", byte_count);
>> =9A =9A =9A =9A =9A =9A =9A return -ENOBUFS;
>> =9A =9A =9A }
>> - =9A =9A pTargetSMB->smb_buf_length =3D cpu_to_be32(byte_count);
>> + =9A =9A target_hdr->smb_buf_length =3D cpu_to_be32(byte_count);
>>
>> =9A =9A =9A /* copy second buffer into end of first buffer */
>> =9A =9A =9A memcpy(data_area_of_tgt, data_area_of_src, total_in_src)=
;
>> @@ -337,6 +338,18 @@ requeue_echo:
>> =9A =9A =9A queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECH=
O_INTERVAL);
>> =9A}
>>
>> +static inline size_t
>> +header_size(void)
>> +{
>> + =9A =9A return sizeof(struct smb_hdr);
>> +}
>> +
>
> I guess that eventually things like this will have a smb2 variant, an=
d
> you'll bundle them all up into a set of "transport ops" or something?

Now I modify these functions for SMB2 code to this variant:

static inline size_t
header_size(server)
{
#ifdef CONFIG_CIFS_SMB2
        if (server->is_smb2)
                 return sizeof(struct smb2_hdr);
#endif
        return sizeof(struct smb_hdr);
}

But having smth like:

struct TCP_Server_Info {
=2E..
struct cifs_transport_ops *t_ops;
=2E..
}

and then using server->t_ops->header_size() looks better.

I also have an idea to have such ops structures for cifsFileInfo and
cifsInodeInfo pointers. I think this let us make the code cleaner.
(Now I use ifdefs and callbacks to share the code between cifs and
smb2). Thoughts?

>
>> +static inline size_t
>> +max_header_size(void)
>> +{
>> + =9A =9A return MAX_CIFS_HDR_SIZE;
>> +}
>> +
>> =9Astatic bool
>> =9Aallocate_buffers(struct TCP_Server_Info *server)
>> =9A{
>> @@ -350,7 +363,7 @@ allocate_buffers(struct TCP_Server_Info *server)
>> =9A =9A =9A =9A =9A =9A =9A }
>> =9A =9A =9A } else if (server->large_buf) {
>> =9A =9A =9A =9A =9A =9A =9A /* we are reusing a dirty large buf, cle=
ar its start */
>> - =9A =9A =9A =9A =9A =9A memset(server->bigbuf, 0, sizeof(struct sm=
b_hdr));
>> + =9A =9A =9A =9A =9A =9A memset(server->bigbuf, 0, header_size());
>> =9A =9A =9A }
>>
>> =9A =9A =9A if (!server->smallbuf) {
>> @@ -364,7 +377,7 @@ allocate_buffers(struct TCP_Server_Info *server)
>> =9A =9A =9A =9A =9A =9A =9A /* beginning of smb buffer is cleared in=
 our buf_get */
>> =9A =9A =9A } else {
>> =9A =9A =9A =9A =9A =9A =9A /* if existing small buf clear beginning=
 */
>> - =9A =9A =9A =9A =9A =9A memset(server->smallbuf, 0, sizeof(struct =
smb_hdr));
>> + =9A =9A =9A =9A =9A =9A memset(server->smallbuf, 0, header_size())=
;
>> =9A =9A =9A }
>>
>> =9A =9A =9A return true;
>> @@ -555,8 +568,9 @@ is_smb_response(struct TCP_Server_Info *server, =
unsigned char type)
>> =9A}
>>
>> =9Astatic struct mid_q_entry *
>> -find_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
>> +find_mid(struct TCP_Server_Info *server, char *buffer)
>> =9A{
>> + =9A =9A struct smb_hdr *buf =3D (struct smb_hdr *)buffer;
>> =9A =9A =9A struct mid_q_entry *mid;
>>
>> =9A =9A =9A spin_lock(&GlobalMid_Lock);
>> @@ -589,7 +603,7 @@ dequeue_mid(struct mid_q_entry *mid, bool malfor=
med)
>>
>> =9Astatic void
>> =9Ahandle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve=
r,
>> - =9A =9A =9A =9Astruct smb_hdr *buf, int malformed)
>> + =9A =9A =9A =9Achar *buf, int malformed)
>> =9A{
>> =9A =9A =9A if (malformed =3D=3D 0 && check2ndT2(buf) > 0) {
>> =9A =9A =9A =9A =9A =9A =9A mid->multiRsp =3D true;
>> @@ -720,11 +734,10 @@ standard_receive3(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
>> =9A{
>> =9A =9A =9A int length;
>> =9A =9A =9A char *buf =3D server->smallbuf;
>> - =9A =9A struct smb_hdr *smb_buffer =3D (struct smb_hdr *)buf;
>> - =9A =9A unsigned int pdu_length =3D be32_to_cpu(smb_buffer->smb_bu=
f_length);
>> + =9A =9A unsigned int pdu_length =3D get_rfc1002_length(buf);
>>
>> =9A =9A =9A /* make sure this will fit in a large buffer */
>> - =9A =9A if (pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
>> + =9A =9A if (pdu_length > CIFSMaxBufSize + max_header_size() - 4) {
>> =9A =9A =9A =9A =9A =9A =9A cERROR(1, "SMB response too long (%u byt=
es)",
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A pdu_length);
>> =9A =9A =9A =9A =9A =9A =9A cifs_reconnect(server);
>> @@ -735,20 +748,18 @@ standard_receive3(struct TCP_Server_Info *serv=
er, struct mid_q_entry *mid)
>> =9A =9A =9A /* switch to large buffer if too big for a small one */
>> =9A =9A =9A if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE - 4) {
>> =9A =9A =9A =9A =9A =9A =9A server->large_buf =3D true;
>> - =9A =9A =9A =9A =9A =9A memcpy(server->bigbuf, server->smallbuf, s=
erver->total_read);
>> + =9A =9A =9A =9A =9A =9A memcpy(server->bigbuf, buf, server->total_=
read);
>> =9A =9A =9A =9A =9A =9A =9A buf =3D server->bigbuf;
>> - =9A =9A =9A =9A =9A =9A smb_buffer =3D (struct smb_hdr *)buf;
>> =9A =9A =9A }
>>
>> =9A =9A =9A /* now read the rest */
>> - =9A =9A length =3D cifs_read_from_socket(server,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A buf + sizeof(struct sm=
b_hdr) - 1,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A pdu_length - sizeof(st=
ruct smb_hdr) + 1 + 4);
>> + =9A =9A length =3D cifs_read_from_socket(server, buf + header_size=
() - 1,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9Apdu_length - header_size() + 1 + 4);
>> =9A =9A =9A if (length < 0)
>> =9A =9A =9A =9A =9A =9A =9A return length;
>> =9A =9A =9A server->total_read +=3D length;
>>
>> - =9A =9A dump_smb(smb_buffer, server->total_read);
>> + =9A =9A dump_smb(buf, server->total_read);
>>
>> =9A =9A =9A /*
>> =9A =9A =9A =9A* We know that we received enough to get to the MID a=
s we
>> @@ -759,7 +770,7 @@ standard_receive3(struct TCP_Server_Info *server=
, struct mid_q_entry *mid)
>> =9A =9A =9A =9A* 48 bytes is enough to display the header and a litt=
le bit
>> =9A =9A =9A =9A* into the payload for debugging purposes.
>> =9A =9A =9A =9A*/
>> - =9A =9A length =3D checkSMB(smb_buffer, smb_buffer->Mid, server->t=
otal_read);
>> + =9A =9A length =3D checkSMB(buf, server->total_read);
>> =9A =9A =9A if (length !=3D 0)
>> =9A =9A =9A =9A =9A =9A =9A cifs_dump_mem("Bad SMB: ", buf,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A min_t(unsigned int, serv=
er->total_read, 48));
>> @@ -767,7 +778,7 @@ standard_receive3(struct TCP_Server_Info *server=
, struct mid_q_entry *mid)
>> =9A =9A =9A if (!mid)
>> =9A =9A =9A =9A =9A =9A =9A return length;
>>
>> - =9A =9A handle_mid(mid, server, smb_buffer, length);
>> + =9A =9A handle_mid(mid, server, buf, length);
>> =9A =9A =9A return 0;
>> =9A}
>>
>> @@ -778,7 +789,6 @@ cifs_demultiplex_thread(void *p)
>> =9A =9A =9A struct TCP_Server_Info *server =3D p;
>> =9A =9A =9A unsigned int pdu_length;
>> =9A =9A =9A char *buf =3D NULL;
>> - =9A =9A struct smb_hdr *smb_buffer =3D NULL;
>> =9A =9A =9A struct task_struct *task_to_wake =3D NULL;
>> =9A =9A =9A struct mid_q_entry *mid_entry;
>>
>> @@ -799,7 +809,6 @@ cifs_demultiplex_thread(void *p)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue;
>>
>> =9A =9A =9A =9A =9A =9A =9A server->large_buf =3D false;
>> - =9A =9A =9A =9A =9A =9A smb_buffer =3D (struct smb_hdr *)server->s=
mallbuf;
>> =9A =9A =9A =9A =9A =9A =9A buf =3D server->smallbuf;
>> =9A =9A =9A =9A =9A =9A =9A pdu_length =3D 4; /* enough to get RFC10=
01 header */
>>
>> @@ -812,14 +821,14 @@ cifs_demultiplex_thread(void *p)
>> =9A =9A =9A =9A =9A =9A =9A =9A* The right amount was read from sock=
et - 4 bytes,
>> =9A =9A =9A =9A =9A =9A =9A =9A* so we can now interpret the length =
field.
>> =9A =9A =9A =9A =9A =9A =9A =9A*/
>> - =9A =9A =9A =9A =9A =9A pdu_length =3D be32_to_cpu(smb_buffer->smb=
_buf_length);
>> + =9A =9A =9A =9A =9A =9A pdu_length =3D get_rfc1002_length(buf);
>>
>> =9A =9A =9A =9A =9A =9A =9A cFYI(1, "RFC1002 header 0x%x", pdu_lengt=
h);
>> =9A =9A =9A =9A =9A =9A =9A if (!is_smb_response(server, buf[0]))
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue;
>>
>> =9A =9A =9A =9A =9A =9A =9A /* make sure we have enough to get to th=
e MID */
>> - =9A =9A =9A =9A =9A =9A if (pdu_length < sizeof(struct smb_hdr) - =
1 - 4) {
>> + =9A =9A =9A =9A =9A =9A if (pdu_length < header_size() - 1 - 4) {
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cERROR(1, "SMB response =
too short (%u bytes)",
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A pdu_leng=
th);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_reconnect(server);
>> @@ -829,12 +838,12 @@ cifs_demultiplex_thread(void *p)
>>
>> =9A =9A =9A =9A =9A =9A =9A /* read down to the MID */
>> =9A =9A =9A =9A =9A =9A =9A length =3D cifs_read_from_socket(server,=
 buf + 4,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A sizeof(struct smb_hdr) - 1 - 4);
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A =9A =9A =9A =9Aheader_size() - 1 - 4);
>> =9A =9A =9A =9A =9A =9A =9A if (length < 0)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue;
>> =9A =9A =9A =9A =9A =9A =9A server->total_read +=3D length;
>>
>> - =9A =9A =9A =9A =9A =9A mid_entry =3D find_mid(server, smb_buffer)=
;
>> + =9A =9A =9A =9A =9A =9A mid_entry =3D find_mid(server, buf);
>>
>> =9A =9A =9A =9A =9A =9A =9A if (!mid_entry || !mid_entry->receive)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A length =3D standard_rece=
ive3(server, mid_entry);
>> @@ -844,22 +853,19 @@ cifs_demultiplex_thread(void *p)
>> =9A =9A =9A =9A =9A =9A =9A if (length < 0)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A continue;
>>
>> - =9A =9A =9A =9A =9A =9A if (server->large_buf) {
>> + =9A =9A =9A =9A =9A =9A if (server->large_buf)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A buf =3D server->bigbuf;
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A smb_buffer =3D (struct smb=
_hdr *)buf;
>> - =9A =9A =9A =9A =9A =9A }
>>
>> =9A =9A =9A =9A =9A =9A =9A server->lstrp =3D jiffies;
>> =9A =9A =9A =9A =9A =9A =9A if (mid_entry !=3D NULL) {
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (!mid_entry->multiRsp=
 || mid_entry->multiEnd)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A mid_entr=
y->callback(mid_entry);
>> - =9A =9A =9A =9A =9A =9A } else if (!is_valid_oplock_break(smb_buff=
er, server)) {
>> + =9A =9A =9A =9A =9A =9A } else if (!is_valid_oplock_break(buf, ser=
ver)) {
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cERROR(1, "No task to wa=
ke, unknown frame received! "
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A"=
NumMids %d", atomic_read(&midCount));
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_dump_mem("Received Da=
ta is: ", buf,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 sizeof(struct smb_hdr));
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_dump_mem("Received Da=
ta is: ", buf, header_size());
>> =9A#ifdef CONFIG_CIFS_DEBUG2
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_dump_detail(smb_buffe=
r);
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_dump_detail(buf);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_dump_mids(server);
>> =9A#endif /* CIFS_DEBUG2 */
>>
>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>> index 1578617..88459d0 100644
>> --- a/fs/cifs/misc.c
>> +++ b/fs/cifs/misc.c
>> @@ -420,8 +420,10 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
>> =9A}
>>
>> =9Aint
>> -checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int total_read)
>> +checkSMB(char *buf, unsigned int total_read)
>> =9A{
>> + =9A =9A struct smb_hdr *smb =3D (struct smb_hdr *)buf;
>> + =9A =9A __u16 mid =3D smb->Mid;
>> =9A =9A =9A __u32 rfclen =3D be32_to_cpu(smb->smb_buf_length);
>> =9A =9A =9A __u32 clc_len; =9A/* calculated length */
>> =9A =9A =9A cFYI(0, "checkSMB Length: 0x%x, smb_buf_length: 0x%x",
>> @@ -502,8 +504,9 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigne=
d int total_read)
>> =9A}
>>
>> =9Abool
>> -is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *=
srv)
>> +is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
>> =9A{
>> + =9A =9A struct smb_hdr *buf =3D (struct smb_hdr *)buffer;
>> =9A =9A =9A struct smb_com_lock_req *pSMB =3D (struct smb_com_lock_r=
eq *)buf;
>> =9A =9A =9A struct list_head *tmp, *tmp1, *tmp2;
>> =9A =9A =9A struct cifs_ses *ses;
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 7f63c44..d4c01b9 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -785,7 +785,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =9A =9A =9A =9A =9A =9A =9A goto out;
>> =9A =9A =9A }
>>
>> - =9A =9A *pbytes_returned =3D be32_to_cpu(midQ->resp_buf->smb_buf_l=
ength);
>> + =9A =9A *pbytes_returned =3D get_rfc1002_length(midQ->resp_buf);
>> =9A =9A =9A memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
>> =9A =9A =9A rc =3D cifs_check_receive(midQ, ses->server, 0);
>> =9Aout:
>> @@ -953,7 +953,7 @@ SendReceiveBlockingLock(const unsigned int xid, =
struct cifs_tcon *tcon,
>> =9A =9A =9A =9A =9A =9A =9A goto out;
>> =9A =9A =9A }
>>
>> - =9A =9A *pbytes_returned =3D be32_to_cpu(midQ->resp_buf->smb_buf_l=
ength);
>> + =9A =9A *pbytes_returned =3D get_rfc1002_length(midQ->resp_buf);
>> =9A =9A =9A memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
>> =9A =9A =9A rc =3D cifs_check_receive(midQ, ses->server, 0);
>> =9Aout:
>
> Either way, it looks reasonable...
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =9Ahttp://vger.kernel.org/majordomo-info.html



--=20
Best regards,
Pavel Shilovsky.
