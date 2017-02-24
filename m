From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 2/8] spengo.c/asn1.c: remove need for replace.h
Date: Fri, 24 Feb 2017 09:27:44 -0500
Message-ID: <20170224142750.4151-3-jlayton@samba.org>
References: <20170224142750.4151-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170224142750.4151-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Just need stdbool.h instead.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 asn1.c   | 2 +-
 spnego.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/asn1.c b/asn1.c
index 4c0e48037f14..dd96d2c0e595 100644
--- a/asn1.c
+++ b/asn1.c
@@ -20,8 +20,8 @@
 #include <string.h>
 #include <talloc.h>
 #include <stdint.h>
+#include <stdbool.h>
 
-#include "replace.h"
 #include "data_blob.h"
 #include "asn1.h"
 
diff --git a/spnego.c b/spnego.c
index 7f32d7d2efa9..e483e6e1c526 100644
--- a/spnego.c
+++ b/spnego.c
@@ -21,8 +21,8 @@
 
 #include <talloc.h>
 #include <stdint.h>
+#include <stdbool.h>
 
-#include "replace.h"
 #include "data_blob.h"
 #include "asn1.h"
 #include "spnego.h"
-- 
2.9.3
