From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS} [1/3] NTLM auth & signing - Allocate session
 key/client response dynamically
Date: Wed, 20 Oct 2010 10:20:39 -0500
Message-ID: <AANLkTinFjLwoFsVkKfYuBR0fseQ4=BLWC+bXfoYXh8j3@mail.gmail.com>
References: <1287533637-22367-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101020104539.5a17a03e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101020104539.5a17a03e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 20, 2010 at 9:45 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 19 Oct 2010 19:13:57 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Start calculation auth response within a session. =A0Move/Add pertin=
et
>> data structures like session key, server challenge and ntlmv2_hash i=
n
>> a session structure. =A0We should do the calculations within a sessi=
on
>> before copying session key and response over to server data
>> structures because a session setup can fail.
>>
>> Only after a very first smb session succeeds, it copy/make its
>> session key, session key of smb connection. =A0This key stays with
>> the smb connection throughout its life.
>>
>> The authentication response field within structure session_key
>> is now dynamic. =A0Every authentication type allocates the response =
sized
>> memory within its session structure and later frees it once the
>> client response is sent and if session's session key becomes
>> connetion's session key.
>>
>> ntlm/ntlmi authentication functions are rearranged. =A0A function
>> named setup_ntlm_resp(), similar to setup_ntlmv2_resp(), replaces
>> function cifs_calculate_session_key().
>>
>> size of CIFS_SESS_KEY_SIZE is changed to 16, to reflect the byte siz=
e
>> of the key it holds.
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsencrypt.c | =A0 99 +++++++++++++++++++++++++---------=
-------------
>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 10 +----
>> =A0fs/cifs/cifspdu.h =A0 =A0 | =A0 =A07 +++-
>> =A0fs/cifs/cifsproto.h =A0 | =A0 11 ++---
>> =A0fs/cifs/connect.c =A0 =A0 | =A0 33 ++++++++++++++--
>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0103 +++++++++++++++++++-------=
-----------------------
>> =A0fs/cifs/transport.c =A0 | =A0 =A06 +-
>> =A07 files changed, 137 insertions(+), 132 deletions(-)
>>
>
> [...]
>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 18ee0ad..c374859 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -98,15 +98,9 @@ enum protocolEnum {
>> =A0};
>>
>> =A0struct session_key {
>> + =A0 =A0 char key[16];
>> + =A0 =A0 char *response;
> =A0 =A0 =A0 =A0^^^^^^^
> =A0 =A0 =A0 =A0What's the point of keeping the key separate from the =
response?
> =A0 =A0 =A0 =A0If you'll always need to allocate memory for the respo=
nse, why
> =A0 =A0 =A0 =A0not allocate the key too as part of the same allocatio=
n?
>
>> =A0 =A0 =A0 unsigned int len;
>> - =A0 =A0 union {
>> - =A0 =A0 =A0 =A0 =A0 =A0 char ntlm[CIFS_SESS_KEY_SIZE + 16];
>> - =A0 =A0 =A0 =A0 =A0 =A0 char krb5[CIFS_SESS_KEY_SIZE + 16]; /* BB:=
 length correct? */
>> - =A0 =A0 =A0 =A0 =A0 =A0 struct {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char key[16];
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ntlmv2_resp resp;
>> - =A0 =A0 =A0 =A0 =A0 =A0 } ntlmv2;
>> - =A0 =A0 } data;
>> =A0};
>>
>> =A0struct cifs_cred {
>> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
>> index b0f4b56..a152cd6 100644
>> --- a/fs/cifs/cifspdu.h
>> +++ b/fs/cifs/cifspdu.h
>> @@ -131,9 +131,14 @@
>> =A0#define CIFS_CRYPTO_KEY_SIZE (8)
>>
>> =A0/*
>> + * Size of the ntlm client response
>> + */
>> +#define CIFS_AUTH_RESP_SIZE (24)
>> +
>> +/*
>> =A0 * Size of the session key (crypto key encrypted with the passwor=
d
>> =A0 */
>> -#define CIFS_SESS_KEY_SIZE (24)
>> +#define CIFS_SESS_KEY_SIZE (16)
>>
>> =A0/*
>> =A0 * Maximum user name length
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index e593c40..8c2d0cf 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -362,13 +362,12 @@ extern int cifs_sign_smb(struct smb_hdr *, str=
uct TCP_Server_Info *, __u32 *);
>> =A0extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP=
_Server_Info *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 *);
>> =A0extern int cifs_verify_signature(struct smb_hdr *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const s=
truct session_key *session_key,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct =
TCP_Server_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ex=
pected_sequence_number);
>> -extern int cifs_calculate_session_key(struct session_key *key, cons=
t char *rn,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const c=
har *pass);
>> -extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *)=
;
>> -extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nl=
s_table *);
>> +extern void SMBNTencrypt(unsigned char *, unsigned char *, unsigned=
 char *);
>> +extern int setup_ntlm_response(struct cifsSesInfo *);
>> +extern void CalcNTLMv2_response(const struct cifsSesInfo *);
>> +extern int setup_ntlmv2_rsp(struct cifsSesInfo *, const struct nls_=
table *);
>> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
>> =A0extern void calc_lanman_hash(const char *password, const char *cr=
yptkey,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool enc=
rypt, char *lnm_session_key);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 019f003..1006dec 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -175,6 +175,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 server->sequence_number =3D 0;
>> =A0 =A0 =A0 server->session_estab =3D false;
>> + =A0 =A0 kfree(server->session_key.response);
>> + =A0 =A0 server->session_key.response =3D NULL;
>> + =A0 =A0 server->session_key.len =3D 0;
>>
>> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> =A0 =A0 =A0 list_for_each(tmp, &server->pending_mid_q) {
>> @@ -1562,6 +1565,10 @@ cifs_put_tcp_session(struct TCP_Server_Info *=
server)
>>
>> =A0 =A0 =A0 cifs_fscache_release_client_cookie(server);
>>
>> + =A0 =A0 kfree(server->session_key.response);
>> + =A0 =A0 server->session_key.response =3D NULL;
>> + =A0 =A0 server->session_key.len =3D 0;
>> +
>> =A0 =A0 =A0 task =3D xchg(&server->tsk, NULL);
>> =A0 =A0 =A0 if (task)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 force_sig(SIGKILL, task);
>> @@ -3162,6 +3169,7 @@ int cifs_setup_session(unsigned int xid, struc=
t cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct nls_table *nls_in=
fo)
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> + =A0 =A0 unsigned int len;
>> =A0 =A0 =A0 struct TCP_Server_Info *server =3D ses->server;
>>
>> =A0 =A0 =A0 ses->flags =3D 0;
>> @@ -3178,10 +3186,22 @@ int cifs_setup_session(unsigned int xid, str=
uct cifsSesInfo *ses,
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&ses->server->srv_mutex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!server->session_estab) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&server->session_ke=
y.data,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &ses->auth=
_key.data, ses->auth_key.len);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len =3D=
 ses->auth_key.len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->session_estab=
 =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->secType =3D=3D=
 RawNTLMSSP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D 16=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^=
^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Why is this special-ca=
sed here? Does the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0auth_key have an incor=
rect len field in the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0RawNTLMSSP case?
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D se=
s->auth_key.len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.respon=
se =3D kmalloc(len, GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!server->session_key.r=
esponse) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EN=
OMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlo=
ck(&server->srv_mutex);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_=
setup_session_ret;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(server->session_key=
=2Eresponse,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_=
key.response, len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(server->session_key=
=2Ekey,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_=
key.key, 16);
>
> Hmmm...you're going to be freeing ses->auth_key.response below.
> Wouldn't it make more sense to just "hand-off" the pointer to the
> response field instead? For instance:
>
> =A0 =A0 =A0 =A0server->session_key.response =3D ses->auth_key.respons=
e;
> =A0 =A0 =A0 =A0ses->auth_key.response =3D NULL;
> =A0 =A0 =A0 =A0ses->auth_key.len =3D 0;
>
> Then you don't have to deal with an error condition, etc...
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_key.len =3D=
 len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->session_estab =3D =
true;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>>
>> @@ -3192,6 +3212,11 @@ int cifs_setup_session(unsigned int xid, stru=
ct cifsSesInfo *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> =A0 =A0 =A0 }
>>
>> +cifs_setup_session_ret:
>> + =A0 =A0 kfree(ses->auth_key.response);
>> + =A0 =A0 ses->auth_key.response =3D NULL;
>> + =A0 =A0 ses->auth_key.len =3D 0;
>> +
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index e35dc60..8bb4518 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>
> [...]
>
>> @@ -785,16 +756,24 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EKEYREJECTED;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 resplen =3D CIFS_SESS_KEY_SIZE + CIFS_AUTH=
_RESP_SIZE;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* bail out if key is too long */
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (msg->sesskey_len >
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(ses->auth_key.data.krb5)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (msg->sesskey_len > resplen) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Kerberos sign=
ing key too long (%u bytes)",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msg->ses=
skey_len);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOVERFLOW;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.response =3D kmalloc(resplen=
, GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ses->auth_key.response) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Kerberos can't =
allocate (%u bytes) memory",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 resplen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ssetup_exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->auth_key.len =3D msg->sesskey_len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->auth_key.data.krb5, msg->data,=
 msg->sesskey_len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->auth_key.response, msg->data, =
msg->sesskey_len);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0This looks questionable. Previously we=
 had a fixed 40
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0byte field for the krb5 key (CIFS_SESS=
_KEY_SIZE (24) +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A016). Now, we have a 16 byte key and a =
40-byte response field
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(CIFS_SESS_KEY_SIZE (16) + CIFS_AUTH_R=
ESP_SIZE (24)),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0You're copying the data into the auth_=
key.response but
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0the auth_key.key seems to be unused. W=
on't that mean
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that signing is broken?
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0I suppose you could copy the first 16 =
bytes into the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0key part and then stick the rest into =
the response
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0field, but that seems sort of kludgey.=
 It would make
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0more sense to have the session_key jus=
t be a length and
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0a pointer to memory allocated off the =
slab and do away
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0with the fixed-length key[16] field.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Then when you want to access the key/r=
esponse, just
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cast that pointer to a struct that has=
 the fields you
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0need.
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.hdr.Flags2 |=3D SMBFLG2_EXT_SE=
C;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 capabilities |=3D CAP_EXTENDED_SECURITY;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req.Capabilities =3D cpu_to_le32(c=
apabilities);
>> @@ -897,8 +876,6 @@ ssetup_ntlmssp_authenticate:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_STD_OP /* not l=
ong */ | CIFS_LOG_ERROR);
>> =A0 =A0 =A0 /* SMB request buf freed in SendReceive2 */
>>
>> - =A0 =A0 cFYI(1, "ssetup rc from sendrecv2 is %d", rc);
>> -
>> =A0 =A0 =A0 pSMB =3D (SESSION_SETUP_ANDX *)iov[0].iov_base;
>> =A0 =A0 =A0 smb_buf =3D (struct smb_hdr *)iov[0].iov_base;
>>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

So we can say

=46or ntlm and ntlmv2 - both key (16 bytes) and response (24 bytes in
case of ntlm and variable bytes in case of ntlmv2) are needed for
signing

=46or ntlmv2 within ntlmssp (RawNTLMSSP) - only key (16 bytes) is neede=
d
for signing

=46or Kerberos - only response (40 bytes) is needed for signing.
