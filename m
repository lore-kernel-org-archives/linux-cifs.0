From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: fixes for manpage pathname replacement
 scheme
Date: Tue, 28 Dec 2010 09:20:56 -0500
Message-ID: <20101228092056.6bfaa34e@tlielax.poochiereds.net>
References: <1292346329-31009-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292346329-31009-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Dec 2010 12:05:29 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Fix up some small problems with pathname replacement:
> 
> 1) replace the bare 'sed' with $(SED)
> 
> 2) '\@' is apparently not portable, so we need to use a different scheme
>    in case we end up using a non-typical sed binary.
> 
> 3) do the sed conversion to a new file and then move it into place. If
>    sed falls down halfway through the conversion we could end up with
>    a half-baked manpage.
> 
> 4) use the $@ construct for brevity and maintainability
> 
> 5) add a comment so that the rationale behind this is explained
> 
> Many thanks to several folks inside Red Hat who pointed out these
> issues.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  Makefile.am |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 

Patch pushed to master branch.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
