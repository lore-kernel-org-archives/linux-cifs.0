From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: remove smb2 multicall binary code
Date: Thu, 17 May 2012 06:48:38 -0400
Message-ID: <20120517064838.2a76dc30@corrin.poochiereds.net>
References: <1336784436-9176-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336784436-9176-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 11 May 2012 21:00:36 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> This was added when it was thought that smb2 would be a different fstype
> altogether. Now that we are not adding a separate fstype, this code is
> no longer needed since nothing will ever call /sbin/mount.smb2.
> 
> Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c |   61 +++------------------------------------------------------
>  1 files changed, 4 insertions(+), 57 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 3041987..2d1d842 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -181,7 +181,6 @@ struct parsed_mount_info {
>  
>  const char *thisprogram;
>  const char *cifs_fstype = "cifs";
> -const char *smb2_fstype = "smb2";
>  
>  static int parse_unc(const char *unc_name, struct parsed_mount_info *parsed_info);
>  
> @@ -250,7 +249,7 @@ check_fstab(const char *progname, const char *mountpoint, const char *devname,
>  
>  BB end finish BB */
>  
> -static int mount_cifs_usage(FILE * stream)
> +static int mount_usage(FILE * stream)
>  {
>  	fprintf(stream, "\nUsage:  %s <remotetarget> <dir> -o <options>\n",
>  		thisprogram);
> @@ -290,52 +289,6 @@ static int mount_cifs_usage(FILE * stream)
>  	return 0;
>  }
>  
> -static int mount_smb2_usage(FILE *stream)
> -{
> -	fprintf(stream, "\nUsage:  %s <remotetarget> <dir> -o <options>\n",
> -		thisprogram);
> -	fprintf(stream, "\nMount the remote target, specified as a UNC name,");
> -	fprintf(stream, " to a local directory.\n\nOptions:\n");
> -	fprintf(stream, "\tuser=<arg>\n\tpass=<arg>\n\tdom=<arg>\n");
> -	fprintf(stream, "\nLess commonly used options:");
> -	fprintf(stream,
> -		"\n\tcredentials=<filename>,guest,perm,noperm,rw,ro,");
> -	fprintf(stream,
> -		"\n\tsep=<char>,iocharset=<codepage>,exec,noexec");
> -	fprintf(stream,
> -		"\n\tnolock,directio,sec=<authentication mechanism>,sign");
> -	fprintf(stream,
> -		"\n\tuid=<uid>,gid=<gid>,dir_mode=<mode>,file_mode=<mode>");
> -	fprintf(stream, "\n\nRarely used options:");
> -	fprintf(stream,
> -		"\n\tport=<tcpport>,rsize=<size>,wsize=<size>,unc=<unc_name>,ip=<ip_address>,");
> -	fprintf(stream,
> -		"\n\tdev,nodev,hard,soft,intr,");
> -	fprintf(stream,
> -		"\n\tnointr,ignorecase,noacl,prefixpath=<path>,nobrl");
> -	fprintf(stream,
> -		"\n\nOptions are described in more detail in the manual page");
> -	fprintf(stream, "\n\tman 8 mount.smb2\n");
> -	fprintf(stream, "\nTo display the version number of the mount helper:");
> -	fprintf(stream, "\n\tmount.smb2 -V\n");
> -
> -	if (stream == stderr)
> -		return EX_USAGE;
> -	return 0;
> -}
> -
> -static int mount_usage(FILE *stream)
> -{
> -	int rc;
> -
> -	if (strcmp(thisprogram, "mount.smb2") == 0)
> -		rc = mount_smb2_usage(stream);
> -	else
> -		rc = mount_cifs_usage(stream);
> -
> -	return rc;
> -}
> -
>  /*
>   * CIFS has to "escape" commas in the password field so that they don't
>   * end up getting confused for option delimiters. Copy password into pw
> @@ -1928,7 +1881,6 @@ int main(int argc, char **argv)
>  	size_t options_size = MAX_OPTIONS_LEN;
>  	struct parsed_mount_info *parsed_info = NULL;
>  	pid_t pid;
> -	const char *fstype;
>  
>  	rc = check_setuid();
>  	if (rc)
> @@ -2109,14 +2061,9 @@ mount_retry:
>  	if (rc)
>  		goto mount_exit;
>  
> -	if (strcmp(thisprogram, "mount.smb2") == 0)
> -		fstype = smb2_fstype;
> -	else
> -		fstype = cifs_fstype;
> -
>  	if (!parsed_info->fakemnt) {
>  		toggle_dac_capability(0, 1);
> -		rc = mount(orig_dev, ".", fstype, parsed_info->flags, options);
> +		rc = mount(orig_dev, ".", cifs_fstype, parsed_info->flags, options);
>  		toggle_dac_capability(0, 0);
>  		if (rc == 0)
>  			goto do_mtab;
> @@ -2133,7 +2080,7 @@ mount_retry:
>  			goto mount_retry;
>  		case ENODEV:
>  			fprintf(stderr,
> -				"mount error: %s filesystem not supported by the system\n", fstype);
> +				"mount error: %s filesystem not supported by the system\n", cifs_fstype);
>  			break;
>  		case ENXIO:
>  			if (!already_uppercased &&
> @@ -2163,7 +2110,7 @@ do_mtab:
>  				goto mount_exit;
>  		}
>  
> -		rc = add_mtab(orig_dev, mountpoint, parsed_info->flags, fstype);
> +		rc = add_mtab(orig_dev, mountpoint, parsed_info->flags, cifs_fstype);
>  	}
>  
>  mount_exit:

Committed...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
