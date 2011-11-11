From: Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] KEYS: Allow special keyrings to be cleared
Date: Fri, 11 Nov 2011 17:41:57 -0500
Message-ID: <1321051317.4810.17.camel@lade.trondhjem.org>
References: <20111111160753.5190.36069.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: jmorris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111111160753.5190.36069.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2011-11-11 at 16:07 +0000, David Howells wrote: 
> The kernel contains some special internal keyrings, for instance the DNS
> resolver keyring :
> 
> 2a93faf1 I-----     1 perm 1f030000     0     0 keyring   .dns_resolver: empty
> 
> It would occasionally be useful to allow the contents of such keyrings to be
> flushed by root (cache invalidation).
> 
> Allow a flag to be set on a keyring to mark that someone possessing the
> sysadmin capability can clear the keyring, even without normal write access to
> the keyring.
> 
> Set this flag on the special keyrings created by the DNS resolver, the NFS
> identity mapper and the CIFS identity mapper.
> 
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Steve Dickson <steved-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
www.netapp.com
