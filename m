From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH V2 3/3] cifs: Add CONFIG_CIFS_DEBUG and rename use of
	CIFS_DEBUG
Date: Fri, 30 Nov 2012 10:39:45 -0500
Message-ID: <20121130103945.14d8b143@tlielax.poochiereds.net>
References: <cover.1354217746.git.joe@perches.com>
	<5f5c9196b44908026a27333ef31dd4ebf4314de2.1354217746.git.joe@perches.com>
	<20121130065629.52c489dc@tlielax.poochiereds.net>
	<1354287460.11903.8.camel@joe-AO722>
	<20121130100705.782980df@tlielax.poochiereds.net>
	<1354289516.11903.15.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1354289516.11903.15.camel@joe-AO722>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 30 Nov 2012 07:31:56 -0800
Joe Perches <joe@perches.com> wrote:

> On Fri, 2012-11-30 at 10:07 -0500, Jeff Layton wrote:
> > On Fri, 30 Nov 2012 06:57:40 -0800
> > Joe Perches <joe@perches.com> wrote:
> > > On Fri, 2012-11-30 at 06:56 -0500, Jeff Layton wrote:
> > > > On Thu, 29 Nov 2012 11:37:20 -0800
> > > > Joe Perches <joe@perches.com> wrote:
> > > > > Rather than havign a permanently enabled #define, allow
> > > > > control over it.
> > > > > 
> > > > > This can reduce the size of the module by ~100KB which
> > > > > could be useful for embedded systems.
> > > []
> > > > > diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> > > > > index 4d12fe4..6867a7f 100644
> > > > > --- a/fs/cifs/cifs_debug.h
> > > > > +++ b/fs/cifs/cifs_debug.h
> > > > > @@ -18,7 +18,10 @@
> > > > >   *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> > > > >   *
> > > > >  */
> > > > > -#define CIFS_DEBUG		/* BB temporary */
> > > > > +
> > > > > +#ifdef CONFIG_CIFS_DEBUG
> > > > > +#define CIFS_DEBUG
> > > > > +#endif
> > > > >  
> > > > >  #ifndef _H_CIFS_DEBUG
> > > > >  #define _H_CIFS_DEBUG
> > > > 
> > > > Looks fine, but I'd probably prefer to just get rid of CIFS_DEBUG
> > > > altogether here and replace it with CONFIG_CIFS_DEBUG.
> > > 
> > > I wasn't sure if there was other code anywhere else that depends
> > > on CIFS_DEBUG.  There isn't any in the kernel source tree.  If not,
> > > then you are right, it should be just CONFIG_CIFS_DEBUG.
> > There shouldn't be. None of this stuff is exposed to userspace, AFAIK.
> > I think it's ok to just make that CONFIG_CIFS_DEBUG.
> > 
> > > > While you're at it, /proc/fs/cifs/cifsFYI should probably not be
> > > > present when CONFIG_CIFS_DEBUG isn't set. Perhaps we should also
> > > > disable traceSMB and its related functions too in that case?
> > > 
> > > That could be considered a kernel api change.
> > > If people agree to delete it, I'd be OK with it.
> > > 
> > 
> > If you compile with CONFIG_CIFS_DEBUG turned off, then the cifsFYI file
> > will be a knob that's not hooked up to anything. I think it's best not
> > to present it at all in that case.
> 
> If there's a userspace script that does
> echo 1 > /proc/fs/cifs/cifsFYI
> it'd now get a file not found error.
> 

It probably should fail since it wouldn't get the results it was
looking for anyway...

> > traceSMB is a little harder to make the case for. Theoretically, it'll
> > still work after your changes, but I'm not sure it makes sense to leave
> > that knob around since it's technically a flag for debugging. You're
> > probably fine not to worry about that one. I'll look at that at some
> > point in the future.
> 
> This could be changed in a separate patch if appropriate.
> Here's the modified patch.
> 
> From: Joe Perches <joe@perches.com>
> 
> This can reduce the size of the module by ~120KB which
> could be useful for embedded systems.
> 
> $ size fs/cifs/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  388567	  34459	 100440	 523466	  7fcca	fs/cifs/built-in.o.new
>  495970	  34599	 117904	 648473	  9e519	fs/cifs/built-in.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/cifs/Kconfig      |   10 +++++++++-
>  fs/cifs/cifs_debug.h |    3 +--
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index 2075ddf..21ff76c 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -122,9 +122,17 @@ config CIFS_ACL
>  	    Allows fetching CIFS/NTFS ACL from the server.  The DACL blob
>  	    is handed over to the application/caller.
>  
> +config CIFS_DEBUG
> +	bool "Enable CIFS debugging routines"
> +	default y
> +	depends on CIFS
> +	help
> +	   Enabling this option adds helpful debugging messages to
> +	   the cifs code which increases the size of the cifs module.
> +	   If unsure, say Y.
>  config CIFS_DEBUG2
>  	bool "Enable additional CIFS debugging routines"
> -	depends on CIFS
> +	depends on CIFS_DEBUG
>  	help
>  	   Enabling this option adds a few more debugging routines
>  	   to the cifs code which slightly increases the size of
> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> index 4d12fe4..86e92ef 100644
> --- a/fs/cifs/cifs_debug.h
> +++ b/fs/cifs/cifs_debug.h
> @@ -18,7 +18,6 @@
>   *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>   *
>  */
> -#define CIFS_DEBUG		/* BB temporary */
>  
>  #ifndef _H_CIFS_DEBUG
>  #define _H_CIFS_DEBUG
> @@ -44,7 +43,7 @@ extern int cifsERROR;
>   *	debug ON
>   *	--------
>   */
> -#ifdef CIFS_DEBUG
> +#ifdef CONFIG_CIFS_DEBUG
>  
>  /* information message: e.g., configuration, major event */
>  #define cifsfyi(fmt, ...)						\

Yep, fair enough, we can move the cifsFYI file under CONFIG_CIFS_DEBUG
in a separate patch.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
