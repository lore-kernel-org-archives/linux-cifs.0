From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH -v6 3/4] cifs NTLMv2/NTLMSSP define crypto hash
 functions and create and send keys needed for key exchange
Date: Tue, 21 Sep 2010 16:42:57 -0700
Message-ID: <20100921164257.3d67598f@corrin.poochiereds.net>
References: <1284865355-16815-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100921105254.32574ba4@corrin.poochiereds.net>
	<AANLkTimqjBtVyB+xvtv5F5_qs333XiFQm+S=8Gh20+x2@mail.gmail.com>
	<20100921114049.75ab2ee8@corrin.poochiereds.net>
	<AANLkTikxqyK72=QcBPu1h-CmpiC+pg5AhVj=V4JRBqS-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikxqyK72=QcBPu1h-CmpiC+pg5AhVj=V4JRBqS--JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 21 Sep 2010 14:04:24 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> >
> > Right. I'm just not sure why we need a separate flag attached to the
> > server struct for this. Why was the "first_time" mechanism not good
> > enough here? I see no reason why that wouldn't have worked for NTLMSSP
> > too.
> 
> Jeff, I will investigate but at the first glance, it looks like
> first_ses is per smb session
> and not smb connection, not sure if that would be good enough for ntlmssp.
> 

first_time is set by is_first_ses_reconnect(). The comment on that
function says:

 * Checks if this is the first smb session to be reconnected after
 * the socket has been reestablished (so we know whether to use vc 0).
 * Called while holding the cifs_tcp_ses_lock, so do not block

...which isn't entirely true, since this works even when there hasn't
been a reconnect. It just walks the list of sessions on a socket and
sees if any of them are already established (that is, need_reconnect
is false).

So there is nominally a bug here -- sesInfoAlloc probably should set
needs_reconnect to true. But since cifs_get_smb_ses doesn't stick the
session on the server's list until after the session setup succeeds the
first time, it doesn't really cause any problems.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
