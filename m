From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH 05/10] fs: cifs: Replace CURRENT_TIME by get_seconds
Date: Tue,  2 Feb 2016 22:07:45 -0800
Message-ID: <1454479670-8204-6-git-send-email-deepa.kernel@gmail.com>
References: <1454479670-8204-1-git-send-email-deepa.kernel@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
To: linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454479670-8204-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This is in preparation for the series that transitions
filesystem timestamps to use 64 bit time and hence make
them y2038 safe.

CURRENT_TIME macro will be deleted before merging the
aforementioned series.

Filesystems will use current_fs_time() instead of
CURRENT_TIME.
Use get_seconds() here as this is not filesystem time.
Only the seconds portion of the timestamp is necessary for
timezone calculation using server time.

Assume that the difference between server and client times
lie in the range INT_MIN..INT_MAX. This is valid because
this is the difference between current times between server
and client, and the largest timezone difference is in the
range of one day.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
---
 fs/cifs/cifssmb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 90b4f9f..1a9e43d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -478,14 +478,14 @@ decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
 		 * this requirement.
 		 */
 		int val, seconds, remain, result;
-		struct timespec ts, utc;
-		utc = CURRENT_TIME;
+		struct timespec ts;
+		unsigned long utc = get_seconds();
 		ts = cnvrtDosUnixTm(rsp->SrvTime.Date,
 				    rsp->SrvTime.Time, 0);
 		cifs_dbg(FYI, "SrvTime %d sec since 1970 (utc: %d) diff: %d\n",
-			 (int)ts.tv_sec, (int)utc.tv_sec,
-			 (int)(utc.tv_sec - ts.tv_sec));
-		val = (int)(utc.tv_sec - ts.tv_sec);
+			 (int)ts.tv_sec, (int)utc,
+			 (int)(utc - ts.tv_sec));
+		val = (int)(utc - ts.tv_sec);
 		seconds = abs(val);
 		result = (seconds / MIN_TZ_ADJ) * MIN_TZ_ADJ;
 		remain = seconds % MIN_TZ_ADJ;
-- 
1.9.1
