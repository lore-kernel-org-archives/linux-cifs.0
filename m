From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: pam module to set cifs credentials in key
 store
Date: Tue, 10 Dec 2013 07:21:27 -0500
Message-ID: <20131210072127.4da4fb66@tlielax.poochiereds.net>
References: <loom.20131113T002139-562@post.gmane.org>
	<20131112212536.6061477e@corrin.poochiereds.net>
	<5283E835.2090508@cora.nwra.com>
	<20131130053237.5ba7359d@tlielax.poochiereds.net>
	<529CE146.8090202@cora.nwra.com>
	<20131207092341.16e0fe0c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/DJG7C9DNOpMJILSuYj60Hip"
Cc: Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131207092341.16e0fe0c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--MP_/DJG7C9DNOpMJILSuYj60Hip
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, 7 Dec 2013 09:23:41 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, 02 Dec 2013 12:36:38 -0700
> Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org> wrote:
> 
> > On 11/30/2013 03:32 AM, Jeff Layton wrote:
> > > On Wed, 13 Nov 2013 13:59:33 -0700
> > > Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org> wrote:
> > >
> > >>  From e2e6e73f05d912377656675292994858b99cabbb Mon Sep 17 00:00:00 2001
> > >> From: Orion Poplawski <orion-CfuHcwXVrUc@public.gmane.org>
> > >> Date: Wed, 13 Nov 2013 13:53:30 -0700
> > >> Subject: [PATCH] Create cifscreds PAM module to insert credentials at login
> > >>
> > >
> > > Sorry for taking so long to review this. This looks like a good start.
> > > FWIW, I'd like to see this merged for the next release, which should
> > > happen in the next month or two.
> > >
> > 
> > No problem, thanks for the review.
> > 
> > > When you think this is ready for merge, please resend with a real
> > > '[PATCH]' tag in the subject, so I don't miss it...
> > 
> > Hopefully this is okay.
> > 
> > >> @@ -231,6 +236,7 @@ AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
> > >>   AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" != "no"])
> > >>   AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
> > >>   AM_CONDITIONAL(CONFIG_CIFSACL, [test "$enable_cifsacl" != "no"])
> > >> +AM_CONDITIONAL(CONFIG_PAM, [test "$enable_pam" != "no" -o "$enable_pam" != "no"])
> > >
> > > Erm...you're testing the same thing twice here?
> > 
> > Oops, copy/paste error.
> > 
> > >
> > > I think the autoconf stuff needs some work.
> > >
> > > If the box doesn't have what's needed to build it, the build is going
> > > to fail unless someone explicitly disables CONFIG_PAM.
> > >
> > > Ideally, we'd build this by default and have autoconf test for what's
> > > required to build the PAM module. If the build requires aren't present,
> > > then the building of the PAM module should be disabled with a warning
> > > message that states that.
> > >
> > > There are some other examples of that sort of behavior in configure.ac.
> > > It's a little more complicated, but it makes life easier for people
> > > building the package.
> > 
> > Okay, I've added a section for checking for security/pam_appl.h.  Should we 
> > also check for the other headers/libraries as well?
> > 
> > I've also added to the keyutils.h section so as to disable the pam module 
> > there too.
> > 
> > 
> > >> +static void
> > >> +free_password (char *password)
> > >> +{
> > >> +	volatile char *vp;
> > >> +	size_t len;
> > >> +
> > >> +	if (!password) {
> > >> +		return;
> > >> +	}
> > >> +
> > >> +	/* Defeats some optimizations */
> > >> +	len = strlen (password);
> > >> +	memset (password, 0xAA, len);
> > >> +	memset (password, 0xBB, len);
> > >> +
> > >> +	/* Defeats others */
> > >> +	vp = (volatile char*)password;
> > >> +	while (*vp) {
> > >> +		*(vp++) = 0xAA;
> > >> +	}
> > >> +
> > >
> > > I'm all for scrubbing the pw memory but that seems a bit like overkill.
> > > Got any references to cite about why you need to write over it 3 times?
> > >
> > > If that's really necessary, then we should move the password handling
> > > in cifscreds and mount.cifs binary to use something like this too.
> > > Maybe consider putting this in an a.out lib and linking it into all 3?
> > 
> > This is copied directly from the gnome-keyring pam module.  I don't have any 
> > references for why it is done.  My guess is because it is part of a PAM chain, 
> > so perhaps to prevent later modules from accessing it?  Or perhaps just to 
> > scrub memory?  I suspect that the multiple times is to defeat compiler 
> > optimization making it a no-op?
> > 
> > >> +
> > >> +/**
> > >> + * This is called when the PAM session is closed.
> > >> + *
> > >> + * Currently it does nothing.  The session closing should remove the passwords
> > >> + *
> > >> + * @param ph PAM handle
> > >> + * @param flags currently unused, TODO: check for silent flag
> > >> + * @param argc number of arguments for this PAM module
> > >> + * @param argv array of arguments for this PAM module
> > >> + * @return PAM_SUCCESS
> > >> + */
> > >> +PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph, int flags, int argc, const char **argv)
> > >> +{
> > >> +	return PAM_SUCCESS;
> > >> +}
> > >> +
> > >
> > > Cleaning up after you're done seems like a good thing to do. The thing
> > > we need to be careful about here is that we might still need these
> > > creds to write out dirty data. This may require some consideration...
> > 
> > Yeah, I'm not sure what there is to do here really.  Anything would be more 
> > than what is done currently running cifscreds directly.
> > 
> > >> +/**
> > >> + * This is called when PAM is invoked to change the user's authentication token.
> > >> + * TODO - update the credetials
> > >> + *
> > >> + * @param ph PAM handle
> > >> + * @param flags currently unused, TODO: check for silent flag
> > >> + * @param argc number of arguments for this PAM module
> > >> + * @param argv array of arguments for this PAM module
> > >> + * @return PAM_SUCCESS
> > >> + */
> > >> + PAM_EXTERN int pam_sm_setcred(pam_handle_t *ph, int flags, int argc, const char **argv)
> > >> +{
> > >> +	return PAM_SUCCESS;
> > >> +}
> > >
> > > The rest looks reasonably straightforward, but I don't PAM that well,
> > > so it's hard for me to comment.
> > >
> > 
> > Actually, I'm not sure what should be done here.  gnome-keyring doesn't do 
> > anything.  http://pubs.opengroup.org/onlinepubs/008329799/pam_sm_setcred.htm 
> > describes the call.
> > 
> > Looks like the pam_sm_chauthtok function is used to update the passwords. 
> > I've made attempts to implement that.
> > 
> 
> Oh, and one other thing...
> 
> Can you resend the above patch with a Signed-off-by line?
> 

Ok, I tested the pam_module this morning and it seems to work as
expected. At this point, I think we can go ahead and merge it once we
have a manpage.

I also intend to add this patch on top, which just does a little
cleanup and fixes some build warnings.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--MP_/DJG7C9DNOpMJILSuYj60Hip
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-cifscreds-fix-up-some-whitespace-typos-and-build-war.patch

=46rom d12443fdd268e547412683d43dc03f266260f7c8 Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Date: Sat, 7 Dec 2013 06:52:26 -0500
Subject: [cifs-utils PATCH] cifscreds: fix up some whitespace, typos and bu=
ild
 warnings in pam_cifscreds.c
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

gcc -g -O2 -Wall -Wextra -D_FORTIFY_SOURCE=3D2 -fpie -pie -Wl,-z,relro,-z,n=
ow  -shared -fpic -o pam_cifscreds.so pam_cifscreds.c cifskey.c resolve_hos=
t.c util.c -lpam -lkeyutils
pam_cifscreds.c: In function =E2=80=98cleanup_free_password=E2=80=99:
pam_cifscreds.c:143:38: warning: unused parameter =E2=80=98ph=E2=80=99 [-Wu=
nused-parameter]
 cleanup_free_password (pam_handle_t *ph, void *data, int pam_end_status)
                                      ^
pam_cifscreds.c:143:58: warning: unused parameter =E2=80=98pam_end_status=
=E2=80=99 [-Wunused-parameter]
 cleanup_free_password (pam_handle_t *ph, void *data, int pam_end_status)
                                                          ^
pam_cifscreds.c: In function =E2=80=98cifscreds_pam_update=E2=80=99:
pam_cifscreds.c:271:8: warning: variable =E2=80=98addrs=E2=80=99 set but no=
t used [-Wunused-but-set-variable]
  char *addrs[16];
        ^
pam_cifscreds.c: In function =E2=80=98pam_sm_authenticate=E2=80=99:
pam_cifscreds.c:359:58: warning: unused parameter =E2=80=98unused=E2=80=99 =
[-Wunused-parameter]
 PAM_EXTERN int pam_sm_authenticate(pam_handle_t *ph, int unused, int argc,=
 const char **argv)
                                                          ^
pam_cifscreds.c: In function =E2=80=98pam_sm_open_session=E2=80=99:
pam_cifscreds.c:414:58: warning: unused parameter =E2=80=98flags=E2=80=99 [=
-Wunused-parameter]
 PAM_EXTERN int pam_sm_open_session(pam_handle_t *ph, int flags, int argc, =
const char **argv)
                                                          ^
pam_cifscreds.c: In function =E2=80=98pam_sm_close_session=E2=80=99:
pam_cifscreds.c:487:51: warning: unused parameter =E2=80=98ph=E2=80=99 [-Wu=
nused-parameter]
 PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph, int flags, int argc,=
 const char **argv)
                                                   ^
pam_cifscreds.c:487:59: warning: unused parameter =E2=80=98flags=E2=80=99 [=
-Wunused-parameter]
 PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph, int flags, int argc,=
 const char **argv)
                                                           ^
pam_cifscreds.c:487:70: warning: unused parameter =E2=80=98argc=E2=80=99 [-=
Wunused-parameter]
 PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph, int flags, int argc,=
 const char **argv)
                                                                      ^
pam_cifscreds.c:487:89: warning: unused parameter =E2=80=98argv=E2=80=99 [-=
Wunused-parameter]
 PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph, int flags, int argc,=
 const char **argv)
                                                                           =
              ^
pam_cifscreds.c: In function =E2=80=98pam_sm_setcred=E2=80=99:
pam_cifscreds.c:501:45: warning: unused parameter =E2=80=98ph=E2=80=99 [-Wu=
nused-parameter]
 PAM_EXTERN int pam_sm_setcred(pam_handle_t *ph, int flags, int argc, const=
 char **argv)
                                             ^
pam_cifscreds.c:501:53: warning: unused parameter =E2=80=98flags=E2=80=99 [=
-Wunused-parameter]
 PAM_EXTERN int pam_sm_setcred(pam_handle_t *ph, int flags, int argc, const=
 char **argv)
                                                     ^
pam_cifscreds.c:501:64: warning: unused parameter =E2=80=98argc=E2=80=99 [-=
Wunused-parameter]
 PAM_EXTERN int pam_sm_setcred(pam_handle_t *ph, int flags, int argc, const=
 char **argv)
                                                                ^
pam_cifscreds.c:501:83: warning: unused parameter =E2=80=98argv=E2=80=99 [-=
Wunused-parameter]
 PAM_EXTERN int pam_sm_setcred(pam_handle_t *ph, int flags, int argc, const=
 char **argv)
                                                                           =
        ^

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 pam_cifscreds.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/pam_cifscreds.c b/pam_cifscreds.c
index 1385146..e0d8a55 100644
--- a/pam_cifscreds.c
+++ b/pam_cifscreds.c
@@ -140,7 +140,8 @@ free_password (char *password)
 }
=20
 static void
-cleanup_free_password (pam_handle_t *ph, void *data, int pam_end_status)
+cleanup_free_password (pam_handle_t *ph __attribute__((unused)), void *dat=
a,
+			int pam_end_status __attribute__((unused)))
 {
 	free_password (data);
 }
@@ -268,7 +269,6 @@ static int cifscreds_pam_update(pam_handle_t *ph, const=
 char *user, const char *
 	int ret =3D PAM_SUCCESS;
 	char addrstr[MAX_ADDR_LIST_LEN];
 	char *currentaddress, *nextaddress;
-	char *addrs[16];
 	int id, count =3D 0;
 	char keytype =3D ((args & ARG_DOMAIN) =3D=3D ARG_DOMAIN) ? 'd' : 'a';
=20
@@ -308,10 +308,8 @@ static int cifscreds_pam_update(pam_handle_t *ph, cons=
t char *user, const char *
 		*nextaddress++ =3D '\0';
=20
 	while (currentaddress) {
-		if (key_search(currentaddress, keytype) > 0) {
-			addrs[count] =3D currentaddress;
+		if (key_search(currentaddress, keytype) > 0)
 			count++;
-		}
=20
 		currentaddress =3D nextaddress;
 		if (currentaddress) {
@@ -322,7 +320,7 @@ static int cifscreds_pam_update(pam_handle_t *ph, const=
 char *user, const char *
 	}
=20
 	if (!count) {
-		pam_syslog(ph, LOG_ERR, "You have no same stached credentials for %s", h=
ostdomain);
+		pam_syslog(ph, LOG_ERR, "You have no same stashed credentials for %s", h=
ostdomain);
 		return PAM_SERVICE_ERR;
 	}
=20
@@ -344,7 +342,7 @@ static int cifscreds_pam_update(pam_handle_t *ph, const=
 char *user, const char *
  * scenarios are possible:
  *
  * - A session is already available which usually means that the user is a=
lready
- *	logged on and PAM has been used inside the screensaver. In that case, n=
o need to=20
+ *	logged on and PAM has been used inside the screensaver. In that case, n=
o need to
  *	do anything(?).
  *
  * - A session is not yet available. Store the password inside PAM data so
@@ -356,7 +354,7 @@ static int cifscreds_pam_update(pam_handle_t *ph, const=
 char *user, const char *
  * @param argv array of arguments for this PAM module
  * @return any of the PAM return values
  */
-PAM_EXTERN int pam_sm_authenticate(pam_handle_t *ph, int unused, int argc,=
 const char **argv)
+PAM_EXTERN int pam_sm_authenticate(pam_handle_t *ph, int unused __attribut=
e__((unused)), int argc, const char **argv)
 {
 	const char *hostdomain;
 	const char *user;
@@ -365,7 +363,7 @@ PAM_EXTERN int pam_sm_authenticate(pam_handle_t *ph, in=
t unused, int argc, const
 	int ret;
=20
 	args =3D parse_args(ph, argc, argv, &hostdomain);
-=09
+
 	/* Figure out and/or prompt for the user name */
 	ret =3D pam_get_user(ph, &user, NULL);
 	if (ret !=3D PAM_SUCCESS || !user) {
@@ -411,7 +409,7 @@ PAM_EXTERN int pam_sm_authenticate(pam_handle_t *ph, in=
t unused, int argc, const
  * @param argv array of arguments for this PAM module
  * @return any of the PAM return values
  */
-PAM_EXTERN int pam_sm_open_session(pam_handle_t *ph, int flags, int argc, =
const char **argv)
+PAM_EXTERN int pam_sm_open_session(pam_handle_t *ph, int flags __attribute=
__((unused)), int argc, const char **argv)
 {
 	const char *user =3D NULL;
 	const char *password =3D NULL;
@@ -484,7 +482,7 @@ PAM_EXTERN int pam_sm_open_session(pam_handle_t *ph, in=
t flags, int argc, const
  * @param argv array of arguments for this PAM module
  * @return PAM_SUCCESS
  */
-PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph, int flags, int argc,=
 const char **argv)
+PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph __attribute__((unused=
)), int flags __attribute__((unused)), int argc __attribute__((unused)), co=
nst char **argv __attribute__((unused)))
 {
 	return PAM_SUCCESS;
 }
@@ -498,7 +496,7 @@ PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph, i=
nt flags, int argc, const
  * @param argv array of arguments for this PAM module
  * @return PAM_SUCCESS
  */
-PAM_EXTERN int pam_sm_setcred(pam_handle_t *ph, int flags, int argc, const=
 char **argv)
+PAM_EXTERN int pam_sm_setcred(pam_handle_t *ph __attribute__((unused)), in=
t flags __attribute__((unused)), int argc __attribute__((unused)), const ch=
ar **argv __attribute__((unused)))
 {
 	return PAM_SUCCESS;
 }
@@ -520,15 +518,14 @@ pam_sm_chauthtok (pam_handle_t *ph, int flags, int ar=
gc, const char **argv)
 	const char *password =3D NULL;
 	uint args;
 	int ret;
-=09
+
 	args =3D parse_args(ph, argc, argv, &hostdomain);
=20
 	if (flags & PAM_UPDATE_AUTHTOK) {
 		/* Figure out the user name */
 		ret =3D pam_get_user(ph, &user, NULL);
 		if (ret !=3D PAM_SUCCESS) {
-			pam_syslog(ph, LOG_ERR, "couldn't get the user name: %s",=20
-				pam_strerror (ph, ret));
+			pam_syslog(ph, LOG_ERR, "couldn't get the user name: %s", pam_strerror =
(ph, ret));
 			return PAM_SERVICE_ERR;
 		}
=20
@@ -537,14 +534,13 @@ pam_sm_chauthtok (pam_handle_t *ph, int flags, int ar=
gc, const char **argv)
 			if (ret =3D=3D PAM_SUCCESS) {
 				pam_syslog(ph, LOG_WARNING, "no password is available for user");
 			} else {
-				pam_syslog(ph, LOG_WARNING, "no password is available for user: %s",
-					pam_strerror(ph, ret));
+				pam_syslog(ph, LOG_WARNING, "no password is available for user: %s", p=
am_strerror(ph, ret));
 			}
 			return PAM_AUTHTOK_RECOVER_ERR;
 		}
-=09
+
 		return cifscreds_pam_update(ph, user, password, args, hostdomain);
 	}
-	else=20
+	else
 		return PAM_IGNORE;
 }
--=20
1.8.4.2


--MP_/DJG7C9DNOpMJILSuYj60Hip--
