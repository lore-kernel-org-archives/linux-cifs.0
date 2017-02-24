From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 8/8] cifs.upcall: don't do env scraping when uid is 0
Date: Fri, 24 Feb 2017 09:27:50 -0500
Message-ID: <20170224142750.4151-9-jlayton@samba.org>
References: <20170224142750.4151-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170224142750.4151-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Setuid programs triggering upcalls could trick the program here. Also,
the d_automount method is done with credentials overridden so if you
can end up with mismatched creds and env vars due to that as well.

It's a hack, but the only recourse I can see is to avoid doing this
when the uid is 0. That means we can't rely on finding root credcaches
in alternate locations using $KRB5CCNAME, but I think that's the best
we can do.

Reported-by: Chad William Seys <cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.8.in |  5 ++++-
 cifs.upcall.c    | 10 +++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/cifs.upcall.8.in b/cifs.upcall.8.in
index e1f3956e176a..81481a482fb4 100644
--- a/cifs.upcall.8.in
+++ b/cifs.upcall.8.in
@@ -44,7 +44,10 @@ Normally, cifs.upcall will probe the environment variable space of the process
 that initiated the upcall in order to fetch the value of $KRB5CCNAME. This can
 assist the program with finding credential caches in non-default locations. If
 this option is set, then the program won't do this and will rely on finding
-credcaches in the default locations specified in krb5.conf.
+credcaches in the default locations specified in krb5.conf. Note that this is
+never performed when the uid is 0. The default credcache location is always
+used when the uid is 0, regardless of the environment variable setting in the
+process.
 .RE
 .PP
 \--krb5conf=/path/to/krb5.conf|-k /path/to/krb5.conf
diff --git a/cifs.upcall.c b/cifs.upcall.c
index 0c89d7cf40d7..8545e09611ad 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1038,11 +1038,19 @@ int main(const int argc, char *const argv[])
 	}
 
 	/*
+	 * We can't reasonably do this for root. Mounting a DFS share, for
+	 * instance we can end up with creds being overridden, but the env
+	 * variable left intact.
+	 */
+	if (uid == 0)
+		env_probe = false;
+
+	/*
 	 * Must do this before setuid, as we need elevated capabilities to
 	 * look at the environ file.
 	 */
 	env_cachename =
-		get_cachename_from_process_env(env_probe ?  arg.pid : 0);
+		get_cachename_from_process_env(env_probe ? arg.pid : 0);
 
 	rc = setuid(uid);
 	if (rc == -1) {
-- 
2.9.3
