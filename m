From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Remove unnecessary check for NULL in password parser
Date: Wed, 28 Mar 2012 18:07:08 +0100
Message-ID: <1332954428.9998.5.camel@localhost>
References: <20120328104541.GC29022@elgon.mountain>
	 <1332933181.2144.11.camel@localhost> <20120328113146.GE3200@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	smfrench <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120328113146.GE3200@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The password parser has an unnecessary check for a NULL value which
triggers warnings in source checking tools. The code contains artifacts
from the old parsing code which are no longer required.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 302a15c..0511fdb 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1565,8 +1565,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 			/* Obtain the value string */
 			value = strchr(data, '=');
-			if (value != NULL)
-				*value++ = '\0';
+			value++;
 
 			/* Set tmp_end to end of the string */
 			tmp_end = (char *) value + strlen(value);
-- 
1.7.7.6
