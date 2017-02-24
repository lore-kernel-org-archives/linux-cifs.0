From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 7/8] cifs.upcall: unset $KRB5CCNAME when creating new credcache from keytab
Date: Fri, 24 Feb 2017 09:27:49 -0500
Message-ID: <20170224142750.4151-8-jlayton@samba.org>
References: <20170224142750.4151-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170224142750.4151-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We don't want to trust $KRB5CCNAME when creating or updating a new
credcache since we could be operating under the wrong credentials.
Always create new credcaches in the default location instead.

Reported-by: Chad William Seys <cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 15e1e0f91c22..0c89d7cf40d7 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -379,6 +379,12 @@ init_cc_from_keytab(const char *keytab_name, const char *user)
 
 	memset((char *) &my_creds, 0, sizeof(my_creds));
 
+	/*
+	 * Unset the environment variable, if any. If we're creating our own
+	 * credcache here, stick it in the default location.
+	 */
+	unsetenv(ENV_NAME);
+
 	if (keytab_name)
 		ret = krb5_kt_resolve(context, keytab_name, &keytab);
 	else
-- 
2.9.3
