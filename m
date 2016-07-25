From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix crash due to race in hmac(md5) handling
Date: Mon, 25 Jul 2016 10:51:30 +0100
Message-ID: <1469440290.8377.6.camel@redhat.com>
References: <1468913181-28163-1-git-send-email-rabin.vincent@axis.com>
	 <1469023049.4942.21.camel@redhat.com> <20160721073053.GA31832@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160721073053.GA31832-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2016-07-21 at 09:30 +0200, Rabin Vincent wrote:
> On Wed, Jul 20, 2016 at 02:57:29PM +0100, Sachin Prabhu wrote:
> >=20
> > Rabin, do you have a reliable reproducer for this case? If yes, can
> > you
> > please point me to it.
> I have only seen one report of the oops in real testing, so I don't
> have
> a case that would reproduce easily on an unmodified kernel, but while
> investigating this I made a debug patch which forces the faulty
> sequence
> to occur and provides a 100% reliable reproducer.
>=20
> The below patched forces the race condition by making two mount.cifs
> processes wait for each other in the appropriate places.
>=20
> With the force-race patch applied and without this fix, the crash
> occurs
> every time when the following sequence of commands is run.=C2=A0=C2=A0=
Tested in
> a
> KVM guest on latest mainline with my "unbreak TCP session reuse"
> patch
> applied.
>=20
> With the force-race patch applied and with this fix, the mount
> processes
> hang since the race condition can never be satisfied.


Thanks Rabin.

Sachin Prabhu

>=20
> =C2=A0cp /sbin/mount.cifs /sbin/cifs1
> =C2=A0cp /sbin/mount.cifs /sbin/cifs2
> =C2=A0mkdir -p cifs cifs2
> =C2=A0cifs1 //192.168.1.1/test cifs -o credentials=3D/creds &
> =C2=A0sleep 2
> =C2=A0cifs2 //192.168.1.1/test2 cifs2 -o credentials=3D/creds
>=20
> 8<-------------------------
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 8347c90..1ed6dfd 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -35,6 +35,32 @@
> =C2=A0#include <linux/highmem.h>
> =C2=A0#include <crypto/skcipher.h>
> =C2=A0
> +static struct completion completions[100];
> +
> +void hack_set_state(int newstate)
> +{
> +	printk("%s: caller %pF sets state to %d\n", current->comm,
> (void *)_RET_IP_, newstate);
> +	complete(&completions[newstate]);
> +}
> +
> +void hack_wait_for_state(int state)
> +{
> +	printk("%s caller %pF wants state %d\n", current->comm,
> (void *)_RET_IP_, state);
> +	wait_for_completion(&completions[state]);
> +	printk("%s caller %pF got state %d\n", current->comm, (void
> *)_RET_IP_, state);
> +}
> +
> +static int hack_init(void)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int i;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (i =3D 0; i < ARRAY_SI=
ZE(completions); i++)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0init_completion(&completions[i]);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> +}
> +late_initcall(hack_init);
> +
> =C2=A0static int
> =C2=A0cifs_crypto_shash_md5_allocate(struct TCP_Server_Info *server)
> =C2=A0{
> @@ -54,6 +80,7 @@ cifs_crypto_shash_md5_allocate(struct
> TCP_Server_Info *server)
> =C2=A0
> =C2=A0	size =3D sizeof(struct shash_desc) +
> =C2=A0			crypto_shash_descsize(server->secmech.md5);
> +
> =C2=A0	server->secmech.sdescmd5 =3D kmalloc(size, GFP_KERNEL);
> =C2=A0	if (!server->secmech.sdescmd5) {
> =C2=A0		crypto_free_shash(server->secmech.md5);
> @@ -661,8 +688,10 @@ static int crypto_hmacmd5_alloc(struct
> TCP_Server_Info *server)
> =C2=A0	unsigned int size;
> =C2=A0
> =C2=A0	/* check if already allocated */
> -	if (server->secmech.sdeschmacmd5)
> +	if (server->secmech.sdeschmacmd5) {
> +		printk("%s: server %p already allocated\n",
> __func__, server);
> =C2=A0		return 0;
> +	}
> =C2=A0
> =C2=A0	server->secmech.hmacmd5 =3D crypto_alloc_shash("hmac(md5)", 0,
> 0);
> =C2=A0	if (IS_ERR(server->secmech.hmacmd5)) {
> @@ -674,12 +703,28 @@ static int crypto_hmacmd5_alloc(struct
> TCP_Server_Info *server)
> =C2=A0
> =C2=A0	size =3D sizeof(struct shash_desc) +
> =C2=A0			crypto_shash_descsize(server-
> >secmech.hmacmd5);
> +
> +	if (!strcmp(current->comm, "cifs1")) {
> +		hack_wait_for_state(10);
> +	}
> +	if (!strcmp(current->comm, "cifs2")) {
> +		hack_set_state(10);
> +		hack_wait_for_state(20);
> +	}
> +
> =C2=A0	server->secmech.sdeschmacmd5 =3D kmalloc(size, GFP_KERNEL);
> +	printk("%s: %s: server %p alloc sdeschmacmd5=3D%p\n",
> __func__, current->comm, server, server->secmech.sdeschmacmd5);
> =C2=A0	if (!server->secmech.sdeschmacmd5) {
> =C2=A0		crypto_free_shash(server->secmech.hmacmd5);
> =C2=A0		server->secmech.hmacmd5 =3D NULL;
> =C2=A0		return -ENOMEM;
> =C2=A0	}
> +
> +	if (!strcmp(current->comm, "cifs2")) {
> +		hack_set_state(30);
> +		hack_wait_for_state(40);
> +	}
> +
> =C2=A0	server->secmech.sdeschmacmd5->shash.tfm =3D server-
> >secmech.hmacmd5;
> =C2=A0	server->secmech.sdeschmacmd5->shash.flags =3D 0x0;
> =C2=A0
> @@ -745,6 +790,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const
> struct nls_table *nls_cp)
> =C2=A0
> =C2=A0	mutex_lock(&ses->server->srv_mutex);
> =C2=A0
> +	printk("%s: ses %p ses->server %p\n", __func__, ses, ses-
> >server);
> =C2=A0	rc =3D crypto_hmacmd5_alloc(ses->server);
> =C2=A0	if (rc) {
> =C2=A0		cifs_dbg(VFS, "could not crypto alloc hmacmd5 rc
> %d\n", rc);
> @@ -780,6 +826,11 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const
> struct nls_table *nls_cp)
> =C2=A0		goto unlock;
> =C2=A0	}
> =C2=A0
> +	if (!strcmp(current->comm, "cifs1")) {
> +		hack_set_state(20);
> +		hack_wait_for_state(30);
> +	}
> +
> =C2=A0	rc =3D crypto_shash_update(&ses->server->secmech.sdeschmacmd5-
> >shash,
> =C2=A0		ntlmv2->ntlmv2_hash,
> =C2=A0		CIFS_HMAC_MD5_HASH_SIZE);
> @@ -788,6 +839,8 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const
> struct nls_table *nls_cp)
> =C2=A0		goto unlock;
> =C2=A0	}
> =C2=A0
> +	hack_set_state(40);
> +
> =C2=A0	rc =3D crypto_shash_final(&ses->server->secmech.sdeschmacmd5-
> >shash,
> =C2=A0		ses->auth_key.response);
> =C2=A0	if (rc)
