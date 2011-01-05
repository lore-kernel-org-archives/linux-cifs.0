From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs.upcall: add 'l' to getopt_long string
Date: Wed,  5 Jan 2011 10:37:05 -0500
Message-ID: <1294241825-9979-1-git-send-email-jlayton@samba.org>
Cc: Stefan Walter <walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reported-by: Stefan Walter <walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 648a138..1ffcd7c 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -680,7 +680,7 @@ int main(const int argc, char *const argv[])
 
 	openlog(prog, 0, LOG_DAEMON);
 
-	while ((c = getopt_long(argc, argv, "ctv", long_options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cltv", long_options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			/* legacy option -- skip it */
-- 
1.7.3.4
