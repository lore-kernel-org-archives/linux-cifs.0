From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: should we propagate SMB error codes further?
Date: Thu, 21 Nov 2013 12:29:10 -0600
Message-ID: <CAH2r5msHhZAfk_xZaMpz6ZJ94Fv1yQ_Wd1cnWEqEjQteeSd-Tw@mail.gmail.com>
References: <20131120081334.GA21566@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131120081334.GA21566-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 20, 2013 at 2:13 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> I'm seeing same interesting errors running against a server from a big
> NAS vendor that shall remain unnamed:
>
> p224160.955651] CIFS VFS: Unexpected lookup error -5
> [224161.298853] CIFS VFS: Unexpected lookup error -5
> [224161.643559] CIFS VFS: Unexpected lookup error -5
> [224161.992309] CIFS VFS: Unexpected lookup error -5
> [224162.333310] CIFS VFS: Unexpected lookup error -5
> [224162.677982] CIFS VFS: Unexpected lookup error -5
>
> Unfortunately it seems like a EIO is the catchall for unknown SMB
> errors, so trying to debug this seems a bit hard.  Should we maybe look
> into propagating the SMB error codes further up the chain inside the
> cifs driver instead of converting them at a fairly low level?
>

I wish we could extend the POSIX-like errors that the
kernel tolerates further (it is especially painful on mount where
a few more return codes would make life easier for
returning more specific mount errors, and I find it even harder on NFS
so it is not just cifs which suffers from wanting more error codes
to send back)

For your use case, you might try turning on the status code logging by
setting the CIFS_RC flag in the cifs debug flags at runtime
(unfortunately they are global not per-process).

"echo 2 > /proc/fs/cifs/cifsFYI"

Then you will see most of the nt status codes logged before they
are remapped.

e.g.
[ 9830.513514] Status code returned 0xc0000016
NT_STATUS_MORE_PROCESSING_REQUIRED
[ 9830.562929] Status code returned 0xc0000225 NT_STATUS_NOT_FOUND

(Maximal logging can be done by "echo 7 > /proc/fs/cifs/cifsFYI" which also
enables logging of CIFS_INFO and CIFS_TIMER events)

-- 
Thanks,

Steve
