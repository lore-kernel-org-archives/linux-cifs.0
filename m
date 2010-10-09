From: Valerie Aurora <vaurora-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/17] Make follow_down() handle d_manage()
Date: Fri, 8 Oct 2010 20:28:31 -0400
Message-ID: <20101009002831.GG30846@shell>
References: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk> <20100930181536.30939.6776.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	autofs-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100930181536.30939.6776.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 30, 2010 at 07:15:36PM +0100, David Howells wrote:
>  }
>  
>  /*
> + * Follow down to the topmost point on a stack of mountpoints.  At each point,

"Follow down to the topmost" -> "Follow down to covering mount" ?

-VAL
