From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: questions cifs.upcall.c
Date: Thu, 24 Mar 2016 12:50:57 -0400
Message-ID: <20160324125057.59d34f5b@synchrony.poochiereds.net>
References: <B6CF10CD-10A5-4A30-93D8-E89FE6ED0697@fhcrc.org>
	<20160324112427.46b0ad33@synchrony.poochiereds.net>
	<E338E595-7E4A-4738-A69F-6235203605A0@fhcrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E338E595-7E4A-4738-A69F-6235203605A0-q9hIisBwmLrYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 24 Mar 2016 15:46:30 +0000
"Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org> wrote:

> thanks for your reply. I=E2=80=99ve already written the code and it s=
eems to work fine at our shop. I will request a pull request for the 6.=
5 release. below is a summary of what I=E2=80=99ve implemented.  I only=
 check the krb5.conf if no credentials are found in /run and /tmp locat=
ions.
>=20
> #define CIFS_DEFAULT_KRB5_KEYTAB "/etc/krb5.keytab"
> #define CIFS_DEFAULT_KRB5_CONF   "/etc/krb5.conf"
> #define CIFS_CCACHE_CONF         "default_ccache_name"
>=20
>=20

Great! Please send patches instead of a pull request, and cc the
linux-cifs mailing list. Others may want to review them as well.

Thanks,
Jeff

>=20
> /*
>  * read /etc/krb5.conf and=20
>  *  if found return default_ccache_name
>  * else return NULL
>  */
> static char* krb5conf_cc_name_path(char* krb5_conf_file);
>=20
> main()
> {
> ...
>         ccdir =3D resolve_krb5_dir(CIFS_DEFAULT_KRB5_USER_DIR, uid);
> 	if (ccdir !=3D NULL)
> 		find_krb5_cc(ccdir, uid, &best_cache, &best_time);
> 	ccname =3D find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid, &best_cache, &be=
st_time);
> 	if (ccname =3D=3D NULL) {
> 		ccdir =3D krb5conf_cc_name_path(CIFS_KRB5_CONF);
> 		ccname =3D find_krb5_cc(ccdir, uid, &best_cache, &best_time);
> 	}
> ...
> }
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> On 3/24/16, 8:24 AM, "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>=20
> >On Mon, 21 Mar 2016 17:37:35 +0000
> >"Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org> wrote:
> > =20
> >> Jeff,
> >>=20
> >> I am setting krb5.conf default_ccache_name =3D (shared mount point=
).  The MIT krb5 routines work fine with the shared drive, but cifs.upc=
all is not reading the /etc/krb5.conf file to find the new location.  D=
efault search locations seem to be hard-coded into cifs.upcall.
> >>=20
> >> I am using Ubuntu 14.04  cifs-utils 6.0.  I have also check Ubuntu=
 16.04 with cifs-util 6.5.
> >>=20
> >> In 2009 you had a patch to read the krb5CCNAME environment variabl=
e, this patch has since been removed.  Setting the default path in krb5=
=2Econf seems to solve a lot of problems but cifs.upcall is not checkin=
g that location. Is there a reason why the krb5.conf is not checked?
> >>=20
> >> WHY are we doing this?  We run a large linux cluster.  Users inter=
act with a set of head nodes.  When users login to the headnotes their =
krb5 ticket is updated.  From head nodes users can run jobs on the Linu=
x cluster.  The cluster nodes do not have updated tickets so users jobs=
 fail.  So we would like to use a shared drive for the tickets so that =
all the cluster nodes have an updated ticket.
> >>=20
> >> Thanks
> >>=20
> >> John Dey
> >> Jidey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org
> >> John-pGYbrA4uTiZBDgjK7y7TUQ@public.gmane.org
> >>=20
> >>=20
> >>  =20
> >
> >(cc'ing linux-cifs mailing list)
> >
> >Hmm, it's been so long since I looked at that code, I've forgotten h=
ow
> >it works. Let's see...
> >
> >        ccdir =3D resolve_krb5_dir(CIFS_DEFAULT_KRB5_USER_DIR, uid);=
             =20
> >        if (ccdir !=3D NULL)                                        =
             =20
> >                find_krb5_cc(ccdir, uid, &best_cache, &best_time);  =
           =20
> >        ccname =3D find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid, &best_ca=
che,         =20
> >                              &best_time);                          =
   =20
> >
> >
> >...and those CIFS_DEFAULT_* macros are:
> >
> >#define CIFS_DEFAULT_KRB5_DIR           "/tmp"                      =
           =20
> >#define CIFS_DEFAULT_KRB5_USER_DIR      "/run/user/%U"
> >
> >So yeah, it does seem to be hardcoded. Why was it written that way?
> >ISTR that older versions of krb5 libs made it hard to get to that
> >variable from the config file, but maybe I'm remembering wrong.
> >
> >It probably wouldn't be too hard to fix, but you'd have to dig into =
the
> >krb5 library API. I doubt I'll have time to do that anytime soon. If
> >you or your OS vendor wants to propose some patches however, I'd be
> >happy to review (and eventually) merge them.
> >
> >Cheers,
> >--=20
> >Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> =20


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
