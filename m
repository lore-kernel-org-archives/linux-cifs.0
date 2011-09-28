From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Mounts to Windows 7 and "out of memory" or "insufficient server
 resources"
Date: Wed, 28 Sep 2011 08:06:22 -0400
Message-ID: <20110928080622.5e30429b@corrin.poochiereds.net>
References: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
	<4E82B4ED.4060107@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E82B4ED.4060107-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 28 Sep 2011 11:17:25 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> On 09/28/2011 03:06 AM, Steve French wrote:
> > FYI - The cifs async write in 3.0 seems to exacerbate problems running
> > out of memory (apparently) on the Windows 7 system (running as a
> > server) after a large file copy to the server completes.   I have been
> > able to reproduce the same problem on Windows Vista Service Pack 2
> > (which is a good news/bad news story since my earlier testing on
> > Windows Vista showed hangs on some requests rather than returning out
> > of memory).  Does not seem to be a problem with any of the Windows
> > server versions just Windows 7 and Vista so far.
> 
> The last time when I encountered this, cifs client was reporting "Cannot
> allocate memory" a.k.a -ENOMEM error. But, it is actually a
> NT_STATUS_INSUFF_SERVER_RESOURCES error from Server being mapped to
> -ENOMEM. I found this mapping confusing atleast initially. Is this
> mapping correct?
> 
> Not sure do we have a POSIX equivalent of
> NT_STATUS_INSUFF_SERVER_RESOURCES? Should we map it to a error code that
> is more obvious?
> 

Maybe -EREMOTEIO ?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
