From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 29 May 2012 10:51:41 -0500
Message-ID: <CAH2r5mvstY0cDsL1MseEqJ2uQdJv-rhXSZiSimtnMkDbQpzhhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 0e93b4b304ae052ba1bc73f6d34a68556fe93429:
  Linus Torvalds (1):
        Merge git://git.kernel.org/pub/scm/virt/kvm/kvm

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (14):
      cifs: make cifs_readdata_alloc take a work_func_t arg
      cifs: abstract out function to marshal the iovec for readv receives
      cifs: add refcounting to cifs_readdata structures
      cifs: add wrapper for cifs_async_readv to retry opening file
      cifs: convert cifs_iovec_read to use async reads
      cifs: remove legacy MultiuserMount option
      cifs: add a deprecation warning to CIFS_IOC_CHECKUMOUNT ioctl
      cifs: add a cache= option to better describe the different cache flavors
      cifs: add deprecation warnings to strictcache and forcedirectio
      cifs: display cache= option in /proc/mounts
      cifs: add warning about change in default cache semantics in 3.7
      cifs: remove the vers= and version= synonyms for ver=
      cifs: add a smb_version_operations/values structures and a
smb_version enum
      cifs: convert send_nt_cancel into a version specific op

Pavel Shilovsky (10):
      CIFS: Move locks to cifsFileInfo structure
      CIFS: Convert lock type to 32 bit variable
      CIFS: Separate protocol specific lock type handling
      CIFS: Separate protocol specific part from getlk
      CIFS: Separate protocol specific part from setlk
      CIFS: Move protocol specific part from SendReceive2 to ops struct
      CIFS: Move header_size/max_header_size to ops structure
      CIFS: Move protocol specific part from cifs_readv_receive to ops struct
      CIFS: Move protocol specific demultiplex thread calls to ops struct
      CIFS: Move add/set_credits and get_credits_field to ops structure

Sedat Dilek (1):
      cifs: Fix comment as d_alloc_root() is replaced by d_make_root()

Shirish Pargaonkar (2):
      cifs: Include backup intent search flags during searches {try #2)
      cifs: fix oops while traversing open file list (try #4)

Steve French (2):
      CIFS: Introduce SMB2 Kconfig option
      CIFS: Introduce SMB2 mounts as vers=2.1


-- 
Thanks,

Steve
