From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: questions cifs.upcall.c
Date: Fri, 1 Apr 2016 18:30:33 -0400
Message-ID: <20160401183033.2f3eb700@synchrony.poochiereds.net>
References: <B6CF10CD-10A5-4A30-93D8-E89FE6ED0697@fhcrc.org>
	<20160324112427.46b0ad33@synchrony.poochiereds.net>
	<E338E595-7E4A-4738-A69F-6235203605A0@fhcrc.org>
	<20160324125057.59d34f5b@synchrony.poochiereds.net>
	<A8994554-2D81-4D87-A767-EF9408C1C86E@fhcrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A8994554-2D81-4D87-A767-EF9408C1C86E-q9hIisBwmLrYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 25 Mar 2016 22:11:54 +0000
"Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org> wrote:

> patch attached.  Based on cifs-util-6.4=20
>=20
> Feature:  Check /etc/krb5.conf for default_ccache_name. This patch wi=
ll allow users to store Kerberos tickets on a shared drive. HPC cluster=
s run jobs on behalf of users. The cluster effectively functions as a s=
ingle compute resource. Jobs that require Kerberos keys will be able to=
 access keys from a common shared drive defined by krb5.conf.
> =20
>=20
>=20
>=20
> On 3/24/16, 9:50 AM, "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>=20
> >On Thu, 24 Mar 2016 15:46:30 +0000
> >"Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org> wrote:
> >
> >> thanks for your reply. I=E2=80=99ve already written the code and i=
t seems to work fine at our shop. I will request a pull request for the=
 6.5 release. below is a summary of what I=E2=80=99ve implemented.  I o=
nly check the krb5.conf if no credentials are found in /run and /tmp lo=
cations.
> >>=20
> >> #define CIFS_DEFAULT_KRB5_KEYTAB "/etc/krb5.keytab"
> >> #define CIFS_DEFAULT_KRB5_CONF   "/etc/krb5.conf"
> >> #define CIFS_CCACHE_CONF         "default_ccache_name"
> >>=20
> >>=20
> >
> >Great! Please send patches instead of a pull request, and cc the
> >linux-cifs mailing list. Others may want to review them as well.
> >
> >Thanks,
> >Jeff
> >
> >>=20
> >> /*
> >>  * read /etc/krb5.conf and=20
> >>  *  if found return default_ccache_name
> >>  * else return NULL
> >>  */
> >> static char* krb5conf_cc_name_path(char* krb5_conf_file);
> >>=20
> >> main()
> >> {
> >> ...
> >>         ccdir =3D resolve_krb5_dir(CIFS_DEFAULT_KRB5_USER_DIR, uid=
);
> >> 	if (ccdir !=3D NULL)
> >> 		find_krb5_cc(ccdir, uid, &best_cache, &best_time);
> >> 	ccname =3D find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid, &best_cache, =
&best_time);
> >> 	if (ccname =3D=3D NULL) {
> >> 		ccdir =3D krb5conf_cc_name_path(CIFS_KRB5_CONF);
> >> 		ccname =3D find_krb5_cc(ccdir, uid, &best_cache, &best_time);
> >> 	}
> >> ...
> >> }
> >>=20
> >>=20
> >>=20
> >>=20
> >>=20
> >>=20
> >>=20
> >> On 3/24/16, 8:24 AM, "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >>=20
> >> >On Mon, 21 Mar 2016 17:37:35 +0000
> >> >"Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org> wrote:
> >> > =20
> >> >> Jeff,
> >> >>=20
> >> >> I am setting krb5.conf default_ccache_name =3D (shared mount po=
int).  The MIT krb5 routines work fine with the shared drive, but cifs.=
upcall is not reading the /etc/krb5.conf file to find the new location.=
  Default search locations seem to be hard-coded into cifs.upcall.
> >> >>=20
> >> >> I am using Ubuntu 14.04  cifs-utils 6.0.  I have also check Ubu=
ntu 16.04 with cifs-util 6.5.
> >> >>=20
> >> >> In 2009 you had a patch to read the krb5CCNAME environment vari=
able, this patch has since been removed.  Setting the default path in k=
rb5.conf seems to solve a lot of problems but cifs.upcall is not checki=
ng that location. Is there a reason why the krb5.conf is not checked?
> >> >>=20
> >> >> WHY are we doing this?  We run a large linux cluster.  Users in=
teract with a set of head nodes.  When users login to the headnotes the=
ir krb5 ticket is updated.  From head nodes users can run jobs on the L=
inux cluster.  The cluster nodes do not have updated tickets so users j=
obs fail.  So we would like to use a shared drive for the tickets so th=
at all the cluster nodes have an updated ticket.
> >> >>=20
> >> >> Thanks
> >> >>=20
> >> >> John Dey
> >> >> Jidey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org
> >> >> John-pGYbrA4uTiZBDgjK7y7TUQ@public.gmane.org
> >> >>=20
> >> >>=20
> >> >>  =20
> >> >
> >> >(cc'ing linux-cifs mailing list)
> >> >
> >> >Hmm, it's been so long since I looked at that code, I've forgotte=
n how
> >> >it works. Let's see...
> >> >
> >> >        ccdir =3D resolve_krb5_dir(CIFS_DEFAULT_KRB5_USER_DIR, ui=
d);             =20
> >> >        if (ccdir !=3D NULL)                                     =
                =20
> >> >                find_krb5_cc(ccdir, uid, &best_cache, &best_time)=
;             =20
> >> >        ccname =3D find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid, &best=
_cache,         =20
> >> >                              &best_time);                       =
      =20
> >> >
> >> >
> >> >...and those CIFS_DEFAULT_* macros are:
> >> >
> >> >#define CIFS_DEFAULT_KRB5_DIR           "/tmp"                   =
              =20
> >> >#define CIFS_DEFAULT_KRB5_USER_DIR      "/run/user/%U"
> >> >
> >> >So yeah, it does seem to be hardcoded. Why was it written that wa=
y?
> >> >ISTR that older versions of krb5 libs made it hard to get to that
> >> >variable from the config file, but maybe I'm remembering wrong.
> >> >
> >> >It probably wouldn't be too hard to fix, but you'd have to dig in=
to the
> >> >krb5 library API. I doubt I'll have time to do that anytime soon.=
 If
> >> >you or your OS vendor wants to propose some patches however, I'd =
be
> >> >happy to review (and eventually) merge them.
> >> >
> >> >Cheers,
> >> >--=20
> >> >Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =20
> >
> >
> >--=20
> >Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

=46irst, in the future, please send a unified diff and please send it
inline. If you're using git, then you really want to use "git
format-patch" and then "git send-email" to send it.

Here's basically what it should look like:

> [PATCH] cifs.upcall: use krb5 config file to find default credcache
>=20
> ---
>  cifs.upcall.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++
>  1 file changed, 61 insertions(+)
>=20
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index e8544c2b68ad..ec726c20e740 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -46,6 +46,7 @@
>  #include <netdb.h>
>  #include <arpa/inet.h>
>  #include <ctype.h>
> +#include <fcntl.h>
> =20
>  #include "replace.h"
>  #include "data_blob.h"
> @@ -55,6 +56,9 @@
>  #define	CIFS_DEFAULT_KRB5_DIR		"/tmp"
>  #define	CIFS_DEFAULT_KRB5_USER_DIR	"/run/user/%U"
>  #define	CIFS_DEFAULT_KRB5_PREFIX	"krb5cc"
> +#define CIFS_DEFAULT_KRB5_CONF          "/etc/krb5.conf"
> +#define CIFS_CCACHE_CONF                "default_ccache_name"
> +#define CIFS_CCACHE_CONF_LEN            19
> =20
>  #define	MAX_CCNAME_LEN			PATH_MAX + 5
> =20
> @@ -295,6 +299,57 @@ static char *resolve_krb5_dir(const char *patter=
n, uid_t uid)
>  		return NULL;
>  }
> =20
> +/*
> + * read /etc/krb5.conf
> + *  if found return default_ccache_name
> + *  else return NULL
> + */
> +static char*
> +krb5conf_cc_name_path(char* krb5conf_file)
> +{
> +   char buf[4096], name[MAX_CCNAME_LEN];
> +   char *s, *t;
> +   int fd, left;
> +   ssize_t len;
> +
> +   fd =3D open(krb5conf_file, O_RDONLY);
> +   if (fd < 0) {
> +       syslog(LOG_DEBUG, "%s: unable to open %s: %d", __func__, buf,=
 errno);
> +       return NULL;
> +   }
> +   name[0] =3D '\0';
> +   s =3D buf;
> +   while((len =3D read(fd,buf,4096)) > 0) {
> +      left =3D (int)len;
> +      while ( left > 0 ) {
> +          while( *s && isspace(*s) && left ) {  s++; left--; }  /* s=
kip leading white space */
> +          if ( strncmp(s, CIFS_CCACHE_CONF, CIFS_CCACHE_CONF_LEN) =3D=
=3D 0) {
> +             s =3D s + CIFS_CCACHE_CONF_LEN;
> +             left -=3D CIFS_CCACHE_CONF_LEN;
> +             while( left > 0 && (isspace(*s) || *s =3D=3D '=3D') ) {=
  s++; left--; }  /* skip ' =3D ' */
> +             t =3D name;
> +             while( *s && !isspace(*s)) {
> +                *t =3D *s;
> +                s++;
> +                t++;
> +             }
> +             break;
> +          }
> +          while( *s && *s !=3D '\n' && left) { s++; left--; } /* ski=
p to end of line */
> +      }
> +   }
> +   close(fd);
> +   if ( name[0] =3D=3D '\0')
> +      return NULL;
> +   if (strncmp(name, "FILE:", 5) =3D=3D 0) {  /* return directory pa=
rt of ccache type <FILE> */
> +          s =3D name + 5;
> +          t =3D rindex(s, '/');
> +          *t =3D '\0';
> +          return strndup(s, MAX_CCNAME_LEN - 5);
> +   }
> +   return strndup(name, MAX_CCNAME_LEN);
> +}
> +

The function above is frightening. If you want to get config settings
from krb5.conf, I'm pretty sure there are functions for that in the
kerberos libraries.

Also, this only looks like it works with FILE: cache types. There are
others, and cifs.upcall needs to support them.


>  /* search for a credcache that looks like a likely candidate */
>  static char *find_krb5_cc(const char *dirname, uid_t uid,
>  			  char **best_cache, time_t *best_time)
> @@ -959,6 +1014,12 @@ int main(const int argc, char *const argv[])
>  		find_krb5_cc(ccdir, uid, &best_cache, &best_time);
>  	ccname =3D find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid, &best_cache,
>  			      &best_time);
> +        if (ccname =3D=3D NULL) {
> +            ccdir =3D krb5conf_cc_name_path(CIFS_DEFAULT_KRB5_CONF);
> +            ccname =3D find_krb5_cc(ccdir, uid, &best_cache, &best_t=
ime);
> +        }
> +        syslog(LOG_DEBUG, "ccname: %s arg.username: %s", ccname, arg=
=2Eusername );
> +
>  	SAFE_FREE(ccdir);
> =20
>  	/* Couldn't find credcache? Try to use keytab */

If you know where the credcache is a'la the config file, then why
bother checking the hardcoded locations first?


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
