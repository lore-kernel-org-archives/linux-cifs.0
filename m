From: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Subject: Issue with upgrade to kernel 3.4.10 -> invalid argument error
Date: Tue, 16 Oct 2012 19:03:10 +0200
Message-ID: <507D934E.9010304@innominate.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060105070606020708050909"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060105070606020708050909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Greetings,


I am having an issue mounting CIFS shares since we upgraded our Linux 
kernel from 2.6.27 to 3.4.10. Each time I try to mount a share drive I 
get an "Invalid argument" error message even though I am using the same 
command line that had previously worked, e.g.:

mount -t cifs //172.16.1.10/allusers /mnt/TEST -o 
'ro,user=cifs,password=secret

I went ahead and checked the source code, and found out that the 
following condition did not evaluate to true:

fs/cifs/connect.c:2130
	if (volume_info->UNCip && volume_info->UNC)
	{
         	rc = cifs_fill_sockaddr((struct sockaddr *)&addr,
                 	    volume_info->UNCip,
	                    strlen(volume_info->UNCip),
         	            volume_info->port);

Thus I obtained a kernel message "Connecting to DFS root not implemented 
yet." So I am now explicitly specifying the UNC as an option, as well as 
the device name:

mount -t cifs //172.16.1.10/allusers /mnt/TEST -o 
'ro,user=cifs,password=secret,unc=\\172.16.1.10\allusers'

Question #1: Why do I have to explicitly provide the UNC now?

It almost seem like a bug to me, given that the devname parameter to the 
cifs_parse_mount_options function already contains this information. The 
newest sources for the 3.7-rc1 kernel seem to have no changes in this 
regard (even though I just took a *quick* look at those sources.)

If this is a bug I would be glad to provide a patch to fix it.

The second observation that I made concerned specifying the UNC as an 
option and passing in slashes as separators instead of backslashes:

mount -t cifs //172.16.1.10/allusers /mnt/TEST -o 
'ro,user=cifs,password=secret,unc=//172.16.1.10/allusers'

This also results in an invalid argument error, as the parser does not 
convert all slashes into backslashes (for the unc option, as the devname 
parameter is already converted!), and thus extract_hostname is not able 
to function properly.

Question #2: Should this be considered a bug?

If that is the case, I would like to suggest the attached bugfix.

Please let me know what you think and thank you in advance for your kind 
support!


Best regards,


-- 
Federico Sauter / Senior firmware programmer
Innominate Security Technologies AG / protecting industrial networks
tel: +49.30.921028-210 / fax: +49.30.921028-020
Rudower Chaussee 13 / D-12489 Berlin / http://www.innominate.com/

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Christoph Leifer

--------------060105070606020708050909
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

--------------060105070606020708050909--
