From: Valerie Aurora <vaurora-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 07/17] Make dentry::d_mounted into a more general field for special function dirs
Date: Fri, 8 Oct 2010 19:57:42 -0400
Message-ID: <20101008235741.GF30846@shell>
References: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk> <20100930181531.30939.10438.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	autofs-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100930181531.30939.10438.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Sep 30, 2010 at 07:15:31PM +0100, David Howells wrote:
> Make the d_mounted field in struct dentry into a more general field for special
> function directories such as mountpoints and autofs substructures.
> 
> d_mounted is renamed d_managed, and that is split into three fields:
> 
>  (*) #define DMANAGED_MOUNTPOINT	0x0fffffff

No matter how hard I try, I always read this as "DAMAGED".  Which I
can't help but imagine subliminally influences the reader's opinion of
the patches.

Of course I am excellent at naming things, see "chunkfs" and
"relatime".  But some ideas for naming various concepts in this patch:

D_MIGHT_MOUNT
D_CHILL_OUT
D_ITS_COMPLICATED

-VAL
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
