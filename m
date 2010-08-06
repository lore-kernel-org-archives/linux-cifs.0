From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] cifs: Include linux/err.h for IS_ERR and PTR_ERR
Date: Fri, 06 Aug 2010 03:13:47 +0100
Message-ID: <20100806021347.29873.87087.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	David Howells <dhowells@redhat.com>
To: smfrench@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Fixes build errors:

net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
net/dns_resolver/dns_key.c:170: error: implicit declaration of function 'IS_ERR'
net/dns_resolver/dns_key.c:171: error: implicit declaration of function 'PTR_ERR'
net/dns_resolver/dns_query.c: In function 'dns_query':
net/dns_resolver/dns_query.c:126: error: implicit declaration of function 'IS_ERR'
net/dns_resolver/dns_query.c:127: error: implicit declaration of function 'PTR_ERR'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/dns_resolver/dns_key.c   |    1 +
 net/dns_resolver/dns_query.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 1b1b411..400a04d 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -28,6 +28,7 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/keyctl.h>
+#include <linux/err.h>
 #include <keys/dns_resolver-type.h>
 #include <keys/user-type.h>
 #include "internal.h"
diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index 6c0cf31..b33e1f7 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -39,6 +39,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/dns_resolver.h>
+#include <linux/err.h>
 #include <keys/dns_resolver-type.h>
 #include <keys/user-type.h>
 
