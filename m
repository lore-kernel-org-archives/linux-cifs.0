From: Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: F_OFD_GETLK implemented wrong with CIFS protocol version 2.0+
Date: Tue, 26 Jun 2018 21:11:40 -0400 (EDT)
Message-ID: <1332132554.10805313.1530061900159.JavaMail.zimbra@redhat.com>
References: <77967693-040b-734a-8e18-be95d97478b3@redhat.com> <CAH2r5muV49o7aTco1757UwuW-c6Fn5r=EW3QMCMfU7FFLZNMTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: labbott@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Adam Williamson <awilliam@redhat.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5muV49o7aTco1757UwuW-c6Fn5r=EW3QMCMfU7FFLZNMTw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The problem is in fs/cifs/file.c:cifs_find_fid_lock_conflict since it is not aware of OFD locks
and thus think there is a conflict.

I have an initial patch that fixes the problem for the reproducer but need more time to understand if/what
else might need fixin.





----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: labbott@redhat.com
> Cc: "CIFS" <linux-cifs@vger.kernel.org>, "samba-technical" <samba-technical@lists.samba.org>, "LKML"
> <linux-kernel@vger.kernel.org>, "Adam Williamson" <awilliam@redhat.com>
> Sent: Tuesday, 26 June, 2018 1:54:40 PM
> Subject: Re: F_OFD_GETLK implemented wrong with CIFS protocol version 2.0+
> 
> We are taking a look at this - Ronnie had some ideas.  Probably simply
> not implemented - hopefully not too hard to fix.
> On Mon, Jun 25, 2018 at 6:58 PM Laura Abbott <labbott@redhat.com> wrote:
> >
> > Hi,
> >
> > A while back, someone reported a failure on Fedora when trying to boot
> > a QEMU image off of a CIFS share. The issue was reduced down to a
> > test case (https://bugzilla.redhat.com/show_bug.cgi?id=1484130#c8)
> >
> > # cat test-ofd-lock.c
> > #define _GNU_SOURCE
> > #include <errno.h>
> > #include <stdio.h>
> > #include <unistd.h>
> > #include <fcntl.h>
> >
> > int main(int argc, char **argv)
> > {
> >      int ret;
> >      int fd;
> >      struct flock fl = {
> >          .l_whence = SEEK_SET,
> >          .l_start  = 0,
> >          .l_len    = 0,
> >          .l_type   = F_RDLCK,
> >      };
> >      if (argc < 2) {
> >              fprintf(stderr, "Usage: %s <file>\n", argv[0]);
> >              return 1;
> >      }
> >      fd = open(argv[1], O_RDWR);
> >      if (fd < 0) {
> >              perror("open");
> >              return errno;
> >      }
> >      ret = fcntl(fd, F_OFD_SETLK, &fl);
> >      if (ret) {
> >              perror("setlk");
> >              return errno;
> >      }
> >      fl.l_type = F_WRLCK;
> >      ret = fcntl(fd, F_OFD_GETLK, &fl);
> >      if (ret) {
> >              perror("getlk");
> >              return errno;
> >      }
> >      if (fl.l_type != F_UNLCK) {
> >              fprintf(stderr, "get lock test failed\n");
> >              return 1;
> >      }
> >      return 0;
> > }
> > [root@localhost ~]# make test-ofd-lock
> > cc     test-ofd-lock.c   -o test-ofd-lock
> > [root@localhost ~]# touch /tmp/test && ./test-ofd-lock /tmp/test
> > [root@localhost ~]# echo $?
> > 0
> > [root@localhost ~]# touch /mnt/test && ./test-ofd-lock /mnt/test
> > get lock test failed
> > [root@localhost ~]# mount | grep /mnt
> > //192.168.31.1/tddownload on /mnt type cifs (rw,relatime,vers=3.0,
> > cache=strict,username=admin,domain=,uid=0,
> > noforceuid,gid=0,noforcegid,addr=192.168.31.1,file_mode=0755,
> > dir_mode=0755,nounix,serverino,mapposix,rsize=1048576,
> > wsize=1048576,echo_interval=60,actimeo=1,user=admin)
> >
> >
> > As explained by one of the QEMU developers
> > (https://bugzilla.redhat.com/show_bug.cgi?id=1484130#c37)
> >
> > '''
> > It is a kernel bug. The code snippet in comment 8 shows clearly that the
> > kernel
> > is doing the wrong thing, which cannot be fixed/worked around by QEMU.
> >
> > In man 2 fcntl:
> >
> >         F_OFD_GETLK (struct flock *)
> >                On input to this call, lock describes an open file
> >                description lock
> > we would like to place on the file.  If the lock could  be  placed,
> > fcntl()  does  not
> >                actually  place  it,  but  returns F_UNLCK in the l_type
> >                field of lock
> > and leaves the other fields of the structure unchanged.  If one or more
> > incompatible
> >                locks would prevent this lock being placed, then details
> >                about one of
> > these locks are returned via lock, as described above for F_GETLK.
> >
> > which is not the case with the new CIFS behaviour.
> > ''
> >
> > You can read the full context at
> > https://bugzilla.redhat.com/show_bug.cgi?id=1484130
> >
> > Any suggestions?
> >
> > Thanks,
> > Laura
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
> Thanks,
> 
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
