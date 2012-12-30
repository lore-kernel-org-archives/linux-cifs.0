From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] Data coherency fixes for v3.8
Date: Sun, 30 Dec 2012 11:54:29 -0600
Message-ID: <CAH2r5mu-pEX7kDQF2NrfE8OtRThsPqZ8GewDg8yxzDvv63Eejw@mail.gmail.com>
References: <1356537234-11507-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356537234-11507-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have merged these and Jeff's two most recent fixes into cifs-2.6.git
for-next.  Let me know if any additional review or updated test
results.

On Wed, Dec 26, 2012 at 9:53 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
> This patchset is targeted for v3.8 and aimed to fix data coherency problem
> mostly with SMB2.1 protocol code but it applies for CIFS code as well.
>
> The problem is that is was investigated that Windows 7 server doesn't
> break read caching lease if we set/have madatory byte-range locks or issue a
> write request. This end up with situations when we have level2 lease, issue
> read caching and conflict with byte-range lock from another fid.
>
> This strage behavior make we think that we should not rely on the server
> and should process such things ourself on the client.
>
> On the client we can set oplock/lease level according to request we send
> to the server: if we issue a write or brlock request we can simply break
> level2 oplock/lease and there is no problem for us if the server breaks it
> too.
>
> The patchset consists of two parts:
> 1) re-fix for the patch "CIFS: Fix write after setting a read lock for
> read oplock files" (patches #1 and #2) that breaks level2 oplock/lease on
> the client if we issue a write request.
> 2) fix for brlocks that breaks level2 oplock/lease on the client if we
> issue a mandatory byte-range lock request.
>
> The work branch with the patches:
> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/for-3.8
>
> Pavel Shilovsky (3):
>   Revert "CIFS: Fix write after setting a read lock for read oplock
>     files"
>   CIFS: Fix write after setting a read lock for read oplock files
>   CIFS: Don't let read only caching for mandatory byte-range locked
>     files
>
>  fs/cifs/cifsfs.c   |   1 -
>  fs/cifs/cifsglob.h |   2 +-
>  fs/cifs/file.c     | 141
> +++++++++++++++++++++++++++++------------------------
>  fs/cifs/smb1ops.c  |   1 +
>  fs/cifs/smb2ops.c  |   3 ++
>  5 files changed, 81 insertions(+), 67 deletions(-)
>
> --
> 1.7.12.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Thanks,

Steve
