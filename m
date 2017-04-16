From: Jonathan Liu <net147-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Do not send echoes before Negotiate is complete
Date: Mon, 17 Apr 2017 09:14:15 +1000
Message-ID: <CANwerB3oiNSyRfpPL3XeAkhm8N27N_DX9co5FM=Bahna96PJEw@mail.gmail.com>
References: <20170416193724.4945-1-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170416193724.4945-1-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Sachin,

On 17 April 2017 at 05:37, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> commit 4fcd1813e640 ("Fix reconnect to not defer smb3 session reconnect
> long after socket reconnect") added support for Negotiate requests to
> be initiated by echo calls.
>
> To avoid delays in calling echo after a reconnect, I added the patch
> introduced by the commit b8c600120fc8 ("Call echo service immediately
> after socket reconnect").
>
> This has however caused a regression with cifs shares which do not have
> support for echo calls to trigger Negotiate requests. On connections
> which need to call Negotiation, the echo calls trigger an error which
> triggers a reconnect which in turn triggers another echo call. This
> results in a loop which is only broken when an operation is performed on
> the cifs share. For an idle share, it can DOS a server.
>
> The patch uses the smb_operation can_echo() for cifs so that it is
> called only if connection has been already been setup.
>
> kernel bz: 194531
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb1ops.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index cc93ba4..60a1979 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -1015,6 +1015,15 @@ cifs_dir_needs_close(struct cifsFileInfo *cfile)
>         return !cfile->srch_inf.endOfSearch && !cfile->invalidHandle;
>  }
>
> +static bool
> +cifs_can_echo(struct TCP_Server_Info *server)
> +{
> +       if (server->tcpStatus == CifsGood)
> +               return true;
> +
> +       return false;

scripts/checkpatch.pl shows whitespace errors:
ERROR: code indent should use tabs where possible
#43: FILE: fs/cifs/smb1ops.c:1022:
+^I        return true;$

total: 1 errors, 0 warnings, 22 lines checked


Can be written more simply as:
return server->tcpStatus == CifsGood;

> +}
> +
>  struct smb_version_operations smb1_operations = {
>         .send_cancel = send_nt_cancel,
>         .compare_fids = cifs_compare_fids,
> @@ -1049,6 +1058,7 @@ struct smb_version_operations smb1_operations = {
>         .get_dfs_refer = CIFSGetDFSRefer,
>         .qfs_tcon = cifs_qfs_tcon,
>         .is_path_accessible = cifs_is_path_accessible,
> +       .can_echo = cifs_can_echo,
>         .query_path_info = cifs_query_path_info,
>         .query_file_info = cifs_query_file_info,
>         .get_srv_inum = cifs_get_srv_inum,
> --
> 2.9.3
>

Regards,
Jonathan
