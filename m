From: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] Add warning that NFS syntax is deprecated and will be removed in cifs-utils-6.0.
Date: Thu, 18 Oct 2012 14:07:49 -0400
Message-ID: <1350583669-12118-2-git-send-email-scott.lovenberg@gmail.com>
References: <1350583669-12118-1-git-send-email-scott.lovenberg@gmail.com>
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350583669-12118-1-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mount.cifs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 756fce2..061ce32 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1335,6 +1335,7 @@ static int parse_unc(const char *unc_name, struct parsed_mount_info *parsed_info
 	}
 
 	/* Set up "host" and "share" pointers based on UNC format. */
+	/* TODO: Remove support for NFS syntax as of cifs-utils-6.0. */
 	if (strncmp(unc_name, "//", 2) && strncmp(unc_name, "\\\\", 2)) {
 		/*
 		 * check for nfs syntax (server:/share/prepath)
@@ -1351,6 +1352,9 @@ static int parse_unc(const char *unc_name, struct parsed_mount_info *parsed_info
 		share++;
 		if (*share == '/')
 			++share;
+		fprintf(stderr, "WARNING: using NFS syntax for mounting CIFS "
+			"shares is deprecated and will be removed in cifs-utils"
+			"-6.0. Please migrate to UNC syntax.");
 	} else {
 		host = unc_name + 2;
 		hostlen = strcspn(host, "/\\");
-- 
1.7.5.4
