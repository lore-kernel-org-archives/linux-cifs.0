From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Elminate sparse __CHECK_ENDIAN__ warnings on port conversion
Date: Sun, 13 Mar 2011 14:00:03 -0500
Message-ID: <AANLkTikqyrPQX0_cyNA7=WP5d4OB1NX4J5R+GFPgKgvW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

[PATCH] [CIFS] Elminate sparse __CHECK_ENDIAN__ warnings on port conversion

Ports are __be16 not unsigned short int

Eliminates the remaining fixable endian warnings:

~/cifs-2.6$ make modules C=1 M=fs/cifs CF=-D__CHECK_ENDIAN__
  CHECK   fs/cifs/connect.c
fs/cifs/connect.c:2408:23: warning: incorrect type in assignment
(different base types)
fs/cifs/connect.c:2408:23:    expected unsigned short *sport
fs/cifs/connect.c:2408:23:    got restricted __be16 *<noident>
fs/cifs/connect.c:2410:23: warning: incorrect type in assignment
(different base types)
fs/cifs/connect.c:2410:23:    expected unsigned short *sport
fs/cifs/connect.c:2410:23:    got restricted __be16 *<noident>
fs/cifs/connect.c:2416:24: warning: incorrect type in assignment
(different base types)
fs/cifs/connect.c:2416:24:    expected unsigned short [unsigned]
[short] <noident>
fs/cifs/connect.c:2416:24:    got restricted __be16 [usertype] <noident>
fs/cifs/connect.c:2423:24: warning: incorrect type in assignment
(different base types)
fs/cifs/connect.c:2423:24:    expected unsigned short [unsigned]
[short] <noident>
fs/cifs/connect.c:2423:24:    got restricted __be16 [usertype] <noident>
fs/cifs/connect.c:2326:23: warning: incorrect type in assignment
(different base types)
fs/cifs/connect.c:2326:23:    expected unsigned short [unsigned] sport
fs/cifs/connect.c:2326:23:    got restricted __be16 [usertype] sin6_port
fs/cifs/connect.c:2330:23: warning: incorrect type in assignment
(different base types)
fs/cifs/connect.c:2330:23:    expected unsigned short [unsigned] sport
fs/cifs/connect.c:2330:23:    got restricted __be16 [usertype] sin_port
fs/cifs/connect.c:2394:22: warning: restricted __be16 degrades to integer

Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 63ec77c..a98cb6f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1493,7 +1493,7 @@ srcip_matches(struct sockaddr *srcaddr, struct
sockaddr *rhs)
 static bool
 match_port(struct TCP_Server_Info *server, struct sockaddr *addr)
 {
-	unsigned short int port, *sport;
+	__be16 port, *sport;

 	switch (addr->sa_family) {
 	case AF_INET:
@@ -2315,7 +2315,7 @@ static int
 generic_ip_connect(struct TCP_Server_Info *server)
 {
 	int rc = 0;
-	unsigned short int sport;
+	__be16 sport;
 	int slen, sfamily;
 	struct socket *socket = server->ssocket;
 	struct sockaddr *saddr;
@@ -2400,7 +2400,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
 static int
 ip_connect(struct TCP_Server_Info *server)
 {
-	unsigned short int *sport;
+	__be16 *sport;
 	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;


-- 
Thanks,

Steve
