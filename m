From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Convert slashes in the UNC parameter to backslashes
Date: Wed, 7 Nov 2012 10:48:53 -0500
Message-ID: <20121107104853.12935810@tlielax.poochiereds.net>
References: <509902BB.6020400@innominate.com>
	<20121107070239.1140fe68@tlielax.poochiereds.net>
	<509A7C36.8080800@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sjayaraman-IBi9RG/b67k@public.gmane.org
To: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <509A7C36.8080800-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 07 Nov 2012 16:20:22 +0100
Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org> wrote:

> Here the corrected (and tested) version.
> 
> Jeff: I agree with you regarding removing the UNC parameter altogether. 
> Is there any scenario in which an UNC parameter could differ from the 
> specified source parameter?
> 
> Regards,
> Fred
> 

I suppose someone could provide their own unc= option that differs from
the device name. At that point, the device name in /proc/mounts (and in
programs like "df") might look like you've mounted one location when in
reality you've mounted another.

That doesn't seem like a valid use-case to me though. It's probably
best that we discourage such abuse ;).

The tricky part is how to get there from here. The mount helper
provides this option pretty much unconditionally, though it generally
generates it from the device string. Maybe something like this?

1) fix the kernel to parse a copy of the UNC out of the device string

2) compare that UNC to the one provided by the unc= option

3) if they differ, then printk a warning that mentions that there is a
discrepancy and that the kernel is going to use the value of the unc=
option for now, but that we'll change that default in two releases.

Something like:

"CIFS VFS: the unc= mount option differs from the device passed in. Using
the value of the unc= option. The kernel will begin preferring the value
in the device string in 3.10!"

Then, have a patch ready to go for the 3.10 merge window that will make
the kernel start ignoring the value of the unc= option. You might even
be nice and keep the comparison and warning around for a little while,
but switch it to mention that the kernel is going to ignore the value
of the unc= option when there is a discrepancy.

In another few releases, we can then get rid of the warning and
comparison too.

Sound reasonable?

> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 5c670b9..c52faf8 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1574,11 +1574,9 @@ cifs_parse_mount_options(const char *mountdata, 
> const char *devname,
>                                  goto cifs_parse_mount_err;
>                          }
>                          strcpy(vol->UNC, string);
> +                       convert_delimiter(vol->UNC, '\\');
> 
> -                       if (strncmp(string, "//", 2) == 0) {
> -                               vol->UNC[0] = '\\';
> -                               vol->UNC[1] = '\\';
> -                       } else if (strncmp(string, "\\\\", 2) != 0) {
> +                       if (strncmp(vol->UNC, "\\\\", 2) != 0) {
>                                  printk(KERN_WARNING "CIFS: UNC Path 
> does not "
>                                                      "begin with // or 
> \\\\\n");
>                                  goto cifs_parse_mount_err;
> 
> 
> 

Looks reasonable. You can add my Reviewed-by. You should probably
resend it with a real "Signed-off-by:" line.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
