From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: don't present the cifsFYI procfile when
 CONFIG_CIFS_DEBUG is disabled
Date: Sun, 23 Dec 2012 08:54:54 -0500
Message-ID: <20121223085454.5fd48bca@tlielax.poochiereds.net>
References: <1355831339-22043-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mssVLMr-knN4mBdbhKCV0_YvriUX3TKaGzp-vzLcNtyNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mssVLMr-knN4mBdbhKCV0_YvriUX3TKaGzp-vzLcNtyNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 20 Dec 2012 15:25:18 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> You make a good point that we need to adjust cifsFYI when CONFIG_CIFS_DEBUG
> is turned off by embedded distros to save memory but we can't remove it since it
> controls CIFS_RC and CIFS_TIMER messages (which we use for debugging,
> and should work even with CONFIG_CIFS_DEBUG is turned off - to allow
> us to see slow requests and get CIFS/SMB2 network errors logged).
> 
> I am fine with the idea of preventing enabling CIFS_INFO in
> /proc/fs/cifs/cifsFYI
> when CONFIG_CIFS_DEBUG is turned off (e.g. masking off the 0x0004 or
> rejecting it if the user tries to set that bit (to enable various informational
> messages which aren't going to print) when on an embedded system
> with debugging not compiled in).
> 

Fair enough. I'll drop this patch then.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
