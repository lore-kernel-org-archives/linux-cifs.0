From: Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org>
Subject: Share mounts in SMBv1 mode, but fails to mount in SMBv2 mode
Date: Mon, 16 Oct 2017 09:59:18 +0200
Message-ID: <144390dd-e0fc-ae98-a645-5972f11d635d@lal.in2p3.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dear CIFS VFS maintainers,

At work, I'm currently mounting our CIFS shares in SMBv1 mode, and it 
works perfectly. But for security reasons, our friendly sysadmins would 
like to drop support for that protocol version in the medium term. So 
I'm trying to mount our network shares in SMBv2 mode instead, which 
hopefully should have just been a matter of adjusting the fstab.

Unfortunately, the mount fails instead, in a way that someone who is not 
a CIFS/kernel specialist cannot easily understand. Can you help me 
figure out what is going on, and hopefully fix this?

hadrien@linux-2ak3:~> uname -r
4.13.5-1-default
hadrien@linux-2ak3:~> /sbin/mount.cifs -V
mount.cifs version: 6.5
hadrien@linux-2ak3:~> sudo mount -v -t cifs //nfsserv22/expsi test -o credentials=<path to credentials file>,vers=2.0
domain=LAL
mount.cifs kernel mount options: ip=134.158.91.155,unc=\\nfsserv22\expsi,vers=2.0,user=grasland,,domain=LAL,pass=********
mount error(95): Operation not supported
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
hadrien@linux-2ak3:~> dmesg | tail
(...)
[ 1553.195516] Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
[ 1553.227109] Status code returned 0xc0000225 STATUS_NOT_FOUND
[ 1553.227118] CIFS VFS: ioctl error in smb2_get_dfs_refer rc=-2
[ 1553.240200] Status code returned 0xc00000bb STATUS_NOT_SUPPORTED
[ 1553.246179] Status code returned 0xc00000bb STATUS_NOT_SUPPORTED
[ 1553.246824] CIFS VFS: cifs_read_super: get root inode failed

I can also provide a wireshark capture of the client-server traffic or 
ask for details of server configuration if you need that. For the later, 
please keep in mind that I'm a total CIFS newbie and be specific about 
what you want to know.

Cheers,
Hadrien Gasaldn
