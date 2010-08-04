From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Subject: [PATCH] mount.cifs: remove redundant error assignment
Date: Wed, 04 Aug 2010 16:55:50 +0530
Message-ID: <4C594E3E.2000903@suse.de>
References: <4C591054.1070007@suse.de> <20100804065338.6fa9d16b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100804065338.6fa9d16b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/04/2010 04:23 PM, Jeff Layton wrote:
> On Wed, 04 Aug 2010 12:31:40 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> 
>> @@ -1521,7 +1520,6 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
>>  	if (!pmntfile) {
>>  		fprintf(stderr, "could not update mount table\n");
>>  		unlock_mtab();
>> -		rc = EX_FILEIO;
>>  		goto add_mtab_exit;
>>  	}
> 		^^^^^^^^^^^
> This looks wrong. If we don't set rc here, then it'll still be 0 and
> the code at add_mtab_exit won't set it to EX_FILEIO.
> 

My bad.. I guess it's due to the effect of working with multiple code versions..

Here's another version which is slightly different.. 


From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] mount.cifs: remove redundant error assignment

Avoid setting error code twice by moving error handling out of add_mtab_exit
block. We already set error code and report error in other places.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 mount.cifs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 9f04261..3623e76 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1554,16 +1554,16 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
 	mountent.mnt_freq = 0;
 	mountent.mnt_passno = 0;
 	rc = addmntent(pmntfile, &mountent);
+	if (rc) {
+		fprintf(stderr, "unable to add mount entry to mtab\n");
+		rc = EX_FILEIO;
+	}
 	endmntent(pmntfile);
 	unlock_mtab();
 	SAFE_FREE(mountent.mnt_opts);
 add_mtab_exit:
 	toggle_dac_capability(1, 0);
 	sigprocmask(SIG_SETMASK, &oldmask, NULL);
-	if (rc) {
-		fprintf(stderr, "unable to add mount entry to mtab\n");
-		rc = EX_FILEIO;
-	}
 
 	return rc;
 }
