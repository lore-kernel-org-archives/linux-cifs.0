From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: add 'fsc' mount option to the usage help text
Date: Tue, 27 Jul 2010 19:26:46 +0530
Message-ID: <4C4EE59E.7050800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add 'fsc' mount option to the 'Less commonly used options' section of
mount.cifs usage help text. As with the previous patch, this one too could be
queued and considered once the local caching patches gets merged upstream.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 mount.cifs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index c84e72d..2065f46 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -265,7 +265,7 @@ static int mount_cifs_usage(FILE * stream)
 	fprintf(stream,
 		"\n\tmapchars,nomapchars,nolock,servernetbiosname=<SRV_RFC1001NAME>");
 	fprintf(stream,
-		"\n\tdirectio,nounix,cifsacl,sec=<authentication mechanism>,sign");
+		"\n\tdirectio,nounix,cifsacl,sec=<authentication mechanism>,sign,fsc");
 	fprintf(stream,
 		"\n\nOptions not needed for servers supporting CIFS Unix extensions");
 	fprintf(stream,
