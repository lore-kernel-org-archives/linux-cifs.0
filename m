From: Robin <beanow-1RVBLsOYap9hl2p70BpVqQ@public.gmane.org>
Subject: [4.13] Bad error message, old SMB protocol host.
Date: Tue, 15 Aug 2017 11:11:38 +0200
Message-ID: <d236d2ff-da83-efce-51a3-d480e140ecf2@oscp.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When trying to mount an older SMB host share, the errors cifs produces 
are very cryptic. Such as
CIFS VFS: cifs_mount failed w/return code = -112

Or
mount: mount //192.168.1.123/path/ on /mnt/path failed: Host is down

I reported this issue as a regression at first.
https://bugzilla.kernel.org/show_bug.cgi?id=196599
Thinking that cifs was just plain broken in this kernel as gvfs mounted 
the same share just fine.

Can this protocol mismatch scenario have it's own, more informative 
error message?
As this will likely effect more people when this change reaches the bulk 
of users.
