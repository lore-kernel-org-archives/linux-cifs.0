From: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Subject: Re: Issue with upgrade to kernel 3.4.10 -> invalid argument error
Date: Wed, 17 Oct 2012 15:47:50 +0200
Message-ID: <507EB706.8040406@innominate.com>
References: <507D934E.9010304@innominate.com> <507E808C.1020401@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030608080301000303020602"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <507E808C.1020401-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030608080301000303020602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear Suresh,


I took a look at the patch that you mention, but *no*, it does not 
address the issue that I mention. The new code still does not convert 
all slashes to backslashes in the UNC field (i.e. the UNC given 
explicitly as in the unc= option.) Thus, it is still possible to get an 
"invalid parameter" error if you provide the UNC with slashes in it:

mount.cifs //myserver/share /mnt/point -o unc=//myserver/share

This will result in an error, since the unc option contains slashes and 
is converted as follows:

\\myserver/share

Thus causing an error within the extract_hostname function in connect.c.

Please take a look at the attached patch, which corrects this issue and 
let me know what you think. :-)


Thanks and regards

Fred


On 10/17/2012 11:55 AM, Suresh Jayaraman wrote:
> On 10/16/2012 10:33 PM, Federico Sauter wrote:
>> Greetings,
>>
>>
>> I am having an issue mounting CIFS shares since we upgraded our Linux
>> kernel from 2.6.27 to 3.4.10. Each time I try to mount a share drive I
>> get an "Invalid argument" error message even though I am using the same
>> command line that had previously worked, e.g.:
>>
>
> A quick look suggests that the symptom is similar to the one fixed by
> the below commit
>
> commit e73f843a3235a19de38359c91586e9eadef12238
> Author: Suresh Jayaraman<sjayaraman-IBi9RG/b67k@public.gmane.org>
> Date:   Tue Jun 12 07:15:50 2012 +0530
>
>      cifs: fix parsing of password mount option
>
>
> It might be worth trying to see whether the commit fixes the problem you
> are seeing.
>
>
> Thanks
> Suresh
>
>
>

--------------030608080301000303020602
Content-Type: text/x-patch;
 name="connect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="connect.patch"

--- fs/cifs/connect.c.stable	2012-10-16 16:44:50.000000000 +0200
+++ fs/cifs/connect.c.fixed	2012-10-16 18:56:37.000000000 +0200
@@ -1204,6 +1204,7 @@
 	char *string = NULL;
 	char *tmp_end, *value;
 	char delim;
+	char *p, *q;
 
 	separator[0] = ',';
 	separator[1] = 0;
@@ -1662,12 +1663,12 @@
 				printk(KERN_WARNING "CIFS: no memory for UNC\n");
 				goto cifs_parse_mount_err;
 			}
-			strcpy(vol->UNC, string);
 
-			if (strncmp(string, "//", 2) == 0) {
-				vol->UNC[0] = '\\';
-				vol->UNC[1] = '\\';
-			} else if (strncmp(string, "\\\\", 2) != 0) {
+			for (p = string, q = vol->UNC; *p; ++p, ++q) {
+				*q = *p == '/'? '\\' : *p;
+			}
+			*q = '\0';
+			if (strncmp(vol->UNC, "\\\\", 2) != 0) {
 				printk(KERN_WARNING "CIFS: UNC Path does not "
 						    "begin with // or \\\\\n");
 				goto cifs_parse_mount_err;

--------------030608080301000303020602--
