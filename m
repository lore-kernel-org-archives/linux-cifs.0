From: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: 3.4.0-rc2+ - CIFS mount failure
Date: Tue, 10 Apr 2012 08:23:24 +0100
Message-ID: <201204100823.24207.chris2553@googlemail.com>
Reply-To: chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

HI,

I'm testing the latest and greatest from Linus' tree and can't mount partitions 
on a nas server. The mounts work fine with 3.3.1. For the failing kernel, git 
describe gives v3.4-rc2-2-g258f742.

What I see is:

[chris:~]$ sudo mount /media/nas/share
mount error(22): Invalid argument
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

Dmesg shows the message:

CIFS: Unknown mount option "user="

The related entry in /etc/fstab is:

//nas/Share /media/nas/share cifs 
rw,noauto,nosuid,nodev,user,guest,uid=1000,gid=100,file_mode=0666  0 0

Let me know how I can help fix this regression.

Please cc me - I'm not subscribed.

Thanks

Chris
-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
