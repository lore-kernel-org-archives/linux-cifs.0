From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/9] SMB2.1 multicredit requests for writing
Date: Thu, 26 Jun 2014 00:52:27 -0500
Message-ID: <CAH2r5mtcMmybX9O_bwYAm1rOQ4p5TMbMkKqOp_HOajKKoztfpQ@mail.gmail.com>
References: <1403535517-8301-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403535517-8301-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Partially merged (first 5 ie those which merged cleanly) into
cifs-2.6.git for-next (for further testing).

On Mon, Jun 23, 2014 at 9:58 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> The goal of this patchset is to add large MTU/multicredits support for writing from the CIFS client to servers that support SMB 2.1 and higher versions of the protocol.
>
> First three patches simplify the writepages code. Patches #4 and #5 both fix the problem in writepages when a server changes wsize value after reconnects from the client. Patches #6 and #7 simplify the iovec write code, #8 fixes the wsize changing problem there. Finally, patch #9 introduces multicredits support for writing.
>
> Pavel Shilovsky (9):
>   CIFS: Separate page processing from writepages
>   CIFS: Separate page sending from writepages
>   CIFS: Separate pages initialization from writepages
>   CIFS: Fix wsize usage in writepages
>   CIFS: Fix cifs_writev_requeue when wsize changes
>   CIFS: Separate filling pages from iovec write
>   CIFS: Separate writing from iovec write
>   CIFS: Fix wsize usage in iovec write
>   CIFS: Use multicredits for writes
>
>  fs/cifs/cifsglob.h      |   17 ++
>  fs/cifs/cifsproto.h     |    3 +
>  fs/cifs/cifssmb.c       |   84 ++++++--
>  fs/cifs/file.c          |  540 ++++++++++++++++++++++++++++-------------------
>  fs/cifs/smb1ops.c       |    8 +
>  fs/cifs/smb2ops.c       |   62 +++++-
>  fs/cifs/smb2pdu.c       |   24 ++-
>  fs/cifs/smb2transport.c |    5 +
>  fs/cifs/transport.c     |   25 ++-
>  9 files changed, 517 insertions(+), 251 deletions(-)
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
