From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] cifs: Rename cERROR and cFYI to cifs_dbg
Date: Fri, 15 Mar 2013 14:56:29 -0400
Message-ID: <20130315145629.2e1a04c5@tlielax.poochiereds.net>
References: <1363128287.23052.21.camel@joe-AO722>
	<1363174614.2031.9.camel@joe-AO722>
	<20130313075155.7464a34a@tlielax.poochiereds.net>
	<1363178421.2031.29.camel@joe-AO722>
	<1363289077.2146.19.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1363289077.2146.19.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 14 Mar 2013 12:24:37 -0700
Joe Perches <joe@perches.com> wrote:

> It's not obvious from reading the macro names that these macros
> are for debugging.  Convert the names to a single more typical
> kernel style cifs_dbg macro.
> 
> 	cERROR(1, ...)   -> cifs_dbg(VFS, ...)
> 	cFYI(1, ...)     -> cifs_dbg(FYI, ...)
> 	cFYI(DBG2, ...)  -> cifs_dbg(NOISY, ...)
> 
> Move the terminating format newline from the macro to the call site.
> 
> Add CONFIG_CIFS_DEBUG function cifs_vfs_err to emit the
> "CIFS VFS: " prefix for VFS messages.
> 
> Size is reduced ~ 1% when CONFIG_CIFS_DEBUG is set (default y)
> 
> $ size fs/cifs/cifs.ko*
>    text    data     bss     dec     hex filename
>  265245	   2525	    132	 267902	  4167e	fs/cifs/cifs.ko.new
>  268359    2525     132  271016   422a8 fs/cifs/cifs.ko.old
> 


This all looks like good stuff. I am a bit concerned about mashing all
of these cleanups into the same patch though.
> Other miscellaneous changes around these conversions:
> 
> o Miscellaneous typo fixes
> o Add terminating \n's to almost all formats and remove them
>   from the macros to be more kernel style like.  A few formats
>   previously had defective \n's
> o Remove unnecessary OOM messages as kmalloc() calls dump_stack
> o Coalesce formats to make grep easier,
>   added missing spaces when coalescing formats
> o Use %s, __func__ instead of embedded function name
> o Removed unnecessary "cifs: " prefixes
> o Convert kzalloc with multiply to kcalloc
> o Remove unused cifswarn macro
> 


-- 
Jeff Layton <jlayton@redhat.com>
