From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: What are the uid=0 and gid=0 doing?
Date: Thu, 29 Jul 2010 09:28:17 +0200
Message-ID: <AANLkTi=UW31iMuqEX9NRspTBwE4X5_4vr3+LE1-sEPjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I'm working on a construction to offer the user easy access to all
kinds of resources, local like USB sticks, CDroms and harddrives,

Two major apps make that possible, fuse-workspace-ll, a fuse fs to
create userfriendly paths to the resource, and redirect the
user/process to the share mounted by the automounter.

Look for more information on:

http://linux.bononline.nl/linux/mount.md5key.new/

Now looking at how a shar is mounted, I see the following:

//SCLFS20091030/sbon
/mnt/mount.md5key/sbon/mount/601d329b6fd5c9d801e620ed7ac41606 cifs
rw,mand,relatime,unc=\\SCLFS20091030\sbon,username=sbon,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.0.2,posixpaths,setuids,serverino,acl,rsize=16384,wsize=57344
0 0

username=sbon, of course because of the use of a credentials file. But
why are the uid and the gid not set to this value?

Stef
