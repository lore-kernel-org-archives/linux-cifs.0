From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] manpage: update mount.cifs manpage with info about
 incomplete options
Date: Fri, 08 Dec 2017 09:03:08 -0500
Message-ID: <1512741788.3961.7.camel@samba.org>
References: <201712081511450916550@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: zhang.xianwei8-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201712081511450916550-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2017-12-08 at 15:11 +0800, zhang.xianwei8-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org wrote:
> This commit a1f3acd40b265f134a97a739a6898b3958d206b9 modified mount
> parameters, but not updated mount.cifs manpage. Fix it.
> 
> Signed-off-by: Zhang Xianwei <zhang.xianwei8-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> ---
> mount.cifs.rst | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index 023ff34..a4445b8 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -48,7 +48,7 @@ OPTIONS
> *******
> 
> 
> -username=arg
> +username=arg|user=arg
> specifies the username to connect as. If this is not
> given, then the environment variable USER is used.
> 
> @@ -64,7 +64,7 @@ username=arg
> non-superuser mount. It is therefore recommended to use the full
> ``username=`` option name.
> 
> -password=arg
> +password=arg|pass=arg
> specifies the CIFS password. If this option is not given then the
> environment variable PASSWD is used. If the password is not specified
> directly or indirectly via an argument to mount, mount.cifs will
> @@ -76,7 +76,7 @@ password=arg
> variable or via a credentials file (see below) or entered at the
> password prompt will be read correctly.
> 
> -credentials=filename
> +credentials=filename|cred=filename
> specifies a file that contains a username and/or password and
> optionally the name of the workgroup. The format of the file is::
> 
> @@ -159,12 +159,12 @@ dir_mode=arg
> If the server does not support the CIFS Unix extensions this overrides
> the default mode for directories.
> 
> -ip=arg
> +ip=arg|addr=arg
> sets the destination IP address. This option is set automatically if
> the server name portion of the requested UNC name can be resolved so
> rarely needs to be specified by the user.
> 
> -domain=arg
> +domain=arg|dom=arg|workgroup=arg
> sets the domain (workgroup) of the user.
> 
> guest

Honestly, I'd really prefer to move this in the other direction and have
the kernel/userland programs stop accepting some of these aliases. They
don't add anything to usability and they are a long-term maintenance
burden.

We'd probably need a 2-3 releases where we accept the aliases and throw
a warning when someone tries to use them. Then we can just rip out
support for them.

That said, if the consensus is to keep the aliases in, then I'll just
plan to merge this patch.

Anyone have thoughts on this?
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
