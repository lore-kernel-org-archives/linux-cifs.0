From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [autofs] [PATCH 00/17] Introduce automounter dentry ops
Date: Fri, 01 Oct 2010 09:31:44 +0100
Message-ID: <8948.1285921904@redhat.com>
References: <4CA59482.1040508@bononline.nl> <20100930181455.30939.53914.stgit@warthog.procyon.org.uk>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, autofs-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stef Bon <stef-/E4qUF3RmbfcqV2Q6a4srg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CA59482.1040508-/E4qUF3RmbfcqV2Q6a4srg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Stef Bon <stef-/E4qUF3RmbfcqV2Q6a4srg@public.gmane.org> wrote:

> Cifs is the target filesystem, and handled by the automounter, thus the
> automounter is the initiator, not cifs.
> 
> As you describe it (well it looks like it, I may not understand...) cifs is
> the initiator, and the patches to the automounter make autofs handle cifs
> requests handle better?

CIFS has DFS referrals, by which one point in a CIFS mount can refer you to a
point in another volume, possibly on another server.  Linux automatically
mounts the referred volume on the directory corresponding to the referral when
you try and cross into it.

AFS and NFS do similar things.

David
