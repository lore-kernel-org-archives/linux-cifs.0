From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Simplify ipv*_connect functions into one (try #2)
Date: Tue, 16 Nov 2010 22:28:09 +0300
Message-ID: <AANLkTi=n1FfwWuwS5w2KdLgHtV_v4vjuF5XF5R7z9x-d@mail.gmail.com>
References: <1289893710-7352-1-git-send-email-piastryyy@gmail.com>
	<20101116131755.37043f53@corrin.poochiereds.net>
	<20101116132500.7865f16b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101116132500.7865f16b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/16 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 16 Nov 2010 13:17:55 -0500
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Tue, 16 Nov 2010 10:48:29 +0300
>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > Make connect logic more ip-protocol independent. Also move RFC1001=
 stuff into
>> > separate function.
>> >
>> > Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > ---
>> > =A0fs/cifs/connect.c | =A0314 ++++++++++++++++++++----------------=
-----------------
>> > =A01 files changed, 116 insertions(+), 198 deletions(-)
>> >
>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > index 251a17c..8bdf1cc 100644
>> > --- a/fs/cifs/connect.c
>> > +++ b/fs/cifs/connect.c
>> > @@ -114,8 +114,8 @@ struct smb_vol {
>> > =A0#define TLINK_ERROR_EXPIRE (1 * HZ)
>> > =A0#define TLINK_IDLE_EXPIRE =A0(600 * HZ)
>> >
>> > -static int ipv4_connect(struct TCP_Server_Info *server);
>> > -static int ipv6_connect(struct TCP_Server_Info *server);
>> > +static int ip_connect(struct TCP_Server_Info *server);
>> > +static int generic_ip_connect(struct TCP_Server_Info *server);
>> > =A0static void tlink_rb_insert(struct rb_root *root, struct tcon_l=
ink *new_tlink);
>> > =A0static void cifs_prune_tlinks(struct work_struct *work);
>> >
>> > @@ -199,10 +199,10 @@ cifs_reconnect(struct TCP_Server_Info *serve=
r)
>> > =A0 =A0 while ((server->tcpStatus !=3D CifsExiting) &&
>> > =A0 =A0 =A0 =A0 =A0 =A0(server->tcpStatus !=3D CifsGood)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 try_to_freeze();
>> > - =A0 =A0 =A0 =A0 =A0 if (server->addr.sockAddr6.sin6_family =3D=3D=
 AF_INET6)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ipv6_connect(server);
>> > - =A0 =A0 =A0 =A0 =A0 else
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ipv4_connect(server);
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 /* on reconnect we should try only the port =
we connected
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0before */
>> > + =A0 =A0 =A0 =A0 =A0 rc =3D generic_ip_connect(server);
>> > =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "reconnect error %=
d", rc);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(3000);
>> > @@ -1668,12 +1668,11 @@ cifs_get_tcp_session(struct smb_vol *volum=
e_info)
>> > =A0 =A0 =A0 =A0 =A0 =A0 /* other OS never observed in Wild doing 1=
39 with v6 */
>> > =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&tcp_ses->addr.sockAddr6, sin_serve=
r6,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct sockaddr_in6=
));
>> > - =A0 =A0 =A0 =A0 =A0 rc =3D ipv6_connect(tcp_ses);
>> > - =A0 } else {
>> > + =A0 } else
>> > =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&tcp_ses->addr.sockAddr, sin_server=
,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct sockaddr_in)=
);
>> > - =A0 =A0 =A0 =A0 =A0 rc =3D ipv4_connect(tcp_ses);
>> > - =A0 }
>> > +
>> > + =A0 rc =3D ip_connect(tcp_ses);
>> > =A0 =A0 if (rc < 0) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error connecting to socket. Abo=
rting operation");
>> > =A0 =A0 =A0 =A0 =A0 =A0 goto out_err_crypto_release;
>> > @@ -2121,19 +2120,97 @@ bind_socket(struct TCP_Server_Info *server=
)
>> > =A0}
>> >
>> > =A0static int
>> > -ipv4_connect(struct TCP_Server_Info *server)
>> > +ip_rfc1001_connect(struct TCP_Server_Info *server)
>> > +{
>> > + =A0 int rc =3D 0;
>> > + =A0 /* some servers require RFC1001 sessinit before sending
>> > + =A0 negprot - BB check reconnection in case where second
>> > + =A0 sessinit is sent but no second negprot */
>> > + =A0 struct rfc1002_session_packet *ses_init_buf;
>> > + =A0 struct smb_hdr *smb_buf;
>> > + =A0 ses_init_buf =3D kzalloc(sizeof(struct rfc1002_session_packe=
t),
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KERNEL);
>> > + =A0 if (ses_init_buf) {
>> > + =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.called_len=
 =3D 32;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 if (server->server_RFC1001_name &&
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->server_RFC1001_name[0] !=3D =
0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_buf->=
trailer.
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
session_req.called_name,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
server->server_RFC1001_name,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
RFC1001_NAME_LEN_WITH_NULL);
>> > + =A0 =A0 =A0 =A0 =A0 else
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_buf->=
trailer.
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
session_req.called_name,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
DEFAULT_CIFS_CALLED_NAME,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
RFC1001_NAME_LEN_WITH_NULL);
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.calling_le=
n =3D 32;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 /* calling name ends in null (byte 16) from =
old smb
>> > + =A0 =A0 =A0 =A0 =A0 convention. */
>> > + =A0 =A0 =A0 =A0 =A0 if (server->workstation_RFC1001_name &&
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->workstation_RFC1001_name[0] =
!=3D 0)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_buf->=
trailer.
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
session_req.calling_name,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
server->workstation_RFC1001_name,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
RFC1001_NAME_LEN_WITH_NULL);
>> > + =A0 =A0 =A0 =A0 =A0 else
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_buf->=
trailer.
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
session_req.calling_name,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
"LINUX_CIFS_CLNT",
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
RFC1001_NAME_LEN_WITH_NULL);
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.scope1 =3D=
 0;
>> > + =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.scope2 =3D=
 0;
>> > + =A0 =A0 =A0 =A0 =A0 smb_buf =3D (struct smb_hdr *)ses_init_buf;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 /* sizeof RFC1002_SESSION_REQUEST with no sc=
ope */
>> > + =A0 =A0 =A0 =A0 =A0 smb_buf->smb_buf_length =3D 0x81000044;
>> > + =A0 =A0 =A0 =A0 =A0 rc =3D smb_send(server, smb_buf, 0x44);
>> > + =A0 =A0 =A0 =A0 =A0 kfree(ses_init_buf);
>> > + =A0 =A0 =A0 =A0 =A0 msleep(1); /* RFC1001 layer in at least one =
server
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 requires very sh=
ort break before negprot
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 presumably becau=
se not expecting negprot
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to follow so fas=
t. =A0This is a simple
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 solution that wo=
rks without
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 complicating the=
 code and causes no
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 significant slow=
ing down on mount
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for everyone els=
e */
>> > + =A0 }
>> > + =A0 /* else the negprot may still work without this
>> > + =A0 even though malloc failed */
>> > +
>> > + =A0 return rc;
>> > +}
>> > +
>> > +static int
>> > +generic_ip_connect(struct TCP_Server_Info *server)
>> > =A0{
>> > =A0 =A0 int rc =3D 0;
>> > - =A0 int val;
>> > - =A0 bool connected =3D false;
>> > - =A0 __be16 orig_port =3D 0;
>> > + =A0 bool using_ipv6 =3D false;
>> > + =A0 unsigned short int *sport;
>> > + =A0 int slen;
>> > =A0 =A0 struct socket *socket =3D server->ssocket;
>> > + =A0 struct sockaddr *saddr;
>> > +
>> > + =A0 if (server->addr.sockAddr6.sin6_family =3D=3D AF_INET6) {
>> > + =A0 =A0 =A0 =A0 =A0 sport =3D &server->addr.sockAddr6.sin6_port;
>> > + =A0 =A0 =A0 =A0 =A0 using_ipv6 =3D true;
>> > + =A0 =A0 =A0 =A0 =A0 slen =3D sizeof(struct sockaddr_in6);
>> > + =A0 =A0 =A0 =A0 =A0 saddr =3D (struct sockaddr *) &server->addr.=
sockAddr6;
>> > + =A0 } else {
>> > + =A0 =A0 =A0 =A0 =A0 sport =3D &server->addr.sockAddr.sin_port;
>> > + =A0 =A0 =A0 =A0 =A0 slen =3D sizeof(struct sockaddr_in);
>> > + =A0 =A0 =A0 =A0 =A0 saddr =3D (struct sockaddr *) &server->addr.=
sockAddr;
>> > + =A0 }
>> >
>> > =A0 =A0 if (socket =3D=3D NULL) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 rc =3D sock_create_kern(PF_INET, SOCK_STRE=
AM,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 IPPROTO_TCP, &socket);
>> > =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d creati=
ng socket", rc);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->ssocket =3D NULL;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> > =A0 =A0 =A0 =A0 =A0 =A0 }
>> >
>> > @@ -2141,59 +2218,24 @@ ipv4_connect(struct TCP_Server_Info *serve=
r)
>> > =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Socket created");
>> > =A0 =A0 =A0 =A0 =A0 =A0 server->ssocket =3D socket;
>> > =A0 =A0 =A0 =A0 =A0 =A0 socket->sk->sk_allocation =3D GFP_NOFS;
>> > - =A0 =A0 =A0 =A0 =A0 cifs_reclassify_socket4(socket);
>> > + =A0 =A0 =A0 =A0 =A0 if (using_ipv6)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reclassify_socket6(sock=
et);
>> > + =A0 =A0 =A0 =A0 =A0 else
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reclassify_socket4(sock=
et);
>> > =A0 =A0 }
>> >
>> > =A0 =A0 rc =3D bind_socket(server);
>> > =A0 =A0 if (rc < 0)
>> > =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> >
>> > - =A0 /* user overrode default port */
>> > - =A0 if (server->addr.sockAddr.sin_port) {
>> > - =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(socket, (struct =
sockaddr *)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 &server->addr.sockAddr,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 sizeof(struct sockaddr_in), 0);
>> > - =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =3D true;
>> > - =A0 }
>> > -
>> > - =A0 if (!connected) {
>> > - =A0 =A0 =A0 =A0 =A0 /* save original port so we can retry user s=
pecified port
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 later if fall back ports fai=
l this time =A0*/
>> > - =A0 =A0 =A0 =A0 =A0 orig_port =3D server->addr.sockAddr.sin_port=
;
>> > -
>> > - =A0 =A0 =A0 =A0 =A0 /* do not retry on the same port we just fai=
led on */
>> > - =A0 =A0 =A0 =A0 =A0 if (server->addr.sockAddr.sin_port !=3D hton=
s(CIFS_PORT)) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr.sin_po=
rt =3D htons(CIFS_PORT);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(=
socket,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 (struct sockaddr *)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 &server->addr.sockAddr,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 sizeof(struct sockaddr_in), 0);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =3D=
 true;
>> > - =A0 =A0 =A0 =A0 =A0 }
>> > - =A0 }
>> > - =A0 if (!connected) {
>> > - =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr.sin_port =3D htons(RFC=
1001_PORT);
>> > - =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(socket, (struct =
sockaddr *)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 &server->addr.sockAddr,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 sizeof(struct sockaddr_in), 0);
>> > - =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =3D true;
>> > - =A0 }
>> > -
>> > - =A0 /* give up here - unless we want to retry on different
>> > - =A0 =A0 =A0 =A0 =A0 protocol families some day */
>> > - =A0 if (!connected) {
>> > - =A0 =A0 =A0 =A0 =A0 if (orig_port)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr.sin_po=
rt =3D orig_port;
>> > - =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error %d connecting to server via i=
pv4", rc);
>> > + =A0 rc =3D socket->ops->connect(socket, saddr, slen, 0);
>> > + =A0 if (rc < 0) {
>> > + =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error %d connecting to server", rc)=
;
>> > =A0 =A0 =A0 =A0 =A0 =A0 sock_release(socket);
>> > =A0 =A0 =A0 =A0 =A0 =A0 server->ssocket =3D NULL;
>> > =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> > =A0 =A0 }
>> >
>> > -
>> > =A0 =A0 /*
>> > =A0 =A0 =A0* Eventually check for other socket options to change f=
rom
>> > =A0 =A0 =A0* =A0the default. sock_setsockopt not used because it e=
xpects
>> > @@ -2211,7 +2253,7 @@ ipv4_connect(struct TCP_Server_Info *server)
>> > =A0 =A0 }
>> >
>> > =A0 =A0 if (server->tcp_nodelay) {
>> > - =A0 =A0 =A0 =A0 =A0 val =3D 1;
>> > + =A0 =A0 =A0 =A0 =A0 int val =3D 1;
>> > =A0 =A0 =A0 =A0 =A0 =A0 rc =3D kernel_setsockopt(socket, SOL_TCP, =
TCP_NODELAY,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)&v=
al, sizeof(val));
>> > =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> > @@ -2222,161 +2264,37 @@ ipv4_connect(struct TCP_Server_Info *serv=
er)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0socket->sk->sk_sndbuf,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0socket->sk->sk_rcvbuf, socket->sk->sk_r=
cvtimeo);
>> >
>> > - =A0 /* send RFC1001 sessinit */
>> > - =A0 if (server->addr.sockAddr.sin_port =3D=3D htons(RFC1001_PORT=
)) {
>> > - =A0 =A0 =A0 =A0 =A0 /* some servers require RFC1001 sessinit bef=
ore sending
>> > - =A0 =A0 =A0 =A0 =A0 negprot - BB check reconnection in case wher=
e second
>> > - =A0 =A0 =A0 =A0 =A0 sessinit is sent but no second negprot */
>> > - =A0 =A0 =A0 =A0 =A0 struct rfc1002_session_packet *ses_init_buf;
>> > - =A0 =A0 =A0 =A0 =A0 struct smb_hdr *smb_buf;
>> > - =A0 =A0 =A0 =A0 =A0 ses_init_buf =3D kzalloc(sizeof(struct rfc10=
02_session_packet),
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0GFP_KERNEL);
>> > - =A0 =A0 =A0 =A0 =A0 if (ses_init_buf) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.sessio=
n_req.called_len =3D 32;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->server_RFC1001_n=
ame &&
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->server_RFC10=
01_name[0] !=3D 0)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangl=
e(ses_init_buf->trailer.
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 session_req.called_name,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 server->server_RFC1001_name,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 RFC1001_NAME_LEN_WITH_NULL);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangl=
e(ses_init_buf->trailer.
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 session_req.called_name,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 DEFAULT_CIFS_CALLED_NAME,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 RFC1001_NAME_LEN_WITH_NULL);
>> > -
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.sessio=
n_req.calling_len =3D 32;
>> > -
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calling name ends in null=
 (byte 16) from old smb
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 convention. */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->workstation_RFC1=
001_name &&
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->workstation_=
RFC1001_name[0] !=3D 0)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangl=
e(ses_init_buf->trailer.
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 session_req.calling_name,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 server->workstation_RFC1001_name,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 RFC1001_NAME_LEN_WITH_NULL);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangl=
e(ses_init_buf->trailer.
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 session_req.calling_name,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 "LINUX_CIFS_CLNT",
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 RFC1001_NAME_LEN_WITH_NULL);
>> > -
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.sessio=
n_req.scope1 =3D 0;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.sessio=
n_req.scope2 =3D 0;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_buf =3D (struct smb_hdr =
*)ses_init_buf;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* sizeof RFC1002_SESSION_RE=
QUEST with no scope */
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_buf->smb_buf_length =3D =
0x81000044;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D smb_send(server, smb_=
buf, 0x44);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses_init_buf);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(1); /* RFC1001 layer =
in at least one server
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
requires very short break before negprot
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
presumably because not expecting negprot
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
to follow so fast. =A0This is a simple
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
solution that works without
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
complicating the code and causes no
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
significant slowing down on mount
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
for everyone else */
>> > - =A0 =A0 =A0 =A0 =A0 }
>> > - =A0 =A0 =A0 =A0 =A0 /* else the negprot may still work without t=
his
>> > - =A0 =A0 =A0 =A0 =A0 even though malloc failed */
>> > -
>> > - =A0 }
>> > + =A0 if (*sport =3D=3D htons(RFC1001_PORT))
>> > + =A0 =A0 =A0 =A0 =A0 rc =3D ip_rfc1001_connect(server);
>> >
>> > =A0 =A0 return rc;
>> > =A0}
>> >
>> > =A0static int
>> > -ipv6_connect(struct TCP_Server_Info *server)
>> > +ip_connect(struct TCP_Server_Info *server)
>> > =A0{
>> > - =A0 int rc =3D 0;
>> > - =A0 int val;
>> > - =A0 bool connected =3D false;
>> > - =A0 __be16 orig_port =3D 0;
>> > - =A0 struct socket *socket =3D server->ssocket;
>> > + =A0 unsigned short int *sport;
>> >
>> > - =A0 if (socket =3D=3D NULL) {
>> > - =A0 =A0 =A0 =A0 =A0 rc =3D sock_create_kern(PF_INET6, SOCK_STREA=
M,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
IPPROTO_TCP, &socket);
>> > - =A0 =A0 =A0 =A0 =A0 if (rc < 0) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error %d creating=
 ipv6 socket", rc);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 socket =3D NULL;
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> > - =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 if (server->addr.sockAddr6.sin6_family =3D=3D AF_INET6)
>> > + =A0 =A0 =A0 =A0 =A0 sport =3D &server->addr.sockAddr6.sin6_port;
>> > + =A0 else
>> > + =A0 =A0 =A0 =A0 =A0 sport =3D &server->addr.sockAddr.sin_port;
>> >
>> > - =A0 =A0 =A0 =A0 =A0 /* BB other socket options to set KEEPALIVE,=
 NODELAY? */
>> > - =A0 =A0 =A0 =A0 =A0 cFYI(1, "ipv6 Socket created");
>> > - =A0 =A0 =A0 =A0 =A0 server->ssocket =3D socket;
>> > - =A0 =A0 =A0 =A0 =A0 socket->sk->sk_allocation =3D GFP_NOFS;
>> > - =A0 =A0 =A0 =A0 =A0 cifs_reclassify_socket6(socket);
>> > - =A0 }
>> > + =A0 if (*sport =3D=3D 0) {
>> > + =A0 =A0 =A0 =A0 =A0 int rc;
>> >
>> > - =A0 rc =3D bind_socket(server);
>> > - =A0 if (rc < 0)
>> > - =A0 =A0 =A0 =A0 =A0 return rc;
>> > + =A0 =A0 =A0 =A0 =A0 /* try with 445 port at first */
>> > + =A0 =A0 =A0 =A0 =A0 *sport =3D htons(CIFS_PORT);
>> >
>> > - =A0 /* user overrode default port */
>> > - =A0 if (server->addr.sockAddr6.sin6_port) {
>> > - =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(socket,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct sock=
addr *) &server->addr.sockAddr6,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struc=
t sockaddr_in6), 0);
>> > + =A0 =A0 =A0 =A0 =A0 rc =3D generic_ip_connect(server);
>> > =A0 =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =3D true;
>> > - =A0 }
>> > -
>> > - =A0 if (!connected) {
>> > - =A0 =A0 =A0 =A0 =A0 /* save original port so we can retry user s=
pecified port
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 later if fall back ports fai=
l this time =A0*/
>> > -
>> > - =A0 =A0 =A0 =A0 =A0 orig_port =3D server->addr.sockAddr6.sin6_po=
rt;
>> > - =A0 =A0 =A0 =A0 =A0 /* do not retry on the same port we just fai=
led on */
>> > - =A0 =A0 =A0 =A0 =A0 if (server->addr.sockAddr6.sin6_port !=3D ht=
ons(CIFS_PORT)) {
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr6.sin6_=
port =3D htons(CIFS_PORT);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(=
socket, (struct sockaddr *)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 &server->addr.sockAddr6,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 sizeof(struct sockaddr_in6), 0);
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =3D=
 true;
>> > - =A0 =A0 =A0 =A0 =A0 }
>> > - =A0 }
>> > - =A0 if (!connected) {
>> > - =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr6.sin6_port =3D htons(R=
=46C1001_PORT);
>> > - =A0 =A0 =A0 =A0 =A0 rc =3D socket->ops->connect(socket, (struct =
sockaddr *)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &server->add=
r.sockAddr6,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struc=
t sockaddr_in6), 0);
>> > - =A0 =A0 =A0 =A0 =A0 if (rc >=3D 0)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connected =3D true;
>> > - =A0 }
>> > -
>> > - =A0 /* give up here - unless we want to retry on different
>> > - =A0 =A0 =A0 =A0 =A0 protocol families some day */
>> > - =A0 if (!connected) {
>> > - =A0 =A0 =A0 =A0 =A0 if (orig_port)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->addr.sockAddr6.sin6_=
port =3D orig_port;
>> > - =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error %d connecting to server via i=
pv6", rc);
>> > - =A0 =A0 =A0 =A0 =A0 sock_release(socket);
>> > - =A0 =A0 =A0 =A0 =A0 server->ssocket =3D NULL;
>> > - =A0 =A0 =A0 =A0 =A0 return rc;
>> > - =A0 }
>> > -
>> > - =A0 /*
>> > - =A0 =A0* Eventually check for other socket options to change fro=
m
>> > - =A0 =A0* the default. sock_setsockopt not used because it expect=
s
>> > - =A0 =A0* user space buffer
>> > - =A0 =A0*/
>> > - =A0 socket->sk->sk_rcvtimeo =3D 7 * HZ;
>> > - =A0 socket->sk->sk_sndtimeo =3D 5 * HZ;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> >
>> > - =A0 if (server->tcp_nodelay) {
>> > - =A0 =A0 =A0 =A0 =A0 val =3D 1;
>> > - =A0 =A0 =A0 =A0 =A0 rc =3D kernel_setsockopt(socket, SOL_TCP, TC=
P_NODELAY,
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (char *)&val=
, sizeof(val));
>> > - =A0 =A0 =A0 =A0 =A0 if (rc)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "set TCP_NODELAY soc=
ket option error %d", rc);
>> > + =A0 =A0 =A0 =A0 =A0 /* if it failed, try with 139 port */
>> > + =A0 =A0 =A0 =A0 =A0 *sport =3D htons(RFC1001_PORT);
>> > =A0 =A0 }
>> >
>> > - =A0 server->ssocket =3D socket;
>> > -
>> > - =A0 return rc;
>> > + =A0 return generic_ip_connect(server);
>> > =A0}
>> >
>> > =A0void reset_cifs_unix_caps(int xid, struct cifsTconInfo *tcon,
>>
>> Nice cleanup.
>>
>> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Actually...my ACK on this still stands if you don't want to do it, bu=
t
> there is a "nice to have" change that could go with this.
>
> It would be nice if we didn't have this goofy "addr" union in the
> TCP_Server_Info, and just had a standard sockaddr_storage embedded
> inside it instead. It would mean quite a bit less conditional code, I
> think...
>
> You're already touching about half the code that would be affected by
> such a change with this patch. Care to do the rest?

Ok, good idea. But I think it should be another separate patch that we
can apply after the patch above.

--=20
Best regards,
Pavel Shilovsky.
