From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/1] fs/cifs/dir.c: use correct path separators
Date: Mon, 12 Sep 2016 19:36:29 +0100
Message-ID: <1473705389.29354.20.camel@redhat.com>
References: <1473255952-27579-1-git-send-email-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473255952-27579-1-git-send-email-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks Aurelien. Comments below.

On Wed, 2016-09-07 at 15:45 +0200, Aurelien Aptel wrote:
> When a prefix path needs to be added, current code hardcodes the
> initial
> path separator to backslash. Use CIFS_DIR_SEP instead and properly
> convert path separator in the prefix path.
> 
> CIFS_MOUNT_USE_PREFIX_PATH is rarely needed (Windows shares with very
> specific ACL or buggy mount call AFAIK) which explains why the
> backsplash wasn't a big issue.
> 
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/dir.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 4716c54..c85a8bb 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -160,13 +160,15 @@ cifs_bp_rename_retry:
>  
>  	if (pplen) {
>  		int i;
> +		char oldsep = dirsep == '/' ? '\\' : '/';
>  
>  		cifs_dbg(FYI, "using cifs_sb prepath <%s>\n",
> cifs_sb->prepath);
> +
> +		full_path[dfsplen] = dirsep;
>  		memcpy(full_path+dfsplen+1, cifs_sb->prepath, pplen-
> 1);
> -		full_path[dfsplen] = '\\';
> -		for (i = 0; i < pplen-1; i++)
> -			if (full_path[dfsplen+1+i] == '/')
> -				full_path[dfsplen+1+i] =
> CIFS_DIR_SEP(cifs_sb);
> +		for (i = 1; i < pplen; i++)
> +			if (full_path[dfsplen+i] == oldsep)
> +				full_path[dfsplen+i] = dirsep;

We have an inline helper convert_delimiter() which already does this.
The block for dfsplen also seems to repeat the code. 

Can we use the  helper for the complete patch instead when the
full_path variable is available?
I think the code here for copying the treename and the prefixpath name
can also be cleaned to make it easier to read ie. move the treeName
copy before we copy over the prefix path.

Sachin Prabhu

>  	}
>  
>  	if (dfsplen) {
