From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: should we propagate SMB error codes further?
Date: Wed, 20 Nov 2013 00:13:34 -0800
Message-ID: <20131120081334.GA21566@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm seeing same interesting errors running against a server from a big
NAS vendor that shall remain unnamed:

p224160.955651] CIFS VFS: Unexpected lookup error -5
[224161.298853] CIFS VFS: Unexpected lookup error -5
[224161.643559] CIFS VFS: Unexpected lookup error -5
[224161.992309] CIFS VFS: Unexpected lookup error -5
[224162.333310] CIFS VFS: Unexpected lookup error -5
[224162.677982] CIFS VFS: Unexpected lookup error -5

Unfortunately it seems like a EIO is the catchall for unknown SMB
errors, so trying to debug this seems a bit hard.  Should we maybe look
into propagating the SMB error codes further up the chain inside the
cifs driver instead of converting them at a fairly low level?
