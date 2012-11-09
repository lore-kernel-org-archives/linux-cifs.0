From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cifs-next] fs: cifs: make smb_echo_interval tunable
Date: Fri, 9 Nov 2012 06:00:17 -0500
Message-ID: <20121109060017.63811198@tlielax.poochiereds.net>
References: <1352407828-23339-1-git-send-email-chris.j.arges@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352407828-23339-1-git-send-email-chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu,  8 Nov 2012 14:50:28 -0600
Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:

> Change SMB_ECHO_INTERVAL to make it a module parameter.
> 
> BugLink: http://bugs.launchpad.net/bugs/1017622
> BugLink: https://bugzilla.samba.org/show_bug.cgi?id=9006
> 

It's customary to write up the reason for a change in the bug
description. A pointer to a bug tracker is nice as a reference, but
it's not reasonable to expect someone to chase down a bunch of bug
tracker links when reading the git logs. It's also possible that
these bug reports could go away or be unavailable when someone needs
to track down the reason for a change.

> Reported-by: Oliver Dumschat-Hoette <dumschat-hoette-cpG9vB2psbIb1SvskN2V4Q@public.gmane.org>
> Signed-off-by: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c   |    5 +++++
>  fs/cifs/cifsglob.h |    5 +++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 5e62f44..25748b3 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -82,6 +82,11 @@ MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
>  module_param(enable_oplocks, bool, 0644);
>  MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
>  
> +unsigned short smb_echo_timeout = 60;
> +module_param(smb_echo_timeout, ushort, 0644);
> +MODULE_PARM_DESC(smb_echo_timeout, "Timeout between two echo requests. "
> +				   "Default: 60. Timeout in seconds ");
> +
>  extern mempool_t *cifs_sm_req_poolp;
>  extern mempool_t *cifs_req_poolp;
>  extern mempool_t *cifs_mid_poolp;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f5af252..d64dcd3 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -78,8 +78,9 @@
>  /*           (max path length + 1 for null) * 2 for unicode    */
>  #define MAX_NAME 514
>  
> -/* SMB echo "timeout" -- FIXME: tunable? */
> -#define SMB_ECHO_INTERVAL (60 * HZ)
> +/* SMB echo "timeout" */
> +extern unsigned short smb_echo_timeout;
> +#define SMB_ECHO_INTERVAL (smb_echo_timeout * HZ)
>  
>  #include "cifspdu.h"
>  

I'm not so sure I like making this tunable...

What would really be better is fixing the code to only echo when there
are outstanding calls to the server.

This also seems like a bit of a kludgy workaround for the real problem.
>From looking over the bug reports, it sounds like the real issue is
that the server is timing out the connection while the client is
suspended. It then has to wait until the next echo comes around to
figure that out. Is that the case?

If so, then I think what you really want here is a way to tell if the
connection is still valid after resume. Perhaps there's some way to
force an immediate SMB echo on these connections after resume? With
that, there'd be little delay at all in contacting the server after a
resume. The server would presumably send back a RST immediately in such
a case and we could get on with the business of reconnecting.

The cifs_demultiplex_thread does make some calls to try_to_freeze().
Perhaps checking the return value on those and kicking off an immediate
echo if it returns true would be a better solution?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
