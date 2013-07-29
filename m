From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RESEND] cifs: file: initialize oparms.reconnect before
 using it
Date: Mon, 29 Jul 2013 09:32:41 -0400
Message-ID: <20130729093241.437315e1@corrin.poochiereds.net>
References: <1375088293-14110-1-git-send-email-andi@etezian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, mikko.rapeli@iki.fi,
	pshilovsky@samba.org
To: Andi Shyti <andi@etezian.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1375088293-14110-1-git-send-email-andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 29 Jul 2013 10:58:13 +0200
Andi Shyti <andi@etezian.org> wrote:

> In the cifs_reopen_file function, if the following statement is
> asserted:
> 
> (tcon->unix_ext && cap_unix(tcon->ses) &&
> 		(CIFS_UNIX_POSIX_PATH_OPS_CAP &
> 		(tcon->fsUnixInfo.Capability)))
> 
> and we succeed to open with cifs_posix_open, the function jumps
> to the label reopen_success and checks for oparms.reconnect
> which is not initialized.
> 
> To avoid this the oparms structure initialization is anticipated
> before the if statement.
> 
> This issue has been reported by scan.coverity.com
> 
> Signed-off-by: Andi Shyti <andi@etezian.org>
> ---
>  fs/cifs/file.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 1e57f36..fbeaf45 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -632,6 +632,15 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>  	else
>  		oplock = 0;
>  
> +	oparms.tcon = tcon;
> +	oparms.cifs_sb = cifs_sb;
> +	oparms.desired_access = desired_access;
> +	oparms.create_options = create_options;

This patch just moves the brokenness around. You're
setting .desired_access here to an unintialized variable.
create_options also looks like it may potentially be wrong at this
point.

It may be that the code won't trip over these bugs in its current form,
but it's not really doing much to "future-proof" it. I think this
function needs a bit more refactoring instead of increasing the level
of spaghetti.

> +	oparms.disposition = disposition;
> +	oparms.path = full_path;
> +	oparms.fid = &cfile->fid;
> +	oparms.reconnect = true;
> +
>  	if (tcon->unix_ext && cap_unix(tcon->ses) &&
>  	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>  				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
> @@ -663,15 +672,6 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>  	if (server->ops->get_lease_key)
>  		server->ops->get_lease_key(inode, &cfile->fid);
>  
> -	oparms.tcon = tcon;
> -	oparms.cifs_sb = cifs_sb;
> -	oparms.desired_access = desired_access;
> -	oparms.create_options = create_options;
> -	oparms.disposition = disposition;
> -	oparms.path = full_path;
> -	oparms.fid = &cfile->fid;
> -	oparms.reconnect = true;
> -
>  	/*
>  	 * Can not refresh inode by passing in file_info buf to be returned by
>  	 * CIFSSMBOpen and then calling get_inode_info with returned buf since


-- 
Jeff Layton <jlayton@redhat.com>
