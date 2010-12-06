From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: Add information about noserverino
Date: Mon, 06 Dec 2010 12:27:03 +0530
Message-ID: <4CFC893F.3050104@suse.de>
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernhard Walle <bernhard-X9USDgGjgfuzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291568855-22604-1-git-send-email-bernhard-X9USDgGjgfuzQB+pC5nmwQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/05/2010 10:37 PM, Bernhard Walle wrote:
> In my case I had the problem that 32 bit userspace applications in an
> amd64 environment was not able to list the directories of a CIFS-mounted
> share. The simple userspace code
> 
>     int main(int argc, char *argv[])
>     {
>         DIR *dir;
>         struct dirent *dirent;
> 
>         if (!argv[1]) {
>             fprintf(stderr, "Usage: %s <directory>\n", argv[0]);
>             return -1;
>         }
> 
>         dir = opendir(argv[1]);
>         if (!dir) {
>             perror("Unable to open directory");
>             return -1;
>         }
> 
>         while ((dirent = readdir(dir)) != NULL)
>             puts(dirent->d_name);
> 
>         closedir(dir);
> 
>         return 0;
>     }
> 
> was sufficient to trigger the problem.
> 
> I discovered that the problem was that the inodes were too large to fit
> in a 32 bit (unsigned long) integer, so the compat_filldir() function
> returned -EOVERFLOW.
> 
> While that is okay it would have saved me a some hours of debugging if
> the message below would have appeared in my kernel log.
> 
> The target was a Samba server (I guess) of a Buffalo LinkStation Duo
> with the unmodified vendor firmware 1.34.
> 
> Signed-off-by: Bernhard Walle <bernhard-X9USDgGjgfuzQB+pC5nmwQ@public.gmane.org>
> ---
>  fs/cifs/readdir.c |   23 +++++++++++++++++++----
>  1 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index d5e591f..d979826 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -773,6 +773,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>  	char *tmp_buf = NULL;
>  	char *end_of_smb;
>  	unsigned int max_len;
> +	int err;
>  
>  	xid = GetXid();
>  
> @@ -783,17 +784,31 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>  
>  	switch ((int) file->f_pos) {
>  	case 0:
> -		if (filldir(direntry, ".", 1, file->f_pos,
> -		     file->f_path.dentry->d_inode->i_ino, DT_DIR) < 0) {
> +		err = filldir(direntry, ".", 1, file->f_pos,
> +		     file->f_path.dentry->d_inode->i_ino, DT_DIR);
> +		if (err < 0) {
>  			cERROR(1, "Filldir for current dir failed");
> +			if (err == -EOVERFLOW) {
> +				cERROR(1, "Server inodes are too large for 32 "
> +						"bit userspace. You might "
> +						"consider using 'noserverino' "
> +						"mount option for this mount.");
> +			}

The patch looks good, however I don't see any reason why we need to
override the returned error with -ENOMEM below. I think we could
possibly use the variable 'rc' itself and set the error code as is.

>  			rc = -ENOMEM;
>  			break;
>  		}
>  		file->f_pos++;
>  	case 1:
> -		if (filldir(direntry, "..", 2, file->f_pos,
> -		     file->f_path.dentry->d_parent->d_inode->i_ino, DT_DIR) < 0) {
> +		err = filldir(direntry, "..", 2, file->f_pos,
> +		     file->f_path.dentry->d_parent->d_inode->i_ino, DT_DIR);
> +		if (err < 0) {
>  			cERROR(1, "Filldir for parent dir failed");
> +			if (err == -EOVERFLOW) {
> +				cERROR(1, "Server inodes are too large for 32 "
> +						"bit userspace. You might "
> +						"consider using 'noserverino' "
> +						"mount option for this mount.");
> +			}
>  			rc = -ENOMEM;
>  			break;
>  		}


-- 
Suresh Jayaraman
