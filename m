From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] list_debug: check prev/next for NULL when checking list_head for validity
Date: Wed, 10 Jan 2018 11:03:49 +1100
Message-ID: <20180110000349.14963-2-lsahlber@redhat.com>
References: <20180110000349.14963-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180110000349.14963-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 lib/list_debug.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/list_debug.c b/lib/list_debug.c
index a34db8d27667..01ef3f6d4706 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -42,7 +42,13 @@ bool __list_del_entry_valid(struct list_head *entry)
 	prev = entry->prev;
 	next = entry->next;
 
-	if (CHECK_DATA_CORRUPTION(next == LIST_POISON1,
+	if (CHECK_DATA_CORRUPTION(next == NULL,
+			"list_del corruption, %p->next is NULL (%p)\n",
+			entry, LIST_POISON1) ||
+	    CHECK_DATA_CORRUPTION(prev == NULL,
+			"list_del corruption, %p->prev is NULL (%p)\n",
+			entry, LIST_POISON2) ||
+	    CHECK_DATA_CORRUPTION(next == LIST_POISON1,
 			"list_del corruption, %p->next is LIST_POISON1 (%p)\n",
 			entry, LIST_POISON1) ||
 	    CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
-- 
2.13.3
