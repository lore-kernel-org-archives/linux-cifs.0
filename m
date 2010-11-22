From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Simplify ipv*_connect functions into one (try
 #2)
Date: Mon, 22 Nov 2010 14:51:39 -0500
Message-ID: <20101122145139.190edfab@corrin.poochiereds.net>
References: <1289893710-7352-1-git-send-email-piastryyy@gmail.com>
	<20101122120145.20989d38@tlielax.poochiereds.net>
	<AANLkTi=V89tV62iyD+_DeSjwDBBVTfyfHMJ6t1mtBrCD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=V89tV62iyD+_DeSjwDBBVTfyfHMJ6t1mtBrCD-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 22 Nov 2010 22:26:59 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/11/22 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > On Tue, 16 Nov 2010 10:48:29 +0300
> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Make connect logic more ip-protocol independent. Also move RFC1001=
 stuff into
> >> separate function.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/connect.c | =A0314 ++++++++++++++++++++----------------=
-----------------
> >> =A01 files changed, 116 insertions(+), 198 deletions(-)
> >>
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 251a17c..8bdf1cc 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -114,8 +114,8 @@ struct smb_vol {
> >> =A0#define TLINK_ERROR_EXPIRE =A0 (1 * HZ)
> >> =A0#define TLINK_IDLE_EXPIRE =A0 =A0(600 * HZ)
> >>
> >> -static int ipv4_connect(struct TCP_Server_Info *server);
> >> -static int ipv6_connect(struct TCP_Server_Info *server);
> >> +static int ip_connect(struct TCP_Server_Info *server);
> >> +static int generic_ip_connect(struct TCP_Server_Info *server);
> >> =A0static void tlink_rb_insert(struct rb_root *root, struct tcon_l=
ink *new_tlink);
> >> =A0static void cifs_prune_tlinks(struct work_struct *work);
> >>
> >> @@ -199,10 +199,10 @@ cifs_reconnect(struct TCP_Server_Info *serve=
r)
> >> =A0 =A0 =A0 while ((server->tcpStatus !=3D CifsExiting) &&
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0(server->tcpStatus !=3D CifsGood)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 try_to_freeze();
> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (server->addr.sockAddr6.sin6_family =3D=
=3D AF_INET6)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ipv6_connect(serv=
er);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 else
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ipv4_connect(serv=
er);
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* on reconnect we should try only the p=
ort we connected
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0before */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D generic_ip_connect(server);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "reconnect err=
or %d", rc);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(3000);
> >> @@ -1668,12 +1668,11 @@ cifs_get_tcp_session(struct smb_vol *volum=
e_info)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* other OS never observed in Wild doi=
ng 139 with v6 */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&tcp_ses->addr.sockAddr6, sin_s=
erver6,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct sockaddr=
_in6));
> >> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ipv6_connect(tcp_ses);
> >> - =A0 =A0 } else {
> >> + =A0 =A0 } else
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&tcp_ses->addr.sockAddr, sin_se=
rver,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct sockaddr=
_in));
> >> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ipv4_connect(tcp_ses);
> >> - =A0 =A0 }
> >> +
> >> + =A0 =A0 rc =3D ip_connect(tcp_ses);
> >> =A0 =A0 =A0 if (rc < 0) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error connecting to socket.=
 Aborting operation");
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err_crypto_release;
> >> @@ -2121,19 +2120,97 @@ bind_socket(struct TCP_Server_Info *server=
)
> >> =A0}
> >>
> >> =A0static int
> >> -ipv4_connect(struct TCP_Server_Info *server)
> >> +ip_rfc1001_connect(struct TCP_Server_Info *server)
> >> +{
> >> + =A0 =A0 int rc =3D 0;
> >> + =A0 =A0 /* some servers require RFC1001 sessinit before sending
> >> + =A0 =A0 negprot - BB check reconnection in case where second
> >> + =A0 =A0 sessinit is sent but no second negprot */
> >> + =A0 =A0 struct rfc1002_session_packet *ses_init_buf;
> >> + =A0 =A0 struct smb_hdr *smb_buf;
> >> + =A0 =A0 ses_init_buf =3D kzalloc(sizeof(struct rfc1002_session_p=
acket),
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KERNE=
L);
> >> + =A0 =A0 if (ses_init_buf) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.called=
_len =3D 32;
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (server->server_RFC1001_name &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->server_RFC1001_name[0] !=
=3D 0)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_b=
uf->trailer.
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 session_req.called_name,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 server->server_RFC1001_name,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 RFC1001_NAME_LEN_WITH_NULL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_b=
uf->trailer.
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 session_req.called_name,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 DEFAULT_CIFS_CALLED_NAME,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 RFC1001_NAME_LEN_WITH_NULL);
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.callin=
g_len =3D 32;
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* calling name ends in null (byte 16) f=
rom old smb
> >> + =A0 =A0 =A0 =A0 =A0 =A0 convention. */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (server->workstation_RFC1001_name &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->workstation_RFC1001_name=
[0] !=3D 0)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_b=
uf->trailer.
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 session_req.calling_name,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 server->workstation_RFC1001_name,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 RFC1001_NAME_LEN_WITH_NULL);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfc1002mangle(ses_init_b=
uf->trailer.
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 session_req.calling_name,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 "LINUX_CIFS_CLNT",
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 RFC1001_NAME_LEN_WITH_NULL);
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.scope1=
 =3D 0;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ses_init_buf->trailer.session_req.scope2=
 =3D 0;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 smb_buf =3D (struct smb_hdr *)ses_init_b=
uf;
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* sizeof RFC1002_SESSION_REQUEST with n=
o scope */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 smb_buf->smb_buf_length =3D 0x81000044;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D smb_send(server, smb_buf, 0x44);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses_init_buf);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 msleep(1); /* RFC1001 layer in at least =
one server
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 requires ver=
y short break before negprot
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 presumably b=
ecause not expecting negprot
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 to follow so=
 fast. =A0This is a simple
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 solution tha=
t works without
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 complicating=
 the code and causes no
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 significant =
slowing down on mount
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for everyone=
 else */
> >> + =A0 =A0 }
> >> + =A0 =A0 /* else the negprot may still work without this
> >> + =A0 =A0 even though malloc failed */
> >> +
> >> + =A0 =A0 return rc;
> >> +}
> >> +
> >> +static int
> >> +generic_ip_connect(struct TCP_Server_Info *server)
> >> =A0{
> >> =A0 =A0 =A0 int rc =3D 0;
> >> - =A0 =A0 int val;
> >> - =A0 =A0 bool connected =3D false;
> >> - =A0 =A0 __be16 orig_port =3D 0;
> >> + =A0 =A0 bool using_ipv6 =3D false;
> >> + =A0 =A0 unsigned short int *sport;
> >> + =A0 =A0 int slen;
> >> =A0 =A0 =A0 struct socket *socket =3D server->ssocket;
> >> + =A0 =A0 struct sockaddr *saddr;
> >> +
> >> + =A0 =A0 if (server->addr.sockAddr6.sin6_family =3D=3D AF_INET6) =
{
> >> + =A0 =A0 =A0 =A0 =A0 =A0 sport =3D &server->addr.sockAddr6.sin6_p=
ort;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 using_ipv6 =3D true;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 slen =3D sizeof(struct sockaddr_in6);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 saddr =3D (struct sockaddr *) &server->a=
ddr.sockAddr6;
> >> + =A0 =A0 } else {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 sport =3D &server->addr.sockAddr.sin_por=
t;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 slen =3D sizeof(struct sockaddr_in);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 saddr =3D (struct sockaddr *) &server->a=
ddr.sockAddr;
> >> + =A0 =A0 }
> >>
> >> =A0 =A0 =A0 if (socket =3D=3D NULL) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D sock_create_kern(PF_INET, SOCK_=
STREAM,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 IPPROTO_TCP, &socket);
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^
> > I finally got a chance to give this a try today. It's broken due to=
 the
> > above statement. If we get an IPv6 address, we need to set the fami=
ly
> > correctly in sock_create_kern.
> >
> > Pavel, care to fix this?
>=20
> No problem. Should I create separate patch or change this one?

Please fix this one. I don't believe Steve has merged it yet.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
