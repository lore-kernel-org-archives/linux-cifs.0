From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifscreds: check optind before accessing argv[optind]
Date: Tue, 23 Jan 2018 11:48:01 +1100
Message-ID: <20180123004801.10182-1-lsahlber@redhat.com>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Redhat bugzilla: 1278543

This fixes a segfault for some incorrect usage, for example
   cifscreds -u test

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 cifscreds.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/cifscreds.c b/cifscreds.c
index 5d84c3c..32f2ee4 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -487,6 +487,9 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (optind >= argc)
+		return usage();
+
 	/* find the best fit command */
 	best = NULL;
 	n = strnlen(argv[optind], MAX_COMMAND_SIZE);
-- 
2.15.1
