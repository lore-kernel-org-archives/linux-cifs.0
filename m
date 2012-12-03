From: Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>
Subject: [PATCH] MAINTAINERS: Fix cifs-tree git url
Date: Mon, 3 Dec 2012 11:36:54 +0100
Message-ID: <20121203103654.GY27196@axis.com>
References: <20121129173053.GQ27196@axis.com>
 <CAH2r5mvKGnZdUNb1-Msb10NBypG2cQm+5JrN-Ajv8VNvmX2+Pg@mail.gmail.com>
 <20121129184709.GR27196@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121129184709.GR27196-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The cifs-tree is no longer found on kernel.org,
but linux-next uses the tree on samba.org, so use that instead.

Signed-off-by: Jesper Nilsson <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 244b2f2..60d0e35 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2009,7 +2009,7 @@ L:	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 L:	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
 Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
+T:	git git://git.samba.org/sfrench/cifs-2.6.git
 S:	Supported
 F:	Documentation/filesystems/cifs.txt
 F:	fs/cifs/
-- 
1.7.11.7


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson-VrBV9hrLPhE@public.gmane.org
