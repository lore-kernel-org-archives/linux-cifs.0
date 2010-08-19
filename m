From: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] cifs: correction of unicode header files
Date: Fri, 20 Aug 2010 00:27:12 +0400
Message-ID: <1282249633-27756-1-git-send-email-jaxbrigs@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch corrects a problem of compilation errors at removal of
UNIUPR_NOLOWER definition and adds include guards to cifs_unicode.h.

Signed-off-by: Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifs_unicode.h |   18 +++++++++++-------
 fs/cifs/cifs_uniupr.h  |   16 ++++++++--------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 6506382..7fe6b52 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -30,6 +30,8 @@
  *     This is a compressed table of upper and lower case conversion.
  *
  */
+#ifndef _CIFS_UNICODE_H
+#define _CIFS_UNICODE_H
 
 #include <asm/byteorder.h>
 #include <linux/types.h>
@@ -67,8 +69,8 @@ extern const struct UniCaseRange CifsUniUpperRange[];
 #endif				/* UNIUPR_NOUPPER */
 
 #ifndef UNIUPR_NOLOWER
-extern signed char UniLowerTable[512];
-extern struct UniCaseRange UniLowerRange[];
+extern signed char CifsUniLowerTable[512];
+extern const struct UniCaseRange CifsUniLowerRange[];
 #endif				/* UNIUPR_NOLOWER */
 
 #ifdef __KERNEL__
@@ -337,15 +339,15 @@ UniStrupr(register wchar_t *upin)
  * UniTolower:  Convert a unicode character to lower case
  */
 static inline wchar_t
-UniTolower(wchar_t uc)
+UniTolower(register wchar_t uc)
 {
-	register struct UniCaseRange *rp;
+	register const struct UniCaseRange *rp;
 
-	if (uc < sizeof(UniLowerTable)) {
+	if (uc < sizeof(CifsUniLowerTable)) {
 		/* Latin characters */
-		return uc + UniLowerTable[uc];	/* Use base tables */
+		return uc + CifsUniLowerTable[uc];	/* Use base tables */
 	} else {
-		rp = UniLowerRange;	/* Use range tables */
+		rp = CifsUniLowerRange;	/* Use range tables */
 		while (rp->start) {
 			if (uc < rp->start)	/* Before start of range */
 				return uc;	/* Uppercase = input */
@@ -374,3 +376,5 @@ UniStrlwr(register wchar_t *upin)
 }
 
 #endif
+
+#endif /* _CIFS_UNICODE_H */
diff --git a/fs/cifs/cifs_uniupr.h b/fs/cifs/cifs_uniupr.h
index 18a9d97..0ac7c5a 100644
--- a/fs/cifs/cifs_uniupr.h
+++ b/fs/cifs/cifs_uniupr.h
@@ -140,7 +140,7 @@ const struct UniCaseRange CifsUniUpperRange[] = {
 /*
  * Latin lower case
  */
-static signed char CifsUniLowerTable[512] = {
+signed char CifsUniLowerTable[512] = {
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 000-00f */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 010-01f */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 020-02f */
@@ -242,12 +242,12 @@ static signed char UniCaseRangeLff20[27] = {
 /*
  * Lower Case Range
  */
-static const struct UniCaseRange CifsUniLowerRange[] = {
-	0x0380, 0x03ab, UniCaseRangeL0380,
-	0x0400, 0x042f, UniCaseRangeL0400,
-	0x0490, 0x04cb, UniCaseRangeL0490,
-	0x1e00, 0x1ff7, UniCaseRangeL1e00,
-	0xff20, 0xff3a, UniCaseRangeLff20,
-	0, 0, 0
+const struct UniCaseRange CifsUniLowerRange[] = {
+	{0x0380, 0x03ab, UniCaseRangeL0380},
+	{0x0400, 0x042f, UniCaseRangeL0400},
+	{0x0490, 0x04cb, UniCaseRangeL0490},
+	{0x1e00, 0x1ff7, UniCaseRangeL1e00},
+	{0xff20, 0xff3a, UniCaseRangeLff20},
+	{0}
 };
 #endif
-- 
1.7.2.1
