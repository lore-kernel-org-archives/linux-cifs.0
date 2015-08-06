From: "L. A. Walsh" <linux-cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Subject: permissions on win-symlinks?
Date: Thu, 06 Aug 2015 13:00:20 -0700
Message-ID: <55C3BCD4.1030507@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I noticed that most of the symlinks I see through cifs
now work (providing it is a "follow-able" path).


 56K -rwxr-xr-x 1  53K Dec  4  2011 Cygwin-Terminal.ico*
 512 -rwxr-xr-x 1   51 Dec 10  2009 Cygwin.bat*
156K -rwxr-xr-x 1 154K Dec  4  2011 Cygwin.ico*
   0 l--------- 1    0 Jul 16  2013 D -> /??/UNC/Ishtar/Documents/
   0 l--------- 1    0 Feb 28 16:38 M -> /??/UNC/Bliss/Music/
   0 l--------- 1    0 Feb 28 16:10 P -> /??/UNC/Bliss/Pictures/
   0 drwxr-xr-x 2    0 Sep 18  2014 PortableApps/
   0 drwxr-xr-x 2    0 Aug  5 17:49 Program Files/
   0 drwxr-xr-x 2    0 Aug  5 17:58 Program Files (x86)/
   0 drwxr-xr-x 2    0 Jul 31 12:40 ProgramData/
   0 drwxr-xr-x 2    0 Aug 28  2013 Python27/
   0 drwxr-xr-x 2    0 Feb  5 20:36 Recovery/
   0 drwxr-xr-x 2    0 Jul 15 19:39 Recycled/
   0 l--------- 1    0 Mar 28  2013 Share -> /??/UNC/Bliss/Share/
   0 drwxr-xr-x 2    0 Jun  2 19:17 Users/
   0 drwxr-xr-x 2    0 Aug  4 23:12 Windows/
   0 l--------- 1    0 Mar 21  2014 bin -> 
/??/C:/windows/system32/cygwin/bin/
 512 -rwxr-xr-x 1   27 Apr 19  2011 boot*
   0 drwxr-xr-x 2    0 Jul  2  2010 boot.d/
 512 -rwxr-xr-x 1   90 Apr 19  2011 boot.ini*
   0 drwxr-xr-x 2    0 Apr 27 12:31 cygwin/
   0 drwxr-xr-x 2    0 May 14 19:01 cygwin64/
   0 drwxr-xr-x 2    0 May 14 06:08 dev/
   0 l--------- 1    0 Feb 28 15:34 etc -> 
/??/C:/Windows/System32/cygwin/etc/
204K -rwxr-xr-x 1 204K Feb 17  2009 grldr*
   0 l--------- 1    0 Mar  5 14:32 lib -> 
/??/C:/Windows/System32/cygwin/lib/
   0 drwxr-xr-x 2    0 Jun 21 02:51 oemfiles/
   0 l--------- 1    0 May 14 07:15 opt -> 
/??/C:/Windows/System32/cygwin/opt/
 96G -rwxr-xr-x 1  96G Aug  5 23:58 pagefile.sys*
   0 drwxr-xr-x 2    0 Jan 23  2014 proc/
   0 l--------- 1    0 Apr 21  2013 prog64 -> Program Files/
   0 l--------- 1    0 Mar  5 14:33 sbin -> 
/??/C:/Windows/System32/cygwin/sbin/
   0 l--------- 1    0 Jan 12  2014 temp -> tmp/
   0 drwxr-xr-x 2    0 Aug  6 12:29 tmp/
   0 l--------- 1    0 Mar  5 14:35 usr -> 
/??/C:/Windows/System32/cygwin/usr/
   0 l--------- 1    0 Mar  5 14:35 var -> 
/??/C:/Windows/System32/cygwin/var/
   0 drwxr-xr-x 2    0 Aug 28  2013 windowsearch/
----

my fstab looks like (working entry first, fails commented out afterwards:

//Athenae/C/  /athenae/ cifs  
user,noauto,rw,uid=law,gid=Administrators,nocase,serverino,credentials=/home/law/.ssh/athenae,setuids,noauto 
0 0
tried: 
  (tried multiuser but didn't make progress -- never saw any auths 
requests to the server either...now sure what I did wrong...(?))

#//BLISS/ATHENAE/C$/  /athenae/ cifs  
user,noauto,rw,netbiosname=Athenae,domain=BLISS,username=Bliss/law,sfu,multiuser,nocase,serverino,setuids,noauto 
0 0

Wanted to setup a script on my end to answer multi-user ID 
requiests...but that
didn't seem to work sell either (I can mount, but all files are owned by 
root.root where I don't have access to most).

Any ideas?

BTW -- I thought the resolving of the symlinks to be 'cool'....
