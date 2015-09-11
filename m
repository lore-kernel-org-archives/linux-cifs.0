From: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Two inodes with the same inode number
Date: Fri, 11 Sep 2015 10:02:32 +0100
Message-ID: <55F298A8.3020509@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have a setup with two hosts, A and B, both using a CIFS SMB 3.0 mount 
where the following operations take place (using 4.1 kernels):

A                  B
open X
close X
                    mv X Y
                    touch X
open X
open Y

After this, host A will have two dentries pointing to the same inode (or 
at least with the same inode number), which results in some 
'interesting' behavior.

I've seen at least two failure modes:
1) Above, both open calls will try to use the same lease key, causing 
the server to fail the second open with STATUS_INVALID_PARAMETER. (the 
server was Windows Server 2012 R2)

2) The reported file size will be different depending on which filename 
was last used to refresh the inode attributes.


Although cifs_d_revalidate updates attributes such as the file size, it 
doesn't ever update the inode number. I tried making it return 0 to drop 
the cached inode if the inode number had changed but even still, opens 
failed occasionally with STATUS_INVALID_PARAMETER. Is there an alternate 
fix for this?

Thanks,
-- 
Ross Lagerwall
