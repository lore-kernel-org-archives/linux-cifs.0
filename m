From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] Cleanup open codepath
Date: Mon, 20 Jan 2014 00:21:07 -0600
Message-ID: <CAH2r5muANBSSsG_adMzpwZcbn2-wWJK34xrY+5iRyMrdeGJv+A@mail.gmail.com>
References: <1389873217-17519-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389873217-17519-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

looks reasonable but am getting various minor whitespace errors
scanning the patch series

Can you fixup and make sure it is checkpatch clean?

e.g.

ERROR: trailing whitespace
#123: FILE: fs/cifs/dir.c:650:
+^I/*^M$

ERROR: trailing whitespace
#124: FILE: fs/cifs/dir.c:651:
+^I * BB Do not bother to decode buf since no local inode yet to put^M$

ERROR: trailing whitespace
#125: FILE: fs/cifs/dir.c:652:
+^I * timestamps in, but we can reuse it safely.^M$

On Thu, Jan 16, 2014 at 5:53 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> This patchset includes various cleanups that touch open codepath. This will help to introduce share modes into cifs module easier.
>
> Patches are rebased on top of Sachin's patchset "Clean up MF-Symlink code and add readlink support for DFS shares".
>
> Pavel Shilovsky (4):
>   CIFS: Cleanup CIFSSMBOpen
>   CIFS: Cleanup cifs_mknod
>   CIFS: Remove extra indentation in cifs_sfu_type
>   CIFS: Cleanup cifs open codepath
>
>  fs/cifs/cifsacl.c   |   40 +++++++++----
>  fs/cifs/cifsproto.h |    7 +--
>  fs/cifs/cifssmb.c   |  158 +++++++++++++++++++++++++++---------------------
>  fs/cifs/dir.c       |   59 +++++++++---------
>  fs/cifs/file.c      |    2 +-
>  fs/cifs/inode.c     |  166 +++++++++++++++++++++++++++++----------------------
>  fs/cifs/link.c      |   44 +++++++++-----
>  fs/cifs/smb1ops.c   |   71 +++++++++++++---------
>  8 files changed, 317 insertions(+), 230 deletions(-)
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
