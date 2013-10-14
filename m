From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH][cifs-utils] asn1: fix use-after-free in asn1_write
Date: Mon, 14 Oct 2013 06:26:17 -0400
Message-ID: <1381746377-1870-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If the talloc_realloc() fails, asn1_write calls talloc_free on the
context and then immediately dereferences the pointer.

Fix this by skipping the talloc_free here. Let the caller handle it.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 asn1.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/asn1.c b/asn1.c
index ea50a23..4c0e480 100644
--- a/asn1.c
+++ b/asn1.c
@@ -47,7 +47,6 @@ bool asn1_write(struct asn1_data *data, const void *p, int len)
 		uint8_t *newp;
 		newp = talloc_realloc(data, data->data, uint8_t, data->ofs+len);
 		if (!newp) {
-			asn1_free(data);
 			data->has_error = true;
 			return false;
 		}
-- 
1.8.3.1
