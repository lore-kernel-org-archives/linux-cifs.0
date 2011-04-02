From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: wrap received signature check in srv_mutex
Date: Sat, 2 Apr 2011 07:37:38 -0400
Message-ID: <20110402073738.534eec0a@tlielax.poochiereds.net>
References: <1301744070-30667-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301744070-30667-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat,  2 Apr 2011 07:34:30 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> While testing my patchset to fix asynchronous writes, I hit a bunch
> of signature problems when testing with signing on. The problem seems
> to be that signature checks on receive can be running at the same
> time as a process that is sending, or even that multiple receives can
> be checking signatures at the same time, clobbering the same data
> structures.
> 
> While we're at it, clean up the comments over cifs_calculate_signature
> and add a note that the srv_mutex should be held when calling this
> function.
> 
> This patch seems to fix the problems for me, but I'm not clear on
> whether it's the best approach. If it is, then this should probably
> go to stable too.
> 
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 5bb4b09..dfbd9f1 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -30,12 +30,13 @@
>  #include <linux/ctype.h>
>  #include <linux/random.h>
>  
> -/* Calculate and return the CIFS signature based on the mac key and SMB PDU */
> -/* the 16 byte signature must be allocated by the caller  */
> -/* Note we only use the 1st eight bytes */
> -/* Note that the smb header signature field on input contains the
> -	sequence number before this function is called */
> -
> +/*
> + * Calculate and return the CIFS signature based on the mac key and SMB PDU.
> + * The 16 byte signature must be allocated by the caller. Note we only use the
> + * 1st eight bytes and that the smb header signature field on input contains
> + * the sequence number before this function is called. Also, this function
> + * should be called with the server->srv_mutex held.
> + */
>  static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
>  				struct TCP_Server_Info *server, char *signature)
>  {
> @@ -209,8 +210,10 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
>  					cpu_to_le32(expected_sequence_number);
>  	cifs_pdu->Signature.Sequence.Reserved = 0;
>  
> +	mutex_lock(&server->srv_mutex);
>  	rc = cifs_calculate_signature(cifs_pdu, server,
>  		what_we_think_sig_should_be);
> +	mutex_unlock(&server->srv_mutex);
>  
>  	if (rc)
>  		return rc;

Also, on a semi-related note. I consistently get this error on session
setup with krb5i, with or without the above patch:

[  842.563693] CIFS VFS: Unexpected SMB signature

I set up the kernel to dump the stack there and get this:

[  842.564981] Pid: 1530, comm: mount.cifs Not tainted 2.6.38-1.fc15.x86_64.debug #1
[  842.566958] Call Trace:
[  842.567658]  [<ffffffffa00fca75>] ? cifs_check_receive+0x6e/0x84 [cifs]
[  842.569415]  [<ffffffffa00fccf6>] ? SendReceive2+0x26b/0x2cd [cifs]
[  842.571079]  [<ffffffffa0102128>] ? CIFS_SessSetup+0x88e/0xe36 [cifs]
[  842.572724]  [<ffffffffa00ee4db>] ? cifs_setup_session+0x90/0x1ae [cifs]
[  842.574551]  [<ffffffffa00ee9b3>] ? cifs_get_smb_ses+0x3ba/0x47e [cifs]
[  842.576257]  [<ffffffffa00f0627>] ? cifs_mount+0x1bb0/0x21c5 [cifs]
[  842.577944]  [<ffffffffa00e1b1c>] ? cifs_do_mount+0x191/0x309 [cifs]
[  842.579612]  [<ffffffff81136544>] ? vfs_kern_mount+0xaa/0x1d7
[  842.581093]  [<ffffffff811366d9>] ? do_kern_mount+0x4d/0xdf
[  842.582554]  [<ffffffff8114e4bf>] ? do_mount+0x6a4/0x6f8
[  842.583986]  [<ffffffff8114e793>] ? sys_mount+0x88/0xc2
[  842.585354]  [<ffffffff81009b82>] ? system_call_fastpath+0x16/0x1b

...it seems like the signature checking on session setup is always
wrong. After that though, I don't see any similar problems.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
