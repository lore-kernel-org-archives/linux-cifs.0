From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH][CIFS] fix SMB3 mount failure due to corrupted empty
 paths when mapchars option used
Date: Tue, 24 Jun 2014 13:07:15 +0200
Message-ID: <20140624130715.468a0558@f163.suse.de>
References: <CAH2r5mtX=ZyPm4JO7WH9uDo3nE_T4GP9h822EP8Ch=sbp2H1vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtX=ZyPm4JO7WH9uDo3nE_T4GP9h822EP8Ch=sbp2H1vA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks good Steve.

On Sun, 22 Jun 2014 20:49:57 -0500, Steve French wrote:

> When we SMB3 mounted with mapchars (to allow reserved characters : \ / > < * ?
> via the Unicode Windows to POSIX remap range) empty paths
> (eg when we open "" to query the root of the SMB3 directory on mount) were not
> null terminated so we sent garbarge as a path name on empty paths which caused
> SMB2/SMB2.1/SMB3 mounts to fail when mapchars was specified.  mapchars is
> particularly important since Unix Extensions for SMB3 are not supported (yet)
> 
> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
