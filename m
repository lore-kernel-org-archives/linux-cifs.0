From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 9/8] cifs.upcall: use a MEMORY: ccache when instantiating from a keytab
Date: Fri, 24 Feb 2017 10:53:22 -0500
Message-ID: <20170224155322.6116-1-jlayton@samba.org>
References: <20170224142750.4151-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170224142750.4151-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Using a more permanent ccache is potentially problematic when we're
instantiating a new one. We might be operating under different creds
than expected. Just use a MEMORY: ccache since we don't need it to
last longer than the life of the upcall anyway.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index e0d372408233..89563fd42adc 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -410,9 +410,9 @@ init_cc_from_keytab(const char *keytab_name, const char *user)
 		goto icfk_cleanup;
 	}
 
-	ret = krb5_cc_default(context, &cc);
+	ret = krb5_cc_resolve(context, "MEMORY:", &cc);
 	if (ret) {
-		syslog(LOG_DEBUG, "krb5_cc_default: %d", (int)ret);
+		syslog(LOG_DEBUG, "krb5_cc_resolve: %d", (int)ret);
 		goto icfk_cleanup;
 	}
 
-- 
2.9.3
