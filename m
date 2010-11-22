From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Simplify ipv*_connect functions into one (try #2)
Date: Mon, 22 Nov 2010 22:26:59 +0300
Message-ID: <AANLkTi=V89tV62iyD+_DeSjwDBBVTfyfHMJ6t1mtBrCD@mail.gmail.com>
References: <1289893710-7352-1-git-send-email-piastryyy@gmail.com>
	<20101122120145.20989d38@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101122120145.20989d38-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/22 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Tue, 16 Nov 2010 10:48:29 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Make connect logic more ip-protocol independent. Also move RFC1001 s=
tuff into
>> separate function.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/connect.c | =A0314 ++++++++++++++++++++------------------=
---------------
>> =A01 files changed, 116 insertions(+), 198 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 251a17c..8bdf1cc 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -114,8 +114,8 @@ struct smb_vol {
>> =A0#define TLINK_ERROR_EXPIRE =A0 (1 * HZ)
>> =A0#define TLINK_IDLE_EXPIRE =A0 =A0(600 * HZ)
>>
>> -static int ipv4_connect(struct TCP_Server_Info *server);
>> -static int ipv6_connect(struct TCP_Server_Info *server);
>> +static int ip_connect(struct TCP_Server_Info *server);
>> +static int generic_ip_connect(struct TCP_Server_Info *server);
>> =A0static void tlink_rb_insert(struct rb_root *root, struct tcon_lin=
k *new_tlink);
>> =A0static void cifs_prune_tlinks(struct work_struct *work);
>>
>> @@ -199,10 +199,10 @@ cifs_reconnect(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 while ((server->tcpStatus !=3D CifsExiting) &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0(server->tcpStatus !=3D CifsGood)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 try_to_freeze();
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (server->addr.sockAddr6.sin6_family =3D=
=3D AF_INET6)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ipv6_connect(server=
);
>> - =A0 =A0 =A0 =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ipv4_connect(server=
);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* on reconnect we should try only the por=
t we connected
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0before */
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D generic_ip_connect(server);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "reconnect error=
 %d", rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(3000);
>> @@ -1668,12 +1668,11 @@ cifs_get_tcp_session(struct smb_vol *volume_=
info)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* other OS never observed in Wild doing=
 139 with v6 */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&tcp_ses->addr.sockAddr6, sin_ser=
ver6,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct sockaddr_i=
n6));
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ipv6_connect(tcp_ses);
>> - =A0 =A0 } else {
>> + =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&tcp_ses->addr.sockAddr, sin_serv=
er,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct sockaddr_i=
n));
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ipv4_connect(tcp_ses);
>> - =A0 =A0 }
>> +
>> + =A0 =A0 rc =3D ip_connect(tcp_ses);
>> =A0 =A0 =A0 if (rc < 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error connecting to socket. A=
borting operation");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err_crypto_release;
>> @@ -2121,19 +2120,97 @@ bind_socket(struct TCP_Server_Info *server)
>> =A0}
>>
>> =A0static int
>> -ipv4_connect(struct TCP_Server_Info *server)
>> +ip_rfc1001_connect(struct TCP_Server_Info *server)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 /* some servers require RFC1001 sessinit before sending
>> + =A0 =A0 negprot - BB check reconnection in case where second
>> + =A0 =A0 sessinit is sent but no second negprot */
>> + =A0 =A0 struct rfc1002_session_packet *ses_init_buf;
>> + =A0 =A0 struct smb_hdr *smb_buf;
>> + =A0 =A0 ses_init_buf =3D kzalloc(sizeof(struct rfc1002_session_pac=
ket),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KERNEL)=
;
>> + =A0 =A0 if (ses_init_buf) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.called_l=
en =3D 32;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (server->server_RFC1001_name &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->server_RFC1001_name[0] !=3D=
 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_buf=
->trailer.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 session_req.called_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 server->server_RFC1001_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 RFC1001_NAME_LEN_WITH_NULL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_buf=
->trailer.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 session_req.called_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 DEFAULT_CIFS_CALLED_NAME,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 RFC1001_NAME_LEN_WITH_NULL);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.calling_=
len =3D 32;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* calling name ends in null (byte 16) fro=
m old smb
>> + =A0 =A0 =A0 =A0 =A0 =A0 convention. */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (server->workstation_RFC1001_name &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->workstation_RFC1001_name[0=
] !=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_buf=
->trailer.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 session_req.calling_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 server->workstation_RFC1001_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 RFC1001_NAME_LEN_WITH_NULL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_buf=
->trailer.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 session_req.calling_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 "LINUX_CIFS_CLNT",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 RFC1001_NAME_LEN_WITH_NULL);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.scope1 =3D=
 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.scope2 =3D=
 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 smb_buf =3D (struct smb_hdr *)ses_init_buf=
;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* sizeof RFC1002_SESSION_REQUEST with no =
scope */
>> + =A0 =A0 =A0 =A0 =A0 =A0 smb_buf->smb_buf_length =3D 0x81000044;
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D smb_send(server, smb_buf, 0x44);
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses_init_buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 msleep(1); /* RFC1001 layer in at least on=
e server
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 requires very =
short break before negprot
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 presumably bec=
ause not expecting negprot
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to follow so f=
ast. =A0This is a simple
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 solution that =
works without
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 complicating t=
he code and causes no
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 significant sl=
owing down on mount
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for everyone e=
lse */
>> + =A0 =A0 }
>> + =A0 =A0 /* else the negprot may still work without this
>> + =A0 =A0 even though malloc failed */
>> +
>> + =A0 =A0 return rc;
>> +}
>> +
>> +static int
>> +generic_ip_connect(struct TCP_Server_Info *server)
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> - =A0 =A0 int val;
>> - =A0 =A0 bool connected =3D false;
>> - =A0 =A0 __be16 orig_port =3D 0;
>> + =A0 =A0 bool using_ipv6 =3D false;
>> + =A0 =A0 unsigned short int *sport;
>> + =A0 =A0 int slen;
>> =A0 =A0 =A0 struct socket *socket =3D server->ssocket;
>> + =A0 =A0 struct sockaddr *saddr;
>> +
>> + =A0 =A0 if (server->addr.sockAddr6.sin6_family =3D=3D AF_INET6) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 sport =3D &server->addr.sockAddr6.sin6_por=
t;
>> + =A0 =A0 =A0 =A0 =A0 =A0 using_ipv6 =3D true;
>> + =A0 =A0 =A0 =A0 =A0 =A0 slen =3D sizeof(struct sockaddr_in6);
>> + =A0 =A0 =A0 =A0 =A0 =A0 saddr =3D (struct sockaddr *) &server->add=
r.sockAddr6;
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 sport =3D &server->addr.sockAddr.sin_port;
>> + =A0 =A0 =A0 =A0 =A0 =A0 slen =3D sizeof(struct sockaddr_in);
>> + =A0 =A0 =A0 =A0 =A0 =A0 saddr =3D (struct sockaddr *) &server->add=
r.sockAddr;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 if (socket =3D=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D sock_create_kern(PF_INET, SOCK_ST=
REAM,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 IPPROTO_TCP, &socket);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^
> I finally got a chance to give this a try today. It's broken due to t=
he
> above statement. If we get an IPv6 address, we need to set the family
> correctly in sock_create_kern.
>
> Pavel, care to fix this?

No problem. Should I create separate patch or change this one?
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d crea=
ting socket", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->ssocket =3D NULL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> @@ -2141,59 +2218,24 @@ ipv4_connect(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Socket created");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->ssocket =3D socket;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 socket->sk->sk_allocation =3D GFP_NOFS;
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_reclassify_socket4(socket);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (using_ipv6)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reclassify_socket6(so=
cket);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reclassify_socket4(so=
cket);
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 rc =3D bind_socket(server);
>> =A0 =A0 =A0 if (rc < 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> - =A0 =A0 /* user overrode default port */
>> - =A0 =A0 if (server->addr.sockAddr.sin_port) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(socket, (struc=
t sockaddr *)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &server->addr.sockAddr,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct sockaddr_in), 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =3D true;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 if (!connected) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* save original port so we can retry user=
 specified port
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 later if fall back ports f=
ail this time =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 orig_port =3D server->addr.sockAddr.sin_po=
rt;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* do not retry on the same port we just f=
ailed on */
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (server->addr.sockAddr.sin_port !=3D ht=
ons(CIFS_PORT)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr.sin_=
port =3D htons(CIFS_PORT);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connec=
t(socket,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 (struct sockaddr *)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 &server->addr.sockAddr,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 sizeof(struct sockaddr_in), 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =
=3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 }
>> - =A0 =A0 if (!connected) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr.sin_port =3D htons(R=
=46C1001_PORT);
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(socket, (struc=
t sockaddr *)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 &server->addr.sockAddr,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 sizeof(struct sockaddr_in), 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =3D true;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 /* give up here - unless we want to retry on different
>> - =A0 =A0 =A0 =A0 =A0 =A0 protocol families some day */
>> - =A0 =A0 if (!connected) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (orig_port)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr.sin_=
port =3D orig_port;
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error %d connecting to server via=
 ipv4", rc);
>> + =A0 =A0 rc =3D socket->ops->connect(socket, saddr, slen, 0);
>> + =A0 =A0 if (rc < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error %d connecting to server", r=
c);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sock_release(socket);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->ssocket =3D NULL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> -
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* Eventually check for other socket options to change=
 from
>> =A0 =A0 =A0 =A0* =A0the default. sock_setsockopt not used because it=
 expects
>> @@ -2211,7 +2253,7 @@ ipv4_connect(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 if (server->tcp_nodelay) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 val =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 int val =3D 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D kernel_setsockopt(socket, SOL_TCP=
, TCP_NODELAY,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)=
&val, sizeof(val));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> @@ -2222,161 +2264,37 @@ ipv4_connect(struct TCP_Server_Info *server=
)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0socket->sk->sk_sndbuf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0socket->sk->sk_rcvbuf, socket->sk->sk=
_rcvtimeo);
>>
>> - =A0 =A0 /* send RFC1001 sessinit */
>> - =A0 =A0 if (server->addr.sockAddr.sin_port =3D=3D htons(RFC1001_PO=
RT)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* some servers require RFC1001 sessinit b=
efore sending
>> - =A0 =A0 =A0 =A0 =A0 =A0 negprot - BB check reconnection in case wh=
ere second
>> - =A0 =A0 =A0 =A0 =A0 =A0 sessinit is sent but no second negprot */
>> - =A0 =A0 =A0 =A0 =A0 =A0 struct rfc1002_session_packet *ses_init_bu=
f;
>> - =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *smb_buf;
>> - =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf =3D kzalloc(sizeof(struct rfc=
1002_session_packet),
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0GFP_KERNEL);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (ses_init_buf) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.sess=
ion_req.called_len =3D 32;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->server_RFC1001=
_name &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->server_RFC=
1001_name[0] !=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002man=
gle(ses_init_buf->trailer.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 session_req.called_name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 server->server_RFC1001_name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 RFC1001_NAME_LEN_WITH_NULL);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002man=
gle(ses_init_buf->trailer.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 session_req.called_name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 DEFAULT_CIFS_CALLED_NAME,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 RFC1001_NAME_LEN_WITH_NULL);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.sess=
ion_req.calling_len =3D 32;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calling name ends in nu=
ll (byte 16) from old smb
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 convention. */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->workstation_RF=
C1001_name &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->workstatio=
n_RFC1001_name[0] !=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002man=
gle(ses_init_buf->trailer.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 session_req.calling_name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 server->workstation_RFC1001_name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 RFC1001_NAME_LEN_WITH_NULL);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002man=
gle(ses_init_buf->trailer.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 session_req.calling_name,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 "LINUX_CIFS_CLNT",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 RFC1001_NAME_LEN_WITH_NULL);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.sess=
ion_req.scope1 =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.sess=
ion_req.scope2 =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_buf =3D (struct smb_hd=
r *)ses_init_buf;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* sizeof RFC1002_SESSION_=
REQUEST with no scope */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_buf->smb_buf_length =3D=
 0x81000044;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D smb_send(server, sm=
b_buf, 0x44);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses_init_buf);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(1); /* RFC1001 laye=
r in at least one server
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 requires very short break before negprot
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 presumably because not expecting negprot
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 to follow so fast. =A0This is a simple
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 solution that works without
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 complicating the code and causes no
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 significant slowing down on mount
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 for everyone else */
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* else the negprot may still work without=
 this
>> - =A0 =A0 =A0 =A0 =A0 =A0 even though malloc failed */
>> -
>> - =A0 =A0 }
>> + =A0 =A0 if (*sport =3D=3D htons(RFC1001_PORT))
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ip_rfc1001_connect(server);
>>
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> =A0static int
>> -ipv6_connect(struct TCP_Server_Info *server)
>> +ip_connect(struct TCP_Server_Info *server)
>> =A0{
>> - =A0 =A0 int rc =3D 0;
>> - =A0 =A0 int val;
>> - =A0 =A0 bool connected =3D false;
>> - =A0 =A0 __be16 orig_port =3D 0;
>> - =A0 =A0 struct socket *socket =3D server->ssocket;
>> + =A0 =A0 unsigned short int *sport;
>>
>> - =A0 =A0 if (socket =3D=3D NULL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D sock_create_kern(PF_INET6, SOCK_STR=
EAM,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 IPPROTO_TCP, &socket);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d creati=
ng ipv6 socket", rc);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 socket =3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 if (server->addr.sockAddr6.sin6_family =3D=3D AF_INET6)
>> + =A0 =A0 =A0 =A0 =A0 =A0 sport =3D &server->addr.sockAddr6.sin6_por=
t;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 sport =3D &server->addr.sockAddr.sin_port;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* BB other socket options to set KEEPALIV=
E, NODELAY? */
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "ipv6 Socket created");
>> - =A0 =A0 =A0 =A0 =A0 =A0 server->ssocket =3D socket;
>> - =A0 =A0 =A0 =A0 =A0 =A0 socket->sk->sk_allocation =3D GFP_NOFS;
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_reclassify_socket6(socket);
>> - =A0 =A0 }
>> + =A0 =A0 if (*sport =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 int rc;
>>
>> - =A0 =A0 rc =3D bind_socket(server);
>> - =A0 =A0 if (rc < 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* try with 445 port at first */
>> + =A0 =A0 =A0 =A0 =A0 =A0 *sport =3D htons(CIFS_PORT);
>>
>> - =A0 =A0 /* user overrode default port */
>> - =A0 =A0 if (server->addr.sockAddr6.sin6_port) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(socket,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct so=
ckaddr *) &server->addr.sockAddr6,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(str=
uct sockaddr_in6), 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D generic_ip_connect(server);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =3D true;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 if (!connected) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* save original port so we can retry user=
 specified port
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 later if fall back ports f=
ail this time =A0*/
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 orig_port =3D server->addr.sockAddr6.sin6_=
port;
>> - =A0 =A0 =A0 =A0 =A0 =A0 /* do not retry on the same port we just f=
ailed on */
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (server->addr.sockAddr6.sin6_port !=3D =
htons(CIFS_PORT)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr6.sin=
6_port =3D htons(CIFS_PORT);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connec=
t(socket, (struct sockaddr *)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &server->addr.sockAddr6,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sizeof(struct sockaddr_in6), 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =
=3D true;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 }
>> - =A0 =A0 if (!connected) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr6.sin6_port =3D htons=
(RFC1001_PORT);
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(socket, (struc=
t sockaddr *)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &server->a=
ddr.sockAddr6,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(str=
uct sockaddr_in6), 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =3D true;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 /* give up here - unless we want to retry on different
>> - =A0 =A0 =A0 =A0 =A0 =A0 protocol families some day */
>> - =A0 =A0 if (!connected) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (orig_port)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr6.sin=
6_port =3D orig_port;
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error %d connecting to server via=
 ipv6", rc);
>> - =A0 =A0 =A0 =A0 =A0 =A0 sock_release(socket);
>> - =A0 =A0 =A0 =A0 =A0 =A0 server->ssocket =3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* Eventually check for other socket options to change f=
rom
>> - =A0 =A0 =A0* the default. sock_setsockopt not used because it expe=
cts
>> - =A0 =A0 =A0* user space buffer
>> - =A0 =A0 =A0*/
>> - =A0 =A0 socket->sk->sk_rcvtimeo =3D 7 * HZ;
>> - =A0 =A0 socket->sk->sk_sndtimeo =3D 5 * HZ;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> - =A0 =A0 if (server->tcp_nodelay) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 val =3D 1;
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D kernel_setsockopt(socket, SOL_TCP, =
TCP_NODELAY,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)&v=
al, sizeof(val));
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "set TCP_NODELAY s=
ocket option error %d", rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* if it failed, try with 139 port */
>> + =A0 =A0 =A0 =A0 =A0 =A0 *sport =3D htons(RFC1001_PORT);
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 server->ssocket =3D socket;
>> -
>> - =A0 =A0 return rc;
>> + =A0 =A0 return generic_ip_connect(server);
>> =A0}
>>
>> =A0void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
