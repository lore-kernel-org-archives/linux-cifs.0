From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: New kernel, new problems...
Date: Sat, 4 Mar 2017 09:40:10 -0600
Message-ID: <CAH2r5msku6_7kx949eOVCkjs=CBRLdPmmhN=1tMeaiXPrKdGKg@mail.gmail.com>
References: <58BA5F50.5060402@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <58BA5F50.5060402-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> Autodisabling the use of server inode numbers on \\Athenae\C.
> This server doesn't seem to support them properly.
> Hardlinks will not be recognized on this mount. Consider
> mounting with the "noserverino" option to silence this message.

cifs.ko, as a linux file system, needs a unique number in order to identify a
file (inode number).  It is particularly important when you see two files with
different names but with the same inode number (which indicates that
they are hardlinked to each other).   There are three cases where the cifs
client can detect that the server gave out invalid inode numbers (or was
unable to give out inode numbers). Note that inode numbers are called
unique ids in the SMB2/SMB3 protocol).
1) the server returned 0 for the unique id on a file when listing
directory contents
or when querying info on a file
2) the server rejected the SMB2/SMB3 query that asks for the unique id
(inode number)
3) we detect a collision where the server gave out the same unique id
for two files of
different types (e.g. a file and directory on the same mount with the
same unique id)

Not all file system types in Windows support unique ids (although NTFS
does).  Could this
be a FAT filesystem on the server?

On Sat, Mar 4, 2017 at 12:31 AM, L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> wrote:
> Brought up 4.10.1 w/options to help cifs info-dumping
> (with CONFIG_CIFS_DEBUG, CONFIG_CIFS_DEBUG2, CONFIG_DYNAMIC_DEBUG enabled.)
>
> I probably should have tried the old options 1st, but added a
> vers=2.1 to my mount line in /etc/fstab:
>
> //Athenae/C/    /athenae    cifs
> user,noauto,rw,uid=law,gid=Administrators,nocase,serverino,vers=2.1,credentials=/home/law/.ssh/athenae,setuids,noauto
> 0 0
>
> which resulted in a mount line:
>
> //Athenae/C/ on /athenae type cifs
> (rw,nosuid,nodev,noexec,relatime,vers=2.1,sec=ntlmssp,cache=strict,username=law,\
> domain=BLISS,uid=5013,forceuid,gid=544,forcegid,addr=192.168.3.12,file_mode=0755,\
> dir_mode=0755,nocase,nounix,setuids,mapposix,rsize=1048576,wsize=1048576,\
> echo_interval=60,actimeo=1,user)
>
>
> Haven't seen the looping yet, but got some odd messages when I mounted in
> my syslog:
>
> Mar  3 22:12:06 Ishtar kernel: [21527.100384] FS-Cache: Loaded
> Mar  3 22:12:06 Ishtar kernel: [21527.120908] FS-Cache: Netfs 'cifs'
> registered for caching
> Mar  3 22:12:06 Ishtar kernel: [21527.121049] Key type cifs.idmap registered
> Mar  3 22:12:06 Ishtar smbd[43429]: [2017/03/03 22:12:06,  0, class=rpc_srv]
> Mar  3 22:12:06 Ishtar smbd[43429]:   pipe_schannel_auth_bind: Attempt to
> bind using schannel without successful serverauth2
> Mar  3 22:12:06 Ishtar smbd[43429]: [2017/03/03 22:12:06,  0, class=rpc_srv]
> Mar  3 22:12:06 Ishtar smbd[43429]:   _netr_ServerAuthenticate3:
> netlogon_creds_server_check failed. Rejecting auth request from client
> ATHENAE machine account ATHENAE$
> Mar  3 22:12:13 Ishtar kernel: [21533.978843] CIFS VFS: Autodisabling the
> use of server inode numbers on \\Athenae\C. This server doesn't seem to
> support them properly. Hardlinks will not be recognized on this mount.
> Consider mounting with the "noserverino" option to silence this message.
>
> ----
> Have never seen issues w/the hardlinks -- what does it mean that "this
> server"
> (windows 7SP1 doesn't support them?)
>
> Anyway, I wanted to try other options, but now I can't unmount what I just
> mounted:
>
> # umount /athenae
> This utility only unmounts cifs filesystems.
>
> ??
>
> It **used** to unmount things when I didn't specify vers=2.1...
>
> So how do I unmount this short of rebooting?
>
> Thanks,
> -linda
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
