From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: Re: [PATCH v2 05/53] CIFS: wait_for_free_request needs to wait on
 credits returned by server (for SMB2)
Date: Sun, 30 Oct 2011 00:00:15 +0400
Message-ID: <CAKywueSGDSw33L4_a7W6D7gM_PH9uy3xTQ6=8zgAimGhz5=UfA@mail.gmail.com>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-6-git-send-email-piastry@etersoft.ru>
	<20111029113508.370e7df9@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Steve French <sfrench@us.ibm.com>
To: Jeff Layton <jlayton@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111029113508.370e7df9@corrin.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2011/10/29 Jeff Layton <jlayton@samba.org>:
> On Fri, 28 Oct 2011 23:54:16 +0400
> Pavel Shilovsky <piastry@etersoft.ru> wrote:
>
>> From: Steve French <sfrench@us.ibm.com>
>>
>> wait_for_free_request is called to ensure that we don't have more th=
an the
>> configured maximum of requests in flight on the wire (for cifs), but=
 for SMB2,
>> the number of requests that can be in flight varies dynamically (the=
 client
>> may request that the server grant more "credits" in a request, and e=
ach
>> request uses at least one credit). =A0 Instead of migrating over the=
 original
>> smb2_wait_for_free_request function, simply add a check in cifs's or=
iginal
>> wait_for_free_request for the is_smb2 case to make sure that we don'=
t go
>> beyond the number of allocated "credits" (ie those that remain from =
those
>> the server has allocated for this tcp session). =A0Otherwise the log=
ic is unchanged
>> (other than to make it extern so that the next function to be added,=
 smb2_sendrcv2
>> in =A0smbtransport.c can call it - smb2_sendrcv2 will be migrated ov=
er in the next patch).
>>
>> Note that smb2 servers will typically allow many more requests in fl=
ight at one time
>> than cifs servers (which usually default to only 50) and can adjust =
this as needed.
>> This should provide significant performance benefit in some workload=
s (ie smb2
>> in many cases will get more parallelism than cifs and some other pro=
tocols
>> since some artificially constrain the maximum number of requests).
>>
>> Signed-off-by: Steve French <sfrench@us.ibm.com>
>> Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
>> ---
>> =A0fs/cifs/cifsglob.h =A0| =A0 =A01 +
>> =A0fs/cifs/cifsproto.h | =A0 =A03 ++-
>> =A0fs/cifs/transport.c | =A0 22 +++++++++++++++++++---
>> =A03 files changed, 22 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 179b784..b440329 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -311,6 +311,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 wait_queue_head_t read_q; /* used by readpages */
>> =A0 =A0 =A0 atomic_t active_readpage_req; /* used by readpages */
>> =A0 =A0 =A0 atomic_t resp_rdy; /* used by readpages and demultiplex =
*/
>> + =A0 =A0 atomic_t credits; =A0/* send no more simultaneous requests=
 than this */
>> =A0 =A0 =A0 __le16 smb2_dialect_revision; /* SMB2.0 implemented, 2.1=
 recognized */
>> =A0 =A0 =A0 struct task_struct *observe;
>> =A0 =A0 =A0 char smb2_crypt_key[CIFS_CRYPTO_KEY_SIZE]; /* BB can we =
use cifs key */
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index ef4f631..84d1e4c 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -1,7 +1,7 @@
>> =A0/*
>> =A0 * =A0 fs/cifs/cifsproto.h
>> =A0 *
>> - * =A0 Copyright (c) International Business Machines =A0Corp., 2002=
,2008
>> + * =A0 Copyright (c) International Business Machines =A0Corp., 2002=
,2011
>> =A0 * =A0 Author(s): Steve French (sfrench@us.ibm.com)
>> =A0 *
>> =A0 * =A0 This library is free software; you can redistribute it and=
/or modify
>> @@ -68,6 +68,7 @@ extern char *cifs_compose_mount_options(const char=
 *sb_mountdata,
>> =A0extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *s=
mb_buffer,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 struct TCP_Server_Info *server);
>> =A0extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
>> +extern int wait_for_free_request(struct TCP_Server_Info *sv, const =
int long_op);
>> =A0extern int cifs_call_async(struct TCP_Server_Info *server, struct=
 kvec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nvec=
, mid_receive_t *receive,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_callback_t *c=
allback, void *cbdata,
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 0cc9584..25d04df 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -254,7 +254,7 @@ smb_send(struct TCP_Server_Info *server, struct =
smb_hdr *smb_buffer,
>> =A0 =A0 =A0 return smb_sendv(server, &iov, 1);
>> =A0}
>>
>> -static int wait_for_free_request(struct TCP_Server_Info *server,
>> +int wait_for_free_request(struct TCP_Server_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const=
 int long_op)
>> =A0{
>> =A0 =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
>> @@ -265,7 +265,8 @@ static int wait_for_free_request(struct TCP_Serv=
er_Info *server,
>>
>> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> =A0 =A0 =A0 while (1) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&server->inFlight) >=3D ci=
fs_max_pending) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((server->is_smb2 =3D=3D false) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&server->inFlight) >=3D=
 cifs_max_pending) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_num_waiters_inc(ser=
ver);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event(server->reque=
st_q,
>> @@ -273,6 +274,16 @@ static int wait_for_free_request(struct TCP_Ser=
ver_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0< cifs_max_pending);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_num_waiters_dec(ser=
ver);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Loc=
k);
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (server->is_smb2 &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (atomic_read(&server->=
credits) < 1)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Loc=
k);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_num_waiters_inc(serve=
r);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event(server->request=
_q,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ato=
mic_read(&server->credits) > 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_num_waiters_dec(serve=
r);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lock)=
;
>> +#endif /* CONFIG_CIFS_SMB2 */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=
=3D CifsExiting) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unl=
ock(&GlobalMid_Lock);
>> @@ -283,8 +294,13 @@ static int wait_for_free_request(struct TCP_Ser=
ver_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0as they are allow=
ed to block on server */
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update # of requests =
on the wire to server */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (long_op !=3D CIFS_BLOC=
KING_OP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->is_smb2 =3D=3D=
 false &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 long_op !=3D CIFS_=
BLOCKING_OP)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_i=
nc(&server->inFlight);
>> +#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (server->is_smb2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec=
(&server->credits);
>> +#endif
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> This patch doesn't make much sense...
>
> "credits" gets initialized to 0, then on the first request, you'll
> decrement it which will make it go negative. I then don't see any pla=
ce
> where credits is ever incremented.
>
> Maybe that happens in a different patch, but splitting your patches o=
ut
> this way makes no sense. No one can reasonably review this patch for
> sanity since the lifecycle of "credits" is incomplete.

In this case we should move this patch after we add smb2_sendrcv
function (where credits are increased). Make sense?

--=20
Best regards,
Pavel Shilovsky.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
