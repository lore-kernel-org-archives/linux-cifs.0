From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Mounts to Windows 7 and "out of memory" or "insufficient server
 resources"
Date: Wed, 28 Sep 2011 08:00:27 -0400
Message-ID: <20110928080027.2c04b12d@corrin.poochiereds.net>
References: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 27 Sep 2011 16:36:22 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> FYI - The cifs async write in 3.0 seems to exacerbate problems running
> out of memory (apparently) on the Windows 7 system (running as a
> server) after a large file copy to the server completes.   I have been
> able to reproduce the same problem on Windows Vista Service Pack 2
> (which is a good news/bad news story since my earlier testing on
> Windows Vista showed hangs on some requests rather than returning out
> of memory).  Does not seem to be a problem with any of the Windows
> server versions just Windows 7 and Vista so far.
> 
> As Pavel noted in an earlier note, increasing MaxWorkItems to 4096 in
> the Windows registry solves this.
> 
> The cifs async write code does increase large file copy speed
> dramatically (more than 15% in most environments) - but we are working
> through how to handle the Windows7/WindowsVista problem to see if
> there are workarounds.
> 

This is seems likely to be a cifs.ko bug -- it does not respect the
MaxReq parm that the server sends in the negotiate and instead uses a
hardcoded limit of 50 requests (which is tunable via module parm).

What value is the server sending in the NEGOTIATE? Ensuring that
cifs.ko doesn't exceed that value seems like a worthwhile endeavor.
This is likely to be even worse soon when the async read patches are
merged.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
