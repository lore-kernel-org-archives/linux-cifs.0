From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 5/5] CIFS: Move add/set_credits and get_credits_field to
 ops structure
Date: Sat, 19 May 2012 09:47:42 +0400
Message-ID: <CAKywueSTd4WUhg6YJNXAnnxtvUbDegCdD6B2Zk=TXRhVRAhBzg@mail.gmail.com>
References: <1337269424-9494-1-git-send-email-piastry@etersoft.ru>
	<1337269424-9494-6-git-send-email-piastry@etersoft.ru>
	<20120518125439.23525985@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120518125439.23525985-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, 17 May 2012 19:43:44 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h =A0| =A0 25 +++++++++++++++----------
>> =A0fs/cifs/cifsproto.h | =A0 =A03 ---
>> =A0fs/cifs/misc.c =A0 =A0 =A0| =A0 19 -------------------
>> =A0fs/cifs/smb1ops.c =A0 | =A0 28 ++++++++++++++++++++++++++++
>> =A0fs/cifs/transport.c | =A0 =A03 ++-
>> =A05 files changed, 45 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 7b3e8fe..d17db87 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -167,6 +167,9 @@ struct smb_version_operations {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct mid_q_=
entry **);
>> =A0 =A0 =A0 int (*check_receive)(struct mid_q_entry *, struct TCP_Se=
rver_Info *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool);
>> + =A0 =A0 void (*add_credits)(struct TCP_Server_Info *, const unsign=
ed int);
>> + =A0 =A0 void (*set_credits)(struct TCP_Server_Info *, const int);
>> + =A0 =A0 int * (*get_credits_field)(struct TCP_Server_Info *);
>> =A0 =A0 =A0 unsigned int (*read_data_offset)(char *);
>> =A0 =A0 =A0 unsigned int (*read_data_length)(char *);
>> =A0 =A0 =A0 int (*map_error)(char *, bool);
>> @@ -367,16 +370,6 @@ in_flight(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 return num;
>> =A0}
>>
>> -static inline int*
>> -get_credits_field(struct TCP_Server_Info *server)
>> -{
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* This will change to switch statement when we reserve =
slots for echos
>> - =A0 =A0 =A0* and oplock breaks.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 return &server->credits;
>> -}
>> -
>> =A0static inline bool
>> =A0has_credits(struct TCP_Server_Info *server, int *credits)
>> =A0{
>> @@ -387,6 +380,18 @@ has_credits(struct TCP_Server_Info *server, int=
 *credits)
>> =A0 =A0 =A0 return num > 0;
>> =A0}
>>
>> +static inline void
>> +cifs_add_credits(struct TCP_Server_Info *server, const unsigned int=
 add)
>> +{
>> + =A0 =A0 server->ops->add_credits(server, add);
>> +}
>> +
>> +static inline void
>> +cifs_set_credits(struct TCP_Server_Info *server, const int val)
>> +{
>> + =A0 =A0 server->ops->set_credits(server, val);
>> +}
>> +
>
> nit: maybe call these "add_credits and set_credits" and get rid of th=
e
> leading '_' on the SMB1 functions below?
>
>> =A0/*
>> =A0 * Macros to allow the TCP_Server_Info->net field and related cod=
e to drop out
>> =A0 * when CONFIG_NET_NS isn't set.
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 57af642..5ec21ec 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -90,9 +90,6 @@ extern int SendReceiveBlockingLock(const unsigned =
int xid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *in_buf ,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *out_buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *bytes_returned);
>> -extern void cifs_add_credits(struct TCP_Server_Info *server,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const unsigned =
int add);
>> -extern void cifs_set_credits(struct TCP_Server_Info *server, const =
int val);
>> =A0extern int checkSMB(char *buf, unsigned int length);
>> =A0extern bool is_valid_oplock_break(char *, struct TCP_Server_Info =
*);
>> =A0extern bool backup_cred(struct cifs_sb_info *);
>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>> index d2bb1e7..e2552d2 100644
>> --- a/fs/cifs/misc.c
>> +++ b/fs/cifs/misc.c
>> @@ -653,22 +653,3 @@ backup_cred(struct cifs_sb_info *cifs_sb)
>>
>> =A0 =A0 =A0 return false;
>> =A0}
>> -
>> -void
>> -cifs_add_credits(struct TCP_Server_Info *server, const unsigned int=
 add)
>> -{
>> - =A0 =A0 spin_lock(&server->req_lock);
>> - =A0 =A0 server->credits +=3D add;
>> - =A0 =A0 server->in_flight--;
>> - =A0 =A0 spin_unlock(&server->req_lock);
>> - =A0 =A0 wake_up(&server->request_q);
>> -}
>> -
>> -void
>> -cifs_set_credits(struct TCP_Server_Info *server, const int val)
>> -{
>> - =A0 =A0 spin_lock(&server->req_lock);
>> - =A0 =A0 server->credits =3D val;
>> - =A0 =A0 server->oplocks =3D val > 1 ? enable_oplocks : false;
>> - =A0 =A0 spin_unlock(&server->req_lock);
>> -}
>> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
>> index 8a0b35b..17a69ed 100644
>> --- a/fs/cifs/smb1ops.c
>> +++ b/fs/cifs/smb1ops.c
>> @@ -102,11 +102,39 @@ cifs_find_mid(struct TCP_Server_Info *server, =
char *buffer)
>> =A0 =A0 =A0 return NULL;
>> =A0}
>>
>> +static void
>> +_cifs_add_credits(struct TCP_Server_Info *server, const unsigned in=
t add)
>> +{
>> + =A0 =A0 spin_lock(&server->req_lock);
>> + =A0 =A0 server->credits +=3D add;
>> + =A0 =A0 server->in_flight--;
>> + =A0 =A0 spin_unlock(&server->req_lock);
>> + =A0 =A0 wake_up(&server->request_q);
>> +}
>> +
>> +static void
>> +_cifs_set_credits(struct TCP_Server_Info *server, const int val)
>> +{
>> + =A0 =A0 spin_lock(&server->req_lock);
>> + =A0 =A0 server->credits =3D val;
>> + =A0 =A0 server->oplocks =3D val > 1 ? enable_oplocks : false;
>> + =A0 =A0 spin_unlock(&server->req_lock);
>> +}
>> +
>> +static int *
>> +cifs_get_credits_field(struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 return &server->credits;
>> +}
>> +
>> =A0struct smb_version_operations smb1_operations =3D {
>> =A0 =A0 =A0 .send_cancel =3D send_nt_cancel,
>> =A0 =A0 =A0 .compare_fids =3D cifs_compare_fids,
>> =A0 =A0 =A0 .setup_request =3D cifs_setup_request,
>> =A0 =A0 =A0 .check_receive =3D cifs_check_receive,
>> + =A0 =A0 .add_credits =3D _cifs_add_credits,
>> + =A0 =A0 .set_credits =3D _cifs_set_credits,
>> + =A0 =A0 .get_credits_field =3D cifs_get_credits_field,
>> =A0 =A0 =A0 .read_data_offset =3D cifs_read_data_offset,
>> =A0 =A0 =A0 .read_data_length =3D cifs_read_data_length,
>> =A0 =A0 =A0 .map_error =3D map_smb_to_linux_error,
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 87bd998..64c35fd 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -304,7 +304,8 @@ wait_for_free_credits(struct TCP_Server_Info *se=
rver, const int optype,
>> =A0static int
>> =A0wait_for_free_request(struct TCP_Server_Info *server, const int o=
ptype)
>> =A0{
>> - =A0 =A0 return wait_for_free_credits(server, optype, get_credits_f=
ield(server));
>> + =A0 =A0 return wait_for_free_credits(server, optype,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
server->ops->get_credits_field(server));
>> =A0}
>>
>> =A0static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_=
buf,
>
> Other than the minor nit above, this looks fine:
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I thought about it but decided to do it that way that lets us not
rename all caller places and makes the patch smaller. But of course I
don't object to rename it.

Steve, thoughts?

--=20
Best regards,
Pavel Shilovsky.
