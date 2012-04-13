From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Fix number parsing in cifs_parse_mount_options
Date: Fri, 13 Apr 2012 14:04:32 +0100
Message-ID: <1334322272.2308.1.camel@localhost>
References: <201204130712.51693.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
To: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201204130712.51693.chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The function kstrtoul() used to parse number strings in the mount
option parser is set to expect a base 10 number . This treats the octal
numbers passed for mount options such as file_mode as base10 numbers
leading to incorrect behavior.

Change the 'base' argument passed to kstrtoul from 10 to 0 to
allow it to auto-detect the base of the number passed.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>

---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6a86f3d..f31dc9a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1123,7 +1123,7 @@ static int get_option_ul(substring_t args[], unsigned long *option)
 	string = match_strdup(args);
 	if (string == NULL)
 		return -ENOMEM;
-	rc = kstrtoul(string, 10, option);
+	rc = kstrtoul(string, 0, option);
 	kfree(string);
 
 	return rc;
-- 
1.7.7.6
