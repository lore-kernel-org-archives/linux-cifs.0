From: Nalin Dahyabhai <nalin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] also consider DIR:-type ccaches
Date: Tue, 21 Aug 2012 18:56:24 -0400
Message-ID: <20120821225624.GH9511@redhat.com>
References: <20120821225443.GG9511@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120821225443.GG9511-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we encounter a subdirectory while scanning a directory for a user's
ccache, check if it's a "DIR" ccache.  Otherwise, continue as before,
checking if it's a "FILE" ccache if it looks like a regular file.
---
 cifs.upcall.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index eef461d..6f95c1c 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -292,6 +292,11 @@ static char *find_krb5_cc(const char *dirname, uid_t uid)
 			free(namelist[i]);
 			continue;
 		}
+		if (S_ISDIR(sbuf.st_mode)) {
+			snprintf(ccname, sizeof(ccname), "DIR:%s/%s", dirname,
+				 namelist[i]->d_name);
+			credpath = ccname + 4;
+		} else
 		if (!S_ISREG(sbuf.st_mode)) {
 			syslog(LOG_DEBUG, "%s: %s is not a regular file",
 			       __func__, credpath);
-- 
1.7.11.5
