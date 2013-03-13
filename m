From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] cifs: Rename cERROR and cifserror to cifs_vfs_err
Date: Wed, 13 Mar 2013 04:36:54 -0700
Message-ID: <1363174614.2031.9.camel@joe-AO722>
References: <1363128287.23052.21.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363128287.23052.21.camel@joe-AO722>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2013-03-12 at 15:44 -0700, Joe Perches wrote:
> The cERROR macro is always used as cERROR(1, and cifserror
> is just a printk(KERN_ERR "CIFS VFS: ".
> 
> Make a cifs_vfs_err function that uses the vsprintf %pV
> extension to avoid duplicating the "CIFS VFS: " prefix.
> 
> Remove the cERROR macro and use cifs_vfs_err directly.

Perhaps a better idea than this patch is to
change both the cERROR and cFYI macros to
a new use of cifs_dbg(type, fmt, ...)

cERROR(set, fmt, ...)   -> cifs_dbg(VFS, fmt, ...)
cFYI(set, fmt, ...)     -> cifs_dbg(FYI, fmt, ...)

This conversion would mark both these macros
as debug stataments as they are only enabled
with CONFIG_CIFS_DEBUG.

Also CONFIG_CIFS_DEBUG2 use of DBG could also
be integrated with the same style.

cFYI(DBG2, fmt, ...)    -> cifs_dbg(NOISY, fmt, ...)

The reduced object size would still apply.

This would also enable an easier conversion to
dynamic debugging of these debug macros.

I'd prefer to move the newline from the macro
to the format as that is more consistent with
the rest of the kernel.

Thoughts?
