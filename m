From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Intermittent issue accessing shares (0xc0000034
 NT_STATUS_OBJECT_NAME_NOT_FOUND)
Date: Fri, 2 Jan 2015 17:45:58 -0500
Message-ID: <20150102174558.2972221a@tlielax.poochiereds.net>
References: <5CD28AE9-6FE9-47AA-8812-80D8264DAF83@visageimaging.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Malte Westerhoff <MWesterhoff-b1n3U3u3AEZwaa3ho+uhNwC/G2K4zDHf@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5CD28AE9-6FE9-47AA-8812-80D8264DAF83-b1n3U3u3AEZwaa3ho+uhNwC/G2K4zDHf@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2 Jan 2015 15:39:32 +0000
Malte Westerhoff <MWesterhoff-b1n3U3u3AEZwaa3ho+uhNwC/G2K4zDHf@public.gmane.org> wrote:

> Hi,
> I hope that this is the right list to post this to. Apologies if not ___ but 
> any hints would be appreciated.
> 
> We are seeing intermittent issues accessing shares that are exported by a 
> Windows 2008R2 server and mounted on a Linux client OpenSuse 13.1 (kernel 
> 3.11.10-21-desktop, samba-client-4.1.11-3.26.1.x86_64).
> The application level symptom is that files can neither be read nor 
> written on a particular share. We have set cifsFYI=3 and we see a 
> NT_STATUS_OBJECT_NAME_NOT_FOUND
> in /var/log/messages when it happens (excerpt below).
> Normally the issue self-repairs within one minute.
> We have six linux clients accessing the same windows server ___ and when one 
> of them has the issue, the others do not ___ so it looks like a client-side 
> issue.
> We are seeing this issue in two separate data centers (with identical 
> server configuration), so it is not likely to be hardware or network.
> The server exports approx 20 shares ___ and typically only one of them is 
> affected at a time (but not always the same one).
> The network connection is a local 10GBit Ethernet connection.
> Across six clients, accessing ~20 shares (each), the issue occurs 
> approximately 2-5 times per 24 hours (total across all servers and 
> shares). 
> The shares are mounted using autofs, but we have seen the same issue with 
> static mounts.
> 
> Here is the output of mount for one of them:
> //10.168.172.51/ImageRootFolder1 on /Storage/WINSERVER001/ImageRootFolder1 
> type cifs 
> (rw,relatime,vers=1.0,cache=strict,username=xxx_username,domain=10.168.172.
> 51,uid=50000,forceuid,gid=100,forcegid,addr=10.168.172.51,file_mode=0755,di
> r_mode=0770,nounix,serverino,rsize=61440,wsize=65536,actimeo=1)
> 
> We have added test code where the clients attempt to write and then read a 
> test file onto each of the shares once per minute. If that fails the 
> clients retry 20 times with 100ms pause. We found that if this fails,
>  it continues to fail all 20 times.
> 
> Below is /var/log/messages for two such failed attempts (file 
> WRITE_0422.TEST)  when the problem occurred:
> 
> 
> 2015-01-02T03:20:09.125669-08:00 linclnt003 kernel: [2649336.134098] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : name: \WRITE_0422.TEST
> 2015-01-02T03:20:09.125671-08:00 linclnt003 kernel: [2649336.134107] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/trans
> port.c: For smb_command
>  6
> 2015-01-02T03:20:09.125672-08:00 linclnt003 kernel: [2649336.134110] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/trans
> port.c: Sending
>  smb: smb_len=72
> 2015-01-02T03:20:09.317001-08:00 linclnt003 kernel: [2649336.325820] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/conne
> ct.c: RFC1002
>  header 0x23
> 2015-01-02T03:20:09.317020-08:00 linclnt003 kernel: [2649336.325830] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/misc.
> c: checkSMB Length:
>  0x27, smb_buf_length: 0x23
> 2015-01-02T03:20:09.317024-08:00 linclnt003 kernel: [2649336.325880] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/trans
> port.c: cifs_sync_mid_result:
>  cmd=6 mid=50171 state=4

cmd 6 is SMB_COM_DELETE -- we're removing a file here.

> 2015-01-02T03:20:09.317025-08:00 linclnt003 kernel: [2649336.325889] 
> Status code returned 0xc0000034 NT_STATUS_OBJECT_NAME_NOT_FOUND

That error is being returned by the server. It's basically equivalent
to a -ENOENT in POSIX terms (which is why we translate it that way).
What may be best is to get some captures and look for these errors, and
see whether you can determine why they're being returned:

    https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Wire_Captures

Can you ascertain whether the file is _actually_ present at the time
that this occurs? Could another client is competing with this one to
remove files? Perhaps the server is just insane and is returning that
error when the file really exists? Maybe the client is sending bad
filenames for some reason?

There are tons of possibilities. You'll probably need to do some
investigative work to determine the root cause.


> 2015-01-02T03:20:09.317026-08:00 linclnt003 kernel: [2649336.325895] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/netmi
> sc.c: Mapping
>  smb error code 0xc0000034 to POSIX err -2
> 2015-01-02T03:20:09.317028-08:00 linclnt003 kernel: [2649336.325900] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/cifss
> mb.c: Error in
>  RMFile = -2
> 2015-01-02T03:20:09.317029-08:00 linclnt003 kernel: [2649336.325905] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/inode
> .c: CIFS VFS:
>  leaving cifs_unlink (xid = 1254639) rc = -2
> 2015-01-02T03:20:09.417642-08:00 linclnt003 kernel: [2649336.426227] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : CIFS VFS: in
>  cifs_lookup as Xid: 1254640 with uid: 50000
> 2015-01-02T03:20:09.417660-08:00 linclnt003 kernel: [2649336.426234] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : parent inode
>  = 0xffff881fdf56fb80 name is: WRITE_0422.TEST and dentry = 
> 0xffff881faa406600
> 2015-01-02T03:20:09.417662-08:00 linclnt003 kernel: [2649336.426239] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : name: \WRITE_0422.TEST
> 2015-01-02T03:20:09.417664-08:00 linclnt003 kernel: [2649336.426242] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : NULL inode
>  in lookup
> 2015-01-02T03:20:09.417665-08:00 linclnt003 kernel: [2649336.426244] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : Full path:
>  \WRITE_0422.TEST inode = 0x          (null)
> 2015-01-02T03:20:09.417666-08:00 linclnt003 kernel: [2649336.426247] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/inode
> .c: Getting info
>  on \WRITE_0422.TEST
> 2015-01-02T03:20:09.417668-08:00 linclnt003 kernel: [2649336.426254] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/trans
> port.c: For smb_command
>  50
> 2015-01-02T03:20:09.417669-08:00 linclnt003 kernel: [2649336.426257] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/trans
> port.c: Sending
>  smb: smb_len=106
> 2015-01-02T03:20:09.417670-08:00 linclnt003 kernel: [2649336.426683] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/conne
> ct.c: RFC1002
>  header 0x23
> 2015-01-02T03:20:09.417678-08:00 linclnt003 kernel: [2649336.426705] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/misc.
> c: checkSMB Length:
>  0x27, smb_buf_length: 0x23
> 2015-01-02T03:20:09.417680-08:00 linclnt003 kernel: [2649336.426709] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/smb1o
> ps.c: invalid
>  transact2 word count
> 2015-01-02T03:20:09.418654-08:00 linclnt003 kernel: [2649336.426760] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/trans
> port.c: cifs_sync_mid_result:
>  cmd=50 mid=50172 state=4
> 2015-01-02T03:20:09.418673-08:00 linclnt003 kernel: [2649336.426768] 
> Status code returned 0xc0000034 NT_STATUS_OBJECT_NAME_NOT_FOUND
> 2015-01-02T03:20:09.418675-08:00 linclnt003 kernel: [2649336.426773] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/netmi
> sc.c: Mapping
>  smb error code 0xc0000034 to POSIX err -2
> 2015-01-02T03:20:09.418677-08:00 linclnt003 kernel: [2649336.426778] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/cifss
> mb.c: Send error
>  in QPathInfo = -2
> 2015-01-02T03:20:09.418678-08:00 linclnt003 kernel: [2649336.426785] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : CIFS VFS: leaving
>  cifs_lookup (xid = 1254640) rc = 0
> 2015-01-02T03:20:09.518641-08:00 linclnt003 kernel: [2649336.527067] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : CIFS VFS: in
>  cifs_lookup as Xid: 1254641 with uid: 50000
> 2015-01-02T03:20:09.518658-08:00 linclnt003 kernel: [2649336.527073] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : parent inode
>  = 0xffff881fdf56fb80 name is: WRITE_0422.TEST and dentry = 
> 0xffff881ee12f5c00
> 2015-01-02T03:20:09.518660-08:00 linclnt003 kernel: [2649336.527078] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : name: \WRITE_0422.TEST
> 2015-01-02T03:20:09.518662-08:00 linclnt003 kernel: [2649336.527080] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : NULL inode
>  in lookup
> 2015-01-02T03:20:09.518664-08:00 linclnt003 kernel: [2649336.527083] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/dir.c
> : Full path:
>  \WRITE_0422.TEST inode = 0x          (null)
> 2015-01-02T03:20:09.518665-08:00 linclnt003 kernel: [2649336.527085] 
> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/cifs/inode
> .c: Getting info
>  on \WRITE_0422.TEST
> 
> 
> The respective section of cifs/DebugData is this:
> 
> Display Internal CIFS Data Structures for Debugging
> ---------------------------------------------------
> CIFS Version 2.01
> Features: dfs fscache lanman posix spnego xattr acl
> Active VFS Requests: 0
> Servers:
> 1) entry for 172.16.107.135 not fully displayed
>         TCP status: 1
>         Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0 In Send: 0 In 
> MaxReq Wait: 0
>         Shares:
>         1) \\172.16.107.135\FileInterface Mounts: 1 Type: NTFS DevInfo: 
> 0x20 Attributes: 0xc500ef
>         PathComponentMax: 255 Status: 0x1 type: DISK
> 
> ___
>         11) \\172.16.107.135\ImageRoot1 Mounts: 1 Type: NTFS DevInfo: 0x20 
> Attributes: 0xc500ff
>         PathComponentMax: 255 Status: 0x1 type: DISK
> 
> ___
> (share 11 is the the one having the error this time).
> 
> 
> Thanks
> Malte
> 
> 
> N_____r__y____b_X____v_^_)__{.n_+____{_r'__{ay_
_____,j__f___h___z_
_w___
___j:+v___w_j_m________zZ+_______j"__!

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
