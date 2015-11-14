From: edward torvalds <ltorvalds024-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: systemd options used to mount a CIFS samba share on boot are not
 allowing to mount share manually after boot
Date: Sat, 14 Nov 2015 18:18:25 +0530
Message-ID: <1447505305.9097.7.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

BUG REPORT:
I am using following lines in /etc/fstab file to mount a samba shared
(CIFS) folder on boot:


//192.168.2.3/Seagates /home/edward/samba/raspberry cifs 
user,noauto,x-systemd.automount,x-systemd.device
-timeout=10s,nofail,uid=1000,gid=1000,credentials=/home/edward/.smbcred
entials,iocharset=utf8,sec=ntlm
 0 0


Note, I am using noauto,x-systemd.automount,x-systemd.device
-timeout=10s without which mounting does not happen during boot.

Sometimes the computer that shares folder is turned off. When that 
computer is turned on later, I mount the folder manually by clicking
the folder icon in nautilus. With above lines in /etc/fstab file, on
manual mounting I get this error: screenshot on imgur(
http://i.imgur.com/HVranvJ.png) which is mount error(22): Invalid
arguments.

from journalctl:


Nov 14 00:33:30 flippingbits systemd[1]: home-edward-samba
-raspberry.mount: Unit entered failed state.

Nov 14 00:33:33 flippingbits kernel: CIFS: Unknown mount option "x
-systemd.automount"


"I mean the same option that helps mounting on boot gives error while
mouting after boot"

The manual mounting happens by non-root user if I remove systemd
specific options: noauto,x-systemd.automount,x-systemd.device
-timeout=10s or by removing user option which prevents me from mounting
saying that only root users can mount.

System details:

1. systemd 225

2. Ubuntu 15.10

3. samba --version 4.1.17-Ubuntu

4. Output(http://sprunge.us/LXHQ) of systemd-analyze blame on my
computer

5. Output(http://sprunge.us/EOLZ) of systemctl status smbd.service

6. Output(http://sprunge.us/PYaK) of systemctl status nmbd.service

7. mount.cifs version: 6.4

(please tell me if you need more information on this)
  
-- 
edward torvalds <ltorvalds024-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
