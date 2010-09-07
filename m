From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] define, declare, and use crypto sync hash structures
Date: Tue, 7 Sep 2010 08:57:08 -0400
Message-ID: <20100907085708.179c5dd0@corrin.poochiereds.net>
References: <1283830467-25062-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100907072742.66d52ecb@corrin.poochiereds.net>
	<AANLkTinL+TtFuSqpyrQ8SVBRfo3GfsY3iWxSNHzw0ZnB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinL+TtFuSqpyrQ8SVBRfo3GfsY3iWxSNHzw0ZnB-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 7 Sep 2010 07:21:30 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Sep 7, 2010 at 6:27 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> > On Mon, =A06 Sep 2010 22:34:27 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsencrypt.c | =A0 71 ++++++++++++++++++++++++++++++++=
+++++++++++++++++
> >> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A02 +
> >> =A0fs/cifs/cifsproto.h =A0 | =A0 =A02 +
> >> =A0fs/cifs/connect.c =A0 =A0 | =A0 16 +++++++++--
> >> =A04 files changed, 88 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> >> index 4f85651..fe1e4c9 100644
> >> --- a/fs/cifs/cifsencrypt.c
> >> +++ b/fs/cifs/cifsencrypt.c
> >> @@ -369,3 +369,74 @@ void CalcNTLMv2_response(const struct cifsSes=
Info *ses,
> >> =A0 =A0 =A0 hmac_md5_final(v2_session_response, &context);
> >> =A0/* =A0 cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32);=
 */
> >> =A0}
> >> +
> >> +void
> >> +cifs_crypto_shash_release(struct TCP_Server_Info *server)
> >> +{
> >> + =A0 =A0 if (server->ntlmssp.md5)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_shash(server->ntlmssp.md5);
> >> +
> >> + =A0 =A0 if (server->ntlmssp.hmacmd5)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 crypto_free_shash(server->ntlmssp.hmacmd=
5);
> >> +
> >> + =A0 =A0 kfree(server->ntlmssp.sdeschmacmd5);
> >> +
> >> + =A0 =A0 kfree(server->ntlmssp.sdescmd5);
> >> +}
> >> +
> >> +int
> >> +cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
> >> +{
> >> + =A0 =A0 int rc;
> >> + =A0 =A0 unsigned int size;
> >> +
> >> + =A0 =A0 server->ntlmssp.hmacmd5 =3D crypto_alloc_shash("hmac(md5=
)", 0, 0);
> >> + =A0 =A0 if (!server->ntlmssp.hmacmd5 ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IS_ERR(server->ntlmssp.h=
macmd5)) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto hma=
cmd5\n");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> >> + =A0 =A0 }
> >> +
> >> + =A0 =A0 server->ntlmssp.md5 =3D crypto_alloc_shash("md5", 0, 0);
> >> + =A0 =A0 if (!server->ntlmssp.md5 || IS_ERR(server->ntlmssp.md5))=
 {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not allocate crypto md5=
\n");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 1;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_crypto_shash_allocate_ret1;
> >> + =A0 =A0 }
> >> +
> >> + =A0 =A0 size =3D sizeof(struct shash_desc) +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_descsize(se=
rver->ntlmssp.hmacmd5);
> >> + =A0 =A0 server->ntlmssp.sdeschmacmd5 =3D kmalloc(size, GFP_KERNE=
L);
> >> + =A0 =A0 if (!server->ntlmssp.sdeschmacmd5) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_crypto_shash_allocate: c=
an't alloc hmacmd5\n");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_crypto_shash_allocate_ret2;
> >> + =A0 =A0 }
> >> + =A0 =A0 server->ntlmssp.sdeschmacmd5->shash.tfm =3D server->ntlm=
ssp.hmacmd5;
> >> + =A0 =A0 server->ntlmssp.sdeschmacmd5->shash.flags =3D 0x0;
> >> +
> >> +
> >> + =A0 =A0 size =3D sizeof(struct shash_desc) +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_shash_descsize(se=
rver->ntlmssp.md5);
> >> + =A0 =A0 server->ntlmssp.sdescmd5 =3D kmalloc(size, GFP_KERNEL);
> >> + =A0 =A0 if (!server->ntlmssp.sdescmd5) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cifs_crypto_shash_allocate: c=
an't alloc md5\n");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto cifs_crypto_shash_allocate_ret3;
> >> + =A0 =A0 }
> >> + =A0 =A0 server->ntlmssp.sdescmd5->shash.tfm =3D server->ntlmssp.=
md5;
> >> + =A0 =A0 server->ntlmssp.sdescmd5->shash.flags =3D 0x0;
> >> +
> >> + =A0 =A0 return 0;
> >> +
> >> +cifs_crypto_shash_allocate_ret3:
> >> + =A0 =A0 kfree(server->ntlmssp.sdeschmacmd5);
> >> +
> >> +cifs_crypto_shash_allocate_ret2:
> >> + =A0 =A0 crypto_free_shash(server->ntlmssp.md5);
> >> +
> >> +cifs_crypto_shash_allocate_ret1:
> >> + =A0 =A0 crypto_free_shash(server->ntlmssp.hmacmd5);
> >> +
> >> + =A0 =A0 return rc;
> >> +}
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 6e35655..6b7249e 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -135,6 +135,8 @@ struct ntlmssp_auth {
> >> =A0 =A0 =A0 unsigned char ciphertext[CIFS_CPHTXT_SIZE]; /* sent to=
 server */
> >> =A0 =A0 =A0 struct crypto_shash *hmacmd5; /* to generate ntlmv2 ha=
sh, CR1 etc. */
> >> =A0 =A0 =A0 struct crypto_shash *md5; /* to generate cifs/smb sign=
ature */
> >> + =A0 =A0 struct sdesc *sdeschmacmd5;
> >> + =A0 =A0 struct sdesc *sdescmd5;
> >
> > It might be nice to have some comments that explain what these new
> > fields actually do. Also, why were these fields added in this patch=
 and
> > the two above it added in the first patch?
>=20
> No particular reason. They were added as I went along creating patche=
s
> incrementally.
> crypto_hash structures hold hash function that will be used such as
> md5 or hmac-md5
> etc..
> sdesc structures hold the context, keys etc.. as user updaes that are
> used to generate
> the hash values.
>=20

In general, it's best to add fields to structures as you add code that
uses them. Splitting the changes that add the fields and use them into
separate patches breaks the logical sequence and makes review tougher.
I now have to go back to the "add a bunch of fields" patch and try to
figure out which pieces there make sense based on the code added here.

> >
> >> =A0};
> >>
> >> =A0/*
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index 8d63406..f3ffa69 100644
> >> --- a/fs/cifs/cifsproto.h
> >> +++ b/fs/cifs/cifsproto.h
> >> @@ -370,6 +370,8 @@ extern int CalcNTLMv2_partial_mac_key(struct c=
ifsSesInfo *,
> >> =A0extern void CalcNTLMv2_response(const struct cifsSesInfo *, cha=
r *);
> >> =A0extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struc=
t nls_table *);
> >> +extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
> >> +extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
> >> =A0#ifdef CONFIG_CIFS_WEAK_PW_HASH
> >> =A0extern void calc_lanman_hash(const char *password, const char *=
cryptkey,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool e=
ncrypt, char *lnm_session_key);
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 0ea52e9..f5369e7 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -1520,6 +1520,7 @@ cifs_put_tcp_session(struct TCP_Server_Info =
*server)
> >> =A0 =A0 =A0 server->tcpStatus =3D CifsExiting;
> >> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> >>
> >> + =A0 =A0 cifs_crypto_shash_release(server);
> >> =A0 =A0 =A0 cifs_fscache_release_client_cookie(server);
> >>
> >> =A0 =A0 =A0 task =3D xchg(&server->tsk, NULL);
> >> @@ -1574,10 +1575,16 @@ cifs_get_tcp_session(struct smb_vol *volum=
e_info)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> >> =A0 =A0 =A0 }
> >>
> >> + =A0 =A0 rc =3D cifs_crypto_shash_allocate(tcp_ses);
> >> + =A0 =A0 if (rc) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "could not setup hash structur=
es rc %d", rc);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> >> + =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 tcp_ses->hostname =3D extract_hostname(volume_info->UN=
C);
> >> =A0 =A0 =A0 if (IS_ERR(tcp_ses->hostname)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(tcp_ses->hostname);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_err2;
> >> =A0 =A0 =A0 }
> >>
> >> =A0 =A0 =A0 tcp_ses->noblocksnd =3D volume_info->noblocksnd;
> >> @@ -1618,7 +1625,7 @@ cifs_get_tcp_session(struct smb_vol *volume_=
info)
> >> =A0 =A0 =A0 }
> >> =A0 =A0 =A0 if (rc < 0) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Error connecting to socket.=
 Aborting operation");
> >> - =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_err2;
> >> =A0 =A0 =A0 }
> >>
> >> =A0 =A0 =A0 /*
> >> @@ -1632,7 +1639,7 @@ cifs_get_tcp_session(struct smb_vol *volume_=
info)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(tcp_ses->tsk);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "error %d create cifsd threa=
d", rc);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 module_put(THIS_MODULE);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_err2;
> >> =A0 =A0 =A0 }
> >>
> >> =A0 =A0 =A0 /* thread spawned, put it on the list */
> >> @@ -1644,6 +1651,9 @@ cifs_get_tcp_session(struct smb_vol *volume_=
info)
> >>
> >> =A0 =A0 =A0 return tcp_ses;
> >>
> >> +out_err2:
> >> + =A0 =A0 cifs_crypto_shash_release(tcp_ses);
> >> +
> >> =A0out_err:
> >> =A0 =A0 =A0 if (tcp_ses) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!IS_ERR(tcp_ses->hostname))
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
