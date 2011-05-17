From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create new binary cifs.idmap for sid to
 uid/gid mapping
Date: Tue, 17 May 2011 12:09:46 -0400
Message-ID: <20110517120946.7890152b@tlielax.poochiereds.net>
References: <1304667239-29127-1-git-send-email-shirishp@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304667239-29127-1-git-send-email-shirishp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  6 May 2011 02:33:59 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Handle cifs.idmap type of key. Extract a SID string from the description
> and map it to either an uid or gid using winbind APIs.
> If that fails (e.g. because winbind is not installed/running or winbind returns
> an error), try to obtain uid of 'nobody' and gid of 'nogroup'.
> And if that fails, kernel assigns uid and gid (from mount superblock).
> 
> Enable including winbind header files and idmapping code conditional
> to winbind devel rpms (header and library).
> 
> An entry such as this
> 
> create  cifs.idmap   *       *               /usr/sbin/cifs.idmap %k
> 
> is needed in the file /etc/request-key.conf.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Makefile.am  |    8 ++
>  cifs.idmap.c |  215 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  configure.ac |   58 +++++++++++++++-
>  3 files changed, 280 insertions(+), 1 deletions(-)
>  create mode 100644 cifs.idmap.c
> 
> diff --git a/Makefile.am b/Makefile.am
> index 67a0190..ad33914 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -30,3 +30,11 @@ bin_PROGRAMS = cifscreds
>  cifscreds_SOURCES = cifscreds.c resolve_host.c util.c
>  cifscreds_LDADD = -lkeyutils
>  endif
> +
> +if CONFIG_CIFSIDMAP
> +cifs_idmap_sbindir = /usr/local/sbin

	^^^^^^^^^
That looks wrong. If I configure with --prefix=/usr then this is still
going to go in /usr/local/sbin, right? I think you instead want to
append cifs.idmap to sbin_PROGRAMS.
 
> +cifs_idmap_sbin_PROGRAMS = cifs.idmap
> +cifs_idmap_SOURCES = cifs.idmap.c
> +cifs_idmap_LDADD = -lkeyutils $(WINB_LDADD)
> +endif
> +
> diff --git a/cifs.idmap.c b/cifs.idmap.c
> new file mode 100644
> index 0000000..0f76873
> --- /dev/null
> +++ b/cifs.idmap.c
> @@ -0,0 +1,215 @@
> +/*
> +* CIFS idmap helper.
> +* Copyright (C) Shirish Pargaonkar (shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org) 2011
> +*
> +* Used by /sbin/request-key.conf for handling
> +* cifs upcall for SID to uig/gid and uid/gid to SID mapping.
> +* You should have keyutils installed and add
> +* this lines to /etc/request-key.conf file:
> +
> +    create cifs.idmap * * /usr/local/sbin/cifs.idmap %k
> +
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License as published by
> +* the Free Software Foundation; either version 2 of the License, or
> +* (at your option) any later version.
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> +* GNU General Public License for more details.
> +* You should have received a copy of the GNU General Public License
> +* along with this program; if not, write to the Free Software
> +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> +*/
> +
> +#ifdef HAVE_CONFIG_H
> +#include "config.h"
> +#endif /* HAVE_CONFIG_H */
> +
> +#include <string.h>
> +#include <getopt.h>
> +#include <syslog.h>
> +#include <dirent.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +#ifdef HAVE_KEYUTILS_H
> +#include <keyutils.h>
> +#endif /* HAVE_KEYUTILS_H */
	^^^^^^^^^^
This can't be built w/o keyutils, right? So I don't think we need the
#ifdefs.

> +#include <stdint.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <limits.h>
> +#ifdef HAVE_WBCLIENT_H
> +#include <wbclient.h>
> +#endif /* HAVE_WBCLIENT_H */
> +
> +static const char *prog = "cifs.idmap";
> +
> +static void usage(void)
> +{
> +	syslog(LOG_INFO, "Usage: %s [-t] [-v] [-l] key_serial", prog);
> +	fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial\n", prog);
> +}
> +
> +#ifdef HAVE_LIBWBCLIENT
> +static int
> +cifs_idmap(const key_serial_t key, const char *key_descr)
> +{
> +	int i;
> +	uid_t uid = 0;
> +	gid_t gid = 0;;
> +	wbcErr rc = 1;
> +	const char *keyend = key_descr;
> +	struct wbcDomainSid sid;
> +	struct passwd *pw;
> +	struct group *gr;
> +
> +	/* skip next 4 ';' delimiters to get to description */
> +	for (i = 1; i <= 4; ++i) {
> +		keyend = index(keyend + 1, ';');
> +		if (!keyend) {
> +			syslog(LOG_ERR, "invalid key description: %s",
> +			       key_descr);
> +			return 1;
> +		}
> +	}
> +	keyend++;
> +

No real bounds checking here. It seems unlikely, but a buggy kernel
could send a garbled string and you could walk off the end of it here.

> +	/*
> +	 * Use winbind to convert received string to a SID and lookup
> +	 * name and map that SID to an uid.  If either of these
> +	 * function calls return with an error,  use system calls to obtain
> +	 * uid of user "nobody". If winbind fails to map a SID to an UID
> +	 * and there is no user named "nobody", return error to the
> +	 * upcall caller. Otherwise instanticate a key using that uid.
> +	 *
> +	 * The same applies to SID and gid mapping.  Instead of a
> +	 * user "nobody", user "nogroup" is looked up if winbind
> +	 * fails to map a SID to a gid.
> +	 */
> +	if (strncmp(keyend, "os", 2) == 0) {
> +		keyend = index(keyend + 1, ':');
> +		keyend++;
		^^^^^^^^^
		ditto on the bounds checks

> +		rc = wbcStringToSid(keyend, &sid);
> +		if (rc)
> +			syslog(LOG_DEBUG, "O strtosid: %s, rc: %d", keyend, rc);
> +		else {
> +			rc = wbcSidToUid(&sid, &uid);
> +			if (rc)
> +				syslog(LOG_DEBUG, "SID %s to uid wbc error: %d",
> +						keyend, rc);
> +		}
> +		if (rc) { /* either of the two wbcSid functions failed */
> +			pw = getpwnam("nobody");
> +			if (!pw)
> +				syslog(LOG_DEBUG, "SID %s to uid pw error: %d",
> +					keyend, rc);
> +			else {
> +				uid = pw->pw_uid;
> +				rc = 0;
> +			}
> +		}
> +		if (!rc) { /* SID has been mapped to a uid */
> +			rc = keyctl_instantiate(key, &uid, sizeof(uid_t), 0);
> +			if (rc)
> +				syslog(LOG_ERR, "%s: key inst: %s",
> +					__func__, strerror(errno));
> +		}
> +	} else if (strncmp(keyend, "gs", 2) == 0) {
> +		keyend = index(keyend + 1, ':');
> +		keyend++;
> +		rc = wbcStringToSid(keyend, &sid);
> +		if (rc)
> +			syslog(LOG_DEBUG, "O strtosid: %s, rc: %d", keyend, rc);
> +		else {
> +			rc = wbcSidToGid(&sid, &gid);
> +			if (rc)
> +				syslog(LOG_DEBUG, "SID %s to gid wbc error: %d",
> +						keyend, rc);
> +		}
> +		if (rc) { /* either of the two wbcSid functions failed */
> +			gr = getgrnam("nogroup");
> +			if (!gr)
> +				syslog(LOG_DEBUG, "SID %s to gid pw error: %d",
> +						keyend, rc);
> +			else {
> +				gid = gr->gr_gid;
> +				rc = 0;
> +			}
> +		}
> +		if (!rc) { /* SID has been mapped to a gid */
> +			rc = keyctl_instantiate(key, &gid, sizeof(gid_t), 0);
> +			if (rc)
> +				syslog(LOG_ERR, "%s: key inst: %s",
> +						__func__, strerror(errno));
> +		}
> +	} else
> +		syslog(LOG_DEBUG, "Invalid SID: %s", keyend);
> +
> +	return rc;
> +}
> +#endif /* HAVE_LIBWBCLIENT */
> +
> +int main(const int argc, char *const argv[])
> +{
> +	int c;
> +	long rc = 1;
> +	key_serial_t key = 0;
> +	char *buf;
> +
> +	openlog(prog, 0, LOG_DAEMON);
> +
> +	while ((c = getopt_long(argc, argv, "v", NULL, NULL)) != -1) {
> +		switch (c) {
> +		case 'v':
> +			printf("version: %s\n", VERSION);
> +			goto out;
> +		default:
> +			syslog(LOG_ERR, "unknown option: %c", c);
> +			goto out;
> +		}
> +	}
> +
> +	/* is there a key? */
> +	if (argc <= optind) {
> +		usage();
> +		goto out;
> +	}
> +
> +	/* get key and keyring values */
> +	errno = 0;
> +	key = strtol(argv[optind], NULL, 10);
> +	if (errno != 0) {
> +		key = 0;
> +		syslog(LOG_ERR, "Invalid key format: %s", strerror(errno));
> +		goto out;
> +	}
> +
> +	rc = keyctl_describe_alloc(key, &buf);
> +	if (rc == -1) {
> +		syslog(LOG_ERR, "keyctl_describe_alloc failed: %s",
> +		       strerror(errno));
> +		rc = 1;
> +		goto out;
> +	}
> +
> +	syslog(LOG_DEBUG, "key description: %s", buf);
> +
> +#ifdef HAVE_LIBWBCLIENT
> +	if ((strncmp(buf, "cifs.idmap", sizeof("cifs.idmap") - 1) == 0))
> +		rc = cifs_idmap(key, buf);
> +#endif /* HAVE_LIBWBCLIENT */
> +

Doesn't this program require libwbclient? If so, then why the #ifdef's?

> +out:
> +	/*
> +	 * on error, negatively instantiate the key ourselves so that we can
> +	 * make sure the kernel doesn't hang it off of a searchable keyring
> +	 * and interfere with the next attempt to instantiate the key.
> +	 */
> +	if (rc != 0 && key == 0)
> +		keyctl_negate(key, 1, KEY_REQKEY_DEFL_DEFAULT);

				^^^^^^^
Is a 1s timeout appropriate here?

> +	return rc;
> +}
> diff --git a/configure.ac b/configure.ac
> index e0e2a60..d9eaead 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -22,13 +22,19 @@ AC_ARG_ENABLE(cifscreds,
>  	enable_cifscreds=$enableval,
>  	enable_cifscreds="no")
>  
> +AC_ARG_ENABLE(cifsidmap,
> +	[AC_HELP_STRING([--enable-cifsidmap],
> +			[Create cifs.idmap binary @<:@default=yes@:>@])],
> +	enable_cifsidmap=$enableval,
> +	enable_cifsidmap="maybe")
> +
>  # Checks for programs.
>  AC_PROG_CC
>  AC_PROG_SED
>  AC_GNU_SOURCE
>  
>  # Checks for header files.
> -AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdlib.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
> +AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
>  
>  if test $enable_cifsupcall != "no"; then
>  	AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
> @@ -89,6 +95,55 @@ if test $enable_cifsupcall != "no"; then
>  	AC_SUBST(KRB5_LDADD)
>  fi
>  
> +if test $enable_cifsidmap != "no"; then
> +	AC_CHECK_HEADERS([keyutils.h], , [
> +				if test "$enable_cifsidmap" = "yes"; then
> +					AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])
> +				else
> +					AC_MSG_WARN([keyutils.h not found, consider installing keyutils-libs-devel. Disabling cifs.idmap.])
> +					enable_cifsidmap="no"
> +				fi
> +			])
> +fi
> +

We're already doing a AC_CHECK_HEADERS for keyutils.h -- I don't think
we want to do it again. Just use the same check for both cifs.upcall
and cifs.idmap.

> +if test $enable_cifsidmap != "no"; then
> +	AC_CHECK_HEADERS([wbclient.h], , [
> +				if test "$enable_cifsidmap" = "yes"; then
> +					AC_MSG_ERROR([wbclient.h not found, consider installing libwbclient-devel..])
> +				else
> +					AC_MSG_WARN([keyutils.h not found, consider installing libwbclient-devel. Disabling cifs.idmap.])
> +					enable_cifsidmap="no"
> +				fi
> +			],
> +[#ifdef HAVE_STDINT_H
> +#include <stdint.h>
> +#endif
> +]
> +[#ifdef HAVE_STDBOOL_H
> +#include <stdbool.h>
> +#endif
> +]
> +[#ifdef HAVE_STDIO_H
> +#include <stdio.h>
> +#endif
> +]
> +[#ifdef HAVE_STDLIB_H
> +#include <stdlib.h>
> +#endif
> +]
> +[#ifdef HAVE_ERRNO_H
> +#include <errno.h>
> +#endif
> +]
> +)
> +fi
> +
> +if test $enable_cifsidmap != "no"; then
> +	AC_CHECK_LIB([wbclient], [wbcStringToSid],
> +		[ WINB_LDADD='-lwbclient' ] [ AC_DEFINE(HAVE_LIBWBCLIENT, 1, ["define var have_libwbclient"]) ], [AC_MSG_ERROR([no functioning wbclient library found!])])
> +	AC_SUBST(WINB_LDADD)
> +fi
> +


Bleh, that's pretty messy. Maybe this should go into a separate
file/function in aclocal/ ?


>  if test $enable_cifscreds = "yes"; then
>  	AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])])
>  fi
> @@ -140,6 +195,7 @@ LIBS=$cu_saved_libs
>  
>  AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
>  AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" = "yes"])
> +AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
>  
>  LIBCAP_NG_PATH
>  


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
