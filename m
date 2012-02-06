From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 06/50] CIFS: Add SMB2 credits support
Date: Mon, 6 Feb 2012 13:59:32 +0400
Message-ID: <CAKywueRE8-Rbcc0QaJeWVJVZKtvxApGfN=QttKECA-fd+yKMyg@mail.gmail.com>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
	<1327048511-2342-6-git-send-email-piastry@etersoft.ru>
	<20120203134212.53f1e950@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120203134212.53f1e950-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 20 Jan 2012 12:34:27 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
>>
>> Convert wait_for_free_request to wait on available credits
>> for SMB2 servers and decrement a credit number for every call.
>> Increment the credit number in smb2_sendrcv2 with every response
>> got from the server.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h =A0 =A0 =A0| =A0 =A01 +
>> =A0fs/cifs/cifsproto.h =A0 =A0 | =A0 =A02 +-
>> =A0fs/cifs/smb2transport.c | =A0 =A06 ++++++
>> =A0fs/cifs/transport.c =A0 =A0 | =A0 20 ++++++++++++++++++--
>> =A04 files changed, 26 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index bb2af48..e5f0b86 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -318,6 +318,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 atomic_t num_waiters; =A0 /* blocked waiting to get in s=
endrecv */
>> =A0#endif
>> =A0#ifdef CONFIG_CIFS_SMB2
>> + =A0 =A0 atomic_t credits; /* send no more simultaneous requests th=
an this */
>> =A0 =A0 =A0 __u64 current_smb2_mid; =A0 =A0 =A0 =A0 /* multiplex id =
- rotating counter */
>> =A0#endif
>> =A0};
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index d1e30d9..b6c784b 100644
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
>> =A0 * =A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
>> =A0 *
>> =A0 * =A0 This library is free software; you can redistribute it and=
/or modify
>> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
>> index d7f1c05..b5702f3 100644
>> --- a/fs/cifs/smb2transport.c
>> +++ b/fs/cifs/smb2transport.c
>> @@ -148,6 +148,7 @@ smb2_sendrcv2(const unsigned int xid, struct cif=
s_ses *ses,
>> =A0 =A0 =A0 unsigned int receive_len;
>> =A0 =A0 =A0 struct mid_q_entry *midQ;
>> =A0 =A0 =A0 struct smb2_hdr *buf =3D iov[0].iov_base;
>> + =A0 =A0 unsigned int credits =3D 1;
>>
>> =A0 =A0 =A0 if (status)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 *status =3D STATUS_SUCCESS;
>> @@ -186,6 +187,7 @@ smb2_sendrcv2(const unsigned int xid, struct cif=
s_ses *ses,
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&ses->server->srv_mutex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server->credits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> @@ -222,6 +224,7 @@ smb2_sendrcv2(const unsigned int xid, struct cif=
s_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->callback =3D cifs_=
delete_mid;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(b=
uf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server->c=
redits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->re=
quest_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> @@ -232,6 +235,7 @@ smb2_sendrcv2(const unsigned int xid, struct cif=
s_ses *ses,
>>
>> =A0 =A0 =A0 rc =3D cifs_sync_mid_result(midQ, ses->server);
>> =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server->credits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> @@ -271,7 +275,9 @@ smb2_sendrcv2(const unsigned int xid, struct cif=
s_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* mark it so buf will not be freed by f=
ree_smb2mid */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->resp_buf =3D NULL;
>>
>> + =A0 =A0 credits =3D le16_to_cpu(buf->CreditRequest);
>> =A0out:
>> + =A0 =A0 atomic_add(credits, &ses->server->credits);
>> =A0 =A0 =A0 cifs_delete_mid(midQ);
>> =A0 =A0 =A0 wake_up(&ses->server->request_q);
>> =A0 =A0 =A0 return rc;
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index f7ac3f0..4414df8 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -287,7 +287,8 @@ cifs_wait_for_free_request(struct TCP_Server_Inf=
o *server, const int long_op)
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
>> @@ -295,6 +296,16 @@ cifs_wait_for_free_request(struct TCP_Server_In=
fo *server, const int long_op)
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
>> @@ -305,8 +316,13 @@ cifs_wait_for_free_request(struct TCP_Server_In=
fo *server, const int long_op)
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
> I'd like to suggest an alternate approach here...
>
> Instead of considering this as a SMB1 vs. SMB2 either/or thing we
> should consider the SMB1 case to be a special case of SMB2 credits. I=
n
> the SMB1 NEGOTIATE response, the server sends us a MaxMpx value. We
> could consider that to be an initial set of credits. Every time we ge=
t
> a SMB1 response from the server, we'll increment the credit value.
>
> If we do that, then there's a lot less protocol dependent code that's
> needed, and if done correctly should also fix the current bug in
> the SMB1 code where it ignores the MaxMpx value.
>
> Thoughts?

As the initial step, I suggest we can set credit value to
cifs_max_pending  before negotiate and then decrement it for any
out-coming request and increment for - incoming. Then we can change it
to 1 respect MaxMpx value.

--=20
Best regards,
Pavel Shilovsky.
