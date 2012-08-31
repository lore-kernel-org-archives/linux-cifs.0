From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] Implement byte-range locks support for SMB2
Date: Fri, 31 Aug 2012 13:26:55 +0400
Message-ID: <CAKywueTu9WLrhWpim6zNtjp-HP59qUJMUZa4ApQepcpLyLK60Q@mail.gmail.com>
References: <1346250908-16832-1-git-send-email-pshilovsky@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346250908-16832-1-git-send-email-pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/8/29 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> This patchset enable brlock support for SMB2 mounts. It allows brlocks
> to be cached and send in portions (on oplock break or unlock range).
>
> git branch:
> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-brlocks
>
> Pavel Shilovsky (6):
>   CIFS: Remove spinlock dependence in brlock processing
>   CIFS: Move brlock code to ops struct
>   CIFS: Handle SMB2 lock flags
>   CIFS: Add brlock support for SMB2
>   CIFS: Use brlock cache for SMB2
>   CIFS: Add NTLMSSP sec type to defaults
>
>  fs/cifs/cifsfs.c    |    1 +
>  fs/cifs/cifsglob.h  |   28 +++++---
>  fs/cifs/cifsproto.h |    7 ++
>  fs/cifs/file.c      |  120 +++++++++++++++++-----------------
>  fs/cifs/smb1ops.c   |   12 ++++
>  fs/cifs/smb2file.c  |  180 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2ops.c   |   28 ++++++++-
>  fs/cifs/smb2pdu.c   |   59 +++++++++++++++++
>  fs/cifs/smb2pdu.h   |   29 ++++++++
>  fs/cifs/smb2proto.h |   11 +++
>  10 files changed, 405 insertions(+), 70 deletions(-)
>

Found a bug here and decided to separate "CIFS: Add NTLMSSP sec type
to defaults" patch from here - will repost.

-- 
Best regards,
Pavel Shilovsky.
