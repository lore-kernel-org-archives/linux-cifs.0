From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/3] setcifsacl: fix up ACE mask handling
Date: Wed,  7 Nov 2012 06:51:59 -0500
Message-ID: <1352289120-29327-3-git-send-email-jlayton@samba.org>
References: <1352289120-29327-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352289120-29327-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Change verify_ace_mask to just attempt to convert the argument to an
unsigned long first. If that fails, then try to treat it as a symbolic
mask string.

Also, clean up ace_mask_value. There's no need to walk the string
twice. Walk it once and turn the single-char mask checks into a switch
statement instead of if/else clauses.

Finally, fix the endianness of the resulting value. It must be in LE.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 81 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 40 insertions(+), 41 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 37e95e2..3178eff 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -512,62 +512,61 @@ verify_ace_flags(char *flagstr, uint8_t *flagval)
 }
 
 static uint32_t
-ace_mask_value(char *maskstr)
+ace_mask_value(char *mask)
 {
-	int i, len;
-	uint32_t maskval = 0x0;
-	char *lmask;
+	uint32_t maskval = 0;
+	char cur;
 
-	if (!strcmp(maskstr, "FULL"))
+	if (!strcmp(mask, "FULL"))
 		return FULL_CONTROL;
-	else if (!strcmp(maskstr, "CHANGE"))
+	if (!strcmp(mask, "CHANGE"))
 		return CHANGE;
-	else if (!strcmp(maskstr, "D"))
-		return DELETE;
-	else if (!strcmp(maskstr, "READ"))
+	if (!strcmp(mask, "READ"))
 		return EREAD;
-	else {
-		len = strlen(maskstr);
-		lmask = maskstr;
-		for (i = 0; i < len; ++i, ++lmask) {
-			if (*lmask == 'R')
-				maskval |= EREAD;
-			else if (*lmask == 'W')
-				maskval |= EWRITE;
-			else if (*lmask == 'X')
-				maskval |= EXEC;
-			else if (*lmask == 'D')
-				maskval |= DELETE;
-			else if (*lmask == 'P')
-				maskval |= WRITE_DAC;
-			else if (*lmask == 'O')
-				maskval |= WRITE_OWNER;
-			else
-				return 0;
+
+	while((cur = *mask++)) {
+		switch(cur) {
+		case 'R':
+			maskval |= EREAD;
+			break;
+		case 'W':
+			maskval |= EWRITE;
+			break;
+		case 'X':
+			maskval |= EXEC;
+			break;
+		case 'D':
+			maskval |= DELETE;
+			break;
+		case 'P':
+			maskval |= WRITE_DAC;
+			break;
+		case 'O':
+			maskval |= WRITE_OWNER;
+			break;
+		default:
+			return 0;
 		}
-		return maskval;
 	}
-
-	return 0;
+	return maskval;
 }
 
 static int
 verify_ace_mask(char *maskstr, uint32_t *maskval)
 {
-	char *invalflag;
+	unsigned long val;
+	char *ep;
 
-	if (strstr(maskstr, "0x") || !strcmp(maskstr, "DELDHLD")) {
-		*maskval = strtol(maskstr, &invalflag, 16);
-		if (!invalflag) {
-			printf("%s: Invalid mask: %s\n", __func__, maskstr);
-			return 1;
-		}
-	} else
-		*maskval = ace_mask_value(maskstr);
+	errno = 0;
+	val = strtoul(maskstr, &ep, 0);
+	if (errno == 0 && *ep == '\0')
+		*maskval = htole32((uint32_t)val);
+	else
+		*maskval = htole32(ace_mask_value(maskstr));
 
 	if (!*maskval) {
-		printf("%s: Invalid mask %s and value: 0x%x\n",
-			__func__, maskstr, *maskval);
+		printf("%s: Invalid mask %s (value 0x%x)\n", __func__,
+			maskstr, *maskval);
 		return 1;
 	}
 
-- 
1.7.12.1
