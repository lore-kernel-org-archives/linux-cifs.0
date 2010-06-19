From: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH]MAINTAINERS update e-mail address
Date: Sat, 19 Jun 2010 13:56:51 -0700
Message-ID: <1276981011-25092-1-git-send-email-justinmattock@gmail.com>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

get_maintainer.pl did it's job.. just the MAINTAINERS
file need to be updated or else you get this:
subject:Auto-response for your message to the "linux-cifs-client" mailing list

The linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org mailing list is now deprecated.
The new mailing list is linux-cifs-u79uwXL29TaiAVqoAR/hOA@public.gmane.org Subscription is no
longer required to post to that list. Please resend your message
there.

so update the linux-cifs address in the MAINTAINERS file.
 Signed-off-by: Justin P. Mattock <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d119c9..8d6a3ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1581,7 +1581,7 @@ F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 M:	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
-L:	linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org (moderated for non-subscribers)
+L:	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org	
 L:	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
 Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
-- 
1.7.1.rc1.21.gf3bd6

--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
