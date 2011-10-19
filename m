From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/9] cifs: cleanup and overhaul of the receive codepath
 (try #4)
Date: Wed, 19 Oct 2011 23:22:42 +0400
Message-ID: <CAKywueTiEmoEDLLt_SPO-qzGScKe1wCFt0HM2JSYHyJ2JoDnZw@mail.gmail.com>
References: <1319030219-3811-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319030219-3811-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/19 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> This patchset represents the remainder of the patches that Steve hasn=
't
> committed yet. The reason for the respin is to incorporate some revie=
w
> comments by Pavel and to respin for conflicts due to other patches th=
at
> have been merged into Steve's tree.
>
> The differences are pretty minor:
>
> 1) fix the function name in the comment on kvec_array_init.
>
> 2) make the patch that adds readv_from_socket use a GFP_NOFS allocati=
on.
> This was fixed in a later patch, but there could be problems bisectin=
g
> without that change.
>
> 3) The unnecessary reset of the "malformed" variable in handle_mid ha=
s
> been removed
>
> Other than that, this patchset is essentially the same as before. The=
se
> are also available in the cifs-3.2 branch of my git tree on
> git.samba.org:
>
> =A0 =A0http://git.samba.org/?p=3Djlayton/linux.git;a=3Dsummary
>
> Jeff Layton (9):
> =A0cifs: turn read_from_socket into a wrapper around a vectorized
> =A0 =A0version
> =A0cifs: keep a reusable kvec array for receives
> =A0cifs: add a third receive phase to cifs_demultiplex_thread
> =A0cifs: move mid finding into separate routine
> =A0cifs: eliminate is_multi_rsp parm to find_cifs_mid
> =A0cifs: move buffer pointers into TCP_Server_Info
> =A0cifs: find mid earlier in receive codepath
> =A0cifs: break out 3rd receive phase into separate function
> =A0cifs: add a callback function to receive the rest of the frame
>
> =A0fs/cifs/cifsglob.h =A0| =A0 29 ++++-
> =A0fs/cifs/cifsproto.h | =A0 =A05 +-
> =A0fs/cifs/cifssmb.c =A0 | =A0 =A05 +-
> =A0fs/cifs/connect.c =A0 | =A0370 +++++++++++++++++++++++++++++++++--=
----------------
> =A0fs/cifs/transport.c | =A0 =A05 +-
> =A05 files changed, 275 insertions(+), 139 deletions(-)
>
> --
> 1.7.6.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Reviewed-and-Tested-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
