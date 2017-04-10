From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: small underflow in cnvrtDosUnixTm()
Date: Mon, 10 Apr 2017 16:49:31 +0300
Message-ID: <20170410134931.GC1918@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
        kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

January is month 1.  There is no zero-th month.  We don't care very much
if the days are invalid but for months, we use it to read from an array
so this bug means we read one space before the start of the
total_days_of_prev_months[] array.

Fixes: 1bd5bbcb6531 ("[CIFS] Legacy time handling for Win9x and OS/2 part 1")
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index abae6dd2c6b9..f1f64a15215a 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -980,8 +980,10 @@ struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 		cifs_dbg(VFS, "illegal hours %d\n", st->Hours);
 	days = sd->Day;
 	month = sd->Month;
-	if ((days > 31) || (month > 12)) {
+	if (days > 31 || month < 1 || month > 12) {
 		cifs_dbg(VFS, "illegal date, month %d day: %d\n", month, days);
+		if (month < 1)
+			month = 1;
 		if (month > 12)
 			month = 12;
 	}
