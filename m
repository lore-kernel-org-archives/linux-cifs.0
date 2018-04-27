From: Steve French <smfrench@gmail.com>
Subject: copy_file_range and user space tools to do copy fastest
Date: Fri, 27 Apr 2018 11:25:20 -0700
Message-ID: <CAH2r5mtRF-yS6stThuVzem+WFmxDqpGLwFvUPviYcmh9dXXwkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Are there any user space tools (other than our test tools and xfs_io
etc.) that support copy_file_range?  Looks like at least cp and rsync
and dd don't.  That syscall which now has been around a couple years,
and was reminded about at the LSF/MM summit a few days ago, presumably
is the 'best' way to copy a file fast since it tries all the
mechanisms (reflink etc.) in order.

Since copy_file_range syscall can be 100x or more faster for network
file systems than the alternative, was surprised when I noticed that
cp and rsync didn't support it.  It doesn't look like rsync even
supports reflink either(although presumably if you call
copy_file_range you don't have to worry about that), and reads/writes
are 8K. See copy_file() in rsync/util.c

In the cp command it looks like it can call the FICLONE IOCTL (see
clone_file() in coreutils/src/copy.c) but doesn't call the expected
"copy_file_range" syscall.

In the dd command it doesn't call either - see dd_copy in corutils/src/dd.c

Since it can be 100x or more faster in some cases to call
copy_file_range than do reads/writes back and forth to do a copy
(especially if network or clustered backend or cloud), what tools are
the best to recommend?

Would rsync or cp be likely to take patches to call the standard
"copy_file_range" syscall
(http://man7.org/linux/man-pages/man2/copy_file_range.2.html)?
Presumably not if it has been two+ years ... but would be interested
what copy tools to recommend to use instead.

These are not uncommon cases (all Windows, Macs, Samba etc. and even
some NFS servers) ... but copies over local file systems can benefit
too (as copy_file_range tries various mechanisms).
-- 
Thanks,

Steve
