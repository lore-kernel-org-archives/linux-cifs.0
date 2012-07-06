From: Casey Yeager <casey-AWiv9L5iBJJF6kxbq+BtvQ@public.gmane.org>
Subject: Creating new files on CIFS mount ignores fmask/file_mode
Date: Thu, 05 Jul 2012 20:18:32 -0500
Message-ID: <4FF63CE8.3040403@yeagerweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

After switching from smbfs mount, the dmask/dir_mode and fmask/file_mode 
no longer have an effect on the newly created files. It seems to use the 
system umask instead. Is there a way to have cifs mount create files 
with permissions like smbfs does?

--------- smbfs mount showing new file permissions ---------

root@osiris:~# cat /etc/fstab | grep smbfs
//192.168.1.23/YEAGER /mnt smbfs 
gid=users,fmask=0660,dmask=0770,username=xxxx,password=xxxx 0 0

root@osiris:~# mount /mnt ; cd /mnt/test

root@osiris:/mnt/test# touch test_smbfs ; ls -l test_smbfs
-rw-rw---- 1 root users 0 2012-07-05 18:45 test_smbfs

--------- cifs mount showing new file permissions ---------
(note: substituting fmask for file_mode and dmask for dir_mod has had no 
effect on outcome)

root@osiris:/# cat /etc/fstab | grep cifs
//192.168.1.23/YEAGER /mnt cifs 
gid=users,file_mode=0660,dir_mod=0770,username=xxxx,password=xxxx 0 0

root@osiris:/# mount /mnt ; cd /mnt/test

root@osiris:/mnt/test# touch test_cifs ; ls -l test_cifs
-rw-r--r-- 1 root users 0 2012-07-05 18:47 test_cifs

--------- re-mounting changes to correct permissions ---------

root@osiris:/mnt/test# cd / ; umount /mnt
root@osiris:/# mount /mnt ; cd /mnt/test

root@osiris:/mnt/test# ls -l test_cifs
-rw-rw---- 1 root users 0 2012-07-05 18:47 test_cifs


testing platforms:
RHEL 4 with samba 3.0.33
Slackware 12.1 with samba 3.0.37
