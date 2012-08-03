From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/45] SMB2 base operation support
Date: Fri, 3 Aug 2012 10:14:19 -0500
Message-ID: <CAH2r5mtZqBpMpeqLEONU=66WFJnRTkHTNzNSWGQqTdAX-X+A4A@mail.gmail.com>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that I have also had a chance to rereview the remainder of the
series, and retest these. I merged the last part of Pavel's "smb2
basic" support into cifs-2.6.git for-next (the first part of the
series below is already upstream, as is the earlier smb2 transport
enablement and cifs common code restructuring).  Even though it tests
ok I plan to leave the SMB2 support as CONFIG_BROKEN until after the
testing at the annual Storage Developer Conference (SMB2 Plugfest)
next month, unless I get more test feedback.

Other near term items:
Jeff noted that we need to merge the patch for default security
mechanism upgrade for cifs, and Jeff has a series of 5 socket handling
patches that Pavel found a problem with (that presumably is a bug in
Windows not in the Linux kernel client - but need to investigate
more). In addition for SMB2 there are also three sparse warnings in
Pavel's code that I want to eliminate.

On Wed, Jul 18, 2012 at 10:48 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> This patchset is the second part of big SMB2 merge (after smb2-mount). It adds SMB2 support for
> file and inode operation as well as rewrites existing part of their code to make it use ops
> server struct of protocol specific callbacks.
>
> The patchset is tested by cthon tests: basic and general parts.
>
> Pavel Shilovsky (45):
>   CIFS: Make CAP_* checks protocol independent
>   CIFS: Simpliify cifs_mkdir call
>   CIFS: Separate protocol specific part from mkdir
>   CIFS: Add SMB2 support for mkdir operation
>   CIFS: Move rmdir code to ops struct
>   CIFS: Add SMB2 support for rmdir
>   CIFS: Protect i_nlink from being negative
>   CIFS: Move unlink code to ops struct
>   CIFS: Add SMB2 support for unlink
>   CIFS: Replace netfid with cifs_fid struct in cifsFileInfo
>   CIFS: Move open code to ops struct
>   CIFS: Move close code to ops struct
>   CIFS: Add open/close file support for SMB2
>   CIFS: Move guery file info code to ops struct
>   CIFS: Add SMB2 support for query_file_info
>   CIFS: Move create code use ops struct
>   CIFS: Move reopen code to ops struct
>   CIFS: Make flush code use ops struct
>   CIFS: Add SMB2 support for flush
>   CIFS: Move r/wsize negotiating to ops struct
>   CIFS: Add SMB2 r/wsize negotiating
>   CIFS: Move async read to ops struct
>   CIFS: Add SMB2 support for cifs_iovec_read
>   CIFS: Move async write to ops struct
>   CIFS: Add SMB2 support for cifs_iovec_write
>   CIFS: Move readpage code to ops struct
>   CIFS: Add readpage support for SMB2
>   CIFS: Move writepage to ops struct
>   CIFS: Add writepage support for SMB2
>   CIFS: Enable signing in SMB2
>   CIFS: Move rename to ops struct
>   CIFS: Add SMB2 support for rename operation
>   CIFS: Move hardlink to ops struct
>   CIFS: Add SMB2 support for hardlink operation
>   CIFS: Move set_file_size to ops struct
>   CIFS: Add SMB2 support for set_file_size
>   CIFS: Move set_file_info to ops struct
>   CIFS: Add set_file_info support for SMB2
>   CIFS: Move readdir code to ops struct
>   CIFS: Add readdir support for SMB2
>   CIFS: Process oplocks for SMB2
>   CIFS: Move oplock break to ops struct
>   CIFS: Add oplock break support for SMB2
>   CIFS: Move statfs to ops struct
>   CIFS: Add statfs support for SMB2
>
>  fs/cifs/Kconfig         |    1 +
>  fs/cifs/Makefile        |    2 +-
>  fs/cifs/cifsacl.c       |    2 +-
>  fs/cifs/cifsencrypt.c   |   30 ++-
>  fs/cifs/cifsfs.c        |   31 +--
>  fs/cifs/cifsglob.h      |  241 ++++++++++++-
>  fs/cifs/cifsproto.h     |   96 ++----
>  fs/cifs/cifssmb.c       |  171 ++++-----
>  fs/cifs/connect.c       |  154 +-------
>  fs/cifs/dir.c           |  108 +++---
>  fs/cifs/file.c          |  473 +++++++++++++-----------
>  fs/cifs/inode.c         |  652 ++++++++++++++++----------------
>  fs/cifs/ioctl.c         |   13 +-
>  fs/cifs/link.c          |   80 +++--
>  fs/cifs/misc.c          |    2 +-
>  fs/cifs/netmisc.c       |    3 +-
>  fs/cifs/readdir.c       |  179 +++++----
>  fs/cifs/smb1ops.c       |  351 +++++++++++++++++-
>  fs/cifs/smb2file.c      |  106 ++++++
>  fs/cifs/smb2glob.h      |   14 +
>  fs/cifs/smb2inode.c     |  137 +++++++-
>  fs/cifs/smb2maperror.c  |    3 +-
>  fs/cifs/smb2misc.c      |   86 ++++-
>  fs/cifs/smb2ops.c       |  267 +++++++++++++-
>  fs/cifs/smb2pdu.c       |  957 ++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/cifs/smb2pdu.h       |  178 +++++++++
>  fs/cifs/smb2proto.h     |   71 ++++-
>  fs/cifs/smb2transport.c |  157 ++++++++-
>  fs/cifs/transport.c     |   24 +-
>  29 files changed, 3499 insertions(+), 1090 deletions(-)
>  create mode 100644 fs/cifs/smb2file.c
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
