From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if available
Date: Wed, 7 Sep 2011 17:18:03 -0500
Message-ID: <CAH2r5muOF077Y35ZJW=Ft22_az5jyB6mAKNLJuUMnM9HNt6Kmg@mail.gmail.com>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>
	<1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315322794-10725-1-git-send-email-martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'll defer to Andrew and Jeff on this one. We could articulate a compat=
ibility
issue more clearly, but presumably this is not an issue for Windows
(or Samba) servers - but if there is a clear need for this for some oth=
er
server let us know so we can continue the discussion.

On Tue, Sep 6, 2011 at 10:26 AM, Martin Wilck
<martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org> wrote:
> This patch complements the kernel patch
> "cifs: add server-provided principal name in upcall". When cifs.upcal=
l
> is started with -p, the kernel-provided principal name from the initi=
al
> negotiation with the server will be used to obtain a ticket. If this =
fails,
> "cifs/<hostname>" and "host/hostname" fallbacks will be tried as fall=
back.
>
> This will enable kerberos-based CIFS mounts on more servers, and make
> mount.cifs work more similar to smbclient.
>
> Note that the "-p" option must be added in the cifs.upcall line in
> /etc/request-key.conf to activate this.
>
> Signed-off-by: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
> ---
> =A0cifs.upcall.8.in | =A0 =A06 ++++++
> =A0cifs.upcall.c =A0 =A0| =A0 38 +++++++++++++++++++++++++++++++-----=
--
> =A0cifs_spnego.h =A0 =A0| =A0 =A02 +-
> =A03 files changed, 38 insertions(+), 8 deletions(-)
>
> diff --git a/cifs.upcall.8.in b/cifs.upcall.8.in
> index 03842b7..7d90d1e 100644
> --- a/cifs.upcall.8.in
> +++ b/cifs.upcall.8.in
> @@ -52,6 +52,12 @@ Traditionally, the kernel has sent only a single u=
id=3D parameter to the upcall fo
> =A0Newer kernels send a creduid=3D option as well, which contains wha=
t uid it thinks actually owns the credentials that it\'s looking for\&.=
 At mount time, this is generally set to the real uid of the user doing=
 the mount. For multisession mounts, it's set to the fsuid of the mount=
 user. Set this option if you want cifs.upcall to use the older uid=3D =
parameter instead of the creduid=3D parameter\&.
> =A0.RE
> =A0.PP
> +\-\-principal\-from\-kernel|\-p
> +.RS 4
> +When this option is used, the principal name obtained by the kernel =
from the CIFS server is used rather than a principal name derived from =
the host name. If this fails, the host name is used as fallback.
> +This makes it possible to obtain credentials for CIFS servers using =
nonstandard principal names, and makes cifs mounts behave more similar =
to smbclient, which also uses the server-provided principal name.
> +.RE
> +.PP
> =A0\-\-version|\-v
> =A0.RS 4
> =A0Print version number and exit\&.
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index de92092..2adac1d 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -518,11 +518,13 @@ handle_krb5_mech(const char *oid, const char *p=
rincipal, DATA_BLOB * secblob,
> =A0#define DKD_HAVE_PID =A0 =A0 =A0 =A0 =A0 0x20
> =A0#define DKD_HAVE_CREDUID =A0 =A0 =A0 0x40
> =A0#define DKD_HAVE_USERNAME =A0 =A0 =A00x80
> +#define DKD_HAVE_PRINCIPAL =A0 =A0 0x100
> =A0#define DKD_MUSTHAVE_SET (DKD_HAVE_HOSTNAME|DKD_HAVE_VERSION|DKD_H=
AVE_SEC)
>
> =A0struct decoded_args {
> =A0 =A0 =A0 =A0int ver;
> =A0 =A0 =A0 =A0char *hostname;
> + =A0 =A0 =A0 char *principal;
> =A0 =A0 =A0 =A0char *ip;
> =A0 =A0 =A0 =A0char *username;
> =A0 =A0 =A0 =A0uid_t uid;
> @@ -557,6 +559,21 @@ decode_key_description(const char *desc, struct =
decoded_args *arg)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retval |=3D DKD_HAVE_H=
OSTNAME;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0syslog(LOG_DEBUG, "hos=
t=3D%s", arg->hostname);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strncmp(tkn, "pri=3D", 4)) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pos =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D=
 strlen(tkn);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D=
 pos - tkn;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D 4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SAFE_FREE(arg->principa=
l);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 arg->principal =3D strn=
dup(tkn + 4, len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (arg->principal =3D=3D=
 NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(=
LOG_ERR, "Unable to allocate memory");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval |=3D DKD_HAVE_PR=
INCIPAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 syslog(LOG_DEBUG, "pri=3D=
%s", arg->principal);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (!strncmp(tkn, "ip4=3D", 4) =
|| !strncmp(tkn, "ip6=3D", 4)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (pos =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len =3D=
 strlen(tkn);
> @@ -755,6 +772,7 @@ static void usage(void)
> =A0const struct option long_options[] =3D {
> =A0 =A0 =A0 =A0{"trust-dns", 0, NULL, 't'},
> =A0 =A0 =A0 =A0{"legacy-uid", 0, NULL, 'l'},
> + =A0 =A0 =A0 {"principal-from-kernel", 0, NULL, 'p'},
> =A0 =A0 =A0 =A0{"version", 0, NULL, 'v'},
> =A0 =A0 =A0 =A0{NULL, 0, NULL, 0}
> =A0};
> @@ -768,7 +786,7 @@ int main(const int argc, char *const argv[])
> =A0 =A0 =A0 =A0size_t datalen;
> =A0 =A0 =A0 =A0unsigned int have;
> =A0 =A0 =A0 =A0long rc =3D 1;
> - =A0 =A0 =A0 int c, try_dns =3D 0, legacy_uid =3D 0;
> + =A0 =A0 =A0 int c, try_dns =3D 0, legacy_uid =3D 0, use_principal =3D=
 0;
> =A0 =A0 =A0 =A0char *buf, *princ =3D NULL, *ccname =3D NULL;
> =A0 =A0 =A0 =A0char hostbuf[NI_MAXHOST], *host;
> =A0 =A0 =A0 =A0struct decoded_args arg;
> @@ -781,7 +799,7 @@ int main(const int argc, char *const argv[])
>
> =A0 =A0 =A0 =A0openlog(prog, 0, LOG_DAEMON);
>
> - =A0 =A0 =A0 while ((c =3D getopt_long(argc, argv, "cltv", long_opti=
ons, NULL)) !=3D -1) {
> + =A0 =A0 =A0 while ((c =3D getopt_long(argc, argv, "cltpv", long_opt=
ions, NULL)) !=3D -1) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (c) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 'c':
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* legacy option -- sk=
ip it */
> @@ -792,6 +810,9 @@ int main(const int argc, char *const argv[])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 'l':
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0legacy_uid++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'p':
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 use_principal++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 'v':
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("version: %s\n"=
, VERSION);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> @@ -873,9 +894,16 @@ int main(const int argc, char *const argv[])
> =A0 =A0 =A0 =A0host =3D arg.hostname;
>
> =A0 =A0 =A0 =A0// do mech specific authorization
> + =A0 =A0 =A0 oid =3D OID_KERBEROS5;
> =A0 =A0 =A0 =A0switch (arg.sec) {
> =A0 =A0 =A0 =A0case MS_KRB5:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 oid =3D OID_KERBEROS5_OLD;
> =A0 =A0 =A0 =A0case KRB5:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (use_principal && have & DKD_HAVE_PR=
INCIPAL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D handle_krb5_mech=
(oid, arg.principal, &secblob, &sess_key, ccname);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0retry_new_hostname:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* for "cifs/" service name + terminat=
ing 0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0datalen =3D strlen(host) + 5 + 1;
> @@ -885,11 +913,6 @@ retry_new_hostname:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (arg.sec =3D=3D MS_KRB5)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 oid =3D OID_KERBEROS5_O=
LD;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 oid =3D OID_KERBEROS5;
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * try getting a cifs/ principal first=
 and then fall back to
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * getting a host/ principal if that d=
oesn't work.
> @@ -965,6 +988,7 @@ out:
> =A0 =A0 =A0 =A0data_blob_free(&sess_key);
> =A0 =A0 =A0 =A0SAFE_FREE(ccname);
> =A0 =A0 =A0 =A0SAFE_FREE(arg.hostname);
> + =A0 =A0 =A0 SAFE_FREE(arg.principal);
> =A0 =A0 =A0 =A0SAFE_FREE(arg.ip);
> =A0 =A0 =A0 =A0SAFE_FREE(arg.username);
> =A0 =A0 =A0 =A0SAFE_FREE(keydata);
> diff --git a/cifs_spnego.h b/cifs_spnego.h
> index f8753a7..d43f965 100644
> --- a/cifs_spnego.h
> +++ b/cifs_spnego.h
> @@ -23,7 +23,7 @@
> =A0#ifndef _CIFS_SPNEGO_H
> =A0#define _CIFS_SPNEGO_H
>
> -#define CIFS_SPNEGO_UPCALL_VERSION 2
> +#define CIFS_SPNEGO_UPCALL_VERSION 3
>
> =A0/*
> =A0* The version field should always be set to CIFS_SPNEGO_UPCALL_VER=
SION.
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
