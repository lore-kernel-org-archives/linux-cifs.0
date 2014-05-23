From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH] cifs: ensure that vol->username is not NULL before running strlen on it
Date: Fri, 23 May 2014 06:53:10 -0400
Message-ID: <1400842390-13488-1-git-send-email-jlayton@poochiereds.net>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dan Carpenter says:

The patch 04febabcf55b: "cifs: sanitize username handling" from Jan
17, 2012, leads to the following static checker warning:

	fs/cifs/connect.c:2231 match_session()
	error: we previously assumed 'vol->username' could be null (see line 2228)

fs/cifs/connect.c
  2219                  /* NULL username means anonymous session */
  2220                  if (ses->user_name == NULL) {
  2221                          if (!vol->nullauth)
  2222                                  return 0;
  2223                          break;
  2224                  }
  2225
  2226                  /* anything else takes username/password */
  2227                  if (strncmp(ses->user_name,
  2228                              vol->username ? vol->username : "",
                                    ^^^^^^^^^^^^^
We added this check for vol->username here.

  2229                              CIFS_MAX_USERNAME_LEN))
  2230                          return 0;
  2231                  if (strlen(vol->username) != 0 &&
                                   ^^^^^^^^^^^^^
But this dereference is not checked.

  2232                      ses->password != NULL &&
  2233                      strncmp(ses->password,
  2234                              vol->password ? vol->password : "",
  2235                              CIFS_MAX_PASSWORD_LEN))
  2236                          return 0;

...fix this by ensuring that vol->username is not NULL before running
strlen on it.

Signed-off-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8b8fe9b373f2..20d75b8ddb26 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2228,7 +2228,7 @@ static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
 			    vol->username ? vol->username : "",
 			    CIFS_MAX_USERNAME_LEN))
 			return 0;
-		if (strlen(vol->username) != 0 &&
+		if ((vol->username && strlen(vol->username) != 0) &&
 		    ses->password != NULL &&
 		    strncmp(ses->password,
 			    vol->password ? vol->password : "",
-- 
1.9.0
