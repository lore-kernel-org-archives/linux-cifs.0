From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Use mkstemp instead of mktemp
Date: Sat, 28 Apr 2012 07:14:54 -0400
Message-ID: <20120428071454.011adbda@tlielax.poochiereds.net>
References: <1335539568-32024-1-git-send-email-gitter.spiros@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335539568-32024-1-git-send-email-gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 27 Apr 2012 11:12:48 -0400
Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> As described in the manual page mktemp(3) the use of this function
> is strongly discouraged in favor of mkstemp(3).
> 
> In fact the mkstemp() function generates a unique temporary file
> name from the supplied template,
> opens a file of that name using the O_EXCL flag (guaranteeing the
> current process to be the only user) and returns a file descriptor.
> 
> The file is then created with mode read/write and permissions 0666 (glibc 2.0.6 and earlier),
> 0600 (glibc 2.0.7 and later).
> 
> But for portability the POSIX specification does not say anything about file modes,
> so the application should make sure its umask is set appropriately before calling mkstemp.
> ( ref. https://buildsecurityin.us-cert.gov/bsi/articles/knowledge/coding/781-BSI.html)
> 
> In this case we set umask to 033 before calling mkstemp
> and after we reset the original umask.
> 
> Signed-off-by: Elia Pinto <gitter.spiros-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> This is the second version of the patch. I have
> tried to follow the Jeff indication
> http://article.gmane.org/gmane.linux.kernel.cifs/5988
> 
> 
>  mount.cifs.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index c90ce3e..1cdaf38 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1627,6 +1627,7 @@ del_mtab(char *mountpoint)
>  	FILE *mnttmp, *mntmtab;
>  	struct mntent *mountent;
>  	char *mtabfile, *mtabdir, *mtabtmpfile;
> +	mode_t mode;
>  
>  	mtabfile = strdup(MOUNTED);
>  	mtabdir = dirname(mtabfile);
> @@ -1652,12 +1653,14 @@ del_mtab(char *mountpoint)
>  		goto del_mtab_exit;
>  	}
>  
> -	mtabtmpfile = mktemp(mtabtmpfile);
> -	if (!mtabtmpfile) {
> -		fprintf(stderr, "del_mtab: cannot setup tmp file destination");
> -		rc = EX_FILEIO;
> -		goto del_mtab_exit;
> +	mode = umask(0077);

Looks like you're still setting the umask to 0077 here?

> +	if (close(mkstemp(mtabtmpfile)) == -1 ) {
> +			fprintf(stderr, "del_mtab: cannot setup tmp file destination");
> +			(void)umask(mode);

You probably don't really need to reset the umask on error, but I guess
it doesn't really hurt...

> +			rc = EX_FILEIO;
> +			goto del_mtab_exit;
>  	}
> +	(void)umask(mode);
>  
>  	mntmtab = setmntent(MOUNTED, "r");
>  	if (!mntmtab) {

Now that I look at that us-cert page though, I'm not sure you're really
making anything safer with this patch...

AFAICT, the thing that makes mkstemp safer than mktemp is the fact that
the filename generation and open are atomic. If you use mkstemp here
and then just close the file afterward, aren't you still subject to the
same set of races that you are with mktemp?

In fact, it seems like this is even worse, really. With this, you're
creating the file and then reopening it. Within that window of time,
an attacker now has some idea of what file you plan to use here
whereas he didn't really before...

I think what might be better is to continue to use mktemp, but do the
setmntent call with a type value of "wx" to make it use an exclusive
open. If that fails with EEXIST, we should call mktemp again and try
again until it succeeds. Of course, not all libc's will take "x" as an
arg there, so you may need an autoconf test to verify that that will
work...

An alternate approach might be to use mkstemp and fdopen, and then
simply use the resulting FILE pointer in the addmntent calls. From a
quick look at glibc, it looks like setmntent is basically a wrapper
around fopen anyway, but that may not be universally true in all
libc's. Hmm...now that I look though, glibc extends the fopen mode with
"ce" too and you'd probably want to do the same. So you might still
need an autoconf test for that anyway...

Either way, this code should probably be moved to a separate helper
function that does this for del_mtab instead of open-coding it there.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
