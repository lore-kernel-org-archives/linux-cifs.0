From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: infrastructure for stashing passwords in
 keyring
Date: Thu, 19 Aug 2010 17:04:51 -0400
Message-ID: <20100819170451.02c964c2@tlielax.poochiereds.net>
References: <1282249574-27724-1-git-send-email-jaxbrigs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282249574-27724-1-git-send-email-jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Aug 2010 00:26:14 +0400
Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> It is a userspace part of a new infrastructure for stashing passwords
> in kernel keyring per user basis. The patch adds the "cifscreds"
> utility for management keys with credentials. The resolve_host
> routine from mount.cifs is carried out in separate file and
> appropriate corrections are made. Assembling of the utility from
> the distribution is possible with --enable-cifscreds=yes option of
> configure script.
> 
> Signed-off-by: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Makefile.am    |    7 +-
>  cifscreds.c    |  582 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  configure.ac   |   15 ++-
>  mount.cifs.c   |  105 ++---------
>  resolve_host.c |  106 ++++++++++
>  resolve_host.h |   34 ++++
>  6 files changed, 754 insertions(+), 95 deletions(-)
>  create mode 100644 cifscreds.c
>  create mode 100644 resolve_host.c
>  create mode 100644 resolve_host.h
> 
> diff --git a/Makefile.am b/Makefile.am
> index c53c9ec..38a16fe 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -3,7 +3,7 @@ ACLOCAL_AMFLAGS = -I aclocal
>  
>  root_sbindir = "/sbin"
>  root_sbin_PROGRAMS = mount.cifs
> -mount_cifs_SOURCES = mount.cifs.c mtab.c util.c
> +mount_cifs_SOURCES = mount.cifs.c mtab.c resolve_host.c util.c
>  mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD)
>  
>  man_MANS = mount.cifs.8
> @@ -15,3 +15,8 @@ cifs_upcall_LDADD = -ltalloc -lkeyutils $(KRB5_LDADD)
>  man_MANS += cifs.upcall.8
>  endif
>  
> +if CONFIG_CIFSCREDS
> +bin_PROGRAMS = cifscreds
> +cifscreds_SOURCES = cifscreds.c resolve_host.c util.c
> +cifscreds_LDADD = -lkeyutils
> +endif
> diff --git a/cifscreds.c b/cifscreds.c
> new file mode 100644
> index 0000000..f21a47f
> --- /dev/null
> +++ b/cifscreds.c
> @@ -0,0 +1,582 @@
> +/*
> + * Credentials stashing utility for Linux CIFS VFS (virtual filesystem) client
> + * Copyright (C) 2010 Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
> + * Copyright (C) 2010 Igor Druzhinin (jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 3 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifdef HAVE_CONFIG_H
> +#include "config.h"
> +#endif /* HAVE_CONFIG_H */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <ctype.h>
> +#include <keyutils.h>
> +#include "mount.h"
> +#include "resolve_host.h"
> +
> +#define THIS_PROGRAM_NAME "cifscreds"
> +
> +/* max length of appropriate command */
> +#define MAX_COMMAND_SIZE 32
> +
> +/* max length of username, password and domain name */
> +#define MAX_USERNAME_SIZE 32
> +#define MOUNT_PASSWD_SIZE 128
> +#define MAX_DOMAIN_SIZE 64
> +
> +/* allowed and disallowed characters for user and domain name */
> +#define USER_DISALLOWED_CHARS "\\/\"[]:|<>+=;,?*@"
> +#define DOMAIN_ALLOWED_CHARS "abcdefghijklmnopqrstuvwxyz" \
> +			     "ABCDEFGHIJKLMNOPQRSTUVWXYZ-."
> +
> +/* destination keyring */
> +#define DEST_KEYRING KEY_SPEC_USER_KEYRING
> +
> +struct command {
> +	int (*action)(int argc, char *argv[]);
> +	const char	name[MAX_COMMAND_SIZE];
> +	const char	*format;
> +};
> +
> +static int cifscreds_add(int argc, char *argv[]);
> +static int cifscreds_clear(int argc, char *argv[]);
> +static int cifscreds_clearall(int argc, char *argv[]);
> +static int cifscreds_update(int argc, char *argv[]);
> +
> +const char *thisprogram;
> +
> +struct command commands[] = {
> +	{ cifscreds_add,	"add",		"<host> <user> [domain]" },
> +	{ cifscreds_clear,	"clear",	"<host> <user> [domain]" },
> +	{ cifscreds_clearall,	"clearall",	"" },
> +	{ cifscreds_update,	"update",	"<host> <user> [domain]" },
> +	{ NULL, "", NULL }
> +};
> +
> +/* display usage information */
> +static void usage(void)
> +{
> +	struct command *cmd;
> +
> +	fprintf(stderr, "Usage:\n");
> +	for (cmd = commands; cmd->action; cmd++)
> +		fprintf(stderr, "\t%s %s %s\n", thisprogram,
> +			cmd->name, cmd->format);
> +	fprintf(stderr, "\n");
> +
> +	exit(EXIT_FAILURE);
> +}
> +
> +/* create key's description string from given credentials */
> +static char *
> +create_description(const char *addr, const char *user,
> +		   const char *domain, char *desc)
> +{
> +	char *str_end;
> +	int str_len;
> +
> +	sprintf(desc, "%s:%s:%s:", THIS_PROGRAM_NAME, addr, user);
> +
> +	if (domain != NULL) {
> +		str_end = desc + strnlen(desc, INET6_ADDRSTRLEN + \
> +					+ MAX_USERNAME_SIZE + \
> +					+ sizeof(THIS_PROGRAM_NAME) + 3);
> +		str_len = strnlen(domain, MAX_DOMAIN_SIZE);
> +		while (str_len--) {
> +			*str_end = tolower(*domain++);
> +			str_end++;
> +		}
> +		*str_end = '\0';
> +	}
> +
> +	return desc;
> +}
> +
> +/* search a specific key in keyring */
> +static key_serial_t
> +key_search(const char *addr, const char *user, const char *domain)
> +{
> +	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + MAX_DOMAIN_SIZE + \
> +		+ sizeof(THIS_PROGRAM_NAME) + 3];
> +	key_serial_t key, *pk;
> +	void *keylist;
> +	char *buffer;
> +	int count, dpos, n, ret;
> +
> +	create_description(addr, user, domain, desc);
> +
> +	/* read the key payload data */
> +	count = keyctl_read_alloc(DEST_KEYRING, &keylist);
> +	if (count < 0)
> +		return 0;
> +
> +	count /= sizeof(key_serial_t);
> +
> +	if (count == 0) {
> +		ret = 0;
> +		goto key_search_out;
> +	}
> +
> +	/* list the keys in the keyring */
> +	pk = keylist;
> +	do {
> +		key = *pk++;
> +
> +		ret = keyctl_describe_alloc(key, &buffer);
> +		if (ret < 0)
> +			continue;
> +
> +		n = sscanf(buffer, "%*[^;];%*d;%*d;%*x;%n", &dpos);
> +		if (n) {
> +			free(buffer);
> +			continue;
> +		}
> +
> +		if (!strcmp(buffer + dpos, desc)) {
> +			ret = key;
> +			free(buffer);
> +			goto key_search_out;
> +		}
> +		free(buffer);
> +
> +	} while (--count);
> +
> +	ret = 0;
> +
> +key_search_out:
> +	free(keylist);
> +	return ret;
> +}
> +
> +/* search all program's keys in keyring */
> +static key_serial_t key_search_all(void)
> +{
> +	key_serial_t key, *pk;
> +	void *keylist;
> +	char *buffer;
> +	int count, dpos, n, ret;
> +
> +	/* read the key payload data */
> +	count = keyctl_read_alloc(DEST_KEYRING, &keylist);
> +	if (count < 0)
> +		return 0;
> +
> +	count /= sizeof(key_serial_t);
> +
> +	if (count == 0) {
> +		ret = 0;
> +		goto key_search_all_out;
> +	}
> +
> +	/* list the keys in the keyring */
> +	pk = keylist;
> +	do {
> +		key = *pk++;
> +
> +		ret = keyctl_describe_alloc(key, &buffer);
> +		if (ret < 0)
> +			continue;
> +
> +		n = sscanf(buffer, "%*[^;];%*d;%*d;%*x;%n", &dpos);
> +		if (n) {
> +			free(buffer);
> +			continue;
> +		}
> +
> +		if (strstr(buffer + dpos, THIS_PROGRAM_NAME ":") ==
> +			buffer + dpos
> +		) {
> +			ret = key;
> +			free(buffer);
> +			goto key_search_all_out;
> +		}
> +		free(buffer);
> +
> +	} while (--count);
> +
> +	ret = 0;
> +
> +key_search_all_out:
> +	free(keylist);
> +	return ret;
> +}
> +
> +/* add or update a specific key to keyring */
> +static key_serial_t
> +key_add(const char *addr, const char *user,
> +	const char *domain, const char *pass)
> +{
> +	char desc[INET6_ADDRSTRLEN + MAX_USERNAME_SIZE + MAX_DOMAIN_SIZE + \
> +		+ sizeof(THIS_PROGRAM_NAME) + 3];
> +
> +	create_description(addr, user, domain, desc);
> +
> +	return add_key("user", desc, pass, strnlen(pass, MOUNT_PASSWD_SIZE) + 1,
> +		DEST_KEYRING);
> +}
> +
> +/* add command handler */
> +static int cifscreds_add(int argc, char *argv[])
> +{
> +	char addrstr[MAX_ADDR_LIST_LEN];
> +	char *currentaddress, *nextaddress;
> +	char *pass;
> +	int ret;
> +
> +	if (argc != 4 && argc != 5)
> +		usage();
> +
> +	ret = resolve_host(argv[2], addrstr);
> +	switch (ret) {
> +	case EX_USAGE:
> +		fprintf(stderr, "error: Could not resolve address "
> +			"for %s\n", argv[2]);
> +		return EXIT_FAILURE;
> +
> +	case EX_SYSERR:
> +		fprintf(stderr, "error: Problem parsing address list\n");
> +		return EXIT_FAILURE;
> +	}
> +
> +	if (strpbrk(argv[3], USER_DISALLOWED_CHARS)) {
> +		fprintf(stderr, "error: Incorrect username\n");
> +		return EXIT_FAILURE;
> +	}
> +
> +	if (argc == 5) {
> +		if (strspn(argv[4], DOMAIN_ALLOWED_CHARS) !=
> +			strnlen(argv[4], MAX_DOMAIN_SIZE)
> +		) {
> +			fprintf(stderr, "error: Incorrect domain name\n");
> +			return EXIT_FAILURE;
> +		}
> +	}
> +
> +	/* search for same credentials stashed for current host */
> +	currentaddress = addrstr;
> +	nextaddress = strchr(currentaddress, ',');
> +	if (nextaddress)
> +		*nextaddress++ = '\0';
> +
> +	while (currentaddress) {
> +		if (key_search(currentaddress, argv[3],
> +			argc == 5 ? argv[4] : NULL) > 0
> +		) {
> +			printf("You already have stashed credentials "
> +				"for %s (%s)\n", currentaddress, argv[2]);
> +			printf("If you want to update them use:\n");
> +			printf("\t%s update\n", thisprogram);
> +
> +			return EXIT_FAILURE;
> +		}
> +
> +		currentaddress = nextaddress;
> +		if (currentaddress) {
> +			*(currentaddress - 1) = ',';
> +			nextaddress = strchr(currentaddress, ',');
> +			if (nextaddress)
> +				*nextaddress++ = '\0';
> +		}
> +	}
> +
> +	/*
> +	 * if there isn't same credentials stashed add them to keyring
> +	 * and set permisson mask
> +	 */
> +	pass = getpass("Password: ");
> +
> +	currentaddress = addrstr;
> +	nextaddress = strchr(currentaddress, ',');
> +	if (nextaddress)
> +		*nextaddress++ = '\0';
> +
> +	while (currentaddress) {
> +		key_serial_t key = key_add(currentaddress, argv[3],
> +					   argc == 5 ? argv[4] : NULL, pass);
> +		if (key <= 0) {
> +			fprintf(stderr, "error: Add credential key for %s\n",
> +				currentaddress);
> +		} else {
> +			if (keyctl(KEYCTL_SETPERM, key, KEY_POS_VIEW | \
> +				KEY_POS_WRITE | KEY_USR_VIEW | \
> +				KEY_USR_WRITE) < 0
> +			) {
> +				fprintf(stderr, "error: Setting permissons "
> +					"on key, attempt to delete...\n");
> +
> +				if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
> +					fprintf(stderr, "error: Deleting key from "
> +						"keyring for %s (%s)\n",
> +						currentaddress, argv[2]);
> +				}
> +			}
> +		}
> +
> +		currentaddress = nextaddress;
> +		if (currentaddress) {
> +			nextaddress = strchr(currentaddress, ',');
> +			if (nextaddress)
> +				*nextaddress++ = '\0';
> +		}
> +	}
> +
> +	return EXIT_SUCCESS;
> +}
> +
> +/* clear command handler */
> +static int cifscreds_clear(int argc, char *argv[])
> +{
> +	char addrstr[MAX_ADDR_LIST_LEN];
> +	char *currentaddress, *nextaddress;
> +	int ret, count = 0, errors = 0;
> +
> +	if (argc != 4 && argc != 5)
> +		usage();
> +
> +	ret = resolve_host(argv[2], addrstr);
> +	switch (ret) {
> +	case EX_USAGE:
> +		fprintf(stderr, "error: Could not resolve address "
> +			"for %s\n", argv[2]);
> +		return EXIT_FAILURE;
> +
> +	case EX_SYSERR:
> +		fprintf(stderr, "error: Problem parsing address list\n");
> +		return EXIT_FAILURE;
> +	}
> +
> +	if (strpbrk(argv[3], USER_DISALLOWED_CHARS)) {
> +		fprintf(stderr, "error: Incorrect username\n");
> +		return EXIT_FAILURE;
> +	}
> +
> +	if (argc == 5) {
> +		if (strspn(argv[4], DOMAIN_ALLOWED_CHARS) !=
> +			strnlen(argv[4], MAX_DOMAIN_SIZE)
> +		) {
> +			fprintf(stderr, "error: Incorrect domain name\n");
> +			return EXIT_FAILURE;
> +		}
> +	}
> +
> +	/*
> +	 * search for same credentials stashed for current host
> +	 * and unlink them from session keyring
> +	 */
> +	currentaddress = addrstr;
> +	nextaddress = strchr(currentaddress, ',');
> +	if (nextaddress)
> +		*nextaddress++ = '\0';
> +
> +	while (currentaddress) {
> +		key_serial_t key = key_search(currentaddress, argv[3],
> +						argc == 5 ? argv[4] : NULL);
> +		if (key > 0) {
> +			if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
> +				fprintf(stderr, "error: Removing key from "
> +					"keyring for %s (%s)\n",
> +					currentaddress, argv[2]);
> +				errors++;
> +			} else {
> +				count++;
> +			}
> +		}
> +
> +		currentaddress = nextaddress;
> +		if (currentaddress) {
> +			nextaddress = strchr(currentaddress, ',');
> +			if (nextaddress)
> +				*nextaddress++ = '\0';
> +		}
> +	}
> +
> +	if (!count && !errors) {
> +		printf("You have no same stashed credentials "
> +			" for %s\n", argv[2]);
> +		printf("If you want to add them use:\n");
> +		printf("\t%s add\n", thisprogram);
> +
> +		return EXIT_FAILURE;
> +	}
> +
> +	return EXIT_SUCCESS;
> +}
> +
> +/* clearall command handler */
> +static int cifscreds_clearall(int argc, char *argv[])
> +{
> +	key_serial_t key;
> +	int count = 0, errors = 0;
> +
> +	if (argc != 2)
> +		usage();
> +
> +	/*
> +	 * search for all program's credentials stashed in session keyring
> +	 * and then unlink them
> +	 */
> +	do {
> +		key = key_search_all();
> +		if (key > 0) {
> +			if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
> +				fprintf(stderr, "error: Deleting key "
> +					"from keyring");
> +				errors++;
> +			} else {
> +				count++;
> +			}
> +		}
> +	} while (key > 0);
> +
> +	if (!count && !errors) {
> +		printf("You have no stashed " THIS_PROGRAM_NAME
> +			" credentials\n");
> +		printf("If you want to add them use:\n");
> +		printf("\t%s add\n", thisprogram);
> +
> +		return EXIT_FAILURE;
> +	}
> +
> +	return EXIT_SUCCESS;
> +}
> +
> +/* update command handler */
> +static int cifscreds_update(int argc, char *argv[])
> +{
> +	char addrstr[MAX_ADDR_LIST_LEN];
> +	char *currentaddress, *nextaddress, *pass;
> +	char *addrs[16];
> +	int ret, id, count = 0;
> +
> +	if (argc != 4 && argc != 5)
> +		usage();
> +
> +	ret = resolve_host(argv[2], addrstr);
> +	switch (ret) {
> +	case EX_USAGE:
> +		fprintf(stderr, "error: Could not resolve address "
> +			"for %s\n", argv[2]);
> +		return EXIT_FAILURE;
> +
> +	case EX_SYSERR:
> +		fprintf(stderr, "error: Problem parsing address list\n");
> +		return EXIT_FAILURE;
> +	}
> +
> +	if (strpbrk(argv[3], USER_DISALLOWED_CHARS)) {
> +		fprintf(stderr, "error: Incorrect username\n");
> +		return EXIT_FAILURE;
> +	}
> +
> +	if (argc == 5) {
> +		if (strspn(argv[4], DOMAIN_ALLOWED_CHARS) !=
> +			strnlen(argv[4], MAX_DOMAIN_SIZE)
> +		) {
> +			fprintf(stderr, "error: Incorrect domain name\n");
> +			return EXIT_FAILURE;
> +		}
> +	}
> +
> +	/* search for necessary credentials stashed in session keyring */
> +	currentaddress = addrstr;
> +	nextaddress = strchr(currentaddress, ',');
> +	if (nextaddress)
> +		*nextaddress++ = '\0';
> +
> +	while (currentaddress) {
> +		if (key_search(currentaddress, argv[3],
> +			argc == 5 ? argv[4] : NULL) > 0
> +		) {
> +			addrs[count] = currentaddress;
> +			count++;
> +		}
> +
> +		currentaddress = nextaddress;
> +		if (currentaddress) {
> +			nextaddress = strchr(currentaddress, ',');
> +			if (nextaddress)
> +				*nextaddress++ = '\0';
> +		}
> +	}
> +
> +	if (!count) {
> +		printf("You have no same stashed credentials "
> +			"for %s\n", argv[2]);
> +		printf("If you want to add them use:\n");
> +		printf("\t%s add\n", thisprogram);
> +
> +		return EXIT_FAILURE;
> +	}
> +
> +	/* update payload of found keys */
> +	pass = getpass("Password: ");
> +
> +	for (id = 0; id < count; id++) {
> +		key_serial_t key = key_add(addrs[id], argv[3],
> +					argc == 5 ? argv[4] : NULL, pass);
> +		if (key <= 0)
> +			fprintf(stderr, "error: Update credential key "
> +				"for %s\n", addrs[id]);
> +	}
> +
> +	return EXIT_SUCCESS;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct command *cmd, *best;
> +	int n;
> +
> +	thisprogram = (char *)basename(argv[0]);
> +	if (thisprogram == NULL)
> +		thisprogram = THIS_PROGRAM_NAME;
> +
> +	if (argc == 1)
> +		usage();
> +
> +	/* find the best fit command */
> +	best = NULL;
> +	n = strnlen(argv[1], MAX_COMMAND_SIZE);
> +
> +	for (cmd = commands; cmd->action; cmd++) {
> +		if (memcmp(cmd->name, argv[1], n) != 0)
> +			continue;
> +
> +		if (cmd->name[n] == 0) {
> +			/* exact match */
> +			best = cmd;
> +			break;
> +		}
> +
> +		/* partial match */
> +		if (best) {
> +			fprintf(stderr, "Ambiguous command\n");
> +			exit(EXIT_FAILURE);
> +		}
> +
> +		best = cmd;
> +	}
> +
> +	if (!best) {
> +		fprintf(stderr, "Unknown command\n");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	exit(best->action(argc, argv));
> +}
> diff --git a/configure.ac b/configure.ac
> index 266380a..c7d420d 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -16,12 +16,18 @@ AC_ARG_ENABLE(cifsupcall,
>  	enable_cifsupcall=$enableval,
>  	enable_cifsupcall="maybe")
>  
> +AC_ARG_ENABLE(cifscreds,
> +	[AC_HELP_STRING([--enable-cifscreds],
> +			[Create cifscreds utility @<:@default=no@:>@])],
> +	enable_cifscreds=$enableval,
> +	enable_cifscreds="no")
> +
>  # Checks for programs.
>  AC_PROG_CC
>  AC_GNU_SOURCE
>  
>  # Checks for header files.
> -AC_CHECK_HEADERS([arpa/inet.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdlib.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
> +AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdlib.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
>  
>  if test $enable_cifsupcall != "no"; then
>  	AC_CHECK_HEADERS([krb5.h krb5/krb5.h])
> @@ -82,6 +88,10 @@ if test $enable_cifsupcall != "no"; then
>  	AC_SUBST(KRB5_LDADD)
>  fi
>  
> +if test $enable_cifscreds = "yes"; then
> +	AC_CHECK_HEADERS([keyutils.h], , [AC_MSG_ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])])
> +fi
> +
>  # Checks for typedefs, structures, and compiler characteristics.
>  AC_HEADER_STDBOOL
>  AC_TYPE_UID_T
> @@ -98,7 +108,7 @@ AC_FUNC_REALLOC
>  AC_FUNC_STRNLEN
>  
>  # check for required functions
> -AC_CHECK_FUNCS([alarm atexit endpwent getmntent getpass gettimeofday inet_ntop memset realpath setenv strchr strdup strerror strncasecmp strndup strpbrk strrchr strstr strtol strtoul uname], , [AC_MSG_ERROR([necessary functions(s) not found])])
> +AC_CHECK_FUNCS([alarm atexit endpwent getmntent getpass gettimeofday inet_ntop memset realpath setenv strchr strcmp strdup strerror strncasecmp strndup strpbrk strrchr strstr strtol strtoul tolower uname], , [AC_MSG_ERROR([necessary functions(s) not found])])
>  
>  # ugly, but I'm not sure how to check for functions in a library that's not in $LIBS
>  cu_saved_libs=$LIBS
> @@ -117,6 +127,7 @@ fi
>  LIBS=$cu_saved_libs
>  
>  AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
> +AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" = "yes"])
>  
>  LIBCAP_NG_PATH
>  
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 3623e76..ed27bba 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -56,6 +56,7 @@
>  #endif /* HAVE_LIBCAP_NG */
>  #include "mount.h"
>  #include "util.h"
> +#include "resolve_host.h"
>  
>  #ifndef MS_MOVE 
>  #define MS_MOVE 8192 
> @@ -87,12 +88,6 @@
>  /* max length of username (somewhat made up here) */
>  #define MAX_USERNAME_SIZE 32
>  
> -/* currently maximum length of IPv6 address string */
> -#define MAX_ADDRESS_LEN INET6_ADDRSTRLEN
> -
> -/* limit list of addresses to 16 max-size addrs */
> -#define MAX_ADDR_LIST_LEN ((MAX_ADDRESS_LEN + 1) * 16)
> -
>  #ifndef SAFE_FREE
>  #define SAFE_FREE(x) do { if ((x) != NULL) {free(x); x = NULL; } } while (0)
>  #endif
> @@ -1207,90 +1202,6 @@ nocopy:
>  	return 0;
>  }
>  
> -/*
> - * resolve "host" portion of parsed info to comma-separated list of
> - * address(es)
> - */
> -static int resolve_host(struct parsed_mount_info *parsed_info)
> -{
> -	int rc;
> -	/* 10 for max width of decimal scopeid */
> -	char tmpbuf[NI_MAXHOST + 1 + 10 + 1];
> -	const char *ipaddr;
> -	size_t len;
> -	struct addrinfo *addrlist, *addr;
> -	struct sockaddr_in *sin;
> -	struct sockaddr_in6 *sin6;
> -
> -	rc = getaddrinfo(parsed_info->host, NULL, NULL, &addrlist);
> -	if (rc != 0) {
> -		fprintf(stderr, "mount error: could not resolve address for "
> -			"%s: %s\n", parsed_info->host,
> -			rc == EAI_SYSTEM ? strerror(errno) : gai_strerror(rc));
> -		/* FIXME: return better error based on rc? */
> -		return EX_USAGE;
> -	}
> -
> -	addr = addrlist;
> -	while (addr) {
> -		/* skip non-TCP entries */
> -		if (addr->ai_socktype != SOCK_STREAM ||
> -		    addr->ai_protocol != IPPROTO_TCP) {
> -			addr = addr->ai_next;
> -			continue;
> -		}
> -
> -		switch (addr->ai_addr->sa_family) {
> -		case AF_INET6:
> -			sin6 = (struct sockaddr_in6 *)addr->ai_addr;
> -			ipaddr = inet_ntop(AF_INET6, &sin6->sin6_addr, tmpbuf,
> -					   sizeof(tmpbuf));
> -			if (!ipaddr) {
> -				rc = EX_SYSERR;
> -				fprintf(stderr,
> -					"mount error: problem parsing address "
> -					"list: %s\n", strerror(errno));
> -				goto resolve_host_out;
> -			}
> -
> -			if (sin6->sin6_scope_id) {
> -				len = strnlen(tmpbuf, sizeof(tmpbuf));
> -				ipaddr = tmpbuf + len;
> -				snprintf(tmpbuf, sizeof(tmpbuf) - len, "%%%u",
> -					 sin6->sin6_scope_id);
> -			}
> -			break;
> -		case AF_INET:
> -			sin = (struct sockaddr_in *)addr->ai_addr;
> -			ipaddr = inet_ntop(AF_INET, &sin->sin_addr, tmpbuf,
> -					   sizeof(tmpbuf));
> -			if (!ipaddr) {
> -				rc = EX_SYSERR;
> -				fprintf(stderr,
> -					"mount error: problem parsing address "
> -					"list: %s\n", strerror(errno));
> -				goto resolve_host_out;
> -			}
> -
> -			break;
> -		default:
> -			addr = addr->ai_next;
> -			continue;
> -		}
> -
> -		if (parsed_info->addrlist[0] != '\0')
> -			strlcat(parsed_info->addrlist, ",",
> -				sizeof(parsed_info->addrlist));
> -		strlcat(parsed_info->addrlist, tmpbuf,
> -			sizeof(parsed_info->addrlist));
> -		addr = addr->ai_next;
> -	}
> -
> -resolve_host_out:
> -	freeaddrinfo(addrlist);
> -	return rc;
> -}
> -
>  static int parse_unc(const char *unc_name, struct parsed_mount_info *parsed_info)
>  {
>  	int length = strnlen(unc_name, MAX_UNC_LEN);
> @@ -1645,10 +1556,20 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
>  	if (rc)
>  		goto assemble_exit;
>  
> -	rc = resolve_host(parsed_info);
> -	if (rc)
> +	rc = resolve_host(parsed_info->host, parsed_info->addrlist);
> +	switch (rc) {
> +	case EX_USAGE:
> +		fprintf(stderr, "mount error: could not resolve address for "
> +			"%s: %s\n", parsed_info->host,
> +			rc == EAI_SYSTEM ? strerror(errno) : gai_strerror(rc));
>  		goto assemble_exit;
>  
> +	case EX_SYSERR:
> +		fprintf(stderr, "mount error: problem parsing address "
> +			"list: %s\n", strerror(errno));
> +		goto assemble_exit;
> +	}
> +
>  	if (!parsed_info->got_user) {
>  		/*
>  		 * Note that the password will not be retrieved from the
> diff --git a/resolve_host.c b/resolve_host.c
> new file mode 100644
> index 0000000..02b8096
> --- /dev/null
> +++ b/resolve_host.c
> @@ -0,0 +1,106 @@
> +/*
> + * resolving DNS hostname routine
> + *
> + * Copyright (C) 2010 Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
> + * Copyright (C) 2010 Igor Druzhinin (jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 3 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifdef HAVE_CONFIG_H
> +#include "config.h"
> +#endif /* HAVE_CONFIG_H */
> +
> +#include <stdio.h>
> +#include <string.h>
> +#include <sys/socket.h>
> +#include <arpa/inet.h>
> +#include <netdb.h>
> +
> +#include "mount.h"
> +#include "util.h"
> +#include "resolve_host.h"
> +
> +/*
> + * resolve hostname to comma-separated list of address(es)
> + */
> +int resolve_host(const char *host, char *addrstr)
> +{
> +	int rc;
> +	/* 10 for max width of decimal scopeid */
> +	char tmpbuf[NI_MAXHOST + 1 + 10 + 1];
> +	const char *ipaddr;
> +	size_t len;
> +	struct addrinfo *addrlist, *addr;
> +	struct sockaddr_in *sin;
> +	struct sockaddr_in6 *sin6;
> +
> +	rc = getaddrinfo(host, NULL, NULL, &addrlist);
> +	if (rc != 0)
> +		return EX_USAGE;
> +
> +	addr = addrlist;
> +	while (addr) {
> +		/* skip non-TCP entries */
> +		if (addr->ai_socktype != SOCK_STREAM ||
> +		    addr->ai_protocol != IPPROTO_TCP) {
> +			addr = addr->ai_next;
> +			continue;
> +		}
> +
> +		switch (addr->ai_addr->sa_family) {
> +		case AF_INET6:
> +			sin6 = (struct sockaddr_in6 *)addr->ai_addr;
> +			ipaddr = inet_ntop(AF_INET6, &sin6->sin6_addr, tmpbuf,
> +					   sizeof(tmpbuf));
> +			if (!ipaddr) {
> +				rc = EX_SYSERR;
> +				goto resolve_host_out;
> +			}
> +
> +			if (sin6->sin6_scope_id) {
> +				len = strnlen(tmpbuf, sizeof(tmpbuf));
> +				ipaddr = tmpbuf + len;
> +				snprintf(tmpbuf, sizeof(tmpbuf) - len, "%%%u",
> +					 sin6->sin6_scope_id);
> +			}
> +			break;
> +		case AF_INET:
> +			sin = (struct sockaddr_in *)addr->ai_addr;
> +			ipaddr = inet_ntop(AF_INET, &sin->sin_addr, tmpbuf,
> +					   sizeof(tmpbuf));
> +			if (!ipaddr) {
> +				rc = EX_SYSERR;
> +				goto resolve_host_out;
> +			}
> +
> +			break;
> +		default:
> +			addr = addr->ai_next;
> +			continue;
> +		}
> +
> +		if (addr == addrlist)
> +			*addrstr = '\0';
> +		else
> +			strlcat(addrstr, ",", MAX_ADDR_LIST_LEN);
> +
> +		strlcat(addrstr, tmpbuf, MAX_ADDR_LIST_LEN);
> +		addr = addr->ai_next;
> +	}
> +
> +resolve_host_out:
> +	freeaddrinfo(addrlist);
> +	return rc;
> +}
> diff --git a/resolve_host.h b/resolve_host.h
> new file mode 100644
> index 0000000..b949245
> --- /dev/null
> +++ b/resolve_host.h
> @@ -0,0 +1,34 @@
> +/*
> + * resolving DNS hostname routine
> + *
> + * Copyright (C) 2010 Jeff Layton (jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org)
> + * Copyright (C) 2010 Igor Druzhinin (jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 3 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _RESOLVE_HOST_H_
> +#define _RESOLVE_HOST_H_
> +
> +#include <arpa/inet.h>
> +
> +/* currently maximum length of IPv6 address string */
> +#define MAX_ADDRESS_LEN INET6_ADDRSTRLEN
> +
> +/* limit list of addresses to 16 max-size addrs */
> +#define MAX_ADDR_LIST_LEN ((MAX_ADDRESS_LEN + 1) * 16)
> +
> +extern int resolve_host(const char *host, char *addrstr);
> +
> +#endif /* _RESOLVE_HOST_H_ */

This looks like good work and I think it's getting close to merge
ready. Could you break this into more than one patch however? The move
of resolve_host into a separate file should be a separate patch from
the one that adds the new program.

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
