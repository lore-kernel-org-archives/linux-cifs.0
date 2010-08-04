From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make cifs_convert_address() take a const src
	pointer and a length
Date: Tue, 3 Aug 2010 23:21:13 -0500
Message-ID: <AANLkTinA1Or90WZ1nAMtDs7+zJ_06rTXLW5ktf1oxq6w@mail.gmail.com>
References: <20100722173251.1512.29858.stgit@warthog.procyon.org.uk>
	<20100722173301.1512.52037.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100722173301.1512.52037.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I merged this (patch 3) - but patch 4 (and thus patch 5) did not merge.

Also patches 4 and 5 had trivial checkpatch warnings.

Patch 6 looks afs related so should probably merge out of your tree,
but it doesn't matter to me.
What about patches 1 and 2 - which is easier?

On Thu, Jul 22, 2010 at 12:33 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
> Make cifs_convert_address() take a const src pointer and a length so =
that all
> the strlen() calls in their can be cut out and to make it unnecessary=
 to modify
> the src string.
>
> Also return the data length from dns_resolve_server_name_to_ip() so t=
hat a
> strlen() can be cut out of cifs_compose_mount_options() too.
>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
> =A0fs/cifs/cifs_dfs_ref.c | =A0 =A05 ++---
> =A0fs/cifs/cifsproto.h =A0 =A0| =A0 =A04 ++--
> =A0fs/cifs/connect.c =A0 =A0 =A0| =A0 =A01 +
> =A0fs/cifs/dns_resolve.c =A0| =A0 20 +++++++++-----------
> =A0fs/cifs/netmisc.c =A0 =A0 =A0| =A0 45 ++++++++++++++++++++++++----=
-----------------
> =A05 files changed, 38 insertions(+), 37 deletions(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index ac19a6f..37543e8 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -141,7 +141,7 @@ char *cifs_compose_mount_options(const char *sb_m=
ountdata,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0rc =3D dns_resolve_server_name_to_ip(*devname, &srvIP)=
;
> - =A0 =A0 =A0 if (rc !=3D 0) {
> + =A0 =A0 =A0 if (rc < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "%s: Failed to resolve serve=
r part of %s to IP: %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, *devname=
, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto compose_mount_options_err;
> @@ -150,8 +150,7 @@ char *cifs_compose_mount_options(const char *sb_m=
ountdata,
> =A0 =A0 =A0 =A0 * assuming that we have 'unc=3D' and 'ip=3D' in
> =A0 =A0 =A0 =A0 * the original sb_mountdata
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 md_len =3D strlen(sb_mountdata) + strlen(srvIP) +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlen(ref->node_name) + 12;
> + =A0 =A0 =A0 md_len =3D strlen(sb_mountdata) + rc + strlen(ref->node=
_name) + 12;
> =A0 =A0 =A0 =A0mountdata =3D kzalloc(md_len+1, GFP_KERNEL);
> =A0 =A0 =A0 =A0if (mountdata =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 2eaebbd..1f54508 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -86,8 +86,8 @@ extern unsigned int smbCalcSize(struct smb_hdr *ptr=
);
> =A0extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
> =A0extern int decode_negTokenInit(unsigned char *security_blob, int l=
ength,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct TCP_Server_Info=
 *server);
> -extern int cifs_convert_address(struct sockaddr *dst, char *src);
> -extern int cifs_fill_sockaddr(struct sockaddr *dst, char *src,
> +extern int cifs_convert_address(struct sockaddr *dst, const char *sr=
c, int len);
> +extern int cifs_fill_sockaddr(struct sockaddr *dst, const char *src,=
 int len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsign=
ed short int port);
> =A0extern int map_smb_to_linux_error(struct smb_hdr *smb, int logErr)=
;
> =A0extern void header_assemble(struct smb_hdr *, char /* command */ ,
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 399b601..7a78b49 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1538,6 +1538,7 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
> =A0 =A0 =A0 =A0if (volume_info->UNCip && volume_info->UNC) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_fill_sockaddr((struct sock=
addr *)&addr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0volume_info->UNCip,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 strlen(volume_info->UNCip),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0volume_info->port);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we failed translati=
ng address */
> diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
> index ff6fa2f..8de3b98 100644
> --- a/fs/cifs/dns_resolve.c
> +++ b/fs/cifs/dns_resolve.c
> @@ -40,11 +40,11 @@ static const struct cred *dns_resolver_cache;
> =A0* =A0 =A0 =A0 =A0 =A0 =A0 0 - name is not IP
> =A0*/
> =A0static int
> -is_ip(char *name)
> +is_ip(const char *name, int len)
> =A0{
> =A0 =A0 =A0 =A0struct sockaddr_storage ss;
>
> - =A0 =A0 =A0 return cifs_convert_address((struct sockaddr *)&ss, nam=
e);
> + =A0 =A0 =A0 return cifs_convert_address((struct sockaddr *)&ss, nam=
e, len);
> =A0}
>
> =A0static int
> @@ -54,6 +54,10 @@ dns_resolver_instantiate(struct key *key, const vo=
id *data,
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0char *ip;
>
> + =A0 =A0 =A0 /* make sure this looks like an address */
> + =A0 =A0 =A0 if (!is_ip(data, datalen))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> +
> =A0 =A0 =A0 =A0ip =3D kmalloc(datalen + 1, GFP_KERNEL);
> =A0 =A0 =A0 =A0if (!ip)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> @@ -61,12 +65,6 @@ dns_resolver_instantiate(struct key *key, const vo=
id *data,
> =A0 =A0 =A0 =A0memcpy(ip, data, datalen);
> =A0 =A0 =A0 =A0ip[datalen] =3D '\0';
>
> - =A0 =A0 =A0 /* make sure this looks like an address */
> - =A0 =A0 =A0 if (!is_ip(ip)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ip);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> - =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0key->type_data.x[0] =3D datalen;
> =A0 =A0 =A0 =A0key->payload.data =3D ip;
>
> @@ -93,7 +91,7 @@ struct key_type key_type_dns_resolver =3D {
> =A0* =A0 =A0 unc - server UNC
> =A0* output:
> =A0* =A0 =A0 *ip_addr - pointer to server ip, caller responcible for =
freeing it.
> - * return 0 on success
> + * return the length of the returned string on success
> =A0*/
> =A0int
> =A0dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
> @@ -131,7 +129,7 @@ dns_resolve_server_name_to_ip(const char *unc, ch=
ar **ip_addr)
> =A0 =A0 =A0 =A0memcpy(name, unc+2, len);
> =A0 =A0 =A0 =A0name[len] =3D 0;
>
> - =A0 =A0 =A0 if (is_ip(name)) {
> + =A0 =A0 =A0 if (is_ip(name, len)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "%s: it is IP, skipping dns up=
call: %s",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0__func__, name);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0data =3D name;
> @@ -164,7 +162,7 @@ skip_upcall:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0name,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*ip_addr
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index 3489468..b7f5975 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -139,17 +139,18 @@ static const struct smb_to_posix_error mapping_=
table_ERRHRD[] =3D {
> =A0* Returns 0 on failure.
> =A0*/
> =A0static int
> -cifs_inet_pton(const int address_family, const char *cp, void *dst)
> +cifs_inet_pton(const int address_family, const char *cp, int len, vo=
id *dst)
> =A0{
> =A0 =A0 =A0 =A0int ret =3D 0;
>
> =A0 =A0 =A0 =A0/* calculate length by finding first slash or NULL */
> =A0 =A0 =A0 =A0if (address_family =3D=3D AF_INET)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D in4_pton(cp, -1 /* len */, dst,=
 '\\', NULL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D in4_pton(cp, len, dst, '\\', NU=
LL);
> =A0 =A0 =A0 =A0else if (address_family =3D=3D AF_INET6)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D in6_pton(cp, -1 /* len */, dst =
, '\\', NULL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D in6_pton(cp, len, dst , '\\', N=
ULL);
>
> - =A0 =A0 =A0 cFYI(DBG2, "address conversion returned %d for %s", ret=
, cp);
> + =A0 =A0 =A0 cFYI(DBG2, "address conversion returned %d for %*.*s",
> + =A0 =A0 =A0 =A0 =A0 =A0ret, len, len, cp);
> =A0 =A0 =A0 =A0if (ret > 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D 1;
> =A0 =A0 =A0 =A0return ret;
> @@ -164,37 +165,39 @@ cifs_inet_pton(const int address_family, const =
char *cp, void *dst)
> =A0* Returns 0 on failure.
> =A0*/
> =A0int
> -cifs_convert_address(struct sockaddr *dst, char *src)
> +cifs_convert_address(struct sockaddr *dst, const char *src, int len)
> =A0{
> - =A0 =A0 =A0 int rc;
> - =A0 =A0 =A0 char *pct, *endp;
> + =A0 =A0 =A0 int rc, alen, slen;
> + =A0 =A0 =A0 const char *pct;
> + =A0 =A0 =A0 char *endp, scope_id[13];
> =A0 =A0 =A0 =A0struct sockaddr_in *s4 =3D (struct sockaddr_in *) dst;
> =A0 =A0 =A0 =A0struct sockaddr_in6 *s6 =3D (struct sockaddr_in6 *) ds=
t;
>
> =A0 =A0 =A0 =A0/* IPv4 address */
> - =A0 =A0 =A0 if (cifs_inet_pton(AF_INET, src, &s4->sin_addr.s_addr))=
 {
> + =A0 =A0 =A0 if (cifs_inet_pton(AF_INET, src, len, &s4->sin_addr.s_a=
ddr)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s4->sin_family =3D AF_INET;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* temporarily terminate string */
> - =A0 =A0 =A0 pct =3D strchr(src, '%');
> - =A0 =A0 =A0 if (pct)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *pct =3D '\0';
> -
> - =A0 =A0 =A0 rc =3D cifs_inet_pton(AF_INET6, src, &s6->sin6_addr.s6_=
addr);
> -
> - =A0 =A0 =A0 /* repair temp termination (if any) and make pct point =
to scopeid */
> - =A0 =A0 =A0 if (pct)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 *pct++ =3D '%';
> + =A0 =A0 =A0 /* attempt to exclude the scope ID from the address par=
t */
> + =A0 =A0 =A0 pct =3D memchr(src, '%', len);
> + =A0 =A0 =A0 alen =3D pct ? pct - src : len;
>
> + =A0 =A0 =A0 rc =3D cifs_inet_pton(AF_INET6, src, alen, &s6->sin6_ad=
dr.s6_addr);
> =A0 =A0 =A0 =A0if (!rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> =A0 =A0 =A0 =A0s6->sin6_family =3D AF_INET6;
> =A0 =A0 =A0 =A0if (pct) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* grab the scope ID */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 slen =3D len - (alen + 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (slen <=3D 0 || slen > 12)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(scope_id, pct + 1, slen);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 scope_id[slen] =3D '\0';
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s6->sin6_scope_id =3D (u32) simple_str=
toul(pct, &endp, 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!*pct || *endp)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (endp !=3D scope_id + slen)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> @@ -202,10 +205,10 @@ cifs_convert_address(struct sockaddr *dst, char=
 *src)
> =A0}
>
> =A0int
> -cifs_fill_sockaddr(struct sockaddr *dst, char *src,
> +cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned short int port)
> =A0{
> - =A0 =A0 =A0 if (!cifs_convert_address(dst, src))
> + =A0 =A0 =A0 if (!cifs_convert_address(dst, src, len))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> =A0 =A0 =A0 =A0switch (dst->sa_family) {
>
>



--=20
Thanks,

Steve
