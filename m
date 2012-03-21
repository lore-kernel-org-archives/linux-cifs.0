From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: pull request for 3.4
Date: Wed, 21 Mar 2012 11:56:29 -0500
Message-ID: <CAH2r5mtyn-c-BokGYhJRWWJ4+hQf-qB7XUtsSuE7xc_rEVFi=g@mail.gmail.com>
References: <20120319094558.1b6094b4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120319094558.1b6094b4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

=46YI - merged the first two. reviewing the others.

Cleaned up checkpatch warning in first one before merging.

On Mon, Mar 19, 2012 at 8:45 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> I think these patches have all been acked/reviewed for 3.4. You may
> pull them when ready:
>
> The following changes since commit 762ad8a5330325b789cfb6dc896f81cf27=
3ff4e9:
>
> =A0Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2=
012-03-13 18:39:28 -0700)
>
> are available in the git repository at:
>
> =A0git://git.samba.org/jlayton/linux.git cifs-3.4
>
> Jeff Layton (11):
> =A0 =A0 =A0cifs: clean up call to cifs_dfs_release_automount_timer()
> =A0 =A0 =A0cifs: clean up ordering in exit_cifs
> =A0 =A0 =A0cifs: add new cifsiod_wq workqueue
> =A0 =A0 =A0cifs: add pid field to cifs_writedata
> =A0 =A0 =A0cifs: allow caller to specify completion op when allocatin=
g writedata
> =A0 =A0 =A0cifs: fix allocation in cifs_write_allocate_pages
> =A0 =A0 =A0cifs: make cifsFileInfo_get return the cifsFileInfo pointe=
r
> =A0 =A0 =A0cifs: fix up get_numpages
> =A0 =A0 =A0cifs: abstract out function to marshal up the iovec array =
for async writes
> =A0 =A0 =A0cifs: call cifs_update_eof with i_lock held
> =A0 =A0 =A0cifs: convert cifs_iovec_write to use async writes
>
> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 25 +++--
> =A0fs/cifs/cifsglob.h =A0| =A0 =A07 +-
> =A0fs/cifs/cifsproto.h | =A0 15 +++-
> =A0fs/cifs/cifssmb.c =A0 | =A0 35 ++++---
> =A0fs/cifs/connect.c =A0 | =A0 =A08 +-
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0271 +++++++++++++++++++++++++++++++=
++------------------
> =A0fs/cifs/misc.c =A0 =A0 =A0| =A0 =A02 +-
> =A07 files changed, 235 insertions(+), 128 deletions(-)
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Thanks,

Steve
