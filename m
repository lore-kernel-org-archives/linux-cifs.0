From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: smb2 work status
Date: Mon, 18 Jul 2011 11:47:30 -0400
Message-ID: <20110718154730.GA5822@infradead.org>
References: <CAKywueQqyi6ynwoAv6Q3GzbxYJSOv7k229N3NA_y05kguqA+DQ@mail.gmail.com>
 <CAKywueRiuj=DrumdGMvdWX6ih8PVz4L0BL7G=LNL6CO+cEfmTQ@mail.gmail.com>
 <20110716192811.GE26925@infradead.org>
 <CAKywueSP7p3pja6FociCPXDtcSuChDdHw1JqCwxyhnqMuP5ahg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKywueSP7p3pja6FociCPXDtcSuChDdHw1JqCwxyhnqMuP5ahg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 18, 2011 at 07:45:01PM +0400, Pavel Shilovsky wrote:
> If I understand you right, you mean to separate inode and file
> operations for smb2 into a different structures, set them once with
> ifdefs in cifs_set_ops() and keep them in smb2inode.c and smb2file.c
> files.

That's the idea.  You'll really have to prototype it to check if it
works out nicely.  If we end up duplicating too much it might not
be feasible, but fro ma quick look it should be much better.
