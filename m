From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Simplify cifs_demultiplex_thread
Date: Thu, 9 Jun 2011 16:10:58 +0400
Message-ID: <BANLkTi=+pi_b=DdO13YGpkOrXEvGfbcvtA@mail.gmail.com>
References: <1307609933-5632-1-git-send-email-piastryyy@gmail.com>
	<20110609075411.040bf5d1@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110609075411.040bf5d1-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/6/9 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, =A09 Jun 2011 12:58:52 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Move several code blocks to separate functions:
>> 1) buffer allocations,
>> 2) rfc1002 header check,
>> 3) read whole smb message from socket,
>> 4) find mid owner.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifs_debug.c | =A0 =A01 -
>> =A0fs/cifs/connect.c =A0 =A0| =A0440 ++++++++++++++++++++++++++++---=
-------------------
>> =A02 files changed, 247 insertions(+), 194 deletions(-)
>>
>
> Nice. This is long overdue.
>
> That said, speaking from the experience of having to chase down subtl=
e
> bugs in this code before, I think this would be best done as a set of
> patches so that we can potentially bisect in case this breaks
> something. Maybe break out each function in a separate patch?
>
> The main reason that I've not done this before is that the code doesn=
't
> lend itself well to separate functions. You've "solved" that here wit=
h a
> lot of pointer passing. That breaks up the code into separate functio=
ns
> but doesn't really clean up the code. So let's consider this a good
> starting point, but more work is really needed here.
>
>> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
>> index 2fe3cf1..c4fc68a 100644
>> --- a/fs/cifs/cifs_debug.c
>> +++ b/fs/cifs/cifs_debug.c
>> @@ -66,7 +66,6 @@ void cifs_dump_detail(struct smb_hdr *smb)
>> =A0 =A0 =A0 cERROR(1, "smb buf %p len %d", smb, smbCalcSize(smb));
>> =A0}
>>
>> -
>> =A0void cifs_dump_mids(struct TCP_Server_Info *server)
>> =A0{
>> =A0 =A0 =A0 struct list_head *tmp;
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index fb31c2c..23addcb 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -317,24 +317,234 @@ requeue_echo:
>> =A0 =A0 =A0 queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECH=
O_INTERVAL);
>> =A0}
>>
>> +static struct mid_q_entry *
>> +find_cifs_owner(struct TCP_Server_Info *server, struct smb_hdr *buf=
,
>> + =A0 =A0 =A0 =A0 =A0 =A0 int *length, bool isLargeBuf, bool *isMult=
iRsp, char **pbigbuf)
>
> This function name seems a little odd. Would find_cifs_mid be better?
>
> Usually when I see a lot of pointer argument passing like this in a
> function, that's a red flag to me of a poor design. In this case,
> that's not really your fault as this code was already a mess. So, I'm
> ok with this in principle as it might make it easier to clean up this
> code later.
>
> While we're considering overhauling this code -- perhaps, long-term w=
e
> should move this to be a state machine?
>
>> +{
>> + =A0 =A0 struct list_head *tmp, *tmp2;
>> + =A0 =A0 struct mid_q_entry *mid_entry =3D NULL;
>> +
>> + =A0 =A0 spin_lock(&GlobalMid_Lock);
>> + =A0 =A0 list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entry(tmp, struct mid_q=
_entry, qhead);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->mid !=3D buf->Mid ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->midState !=3D MID_REQUE=
ST_SUBMITTED ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->command !=3D buf->Comma=
nd) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (*length =3D=3D 0 && check2ndT2(buf, se=
rver->maxBuf) > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We have a multipart tra=
nsact2 resp */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *isMultiRsp =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->resp_buf) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* merge r=
esponse - fix up 1st*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *length =3D=
 coalesce_t2(buf, mid_entry->resp_buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*lengt=
h > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 *length =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 mid_entry->multiRsp =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /* all parts received or
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* packet is malformed
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 mid_entry->multiEnd =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto multi_t2_fnd;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!isLar=
geBuf) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* FIXME: switch to already
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0* =A0 =A0 =A0 =A0allocated largebuf?
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cERROR(1, "1st trans2 resp "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 "needs bigbuf");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /* Have first buffer */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 mid_entry->resp_buf =3D buf;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 mid_entry->largeBuf =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 *pbigbuf =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->resp_buf =3D buf;
>> + =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->largeBuf =3D isLargeBuf;
>> +multi_t2_fnd:
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (*length =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->midState =3D MI=
D_RESPONSE_RECEIVED;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->midState =3D MI=
D_RESPONSE_MALFORMED;
>> +#ifdef CONFIG_CIFS_STATS2
>> + =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->when_received =3D jiffies;
>> +#endif
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&mid_entry->qhead);
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 }
>> + =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> +
>> + =A0 =A0 return mid_entry;
>> +}
>> +
>> +static int
>> +check_rfc1002_header(struct TCP_Server_Info *server, char *buf, int=
 length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int pdu_length, struct=
 socket **psocket)
>
> I don't think you really need psocket here. That should just be
> server->ssocket. For that matter, pdu_length should be readable from
> buf, and "length" is always going to be 4 anyway, right?
>
>> +{
>> + =A0 =A0 char temp =3D *buf;
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* The first byte big endian of the length field,
>> + =A0 =A0 =A0* is actually not part of the length but the type
>> + =A0 =A0 =A0* with the most common, zero, as regular data.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (temp =3D=3D (char) RFC1002_SESSION_KEEP_ALIVE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 } else if (temp =3D=3D (char)RFC1002_POSITIVE_SESSION_RESP=
ONSE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Good RFC 1002 session rsp");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 } else if (temp =3D=3D (char)RFC1002_NEGATIVE_SESSION_RESP=
ONSE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* we get this from Windows 98 instead of
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0an error on SMB negprot response */
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Negative RFC1002 Session Response=
 Error 0x%x)",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdu_length);
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* give server a second to clean up =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 msleep(1000);
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* always try 445 first on reconnect since=
 we get NACK
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* on some if we ever connected to port =
139 (the NACK
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* is since we do not begin with RFC1001=
 session
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* initialize frame)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_set_port((struct sockaddr *)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &server->d=
staddr, CIFS_PORT);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
>> + =A0 =A0 =A0 =A0 =A0 =A0 *psocket =3D server->ssocket;
>> + =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&server->response_q);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 } else if (temp !=3D (char) 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unknown RFC 1002 frame");
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem(" Received Data: ", buf, len=
gth);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
>> + =A0 =A0 =A0 =A0 =A0 =A0 *psocket =3D server->ssocket;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /* else we have an SMB response */
>> + =A0 =A0 if ((pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) =
||
>> + =A0 =A0 =A0 =A0 (pdu_length < sizeof(struct smb_hdr) - 1 - 4)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Invalid size SMB length %d pdu_=
length %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length, pdu_length+4);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
>> + =A0 =A0 =A0 =A0 =A0 =A0 *psocket =3D server->ssocket;
>> + =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&server->response_q);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> +static int
>> +allocate_bufs(char **pbigbuf, char **psmallbuf, unsigned int size,
>> + =A0 =A0 =A0 =A0 =A0 bool isLargeBuf)
> =A0 ^^^
> nit: This can probably be a bool return.
>
>> +{
>> + =A0 =A0 char *bigbuf =3D *pbigbuf, *smallbuf =3D *psmallbuf;
>> +
>> + =A0 =A0 if (bigbuf =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 bigbuf =3D (char *)cifs_buf_get();
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!bigbuf) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "No memory for l=
arge SMB response");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(3000);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry will check if exi=
ting */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else if (isLargeBuf) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* we are reusing a dirty large buf, clear=
 its start */
>> + =A0 =A0 =A0 =A0 =A0 =A0 memset(bigbuf, 0, size);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (smallbuf =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 smallbuf =3D (char *)cifs_small_buf_get();
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!smallbuf) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "No memory for S=
MB response");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(1000);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry will check if exi=
ting */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* beginning of smb buffer is cleared in o=
ur buf_get */
>> + =A0 =A0 } else /* if existing small buf clear beginning */
>> + =A0 =A0 =A0 =A0 =A0 =A0 memset(smallbuf, 0, size);
>> +
>> + =A0 =A0 *pbigbuf =3D bigbuf;
>> + =A0 =A0 *psmallbuf =3D smallbuf;
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
> =A0 =A0 =A0 =A0^^^
> The buffer handling could really stand to be redesigned, but splittin=
g
> it out into a separate function is a decent start.
>
>> +static int
>> +read_from_socket(struct TCP_Server_Info *server, unsigned int pdu_l=
ength,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0struct socket **psocket, struct msghdr =
*smb_msg,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0struct kvec *iov, unsigned int *ptotal_=
read)
>> +{
>> + =A0 =A0 int length, rc =3D 0;
>> + =A0 =A0 unsigned int total_read;
>> +
>> + =A0 =A0 for (total_read =3D 0; total_read < pdu_length;
>> + =A0 =A0 =A0 =A0 =A0total_read +=3D length) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 length =3D kernel_recvmsg(*psocket, smb_ms=
g, iov, 1,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 pdu_length - total_read, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=3D CifsExiting) =
{
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* then will exit */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 2;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (server->tcpStatus =3D=3D CifsNe=
edReconnect) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *psocket =3D server->ssock=
et;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Reconnect wakes up rspn=
s q */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Now we will reread sock=
 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (length =3D=3D -ERESTARTSYS ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length =3D=3D -EAGA=
IN ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length =3D=3D -EINT=
R) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Minimum sleep to prev=
ent looping,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* allowing socket to cl=
ear and app
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* threads to set tcpSta=
tus
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* CifsNeedReconnect if =
server hung.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 usleep_range(1000, 2000);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (length <=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Received no dat=
a, expecting %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 pdu_length - total_read);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *psocket =3D server->ssock=
et;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 *ptotal_read =3D total_read;
>> + =A0 =A0 return 0;
>> +}
>> +
>> =A0static int
>> =A0cifs_demultiplex_thread(struct TCP_Server_Info *server)
>> =A0{
>> =A0 =A0 =A0 int length;
>> =A0 =A0 =A0 unsigned int pdu_length, total_read;
>> + =A0 =A0 char *buf =3D NULL, *smallbuf =3D NULL, *bigbuf =3D NULL;
>> =A0 =A0 =A0 struct smb_hdr *smb_buffer =3D NULL;
>> - =A0 =A0 struct smb_hdr *bigbuf =3D NULL;
>> - =A0 =A0 struct smb_hdr *smallbuf =3D NULL;
>> =A0 =A0 =A0 struct msghdr smb_msg;
>> =A0 =A0 =A0 struct kvec iov;
>> =A0 =A0 =A0 struct socket *csocket =3D server->ssocket;
>> =A0 =A0 =A0 struct list_head *tmp, *tmp2;
>> =A0 =A0 =A0 struct task_struct *task_to_wake =3D NULL;
>> =A0 =A0 =A0 struct mid_q_entry *mid_entry;
>> - =A0 =A0 char temp;
>> =A0 =A0 =A0 bool isLargeBuf =3D false;
>> =A0 =A0 =A0 bool isMultiRsp;
>> - =A0 =A0 int reconnect;
>> + =A0 =A0 int rc;
>>
>> =A0 =A0 =A0 current->flags |=3D PF_MEMALLOC;
>> =A0 =A0 =A0 cFYI(1, "Demultiplex PID: %d", task_pid_nr(current));
>> @@ -348,35 +558,17 @@ cifs_demultiplex_thread(struct TCP_Server_Info=
 *server)
>> =A0 =A0 =A0 while (server->tcpStatus !=3D CifsExiting) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (try_to_freeze())
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (bigbuf =3D=3D NULL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bigbuf =3D cifs_buf_get();
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!bigbuf) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, =
"No memory for large SMB response");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(300=
0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry w=
ill check if exiting */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (isLargeBuf) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we are reusing a dirty =
large buf, clear its start */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(bigbuf, 0, sizeof(s=
truct smb_hdr));
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (smallbuf =3D=3D NULL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smallbuf =3D cifs_small_bu=
f_get();
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!smallbuf) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, =
"No memory for SMB response");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(100=
0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry w=
ill check if exiting */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* beginning of smb buffer=
 is cleared in our buf_get */
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else /* if existing small buf clear begi=
nning */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(smallbuf, 0, sizeof=
(struct smb_hdr));
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D allocate_bufs(&bigbuf, &smallbuf, s=
izeof(struct smb_hdr),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0isL=
argeBuf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 isLargeBuf =3D false;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 isMultiRsp =3D false;
>> - =A0 =A0 =A0 =A0 =A0 =A0 smb_buffer =3D smallbuf;
>> - =A0 =A0 =A0 =A0 =A0 =A0 iov.iov_base =3D smb_buffer;
>> + =A0 =A0 =A0 =A0 =A0 =A0 smb_buffer =3D (struct smb_hdr *)smallbuf;
>> + =A0 =A0 =A0 =A0 =A0 =A0 buf =3D smallbuf;
>> + =A0 =A0 =A0 =A0 =A0 =A0 iov.iov_base =3D smallbuf;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov.iov_len =3D 4;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_msg.msg_control =3D NULL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_msg.msg_controllen =3D 0;
>> @@ -414,8 +606,7 @@ incomplete_rcv:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 allowing=
 socket to clear and app threads to set
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcpStatu=
s CifsNeedReconnect if server hung */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pdu_length < 4) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov.iov_ba=
se =3D (4 - pdu_length) +
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)smb_buffer;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov.iov_ba=
se =3D (4 - pdu_length) + buf;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov.iov_=
len =3D pdu_length;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_msg.=
msg_control =3D NULL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_msg.=
msg_controllen =3D 0;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Should the above code be using read_fr=
om_socket() as
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0well? It would be nice if we had a sin=
gle function that
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0we always called to do reads off the s=
ocket and simply
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0check the return value from that. That=
 may be reasonable
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for a later patch.
>
>> @@ -440,114 +631,42 @@ incomplete_rcv:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* The right amount was read from socket=
 - 4 bytes */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* so we can now interpret the length fi=
eld */
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* the first byte big endian of the length=
 field,
>> - =A0 =A0 =A0 =A0 =A0 =A0 is actually not part of the length but the=
 type
>> - =A0 =A0 =A0 =A0 =A0 =A0 with the most common, zero, as regular dat=
a */
>> - =A0 =A0 =A0 =A0 =A0 =A0 temp =3D *((char *) smb_buffer);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* Note that FC 1001 length is big endian =
on the wire,
>> - =A0 =A0 =A0 =A0 =A0 =A0 but we convert it here so it is always man=
ipulated
>> - =A0 =A0 =A0 =A0 =A0 =A0 as host byte order */
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* Note that FC 1001 length is big endia=
n on the wire,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nit: might as well add=
 the missing "R" here
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* but we convert it here so it is alway=
s manipulated
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* as host byte order
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdu_length =3D be32_to_cpu(smb_buffer->s=
mb_buf_length);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "rfc1002 length 0x%x", pdu_length+=
4);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (temp =3D=3D (char) RFC1002_SESSION_KEE=
P_ALIVE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (temp =3D=3D (char)RFC1002_POSIT=
IVE_SESSION_RESPONSE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Good RFC 1002 ses=
sion rsp");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (temp =3D=3D (char)RFC1002_NEGAT=
IVE_SESSION_RESPONSE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we get this from Window=
s 98 instead of
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0an error on SMB neg=
prot response */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Negative RFC1002 =
Session Response Error 0x%x)",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdu_length=
);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* give server a second to=
 clean up =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(1000);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* always try 445 first on=
 reconnect since we get NACK
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* on some if we ever co=
nnected to port 139 (the NACK
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* is since we do not be=
gin with RFC1001 session
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* initialize frame)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_set_port((struct sock=
addr *)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &server->dstaddr, CIFS_PORT);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 csocket =3D server->ssocke=
t;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&server->response_=
q);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 } else if (temp !=3D (char) 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unknown RFC 100=
2 frame");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem(" Received D=
ata: ", (char *)smb_buffer,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 length);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 csocket =3D server->ssocke=
t;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* else we have an SMB response */
>> - =A0 =A0 =A0 =A0 =A0 =A0 if ((pdu_length > CIFSMaxBufSize + MAX_CIF=
S_HDR_SIZE - 4) ||
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (pdu_length < size=
of(struct smb_hdr) - 1 - 4)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Invalid size SM=
B length %d pdu_length %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 length, pdu_length+4);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 csocket =3D server->ssocke=
t;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&server->response_=
q);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D check_rfc1002_header(server, buf, l=
ength, pdu_length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &csocket);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* else length ok */
>> - =A0 =A0 =A0 =A0 =A0 =A0 reconnect =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "rfc1002 length 0x%x", pdu_length+=
4);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pdu_length > MAX_CIFS_SMALL_BUFFER_S=
IZE - 4) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 isLargeBuf =3D true;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bigbuf, smallbuf,=
 4);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_buffer =3D bigbuf;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_buffer =3D (struct smb=
_hdr *)bigbuf;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 buf =3D bigbuf;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 length =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 iov.iov_base =3D 4 + (char *)smb_buffer;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 iov.iov_base =3D 4 + buf;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov.iov_len =3D pdu_length;
>> - =A0 =A0 =A0 =A0 =A0 =A0 for (total_read =3D 0; total_read < pdu_le=
ngth;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0total_read +=3D length) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D kernel_recvmsg(=
csocket, &smb_msg, &iov, 1,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 pdu_length - total_read, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=3D=
 CifsExiting) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* then wi=
ll exit */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 reconnect =
=3D 2;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (server->tcpStat=
us =3D=3D CifsNeedReconnect) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_recon=
nect(server);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 csocket =3D=
 server->ssocket;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Reconne=
ct wakes up rspns q */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Now we =
will reread sock */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 reconnect =
=3D 1;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (length =3D=3D -=
ERESTARTSYS ||
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len=
gth =3D=3D -EAGAIN ||
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len=
gth =3D=3D -EINTR) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(1);=
 /* minimum sleep to prevent looping,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 allowing socket to clear and app
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 threads to set tcpStatus
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 CifsNeedReconnect if server hung*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D=
 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (length <=3D 0) =
{
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, =
"Received no data, expecting %d",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 pdu_length - total_read);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_recon=
nect(server);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 csocket =3D=
 server->ssocket;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 reconnect =
=3D 1;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (reconnect =3D=3D 2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D read_from_socket(server, pdu_length=
, &csocket, &smb_msg,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 &iov, &total_read);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 2)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 =A0 =A0 =A0 =A0 else if (reconnect =3D=3D 1)
>> + =A0 =A0 =A0 =A0 =A0 =A0 else if (rc =3D=3D 1)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_read +=3D 4; /* account for rfc100=
2 hdr */
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_smb(smb_buffer, total_read);
>>
>> + =A0 =A0 =A0 =A0 =A0 =A0 server->lstrp =3D jiffies;
>> + =A0 =A0 =A0 =A0 =A0 =A0 length =3D 0;
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* We know that we received enough to =
get to the MID as we
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* checked the pdu_length earlier. Now=
 check to see
>> @@ -559,75 +678,11 @@ incomplete_rcv:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D checkSMB(smb_buffer, smb_buff=
er->Mid, total_read);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (length !=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Bad SMB: ",=
 smb_buffer,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 min_t(unsigned int, total_read, 48));
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 server->lstrp =3D jiffies;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> - =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_safe(tmp, tmp2, &server->pen=
ding_mid_q) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entry(t=
mp, struct mid_q_entry, qhead);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->mid !=3D sm=
b_buffer->Mid ||
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->midStat=
e !=3D MID_REQUEST_SUBMITTED ||
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->command=
 !=3D smb_buffer->Command) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =
=3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (length =3D=3D 0 &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 check2ndT2(smb_buf=
fer, server->maxBuf) > 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We have=
 a multipart transact2 resp */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 isMultiRsp=
 =3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_en=
try->resp_buf) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 /* merge response - fix up 1st*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 length =3D coalesce_t2(smb_buffer,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->resp_buf);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (length > 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 length =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 mid_entry->multiRsp =3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 /* all parts received or
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0* packet is malformed
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 mid_entry->multiEnd =3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 goto multi_t2_fnd;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (!isLargeBuf) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0* FIXME: switch to already
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0* =A0 =A0 =A0 =A0allocated largebuf?
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 cERROR(1, "1st trans2 resp "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "needs bigbuf");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 /* Have first buffer */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 mid_entry->resp_buf =3D
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0smb_buffer;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 mid_entry->largeBuf =3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 bigbuf =3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->resp_buf =3D sm=
b_buffer;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->largeBuf =3D is=
LargeBuf;
>> -multi_t2_fnd:
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (length =3D=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry-=
>midState =3D MID_RESPONSE_RECEIVED;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry-=
>midState =3D MID_RESPONSE_MALFORMED;
>> -#ifdef CONFIG_CIFS_STATS2
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->when_received =3D=
 jiffies;
>> -#endif
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&mid_entry->=
qhead);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Bad SMB: ",=
 buf,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 min_t(unsigned int, total_read, 48));
>>
>> + =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D find_cifs_owner(server, smb_=
buffer, &length,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 isLargeBuf, &isMultiRsp, &bigbuf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry !=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->callback(mid_=
entry);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Was previous buf put =
in mpx struct for multi-rsp? */
>> @@ -645,13 +700,12 @@ multi_t2_fnd:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!isMultiRsp) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "No task to wa=
ke, unknown frame received! "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"=
NumMids %d", atomic_read(&midCount));
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Received Da=
ta is: ", (char *)smb_buffer,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mem("Received Da=
ta is: ", buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 sizeof(struct smb_hdr));
>> =A0#ifdef CONFIG_CIFS_DEBUG2
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_detail(smb_buf=
fer);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_dump_mids(server);
>> =A0#endif /* CIFS_DEBUG2 */
>> -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 } /* end while !EXITING */
>>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Thanks for the review!

I agree with your points - so, I am going to split it into several
patches, rework places you mentioned and post whole series soon.

--=20
Best regards,
Pavel Shilovsky.
