From: Arturo Puente <arturo.puente-duWF5KbFyrWv22wSYJUg5QC/G2K4zDHf@public.gmane.org>
Subject: [Problem with mount.cifs version 6.3 in Centos 6.5]
Date: Fri, 27 Jun 2014 09:57:07 -0430
Message-ID: <53AD7F3B.3050208@arturo-puente.com>
Reply-To: arturo.puente-duWF5KbFyrWv22wSYJUg5QC/G2K4zDHf@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

  I have a CentOS Release 6.5 (Final) (2.6.32-431.17.1.el6.x86_64) machine.
  I downloaded cifs-utils-6.3.tar.bz2, and did

  1 - #tar -xjvf cifs-utils-6.3.tar.bz2
  2 - #cd cifs-utils-6.3
  3 - #./configure --prefix=/usr
  4 - #make
  5 - #make install
  6 - # mount.cifs -V
      mount.cifs version: 6.3

  After that, I am trying to mount an AZURE Share with

  mount.cifs //storage  /home/data/ -o 
vers=2.1,credentials=credentials-file,dir_mode=0777,file_mode=0777
  with //storage here instead of the true share storage name and
       credentials-file instead of the true location of the credentials 
file,

  And I got the following message

  mount error(112): Host is down
  Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

  In this machine
  #cat /boot/config-2.6.32-431.17.1.el6.x86_64 | grep CIFS

  CONFIG_CIFS=m
  CONFIG_CIFS_STATS=y
  # CONFIG_CIFS_STATS2 is not set
  CONFIG_CIFS_WEAK_PW_HASH=y
  CONFIG_CIFS_UPCALL=y
  CONFIG_CIFS_XATTR=y
  CONFIG_CIFS_POSIX=y
  # CONFIG_CIFS_DEBUG2 is not set
  CONFIG_CIFS_DFS_UPCALL=y
  CONFIG_CIFS_ACL=y
  # CONFIG_CIFS_FSCACHE is not set


  Using a machine with Ubuntu 14.04 LTS (3.13.0-29-generic) that has 
preloaded cifs
  # mount.cifs -V
  mount.cifs version: 6.0

  Using the same command to mount the share, I didn't get the error message
  and the share is mounted without any trouble.

  In this machine
  # cat /boot/config-3.13.0-29-generic | grep CIFS

  CONFIG_CIFS=m
  CONFIG_CIFS_STATS=y
  # CONFIG_CIFS_STATS2 is not set
  CONFIG_CIFS_WEAK_PW_HASH=y
  CONFIG_CIFS_UPCALL=y
  CONFIG_CIFS_XATTR=y
  CONFIG_CIFS_POSIX=y
  # CONFIG_CIFS_DEBUG2 is not set
  CONFIG_CIFS_DFS_UPCALL=y
  CONFIG_CIFS_ACL=y
  CONFIG_CIFS_FSCACHE=y
  CONFIG_CIFS_DEBUG=y
  CONFIG_CIFS_SMB2=y

  Both machines are inside the same pool of virtual machines for my 
account inside Azure

  Does anyone knows why I am getting the message

  mount error(112): Host is down

  In the machine with CentOS 6.5.?

  Thank you in advance for your Help with this matter.

  Arturo Puente
