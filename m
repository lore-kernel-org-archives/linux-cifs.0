From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [Samba] cifs-utils: regression in (mulituser?) mounting 'CIFS
 VFS: Send error in SessSetup = -126'
Date: Fri, 10 Feb 2017 17:01:24 -0500
Message-ID: <1486764084.4233.27.camel@samba.org>
References: <a13d9992-6be8-6f16-f4cb-98e83d2e140b@physics.wisc.edu>
         <mpsd1erijy1.fsf@aaptelpc.suse.de>
         <60de4c72-5278-04b3-5298-658fd11ad978@physics.wisc.edu>
         <106aff65-99f7-ede5-bc08-160b579abb9f@physics.wisc.edu>
         <1486746542.4233.14.camel@samba.org>
         <284d47c4-a3c7-a2c9-d7d1-e5444308922c@physics.wisc.edu>
         <1486748379.4233.16.camel@samba.org> <1486751411.4233.21.camel@samba.org>
         <1486754095.31734.20.camel@redhat.com> <1486754996.4233.23.camel@samba.org>
         <1486757672.31734.25.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        Nalin Dahyabhai <nalin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Simo Sorce <ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Chad William Seys <cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org>,
        samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486757672.31734.25.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2017-02-10 at 15:14 -0500, Simo Sorce wrote:
> On Fri, 2017-02-10 at 14:29 -0500, Jeff Layton wrote:
> > On Fri, 2017-02-10 at 14:14 -0500, Simo Sorce wrote:
> > > On Fri, 2017-02-10 at 13:30 -0500, Jeff Layton wrote:
> > > > On Fri, 2017-02-10 at 12:39 -0500, Jeff Layton wrote:
> > > > > On Fri, 2017-02-10 at 11:15 -0600, Chad William Seys wrote:
> > > > > > Hi Jeff,
> > > > > > 
> > > > > > > So we have a default credcache for the user for whom we are
> > > > > > > operating
> > > > > > > as, but we can't get the default principal name from it. My
> > > > > > > guess is
> > > > > > > that it's not finding the
> > > > > > 
> > > > > > This mount is run by root UID=0 and seems to be find that
> > > > > > credential 
> > > > > > cache without problem (earlier in the logs).  The problem
> > > > > > seems
> > > > > > to come 
> > > > > > in when it tries to find the cache for user with UID=1494 .
> > > > > > 
> > > > > > I'm wondering if the scan of /tmp was helpful for finding
> > > > > > caches
> > > > > > of 
> > > > > > non-same users.
> > > > > > 
> > > > > > (I'm a little surprised that there is any attempt to find
> > > > > > credentials of 
> > > > > > the non-root user at mount time - what happens if the non-
> > > > > > root
> > > > > > user 
> > > > > > hasn't kinit-ed yet?  And yet that case worked in the
> > > > > > past...)
> > > > > > 
> > > > > 
> > > > > I'm more interested in what the trailing info in your credcache
> > > > > name is.
> > > > > In your log output for the working case, there are:
> > > > > 
> > > > > /tmp/krb5cc_0
> > > > > /tmp/krb5cc_1494_sM11PG
> > > > > 
> > > > > So first one doesn't have that _XXXXXX trailing bit. Maybe
> > > > > cifs.upcall
> > > > > is not guessing that piece of the filename correctly?
> > > > > 
> > > > 
> > > > (cc'ing Nalin, Simo and the linux-cifs ml)
> > > > 
> > > > Yeah, it seems pretty likely that that is the problem. My guess
> > > > is
> > > > that
> > > > the extra stuff on the ccname is coming from pam_krb5, which
> > > > seems to
> > > > want to create a credcache that is session-specific.
> > > > 
> > > > You could play with setting a different ccname_template for
> > > > pam_krb5
> > > > that doesn't have the trailing stuff at the end, but it looks
> > > > like it
> > > > won't clean them up on logout if you do that. Caveat emptor.
> > > > 
> > > > I'm not sure what the right solution is there. For Simo and
> > > > Nalin:
> > > > 
> > > > The upshot here is that we did a big clean up of the cifs-utils
> > > > code
> > > > recently, to get it out of the business of scanning /tmp for
> > > > credcaches.
> > > > That allows us to have better compatibility with other credcache
> > > > types
> > > > (keyring or whatever), and it was always rather nasty anyway.
> > > > 
> > > > pam_krb5 wants to make session-specific credcaches however, and
> > > > cifs.upcall can't easily guess them. cifs.upcall is called from
> > > > the
> > > > kernel, so it can't look in the environment or anything to find
> > > > the
> > > > credcache.
> > > > 
> > > > What's the right approach to fix this? Are we stuck with scanning
> > > > /tmp
> > > > forever?
> > > 
> > > I think the right approach in the long run will be the KCM we are
> > > building in SSSD and planning to make the default cache type for
> > > F26.
> > > 
> > > For file ccaches you are out of luck, even scanning /tmp can fail
> > > as
> > > users can decide to put them elsewhere.
> > > 
> > > If a scan need to be made I would rather stat the files and look
> > > which
> > > one belong to the user that start with "/tmp/krb" rather than
> > > trying to
> > > guess the file name. Keep in mind predictable file names in /tmp
> > > are
> > > really not an option so pam_krb5 is doing the right thing in using
> > > a
> > > randomized file name given it runs as root.
> > > 
> > 
> > Well, that's what we used to do -- do a readdir in /tmp, start
> > looking for files that might be credcaches. Of course that meant we
> > have to carry around a bunch of cruft for handling FILE: credcaches
> > that doesn't really adapt well to DIR: or KEYRING: ones.
> > 
> > I guess I have a philosophical question: how is an application (like
> > cifs.upcall), which is not descended from the user's session expected
> > to find a user's credcache? Is that use-case just not really
> > accounted for buy the krb5 libs?
> 
> Yeah it is not accounted for, it is assumed that applications are given
> a ccache name by the caller or in KRB5CCNAME.
> The fact the kernel operates this way was not on the radar in the
> intial design.
> 
> > One thing we could do (though I really don't like it), is to take the
> > pid value passed in the upcall and scrape that task's
> > /proc/<pid>/environ file for KRB5CCNAME=. That really is pretty nasty
> > though.
> 
> Yeah it is, and it is probably also not fully reliable, but it may be
> the best way to go in the short term.
> 
> I think the only way will be the KCM, although it would be really nice
> if the KCM could be given a session id of some kind, because it would
> be nice to be able to have different ccaches in different sessions.
> However for the general case and NFS/CIFS in particular I think KCM
> will be the right way to go and will be sufficient to just talk to it
> "as the user" (ie with a setuid like nfs utils does).
> 
> Simo.
> 

Something like this might work (on top of the debug patch I sent
earlier). Only tested for compilation so far, but I think the approach
is fairly straightforward. It definitely needs testing, and I'm not sure
I really like trusting info in the user's environment like this. Any
thoughts on ways to vet it more carefully?

In any case, I'll plan to give this a spin over the weekend when I get
some time.

----------------------8<-----------------------------

cifs.upcall: scrape KRB5CCNAME out of initiating task's /proc/<pid>/environ file

If we find one, then we use that to set the same variable, the same way in the
upcall's environment.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 119 insertions(+), 4 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index dd0843e358b1..82aa4f2c2c28 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -40,6 +40,7 @@
 #include <dirent.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <fcntl.h>
 #include <unistd.h>
 #include <keyutils.h>
 #include <time.h>
@@ -154,12 +155,127 @@ err_cache:
 	return credtime;
 }
 
+#define	CIFS_UPCALL_ENV_PATH_FMT	"/proc/%d/environ"
+#define	CIFS_UPCALL_ENV_PATH_MAXLEN	(6 + 10 + 8 + 1)
+
+#define	ENV_NAME			"KRB5CCNAME"
+#define	ENV_PREFIX			"KRB5CCNAME="
+#define	ENV_PREFIX_LEN			11
+
+#define	ENV_BUF_START			(4096)
+#define	ENV_BUF_MAX			(131072)
+
+/**
+ * get_cachename_from_process_env - scrape value of $KRB5CCNAME out of the
+ * 				    initiating process' environment.
+ * @pid: initiating pid value from the upcall string
+ *
+ * Open the /proc/<pid>/environ file for the given pid, and scrape it for
+ * KRB5CCNAME entries.
+ *
+ * We start with a page-size buffer, and then progressively double it until
+ * we can slurp in the whole thing.
+ *
+ * Note that this is not entirely reliable. If the process is sitting in a
+ * container or something, then this is almost certainly not going to point
+ * where you expect.
+ *
+ * Probably it just won't work, but could a user use this to trick cifs.upcall
+ * into reading a file outside the container, by setting KRB5CCNAME in a
+ * crafty way?
+ *
+ * YMMV here.
+ */
+static char *
+get_cachename_from_process_env(pid_t pid)
+{
+	int fd, ret;
+	ssize_t buflen;
+	ssize_t bufsize = ENV_BUF_START;
+	char pathname[CIFS_UPCALL_ENV_PATH_MAXLEN];
+	char *cachename = NULL;
+	char *buf = NULL, *pos;
+
+	if (!pid) {
+		syslog(LOG_DEBUG, "%s: pid == 0\n", __func__);
+		return NULL;
+	}
+
+	pathname[CIFS_UPCALL_ENV_PATH_MAXLEN - 1] = '\0';
+	ret = snprintf(pathname, CIFS_UPCALL_ENV_PATH_MAXLEN,
+				CIFS_UPCALL_ENV_PATH_FMT, pid);
+	if (ret || pathname[CIFS_UPCALL_ENV_PATH_MAXLEN - 1] != '\0') {
+		syslog(LOG_DEBUG, "%s: unterminated path!\n", __func__);
+		return NULL;
+	}
+
+	syslog(LOG_DEBUG, "%s: pathname=%s\n", __func__, pathname);
+	fd = open(pathname, O_RDONLY);
+	if (fd < 0) {
+		syslog(LOG_DEBUG, "%s: open failed: %d\n", __func__, errno);
+		return NULL;
+	}
+retry:
+	if (bufsize > ENV_BUF_MAX) {
+		syslog(LOG_DEBUG, "%s: buffer too big: %d\n", __func__, errno);
+		goto out_close;
+	}
+
+	buf = malloc(bufsize);
+	if (!buf) {
+		syslog(LOG_DEBUG, "%s: malloc failure\n", __func__);
+		goto out_close;
+	}
+
+	buflen = read(fd, buf, bufsize);
+	if (buflen < 0) {
+		syslog(LOG_DEBUG, "%s: read failed: %d\n", __func__, errno);
+		goto out_close;
+	}
+
+	if (buflen == bufsize) {
+		/* We read to the end of the buffer, double and try again */
+		syslog(LOG_DEBUG, "%s: read to end of buffer (%zu bytes)\n", __func__, bufsize);
+		free(buf);
+		bufsize *= 2;
+		if (lseek(fd, 0, SEEK_SET) < 0)
+			goto out_close;
+		goto retry;
+	}
+
+	pos = buf;
+	while (buflen > 0) {
+		size_t len = strnlen(pos, buflen);
+
+		if (len > ENV_PREFIX_LEN &&
+		    memcmp(pos, ENV_PREFIX, ENV_PREFIX_LEN)) {
+			cachename = strndup(pos + ENV_PREFIX_LEN,
+						len - ENV_PREFIX_LEN);
+			syslog(LOG_DEBUG, "%s: cachename = %s\n", __func__, cachename);
+			break;
+		}
+		buflen -= (len + 1);
+		pos += (len + 1);
+	}
+	free(buf);
+out_close:
+	close(fd);
+	return cachename;
+}
+
 static krb5_ccache
-get_default_cc(void)
+get_existing_cc(pid_t pid)
 {
 	krb5_error_code ret;
 	krb5_ccache cc;
-	char *cachename;
+	char *cachename = NULL;
+
+	cachename = get_cachename_from_process_env(pid);
+	if (cachename) {
+		if (setenv(ENV_NAME, cachename, 1))
+			syslog(LOG_DEBUG, "%s: failed to setenv %d\n", __func__, errno);
+		free(cachename);
+	}
 
 	ret = krb5_cc_default(context, &cc);
 	if (ret) {
@@ -182,7 +298,6 @@ get_default_cc(void)
 	return cc;
 }
 
-
 static krb5_ccache
 init_cc_from_keytab(const char *keytab_name, const char *user)
 {
@@ -815,7 +930,7 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
-	ccache = get_default_cc();
+	ccache = get_existing_cc(arg.pid);
 	/* Couldn't find credcache? Try to use keytab */
 	if (ccache == NULL && arg.username != NULL)
 		ccache = init_cc_from_keytab(keytab_name, arg.username);
-- 
2.9.3
