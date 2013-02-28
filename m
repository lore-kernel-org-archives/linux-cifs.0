From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Unable to mount.cifs with 3.x kernels
Date: Thu, 28 Feb 2013 07:06:55 -0800
Message-ID: <20130228070655.3051abf1@corrin.poochiereds.net>
References: <CAGZ55DQMYUyiSrPodWtfzRFne1qSC+SJn4A2yw6kx6xV-d0jxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: Johann Spies <johann.spies-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGZ55DQMYUyiSrPodWtfzRFne1qSC+SJn4A2yw6kx6xV-d0jxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Feb 2013 09:49:09 +0200
Johann Spies <johann.spies-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> When using a 2.6.38 kernel on Debian I can mount a Windows share with
> the following in my /etc/fstab:
> 
> //stbstaff.stb.sun.ac.za/dept/let/senis /home/js/mnt/senis cifs
> credentials=/etc/credentials,domain=stb,user,uid=1000,gid=1000 0     0
> 
> and the command 'mount /home/js/mnt/senis/'
> 
> But with  3.x kernels (I have a 3.8 self-compiled kernel from Ubuntu sources at
> the moment) I get this:
> 
> mount error(13): Permission denied
> 
> Is that a bug?
> 
> Here is some of the debug information for trying to mount with the 3.x kernel:
> 

-------------------[snip]------------------

> [ 6859.860011] fs/cifs/inode.c: looking for uniqueid=110
> [ 6859.860021] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 110
> [ 6859.860023] fs/cifs/inode.c: cifs_revalidate_cache: inode 110 is new
> [ 6859.860026] fs/cifs/cifsfs.c: Get root dentry for \let\senis
> [ 6859.860030] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 11 with uid: 0
> [ 6859.860032] fs/cifs/dir.c: parent inode = 0xffff880190f40078 name
> is: let and dentry = 0xffff88013fc83d80
> [ 6859.860033] fs/cifs/dir.c: NULL inode in lookup
> [ 6859.860035] fs/cifs/dir.c: Full path: \let inode = 0x          (null)
> [ 6859.860036] fs/cifs/inode.c: Getting info on \let
> [ 6859.860039] fs/cifs/transport.c: For smb_command 50
> [ 6859.860040] fs/cifs/transport.c: Sending smb: smb_len=82
> [ 6859.860291] fs/cifs/connect.c: RFC1002 header 0x23
> [ 6859.860298] fs/cifs/smb1ops.c: invalid transact2 word count
> [ 6859.860307] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=12 state=4
> [ 6859.860312] Status code returned 0xc0000022 NT_STATUS_ACCESS_DENIED
> [ 6859.860317] fs/cifs/netmisc.c: Mapping smb error code 0xc0000022 to
> POSIX err -13

-------------------[snip]------------------

The user you're connecting as doesn't have access to do a lookup on
"/let" at the top level of the share. When the superblock sharing
patches went in a year or two ago, the client started trying to walk
down from the root of the share to the mount root. If you don't have
access to some point in the middle then the mount fails.

This is currently still broken. The only workaround is to allow these
users access on the intermediate directories. I think read access is
sufficient, but I don't recall the specifics.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
