From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 21 Mar 2012 16:30:51 -0400
Message-ID: <20120321163051.0fa2c714@redhat.com>
References: <1331307197.10670.2.camel@localhost>
	<20120321133855.52901c60@redhat.com>
	<1332354787.2818.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332354787.2818.7.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 21 Mar 2012 18:33:07 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Wed, 2012-03-21 at 13:38 -0400, Jeff Layton wrote:
> > On Fri, 09 Mar 2012 15:33:17 +0000
> > Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > > Use the standard token parser instead of the long if confidtion to parse
> > > cifs mount options.
> > > 
> > > This was first proposed by Scott Lovenberg
> > > http://lists.samba.org/archive/linux-cifs-client/2010-May/006079.html
> > > 
> > > Mount options have been grouped together in terms of their input types.
> > > Aliases for username, password, domain and credentials have been added.
> > > The password parser has been modified to make it easier to read.
> > > 
> > > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > 
> > 
> > 
> > In testing this today, I found a problem. I tried to mount up a share
> > with sec=none as the options. With that, I got this error:
> > 
> >     CIFS: Unknown mount option pass=
> > 
> > The problem is that the mount.cifs helper will pass a blank "pass="
> > option to the kernel. It seems like the standard option parser doesn't
> > have a way to allow you to specify an optional argument. That may need
> > to be added in order for this to work.
> 
> 
> We could use it in this manner.
> 
> ----
> Allow mount option pass to be a blank value.
> 
> When using sec=none, the mount.cifs helper will pass a blank 'pass='
> mount option. This should be handled by the parser.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8f83ea0..831f242 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -107,6 +107,9 @@ enum {
>  	/* Mount options to be ignored */
>  	Opt_ignore,
>  
> +	/* Options which could be blank */
> +	Opt_blank_pass,
> +
>  	Opt_err
>  };
>  
> @@ -180,6 +183,7 @@ static const match_table_t cifs_mount_option_tokens = {
>  
>  	{ Opt_user, "user=%s" },
>  	{ Opt_user, "username=%s" },
> +	{ Opt_blank_pass, "pass=" },
>  	{ Opt_pass, "pass=%s" },
>  	{ Opt_pass, "password=%s" },
>  	{ Opt_ip, "ip=%s" },
> @@ -1546,6 +1550,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			}
>  			vol->nullauth = 0;
>  			break;
> +		case Opt_blank_pass:
> +			vol->password = NULL;
> +			break;
>  		case Opt_pass:
>  			/* passwords have to be handled differently
>  			 * to allow the character used for deliminator

ACK.

Since Steve hasn't committed this yet, care to send a respin of the
original? I don't think there are any others that require the ability
to handle a blank option, but we can always add that later if needed.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
