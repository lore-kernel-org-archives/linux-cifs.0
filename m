From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Fri, 14 Oct 2016 17:52:41 -0500
Message-ID: <CAH2r5mtBVZkMRaU2zJ8CewzXqeK03mwU0drC+muQG2OQ-fyMKQ@mail.gmail.com>
References: <CAH2r5msU1BF5pL3H1or=JKLNzgeYxPEoXrQuJRwHGs996J2aQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msU1BF5pL3H1or=JKLNzgeYxPEoXrQuJRwHGs996J2aQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Forgot to cc: mailing list

On Fri, Oct 14, 2016 at 5:52 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Please pull the following changes since commit
> 1573d2caf713874cfe0d1336c823d0fb548d8bed:
>
> Including:
> - 9 bug fixes for stable.  Some of these we found at the recent two
> weeks of SMB3 test events/plugfests.
> - Significant improvements in reconnection (e.g. if server or network crashes)
>   especially when mounted with "persistenthandles" or to server which advertises
>   Continuous Availability on the share.
> - a new mount option "idsfromsid" which improves POSIX compatibility
> in some cases (when winbind not configured e.g.) by better (and
> faster) fetching uid/gid from acl (when "cifsacl" mount option is
> enabled).  NB: we are almost complete work on "cifsacl" (querying
> mode/uid/gid from ACL) for SMB3, but SMB3 support for cifsacl is not
> included in this set.
> - improved handling for SMB3 "credits" (even if server is buggy)
>
> Still working on two sets of changes:
> - cifsacl enablement for SMB3
> - cleanup of RFC1001 length calculation (so we can handle encryption
> and multichannel and RDMA)
>
> And a couple of new bugs were reported recently (unrelated to above)
> so will probably have another merge request next week.
>
>   Merge branch 'parisc-4.9-2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
> (2016-10-11 23:59:07 -0700)
>
> are available in the git repository at:
>
>
>   git://git.samba.org/sfrench/cifs-2.6.git for-next
>
> for you to fetch changes up to 3514de3fd5fab518520e393152d3f4e3d0441d8d:
>
>   CIFS: Retrieve uid and gid from special sid if enabled (2016-10-14
> 14:22:16 -0500)
>
> ----------------------------------------------------------------
> Aurelien Aptel (1):
>       fs/cifs: keep guid when assigning fid to fileinfo
>
> Germano Percossi (1):
>       Expose cifs module parameters in sysfs
>
> Pavel Shilovsky (2):
>       CIFS: Fix persistent handles re-opening on reconnect
>       CIFS: Reset read oplock to NONE if we have mandatory locks after reopen
>
> Ross Lagerwall (1):
>       cifs: Limit the overall credit acquired
>
> Sachin Prabhu (3):
>       Fix regression which breaks DFS mounting
>       SMB2: Separate Kerberos authentication from SMB2_sess_setup
>       SMB2: Separate RawNTLMSSP authentication from SMB2_sess_setup
>
> Steve French (13):
>       Add way to query file attributes via cifs xattr
>       Add way to query creation time of file via cifs xattr
>       Display number of credits available
>       Set previous session id correctly on SMB3 reconnect
>       SMB3: GUIDs should be constructed as random but valid uuids
>       Clarify locking of cifs file and tcon structures and make more granular
>       fs/cifs: reopen persistent handles on reconnect
>       SMB3: Add mount parameter to allow user to override max credits
>       Do not send SMB3 SET_INFO request if nothing is changing
>       Enable previous version support
>       Cleanup missing frees on some ioctls
>       CIFS: Add new mount option to set owner uid and gid from special
> sids in acl
>       CIFS: Retrieve uid and gid from special sid if enabled
>
>  fs/cifs/cifs_debug.c |   1 +
>  fs/cifs/cifs_fs_sb.h |   1 +
>  fs/cifs/cifs_ioctl.h |   8 +
>  fs/cifs/cifsacl.c    | 123 +++++++++++
>  fs/cifs/cifsfs.c     |  11 +-
>  fs/cifs/cifsglob.h   |  50 +++--
>  fs/cifs/cifsproto.h  |   2 +
>  fs/cifs/cifssmb.c    |   4 +-
>  fs/cifs/connect.c    |  43 +++-
>  fs/cifs/file.c       | 105 ++++++---
>  fs/cifs/ioctl.c      |  16 +-
>  fs/cifs/misc.c       |  15 +-
>  fs/cifs/readdir.c    |   6 +-
>  fs/cifs/smb2inode.c  |   6 +
>  fs/cifs/smb2misc.c   |  16 +-
>  fs/cifs/smb2ops.c    |  62 +++++-
>  fs/cifs/smb2pdu.c    | 587 +++++++++++++++++++++++++++++++++------------------
>  fs/cifs/smb2pdu.h    |   2 +-
>  fs/cifs/xattr.c      |  62 +++++-
>  19 files changed, 824 insertions(+), 296 deletions(-)
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
