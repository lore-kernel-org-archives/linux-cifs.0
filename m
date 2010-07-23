From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-next: manual merge of the workqueues tree with the Linus' tree
Date: Fri, 23 Jul 2010 13:05:54 +0100
Message-ID: <19175.1279886754@redhat.com>
References: <20100723144600.dd4da992.sfr@canb.auug.org.au>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100723144600.dd4da992.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:

> Today's linux-next merge of the workqueues tree got a conflict in
> fs/cifs/cifsfs.c between commit 4c0c03ca54f72fdd5912516ad0a23ec5cf01bda7
> ("CIFS: Fix a malicious redirect problem in the DNS lookup code") from
> Linus' tree and commit 9b646972467fb5fdc677f9e4251875db20bdbb64 ("cifs:
> use workqueue instead of slow-work") from the workqueues tree.
> 
> I fixed it up (I think - I removed the call to cifs_exit_dns_resolver()
> as there is no way to get to that code any more) and can carry the fix
> for a while.

Looks right.

David
