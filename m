From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Parsing for obsolete mount options
Date: Mon, 28 Feb 2011 13:45:06 -0500
Message-ID: <20110228134506.71e840b1@corrin.poochiereds.net>
References: <AANLkTikpA7=G=5y075-jWfMUfKDj=w6URfi_hyYVnbp2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikpA7=G=5y075-jWfMUfKDj=w6URfi_hyYVnbp2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 26 Feb 2011 12:08:23 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I was trying to figure out a way to parse for mount options which are
> obsolete for smb2 (but valid for cifs), but without an "-t smb2" fs
> type it is harder.    Jeff had preferred (rather than a "-t smb2" file
> type) that we call smb2 a "version" of cifs, and by analogy with nfs
> ("nfsvers=2",  "nfsvers=4" etc.) specify a "vers=smb2" or "vers=2" to
> indicate mounting with experimental smb2 is desired ... but to be able
> to parse mount options which are now obsolete (for smb2) we have to
> scan the whole mount option string, looking for "vers=2" (or
> equivalent) first, then either call a (new) smb2_parse_mount_options
> function, or flag them in the current cifs_parse_mount_options when we
> detect a "vers=2"  - by the time we get out of
> cifs_parse_mount_options it is too late because we don't know which
> mount options the user specified explicitly (and which we got from
> defaults).
> 
> As a summary of some of the mount differences:
> 1) sec=ntlm (and sec=lanman) is no longer going to be valid (ntlmv2
> and krb5 only)
> 2) noblocksend and noautotune probably no longer needed
> 3) posixpaths/noposixpaths no longer needed
> 4) noserverino not valid
> 5) sockopt may not be needed (nodelay can be defaulted)
> 

Probably, the best thing is to do this in 2 phases:

1) parse the mount options to the best of your ability

2) check the result and see whether they make sense

Autonegotiation will make the second part interesting though since you
might not know the version until later. In that case, you probably will
just have to ignore options that don't have any effect on the version
negotiated.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
