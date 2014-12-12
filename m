From: Franck Eyraud <franck+linux-cifs-ici3nDnK79kZQKRGMNo+Zg@public.gmane.org>
Subject: DFS referrals support ?
Date: Fri, 12 Dec 2014 12:51:49 +0100
Message-ID: <548AD6D5.7080901@nospam.yrnm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

We are meeting some issues with DFS referrals when using CIFS for linux. 
I don't know much about technical details on DFS, but before studying 
further, I would like to know if this feature is even supposed to be 
supported by the Linux CIFS client.

To explain the situation, we have several shares :

\\filer\main(main entry point)
\\filer\share1(scattered volumes with data)
\\filer\share2

if \\filer\main\share1points to \\filer\share1(top level) we manage to 
access the share1 content correctly (so DFS mechanism seems to work)

but if \\filer\main\some\directory\remote\locationpoints to 
\\filer\share2\dir1\dir2\inside\locationhere we get stuck.

The client can have the following behaviours, more or less with no 
apparent logic up to now :
    * "Object is remote" error
    * "No such file or directory" error
    * sometimes locked in infinite loop (with the older versions, see below)
    * accesses it, but lists the content of \\filer\share2(top  level of 
the share) not the content of \\filer\share2\dir1\dir2\inside\locationso 
we loose part of the link's path

With Windows 7 clients, the expected behaviour occurs correctly.

We use up-to-date debian 6.0.10 & 7.6, and CentOS 6.5 (i.e kernels 
2.6.32 & 3.2.x) with stock cifs-utils package (2:4.5-2, 2:5.5-1) and the 
CIFS server is NetApp OnTap 8, with the widelink feature (translation of 
linux symlinks)

If this should be supported, can you provide information of the 
parameters to set correctly, or if we have to compile a newer version, 
which one ?

Thank you,

Franck
