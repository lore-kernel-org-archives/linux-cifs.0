From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] Bugfixes for v3.17-rc
Date: Fri, 22 Aug 2014 11:08:39 -0500
Message-ID: <CAH2r5muMBBYwJZ7tbM9RTNwqsxvaDAXXCnp69as8QDovUmQwuQ@mail.gmail.com>
References: <1408699931-22515-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408699931-22515-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git for-next

This is fantastic that xfstests have already been so useful.  This
will help a lot.

And I also saw that the cthon test improvements were merged into Steve
D's tree.  We need to update the (Samba? and xfstest?) wikis with
information on how to run these.

On Fri, Aug 22, 2014 at 4:32 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Here is the set of bugfixes that was found during XFS testing (as a part of cifs-tests).
> The patches are targeted for v3.17-rc and for stable as well.
>
> Pavel Shilovsky (3):
>   CIFS: Fix directory rename error
>   CIFS: Fix wrong restart readdir for SMB1
>   CIFS: Fix wrong filename length for SMB2
>
>  fs/cifs/cifsglob.h  | 5 -----
>  fs/cifs/inode.c     | 5 ++++-
>  fs/cifs/readdir.c   | 2 +-
>  fs/cifs/smb2file.c  | 2 +-
>  fs/cifs/smb2inode.c | 2 +-
>  fs/cifs/smb2ops.c   | 2 +-
>  fs/cifs/smb2pdu.c   | 2 +-
>  7 files changed, 9 insertions(+), 11 deletions(-)
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
