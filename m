From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 02/16] CIFS: Introduce SMB2 mounts as vers=2
Date: Sun, 6 May 2012 08:31:03 -0400
Message-ID: <20120506083103.605e3dae@corrin.poochiereds.net>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
	<1332753703-4315-3-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332753703-4315-3-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 26 Mar 2012 13:21:29 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> As with Linux nfs client, which uses "nfsvers=" or "vers=" to
> indicate which protocol to use for mount, specifying
> 
> "vers=smb2" or "vers=2"
> 
> will force an SMB2 mount. When vers is not specified CIFS is used
> 
> ie "vers=cifs" or "vers=1"
> 
> We can eventually autonegotiate down from SMB2 to CIFS
> when SMB2 is stable enough to make it the default, but this
> is for the future.  At that time we could also implement a
> "maxprotocol" mount option as smbclient and Samba have today,
> but that would be premature until SMB2 is stable.
> 
> Intially the SMB2 Kconfig option will depend on "BROKEN"
> until the merge is complete, and then be "EXPERIMENTAL"
> When it is no longer experimental we can consider changing
> the default protocol to attempt first.
> 
> Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |    3 +++
>  fs/cifs/connect.c  |    8 ++++++++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 4ff6313..9e28070 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -167,6 +167,9 @@ struct smb_vol {
>  	umode_t file_mode;
>  	umode_t dir_mode;
>  	unsigned secFlg;
> +#ifdef CONFIG_CIFS_SMB2
> +	bool use_smb2:1; /* use SMB2 protocol rather than CIFS */
> +#endif

Now that we have a new SMB major version to deal with, a boolean really
seems unsuited to this purpose. Should we change this to be an unsigned
int or something and assign the correct version number to it?

>  	bool retry:1;
>  	bool intr:1;
>  	bool setuids:1;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 9808154..955f0a3 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1856,6 +1856,14 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			    strnicmp(string, "1", 1) == 0) {
>  				/* This is the default */
>  				break;
> +			} else if (strnicmp(string, "smb2", 4) == 0 ||
> +				   strnicmp(string, "2", 1) == 0) {
> +#ifdef CONFIG_CIFS_SMB2
> +				vol->use_smb2 = true;
> +#else
> +				cERROR(1, "SMB2 support not enabled");

I think we should not try to accept ver=smb2 or anything. Let's stick
with numbered versions. In fact, the ver=cifs that the current code
allows should also be removed, IMO. Nothing sends that now, and we
shouldn't establish the precedent.

> +#endif /* CONFIG_CIFS_SMB2 */
> +				break;
>  			}
>  			/* For all other value, error */
>  			printk(KERN_WARNING "CIFS: Invalid version"

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
