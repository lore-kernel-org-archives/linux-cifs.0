From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] Clean up MF-Symlink code and add readlink support for
 DFS shares
Date: Mon, 20 Jan 2014 00:44:22 -0600
Message-ID: <CAH2r5msBUxJZ3gcmsbcwU4EA5HNjuT5_XavE_fGe64ab6i5gbQ@mail.gmail.com>
References: <1385399395-19217-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385399395-19217-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

remaining 7 merged into cifs-2.6.git for-next

On Mon, Nov 25, 2013 at 11:09 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The following set of patches was created as a result of an error
> reported by Red Hat QA which requires code to allow us to call
> readlink on dfs shares.
>
> Along with a fix for this issue, it appeared to be a good time to
> clean up the M-F symlink code to make it protocol agnostic as well
> as fix a couple of bugs in it.
>
> Sachin Prabhu (8):
>   cifs: We do not drop reference to tlink in  CIFSCheckMFSymlink()
>   cifs: Rename and cleanup open_query_close_cifs_symlink()
>   cifs: Rename MF symlink function names
>   cifs: use protocol specific call for query_mf_symlink()
>   cifs: Add create MFSymlinks to protocol ops struct
>   cifs: Re-order M-F Symlink code
>   cifs: move unix extension call to cifs_query_symlink()
>   cifs: Add support for readlink on dfs shares under posix extensions
>
>  fs/cifs/cifsglob.h  |   8 +-
>  fs/cifs/cifsproto.h |  20 ++--
>  fs/cifs/inode.c     |  10 +-
>  fs/cifs/link.c      | 315 ++++++++++++++++++++++++----------------------------
>  fs/cifs/readdir.c   |   2 +-
>  fs/cifs/smb1ops.c   |  55 +++++++--
>  6 files changed, 218 insertions(+), 192 deletions(-)
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
