From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: linux-next: manual merge of the workqueues tree with the Linus'
 tree
Date: Fri, 23 Jul 2010 13:34:55 +0200
Message-ID: <4C497E5F.80301@kernel.org>
References: <20100723144600.dd4da992.sfr@canb.auug.org.au>	<4C497CD5.5010908@kernel.org> <20100723213148.3d2193a3.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100723213148.3d2193a3.sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

On 07/23/2010 01:31 PM, Stephen Rothwell wrote:
>> Yes, one failure case is removed, so that would be correct.
> 
> Thanks for the confirmation.  This should probably be fixed in the
> workqueues tree before it is merged upstream.

I was thinking about sending pull request w/ a note describing how to
resolve the conflict.  Would pulling in master before requesting pull
be better?

Thanks.

-- 
tejun
