From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v4 4/7] CIFS: Extend credit mechanism to process request type
Date: Thu, 7 Jun 2012 19:51:01 +0400
Message-ID: <CAKywueRZ0nxOCFXw+cUNPPJ+vmYwKTAgB7Y9FAyPDQor1gyWSA@mail.gmail.com>
References: <1338468657-29742-1-git-send-email-pshilovsky@samba.org>
	<1338468657-29742-6-git-send-email-pshilovsky@samba.org>
	<20120606075759.5a50fd34@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120606075759.5a50fd34-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/6/6 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Thu, 31 May 2012 16:50:54 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> Split all requests to echos, oplocks and others - each group uses
>> its own credit slot. This change is required to support SMB2 code.
>>
>> As for CIFS - we don't use this approach and the logic isn't changed=
=2E
>>
>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h =A0| =A0 14 ++++++++++----
>> =A0fs/cifs/cifsproto.h | =A0 =A02 +-
>> =A0fs/cifs/cifssmb.c =A0 | =A0 12 ++++++------
>> =A0fs/cifs/smb1ops.c =A0 | =A0 12 ++++++++++--
>> =A0fs/cifs/transport.c | =A0 34 +++++++++++++++++++---------------
>> =A05 files changed, 46 insertions(+), 28 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 2aac4e5..560b011 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -171,9 +171,11 @@ struct smb_version_operations {
>> =A0 =A0 =A0 /* check response: verify signature, map error */
>> =A0 =A0 =A0 int (*check_receive)(struct mid_q_entry *, struct TCP_Se=
rver_Info *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool);
>> - =A0 =A0 void (*add_credits)(struct TCP_Server_Info *, const unsign=
ed int);
>> + =A0 =A0 void (*add_credits)(struct TCP_Server_Info *, const unsign=
ed int,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int);
>> =A0 =A0 =A0 void (*set_credits)(struct TCP_Server_Info *, const int)=
;
>> - =A0 =A0 int * (*get_credits_field)(struct TCP_Server_Info *);
>> + =A0 =A0 int * (*get_credits_field)(struct TCP_Server_Info *, const=
 int);
>> + =A0 =A0 unsigned int (*get_credits)(struct mid_q_entry *);
>> =A0 =A0 =A0 __u64 (*get_next_mid)(struct TCP_Server_Info *);
>> =A0 =A0 =A0 /* data offset from read response message */
>> =A0 =A0 =A0 unsigned int (*read_data_offset)(char *);
>> @@ -392,9 +394,10 @@ has_credits(struct TCP_Server_Info *server, int=
 *credits)
>> =A0}
>>
>> =A0static inline void
>> -add_credits(struct TCP_Server_Info *server, const unsigned int add)
>> +add_credits(struct TCP_Server_Info *server, const unsigned int add,
>> + =A0 =A0 =A0 =A0 const int optype)
>> =A0{
>> - =A0 =A0 server->ops->add_credits(server, add);
>> + =A0 =A0 server->ops->add_credits(server, add, optype);
>> =A0}
>>
>> =A0static inline void
>> @@ -956,6 +959,9 @@ static inline void free_dfs_info_array(struct df=
s_info3_param *param,
>> =A0#define =A0 CIFS_LOG_ERROR =A0 =A00x010 =A0 =A0/* log NT STATUS i=
f non-zero */
>> =A0#define =A0 CIFS_LARGE_BUF_OP 0x020 =A0 =A0/* large request buffe=
r */
>> =A0#define =A0 CIFS_NO_RESP =A0 =A0 =A00x040 =A0 =A0/* no response b=
uffer required */
>> +#define =A0 CIFS_ECHO_OP =A0 =A0 =A00x080 =A0 =A0/* echo request */
>> +#define =A0 CIFS_OBREAK_OP =A0 0x0100 =A0 =A0/* oplock break reques=
t */
>> +#define =A0 CIFS_REQ_MASK =A0 =A00x0180 =A0 =A0/* mask request type=
 */
>>
>
>
> Ok, now that I went back and read the patch description, I think I
> understand why you're doing it this way. Still, it's generally good
> practice to add flags only when you're going to use them, or to expla=
in
> why you're adding them without setting them anywhere.

Ok, it seems I need to add an extra description to the commit message.

>
>> =A0/* Security Flags: indicate type of session setup needed */
>> =A0#define =A0 CIFSSEC_MAY_SIGN =A0 0x00001
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 0a6cbfe..41d5a76 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -71,7 +71,7 @@ extern void DeleteMidQEntry(struct mid_q_entry *mi=
dEntry);
>> =A0extern int cifs_call_async(struct TCP_Server_Info *server, struct=
 kvec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nvec=
, mid_receive_t *receive,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_callback_t *c=
allback, void *cbdata,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool ignore_pend);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const int optype);
>> =A0extern int SendReceive(const unsigned int /* xid */ , struct cifs=
_ses *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr * /* inpu=
t */ ,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr * /* out =
*/ ,
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 5b40073..65898cc 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -720,7 +720,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
>> =A0 =A0 =A0 struct TCP_Server_Info *server =3D mid->callback_data;
>>
>> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> - =A0 =A0 add_credits(server, 1);
>> + =A0 =A0 add_credits(server, 1, 0);
>> =A0}
>>
>> =A0int
>> @@ -747,7 +747,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 iov.iov_len =3D be32_to_cpu(smb->hdr.smb_buf_length) + 4=
;
>>
>> =A0 =A0 =A0 rc =3D cifs_call_async(server, &iov, 1, NULL, cifs_echo_=
callback,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server, true);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server, CIFS_AS=
YNC_OP);
>
> Even if the SMB1 operation doesn't use this, it's probably a good ide=
a
> to set the ECHO flag here. If you ever change the behavior of the oth=
er
> operations, you might avoid a bug that way.
>
> Probably ditto for the oplock break operation.

We need to set CIFS_ASYNC_OP flag here because it indicates that we
can't wait until credits come (according to the echo behavior in CIFS
that we discussed earlier). So, setting ECHO flag here means that we
need to consume credit from 'echo' slot - that doesn't match the
reality. As for the oplock break operation - it is the same.

May be we should rename 'CIFS_ASYNC_OP' flag to make it more
informative (e.g. CIFS_NOCREDIT_OP or smth else) ?

--=20
Best regards,
Pavel Shilovsky.
