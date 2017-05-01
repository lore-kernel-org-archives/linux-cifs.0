From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v3] cifs: small underflow in cnvrtDosUnixTm()
Date: Mon, 1 May 2017 21:43:43 +0300
Message-ID: <20170501184343.lkkv43vzwsyrty3d@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
To: Steve French <sfrench@samba.org>, walter harms <wharms@bfs.de>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

January is month 1.  There is no zero-th month.  If someone passes a
zero month then it means we read from one space before the start of the
total_days_of_prev_months[] array.

We may as well also be strict about days as well.

Fixes: 1bd5bbcb6531 ("[CIFS] Legacy time handling for Win9x and OS/2 part 1") 
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: be stricter about days.
v3: style cleanup.

Being stricter about days is slightly riskier than simply preventing the
out ouf bounds array access.  Please review carefully, etc.


diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index abae6dd2c6b9..cc88f4f0325e 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -980,10 +980,10 @@ struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 		cifs_dbg(VFS, "illegal hours %d\n", st->Hours);
 	days = sd->Day;
 	month = sd->Month;
-	if ((days > 31) || (month > 12)) {
+	if (days < 1 || days > 31 || month < 1 || month > 12) {
 		cifs_dbg(VFS, "illegal date, month %d day: %d\n", month, days);
-		if (month > 12)
-			month = 12;
+		days = clamp(days, 1, 31);
+		month = clamp(month, 1, 12);
 	}
 	month -= 1;
 	days += total_days_of_prev_months[month];
