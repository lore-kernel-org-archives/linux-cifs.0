From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: file_mode, dir_mode ignored when unix extensions are negotiated?
Date: Fri, 03 Aug 2012 18:17:17 +0530
Message-ID: <501BC855.10405@suse.com>
References: <501679EF.7070507@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <501679EF.7070507-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(Sorry about the self-reply)

On 07/30/2012 05:41 PM, Suresh Jayaraman wrote:
> Do we ignore file_mode and dir_mode options when the unix extensions
> have been negotiated? On a 3.1 based kernel, I see file_mode, dir_mode
> options are not being honoured when mounting a Samba Server (Linux) with
> unix extensions enabled. So, the expected behavior is to get the mode
> from the server and not allow the client to override the modes?
> 
> This behavior looks different from the smbfs behavior. I couldn't
> recollect or find from mailing list threads why it has done to be this
> way. Could someone please enlighten me?
> 

http://lists.samba.org/archive/linux-cifs-client/2006-December/001627.html

>From this thread, the reason seems to be that we don't want to change
the behavior as there would be users who might want to use the
uid/gid/mode from the server when Unix Extensions are enabled.

So, I'd assume that the rationale remains the same unless someone tells
me that is wrong.


Thanks
Suresh
