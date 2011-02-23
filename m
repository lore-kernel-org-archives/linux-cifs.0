From: "Heinrich Mislik" <Heinrich.Mislik-4JhlDu4IDl0juwv8T7myQQ@public.gmane.org>
Subject: Mounting DFS
Date: Wed, 23 Feb 2011 18:03:19 +0100
Message-ID: <4D654BE7.11698.1C98C6C7@Heinrich.Mislik.univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-description: Mail message body
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I want to know the current status of support for mounting DFS shares. 
I found this posting:

http://marc.info/?l=linux-cifs-client&m=123357912319175&w=2

which at the end says:

> Problem 1 is almost solved, I just need some time to cleanup
> patches I've written.

I think, that my problem is related. Here is, what I tried:

On a samba server I have two shares:

[dfs]
   msdfs root = yes
# symlink exists: /home/dfs/share1 -> msdfs://otherserver/someshare
   path = /home/dfs
[share2]
   msdfs root = yes
   msdfs proxy = \otherserver\someshare

Both Windows and smbclient can access these shares without Problems.

After configuring /etc/request-key.conf I can mount with 

mount -t cifs //someserver/dfs/share1 -ouser=someuser /mnt

I can see the files of //otherserver/someshare under /mnt as 
expected.

But Mounting with 

mount -t cifs //someserver/share2 -ouser=someuser /mnt

I get

retrying with upper case share name
mount error(6): No such device or address
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

The mounts were tried on:

/proc/version

Linux version 2.6.32-71.14.1.el6.x86_64 (mockbuild@ls20-bc2-
14.build.redhat.com) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) 
(GCC) ) #1 SMP Wed Jan 5 17:01:01 EST 2011

Thanks for any help

Cheers

Heinrich
-- 
Heinrich Mislik
Zentraler Informatikdienst der Universitaet Wien
A-1010 Wien, Universitaetsstrasse 7
Tel.: (+43 1) 4277-14056, Fax: (+43 1) 4277-9140
