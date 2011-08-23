From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 8/8] cifs-utils: cifsacl utilities: Add make directives for setcifsacl (try #2)
Date: Tue, 23 Aug 2011 14:04:30 -0500
Message-ID: <1314126270-12130-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Add Makefile directives for setcifsacl.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Makefile.am |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 3ec6b7e..7d4bdea 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -57,11 +57,18 @@ getcifsacl_SOURCES = getcifsacl.c
 getcifsacl_LDADD = -lkeyutils $(WINB_LDADD)
 man_MANS += getcifsacl.8
 
+sbin_PROGRAMS += setcifsacl
+setcifsacl_SOURCES = setcifsacl.c
+setcifsacl_LDADD = -lkeyutils $(WINB_LDADD)
+man_MANS += setcifsacl.8
+
 getcifsacl.8: getcifsacl.8.in
 	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
+setcifsacl.8: setcifsacl.8.in
+	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
 endif
 
 clean-local-aclprogs:
 if CONFIG_CIFSACL
-	rm -f getcifsacl.8 getcifsacl.8-t
+	rm -f getcifsacl.8 getcifsacl.8-t setcifsacl.8 setcifsacl.8-t
 endif
-- 
1.6.0.2
