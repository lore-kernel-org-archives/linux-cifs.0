From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs-utils: fixes for manpage pathname replacement scheme
Date: Tue, 14 Dec 2010 12:05:29 -0500
Message-ID: <1292346329-31009-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fix up some small problems with pathname replacement:

1) replace the bare 'sed' with $(SED)

2) '\@' is apparently not portable, so we need to use a different scheme
   in case we end up using a non-typical sed binary.

3) do the sed conversion to a new file and then move it into place. If
   sed falls down halfway through the conversion we could end up with
   a half-baked manpage.

4) use the $@ construct for brevity and maintainability

5) add a comment so that the rationale behind this is explained

Many thanks to several folks inside Red Hat who pointed out these
issues.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index cbfa846..67a0190 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -14,11 +14,15 @@ cifs_upcall_SOURCES = cifs.upcall.c data_blob.c asn1.c spnego.c util.c
 cifs_upcall_LDADD = -ltalloc -lkeyutils $(KRB5_LDADD)
 man_MANS += cifs.upcall.8
 
+#
+# Fix the pathnames in manpages. To prevent @label@ being replaced by m4, we
+# need to obfuscate the LHS of the regex (hence the trivial one character set).
+#
 cifs.upcall.8: cifs.upcall.8.in
-	sed 's,\@sbindir\@,$(sbindir),' < $(srcdir)/cifs.upcall.8.in > cifs.upcall.8
+	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
 
 clean-local:
-	rm -f cifs.upcall.8
+	rm -f cifs.upcall.8 cifs.upcall.8-t
 endif
 
 if CONFIG_CIFSCREDS
-- 
1.7.3.2
