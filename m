From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-utils PATCH 2/3] cifs.upcall: use krb5 routines to get
 default ccname
Date: Fri, 14 Oct 2016 14:31:57 -0400
Message-ID: <1476469917.2727.3.camel@samba.org>
References: <1471868962-7312-1-git-send-email-jlayton@samba.org>
         <1471868962-7312-3-git-send-email-jlayton@samba.org>
         <039A665D-75B4-4008-85F9-6CAE8BFB2E15@fhcrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: "Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <039A665D-75B4-4008-85F9-6CAE8BFB2E15-q9hIisBwmLrYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If you mean the set that I proposed in late August, then yes...that
went into cifs-utils v6.6.

Thanks,
Jeff

On Fri, 2016-10-14 at 18:09 +0000, Dey, John F wrote:
> Are the default_ccache_name patches making it upstream? 
> 
> John Dey
> 
> 
> 
> 
> 
> 
> On 8/22/16, 5:29 AM, "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > 
> > Currently we end up groveling around in /tmp, trying to guess what the
> > credcache will be. Instead, just get the default ccname for the user,
> > and then see if it has a valid tgt. If it doesn't then we try to use
> > the keytab to init the credcache before proceeding.
> > 
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> > cifs.upcall.c | 148 +++++++++++-----------------------------------------------
> > 1 file changed, 27 insertions(+), 121 deletions(-)
> > 
> > diff --git a/cifs.upcall.c b/cifs.upcall.c
> > index e8544c2b68ad..d0f6d089d8e1 100644
> > --- a/cifs.upcall.c
> > +++ b/cifs.upcall.c
> > @@ -52,12 +52,6 @@
> > #include "spnego.h"
> > #include "cifs_spnego.h"
> > 
> > -#define	CIFS_DEFAULT_KRB5_DIR		"/tmp"
> > -#define	CIFS_DEFAULT_KRB5_USER_DIR	"/run/user/%U"
> > -#define	CIFS_DEFAULT_KRB5_PREFIX	"krb5cc"
> > -
> > -#define	MAX_CCNAME_LEN			PATH_MAX + 5
> > -
> > static const char *prog = "cifs.upcall";
> > typedef enum _sectype {
> > 	NONE = 0,
> > @@ -178,13 +172,34 @@ err_cache:
> > 	return credtime;
> > }
> > 
> > -static int krb5cc_filter(const struct dirent *dirent)
> > +static char *
> > +get_default_cc(void)
> > {
> > -	/* subtract 1 for the null terminator */
> > -	return !strncmp(dirent->d_name, CIFS_DEFAULT_KRB5_PREFIX,
> > -			sizeof(CIFS_DEFAULT_KRB5_PREFIX) - 1);
> > +	krb5_error_code ret;
> > +	const char *ccname;
> > +	char *rcc = NULL;
> > +	krb5_context context = NULL;
> > +
> > +	ret = krb5_init_context(&context);
> > +	if (ret) {
> > +		syslog(LOG_DEBUG, "krb5_init_context: %d", (int)ret);
> > +		return NULL;
> > +	}
> > +
> > +	ccname = krb5_cc_default_name(context);
> > +	if (!ccname) {
> > +		syslog(LOG_DEBUG, "krb5_cc_default returned NULL.");
> > +		goto out_free_context;
> > +	}
> > +
> > +	if (get_tgt_time(ccname))
> > +		rcc = strdup(ccname);
> > +out_free_context:
> > +	krb5_free_context(context);
> > +	return rcc;
> > }
> > 
> > +
> > static char *
> > init_cc_from_keytab(const char *keytab_name, const char *user)
> > {
> > @@ -263,109 +278,6 @@ icfk_cleanup:
> > 	return ccname;
> > }
> > 
> > -/* resolve a pattern to an actual directory path */
> > -static char *resolve_krb5_dir(const char *pattern, uid_t uid)
> > -{
> > -	char name[MAX_CCNAME_LEN];
> > -	int i;
> > -	size_t j;
> > -	for (i = 0, j = 0; (pattern[i] != '\0') && (j < sizeof(name)); i++) {
> > -		switch (pattern[i]) {
> > -		case '%':
> > -			switch (pattern[i + 1]) {
> > -			case '%':
> > -				name[j++] = pattern[i];
> > -				i++;
> > -				break;
> > -			case 'U':
> > -				j += snprintf(name + j, sizeof(name) - j,
> > -					      "%lu", (unsigned long) uid);
> > -				i++;
> > -				break;
> > -			}
> > -			break;
> > -		default:
> > -			name[j++] = pattern[i];
> > -			break;
> > -		}
> > -	}
> > -	if ((j > 0) && (j < sizeof(name)))
> > -		return strndup(name, MAX_CCNAME_LEN);
> > -	else
> > -		return NULL;
> > -}
> > -
> > -/* search for a credcache that looks like a likely candidate */
> > -static char *find_krb5_cc(const char *dirname, uid_t uid,
> > -			  char **best_cache, time_t *best_time)
> > -{
> > -	struct dirent **namelist;
> > -	struct stat sbuf;
> > -	char ccname[MAX_CCNAME_LEN], *credpath;
> > -	int i, n;
> > -	time_t cred_time;
> > -
> > -	n = scandir(dirname, &namelist, krb5cc_filter, NULL);
> > -	if (n < 0) {
> > -		syslog(LOG_DEBUG, "%s: scandir error on directory '%s': %s",
> > -		       __func__, dirname, strerror(errno));
> > -		return NULL;
> > -	}
> > -
> > -	for (i = 0; i < n; i++) {
> > -		snprintf(ccname, sizeof(ccname), "FILE:%s/%s", dirname,
> > -			 namelist[i]->d_name);
> > -		credpath = ccname + 5;
> > -		syslog(LOG_DEBUG, "%s: considering %s", __func__, credpath);
> > -
> > -		if (lstat(credpath, &sbuf)) {
> > -			syslog(LOG_DEBUG, "%s: stat error on '%s': %s",
> > -			       __func__, credpath, strerror(errno));
> > -			free(namelist[i]);
> > -			continue;
> > -		}
> > -		if (sbuf.st_uid != uid) {
> > -			syslog(LOG_DEBUG, "%s: %s is owned by %u, not %u",
> > -			       __func__, credpath, sbuf.st_uid, uid);
> > -			free(namelist[i]);
> > -			continue;
> > -		}
> > -		if (S_ISDIR(sbuf.st_mode)) {
> > -			snprintf(ccname, sizeof(ccname), "DIR:%s/%s", dirname,
> > -				 namelist[i]->d_name);
> > -			credpath = ccname + 4;
> > -		} else
> > -		if (!S_ISREG(sbuf.st_mode)) {
> > -			syslog(LOG_DEBUG, "%s: %s is not a regular file",
> > -			       __func__, credpath);
> > -			free(namelist[i]);
> > -			continue;
> > -		}
> > -		if (!(cred_time = get_tgt_time(ccname))) {
> > -			syslog(LOG_DEBUG, "%s: %s is not a valid credcache.",
> > -			       __func__, ccname);
> > -			free(namelist[i]);
> > -			continue;
> > -		}
> > -
> > -		if (cred_time <= *best_time) {
> > -			syslog(LOG_DEBUG, "%s: %s expires sooner than current "
> > -			       "best.", __func__, ccname);
> > -			free(namelist[i]);
> > -			continue;
> > -		}
> > -
> > -		syslog(LOG_DEBUG, "%s: %s is valid ccache", __func__, ccname);
> > -		free(*best_cache);
> > -		*best_cache = strndup(ccname, MAX_CCNAME_LEN);
> > -		*best_time = cred_time;
> > -		free(namelist[i]);
> > -	}
> > -	free(namelist);
> > -
> > -	return *best_cache;
> > -}
> > -
> > static int
> > cifs_krb5_get_req(const char *host, const char *ccname,
> > 		  DATA_BLOB * mechtoken, DATA_BLOB * sess_key)
> > @@ -841,13 +753,12 @@ int main(const int argc, char *const argv[])
> > 	unsigned int have;
> > 	long rc = 1;
> > 	int c, try_dns = 0, legacy_uid = 0;
> > -	char *buf, *ccdir = NULL, *ccname = NULL, *best_cache = NULL;
> > +	char *buf, *ccname = NULL;
> > 	char hostbuf[NI_MAXHOST], *host;
> > 	struct decoded_args arg;
> > 	const char *oid;
> > 	uid_t uid;
> > 	char *keytab_name = NULL;
> > -	time_t best_time = 0;
> > 
> > 	hostbuf[0] = '\0';
> > 	memset(&arg, 0, sizeof(arg));
> > @@ -954,13 +865,8 @@ int main(const int argc, char *const argv[])
> > 		syslog(LOG_ERR, "setuid: %s", strerror(errno));
> > 		goto out;
> > 	}
> > -	ccdir = resolve_krb5_dir(CIFS_DEFAULT_KRB5_USER_DIR, uid);
> > -	if (ccdir != NULL)
> > -		find_krb5_cc(ccdir, uid, &best_cache, &best_time);
> > -	ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid, &best_cache,
> > -			      &best_time);
> > -	SAFE_FREE(ccdir);
> > 
> > +	ccname = get_default_cc();
> > 	/* Couldn't find credcache? Try to use keytab */
> > 	if (ccname == NULL && arg.username != NULL)
> > 		ccname = init_cc_from_keytab(keytab_name, arg.username);
> > -- 
> > 2.7.4
> > 
