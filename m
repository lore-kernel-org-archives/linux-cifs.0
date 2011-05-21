From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Sat, 21 May 2011 06:31:05 -0400
Message-ID: <20110521103105.GA20409@infradead.org>
References: <BANLkTin1aphq5JHJkTOVjgSAaPWWYBuYYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTin1aphq5JHJkTOVjgSAaPWWYBuYYw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, May 20, 2011 at 12:41:33PM -0500, Steve French wrote:
> Sent the following request up, but plan to send another big set of
> changes up with Jeff's aync set (would like help reviewing patches 3,
> 5 and 6 in particular of Jeff's set) and some of Pavel's SMB2 prep
> patches in a few days.

Steve, as said numours times before: please don't introduce the half
baked smb2 bits into mainline yet.  Prepare a separate git tree that
can actually be reviewed properly for it.
