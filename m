From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Unexpected folder mode when unix extensions are enabled
Date: Thu, 20 Nov 2014 14:47:59 -0600
Message-ID: <CAH2r5msMSHZnNLAKPS29-8hiR8KJAOKCD1T03mK2QnVT_G1T+g@mail.gmail.com>
References: <546E1A8F.3060104@naturescapelawncare.com> <CAH2r5msgF-M7mUKqhRp1yPLAKwpNJkk+Y0BV7Oy3KocnHw3Bxw@mail.gmail.com>
 <546E27D3.8060707@naturescapelawncare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Kerrigan Joseph <kerrigan-unDuD2xQE4RCRbd0KW1xqSWTkRzJkiQl@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546E27D3.8060707-unDuD2xQE4RCRbd0KW1xqSWTkRzJkiQl@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>>> This behavior is not present when I mount the share with the unix
>>> extensions
>>> disabled, or when I access the share using smbclient.
>>>
>>> I would much prefer to operate with the unix extensions enabled, as it
>>> allows
>>> the client to accurately reflect the permissions present on the server,
>>> but
>>> I
>>> can't for the life of me figure out how to make the client obey the
>>> server's
>>> mode/mask directives!
>>>
>>> It should go without saying, but I'm not actually trying to use these
>>> particular modes in production. I ran into this issue when trying to
>>> enforce
>>> more sane permissions, but my example that follows uses these modes to
>>> illustrate the issue I'm experiencing.

Maybe a bug in the older Samba server?  Samba 3.6 is pretty old.  By
the way with Unix Extensions disabled (unless you are mounting with
"cifsacl" mount option) you aren't going to get the exact posix
permissions saved on the Samba server (there is no way to pass them
over cifs without using SMB/CIFS/NTFS ACLs, and even that is an
approximation with no exact equivalents for some of the special mode
bits).  For the non-posix extensions mounts, cifs.ko can handle the
"read-only" case (since there is a dos attribute), and cifs.ko can
cache mode changes in the client, depending on mount options (ACL
enforcement is really only important on the server anyway so what the
client thinks the permissions are is less important than the actual
ACL on the server) which may be what you are seeing in the non-POSIX
case.  Are you mounting with "cifsacl" in the non-posix case?

I tried an experiment (Samba 4.1.11, the current default in Ubuntu and
also using a fairly current cifs.ko, although it shouldn't matter for
this) using default (ie using cifs posix extensions).  All mode
changes for files and directories matched what I expected.

Creating directories and files and locally on ext4 set the various
modes (including the setuid, setgid and sticky bits).  Everything
matched on ls locally vs. remotely

sfrench@ubuntu:~/cifs-2.6/fs/cifs$ ls ~/test1 -la
total 40
drwxrwxr-x 10 sfrench sfrench 4096 Nov 20 14:27 .
drwxr-xr-x 28 sfrench sfrench 4096 Nov 20 14:26 ..
-rwxrwxrwx  1 sfrench sfrench    0 Nov 20 14:26 0777
drwxrwxrwx  2 sfrench sfrench 4096 Nov 20 14:27 0777d
-rwxrwxrwt  1 sfrench sfrench    0 Nov 20 14:26 1777
drwxrwxrwt  2 sfrench sfrench 4096 Nov 20 14:27 1777d
-rwxrwsrwx  1 sfrench sfrench    0 Nov 20 14:26 2777
drwxrwsrwx  2 sfrench sfrench 4096 Nov 20 14:27 2777d
-rwxrwsrwt  1 sfrench sfrench    0 Nov 20 14:26 3777
drwxrwsrwt  2 sfrench sfrench 4096 Nov 20 14:27 3777d
-rwsrwxrwx  1 sfrench sfrench    0 Nov 20 14:26 4777
drwsrwxrwx  2 sfrench sfrench 4096 Nov 20 14:27 4777d
-rwsrwxrwt  1 sfrench sfrench    0 Nov 20 14:26 5777
drwsrwxrwt  2 sfrench sfrench 4096 Nov 20 14:27 5777d
-rwsrwsrwx  1 sfrench sfrench    0 Nov 20 14:27 6777
drwsrwsrwx  2 sfrench sfrench 4096 Nov 20 14:27 6777d
-rwsrwsrwt  1 sfrench sfrench    0 Nov 20 14:27 7777
drwsrwsrwt  2 sfrench sfrench 4096 Nov 20 14:27 7777d
sfrench@ubuntu:~/cifs-2.6/fs/cifs$ ls /mnt/test1 -la
total 0
drwxrwxr-x 10 sfrench sfrench 0 Nov 20 14:27 .
drwxr-xr-x 28 sfrench sfrench 0 Nov 20 14:26 ..
-rwxrwxrwx  1 sfrench sfrench 0 Nov 20 14:26 0777
drwxrwxrwx  2 sfrench sfrench 0 Nov 20 14:27 0777d
-rwxrwxrwt  1 sfrench sfrench 0 Nov 20 14:26 1777
drwxrwxrwt  2 sfrench sfrench 0 Nov 20 14:27 1777d
-rwxrwsrwx  1 sfrench sfrench 0 Nov 20 14:26 2777
drwxrwsrwx  2 sfrench sfrench 0 Nov 20 14:27 2777d
-rwxrwsrwt  1 sfrench sfrench 0 Nov 20 14:26 3777
drwxrwsrwt  2 sfrench sfrench 0 Nov 20 14:27 3777d
-rwsrwxrwx  1 sfrench sfrench 0 Nov 20 14:26 4777
drwsrwxrwx  2 sfrench sfrench 0 Nov 20 14:27 4777d
-rwsrwxrwt  1 sfrench sfrench 0 Nov 20 14:26 5777
drwsrwxrwt  2 sfrench sfrench 0 Nov 20 14:27 5777d
-rwsrwsrwx  1 sfrench sfrench 0 Nov 20 14:27 6777
drwsrwsrwx  2 sfrench sfrench 0 Nov 20 14:27 6777d
-rwsrwsrwt  1 sfrench sfrench 0 Nov 20 14:27 7777
drwsrwsrwt  2 sfrench sfrench 0 Nov 20 14:27 7777d


I tried a similar experiment remotely (creating the file locally and
setting the mode remotely over cifs to 07777)

sfrench@ubuntu:~/cifs-2.6/fs/cifs$ touch ~/test1/testfile

sfrench@ubuntu:~/cifs-2.6/fs/cifs$ ls ~/test1/testfile -la
-rw-rw-r-- 1 sfrench sfrench 0 Nov 20 14:36 /home/sfrench/test1/testfile

sfrench@ubuntu:~/cifs-2.6/fs/cifs$ umask
0002

sfrench@ubuntu:~/cifs-2.6/fs/cifs$ chmod 7777 /mnt/test1/testfile

sfrench@ubuntu:~/cifs-2.6/fs/cifs$ ls ~/test1/testfile -la
-rwsrwsrwt 1 sfrench sfrench 0 Nov 20 14:36 /home/sfrench/test1/testfile

sfrench@ubuntu:~/cifs-2.6/fs/cifs$ ls /mnt/test1/testfile -la
-rwsrwsrwt 1 sfrench sfrench 0 Nov 20 14:36 /mnt/test1/testfile

Similarly for a directory:


sfrench@ubuntu:~/cifs-2.6/fs/cifs$ mkdir ~/test1/testdir
sfrench@ubuntu:~/cifs-2.6/fs/cifs$ ls -lda ~/test1/testdir
drwxrwxr-x 2 sfrench sfrench 4096 Nov 20 14:39 /home/sfrench/test1/testdir
sfrench@ubuntu:~/cifs-2.6/fs/cifs$ chmod 7777 /mnt/test1/testdir
sfrench@ubuntu:~/cifs-2.6/fs/cifs$ ls -lda ~/test1/testdir
drwsrwsrwt 2 sfrench sfrench 4096 Nov 20 14:39 /home/sfrench/test1/testdir









-- 
Thanks,

Steve
