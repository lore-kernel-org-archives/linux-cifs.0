From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Wed, 20 Nov 2013 23:37:43 -0800
Message-ID: <20131121073743.GA22312@infradead.org>
References: <CAH2r5msTi=keXhjob1F9fxTSR8AVAAzR5PZKHqHXaf6WAdqTpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msTi=keXhjob1F9fxTSR8AVAAzR5PZKHqHXaf6WAdqTpg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 20, 2013 at 09:54:21PM -0600, Steve French wrote:
> Small set of changes this time.  As promised, the finish up of
> the copy offload support, and a small security feature for SMB3
> needed to prevent certain types of downgrade attacks.
> 
> The following changes since commit 2d3c627502f2a9b0a7de06a5a2df23
> 65542a72c9:

NAK.  Multiple people have told you you should not abuse the btrfs
reflink ioctl for the semantically different cifs copy offloading.
