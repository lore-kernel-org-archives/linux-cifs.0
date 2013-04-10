From: Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org>
Subject: Re: Cannot mount Canon Scanner CIFS share with cifs while
 smbclient works
Date: Wed, 10 Apr 2013 20:46:39 +0200
Message-ID: <20130410184639.GB31333@torres.zugschlus.de>
References: <20130408194049.GE10949@torres.zugschlus.de>
 <20130410090415.7e1c40b3@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130410090415.7e1c40b3-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Apr 10, 2013 at 09:04:15AM -0400, Jeff Layton wrote:
> In any case, a workaround for now might be to try and mount with
> sec=none. I *think* that will make the client do what smbclient is
> doing here.

I tried that, no change. Would another dump of a mount.cifs -o
sec=none help?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 31958061
Nordisch by Nature |  How to make an American Quilt | Fax: *49 621 31958062
