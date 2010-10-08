From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: reinstate ip= as an override for address resolution
Date: Fri,  8 Oct 2010 15:15:05 -0400
Message-ID: <1286565306-32035-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The manpage says:

       ip=arg
           sets the destination IP address. This option is set automatically
           if the server name portion of the requested UNC name can be
           resolved so rarely needs to be specified by the user.

...but recent changes have made it not work anymore as an override if
someone specifies an ip= option as part of the mount options. Reinstate
that behavior by copying the ip= option verbatim into the addrlist of
the parsed options struct and then skipping the name resolution. That
should allow the ip= option to pass unadulterated to the kernel.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index ed27bba..df92d79 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -958,10 +958,12 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
 					"target ip address argument missing\n");
 			} else if (strnlen(value, MAX_ADDRESS_LEN) <=
 				MAX_ADDRESS_LEN) {
+				strcpy(parsed_info->addrlist, value);
 				if (parsed_info->verboseflag)
 					fprintf(stderr,
 						"ip address %s override specified\n",
 						value);
+				goto nocopy;
 			} else {
 				fprintf(stderr, "ip address too long\n");
 				return EX_USAGE;
@@ -1556,7 +1558,9 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
 	if (rc)
 		goto assemble_exit;
 
-	rc = resolve_host(parsed_info->host, parsed_info->addrlist);
+	if (parsed_info->addrlist[0] == '\0')
+		rc = resolve_host(parsed_info->host, parsed_info->addrlist);
+
 	switch (rc) {
 	case EX_USAGE:
 		fprintf(stderr, "mount error: could not resolve address for "
-- 
1.7.2.3
