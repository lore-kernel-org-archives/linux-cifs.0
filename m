From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 1/8] data_blob: remove need for replace.h
Date: Fri, 24 Feb 2017 09:27:43 -0500
Message-ID: <20170224142750.4151-2-jlayton@samba.org>
References: <20170224142750.4151-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170224142750.4151-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We only need ZERO_STRUCT there.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 data_blob.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/data_blob.c b/data_blob.c
index 834d810c9d46..a884f132bcde 100644
--- a/data_blob.c
+++ b/data_blob.c
@@ -20,9 +20,12 @@
 
 #include <string.h>
 
-#include "replace.h"
 #include "data_blob.h"
 
+#ifndef ZERO_STRUCT
+#define ZERO_STRUCT(x) memset((char *)&(x), 0, sizeof(x))
+#endif
+
 const DATA_BLOB data_blob_null = { NULL, 0 };
 
 /**
-- 
2.9.3
