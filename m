From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/3] setcifsacl: fix endianness of ->size in build_cmdline_aces
Date: Wed,  7 Nov 2012 06:52:00 -0500
Message-ID: <1352289120-29327-4-git-send-email-jlayton@samba.org>
References: <1352289120-29327-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352289120-29327-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The size must also be kept in little-endian.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 3178eff..8891844 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -626,8 +626,8 @@ build_cmdline_aces(char **arrptr, int numcaces)
 			goto build_cmdline_aces_ret;
 		}
 
-		cacesptr[i]->size = 1 + 1 + 2 + 4 + 1 + 1 + 6 +
-				(cacesptr[i]->sid.num_subauth * 4);
+		cacesptr[i]->size = htole16(1 + 1 + 2 + 4 + 1 + 1 + 6 +
+					    cacesptr[i]->sid.num_subauth * 4);
 	}
 	return cacesptr;
 
-- 
1.7.12.1
