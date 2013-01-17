From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH] cifs: fix srcip_matches() for ipv6
Date: Wed, 16 Jan 2013 21:36:17 -0500
Message-ID: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

srcip_matches() previously had code like this:

  srcip_matches(..., struct sockaddr *rhs) {
    /* ... */
    struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *) &rhs;
    return ipv6_addr_equal(..., &vaddr6->sin6_addr);
  }

which interpreted the values on the stack after the 'rhs' pointer as an
ipv6 address.  The correct thing to do is to use 'rhs', not '&rhs'.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 fs/cifs/connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 17c3643..12b3da3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1917,7 +1917,7 @@ srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
 	}
 	case AF_INET6: {
 		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
-		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)&rhs;
+		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
 		return ipv6_addr_equal(&saddr6->sin6_addr, &vaddr6->sin6_addr);
 	}
 	default:
-- 
1.7.10.4
